//! Shape alignment tools.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2017-2019,2026

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

  \amu_include (include/amu/doxyg_init_pd_gds_ipg.amu)
*******************************************************************************/

// group(s) begin (test summary and includes-required)
/***************************************************************************//**
  \amu_include (include/amu/doxyg_define_in_parent_open.amu)
  \amu_include (include/amu/includes_required.amu)
*******************************************************************************/

// member-wide reference definitions
/***************************************************************************//**
  \amu_define group_references
  (
    [line conventions]: \ref data_types_lines
  )
*******************************************************************************/

// member-wide documentation and conventions
/***************************************************************************//**
  \addtogroup \amu_eval(${group})
  \details
  \anchor \amu_eval(${group})_conventions
  \par Conventions

  - Convention list
*******************************************************************************/

//----------------------------------------------------------------------------//
// members
//----------------------------------------------------------------------------//

//! Orient a line or vector to a reference line or vector.
/***************************************************************************//**
  \param    l   <line-3d | line-2d> The line or vector to align.
  \param    r   <line-3d | line-2d> The reference line or vector.

  \param    ar  <decimal> Axial roll about \p r (in degrees).

  \details

    Rotates children so that the direction of \p l is aligned with the
    direction of \p r, then applies an optional axial roll \p ar about
    \p r.  No translation is performed; use align_ll() when translation
    to a specific point along \p r is also required.

    When \p l and \p r are parallel or anti-parallel their cross
    product is the zero vector, which would leave rotate() undefined.
    In that case a perpendicular fallback axis is derived
    automatically: \c cross(ll,x_axis3d_uv) is tried first, then \c
    cross(ll,y_axis3d_uv) if \p l happens to be collinear with the
    x-axis.

    See [line conventions] for more information.

  \amu_eval(${group_references})
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

  ax = cross(ll, lr);

  // When ll and lr are parallel or anti-parallel, cross() returns the zero
  // vector, which makes rotate() undefined. Select a fallback axis that is
  // guaranteed to be perpendicular to ll: try x_axis3d_uv first, then y_axis3d_uv
  // in the degenerate case where ll is itself collinear with x_axis3d_uv.
  ax_fb1  = (norm(ax) > grid_fine) ? ax : cross(ll, x_axis3d_uv);
  ax_safe = (norm(ax_fb1) > grid_fine) ? ax_fb1 : cross(ll, y_axis3d_uv);

  rotate(ar, lr)
  rotate(angle_ll(ll, lr), ax_safe)
  children();
}

//! Align a line or vector to a reference line or vector.
/***************************************************************************//**
  \param    l   <line-3d | line-2d> The line or vector to align.
  \param    r   <line-3d | line-2d> The reference line or vector.

  \param    lp  <integer> The line alignment point (see table).
  \param    rp  <integer> The reference-line alignment point (see table).

  \param    ar  <decimal> Axial roll about \p r (in degrees).

  \param    to  <vector-3d | vector-2d> Translation offset about \p r.
  \param    ro  <decimal-list-1:3 | decimal> Rotation offset about \p r
                (in degrees).

  \param    lpo <point-3d | point-2d> User-supplied alignment point on
                \p l. Used when \p lp is \b 4.
  \param    rpo <point-3d | point-2d> User-supplied alignment point on
                \p r. Used when \p rp is \b 4.

  \details

    The specified alignment point for the line \p l will be translated
    to the specified alignment point for the reference line \p r.

    | lp, rp  | alignment point                   |
    |:-------:|:----------------------------------|
    |  0      | none (no translation)             |
    |  1      | initial                           |
    |  2      | median                            |
    |  3      | termination                       |
    |  4      | user-supplied (\p lpo / \p rpo)   |

    See [line conventions] for more information.

  \amu_eval(${group_references})
*******************************************************************************/
module align_ll
(
  l   = z_axis3d_ul,
  r   = z_axis3d_ul,
  lp  = 0,
  rp  = 0,
  ar  = 0,
  to  = origin3d,
  ro  = zero3d,
  lpo = origin3d,
  rpo = origin3d
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
  translate(select_ci([origin3d, ri, rm, rt, point_to_3d(rpo)], rp))

  // orient and roll line about reference
  rotate(ar, vol_to_origin(lr))
  rotate(angle_ll(ll, lr), cross_ll(ll, lr))

  // apply offsets
  translate(to)
  rotate(ro)

  // translate alignment point
  translate(-select_ci([origin3d, li, lm, lt, point_to_3d(lpo)], lp))
  children();
}

//! Align an objects Cartesian axis to reference line or vector.
/***************************************************************************//**
  \param    a   <integer> The Cartesian axis index to align
                (\b x_axis_ci, \b y_axis_ci, or \b z_axis_ci).
  \param    r   <line-3d | line-2d> The reference line or vector.

  \param    rp  <integer> The reference-line alignment point (see table).

  \param    ar  <decimal> Axial roll about \p r (in degrees).

  \param    to  <vector-3d | vector-2d> Translation offset about \p r.
  \param    ro  <decimal-list-1:3 | decimal> Rotation offset about \p r
                (in degrees).

  \param    rpo <point-3d | point-2d> User-supplied alignment point on
                \p r. Used when \p rp is \b 4.

  \details

    The origin will be translated to the specified alignment point for
    the reference line \p r.  Equivalent to calling align_ll() with \p
    l fixed to the Cartesian axis selected by \p a.

    | rp      | alignment point                   |
    |:-------:|:----------------------------------|
    |  0      | none (no translation)             |
    |  1      | initial                           |
    |  2      | median                            |
    |  3      | termination                       |
    |  4      | user-supplied (\p rpo)            |

    See [line conventions] for more information.

  \amu_eval(${group_references})
*******************************************************************************/
module align_al
(
  a   = z_axis_ci,
  r   = z_axis3d_ul,
  rp  = 0,
  ar  = 0,
  to  = origin3d,
  ro  = zero3d,
  rpo = origin3d
)
{
  assert
  (
    a == x_axis_ci || a == y_axis_ci || a == z_axis_ci,
    "align_al: 'a' must be x_axis_ci (0), y_axis_ci (1), or z_axis_ci (2)"
  );

  ra = select_ci([x_axis3d_ul, y_axis3d_ul, z_axis3d_ul], a);

  align_ll(ra, r, 0, rp, ar, to, ro, origin3d, rpo)
  children();
}

//! @}
//! @}

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
