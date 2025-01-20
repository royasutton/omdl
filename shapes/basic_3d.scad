//! Basic 3D shapes.
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

    \amu_define group_name  (Basic 3d)
    \amu_define group_brief (Basic 3D shapes.)

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

//! A cone.
/***************************************************************************//**
  \param    r <decimal> The base radius.
  \param    h <decimal> The height.

  \param    d <decimal> The base diameter.

  \param    vr <decimal-list-2 | decimal> A list [rb, rp] of decimals or
            a single decimal for (rb=rp]. The corner rounding radius.

  \details

    \amu_eval ( object=cone ${object_ex_diagram_3d} )
*******************************************************************************/
module cone
(
  r = 1,
  h,
  d,
  vr
)
{
  cr = is_defined(d) ? d/2 : r;

  vr_b = defined_e_or(vr, 0, vr);
  vr_p = defined_e_or(vr, 1, vr_b);

  if ( is_undef(vr) )
  {
    cylinder(h=h, r1=cr, r2=0, center=false);
  }
  else
  {
    hl = sqrt(cr*cr + h*h);

    rotate_extrude(angle=360)
    translate([eps*2-cr, 0])
    difference()
    {
      tp = triangle2d_sss2ppp([hl, cr*2, hl]);

      polygon( polygon_round_eve_all_p(tp, vr=[vr_p, vr_b, 0]) );
      square( size=[cr, h], center=false );
    }
  }
}

//! A cuboid with edge, round, or chamfer corners.
/***************************************************************************//**
  \param    size <decimal-list-3 | decimal> A list [x, y, z] of decimals
            or a single decimal for (x=y=z).

  \param    vr <decimal> The corner rounding radius.

  \param    vrm <integer> The radius mode.
            A 2-bit encoded integer that indicates edge and vertex finish.
            \em B0 controls edge and \em B1 controls vertex.

  \param    center <boolean> Center about origin.

  \details

    \amu_eval ( object=cuboid ${object_ex_diagram_3d} )

    | vrm | B1  | B0  | Description                                 |
    |:---:|:---:|:---:|:--------------------------------------------|
    |  0  |  0  |  0  | \em round edges with \em round vertexes     |
    |  1  |  0  |  1  | \em chamfer edges with \em sphere vertexes  |
    |  2  |  1  |  0  | \em round edges with \em chamfer vertexes   |
    |  3  |  1  |  1  | \em chamfer edges with \em chamfer vertexes |

  \note     Using \em round replaces all edges with a quarter circle
            of radius \p vr, inset <tt>[vr, vr]</tt> from the each edge.
  \note     Using \em chamfer replaces all edges with isosceles right
            triangles with side lengths equal to the corner rounding
            radius \p vr. Therefore the chamfer length will be
            <tt>vr*sqrt(2)</tt> at 45 degree angles.
*******************************************************************************/
module cuboid
(
  size,
  vr,
  vrm = 0,
  center = false
)
{
  bx = defined_e_or(size, 0, size);
  by = defined_e_or(size, 1, bx);
  bz = defined_e_or(size, 2, by);

  ef = binary_bit_is(vrm, 0, 0);
  vf = binary_bit_is(vrm, 1, 0);

  translate(center==true ? origin3d : [bx/2, by/2, bz/2])
  if ( is_undef(vr) )
  {
    cube([bx, by, bz], center=true);
  }
  else
  {
    cube([bx,      by-vr*2, bz-vr*2], center=true);
    cube([bx-vr*2, by,      bz-vr*2], center=true);
    cube([bx-vr*2, by-vr*2, bz     ], center=true);

    bv  = [bx, by, bz];
    rot = [[0,0,0], [90,0,90], [90,90,0]];

    for ( axis = [0:2] )
    {
      zo = bv[(axis+2)%3]/2 - vr;

      for ( x = [1,-1], y = [1,-1] )
      {
        rotate( rot[axis] )
        translate( [x*(bv[axis]/2-vr), y*(bv[(axis+1)%3]/2-vr), 0] )
        if ( ef )
        {
          cylinder( h=zo*2, r=vr, center=true );
        }
        else
        {
          polyhedron
          (
            points =
            [
              [-eps,-eps,+zo], [(vr+eps)*x,-eps,+zo], [-eps,(vr+eps)*y,+zo],
              [-eps,-eps,-zo], [(vr+eps)*x,-eps,-zo], [-eps,(vr+eps)*y,-zo],
            ],
            faces = [[0,2,1], [0,1,4,3], [1,2,5,4], [2,0,3,5], [3,4,5]]
          );
        }
      }
    }

    for ( x = [1,-1], y = [1,-1], z = [1,-1] )
    {
      translate([x*(bx/2-vr), y*(by/2-vr), z*(bz/2-vr)])
      if ( vf )
      {
        sphere(vr);
      }
      else
      {
        polyhedron
        (
          points = [[0,0,0], [vr*x,0,0], [0,vr*y,0], [0,0,vr*z]],
          faces = [[1,2,3], [0,2,1], [0,3,2], [0,1,3]]
        );
      }
    }
  }
}

//! An ellipsoid.
/***************************************************************************//**
  \param    size <decimal-list-2 | decimal> A list [w, h] of decimals or a
            single decimal for (w=h).

  \details

    \amu_eval ( object=ellipsoid ${object_ex_diagram_3d} )
*******************************************************************************/
module ellipsoid
(
  size
)
{
  w = defined_e_or(size, 0, size);
  h = defined_e_or(size, 1, w);

  if (w == h)
  {
    sphere( d=w );
  }
  else
  {
    scale( [1, 1, h/w] )
    sphere( r = w/2 );
  }
}

