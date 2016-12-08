//! Three-dimensional basic shapes.
/***************************************************************************//**
  \file   shapes3d.scad
  \author Roy Allen Sutton
  \date   2015-2016

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

  \todo Complete rounded cylinder.

  \ingroup shapes shapes_3d
*******************************************************************************/

include <shapes2d.scad>;

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \addtogroup shapes
  @{

    \amu_define caption (3D Shapes)

    \amu_make png_files (append=dim extension=png)
    \amu_make eps_files (append=dim extension=png2eps)
    \amu_shell file_cnt ("echo ${png_files} | wc -w")
    \amu_shell cell_num ("seq -f '(%g)' -s '^' ${file_cnt}")

    \htmlonly
      \amu_image_table
        (
          type=html columns=4 image_width="200" cell_files="${png_files}"
          table_caption="${caption}" cell_captions="${cell_num}"
        )
    \endhtmlonly
    \latexonly
      \amu_image_table
        (
          type=latex columns=4 image_width="1.25in" cell_files="${eps_files}"
          table_caption="${caption}" cell_captions="${cell_num}"
        )
    \endlatexonly

  \defgroup shapes_3d 3D Shapes
  \brief    Three dimensional geometric shapes.
  @{
*******************************************************************************/
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
// amu macros
//----------------------------------------------------------------------------//
/***************************************************************************//**
  \amu_define scope (shapes3d_dim)
  \amu_define tuple (qvga_diag)

  \amu_define example_dim
  (
    \image html  ${scope}_${tuple}_${function}.png "${function}"
    \image latex ${scope}_${tuple}_${function}.eps "${function}" width=2.5in
    \dontinclude ${scope}.scad \skipline ${function}(
  )
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
  cr = (r == undef) ? d/2 : r;

  br = (vr1 == undef) ? vr : vr1;
  pr = (vr2 == undef) ? vr : vr2;

  if ( (br == undef) || (pr == undef) )
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
      triangle_lll( s1=cr*2, s2=hl, s3=hl, v1r=br, v2r=br, v3r=pr );
      square( size=[cr,h], center=false );
    }
  }
}

//! A cuboid.
/***************************************************************************//**
  \param    size <vector|decimal> A vector [x, y, z] of decimals or a
            single decimal for (x=y=z).

  \param    vr <decimal> The corner rounding radius.

  \param    center <boolean> Center about origin.

  \details

    \b Example
    \amu_eval ( function=cuboid ${example_dim} )
*******************************************************************************/
module cuboid
(
  size,
  vr,
  center = false
)
{
  bx = (len(size) >= 1) ? size[0] : size;
  by = (len(size) >= 2) ? size[1] : bx;
  bz = (len(size) >= 3) ? size[2] : by;

  translate(center==true ? [0,0,0] : [bx/2, by/2, bz/2])
  if ( vr == undef )
  {
    cube([bx, by, bz], center=true);
  }
  else
  {
    cube([bx,      by-vr*2, bz-vr*2], center=true);
    cube([bx-vr*2, by,      bz-vr*2], center=true);
    cube([bx-vr*2, by-vr*2, bz     ], center=true);

    bv  = [bx, by, bz];
    rot = [ [0,0,0], [90,0,90], [90,90,0] ];

    for (axis = [0:2])
    {
      for
      (
        x = [vr-bv[axis]/2,       -vr+bv[axis]/2      ],
        y = [vr-bv[(axis+1)%3]/2, -vr+bv[(axis+1)%3]/2]
      )
      {
        rotate( rot[axis] )
        translate( [x, y, 0] )
        cylinder( h=bv[(axis+2)%3]-2*vr, r=vr, center=true );
      }
    }

    for
    (
      x = [vr-bx/2, -vr+bx/2],
      y = [vr-by/2, -vr+by/2],
      z = [vr-bz/2, -vr+bz/2]
    )
    {
      translate([x,y,z])
      sphere(vr);
    }
  }
}

//! An ellipsoid.
/***************************************************************************//**
  \param    size <vector|decimal> A vector [w, h] of decimals or a
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
  w = (len(size) >= 1) ? size[0] : size;
  h = (len(size) >= 2) ? size[1] : w;

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
  \param    size <vector|decimal> A vector [w, h] of decimals or a
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
  w = (len(size) >= 1) ? size[0] : size;
  h = (len(size) >= 2) ? size[1] : w;

  trx = w/2 * sqrt(2) + 1;
  try = w/2 * sqrt(2) + 1;

  pa0 = (4 * a1 + 0 * a2) / 4;
  pa1 = (3 * a1 + 1 * a2) / 4;
  pa2 = (2 * a1 + 2 * a2) / 4;
  pa3 = (1 * a1 + 3 * a2) / 4;
  pa4 = (0 * a1 + 4 * a2) / 4;

  if(a2 > a1)
  {
    intersection()
    {
      ellipsoid(size);

      translate([0,0,-h/2])
      linear_extrude(height=h)
      polygon
      ([
        [0,0],
        [trx * cos(pa0), try * sin(pa0)],
        [trx * cos(pa1), try * sin(pa1)],
        [trx * cos(pa2), try * sin(pa2)],
        [trx * cos(pa3), try * sin(pa3)],
        [trx * cos(pa4), try * sin(pa4)],
        [0,0]
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
  \param    r <decimal> The face radius.

  \param    center <boolean> Center about origin.

  \details

    \b Example
    \amu_eval ( function=tetrahedron ${example_dim} )

  \todo Support vertex rounding radius.
*******************************************************************************/
module tetrahedron
(
  r,
  center = false
)
{
  o = r/2;
  a = r*sqrt(3)/2;

  translate(center==true ? [0,0,0] : [0,0,o])
  polyhedron
  (
    points =
    [
      [-a, -o, -o],
      [ a, -o, -o],
      [ 0,  r, -o],
      [ 0,  0,  r]
    ],
    faces =
    [
      [0, 1, 2],
      [1, 2, 3],
      [0, 1, 3],
      [0, 2, 3]
    ]
  );
}

//! A pyramid with quadrilateral base.
/***************************************************************************//**
  \param    x <decimal> The base x-length.
  \param    y <decimal> The base y-length.
  \param    z <decimal> The z-height.

  \param    center <boolean> Center about origin.

  \details

    \b Example
    \amu_eval ( function=pyramid_q ${example_dim} )

  \todo Support vertex rounding radius.
*******************************************************************************/
module pyramid_q
(
  x,
  y,
  z,
  center = false
)
{
  tw = x/2;
  th = y/2;
  ph = z;

  translate(center==true ? [0,0,-ph/2] : [0,0,0])
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

//! A three dimensional star.
/***************************************************************************//**
  \param    size <vector|decimal> A vector [l, w, h] of decimals
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
  l = (len(size) >= 1) ? size[0] : size;
  w = (len(size) >= 2) ? size[1] : l/2;
  h = (len(size) >= 3) ? size[2] : w/2;

  if (half == true)
  {
    difference()
    {
      st_radial_copy(n=n, angle=true, move=false)
      scale([1, 1, h/w])
      rotate([45, 0, 0])
      rotate([0, 90, 0])
      pyramid_q(x=w, y=w, z=l, center=false);

      translate([0,0,-h/2])
      cylinder(r=l, h=h, center=true);
    }
  }
  else
  {
    st_radial_copy(n=n, angle=true, move=false)
    scale([1, 1, h/w])
    rotate([45, 0, 0])
    rotate([0, 90, 0])
    pyramid_q(x=w, y=w, z=l, center=false);
  }
}

//! A rectangular cross-sectional profile revolved about the z-axis.
/***************************************************************************//**
  \param    size <vector|decimal> The profile size. A vector [x, y] of decimals
            or a single decimal for (x=y).
  \param    core <vector|decimal> The profile core. A vector [x, y] of decimals
            or a single decimal for (x=y).

  \param    r <decimal> The rotation radius.
  \param    l <decimal> The elongation length.

  \param    t <vector|decimal> The profile thickness. A vector [x, y] of decimals
            or a single decimal for (x=y).

  \param    co <vector> Core offset. A vector [x, y] of decimals.
  \param    cr <decimal> Core z-rotation.

  \param    vr <decimal> The profile default corner rounding radius.
  \param    vr1 <decimal> The profile outer corner rounding radius.
  \param    vr2 <decimal> The profile core corner rounding radius.

  \param    vr <vector|decimal> The profile default corner rounding radius.
            A vector [v1r, v2r, v3r, v4r] of decimals or a single decimal
            for (v1r=v2r=v3r=v4r). Unspecified corners are not rounded.
  \param    vr1 <vector|decimal> The profile outer corner rounding radius.
            A vector [v1r, v2r, v3r, v4r] of decimals or a single decimal
            for (v1r=v2r=v3r=v4r). Unspecified corners are not rounded.
  \param    vr2 <vector|decimal> The profile core corner rounding radius.
            A vector [v1r, v2r, v3r, v4r] of decimals or a single decimal
            for (v1r=v2r=v3r=v4r). Unspecified corners are not rounded.

  \param    pa <decimal> The profile pitch angle in degrees.
  \param    ra <decimal> The rotation sweep angle in degrees.

  \param    center <boolean> Rotate about profile center.
  \param    profile <boolean> Show profile only (do not extrude).

  \details

    Thickness \p t
    \li <tt>core = size - t</tt>; when \p t and \p size are given.
    \li <tt>size = core + t</tt>; when \p t and \p core are given.

    \b Example
    \amu_eval ( function=torus_rp ${example_dim} )
*******************************************************************************/
module torus_rp
(
  size,
  core,
  r,
  l = 0,
  t,
  co,
  cr = 0,
  vr,
  vr1,
  vr2,
  pa = 0,
  ra = 360,
  center = false,
  profile = false
)
{
  st_rotate_extrude_elongate( r=r, l=l, pa=pa, ra=ra, profile=profile )
  rectangle_c
  (
    size=size, core=core, t=t,
    co=co, cr=cr,
    vr=vr, vr1=vr1, vr2=vr2,
    center=center
  );
}

//! A triangular cross-sectional profile revolved about the z-axis.
/***************************************************************************//**
  \param    vs <vector|decimal> The size. A vector [s1, s2, s3] of decimals
            or a single decimal for (s1=s2=s3).
  \param    vc <vector|decimal> The core. A vector [s1, s2, s3] of decimals
            or a single decimal for (s1=s2=s3).

  \param    r <decimal> The rotation radius.
  \param    l <decimal> The elongation length.

  \param    co <vector> Core offset. A vector [x, y] of decimals.
  \param    cr <decimal> Core z-rotation.

  \param    vr <vector|decimal> The default vertex rounding radius. A vector
            [v1r, v2r, v3r] of decimals or a single decimal for (v1r=v2r=v3r).
  \param    vr1 <vector|decimal> The outer vertex rounding radius. A vector
            [v1r, v2r, v3r] of decimals or a single decimal for (v1r=v2r=v3r).
  \param    vr2 <vector|decimal> The core vertex rounding radius. A vector
            [v1r, v2r, v3r] of decimals or a single decimal for (v1r=v2r=v3r).

  \param    pa <decimal> The profile pitch angle in degrees.
  \param    ra <decimal> The rotation sweep angle in degrees.

  \param    centroid <boolean> Rotate about profile centroid.
  \param    incenter <boolean> Rotate about profile incenter.
  \param    profile <boolean> Show profile only (do not extrude).

  \details

    \b Example
    \amu_eval ( function=torus_tp ${example_dim} )

  \note The outer and inner triangles centroids are aligned prior to the
        core removal.
*******************************************************************************/
module torus_tp
(
  vs,
  vc,
  r,
  l = 0,
  co,
  cr = 0,
  vr,
  vr1,
  vr2,
  pa = 0,
  ra = 360,
  centroid = false,
  incenter = false,
  profile = false,
)
{
  st_rotate_extrude_elongate( r=r, l=l, pa=pa, ra=ra, profile=profile )
  triangle_vl_c
  (
    vs=vs, vc=vc,
    co=co, cr=cr,
    vr=vr, vr1=vr1, vr2=vr2,
    centroid=centroid, incenter=incenter
  );
}

//! An elliptical cross-sectional profile revolved about the z-axis.
/***************************************************************************//**
  \param    size <vector|decimal> The profile size. A vector [x, y] of decimals
            or a single decimal for (x=y).
  \param    core <vector|decimal> The profile core. A vector [x, y] of decimals
            or a single decimal for (x=y).

  \param    r <decimal> The rotation radius.
  \param    l <decimal> The elongation length.

  \param    t <vector|decimal> The profile thickness. A vector [x, y] of decimals
            or a single decimal for (x=y).

  \param    a1 <decimal> The profile start angle in degrees.
  \param    a2 <decimal> The profile stop angle in degrees.

  \param    co <vector> Core offset. A vector [x, y] of decimals.
  \param    cr <decimal> Core z-rotation.

  \param    pa <decimal> The profile pitch angle in degrees.
  \param    ra <decimal> The rotation sweep angle in degrees.

  \param    profile <boolean> Show profile only (do not extrude).

  \details

    Thickness \p t
    \li <tt>core = size - t</tt>; when \p t and \p size are given.
    \li <tt>size = core + t</tt>; when \p t and \p core are given.

    \b Example
    \amu_eval ( function=torus_ep ${example_dim} )
*******************************************************************************/
module torus_ep
(
  size,
  core,
  r,
  l = 0,
  t,
  a1 = 0,
  a2 = 0,
  co,
  cr = 0,
  pa = 0,
  ra = 360,
  profile = false
)
{
  st_rotate_extrude_elongate( r=r, l=l, pa=pa, ra=ra, profile=profile )
  ellipse_cs
  (
    size=size, core=core, t=t,
    a1=a1, a2=a2,
    co=co, cr=cr
  );
}

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE dim;
  BEGIN_OPENSCAD;
    include <shapes3d.scad>;

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
    else if (shape == "tetrahedron")
      tetrahedron( r = 20, center=true );
    else if (shape == "pyramid_q")
      pyramid_q( x=35, y=20, z=5, center=true );
    else if (shape == "star3d")
      star3d(size=40, n=5, half=true);
    else if (shape == "torus_rp")
      torus_rp( size=[40,20], core=[35,20], r=40, l=60, co=[0,2.5], vr=2, center=true );
    else if (shape == "torus_tp")
      torus_tp( vs=40, vc=30, r=60, co=[0,-4], vr=4, pa=90, ra=270, centroid=true );
    else if (shape == "torus_ep")
      torus_ep(size=[20,15], t=[2,4], r=50, a1=0, a2=180, pa=90, ra=270, co=[0,2]);
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
                tetrahedron
                pyramid_q
                torus_rp
                torus_tp
                torus_ep
                star3d
              ";
    variables add_opts_combine "views shapes";
    variables add_opts "--viewall --autocenter";

    include --path "${INCLUDE_PATH}" script_std.mfs;
  END_MFSCRIPT;
END_SCOPE;

BEGIN_SCOPE manifest;
  BEGIN_OPENSCAD;
    include <shapes3d.scad>;

    group = 1;
    $fn = 72;

    if (group == 1)
    st_cartesian_copy( grid=4, incr=60, center=true )
    {
      cone( h=25, r=10, vr=2 );
      cuboid( size=[25,40,20], vr=5, center=true );
      ellipsoid( size=[40,25] );
      ellipsoid_s( size=[60,15], a1=0, a2=270 );
      tetrahedron( r = 20, center=true );
      pyramid_q( x=35, y=20, z=5, center=true );
      star3d(size=40, n=5, half=false);
    }

    if (group == 2)
    st_cartesian_copy( grid=4, incr=140, center=true )
    {
      torus_rp( size=[40,20], core=[35,20], r=40, l=60, co=[0,2.5], vr=2, center=true );
      torus_tp( vs=40, vc=30, r=60, co=[0,-4], vr=4, pa=90, ra=270, centroid=true );
      torus_ep(size=[20,15], t=[2,4], r=50, a1=0, a2=180, pa=90, ra=270, co=[0,2]);
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
