//! Coordinate systems and conversions.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2017-2024

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

    \amu_define group_name  (Coordinates Systems)
    \amu_define group_brief (Coordinate systems and conversions.)

  \amu_include (include/amu/doxyg_init_pd_gds_ipg.amu)
*******************************************************************************/

// auto-tests (append to test results page)
/***************************************************************************//**
  \amu_include (include/amu/validate_log.amu)
  \amu_include (include/amu/validate_results.amu)
*******************************************************************************/

// group(s) begin (test summary and includes-required)
/***************************************************************************//**
  \amu_include (include/amu/doxyg_define_in_parent_open.amu)
  \amu_include (include/amu/validate_summary.amu)
  \amu_include (include/amu/includes_required.amu)
*******************************************************************************/

// member-wide reference definitions
/***************************************************************************//**
  \amu_define group_references
  (
  )
*******************************************************************************/

// member-wide documentation and conventions
/***************************************************************************//**
  \addtogroup \amu_eval(${group})
  \details
  \anchor \amu_eval(${group})_conventions
  \par Conventions

  \b Parameter \b naming

  - \p c is the coordinate point (or list of coordinate points for
    the scale utility functions) to convert. It has no default and must
    always be supplied by the caller. Its required dimensionality
    depends on the target or source system (see Dimension requirements
    below).
  - \p from identifies the source coordinate system; defaults to
    \ref coordinate_unit_default.
  - \p to identifies the target coordinate system; defaults to
    \ref coordinate_unit_base.
  - \p s is the coordinate system identifier string used in
    \ref coordinate_unit_name. It is distinct from \p c (a numeric
    point) in both type and role; defaults to
    \ref coordinate_unit_default.
  - \p r is a radial scale factor used in the scale utility functions.
  - \p t is a boolean flag in the scale utility functions: \b true
    translates all points to exactly radius \p r; \b false scales
    each point's existing radius by \p r.

  \b Return \b values

  - All conversion functions return \b undef for unrecognised system
    identifiers, for input points of wrong dimensionality, or for
    inputs that are not valid points.

  \b Dimension \b requirements

  - \c "c" (cartesian) accepts both 2d \c [x,y] and 3d \c [x,y,z].
  - \c "p" (polar) requires a 2d point \c [r,aa]; a 3d input returns
    \b undef.
  - \c "y" (cylindrical) and \c "s" (spherical) require a 3d point;
    a 2d input returns \b undef.

  \b Angular \b convention

  - All angular components (\c aa, \c pa) are in degrees.
  - The azimuthal angle \c aa is measured from the positive x-axis
    in the xy-plane. When \ref coordinate_positive_angle is \b true,
    negative azimuthal results are shifted by +360° so that \c aa is
    always in [0°, 360°). This applies to polar, cylindrical, and
    spherical output.
  - The polar angle \c pa (spherical only) is always in [0°, 180°]
    and is not affected by \ref coordinate_positive_angle.
  - When the input point is the origin \c [0,0,0], the polar angle
    \c pa is defined as 0° by convention.

  \b Global \b configuration

  - \ref coordinate_unit_base sets the target system when \p to is
    omitted. Defaults to \c "c". Intended to be overridden at the top
    of a design file or child scope before any coordinate function is
    called.
  - \ref coordinate_unit_default sets the assumed source system when
    \p from or \p s is omitted. Defaults to \c "c".
  - \ref coordinate_positive_angle controls whether negative azimuthal
    angles are normalised to [0°, 360°). Defaults to \b true. Unlike
    \ref coordinate_unit_base and \ref coordinate_unit_default, this
    variable may be changed between individual calls to alter angle
    normalisation on a per-conversion basis.

  These functions allow for geometric points in space to be specified
  using multiple coordinate systems. Some geometric calculations are
  specified more naturally in one or another coordinate system. These
  conversion functions allow for the movement between the most
  convenient for a particular application.

  For more information see Wikipedia on [coordinate system].

  The table below enumerates the supported coordinate systems.

  | system id  | description    | dimensions  | point convention    |
  |:----------:|:--------------:|:-----------:|:-------------------:|
  |  c         | [cartesian]    | 2d or 3d    | [x, y] or [x, y, z] |
  |  p         | [polar]        | 2d          | [r, aa]             |
  |  y         | [cylindrical]  | 3d          | [r, aa, z]          |
  |  s         | [spherical]    | 3d          | [r, aa, pa]         |

  The symbols used in the convention column are as follows:

  | symbol  | description             | units   | reference           |
  |:-------:|:------------------------|:-------:|:-------------------:|
  | x, y, z | coordinate distance     | any     | xyz-axis            |
  | r       | radial distance         | any     | z-axis / xyz-origin |
  | aa      | [azimuthal] angle       | degrees | positive x-axis     |
  | pa      | polar / [zenith] angle  | degrees | positive z-axis     |

  \note The [azimuthal] angle is a measure of the radial vector orthogonal
        projection onto the xy-plane measured from the positive x-axis.
        The polar angle is measured from the z-axis ([zenith]) to the
        radial vector.

  \amu_define title           (Coordinate system base example)
  \amu_define scope_id        (example)
  \amu_define output_scad     (true)
  \amu_define output_console  (false)
  \amu_include (include/amu/scope.amu)

  \amu_define output_scad     (false)
  \amu_define output_console  (true)

  \amu_define title           (coordinate_unit_base=c)
  \amu_define scope_id        (example_c)
  \amu_include (include/amu/scope.amu)

  \amu_define title           (coordinate_unit_base=p)
  \amu_define scope_id        (example_p)
  \amu_include (include/amu/scope.amu)

  \amu_define title           (coordinate_unit_base=y)
  \amu_define scope_id        (example_y)
  \amu_include (include/amu/scope.amu)

  \amu_define title           (coordinate_unit_base=s)
  \amu_define scope_id        (example_s)
  \amu_include (include/amu/scope.amu)

  [coordinate system]: https://en.wikipedia.org/wiki/Coordinate_system
  [cartesian]: https://en.wikipedia.org/wiki/Cartesian_coordinate_system
  [polar]: https://en.wikipedia.org/wiki/Polar_coordinate_system
  [cylindrical]: https://en.wikipedia.org/wiki/Cylindrical_coordinate_system
  [spherical]: https://en.wikipedia.org/wiki/Spherical_coordinate_system
  [azimuthal]: https://en.wikipedia.org/wiki/Azimuth
  [zenith]: https://en.wikipedia.org/wiki/Zenith
*******************************************************************************/

