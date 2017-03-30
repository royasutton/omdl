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

//! Align a shapes' x, y, or z Cartesian axis to reference line or vector.
/***************************************************************************//**
  \param    rl <line-3d|line-2d> The reference line or vector.
  \param    t <integer> Origin translation along reference line (see table).
  \param    r <decimal> Rotation about the reference line (in degrees).
  \param    d <integer> The Cartesian axis index to align (0, 1, or 2).

  \details

    |  t  | origin translation          |
    |:---:|:----------------------------|
    |  0  |  none                       |
    |  1  |  line initial point         |
    |  2  |  line median point          |
    |  3  |  line termination point     |
    |  4  |  line initial + termination |

    See \ref dt_vectors for argument specification and conventions.
*******************************************************************************/
module align_axis
(
  rl,
  t = 0,
  r = 0,
  d = 2
)
{
  pt = vector_get_tp(rl);
  pi = vector_get_ip(rl);

  pa = acos((pt[2]-pi[2]) / distance_pp(pt, pi));
  aa = atan2(pt[1]-pi[1], pt[0]-pi[0]);

  translate(ciselect([origin3d, pi, (pt+pi)/2, pt, pt+pi, origin3d], t))
  rotate(ciselect([[0, pa, aa], [0, pa, aa], [0, pa, aa], zero3d], d))
  rotate(ciselect([[0, -90, r], [90, 0, r], [0, 0, r], zero3d], d))
  children();
}

//! Align a line to a reference line or vector in Euclidean 2d-space.
/***************************************************************************//**
  \param    l <line-2d> The line or vector to align.
  \param    rl <line-2d> The reference line or vector.

  \param    lp <integer> The line alignment point (see table).
  \param    rp <integer> The reference line alignment point (see table).

  \param    t <vector-3d|vector-2d> Origin translation vector.
  \param    r <decimal-list-1:3|decimal> Origin rotation angle (in degrees).

  \details

    The alignment reference point of the line will be a translated to
    to the reference line alignment line reference. The origin rotation
    is applied prior to the origin translation.

    | lp, rp  | alignment translation |
    |:-------:|:----------------------|
    |  0      | none                  |
    |  1      | initial               |
    |  2      | median                |
    |  3      | termination           |
    |  4      | initial + termination |

    See \ref dt_vectors for argument specification and conventions.
*******************************************************************************/
module align_line2d
(
  l,
  rl = x_axis2d_ul,
  lp = 2,
  rp = 2,
  t  = origin2d,
  r  = zero2d,
)
{
  li = vector_get_ip(l);
  lt = vector_get_tp(l);
  lm = mean([li, lt]);

  ai = vector_get_ip(rl);
  at = vector_get_tp(rl);
  am = mean([ai, at]);

  translate(ciselect([origin2d, ai, am, at, ai+at, am], rp))
  rotate(angle_vv(l, rl))
  translate(t)
  rotate(r)
  translate(-ciselect([origin2d, li, lm, lt, li+lt, lm], lp))
  children();
}

//! @}
//! @}

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
