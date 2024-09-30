//! Shape extrusion tools.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2015-2023

  \copyright

    This file is part of [omdl] (https://github.com/royasutton/omdl),
    an OpenSCAD mechanical design library.

    The \em omdl is free software; you can redistribute it and/or modify
    it under the terms of the [GNU Lesser General Public License]
    (http://www.gnu.org/licenses/lgpl.html) as published by the Free
    Software Foundation; either version 2.1 of the License, or (at
    your option) any later version.

    The \em omdl is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with the \em omdl; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
    02110-1301, USA; or see <http://www.gnu.org/licenses/>.

  \details

    \amu_define group_name  (Extrude)
    \amu_define group_brief (Shape extrusion tools.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group and macros.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_include (include/amu/includes_required.amu)

  \amu_define image_view (diag)

  \amu_define group_id (${parent})
  \amu_include (include/amu/scope_diagrams_3d_in_group.amu)

  \amu_define group_id (${group})
  \amu_include (include/amu/scope_diagrams_3d_in_group.amu)

  \amu_include (include/amu/scope_diagram_3d_object.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//! Translate, rotate, and revolve a 2d shape about the z-axis.
/***************************************************************************//**
  \param    r <decimal> The rotation radius.
  \param    pa <decimal> The profile pitch angle in degrees.
  \param    ra <decimal> The rotation sweep angle in degrees.

  \details

    \amu_eval ( object=extrude_rotate_tr ${object_ex_diagram_3d} )
*******************************************************************************/
module extrude_rotate_tr
(
  r,
  pa = 0,
  ra = 360
)
{
  rotate_extrude(angle = ra)
  translate([r, 0])
  rotate([0, 0, pa])
  children();
}

//! Translate, rotate, scale, and revolve a 2d shape about the z-axis.
/***************************************************************************//**
  \copydetails extrude_rotate_tr()

  \param    s <decimal-list-2|decimal> The start and end scale factor.
            A list [s1, s2] of decimals or a single decimal for (s1=s2)

  \details

    When the parameter \p s is not specified, the shape profile is
    revolved using extrude_rotate_tr(). When the parameter \p s is
    specified, the shape profile is scaled from \p s1 to \p s2 along
    the revolution path.

    \amu_eval ( object=extrude_rotate_trs ${object_ex_diagram_3d} )
*******************************************************************************/
module extrude_rotate_trs
(
  r,
  pa = 0,
  ra = 360,

  s
)
{
  if ( is_undef(s) )
  {
    extrude_rotate_tr(r=r, pa=pa, ra=ra)
    children();
  }
  else
  {
    sd = is_scalar(s) ? s : 1;
    s1 = defined_e_or(s, 0, sd);
    s2 = defined_e_or(s, 1, sd);

    facets = ceil(sqrt(openscad_fn(r)));

    facet_sa = ra/facets;
    facet_ss = (s2-s1)/facets;

    for (f=[0:facets-1])
    rotate(facet_sa * f - 180*eps)                // prior facet overlap
    rotate_extrude(angle = facet_sa + 380*eps)    // prior + next overlap
    translate([r, 0])
    scale(s1 + facet_ss * f)
    rotate([0, 0, pa])
    children();
  }
}

//! Translate, rotate, and revolve a 2d shape about the z-axis with linear elongation.
/***************************************************************************//**
  \copydetails extrude_rotate_tr()

  \param    l <decimal-list-2|decimal> The elongation length.
            A list [x, y] of decimals or a single decimal for (x=y)
  \param    m <integer> The section render mode. An 8-bit encoded integer
            that indicates the revolution sections to render.
            Bit values \b 1 enables the corresponding section and bit values
            \b 0 are disabled. Sections are assigned to the bit position in
            counter-clockwise order.

  \details

    When the parameter \p l is not specified, the shape profile is
    revolved using extrude_rotate_tr(). When the parameter \p l is
    specified, the shape profile may be linearly extruded along the the
    \em x-axis and \em y-axis, with the linear extrusion lengths
    specified by \p l, and is revolved 90 degrees to transition between
    the axes. In this mode, the parameter \p ra is defined to be 90 for
    all corners and the parameter \p m controls which of the eight path
    sections to render during the 360 degree revolution.

    \amu_eval ( object=extrude_rotate_trl ${object_ex_diagram_3d} )
*******************************************************************************/
module extrude_rotate_trl
(
  r,
  pa = 0,
  ra = 360,

  l,
  m = 255
)
{
  if ( is_undef(l) )
  {
    extrude_rotate_tr(r=r, pa=pa, ra=ra)
    children();
  }
  else
  {
    ld = is_scalar(l) ? l : 0;
    lx = defined_e_or(l, 0, ld);
    ly = defined_e_or(l, 1, ld);

    // corner rotation
    for
    (
      i = [
             [+lx/2, +ly/2,   0, 1],
             [-lx/2, +ly/2,  90, 3],
             [-lx/2, -ly/2, 180, 5],
             [+lx/2, -ly/2, 270, 7]
          ]
    )
    if ( binary_bit_is(m, i[3], 1) )
    {
      translate([i[0], i[1], 0])
      rotate([0, 0, i[2]])
      extrude_rotate_tr(r=r, pa=pa, ra=90)
      children();
    }

    // linear extrusion
    for
    (
      i = [
            [ +r +lx/2,    +ly/2,   0, ly, 0],
            [    -lx/2, +r +ly/2,  90, lx, 2],
            [ -r -lx/2,    -ly/2, 180, ly, 4],
            [     lx/2, -r -ly/2, 270, lx, 6]
          ]
    )
    if ( binary_bit_is(m, i[4], 1) )
    {
      translate([i[0], i[1], 0])
      rotate([90, 0, i[2]])
      translate([0, 0, -eps])
      linear_extrude(height=i[3] + eps*2)
      rotate([0, 0, pa])
      children();
    }
  }
}

//! Linearly extrude a 2d shape with upper and lower scaling.
/***************************************************************************//**
  \param    h <decimal-list-3:9|decimal> A list of decimals or a single
            decimal.
  \param    center <boolean> Center extrusion about origin.
  \param    c <boolean> conditional.

  \details

    When \p c is \b true, apply the transformation to the children
    objects, otherwise return the children unmodified. When \p h is a
    decimal, the shape is extruded linearly as normal. To scale the
    upper and lower slices of the extrusion, \p h must be a list with a
    minimum of three decimal values as described in the following
    table. For symmetrical scaling, shape must be centered about
    origin.

     h[n] | default | description
    :----:|:-------:|:---------------------------------------
      0   |         | total extrusion height
      1   |         | (+z) number of scaled extrusion slices
      2   |         | (+z) extrusion scale percentage
      3   | -h[2]   | (+z) x-dimension scale percentage
      4   |  h[3]   | (+z) y-dimension scale percentage
      5   |  h[1]   | (-z) number of scaled extrusion slices
      6   |  h[2]   | (-z) extrusion scale percentage
      7   |  h[3]   | (-z) x-dimension scale percentage
      8   |  h[4]   | (-z) y-dimension scale percentage

  \details

    \amu_eval ( object=extrude_linear_uls ${object_ex_diagram_3d} )

  \todo This function should be rewritten to use the built-in scaling
        provided by linear_extrude() in the upper and lower scaling zones.
*******************************************************************************/
module extrude_linear_uls
(
  h,
  center = false,
  c = true
)
{
  if ( is_undef(h) || (c == false) )
  {
    children();
  }
  else if ( is_scalar(h) )
  {
    translate(center==true ? [0, 0, -h/2] : origin3d)
    linear_extrude(height=h)
    children();
  }
  else
  {
    z = h[0];                                   // total height

    n1 = (len(h) >= 3) ? max(h[1], 0)  : 0;     // number of scaled-slices
    z1 = (len(h) >= 3) ? abs(h[2])/100 : 0;     // z scale fraction
    x1 = (len(h) >= 4) ?     h[3] /100 : -z1;   // x scale fraction
    y1 = (len(h) >= 5) ?     h[4] /100 : x1;    // y scale fraction

    n2 = (len(h) >= 6) ? max(h[5], 0)  : n1;
    z2 = (len(h) >= 7) ? abs(h[6])/100 : z1;
    x2 = (len(h) >= 8) ?     h[7] /100 : x1;
    y2 = (len(h) >= 9) ?     h[8] /100 : y1;

    h1 = (n1>0) ? z1 * z : 0;
    h2 = (n2>0) ? z2 * z : 0;
    h0 = z - h1 - h2;

    translate(center==true ? [0, 0, -z/2] : origin3d)
    {
      if (h1 > 0)
      {
        translate([0, 0, h0+h2])
        for( s = [0 : n1-1] )
        {
          translate([0, 0, h1/n1*s])
          scale([1+x1/n1*(s+1), 1+y1/n1*(s+1), 1])
          linear_extrude(height=h1/n1)
          children();
        }
      }

      translate([0, 0, h2])
      linear_extrude(height=h0)
      children();

      if (h2 > 0)
      {
        for( s = [0 : n2-1] )
        {
          translate([0, 0, h2/n2*s])
          scale([1+x2/n2*(n2-s), 1+y2/n2*(n2-s), 1])
          linear_extrude(height=h2/n2)
          children();
        }
      }
    }
  }
}

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE diagram;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;

    shape = "extrude_rotate_tr";
    $fn = 36;

    if (shape == "extrude_rotate_tr")
      extrude_rotate_tr( r=50, pa=45, ra=270 ) square( [10,5], center=true );
    if (shape == "extrude_rotate_trs")
      extrude_rotate_trs( r=50, pa=45, ra=180, s=[1, 3] ) circle( 5, center=true );
    else if (shape == "extrude_rotate_trl")
      extrude_rotate_trl( r=25, l=[5, 50], pa=45, m=31 ) square( [10,5], center=true );
    else if (shape == "extrude_linear_uls")
      extrude_linear_uls( [5,10,15,-5], center=true ) square( [20,15], center=true );
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;

    views     name "views" views "diag";
    defines   name "shapes" define "shape"
              strings "
                extrude_rotate_tr
                extrude_rotate_trs
                extrude_rotate_trl
                extrude_linear_uls
              ";
    variables add_opts_combine "views shapes";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
