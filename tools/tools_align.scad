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

//! Align an axis of a shape to an arbitrary vector.
/***************************************************************************//**
  \param    v <vector-3d> An alignment vector or line.
  \param    t <integer> Translation mode (one of [0:4], see table).
  \param    r <decimal> Post-alignment rotation about the alignment
            vector (in degrees).
  \param    a <integer> Shape axis index to align (0, 1, or 2).

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
module align_axis2v
(
  v,
  t = 0,
  r = 0,
  a = 2
)
{
  pt = vector_get_tp(v);
  pi = vector_get_ip(v);

  pa = acos((pt[2]-pi[2]) / distance_pp(pt, pi));
  aa = atan2(pt[1]-pi[1], pt[0]-pi[0]);

  tv  = (t == 0) ? origin3d
      : (t == 1) ? pi
      : (t == 2) ? (pt+pi)/2
      : (t == 3) ? pt
      : (t == 4) ? pt+pi
      : origin3d;

  rv = (a == 0) ? [[ 0, -90, r], [0, pa, aa]]
     : (a == 1) ? [[90,   0, r], [0, pa, aa]]
     : (a == 2) ? [[ 0,   0, r], [0, pa, aa]]
     : [origin3d, origin3d];

  translate(tv)
  rotate(rv[1])
  rotate(rv[0])
  children();
}

//! @}
//! @}

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
