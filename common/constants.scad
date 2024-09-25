//! Constant definitions.
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

    \amu_define group_name  (Constant Definitions)
    \amu_define group_brief (Common mechanical design constants.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group.amu)

  \amu_include (include/amu/group_in_parent_start.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// subgroups.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_define group1        (${group}_general)
  \amu_define group1_name   (General)
  \amu_define group1_brief  (General mathematical constants.)

  \amu_define group2        (${group}_system)
  \amu_define group2_name   (System)
  \amu_define group2_brief  (System and program limits.)

  \amu_define group3        (${group}_euclidean)
  \amu_define group3_name   (Euclidean)
  \amu_define group3_brief  (Euclidean space axis mapping.)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group1.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \defgroup \amu_eval(${group1} ${group1_name})
  \brief    \amu_eval(${group1_brief})
  @{
  \amu_include (include/amu/includes_required.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//! <decimal> Epsilon, small distance to deal with overlapping shapes.
eps = 0.001;

//! <decimal> The ratio of a circle's circumference to its diameter.
pi  = 3.14159265358979323;

//! <decimal> The ratio of a circle's circumference to its radius.
tau = 2*pi;

//! <decimal> The golden ratio.
phi = (1 + sqrt(5)) / 2;

//! @}

//----------------------------------------------------------------------------//
// group2.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \defgroup \amu_eval(${group2} ${group2_name})
  \brief    \amu_eval(${group2_brief})
  @{
  \amu_include (include/amu/includes_required.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//! <decimal> The largest representable number in OpenSCAD scripts.
number_max = 1e308;

//! <decimal> The smallest representable number in OpenSCAD scripts.
number_min = -1e308;

//! <value> The OpenSCAD \c inf value (infinity).
number_inf = 1/0;

//! <value> The OpenSCAD \c nan value (not a number).
number_nan = 0/0;

//! <string> A string with no characters (the empty string).
empty_str = "";

//! \<list> A list with no values (the empty list).
empty_lst = [];

//! OpenSCAD coarse grid limit.
grid_coarse = 0.001;

//! OpenSCAD fine grid limit.
grid_fine = 0.000001;

//! @}

//----------------------------------------------------------------------------//
// group3.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \defgroup \amu_eval(${group3} ${group3_name})
  \brief    \amu_eval(${group3_brief})
  @{
  \amu_include (include/amu/includes_required.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//! <integer> The coordinate axis index for the Euclidean space x-axis.
x_axis_ci = 0;

//! <integer> The coordinate axis index for the Euclidean space y-axis.
y_axis_ci = 1;

//! <integer> The coordinate axis index for the Euclidean space z-axis.
z_axis_ci = 2;

//! <decimal-list-2> A 2d zero vector (a list with two zeros).
zero2d = [0, 0];

//! <point-2d> The origin point coordinate in 2d Euclidean space.
origin2d = [0, 0];

//! <vector-2d> The unit vector of the positive x-axis in 2d Euclidean space.
x_axis2d_uv = [1, 0];

//! <vector-2d> The unit vector of the positive y-axis in 2d Euclidean space.
y_axis2d_uv = [0, 1];

//! <line-2d> A positively-directed unit line centered on the x-axis in 2d Euclidean space.
x_axis2d_ul = [-x_axis2d_uv, +x_axis2d_uv];

//! <line-2d> A positively-directed unit line centered on the y-axis in 2d Euclidean space.
y_axis2d_ul = [-y_axis2d_uv, +y_axis2d_uv];

//! <decimal-list-2> A 3d zero vector (a list with three zeros).
zero3d = [0, 0, 0];

//! <point-3d> The origin point coordinate in 3-dimensional Euclidean space.
origin3d = [0, 0, 0];

//! <vector-3d> The unit vector of the positive x-axis in 3d Euclidean space.
x_axis3d_uv = [1, 0, 0];

//! <vector-3d> The unit vector of the positive y-axis in 3d Euclidean space.
y_axis3d_uv = [0, 1, 0];

//! <vector-3d> The unit vector of the positive z-axis in 3d Euclidean space.
z_axis3d_uv = [0, 0, 1];

//! <line-3d> A positively-directed unit line centered on the x-axis in 3d Euclidean space.
x_axis3d_ul = [-x_axis3d_uv, +x_axis3d_uv];

//! <line-3d> A positively-directed unit line centered on the y-axis in 3d Euclidean space.
y_axis3d_ul = [-y_axis3d_uv, +y_axis3d_uv];

//! <line-3d> A positively-directed unit line centered on the z-axis in 3d Euclidean space.
z_axis3d_ul = [-z_axis3d_uv, +z_axis3d_uv];

//! <plane> The right-handed xy plane centered at the origin with normal vector.
xy_plane_on = [origin3d, z_axis3d_uv];

//! <plane> The right-handed yz plane centered at the origin with normal vector.
yz_plane_on = [origin3d, x_axis3d_uv];

//! <plane> The right-handed zx plane centered at the origin with normal vector.
zx_plane_on = [origin3d, y_axis3d_uv];

//! <plane> The right-handed xy plane centered at the origin with coplanar unit square points.
xy_plane_os = [origin3d, [for (r=[[1,1],[1,-1],[-1,-1],[-1,1]]) [r[0],r[1],0]]];

//! <plane> The right-handed yz plane centered at the origin with coplanar unit square points.
yz_plane_os = [origin3d, [for (r=[[1,1],[1,-1],[-1,-1],[-1,1]]) [0,r[0],r[1]]]];

//! <plane> The right-handed zx plane centered at the origin with coplanar unit square points.
zx_plane_os = [origin3d, [for (r=[[1,1],[1,-1],[-1,-1],[-1,1]]) [r[1],0,r[0]]]];

//! @}
//! @}

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