//----------------------------------------------------------------------------//
// members
//----------------------------------------------------------------------------//

//! <string> The base units for value storage.
//! \note This variable is intended to be overridden at the top of a
//!   design file or in a child scope. All coordinate functions that
//!   omit the \p to parameter will convert to this system.
coordinate_unit_base = "c";

//! <string> The default units when unspecified.
//! \note This variable is intended to be overridden at the top of a
//!   design file or in a child scope. All coordinate functions that
//!   omit the \p from or \p s parameter will assume this system.
coordinate_unit_default = "c";

//! <boolean> When converting to angular measures add 360 to negative angles.
//! \note When \b true, any negative azimuthal angle \c aa produced during
//!   conversion is shifted by +360° so that \c aa is always in [0°, 360°).
//!   Applies to polar, cylindrical, and spherical output. May be changed
//!   between individual calls; does not affect the polar angle \c pa.
coordinate_positive_angle = true;

//! Return the name of the given coordinate system identifier.
/***************************************************************************//**
  \param    s <string> A coordinate system identifier.

  \returns  <string> The system name for the given identifier.
            Returns \b undef for identifiers that are not defined.
*******************************************************************************/
function coordinate_unit_name
(
  s = coordinate_unit_default
) = (s == "c") ? "cartesian"
  : (s == "p") ? "polar"
  : (s == "y") ? "cylindrical"
  : (s == "s") ? "spherical"
  : undef;

