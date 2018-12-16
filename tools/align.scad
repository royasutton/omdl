//! Shape alignment tools.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2017-2018

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

    \amu_define group_name  (Alignment)
    \amu_define group_brief (Shape alignment tools.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
*******************************************************************************/

include <../math/math-base.scad>;

//----------------------------------------------------------------------------//
// group.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//! Orient a line or vector to a reference line or vector.
/***************************************************************************//**
  \param    l <line-3d|line-2d> The line or vector to align.
  \param    rl <line-3d|line-2d> The reference line or vector.

  \param    r <decimal> Roll about axis \p rl (in degrees).

  \details

    See \ref dt_line for argument specification and conventions.
*******************************************************************************/
module orient_ll
(
  l  = z_axis3d_ul,
  rl = z_axis3d_ul,
  r  = 0
)
{
  ll = line_move2origin(l);
  lr = line_move2origin(rl);

  rotate(r, lr)
  rotate(angle_ll(ll, lr), cross(ll, lr))
  children();
}

//! Align a line or vector to a reference line or vector.
/***************************************************************************//**
  \param    l <line-3d|line-2d> The line or vector to align.
  \param    rl <line-3d|line-2d> The reference line or vector.

  \param    ap <integer> The line alignment point (see table).
  \param    rp <integer> The reference-line alignment point (see table).

  \param    r <decimal> Roll about axis \p rl (in degrees).

  \param    to <vector-3d|vector-2d> Translation offset about \p rl.
  \param    ro <decimal-list-1:3|decimal> Rotation offset about \p rl
            (in degrees).

  \details

    The specified alignment point for the line \p l will be a translated
    to the specified alignment point for the reference line \p rl.

    | ap, rp  | alignment point       |
    |:-------:|:----------------------|
    |  0      | none (no translation) |
    |  1      | initial               |
    |  2      | median                |
    |  3      | termination           |
    |  4      | initial + termination |

    See \ref dt_line for argument specification and conventions.
*******************************************************************************/
module align_ll
(
  l  = z_axis3d_ul,
  rl = z_axis3d_ul,
  ap = 0,
  rp = 0,
  r  = 0,
  to = origin3d,
  ro = zero3d
)
{
  li = dimension_2to3_v(line_get_ip( l));
  lt = dimension_2to3_v(line_get_tp( l));

  ri = dimension_2to3_v(line_get_ip(rl));
  rt = dimension_2to3_v(line_get_tp(rl));

  ll = [li, lt];
  lm = mean(ll);

  lr = [ri, rt];
  rm = mean(lr);

  // translate reference
  translate(ciselect([origin3d, ri, rm, rt, ri+rt, rm], rp))

  // orient and roll line about reference
  rotate(r, line_move2origin(lr))
  rotate(angle_ll(ll, lr), cross_ll(ll, lr))

  // apply offsets
  translate(to)
  rotate(ro)

  // translate alignment point
  translate(-ciselect([origin3d, li, lm, lt, li+lt, lm], ap))
  children();
}

//! Align a shapes' x, y, or z Cartesian axis to reference line or vector.
/***************************************************************************//**
  \param    rl <line-3d|line-2d> The reference line or vector.

  \param    rp <integer> The reference-line alignment point (see table).

  \param    r <decimal> Roll about axis \p rl (in degrees).

  \param    to <vector-3d|vector-2d> Translation offset about \p rl.
  \param    ro <decimal-list-1:3|decimal> Rotation offset about \p rl
            (in degrees).

  \param    d <integer> The Cartesian axis index to align (0, 1, or 2).

  \details

    The origin will be a translated to the specified alignment point
    for the reference line \p rl.

    | rp      | alignment point       |
    |:-------:|:----------------------|
    |  0      | none (no translation) |
    |  1      | initial               |
    |  2      | median                |
    |  3      | termination           |
    |  4      | initial + termination |

    See \ref dt_line for argument specification and conventions.
*******************************************************************************/
module align_l
(
  rl = z_axis3d_ul,
  rp = 0,
  r  = 0,
  to = origin3d,
  ro = zero3d,
  d  = z_axis_ci
)
{
  ra = ciselect([x_axis3d_ul, y_axis3d_ul, z_axis3d_ul], d);

  align_ll(ra, rl, 0, rp, r, to, ro)
  children();
}

//! @}
//! @}

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
