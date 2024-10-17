//! Basic 2D shapes.
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

    \amu_define group_name  (Basic 2d)
    \amu_define group_brief (Basic 2D shape.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group and macros.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_include (include/amu/includes_required.amu)

  \amu_define image_view (top)

  \amu_define group_id (${parent})
  \amu_include (include/amu/scope_diagrams_3d_in_group.amu)

  \amu_define group_id (${group})
  \amu_include (include/amu/scope_diagrams_3d_in_group.amu)

  \amu_include (include/amu/scope_diagram_3d_object.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//! A rectangle with corner rounds or chamfers.
/***************************************************************************//**
  \param    size <decimal-list-2 | decimal> A list [x, y] of decimals
            or a single decimal for (x=y).

  \param    vr <decimal-list-4 | decimal> The corner rounding radius.
            A list [v1r, v2r, v3r, v4r] of decimals or a single decimal
            for (v1r=v2r=v3r=v4r). Unspecified corners are not rounded.

  \param    vrm <integer> The corner radius mode.
            A 4-bit encoded integer that indicates each corner finish.
            Use bit value \b 0 for \em round and \b 1 for \em chamfer.

  \param    center <boolean> Center about origin.

  \details

    \amu_eval ( object=rectangle ${object_ex_diagram_3d} )

    Corner \em round is of constant radius \p vr. A corner \em chamfer
    replaces the last \p vr length of the corners edge with an
    isosceles right triangle with a chamfer length of (vr * sqrt(2))
    cut at 45 degrees.
*******************************************************************************/
module rectangle
(
  size,
  vr,
  vrm = 0,
  center = false
)
{
  rx = defined_e_or(size, 0, size);
  ry = defined_e_or(size, 1, rx);

  translate(center==true ? [-rx/2, -ry/2] : origin2d)
  {
    if ( is_undef(vr) )                 // no rounding
    {
      square([rx, ry]);
    }
    else if ( is_scalar(vr) )           // equal rounding
    {
      for ( i =  [ [0, 0,  1, 0,  1,   0],
                   [1, 1, -1, 0,  1,  90],
                   [2, 1, -1, 1, -1, 180],
                   [3, 0,  1, 1, -1, 270] ] )
      {
        translate([rx*i[1] + vr * i[2], ry*i[3] + vr * i[4]])
        if ( binary_bit_is(vrm, i[0], 0) )
        {
          circle(r=vr);
        }
        else
        {
          rotate([0, 0, i[5]])
          polygon(points=[[eps,-vr], [eps,eps], [-vr,eps]], paths=[[0,1,2]]);
        }
      }

      translate([0, vr])
      square([rx, ry] - [0, vr*2]);

      translate([vr, 0])
      square([rx, ry] - [vr*2, 0]);
    }
    else                                // individual rounding
    {
      crv = [ defined_e_or(vr, 0, 0),
              defined_e_or(vr, 1, 0),
              defined_e_or(vr, 2, 0),
              defined_e_or(vr, 3, 0) ];

      for ( i =  [ [0, 0,  1, 0,  1],
                   [1, 1, -1, 0,  1],
                   [2, 1, -1, 1, -1],
                   [3, 0,  1, 1, -1] ] )
      {
        if ( (crv[i[0]] > 0) && binary_bit_is(vrm, i[0], 0) )
        {
         translate([rx*i[1] + crv[i[0]] * i[2], ry*i[3] + crv[i[0]] * i[4]])
         circle(r=crv[i[0]]);
        }
      }

      ppv =
      [
        for
        (
          i = [
                [0,  0,  0,  0,  1],
                [0,  0,  1,  0,  0],
                [1,  1, -1,  0,  0],
                [1,  1,  0,  0,  1],
                [2,  1,  0,  1, -1],
                [2,  1, -1,  1,  0],
                [3,  0,  1,  1,  0],
                [3,  0,  0,  1, -1]
              ]
        )
          [rx*i[1] + crv[i[0]] * i[2], ry*i[3] + crv[i[0]] * i[4]]
      ];

      polygon( points=ppv, paths=[ [0,1,2,3,4,5,6,7] ] );
    }
  }
}

//! A rectangle with a removed rectangular core.
/***************************************************************************//**
  \param    size <decimal-list-2 | decimal> A list [x, y] of decimals
            or a single decimal for (x=y).
  \param    core <decimal-list-2 | decimal> A list [x, y] of decimals
            or a single decimal for (x=y).

  \param    t <decimal-list-2 | decimal> A list [x, y] of decimals
            or a single decimal for (x=y).

  \param    co <decimal-list-2> Core offset. A list [x, y] of decimals.
  \param    cr <decimal> Core z-rotation.

  \param    vr <decimal-list-4 | decimal> The default corner rounding radius.
            A list [v1r, v2r, v3r, v4r] of decimals or a single decimal
            for (v1r=v2r=v3r=v4r). Unspecified corners are not rounded.
  \param    vr1 <decimal-list-4 | decimal> The outer corner rounding radius.
  \param    vr2 <decimal-list-4 | decimal> The core corner rounding radius.

  \param    vrm <integer> The default corner radius mode.
            A 4-bit encoded integer that indicates each corner finish.
            Use bit value \b 0 for \em round and \b 1 for \em chamfer.
  \param    vrm1 <integer> The outer corner radius mode.
  \param    vrm2 <integer> The core corner radius mode.

  \param    center <boolean> Center about origin.

  \details

    Thickness \p t
    \li <tt>core = size - t</tt>; when \p t and \p size are given.
    \li <tt>size = core + t</tt>; when \p t and \p core are given.

    \amu_eval ( object=rectangle_c ${object_ex_diagram_3d} )
*******************************************************************************/
module rectangle_c
(
  size,
  core,
  t,
  co,
  cr = 0,
  vr,
  vr1,
  vr2,
  vrm = 0,
  vrm1,
  vrm2,
  center = false
)
{
  od = all_defined([t, core]) ? (core + t*2) : size;
  id = all_defined([t, size]) ? (size - t*2) : core;

  rx = defined_e_or(od, 0, od);
  ry = defined_e_or(od, 1, od);

  or = defined_or(vr1, vr);
  ir = defined_or(vr2, vr);

  om = defined_or(vrm1, vrm);
  im = defined_or(vrm2, vrm);

  if ( is_defined(id) )
  {
    translate(center==true ? origin2d : [rx/2, ry/2])
    difference()
    {
      rectangle(size=od, vr=or, vrm=om, center=true);

      translate(is_defined(co) ? co : origin2d)
      rotate([0, 0, cr])
      rectangle(size=id, vr=ir, vrm=im, center=true);
    }
  }
  else
  {
    rectangle(size=od, vr=or, vrm=om, center=center);
  }
}

//! A rhombus.
/***************************************************************************//**
  \param    size <decimal-list-2 | decimal> A list [w, h] of decimals
            or a single decimal for (w=h).

  \param    vr <decimal-list-4 | decimal> The corner rounding radius.
            A list [v1r, v2r, v3r, v4r] of decimals or a single decimal
            for (v1r=v2r=v3r=v4r). Unspecified corners are not rounded.

  \param    center <boolean> Center about origin.

  \details

    \amu_eval ( object=rhombus ${object_ex_diagram_3d} )

    See [Wikipedia] for more information.

  [Wikipedia]: https://en.wikipedia.org/wiki/Rhombus
*******************************************************************************/
module rhombus
(
  size,
  vr,
  center = false
)
{
  rx = defined_e_or(size, 0, size) / 2;
  ry = defined_e_or(size, 1, rx*2) / 2;

  translate(center==true ? origin2d : [rx, ry])
  {
    if ( is_undef(vr) )              // no rounding
    {
      polygon
      (
        points=[ [rx,0], [0,ry], [-rx,0], [0,-ry] ],
        paths=[ [0,1,2,3] ]
      );
    }
    else                                // individual rounding
    {
      erc = is_scalar(vr) ? vr : 0;     // equal rounding

      crv = [ defined_e_or(vr, 0, erc),
              defined_e_or(vr, 1, erc),
              defined_e_or(vr, 2, erc),
              defined_e_or(vr, 3, erc) ];

      a1 = angle_ll([[rx,0], [0,ry]], [[rx,0], [0,-ry]]) / 2;
      a2 = 90 - a1;

      for ( i = [ [0,  1, -1,  0,  0],
                  [1,  0,  0,  1, -1],
                  [2, -1,  1,  0,  0],
                  [3,  0,  0, -1,  1] ] )
      {
        translate
        (
          [ rx*i[1] + crv[i[0]]/sin(a1) * i[2], ry*i[3] + crv[i[0]]/sin(a2) * i[4] ]
        )
        circle (r=crv[i[0]]);
      }

      ppv =
      [
        for
        (
          i = [
                [0,  0,  1, -1,  0, -1],
                [0,  0,  1, -1,  0,  1],
                [1,  1,  0,  1,  1, -1],
                [1,  1,  0, -1,  1, -1],
                [2,  0, -1,  1,  0,  1],
                [2,  0, -1,  1,  0, -1],
                [3,  1,  0, -1, -1,  1],
                [3,  1,  0, +1, -1, +1]
              ]
        )
          ( i[1] == 0 )
          ? [
              rx*i[2] + crv[i[0]] * (1/sin(a1)-sin(a1)) * i[3],
              ry*i[4] + crv[i[0]] * cos(a1) * i[5]
            ]
          : [
              rx*i[2] + crv[i[0]] * cos(a2) * i[3],
              ry*i[4] + crv[i[0]] * (1/sin(a2)-sin(a2)) * i[5]
            ]
      ];

      polygon( points=ppv, paths=[ [0,1,2,3,4,5,6,7] ] );
    }
  }
}

//! An n-sided equiangular/equilateral regular polygon.
/***************************************************************************//**
  \param    n <integer> The number of sides.
  \param    r <decimal> The ngon vertex radius.

  \param    vr <decimal> The vertex rounding radius.

  \details

    \amu_eval ( object=ngon ${object_ex_diagram_3d} )

    See [Wikipedia] for more information.

  [Wikipedia]: https://en.wikipedia.org/wiki/Regular_polygon
*******************************************************************************/
module ngon
(
  n,
  r,
  vr
)
{
  if ( is_undef(vr) )
  {
    circle(r=r, $fn=n);
  }
  else
  {
    hull()
    {
      for ( c = polygon_regular_p( r=r, n=n, vr=vr ) )
      {
        translate( c )
        circle( r=vr );
      }
    }
  }
}

//! An ellipse.
/***************************************************************************//**
  \param    size <decimal-list-2 | decimal> A list [rx, ry] of decimals
            or a single decimal for (rx=ry).

  \details

    \amu_eval ( object=ellipse ${object_ex_diagram_3d} )
*******************************************************************************/
module ellipse
(
  size
)
{
  rx = defined_e_or(size, 0, size);
  ry = defined_e_or(size, 1, rx);

  if ( rx == ry )
  {
    circle(r=rx);
  }
  else
  {
    scale([1, ry/rx])
    circle(r=rx);
  }
}

//! An ellipse with a removed elliptical core.
/***************************************************************************//**
  \param    size <decimal-list-2 | decimal> A list [rx, ry] of decimals
            or a single decimal for (rx=ry).
  \param    core <decimal-list-2 | decimal> A list [rx, ry] of decimals
            or a single decimal for (rx=ry).

  \param    t <decimal-list-2 | decimal> A list [x, y] of decimals
            or a single decimal for (x=y).

  \param    co <decimal-list-2> Core offset. A list [x, y] of decimals.
  \param    cr <decimal> Core z-rotation.

  \details

    Thickness \p t
    \li <tt>core = size - t</tt>; when \p t and \p size are given.
    \li <tt>size = core + t</tt>; when \p t and \p core are given.

    \amu_eval ( object=ellipse_c ${object_ex_diagram_3d} )
*******************************************************************************/
module ellipse_c
(
  size,
  core,
  t,
  co,
  cr = 0
)
{
  od = all_defined([t, core]) ? (core + t) : size;
  id = all_defined([t, size]) ? (size - t) : core;

  if ( is_defined(id) )
  {
    difference()
    {
      ellipse(size=od);

      translate(is_defined(co) ? co : origin2d)
      rotate([0, 0, cr])
      ellipse(size=id);
    }
  }
  else
  {
    ellipse(size=od);
  }
}

//! An ellipse sector.
/***************************************************************************//**
  \param    size <decimal-list-2 | decimal> A list [rx, ry] of decimals
            or a single decimal for (rx=ry).

  \param    a1 <decimal> The start angle in degrees.
  \param    a2 <decimal> The stop angle in degrees.

  \details

    \amu_eval ( object=ellipse_s ${object_ex_diagram_3d} )
*******************************************************************************/
module ellipse_s
(
  size,
  a1 = 0,
  a2 = 0
)
{
  rx = defined_e_or(size, 0, size);
  ry = defined_e_or(size, 1, rx);

  trx = rx * sqrt(2) + 1;
  try = ry * sqrt(2) + 1;

  pa0 = (4 * a1 + 0 * a2) / 4;
  pa1 = (3 * a1 + 1 * a2) / 4;
  pa2 = (2 * a1 + 2 * a2) / 4;
  pa3 = (1 * a1 + 3 * a2) / 4;
  pa4 = (0 * a1 + 4 * a2) / 4;

  if (a2 > a1)
  {
    intersection()
    {
      ellipse(size);

      polygon
      ([
        origin2d,
        [trx * cos(pa0), try * sin(pa0)],
        [trx * cos(pa1), try * sin(pa1)],
        [trx * cos(pa2), try * sin(pa2)],
        [trx * cos(pa3), try * sin(pa3)],
        [trx * cos(pa4), try * sin(pa4)],
        origin2d
      ]);
    }
  }
  else
  {
    ellipse(size);
  }
}

//! A sector of an ellipse with a removed elliptical core.
/***************************************************************************//**
  \param    size <decimal-list-2 | decimal> A list [rx, ry] of decimals
            or a single decimal for (rx=ry).
  \param    core <decimal-list-2 | decimal> A list [rx, ry] of decimals
            or a single decimal for (rx=ry).

  \param    t <decimal-list-2 | decimal> A list [x, y] of decimals
            or a single decimal for (x=y).

  \param    a1 <decimal> The start angle in degrees.
  \param    a2 <decimal> The stop angle in degrees.

  \param    co <decimal-list-2> Core offset. A list [x, y] of decimals.
  \param    cr <decimal> Core z-rotation.

  \details

    Thickness \p t
    \li <tt>core = size - t</tt>; when \p t and \p size are given.
    \li <tt>size = core + t</tt>; when \p t and \p core are given.

    \amu_eval ( object=ellipse_cs ${object_ex_diagram_3d} )
*******************************************************************************/
module ellipse_cs
(
  size,
  core,
  t,
  a1 = 0,
  a2 = 0,
  co,
  cr = 0
)
{
  od = all_defined([t, core]) ? (core + t) : size;
  id = all_defined([t, size]) ? (size - t) : core;

  if ( is_defined(id) )
  {
    difference()
    {
      ellipse_s(a1=a1, a2=a2, size=od);

      translate(is_defined(co) ? co : origin2d)
      rotate([0, 0, cr])
      ellipse(size=id);
    }
  }
  else
  {
    ellipse_s(a1=a1, a2=a2, size=od);
  }
}

//! A two-dimensional star.
/***************************************************************************//**
  \param    size <decimal-list-2 | decimal> A list [l, w] of decimals
            or a single decimal for (size=l=2*w).

  \param    n <decimal> The number of points.

  \param    vr <decimal-list-3 | decimal> The vertex rounding radius.
            A list [v1r, v2r, v3r] of decimals or a single decimal for
            (v1r=v2r=v3r).

  \details

    \amu_eval ( object=star2d ${object_ex_diagram_3d} )
*******************************************************************************/
module star2d
(
  size,
  n = 5,
  vr
)
{
  l = defined_e_or(size, 0, size);
  w = defined_e_or(size, 1, l/2);

  t = triangle2d_sss2ppp([l, w, l]);
  p = is_undef(vr) ? t : polygon_round_eve_all_p(c=t, vr=vr);

  repeat_radial(n=n, angle=true, move=false)
  rotate([0, 0, -90])
  translate([-w/2, 0])
  polygon(p);
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

    shape = "ellipse_cs";
    $fn = 36;

    if (shape == "rectangle")
      rectangle( size=[25,40], vr=[0,10,10,5], vrm=4, center=true );
    else if (shape == "rectangle_c")
      rectangle_c( size=[40,25], t=[15,5], vr1=[0,0,10,10], vr2=2.5, vrm2=3, co=[0,5], center=true );
    else if (shape == "rhombus")
      rhombus( size=[40,25], vr=[2,4,2,4], center=true );
    else if (shape == "ngon")
      ngon( n=6, r=25, vr=6 );
    else if (shape == "ellipse")
      ellipse( size=[25, 40] );
    else if (shape == "ellipse_c")
      ellipse_c( size=[25,40], core=[16,10], co=[0,10], cr=45 );
    else if (shape == "ellipse_s")
      ellipse_s( size=[25,40], a1=90, a2=180 );
    else if (shape == "ellipse_cs")
      ellipse_cs( size=[25,40], t=[10,5], a1=90, a2=180, co=[10,0], cr=45);
    else if (shape == "star2d")
      star2d( size=[40, 15], n=5, vr=2 );
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;

    views     name "views" views "top";
    defines   name "shapes" define "shape"
              strings "
                rectangle
                rectangle_c
                rhombus
                ngon
                ellipse
                ellipse_c
                ellipse_s
                ellipse_cs
                star2d
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
