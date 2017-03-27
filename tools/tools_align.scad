//! Shape alignment tools.
/***************************************************************************//**
  \file   tools_align.scad
  \author Roy Allen Sutton
  \date   2017

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

  \ingroup tools tools_align
*******************************************************************************/

include <math.scad>;

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \addtogroup tools
  @{

  \defgroup tools_align Alignment
  \brief    Shape alignment tools.
  @{
*******************************************************************************/
//----------------------------------------------------------------------------//

//! Align a shape's Cartesian axis to another axis specified as line.
/***************************************************************************//**
  \param    a <line-3d|line-2d> An alignment axis line or vector.
  \param    t <integer> Translation mode (one of [0:4], see table).
  \param    r <decimal> Rotation about the alignment vector (in degrees).
  \param    d <integer> Dimension index. The Cartesian axis index to
            align (0, 1, or 2).

  \details

    |  t  | shape translation |
    |:---:|:-----------------:|
    |  0  |  0                |
    |  1  |  pi               |
    |  2  |  (pt+pi)/2        |
    |  3  |  pt               |
    |  4  |  pt+pi            |

    Where \c pi is the initiating point and \c pt is the terminating
    point of the vector or line.

    See \ref dt_vectors for argument specification and conventions.
*******************************************************************************/
module align_axis
(
  a,
  t = 0,
  r = 0,
  d = 2
)
{
  pt = vector_get_tp(a);
  pi = vector_get_ip(a);

  pa = acos((pt[2]-pi[2]) / distance_pp(pt, pi));
  aa = atan2(pt[1]-pi[1], pt[0]-pi[0]);

  tv  = (t == 0) ? origin3d
      : (t == 1) ? pi
      : (t == 2) ? (pt+pi)/2
      : (t == 3) ? pt
      : (t == 4) ? pt+pi
      : origin3d;

  rv = (d == 0) ? [[ 0, -90, r], [0, pa, aa]]
     : (d == 1) ? [[90,   0, r], [0, pa, aa]]
     : (d == 2) ? [[ 0,   0, r], [0, pa, aa]]
     : [origin3d, origin3d];

  translate(tv)
  rotate(rv[1])
  rotate(rv[0])
  children();
}

//! Align a line to an arbitrary axis specified as another line.
/***************************************************************************//**
  \param    l <line-3d|line-2d> A line or vector to align.
  \param    a <line-3d|line-2d> An alignment axis line or vector.

  \param    lm <integer> line reference point mode
            (one of [0:2], see table).
  \param    am <integer> axis reference point mode
            (one of [0:2], see table).

  \param    t <vector-3d|vector-2d> Post-alignment translation vector.
  \param    r <decimal-list-1:3|decimal> Post-alignment rotation angles
            (in degrees). Single decimal specifies z-rotation.

  \details

    | lm, am  | reference point | note      |
    |:-------:|:---------------:|:---------:|
    |  0      |  initial        |           |
    |  1      |  median         | (default) |
    |  2      |  termination    |           |

    See \ref dt_vectors for argument specification and conventions.
*******************************************************************************/
module align_line
(
  l,
  a,
  lm,
  am,
  t,
  r
)
{
  translate(ciselect([first(a), mean(a), second(a), mean(a)], am))
  rotate(angle_vv(l, a))
  rotate(defined_or(r, origin3d))
  translate(-ciselect([first(l), mean(l), second(l), mean(l)], lm))
  translate(defined_or(t, origin3d))
  children();
}

//! @}
//! @}

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
