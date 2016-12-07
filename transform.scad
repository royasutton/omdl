//! Shape transformation functions.
/***************************************************************************//**
  \file   transform.scad
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

  \ingroup transforms transforms_extrude transforms_replicate
*******************************************************************************/

use <console.scad>;
include <math.scad>;

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \addtogroup transforms
  @{

  \defgroup transforms_extrude Extrusions
  \brief    Shape Extrusions.
  @{
*******************************************************************************/
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
// amu macros
//----------------------------------------------------------------------------//
/***************************************************************************//**
  \amu_define scope (transform_dim)
  \amu_define tuple (qvga_diag)

  \amu_define example_dim
  (
    \image html  ${scope}_${tuple}_${function}.png "${function}"
    \image latex ${scope}_${tuple}_${function}.eps "${function}" width=2.5in
    \dontinclude ${scope}.scad \skipline ${function}(
  )
*******************************************************************************/
//----------------------------------------------------------------------------//

//! Revolve the 2D shape about the z-axis.
/***************************************************************************//**
  \param    r <decimal> The rotation radius.
  \param    pa <decimal> The profile pitch angle in degrees.
  \param    ra <decimal> The rotation sweep angle in degrees.
  \param    profile <boolean> Show profile only (do not extrude).

  \details

    \b Example
    \amu_eval ( function=st_rotate_extrude ${example_dim} )
*******************************************************************************/
module st_rotate_extrude
(
  r,
  pa = 0,
  ra = 360,
  profile = false
)
{
  rotate_extrude(angle = (profile==true ? 1 : ra) )
  translate([r, 0])
  rotate([0, 0, pa])
  children();
}

//! Revolve the 2D shape about the z-axis with linear elongation.
/***************************************************************************//**
  \param    r <decimal> The rotation radius.
  \param    l <decimal> The elongation length.
  \param    pa <decimal> The profile pitch angle in degrees.
  \param    ra <decimal> The rotation sweep angle in degrees.
  \param    profile <boolean> Show profile only (do not extrude).

  \details

    \b Example
    \amu_eval ( function=st_rotate_extrude_elongate ${example_dim} )

  \note When elongating (\p l > 0), parameter \p pa is ignored in order to
        complete the circuit.
*******************************************************************************/
module st_rotate_extrude_elongate
(
  r,
  l = 0,
  pa = 0,
  ra = 360,
  profile = false
)
{
  if ( (l == 0) || (profile==true) )
  {
    st_rotate_extrude(r=r, pa=pa, ra=ra, profile=profile)
    children();
  }
  else
  {
    for (y = [[+l/2, 0], [-l/2, 180]])
    {
      translate([0, y[0], 0])
      rotate([0, 0, y[1]])
      st_rotate_extrude(r=r, pa=pa, ra=180, profile=profile)
      children();
    }

    for (x = [[+r, 0], [-r, 180]])
    {
      translate([x[0], 0, 0])
      rotate([90, 0, x[1]])
      translate([0, 0, -l/2])
      linear_extrude(height=l)
      rotate([0, 0, pa])
      children();
    }
  }
}

//! Linearly extrude 2D shape with extrusion upper and lower scaling.
/***************************************************************************//**
  \param    h <vector|decimal> A vector of decimals or a single decimal to
            specify simple extrusion height.
  \param    center <boolean> Center extrusion about origin.

  \details

    When \p h is a decimal, the shape is extruded linearly as normal. To
    scale the upper and lower slices of the extrusion, \p h must be
    assigned a vector with a minimum of three decimal values as
    described in the following table.

      sym | h[n] | default | description
    :----:|:----:|:-------:|:---------------------------------------
      h   |  0   |         | total extrusion height
      n1  |  1   |         | (+z) number of scaled extrusion slices
      h1  |  2   |         | (+z) extrusion scale percentage
      x1  |  3   | -h1     | (+z) x-dimension scale percentage
      y1  |  4   |  x1     | (+z) y-dimension scale percentage
      n2  |  5   |  n1     | (-z) number of scaled extrusion slices
      h2  |  6   |  h1     | (-z) extrusion scale percentage
      x2  |  7   |  x1     | (-z) x-dimension scale percentage
      y2  |  8   |  y1     | (-z) y-dimension scale percentage

  \details

    \b Example
    \amu_eval ( function=st_linear_extrude_scale ${example_dim} )

  \note When symmetrical scaling is desired, shape must be centered about
        origin.
*******************************************************************************/
module st_linear_extrude_scale
(
  h,
  center = false
)
{
  if (h == undef)
  {
    children();
  }
  else if (len(h) == undef)
  {
    translate(center==true ? [0, 0, -h/2] : [0,0,0])
    linear_extrude(height=h)
    children();
  }
  else
  {
    z = h[0];                                   // total height

    n1 = (len(h) >= 3) ? max(h[1], 0)  : undef; // number of scaled-slices
    z1 = (len(h) >= 3) ? abs(h[2])/100 : undef; // z scale fraction
    x1 = (len(h) >= 4) ?     h[3] /100 : -z1;   // x scale fraction
    y1 = (len(h) >= 5) ?     h[4] /100 : x1;    // y scale fraction

    n2 = (len(h) >= 6) ? max(h[5], 0)  : n1;
    z2 = (len(h) >= 7) ? abs(h[6])/100 : z1;
    x2 = (len(h) >= 8) ?     h[7] /100 : x1;
    y2 = (len(h) >= 9) ?     h[8] /100 : y1;

    h1 = (n1>0) ? z1 * z : 0;
    h2 = (n2>0) ? z2 * z : 0;
    h0 = z - h1 - h2;

    translate(center==true ? [0, 0, -z/2] : [0,0,0])
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
/***************************************************************************//**
  \addtogroup transforms
  @{

  \defgroup transforms_replicate Replications
  \brief    Shape Replications and distribution.
  @{
*******************************************************************************/
//----------------------------------------------------------------------------//

//! Distribute copies of a 2D or 3D shape equally about a z-axis radius.
/***************************************************************************//**
  \param    n <decimal> The number of equally spaced radii.
  \param    r <decimal> The shape move radius.
  \param    angle <boolean> Rotate each copy about z-axis.
  \param    move <boolean> Move each shape copy to radii coordinate.

  \details

    \b Example
    \amu_eval ( function=st_radial_copy ${example_dim} )
*******************************************************************************/
module st_radial_copy
(
  n,
  r = 1,
  angle = true,
  move = false
)
{
  for ( p = ngon_vp( r=r, n=n ) )
  {
    translate(move==true ? p : [0,0])
    rotate(angle==true ? [0, 0, angle_p2p ( x_axis2d_uv, p )] : [0, 0, 0])
    children();
  }
}

//! Distribute copies of 2D or 3D shapes about Cartesian grid.
/***************************************************************************//**
  \param    grid <vector|decimal> A vector [x, y, z] of decimals or a
            single decimal for (x=y=z).
  \param    incr <vector|decimal> A vector [x, y, z] of decimals or a
            single decimal for (x=y=z).
  \param    copy <decimal> Number of times to iterate over children.
  \param    center <boolean> Center distribution about origin.

  \details

    \b Example
    \amu_eval ( function=st_cartesian_copy ${example_dim} )
*******************************************************************************/
module st_cartesian_copy
(
  grid,
  incr,
  copy = 1,
  center = false
)
{
  gridx = (len(grid)>=1) ? grid[0] : grid;
  gridy = (len(grid)>=2) ? grid[1] : gridx;
  gridz = (len(grid)>=3) ? grid[2] : gridx;

  incrx = (len(incr)>=1) ? incr[0] : incr;
  incry = (len(incr)>=2) ? incr[1] : incrx;
  incrz = (len(incr)>=3) ? incr[2] : incrx;

  if ( ( $children * copy ) > ( gridx * gridy * gridz ) )
  {
    log_warn("more objects than grid capacity, shapes will overlap.");
    log_info
    (
      str
      (
        "children=", $children,
        ", copies=", copy,
        ", objects=", $children * copy
      )
    );
    log_info
    (
      str
      (
        "grid[x,y,z]=[", gridx, ", ", gridy, ", ", gridz, "]",
        ", capacity=", gridx * gridy * gridz
      )
    );
  }

  translate
  (
    center==true
    ? [
        -( min($children * copy, gridx) -1 )                   * incrx / 2,
        -( min(ceil($children * copy/gridx), gridy) -1 )       * incry / 2,
        -( min(ceil($children * copy/gridx/gridy), gridz) -1 ) * incrz / 2
      ]
    : [0,0,0]
  )
  if ( copy > 0 )
  {
    for
    (
      y = [0 : (copy-1)],
      x = [0 : ($children-1)]
    )
    {
      i = y * $children + x;

      translate
      (
        [
          incrx * (i%gridx),
          incry * (floor(i/gridx)%gridy),
          incrz * (floor(floor(i/gridx)/gridy)%gridz)
        ]
      )
      children([x]);
    }
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
    include <transform.scad>;

    shape = "st_rotate_extrude";
    $fn = 72;

    if (shape == "st_rotate_extrude")
      st_rotate_extrude( r=50, pa=45 ) square( [10,5], center=true );
    else if (shape == "st_rotate_extrude_elongate")
      st_rotate_extrude_elongate( r=25, l=50, pa=45 ) square( [10,5], center=true );
    else if (shape == "st_linear_extrude_scale")
      st_linear_extrude_scale( [5,10,15,-5], center=true ) square( [20,15], center=true );
    else if (shape == "st_radial_copy")
      st_radial_copy( n=7, r=6, move=true ) square( [20,1], center=true );
    else if (shape == "st_cartesian_copy")
      st_cartesian_copy( grid=[5,5,4], incr=10, copy=50, center=true ) {cube(10, center=true); sphere(10);}
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {config_base,config_png}.mfs;

    views     name "views" views "diag";
    defines   name "shapes" define "shape"
              strings "
                st_rotate_extrude
                st_rotate_extrude_elongate
                st_linear_extrude_scale
                st_radial_copy
                st_cartesian_copy
              ";
    variables add_opts_combine "views shapes";
    variables add_opts "--viewall --autocenter";

    include --path "${INCLUDE_PATH}" script_std.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
