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

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_include (include/amu/includes_required.amu)

  \details

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

    \amu_define title (Coordinate system base example)
    \amu_define scope_id (example)
    \amu_define output_scad (true)
    \amu_define output_console (false)
    \amu_include (include/amu/scope.amu)

    \amu_define output_scad (false)
    \amu_define output_console (true)

    \amu_define title (coordinate_unit_base=c)
    \amu_define scope_id (example_c)
    \amu_include (include/amu/scope.amu)

    \amu_define title (coordinate_unit_base=p)
    \amu_define scope_id (example_p)
    \amu_include (include/amu/scope.amu)

    \amu_define title (coordinate_unit_base=y)
    \amu_define scope_id (example_y)
    \amu_include (include/amu/scope.amu)

    \amu_define title (coordinate_unit_base=s)
    \amu_define scope_id (example_s)
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

//! <string> The base units for value storage.
coordinate_unit_base = "c";

//! <string> The default units when unspecified.
coordinate_unit_default = "c";

//! <boolean> When converting to angular measures add 360 to negative angles.
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
  \param    c <point> A point to convert.
  \param    to <string> The coordinate system identifier to which the point
            should be converted.

  \returns  <point> The converted result.
            Returns \b undef for identifiers that are not defined.

  \private
*******************************************************************************/
function coordinate_unit_c2
(
  c,
  to
) = !is_point(c) ? undef

    // cartesian (2d, 3d)
  : (to == "c") ? c

  : let( d = line_dim(c) )

    // polar (2d)
    (to == "p") ? (d != 2 ) ? undef
    : (
        let
        (
          r   = sqrt(pow(c[0],2) + pow(c[1],2)),
          aa  = atan2(c[1], c[0]),
          aap = ((aa<0) && (coordinate_positive_angle==true)) ? aa+360 : aa
        )
        [r, aap]
      )

    // cylindrical (3d)
  : (to == "y") ? (d != 3 ) ? undef
    : (
        let
        (
          r   = sqrt(pow(c[0],2) + pow(c[1],2)),
          aa  = atan2(c[1], c[0]),
          aap = ((aa<0) && (coordinate_positive_angle==true)) ? aa+360 : aa,
          z   = (c[2] !=undef) ? c[2] : 0
        )
        [r, aap, z]
      )

    // spherical (3d)
  : (to == "s") ? (d != 3 ) ? undef
    : (
        let
        (
          r   = sqrt(pow(c[0],2) + pow(c[1],2) + pow(c[2],2)),
          aa  = atan2(c[1], c[0]),
          aap = ((aa<0) && (coordinate_positive_angle==true)) ? aa+360 : aa,
          pa  = acos(c[2] / r)
        )
        [r, aap, pa]
      )

  : undef;

//! Convert a point from some coordinate system to the Cartesian coordinate system.
/***************************************************************************//**
  \param    c <point> A point to convert.
  \param    from <string> The coordinate system identifier of the point
            to be converted.

  \returns  <point> The converted result.
            Returns \b undef for identifiers that are not defined.

  \private
*******************************************************************************/
function coordinate_unit_2c
(
  c,
  from
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
          y = c[0]*sin(c[1]),
          z = (c[2] != undef) ? c[2] : 0
        )
        [x, y, z]
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

//! Convert point from one coordinate system to another.
/***************************************************************************//**
  \param    c <point> A point to convert.
  \param    from <string> The coordinate system identifier of the point
            to be converted.
  \param    to <string> The coordinate system identifier to which the point
            should be converted.

  \returns  <point> The converted result.
            Returns \b undef for identifiers that are not defined.
*******************************************************************************/
function coordinate
(
  c,
  from = coordinate_unit_default,
  to   = coordinate_unit_base
) = (from == to) ? c
  : coordinate_unit_c2( coordinate_unit_2c( c, from ), to );

//! Convert point from one coordinate system to another.
/***************************************************************************//**
  \param    c <point> A point to convert.
  \param    from <string> The coordinate system identifier of the point
            to be converted.
  \param    to <string> The coordinate system identifier to which the point
            should be converted.

  \returns  <point> The converted result.
            Returns \b undef for identifiers that are not defined.
*******************************************************************************/
function coordinate_inv
(
  c,
  from = coordinate_unit_base,
  to   = coordinate_unit_default
) = (from == to) ? c
  : coordinate_unit_c2( coordinate_unit_2c( c, from ), to );

//! Radially scale a list of 2d cartesian coordinates.
/***************************************************************************//**
  \param    c <coords-2d> A list of cartesian coordinates [[x, y], ...].
  \param    r <decimal> A polar radius.
  \param    t <boolean> Translate or scale radius.

  \returns  <coords-2d> A list of scaled cartesian coordinates.

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
  \param    c <coords-2d> A list of polar coordinates [[r, aa], ...].
  \param    r <decimal> A polar radius.
  \param    t <boolean> Translate or scale radius.

  \returns  <coords-2d> A list of scaled cartesian coordinates.

  \details

    When \p t is \b true, all coordinates will terminate on a circle of
    radius \p r. When \p t is \b false, the radius of each coordinate
    is scaled by \p r.
*******************************************************************************/
function coordinate_scale2d_p2c
(
  p,
  r,
  t = false
) =
  [
    for (i = p)
      coordinate([(t == true) ? r : r*i[0], i[1]], from="p", to="c")
  ];

//! Spherically scale a list of 3d cartesian coordinates.
/***************************************************************************//**
  \param    c <coords-3d> A list of cartesian coordinates [[x, y, z], ...].
  \param    r <decimal> A spherical radius.
  \param    t <boolean> Translate or scale radius.

  \returns  <coords-3d> A list of scaled cartesian coordinates.

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
  \param    c <coords-3d> A list of spherical coordinates [[r, aa, pa], ...].
  \param    r <decimal> A spherical radius.
  \param    t <boolean> Translate or scale radius.

  \returns  <coords-3d> A list of scaled cartesian coordinates.

  \details

    When \p t is \b true, all coordinates will terminate on a sphere of
    radius \p r. When \p t is \b false, the radius of each coordinate
    is scaled by \p r.
*******************************************************************************/
function coordinate_scale3d_s2c
(
  s,
  r,
  t = false
) =
  [
    for (i = s)
      coordinate([(t == true) ? r : r*i[0], i[1], i[2]], from="s", to="c")
  ];

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

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
