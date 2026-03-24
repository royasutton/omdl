//! Angle units and conversions.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2015-2024

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

    \amu_define group_name  (Angle Units)
    \amu_define group_brief (Angle units and conversions.)

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

  - \p a is the angle value to convert. It has no default and must
    always be supplied by the caller. It may be a scalar for \c "r"
    or \c "d", or a 3-element list for \c "dms"; the required type
    depends on the source unit.
  - \p from identifies the source unit; defaults to
    \ref angle_unit_default.
  - \p to identifies the target unit; defaults to
    \ref angle_unit_base.
  - \p u is a unit-identifier string used in name-lookup functions;
    defaults to \ref angle_unit_default.

  \b Return \b values

  - All functions return \b undef for unrecognised unit identifiers.
    Callers are responsible for testing return values when inputs may
    be dynamic.
  - The return type matches the target unit: a scalar for \c "r" or
    \c "d", and a 3-element list for \c "dms".

  \b DMS \b format

  - The \c "dms" (degree, minute, second) type is represented as a
    3-element list \c [degrees, minutes, seconds].
  - The sign of the angle is carried exclusively by the \p degrees
    component. The \p minutes and \p seconds components are always
    non-negative. For example, −30°15′20″ is encoded as
    \c [-30, 15, 20].
  - Supplying a \c "dms" value with mixed signs (e.g. \c [-30,-15,0])
    is not supported and produces undefined results.

  \b Global \b configuration

  - \ref angle_unit_base sets the storage base unit for the entire
    design. It defaults to \c "d" and is intended to be overridden
    at the top of a design file or within a child scope before any
    angle function is called.
  - \ref angle_unit_default sets the assumed input unit when \p from
    or \p u is not specified. It also defaults to \c "d".
  - Both variables must be assigned before any angle function is
    called; changing them after dependent assignments have already
    been evaluated has no effect on those prior results.

  \b Unit \b identifiers

  - Unit identifier strings are case-sensitive and lowercase
    (e.g. \c "r", \c "d", \c "dms").

  \b Shorthand \b functions

  - The \c a_deg() and \c a_rad() helpers are convenience wrappers
    that fix \p from to their named unit. The \p to parameter
    defaults to \ref angle_unit_base and may be overridden when a
    non-default target unit is needed.

  These functions allow for angles to be specified with units.
  Angles specified with units are independent of (\ref angle_unit_base).
  There are also unit conversion functions for converting from one unit
  to another.

  The table below enumerates the supported units.

   units id  | description            | type            |
  :---------:|:----------------------:|:---------------:|
   r         | radian                 | decimal         |
   d         | degree                 | decimal         |
   dms       | degree, minute, second | decimal-list-3  |


  \amu_define title           (Angle base unit example)
  \amu_define scope_id        (example)
  \amu_define output_scad     (true)
  \amu_define output_console  (false)
  \amu_include (include/amu/scope.amu)

  \amu_define output_scad     (false)
  \amu_define output_console  (true)

  \amu_define title           (angle_unit_base=r)
  \amu_define scope_id        (example_r)
  \amu_include (include/amu/scope.amu)

  \amu_define title           (angle_unit_base=d)
  \amu_define scope_id        (example_d)
  \amu_include (include/amu/scope.amu)

  \amu_define title           (angle_unit_base=dms)
  \amu_define scope_id        (example_dms)
  \amu_include (include/amu/scope.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// members
//----------------------------------------------------------------------------//

//! <string> The base units for value storage.
//! \note This variable is intended to be overridden at the top of a
//!   design file or in a child scope. All angle functions that omit
//!   the \p to parameter will convert to this unit.
angle_unit_base = "d";

//! <string> The default units when unspecified.
//! \note This variable is intended to be overridden at the top of a
//!   design file or in a child scope. All angle functions that omit
//!   the \p from or \p u parameter will assume this unit.
angle_unit_default = "d";

//! Return the name of an angle unit identifier.
/***************************************************************************//**
  \param    u <string> An angle unit identifier.

  \returns  <string> The units name for the given angle unit identifier.
            Returns \b undef for identifiers that are not defined.
*******************************************************************************/
function angle_unit_name
(
  u = angle_unit_default
) = u == "r"   ? "radian"
  : u == "d"   ? "degree"
  : u == "dms" ? "degree, minute, second"
  : undef;

//! Convert an angle from degrees to other units.
/***************************************************************************//**
  \param    a  <decimal | decimal-list-3> An angle to convert.
  \param    to <string> The units to which the angle should be converted.
               Defaults to \ref angle_unit_base.

  \returns  <decimal | decimal-list-3> The conversion result.
            Returns \b undef for identifiers that are not defined. For
            \c "dms" output the sign is carried by the degrees
            component only; minutes and seconds are always
            non-negative.

  \note     The radian conversion uses \c tau (= 2π), which is defined
            in the omdl base library (\c omdl-base.scad).

  \private
*******************************************************************************/
function _angle_unit_d2
(
  a,
  to = angle_unit_base
) = to == "r"   ? (a * tau / 360)
  : to == "d"   ? (a)
  : to == "dms" ?
      // use abs(a) so floor() behaves correctly for negative angles;
      // sign is preserved on the degrees component only
      let
      (
        sign = (a < 0) ? -1 : 1,
        aa   = abs(a),
        deg  = floor(aa),
        min  = floor((aa - deg) * 60),
        sec  = (aa - deg - min/60) * 3600
      )
      [ sign * deg, min, sec ]
  : undef;

//! Convert an angle from some units to degrees.
/***************************************************************************//**
  \param    a    <decimal | decimal-list-3> An angle to convert.
  \param    from <string> The units of the angle to be converted.
                 Defaults to \ref angle_unit_default.

  \returns  <decimal> The conversion result in degrees.
            Returns \b undef for identifiers that are not defined. For
            \c "dms" input the sign must be on the degrees component
            only; minutes and seconds must be non-negative.

  \note     The radian conversion uses \c tau (= 2π), which is defined
            in the omdl base library (\c omdl-base.scad).

  \private
*******************************************************************************/
function _angle_unit_2d
(
  a,
  from = angle_unit_default
) = from == "r"   ? (a * 360 / tau)
  : from == "d"   ? (a)
  : from == "dms" ?
      // sign lives on the degrees component only; minutes and seconds
      // are always non-negative magnitudes
      let( sign = (a[0] < 0) ? -1 : 1, adeg = abs(a[0]) )
      sign * (adeg + a[1]/60 + a[2]/3600)
  : undef;

//! Convert an angle value from one unit to another.
/***************************************************************************//**
  \param    a    <decimal | decimal-list-3> The angle to convert.
  \param    from <string> The units of the angle to be converted.
                 Defaults to \ref angle_unit_default.
  \param    to   <string> The units to which the angle should be converted.
                 Defaults to \ref angle_unit_base. Conversion to \c "d"
                 is short-circuited: the intermediate d to step is
                 skipped.

  \returns  <decimal | decimal-list-3> The conversion result. Return
            type is a scalar for \c "r" or \c "d", and a 3-element list
            for \c "dms". Returns \b undef for identifiers that are not
            defined.
*******************************************************************************/
function angle
(
  a,
  from = angle_unit_default,
  to   = angle_unit_base
) = (from == to) ? a
  : let( d = _angle_unit_2d( a, from ) )
    (d == undef) ? undef
    // short-circuit: 2d result is already the answer when target is degrees
  : (to == "d") ? d
  : _angle_unit_d2( d, to );

//! Convert an angle value from one unit to another (direction-swapped defaults).
/***************************************************************************//**
  \param    a    <decimal | decimal-list-3> The angle to convert.
  \param    from <string> The units of the angle to be converted.
                 Defaults to \ref angle_unit_base.
  \param    to   <string> The units to which the angle should be converted.
                 Defaults to \ref angle_unit_default.

  \returns  <decimal | decimal-list-3> The conversion result. Return type
            is a scalar for \c "r" or \c "d", and a 3-element list for
            \c "dms". Returns \b undef for identifiers that are not
            defined.

  \note     This is a convenience alias for \ref angle with \p from and
            \p to defaults swapped. It is useful when the natural
            direction of a design is from the base unit back to a
            display or input unit.
*******************************************************************************/
function angle_inv
(
  a,
  from = angle_unit_base,
  to   = angle_unit_default
) = angle(a=a, from=from, to=to);

//----------------------------------------------------------------------------//
// shorthand conversions
//----------------------------------------------------------------------------//

//! \name Shorts
//! @{
//!
//! Convenience wrappers around \ref angle that fix the \p from unit
//! to a named unit. The \p to parameter defaults to \ref angle_unit_base
//! and may be overridden when a non-default target unit is needed.
//! Use \ref angle directly when the source unit is also non-default.

//! Shorthand angle conversion for degrees.
/***************************************************************************//**
  \param    a  <decimal> The angle to convert.
  \param    to <string> The units to which the angle should be converted.
               Defaults to \ref angle_unit_base.

  \returns  <decimal> The conversion result.
*******************************************************************************/
function a_deg(a, to=angle_unit_base) = angle(a=a, from="d", to=to);

//! Shorthand angle conversion for radians.
/***************************************************************************//**
  \param    a  <decimal> The angle to convert.
  \param    to <string> The units to which the angle should be converted.
               Defaults to \ref angle_unit_base.

  \returns  <decimal> The conversion result.
*******************************************************************************/
function a_rad(a, to=angle_unit_base) = angle(a=a, from="r", to=to);

//! @}

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
    for (i=[1:3]) echo( "not tested:" );

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

    angle_unit_base = "d";
    angle_unit_default = "r";

    // get unit names
    bu = angle_unit_name(angle_unit_base);
    du = angle_unit_name();

    // absolute angle measurements in base unit.
    c1 = angle(pi/6);
    c2 = angle(pi/4);
    c3 = angle(180, "d");
    c4 = angle([30, 15, 50], "dms");

    // convert between units.
    c5 = angle([30, 15, 50], from="dms", to="r");
    c6 = angle(0.528205, to="dms");

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

    defines   name "units" define "angle_unit_base" strings "r d dms";
    variables add_opts_combine "units";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
