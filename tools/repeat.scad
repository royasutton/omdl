//! Shape repetition tools.
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

    \amu_define group_name  (Repeat)
    \amu_define group_brief (Shape repetition tools.)
    \amu_define view        (diag)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
*******************************************************************************/

include <../math/vector_algebra.scad>;
include <../math/polygon_shapes.scad>;

//----------------------------------------------------------------------------//
// dim macro, dim table, and group.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/example_dim_table.amu)

  \amu_include (include/amu/group_in_parent_start.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//! Distribute copies of a 2d or 3d shape equally about a z-axis radius.
/***************************************************************************//**
  \param    n <integer> The number of equally spaced radii.
  \param    r <decimal> The shape move radius.
  \param    angle <boolean> Rotate each copy about z-axis.
  \param    move <boolean> Move each shape copy to radii coordinate.

  \details

    \b Example
    \amu_eval ( function=radial_repeat ${example_dim} )
*******************************************************************************/
module radial_repeat
(
  n,
  r = 1,
  angle = true,
  move = false
)
{
  for ( p = rpolygon_lp( r=r, n=n ) )
  {
    translate(move==true ? p : origin2d)
    rotate(angle==true ? [0, 0, angle_ll(x_axis2d_uv, p)] : origin3d)
    children();
  }
}

//! Distribute copies of 2d or 3d shapes about Cartesian grid.
/***************************************************************************//**
  \param    g <integer-list-3|integer> The grid division count. A list
            [x, y, z] of integers or a single integer for (x=y=z).
  \param    i <decimal-list-3|decimal> The grid increment size. A list
            [x, y, z] of decimals or a single decimal for (x=y=z).
  \param    c <integer> The number of copies. Number of times to iterate
            over children.
  \param    center <boolean> Center distribution about origin.

  \details

    \b Example
    \amu_eval ( function=grid_repeat ${example_dim} )
*******************************************************************************/
module grid_repeat
(
  g,
  i,
  c = 1,
  center = false
)
{
  gridd = is_scalar(g) ? g : 1;

  gridx = edefined_or(g, 0, gridd);
  gridy = edefined_or(g, 1, gridd);
  gridz = edefined_or(g, 2, gridd);

  incrd = is_scalar(i) ? i : 0;

  incrx = edefined_or(i, 0, incrd);
  incry = edefined_or(i, 1, incrd);
  incrz = edefined_or(i, 2, incrd);

  if ( ( $children * c ) > ( gridx * gridy * gridz ) )
  {
    log_warn("more objects than grid capacity, shapes will overlap.");
    log_info
    (
      str
      (
        "children=", $children,
        ", copies=", c,
        ", objects=", $children * c
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
        -( min($children * c, gridx) -1 )                   * incrx / 2,
        -( min(ceil($children * c/gridx), gridy) -1 )       * incry / 2,
        -( min(ceil($children * c/gridx/gridy), gridz) -1 ) * incrz / 2
      ]
    : origin3d
  )
  if ( c > 0 )
  {
    for
    (
      y = [0 : (c-1)],
      x = [0 : ($children-1)]
    )
    {
      j = y * $children + x;

      translate
      (
        [
          incrx * (j%gridx),
          incry * (floor(j/gridx)%gridy),
          incrz * (floor(floor(j/gridx)/gridy)%gridz)
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
    include <tools/repeat.scad>;

    shape = "radial_repeat";
    $fn = 72;

    if (shape == "radial_repeat")
      radial_repeat( n=7, r=6, move=true ) square( [20,1], center=true );
    else if (shape == "grid_repeat")
      grid_repeat( g=[5,5,4], i=10, c=50, center=true ) {cube(10, center=true); sphere(10);}
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {config_base,config_png}.mfs;

    views     name "views" views "diag";
    defines   name "shapes" define "shape"
              strings "
                radial_repeat
                grid_repeat
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