//! A sector of an ellipsoid.
/***************************************************************************//**
  \param    size <decimal-list-2 | decimal> A list [w, h] of decimals or a
            single decimal for (w=h).

  \param    a1 <decimal> The start angle in degrees.
  \param    a2 <decimal> The stop angle in degrees.

  \details

    \amu_eval ( object=ellipsoid_s ${object_ex_diagram_3d} )
*******************************************************************************/
module ellipsoid_s
(
  size,
  a1 = 0,
  a2 = 0
)
{
  w = defined_e_or(size, 0, size);
  h = defined_e_or(size, 1, w);

  trx = w/2 * sqrt(2) + 1;
  try = w/2 * sqrt(2) + 1;

  pa0 = (4 * a1 + 0 * a2) / 4;
  pa1 = (3 * a1 + 1 * a2) / 4;
  pa2 = (2 * a1 + 2 * a2) / 4;
  pa3 = (1 * a1 + 3 * a2) / 4;
  pa4 = (0 * a1 + 4 * a2) / 4;

  if (a2 > a1)
  {
    intersection()
    {
      ellipsoid(size);

      translate([0,0,-h/2])
      linear_extrude(height=h)
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
    ellipsoid(size);
  }
}

//! A pyramid with trilateral base formed by four equilateral triangles.
/***************************************************************************//**
  \param    size <decimal> The face radius.

  \param    center <boolean> Center about origin.

  \details

    \amu_eval ( object=pyramid_t ${object_ex_diagram_3d} )
*******************************************************************************/
module pyramid_t
(
  size,
  center = false
)
{
  o = size/2;
  a = size*sqrt(3)/2;

  translate(center==true ? origin3d : [0,0,o])
  polyhedron
  (
    points =
    [
      [-a,    -o,    -o],
      [ a,    -o,    -o],
      [ 0,  size,    -o],
      [ 0,     0,  size]
    ],
    faces =
    [
      [0, 2, 1],
      [1, 2, 3],
      [0, 1, 3],
      [0, 3, 2]
    ]
  );
}

//! A pyramid with quadrilateral base.
/***************************************************************************//**
  \param    size <decimal-list-3 | decimal> A list [x, y, z] of decimals
            or a single decimal for (x=y=z).

  \param    center <boolean> Center about origin.

  \details

    \amu_eval ( object=pyramid_q ${object_ex_diagram_3d} )
*******************************************************************************/
module pyramid_q
(
  size,
  center = false
)
{
  tw = defined_e_or(size, 0, size)/2;
  th = defined_e_or(size, 1, tw*2)/2;
  ph = defined_e_or(size, 2, th*2);

  translate(center==true ? [0,0,-ph/2] : origin3d)
  polyhedron
  (
    points=
    [
      [-tw, -th,  0],
      [-tw,  th,  0],
      [ tw,  th,  0],
      [ tw, -th,  0],
      [  0,   0, ph]
    ],
    faces=
    [
      [0, 3, 2, 1],
      [0, 1, 4],
      [1, 2, 4],
      [2, 3, 4],
      [3, 0, 4]
    ]
  );
}

//! A three-dimensional star.
/***************************************************************************//**
  \param    size <decimal-list-3 | decimal> A list [l, w, h] of decimals
            or a single decimal for (size=l=2*w=4*h).

  \param    n <decimal> The number of points.

  \param    half <boolean> Render upper half only.

  \details

    \amu_eval ( object=star3d ${object_ex_diagram_3d} )
*******************************************************************************/
module star3d
(
  size,
  n = 5,
  half = false
)
{
  l = defined_e_or(size, 0, size);
  w = defined_e_or(size, 1, l/2);
  h = defined_e_or(size, 2, w/2);

  if (half == true)
  {
    difference()
    {
      repeat_radial(n=n, angle=true, move=false)
      scale([1, 1, h/w])
      rotate([45, 0, 0])
      rotate([0, 90, 0])
      pyramid_q(size=[w, w, l], center=false);

      translate([0,0,-h/2])
      cylinder(r=l, h=h, center=true);
    }
  }
  else
  {
    repeat_radial(n=n, angle=true, move=false)
    scale([1, 1, h/w])
    rotate([45, 0, 0])
    rotate([0, 90, 0])
    pyramid_q(size=[w, w, l], center=false);
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

    shape = "cone";
    $fn = 36;

    if (shape == "cone")
      cone( h=25, r=10, vr=2 );
    else if (shape == "cuboid")
      cuboid( size=[25,40,20], vr=5, center=true );
    else if (shape == "ellipsoid")
      ellipsoid( size=[40,25] );
    else if (shape == "ellipsoid_s")
      ellipsoid_s( size=[60,15], a1=0, a2=270 );
    else if (shape == "pyramid_t")
      pyramid_t( size=20, center=true );
    else if (shape == "pyramid_q")
      pyramid_q( size=[35,20,5], center=true );
    else if (shape == "star3d")
      star3d( size=40, n=5, half=true );
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;

    views     name "views" views "diag";
    defines   name "shapes" define "shape"
              strings "
                cone
                cuboid
                ellipsoid
                ellipsoid_s
                pyramid_t
                pyramid_q
                star3d
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
