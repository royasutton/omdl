//! Angle units and conversions.
/***************************************************************************//**
  \file   units_angle.scad
  \author Roy Allen Sutton
  \date   2015-2017

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

  \ingroup units units_angle
*******************************************************************************/

include <../constants.scad>;

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \addtogroup units
  @{

  \defgroup units_angle Angles
  \brief    Angle units and conversions.

  \details

    These functions allow for angles to be specified with units.
    Angles specified with units are independent of (\ref base_unit_angle).
    There are also unit conversion functions for converting from one unit
    to another.

    The table below enumerates the supported units.

     units id  | description            | type            |
    :---------:|:----------------------:|:---------------:|
     r         | radian                 | decimal         |
     d         | degree                 | decimal         |
     dms       | degree, minute, second | decimal-list-3  |

    \b Example

      \dontinclude units_angle_example.scad
      \skip include
      \until to="dms");

    \b Result (base_angle_length = \b r):  \include units_angle_example_r.log
    \b Result (base_angle_length = \b d):  \include units_angle_example_d.log
    \b Result (base_angle_length = \b dms): \include units_angle_example_dms.log

  @{
*******************************************************************************/
//----------------------------------------------------------------------------//

//! <string> The base units for angle measurements.
base_unit_angle = "d";

//! Return the name of an angle unit identifier.
/***************************************************************************//**
  \param    u <string> An angle unit identifier.

  \returns  <string> The units name for the given angle unit identifier.
            Returns \b undef for identifiers that are not defined.
*******************************************************************************/
function unit_angle_name
(
  u = base_unit_angle
) = u == "r"   ? "radian"
  : u == "d"   ? "degree"
  : u == "dms" ? "degree, minute, second"
  : undef;

//! Convert an angle from degrees to other units.
/***************************************************************************//**
  \param    a <decimal|decimal-list-3> An angle to convert.
  \param    to <string> The units to which the angle should be converted.

  \returns  <decimal|decimal-list-3> The conversion result.
            Returns \b undef for identifiers that are not defined.

  \private
*******************************************************************************/
function unit_angle_d_to
(
  a,
  to
) = to == "r"    ? (a * tau / 360)
  : to == "d"    ? (a)
  : to == "dms"  ? ([
                      floor(a),
                      floor((a - floor(a)) * 60),
                      (a - floor(a) - floor((a - floor(a)) * 60) / 60) * 3600
                   ])
  : undef;

//! Convert an angle from some units to degrees.
/***************************************************************************//**
  \param    a <decimal|decimal-list-3> An angle to convert.
  \param    from <string> The units of the angle to be converted.

  \returns  <decimal|decimal-list-3> The conversion result.
            Returns \b undef for identifiers that are not defined.
  \private
*******************************************************************************/
function unit_angle_to_d
(
  a,
  from
) = from == "r"    ? (a * 360 / tau)
  : from == "d"    ? (a)
  : from == "dms"  ? (a[0] + a[1]/60 + a[2]/3600)
  : undef;

//! Convert an angle from some units to another.
/***************************************************************************//**
  \param    a <decimal|decimal-list-3> An angle to convert.
  \param    from <string> The units of the angle to be converted.
  \param    to <string> A units to which the angle should be converted.

  \returns  <decimal|decimal-list-3> The conversion result.
            Returns \b undef for identifiers that are not defined.
*******************************************************************************/
function convert_angle
(
  a,
  from = base_unit_angle,
  to   = base_unit_angle
) = unit_angle_d_to( unit_angle_to_d( a, from ), to );

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE example;
  BEGIN_OPENSCAD;
    include <units/units_angle.scad>;

    base_unit_angle = "d";

    // get base unit name
    un = unit_angle_name();

    // absolute angle measurements in base unit.
    c1 = convert_angle(pi/6, "r");
    c2 = convert_angle(pi/4, "r");
    c3 = convert_angle(180, "d");
    c4 = convert_angle([30, 15, 50], "dms");

    // convert between units.
    c5 = convert_angle([30, 15, 50], from="dms", to="r");
    c6 = convert_angle(0.528205, from="r", to="dms");

    echo( un=un );
    echo( c1=c1 );
    echo( c2=c2 );
    echo( c3=c3 );
    echo( c4=c4 );
    echo( c5=c5 );
    echo( c6=c6 );
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {config_base,config_csg}.mfs;

    defines   name "units" define "base_unit_angle" strings "r d dms";
    variables add_opts_combine "units";

    include --path "${INCLUDE_PATH}" script_std.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
