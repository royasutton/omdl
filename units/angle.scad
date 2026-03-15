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

  /+
  \anchor \amu_eval(${group})_conventions
  \par Conventions

  - Convention list
  +/

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


  \amu_define title (Angle base unit example)
  \amu_define scope_id (example)
  \amu_define output_scad (true)
  \amu_define output_console (false)
  \amu_include (include/amu/scope.amu)

  \amu_define output_scad (false)
  \amu_define output_console (true)

  \amu_define title (angle_unit_base=r)
  \amu_define scope_id (example_r)
  \amu_include (include/amu/scope.amu)

  \amu_define title (angle_unit_base=d)
  \amu_define scope_id (example_d)
  \amu_include (include/amu/scope.amu)

  \amu_define title (angle_unit_base=dms)
  \amu_define scope_id (example_dms)
  \amu_include (include/amu/scope.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// members
//----------------------------------------------------------------------------//

//! <string> The base units for value storage.
angle_unit_base = "d";

//! <string> The default units when unspecified.
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
  \param    a <decimal | decimal-list-3> An angle to convert.
  \param    to <string> The units to which the angle should be converted.

  \returns  <decimal | decimal-list-3> The conversion result.
            Returns \b undef for identifiers that are not defined.

  \private
*******************************************************************************/
function _angle_unit_d2
(
  a,
  to
) = to == "r"   ? (a * tau / 360)
  : to == "d"   ? (a)
  : to == "dms" ?
      // use abs(a) so floor() behaves correctly for negative angles;
      // sign is preserved on the degrees component only
      let(
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
  \param    a <decimal | decimal-list-3> An angle to convert.
  \param    from <string> The units of the angle to be converted.

  \returns  <decimal | decimal-list-3> The conversion result.
            Returns \b undef for identifiers that are not defined.
  \private
*******************************************************************************/
function _angle_unit_2d
(
  a,
  from
) = from == "r"   ? (a * 360 / tau)
  : from == "d"   ? (a)
  : from == "dms" ?
      // sign lives on the degrees component only; minutes and seconds
      // are always non-negative magnitudes
      let( sign = (a[0] < 0) ? -1 : 1 )
      sign * (abs(a[0]) + a[1]/60 + a[2]/3600)
  : undef;

//! Convert an angle from some units to another.
/***************************************************************************//**
  \param    a <decimal | decimal-list-3> An angle to convert.
  \param    from <string> The units of the angle to be converted.
  \param    to <string> A units to which the angle should be converted.

  \returns  <decimal | decimal-list-3> The conversion result.
            Returns \b undef for identifiers that are not defined.
*******************************************************************************/
function angle
(
  a,
  from = angle_unit_default,
  to   = angle_unit_base
) = (from == to) ? a
  : let( d = _angle_unit_2d( a, from ) )
    (d == undef) ? undef
  : _angle_unit_d2( d, to );

//! Convert an angle from some units to another.
/***************************************************************************//**
  \param    a <decimal | decimal-list-3> An angle to convert.
  \param    from <string> The units of the angle to be converted.
  \param    to <string> A units to which the angle should be converted.

  \returns  <decimal | decimal-list-3> The conversion result.
            Returns \b undef for identifiers that are not defined.
*******************************************************************************/
function angle_inv
(
  a,
  from = angle_unit_base,
  to   = angle_unit_default
) = (from == to) ? a
  : let( d = _angle_unit_2d( a, from ) )
    (d == undef) ? undef
  : _angle_unit_d2( d, to );

//----------------------------------------------------------------------------//
// shorthand conversions
//----------------------------------------------------------------------------//

//! \name Shorts
//! @{

//! Shorthand angle conversion for degrees.
/***************************************************************************//**
  \param    a <decimal> The angle to convert.

  \returns  <decimal> The conversion result.
*******************************************************************************/
function a_deg(a) = angle(a=a, from="d");

//! Shorthand angle conversion for radians.
/***************************************************************************//**
  \param    a <decimal> The angle to convert.

  \returns  <decimal> The conversion result.
*******************************************************************************/
function a_rad(a) = angle(a=a, from="r");

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
