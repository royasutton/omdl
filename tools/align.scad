//! Shape alignment tools.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2017-2019

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

//----------------------------------------------------------------------------//
// group.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_include (include/amu/includes_required.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//! Orient a line or vector to a reference line or vector.
/***************************************************************************//**
  \param    l <line-3d | line-2d> The line or vector to align.
  \param    r <line-3d | line-2d> The reference line or vector.

  \param    ar <decimal> Axial roll about \p r (in degrees).

  \details

    See \ref dt_line for argument specification and conventions.
*******************************************************************************/
module orient_ll
(
  l  = z_axis3d_ul,
  r  = z_axis3d_ul,
  ar = 0
)
{
  ll = vol_to_origin(l);
  lr = vol_to_origin(r);

  rotate(ar, lr)
  rotate(angle_ll(ll, lr), cross(ll, lr))
  children();
}

//! Align a line or vector to a reference line or vector.
/***************************************************************************//**
  \param    l <line-3d | line-2d> The line or vector to align.
  \param    r <line-3d | line-2d> The reference line or vector.

  \param    lp <integer> The line alignment point (see table).
  \param    rp <integer> The reference-line alignment point (see table).

  \param    ar <decimal> Axial roll about \p r (in degrees).

  \param    to <vector-3d | vector-2d> Translation offset about \p r.
  \param    ro <decimal-list-1:3 | decimal> Rotation offset about \p r
            (in degrees).

  \details

    The specified alignment point for the line \p l will be a translated
    to the specified alignment point for the reference line \p r.

    | lp, rp  | alignment point       |
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
  r  = z_axis3d_ul,
  lp = 0,
  rp = 0,
  ar = 0,
  to = origin3d,
  ro = zero3d
)
{
  li = point_to_3d(line_ip(l));
  lt = point_to_3d(line_tp(l));

  ri = point_to_3d(line_ip(r));
  rt = point_to_3d(line_tp(r));

  ll = [li, lt];
  lm = mean(ll);

  lr = [ri, rt];
  rm = mean(lr);

  // translate reference
  translate(select_ci([origin3d, ri, rm, rt, ri+rt, rm], rp))

  // orient and roll line about reference
  rotate(ar, vol_to_origin(lr))
  rotate(angle_ll(ll, lr), cross_ll(ll, lr))

  // apply offsets
  translate(to)
  rotate(ro)

  // translate alignment point
  translate(-select_ci([origin3d, li, lm, lt, li+lt, lm], lp))
  children();
}

//! Align an objects Cartesian axis to reference line or vector.
/***************************************************************************//**
  \param    a <integer> The Cartesian axis index to align
            (\b x_axis_ci, \b y_axis_ci, or \b z_axis_ci).
  \param    r <line-3d | line-2d> The reference line or vector.

  \param    rp <integer> The reference-line alignment point (see table).

  \param    ar <decimal> Axial roll about \p r (in degrees).

  \param    to <vector-3d | vector-2d> Translation offset about \p r.
  \param    ro <decimal-list-1:3 | decimal> Rotation offset about \p r
            (in degrees).

  \details

    The origin will be a translated to the specified alignment point
    for the reference line \p r.

    | rp      | alignment point       |
    |:-------:|:----------------------|
    |  0      | none (no translation) |
    |  1      | initial               |
    |  2      | median                |
    |  3      | termination           |
    |  4      | initial + termination |

    See \ref dt_line for argument specification and conventions.
*******************************************************************************/
module align_al
(
  a  = z_axis_ci,
  r  = z_axis3d_ul,
  rp = 0,
  ar = 0,
  to = origin3d,
  ro = zero3d
)
{
  ra = select_ci([x_axis3d_ul, y_axis3d_ul, z_axis3d_ul], a);

  align_ll(ra, r, 0, rp, ar, to, ro)
  children();
}

//! @}
//! @}

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
