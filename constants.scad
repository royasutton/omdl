//! Design constant definitions.
/***************************************************************************//**
  \file   constants.scad
  \author Roy Allen Sutton
  \date   2015-2017

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

  \note Include this library file using the \b include statement.

  \ingroup constants constants_general constants_system constants_euclidean
*******************************************************************************/

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \addtogroup constants
  @{

  \defgroup constants_general General
  \brief    General design constants.
  @{
*******************************************************************************/
//----------------------------------------------------------------------------//

//! <decimal> Epsilon, small distance to deal with overlapping shapes.
eps = 0.01;

//! <decimal> The ratio of a circle's circumference to its diameter.
pi  = 3.14159265358979323;

//! <decimal> The ratio of a circle's circumference to its radius.
tau = 2*pi;

//! <decimal> The golden ratio.
phi = (1 + sqrt(5)) / 2;

//! @}
//! @}

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \addtogroup constants
  @{

  \defgroup constants_system System
  \brief    System and program limits.
  @{
*******************************************************************************/
//----------------------------------------------------------------------------//

//! <decimal> The largest representable number in OpenSCAD scripts.
number_max = 1e308;

//! <decimal> The smallest representable number in OpenSCAD scripts.
number_min = -1e308;

//! <string> A string with no characters (the empty string).
empty_str = "";

//! \<list> A list with no values (the empty list).
empty_lst = [];

//! @}
//! @}

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \addtogroup constants
  @{

  \defgroup constants_euclidean Euclidean
  \brief    Euclidean space axis mapping.
  @{
*******************************************************************************/
//----------------------------------------------------------------------------//

//! <integer> The mapping index for the x-axis in Euclidean space.
x_axis_vi = 0;

//! <integer> The mapping index for the y-axis in Euclidean space.
y_axis_vi = 1;

//! <integer> The mapping index for the z-axis in Euclidean space.
z_axis_vi = 2;

//! <point-2d> The origin point coordinate in 2d Euclidean space.
origin2d = [0, 0];

//! <vector-2d> The unit vector of the positive x-axis in 2d Euclidean space.
x_axis2d_uv = [1, 0];

//! <vector-2d> The unit vector of the positive y-axis in 2d Euclidean space.
y_axis2d_uv = [0, 1];

//! <point-3d> The origin point coordinate in 3-dimensional Euclidean space.
origin3d = [0, 0, 0];

//! <vector-3d> The unit vector of the positive x-axis in 3d Euclidean space.
x_axis3d_uv = [1, 0, 0];

//! <vector-3d> The unit vector of the positive y-axis in 3d Euclidean space.
y_axis3d_uv = [0, 1, 0];

//! <vector-3d> The unit vector of the positive z-axis in 3d Euclidean space.
z_axis3d_uv = [0, 0, 1];

//! @}
//! @}

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