//! Convert a point from Cartesian to other coordinate systems.
/***************************************************************************//**
  \param    c  <point> A point to convert. Must be 2d for \c "p" output,
               and 3d for \c "y" or \c "s" output. Cartesian \c "c"
               accepts both 2d and 3d.
  \param    to <string> The coordinate system identifier to which the point
               should be converted. Defaults to \ref coordinate_unit_base.

  \returns  <point> The converted result.
            Returns \b undef for identifiers that are not defined, or
            if \p c is not a valid point, or if the dimensionality of
            \p c does not match the requirements of \p to.

  \note     Azimuthal angle normalisation is controlled by
            \ref coordinate_positive_angle.
  \note     For spherical output, when \p c is the origin \c [0,0,0]
            the polar angle \c pa is defined as 0° by convention.

  \private
*******************************************************************************/
function _coordinate_unit_c2
(
  c,
  to = coordinate_unit_base
) = !is_point(c) ? undef

    // cartesian (2d, 3d)
  : (to == "c") ? c

  : let( d = line_dim(c) )

    // polar (2d)
    (to == "p") ? (d != 2) ? undef
    : (
        let
        (
          r   = sqrt(pow(c[0],2) + pow(c[1],2)),
          aa  = atan2(c[1], c[0]),
          aap = ((aa<0) && coordinate_positive_angle) ? aa+360 : aa
        )
        [r, aap]
      )

    // cylindrical (3d)
  : (to == "y") ? (d != 3) ? undef
    : (
        let
        (
          r   = sqrt(pow(c[0],2) + pow(c[1],2)),
          aa  = atan2(c[1], c[0]),
          aap = ((aa<0) && coordinate_positive_angle) ? aa+360 : aa
        )
        [r, aap, c[2]]
      )

    // spherical (3d)
  : (to == "s") ? (d != 3) ? undef
    : (
        let
        (
          r   = sqrt(pow(c[0],2) + pow(c[1],2) + pow(c[2],2)),
          aa  = atan2(c[1], c[0]),
          aap = ((aa<0) && coordinate_positive_angle) ? aa+360 : aa,
          // guard against r==0 (origin): acos(0/0) is undefined; pa=0 by convention
          pa  = (r == 0) ? 0 : acos(c[2] / r)
        )
        [r, aap, pa]
      )

  : undef;

//! Convert a point from some coordinate system to the Cartesian coordinate system.
/***************************************************************************//**
  \param    c    <point> A point to convert. Must be 2d for \c "p" input,
                 and 3d for \c "y" or \c "s" input. Cartesian \c "c"
                 accepts both 2d and 3d.
  \param    from <string> The coordinate system identifier of the point
                 to be converted. Defaults to \ref coordinate_unit_default.

  \returns  <point> The converted result.
            Returns \b undef for identifiers that are not defined, or
            if \p c is not a valid point, or if the dimensionality of
            \p c does not match the requirements of \p from.

  \private
*******************************************************************************/
function _coordinate_unit_2c
(
  c,
  from = coordinate_unit_default
) = !is_point(c) ? undef

    // cartesian (2d, 3d)
  : (from == "c") ? c

  : let( d = line_dim(c) )

    // polar (2d)
    (from == "p") ? (d != 2 ) ? undef
    : (
        let
        (
          x = c[0]*cos(c[1]),
          y = c[0]*sin(c[1])
        )
        [x, y]
      )

    // cylindrical (3d)
  : (from == "y") ? (d != 3 ) ? undef
    : (
        let
        (
          x = c[0]*cos(c[1]),
          y = c[0]*sin(c[1])
        )
        [x, y, c[2]]
      )

    // spherical (3d)
  : (from == "s") ? (d != 3 ) ? undef
    : (
        let
        (
          x = c[0]*sin(c[2])*cos(c[1]),
          y = c[0]*sin(c[2])*sin(c[1]),
          z = c[0]*cos(c[2])
        )
        [x, y, z]
      )
  : undef;

//! Convert a point from one coordinate system to another.
/***************************************************************************//**
  \param    c    <point> A point to convert. Dimensionality must satisfy
                 the requirements of both \p from and \p to.
  \param    from <string> The coordinate system identifier of the point
                 to be converted. Defaults to \ref
                 coordinate_unit_default.
  \param    to   <string> The coordinate system identifier to which the
                 point should be converted. Defaults to \ref
                 coordinate_unit_base.

  \returns  <point> The converted result.
            Returns \b undef for unrecognised identifiers, invalid
            points, or dimensionality mismatches.

  \note     \c "p" requires 2d input; \c "y" and \c "s" require 3d input;
            \c "c" accepts both. See conventions for full details.
*******************************************************************************/
function coordinate
(
  c,
  from = coordinate_unit_default,
  to   = coordinate_unit_base
) = (from == to) ? c
  : let( cc = _coordinate_unit_2c( c, from ) )
    (cc == undef) ? undef
  : _coordinate_unit_c2( cc, to );

//! Convert a point from one coordinate system to another (direction-swapped defaults).
/***************************************************************************//**
  \param    c    <point> A point to convert. Dimensionality must satisfy
                 the requirements of both \p from and \p to.
  \param    from <string> The coordinate system identifier of the point
                 to be converted. Defaults to \ref coordinate_unit_base.
  \param    to   <string> The coordinate system identifier to which the
                 point should be converted. Defaults to
                 \ref coordinate_unit_default.

  \returns  <point> The converted result.
            Returns \b undef for unrecognised identifiers, invalid
            points, or dimensionality mismatches.

  \note     This is a convenience alias for \ref coordinate with \p from
            and \p to defaults swapped. It is useful when the natural
            direction of a design is from the base system back to a
            display or input system.
*******************************************************************************/
function coordinate_inv
(
  c,
  from = coordinate_unit_base,
  to   = coordinate_unit_default
) = coordinate(c=c, from=from, to=to);

