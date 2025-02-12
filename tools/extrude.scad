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

  \param    s <decimal-list-2 | decimal> The start and end scale factor.
            A list [s1, s2] of decimals or a single decimal for (s1=s2)
  \param    m <integer> The facet number mode (either \b 0 or \b 1).
            With \p m = \b 1, fewer scaled-steps are generated during
            the revolution.

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

  s,
  m = 0
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

    sn = (m == 0) ? ceil(get_fn(r) * ra/360)
                  : ceil(sqrt(get_fn(r) * ra/360));

    sa = ra/sn;         // section angle
    ss = (s2-s1)/sn;    // uniform section scale
    so = 360*eps;       // section overlap

    for (f=[0:sn-1])
    rotate(sa * f - so/2)
    rotate_extrude(angle = sa + so)
    translate([r, 0])
    scale(s1 + ss * f)
    rotate([0, 0, pa])
    children();
  }
}

//! Translate, rotate, and revolve a 2d shape about the z-axis with linear elongation.
/***************************************************************************//**
  \copydetails extrude_rotate_tr()

  \param    l <decimal-list-2 | decimal> The elongation length.
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

//! Linearly extrude a 2d shape with uniformly-spaced profile scaling.
/***************************************************************************//**
  \param    h <datastruct | decimal> A data structure or a single decimal.
  \param    center <boolean> Center extrusion about origin.
  \param    c <boolean> conditional.
  \param    ha <decimal> An extrusion height adjustment value.

  \details

    When \p c is \b true, apply the transformation to the children
    objects, otherwise return the children unmodified.

    <b>Data structure syntax</b>

     h[n] | type              | description
    :----:|:-----------------:|:---------------------------------------
      0   | <decimal>         | total extrusion height
      1   | <decimal-list-n>  | list of one or more scale factors

    Each scale factor can be either a single decimal or a list of two
    decimals to scale \b x and \b y independently. When the scale
    factor is a single decimal, both dimensions are scaled equally.

    When \p h is a decimal, or a list with a single decimal, the shape
    is linearly extruded to the height specified by the decimal value
    without scaling. When \p h is a list, the first element of \p h
    specifies the extrusion height and the second element of \p h
    specifies the scale factor, or scale factors in the case that the
    second element is a list, When s list of scaling factors is
    specified, the scale factors are applied sequentially with uniform
    spacing along the linear extrusion height.

    \note The parameter \p ha may be used to add (small) values to the
    extrusion height to construct overlapping shapes when multiple
    extrusions are stacked.

    \amu_eval ( object=extrude_linear_uss ${object_ex_diagram_3d} )
*******************************************************************************/
module extrude_linear_uss
(
  h,
  center = false,
  c = true,
  ha = 0
)
{
  if ( is_undef(h) || (c == false) )
  {
    children();
  }
  else if ( is_scalar(h) )
  {
    linear_extrude(height=h + ha, center=center)
    children();
  }
  else
  {
    ht = defined_e_or(h, 0, 1) + ha;  // section height
    ss = defined_e_or(h, 1, 1);       // section scale steps

    su = is_list(ss) ? ss : [ss];     // make sure 'ss' is a list

    // handle single scale section case
    sv = (len(su) == 1) ? concat(su, su) : su;

    sn = len(sv);       // section count
    sz = ht/(sn-1);     // uniform section size
    so = eps;           // section overlap

    translate(center==true ? [0, 0, -ht/2] : origin3d)
    for (f=[0:sn-2])
    {
      cl = is_list(sv[f]);
      nl = is_list(sv[f+1]);

      // handle one, two, and mixed-dimensional scaling
      es =  cl &&  nl ? [first(sv[f+1])/first(sv[f]), second(sv[f+1])/second(sv[f])]
         : !cl &&  nl ? [first(sv[f+1])/      sv[f] , second(sv[f+1])/       sv[f] ]
         :              sv[f+1]/sv[f];

      translate([0, 0, sz * f - so/2])
      linear_extrude(height=sz + so, scale=es)
      scale(sv[f])
      children();
    }
  }
}

//! Linearly extrude a 2d shape with multi-segment uniformly-spaced profile scaling.
/***************************************************************************//**
  \param    h <datastruct-list-n | decimal> A data structure or a single decimal.
  \param    center <boolean> Center extrusion about origin.
  \param    c <boolean> conditional.

  \details

    When \p c is \b true, apply the transformation to the children
    objects, otherwise return the children unmodified.

    <b>Data structure syntax</b>

    The scaled extrusion can be divided across as many segments \em (n)
    as desired with each being specified by a data structure using the
    syntax of the function extrude_linear_uss(). Scaling for multiple
    segments are placed in a list and each segment is processed
    sequentially, in the listed order, until all \em n-segments have
    been linearly extruded and stacked.

    \note As with extrude_linear_uss(), each scale factor can be either
    a single decimal or a list of two decimals to scale \b x and \b y
    independently. When the scale factor is a single decimal, both
    dimensions are scaled equally.

    \amu_eval ( object=extrude_linear_mss ${object_ex_diagram_3d} )
*******************************************************************************/
module extrude_linear_mss
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
    linear_extrude(height=h, center=center)
    children();
  }
  else
  {
    // calculate total height of all sections
    hv = [for (e=h) is_list(e) ? first(e) : e];
    ht = sum( hv );

    sn = len(hv);       // section count
    so = eps;           // section overlap

    translate(center==true ? [0, 0, -ht/2] : origin3d)
    for (f=[0:sn-1])
    {
      // calculate total height of prior sections
      tv = (f == 0) ? [0] : [ for (g=[0:f-1]) is_list(h[g]) ? first(h[g]) : h[g] ];
      tt = sum( tv );

      // extrude current section
      translate([0, 0, tt - so/2])
      extrude_linear_uss(h=h[f], ha=so, center=false)
      children();
    }
  }
}

//! Return the total extrusion height for extrude_linear_mss().
/***************************************************************************//**
  \param    h <datastruct-list-n | decimal> A data structure or a single decimal.
  \param    s <boolean> return segment heights.

  \details

    For a given extrusion performed by extrude_linear_mss(), this
    function returns the resulting total extrusion height, as a single
    sum, or as a vector of the individual segment heights.
*******************************************************************************/
function extrude_linear_mss_eht
(
  h,
  s = false
) = let
    (
      v  = is_defined(h) ? [for (e=h) is_list(e) ? first(e) : e] : [0],
      t = sum(v)
    )
    (s == true) ? v : sum(v);

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
      extrude_rotate_trs( r=50, pa=45, ra=180, s=[1, 3] ) circle( 5 );
    else if (shape == "extrude_rotate_trl")
      extrude_rotate_trl( r=25, l=[5, 50], pa=45, m=31 ) square( [10,5], center=true );
    else if (shape == "extrude_linear_uss")
      extrude_linear_uss( [10, [1,1/2,[1,1/2],[1/4,1/2]]], center=true) circle( d=10 );
    else if (shape == "extrude_linear_mss")
      extrude_linear_mss( h=[[10, [1.25, 1]], 20, [35, [for (i=[90:-1:10]) sin(i)]]], center=true) circle(15);
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;

    views     name "views" views "diag";
    defines   name "shapes" define "shape"
              strings "
                extrude_rotate_tr
                extrude_rotate_trs
                extrude_rotate_trl
                extrude_linear_uss
                extrude_linear_mss
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
