//! Common 3D derivative shapes.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2015-2018

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

    \amu_define group_name  (3d Shapes)
    \amu_define group_brief (Common 3D derivative shapes.)
    \amu_define view        (diag)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
*******************************************************************************/

include <derivative_2d.scad>;
include <../tools/extrude.scad>;

//----------------------------------------------------------------------------//
// dim macro, dim table, and group.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/example_dim_table.amu)

  \amu_include (include/amu/group_in_parent_start.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//! A cone.
/***************************************************************************//**
  \param    r <decimal> The base radius.
  \param    h <decimal> The height.

  \param    d <decimal> The base diameter.

  \param    vr <decimal> The default corner rounding radius.
  \param    vr1 <decimal> The base corner rounding radius.
  \param    vr2 <decimal> The point corner rounding radius.

  \details

    \b Example
    \amu_eval ( function=cone ${example_dim} )
*******************************************************************************/
module cone
(
  r,
  h,
  d,
  vr,
  vr1,
  vr2
)
{
  cr = defined_or(r, d/2);

  br = defined_or(vr1, vr);
  pr = defined_or(vr2, vr);

  if ( any_undefined([br, pr]) )
  {
    cylinder(h=h, r1=cr, r2=0, center=false);
  }
  else
  {
    hl = sqrt(cr*cr + h*h);

    rotate_extrude(angle=360)
    translate([-cr, 0])
    difference()
    {
      triangle_sss( s1=cr*2, s2=hl, s3=hl, v1r=br, v2r=br, v3r=pr );
      square( size=[cr,h], center=false );
    }
  }
}

//! A cuboid with edge, fillet, or chamfer corners.
/***************************************************************************//**
  \param    size <decimal-list-3|decimal> A list [x, y, z] of decimals
            or a single decimal for (x=y=z).

  \param    vr <decimal> The corner rounding radius.

  \param    vrm <integer> The radius mode.
            A 2-bit encoded integer that indicates edge and vertex finish.
            \em B0 controls edge and \em B1 controls vertex.

  \param    center <boolean> Center about origin.

  \details

    \b Example
    \amu_eval ( function=cuboid ${example_dim} )

    | vrm | B1  | B0  | Description                                 |
    |:---:|:---:|:---:|:--------------------------------------------|
    |  0  |  0  |  0  | \em fillet edges with \em fillet vertexes   |
    |  1  |  0  |  1  | \em chamfer edges with \em sphere vertexes  |
    |  2  |  1  |  0  | \em fillet edges with \em chamfer vertexes  |
    |  3  |  1  |  1  | \em chamfer edges with \em chamfer vertexes |

  \note     Using \em fillet replaces all edges with a quarter circle
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
  bx = edefined_or(size, 0, size);
  by = edefined_or(size, 1, bx);
  bz = edefined_or(size, 2, by);

  ef = bitwise_is_equal(vrm, 0, 0);
  vf = bitwise_is_equal(vrm, 1, 0);

  translate(center==true ? origin3d : [bx/2, by/2, bz/2])
  if ( not_defined(vr) )
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
              [-aeps,-aeps,+zo], [(vr+aeps)*x,-aeps,+zo], [-aeps,(vr+aeps)*y,+zo],
              [-aeps,-aeps,-zo], [(vr+aeps)*x,-aeps,-zo], [-aeps,(vr+aeps)*y,-zo],
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
  \param    size <decimal-list-2|decimal> A list [w, h] of decimals or a
            single decimal for (w=h).

  \details

    \b Example
    \amu_eval ( function=ellipsoid ${example_dim} )
*******************************************************************************/
module ellipsoid
(
  size
)
{
  w = edefined_or(size, 0, size);
  h = edefined_or(size, 1, w);

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
  \param    size <decimal-list-2|decimal> A list [w, h] of decimals or a
            single decimal for (w=h).

  \param    a1 <decimal> The start angle in degrees.
  \param    a2 <decimal> The stop angle in degrees.

  \details

    \b Example
    \amu_eval ( function=ellipsoid_s ${example_dim} )
*******************************************************************************/
module ellipsoid_s
(
  size,
  a1 = 0,
  a2 = 0
)
{
  w = edefined_or(size, 0, size);
  h = edefined_or(size, 1, w);

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

    \b Example
    \amu_eval ( function=pyramid_t ${example_dim} )

  \todo Support vertex rounding radius.
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
  \param    size <decimal-list-3|decimal> A list [x, y, z] of decimals
            or a single decimal for (x=y=z).

  \param    center <boolean> Center about origin.

  \details

    \b Example
    \amu_eval ( function=pyramid_q ${example_dim} )

  \todo Support vertex rounding radius.
*******************************************************************************/
module pyramid_q
(
  size,
  center = false
)
{
  tw = edefined_or(size, 0, size)/2;
  th = edefined_or(size, 1, tw*2)/2;
  ph = edefined_or(size, 2, th*2);

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
  \param    size <decimal-list-3|decimal> A list [l, w, h] of decimals
            or a single decimal for (size=l=2*w=4*h).

  \param    n <decimal> The number of points.

  \param    half <boolean> Render upper half only.

  \details

    \b Example
    \amu_eval ( function=star3d ${example_dim} )
*******************************************************************************/
module star3d
(
  size,
  n = 5,
  half = false
)
{
  l = edefined_or(size, 0, size);
  w = edefined_or(size, 1, l/2);
  h = edefined_or(size, 2, w/2);

  if (half == true)
  {
    difference()
    {
      radial_repeat(n=n, angle=true, move=false)
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
    radial_repeat(n=n, angle=true, move=false)
    scale([1, 1, h/w])
    rotate([45, 0, 0])
    rotate([0, 90, 0])
    pyramid_q(size=[w, w, l], center=false);
  }
}

//! A rectangular cross-sectional profile revolved about the z-axis.
/***************************************************************************//**
  \copydoc rotate_extrude_tre()

  \copydoc rectangle_c()

  \details

    \b Example
    \amu_eval ( function=torus_rp ${example_dim} )
*******************************************************************************/
module torus_rp
(
  r,
  pa = 0,
  ra = 360,
  profile = false,
  l,
  m = 255,

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
  rotate_extrude_tre( r=r, l=l, pa=pa, ra=ra, m=m, profile=profile )
  rectangle_c
  (
    size=size, core=core, t=t,
    co=co, cr=cr,
    vr=vr, vr1=vr1, vr2=vr2,
    vrm=vrm, vrm1=vrm1, vrm2=vrm2,
    center=center
  );
}

//! A triangular cross-sectional profile revolved about the z-axis.
/***************************************************************************//**
  \copydoc rotate_extrude_tre()

  \copydoc triangle_ls_c()

  \details

    \b Example
    \amu_eval ( function=torus_tp ${example_dim} )
*******************************************************************************/
module torus_tp
(
  r,
  pa = 0,
  ra = 360,
  profile = false,
  l,
  m = 255,

  vs,
  vc,
  co,
  cr = 0,
  vr,
  vr1,
  vr2,
  centroid = false,
  incenter = false
)
{
  rotate_extrude_tre( r=r, l=l, pa=pa, ra=ra, m=m, profile=profile )
  triangle_ls_c
  (
    vs=vs, vc=vc,
    co=co, cr=cr,
    vr=vr, vr1=vr1, vr2=vr2,
    centroid=centroid, incenter=incenter
  );
}

//! An elliptical cross-sectional profile revolved about the z-axis.
/***************************************************************************//**
  \copydoc rotate_extrude_tre()

  \copydoc ellipse_cs()

  \details

    \b Example
    \amu_eval ( function=torus_ep ${example_dim} )
*******************************************************************************/
module torus_ep
(
  r,
  pa = 0,
  ra = 360,
  profile = false,
  l,
  m = 255,

  size,
  core,
  t,
  a1 = 0,
  a2 = 0,
  co,
  cr = 0
)
{
  rotate_extrude_tre( r=r, l=l, pa=pa, ra=ra, m=m, profile=profile )
  ellipse_cs
  (
    size=size, core=core, t=t,
    a1=a1, a2=a2,
    co=co, cr=cr
  );
}

//! A rectangular profile revolved about the z-axis for generating cylinders.
/***************************************************************************//**
  \copydoc rotate_extrude_tre()

  \param    cr <decimal-list-2|decimal> The lower and upper radius. A
            list [cr1, cr2] of decimals or a single decimal for (cr1=cr2).
  \param    h <decimal> The height.

  \param    vr <decimal-list-2|decimal> The profile corner rounding
            radius. A list [vr1, vr2] of decimals or a single decimal
            for (vr1=vr2). Unspecified corners are not rounded.

  \param    center <boolean> Center profile height.

  \details

    \b Example
    \amu_eval ( function=torus_cp ${example_dim} )
*******************************************************************************/
module torus_cp
(
  r,
  pa = 0,
  ra = 360,
  profile = false,
  l,
  m = 255,

  cr,
  h,
  vr = 0,
  center = false
)
{
  cr1  = edefined_or(cr, 0, cr);
  cr2  = edefined_or(cr, 1, cr1);

  // limit corner rounding to [0, cr1/2]
  vr1 = limit(edefined_or(vr, 0, vr), 0, cr1/2);
  vr2 = limit(edefined_or(vr, 1, vr1), 0, cr2/2);

  pc1 = [cr1-vr1,   vr1];
  pc2 = [cr2-vr2, h-vr2];

  a  = 90
     + angle_ll (x_axis2d_ul, [pc2, pc1])
     - angle_ll (x_axis2d_ul, [distance_pp(pc2, pc1), vr2-vr1]);

  p =
  [
    [0, 0],
    [cr1-vr1, 0],
    pc1 + vr1*[cos(a), sin(a)],
    pc2 + vr2*[cos(a), sin(a)],
    [cr2-vr2, h],
    [0, h]
  ];

  translate(center==true ? [0, 0, -h/2] : origin3d)
  rotate_extrude_tre( r=r, l=l, pa=pa, ra=ra, m=m, profile=profile )
  union()
  {
    translate(pc1)
    circle(r=vr1);

    translate(pc2)
    circle(r=vr2);

    polygon(points=p, paths=[[0,1,2,3,4,5,6]]);
  }
}

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE dim;
  BEGIN_OPENSCAD;
    include <shapes/derivative_3d.scad>;

    shape = "cuboid";
    $fn = 72;

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
    else if (shape == "torus_rp")
      torus_rp( size=[40,20], core=[35,20], r=40, l=[90,60], co=[0,2.5], vr=4, vrm=15, center=true );
    else if (shape == "torus_tp")
      torus_tp( vs=40, vc=30, r=60, co=[0,-4], vr=4, pa=90, ra=270, centroid=true );
    else if (shape == "torus_ep")
      torus_ep( size=[20,15], t=[2,4], r=50, a1=0, a2=180, pa=90, ra=270, co=[0,2] );
    else if (shape == "torus_cp")
      torus_cp( cr=[15,10], h=30, vr=[5,2], r=40, l=[90,60], center=true );
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {config_base,config_png}.mfs;

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
                torus_rp
                torus_tp
                torus_ep
                torus_cp
              ";
    variables add_opts_combine "views shapes";
    variables add_opts "--viewall --autocenter";

    include --path "${INCLUDE_PATH}" script_std.mfs;
  END_MFSCRIPT;
END_SCOPE;

BEGIN_SCOPE manifest;
  BEGIN_OPENSCAD;
    include <shapes/derivative_3d.scad>;

    group = 1;
    $fn = 72;

    if (group == 1)
    grid_repeat( g=4, i=60, center=true )
    {
      translate([0,0,-12.5]) cone( h=25, r=15, vr=2 );
      cuboid( size=[25,40,20], vr=5, center=true );
      ellipsoid( size=[40,25] );
      ellipsoid_s( size=[60,15], a1=0, a2=270 );
      pyramid_t( size=15, center=true );
      pyramid_q( size=[35,40,25], center=true );
      star3d( size=40, n=5, half=false );
    }

    if (group == 2)
    grid_repeat( g=4, i=150, center=true )
    {
      torus_rp( size=[40,20], core=[35,20], r=40, l=[25,60], co=[0,2.5], vr=4, vrm=15, center=true );
      torus_tp( vs=40, vc=30, r=60, co=[0,-4], vr=4, pa=90, ra=270, centroid=true );
      torus_ep( size=[20,15], t=[2,4], r=60, a1=0, a2=180, pa=90, ra=270, co=[0,2] );
      torus_cp( cr=[15,10], h=30, vr=[5,2], r=40, l=[25,60], center=true );
    }
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {config_base,config_stl}.mfs;

    defines   name "group" define "group" integers "1 2";
    variables set_opts_combine "group";

    include --path "${INCLUDE_PATH}" script_std.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