//! Radially scale a list of 2d cartesian coordinates.
/***************************************************************************//**
  \param    c <points-2d> A list of cartesian coordinates [[x, y], ...].
  \param    r <decimal> A polar radius.
  \param    t <boolean> Translate or scale radius.

  \returns  <points-2d> A list of scaled cartesian coordinates.

  \details

    When \p t is \b true, all coordinates will terminate on a circle of
    radius \p r. When \p t is \b false, the radius of each coordinate
    is scaled by \p r.
*******************************************************************************/
function coordinate_scale2d_cpc
(
  c,
  r,
  t = false
) =
  [
    for (i = c)
    let (p = coordinate(i, from="c", to="p"))
      coordinate([(t == true) ? r : r*p[0], p[1]], from="p", to="c")
  ];

//! Radially scale and convert a list of 2d polar coordinates to cartesian.
/***************************************************************************//**
  \param    c <points-2d> A list of polar coordinates [[r, aa], ...].
  \param    r <decimal> A polar radius.
  \param    t <boolean> Translate or scale radius.

  \returns  <points-2d> A list of scaled cartesian coordinates.

  \details

    When \p t is \b true, all coordinates will terminate on a circle of
    radius \p r. When \p t is \b false, the radius of each coordinate
    is scaled by \p r.
*******************************************************************************/
function coordinate_scale2d_p2c
(
  c,
  r,
  t = false
) =
  [
    for (i = c)
      coordinate([(t == true) ? r : r*i[0], i[1]], from="p", to="c")
  ];

//! Spherically scale a list of 3d cartesian coordinates.
/***************************************************************************//**
  \param    c <points-3d> A list of cartesian coordinates [[x, y, z], ...].
  \param    r <decimal> A spherical radius.
  \param    t <boolean> Translate or scale radius.

  \returns  <points-3d> A list of scaled cartesian coordinates.

  \details

    When \p t is \b true, all coordinates will terminate on a sphere of
    radius \p r. When \p t is \b false, the radius of each coordinate
    is scaled by \p r.
*******************************************************************************/
function coordinate_scale3d_csc
(
  c,
  r,
  t = false
) =
  [
    for (i = c)
    let (s = coordinate(i, from="c", to="s"))
      coordinate([(t == true) ? r : r*s[0], s[1], s[2]], from="s", to="c")
  ];

//! Spherically scale and convert a list of 3d spherical coordinates to cartesian.
/***************************************************************************//**
  \param    c <points-3d> A list of spherical coordinates [[r, aa, pa], ...].
  \param    r <decimal> A spherical radius.
  \param    t <boolean> Translate or scale radius.

  \returns  <points-3d> A list of scaled cartesian coordinates.

  \details

    When \p t is \b true, all coordinates will terminate on a sphere of
    radius \p r. When \p t is \b false, the radius of each coordinate
    is scaled by \p r.
*******************************************************************************/
function coordinate_scale3d_s2c
(
  c,
  r,
  t = false
) =
  [
    for (i = c)
      coordinate([(t == true) ? r : r*i[0], i[1], i[2]], from="s", to="c")
  ];

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE validate;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <common/validation.scad>;

    echo( str("openscad version ", version()) );
    for (i=[1:7]) echo( "not tested:" );

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_term}.mfs;
    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

/*
BEGIN_SCOPE example;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <units/coordinate.scad>;

    coordinate_unit_base = "c";
    coordinate_unit_default = "p";

    // get unit names
    bu = coordinate_unit_name(coordinate_unit_base);
    du = coordinate_unit_name();

    // absolute coordinates in a specified coordinate system.
    c1 = coordinate([1, 1, 1], "c");
    c2 = coordinate([1, 180]);
    c3 = coordinate([1, 90, -1], "y");
    c4 = coordinate([1, 5, 50], "s");

    // convert between system.
    c5 = coordinate([10*sqrt(2), 45, 45], from="s", to="y");
    c6 = coordinate([sqrt(2), 45], to="c");

    // end_include

    echo( bu=bu );
    echo( du=du );
    echo( );
    echo( c1=c1 );
    echo( c2=c2 );
    echo( c3=c3 );
    echo( c4=c4 );
    echo( c5=c5 );
    echo( c6=c6 );
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_term}.mfs;

    defines   name "system" define "coordinate_unit_base" strings "c p y s";
    variables add_opts_combine "system";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
