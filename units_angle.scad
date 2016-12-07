//! Angle units and conversions.
/***************************************************************************//**
  \file   units_angle.scad
  \author Roy Allen Sutton
  \date   2015-2016

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

  \note Include this library file using the \b include statement.

  \ingroup units units_angle
*******************************************************************************/

include <constants.scad>;

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \addtogroup units
  @{

  \defgroup units_angle Angle
  \brief    Angle units and conversions.

  \details

    These functions allow for angles to be specified with units.
    Angles specified with units are independent of (\ref base_unit_angle).
    There are also unit conversion functions for converting from one unit
    to another.

    The table below enumerates the supported unit identifiers and their
    descriptions.

     units id  | description
    :---------:|:----------------------:
     r         | radian
     d         | degree
     dms       | degree, minute, second

    \b Example

      \dontinclude units_angle_example.scad
      \skip include
      \until to="dms");

    result (base_angle_length = \b r):  \include units_angle_example_r.log
    result (base_angle_length = \b d):  \include units_angle_example_d.log
    result (base_angle_length = \b dms): \include units_angle_example_dms.log

  @{
*******************************************************************************/
//----------------------------------------------------------------------------//

//! <string> Base unit for angle measurements.
base_unit_angle = "d";

//! Return the name of the given angle \p unit identifier.
/***************************************************************************//**
  \param    units <string> An angle unit identifier.
  \returns  <string> The units name for the given angle unit identifier.
            Returns \b 'undef' for identifiers that are not defined.
*******************************************************************************/
function unit_angle_name
(
  units = base_unit_angle
) = units == "r"   ? "radian"
  : units == "d"   ? "degree"
  : units == "dms" ? "degree, minute, second"
  : undef;

//! Convert the \p angle from degrees to \p to units.
/***************************************************************************//**
  \param    angle <decimal|vector> An angle to convert (dms angles are
            3-tuple vector [d, m, s]).
  \param    to <string> The units to which the angle should be converted.
  \returns  <decimal|vector> The conversion result (dms angles are
            3-tuple vector [d, m, s]). Returns \b 'undef' for identifiers
            that are not defined.
  \private
*******************************************************************************/
function unit_angle_d_to
(
  angle,
  to
) = to == "r"    ? ( angle * tau / 360 )
  : to == "d"    ? ( angle )
  : to == "dms"  ? ( [ floor(angle),
                       floor( ( angle - floor(angle) ) * 60 ),
                       ( angle
                         - floor(angle)
                         - floor( ( angle - floor(angle) ) * 60 ) / 60 ) * 3600
                     ] )
  : undef;

//! Convert the \p angle from \p from units to degrees.
/***************************************************************************//**
  \param    angle <decimal|vector> An angle to convert (dms angles are
            3-tuple vector [d, m, s]).
  \param    from <string> The units of the angle to be converted.
  \returns  <decimal|vector> The conversion result (dms angles are
            3-tuple vector [d, m, s]). Returns \b 'undef' for identifiers
            that are not defined.
  \private
*******************************************************************************/
function unit_angle_to_d
(
  angle,
  from
) = from == "r"    ? ( angle * 360 / tau )
  : from == "d"    ? ( angle )
  : from == "dms"  ? ( angle[0] + angle[1]/60 + angle[2]/3600 )
  : undef;

//! Convert the \p angle from \p from units to \p to units.
/***************************************************************************//**
  \param    angle <decimal|vector> An angle to convert (dms angles are
            3-tuple vector [d, m, s]).
  \param    from <string> The units of the angle to be converted.
  \param    to <string> A units to which the angle should be converted.
  \returns  <decimal|vector> The conversion result (dms angles are
            3-tuple vector [d, m, s]). Returns \b 'undef' for identifiers
            that are not defined.
*******************************************************************************/
function convert_angle
(
  angle,
  from = base_unit_angle,
  to   = base_unit_angle
) = unit_angle_d_to( unit_angle_to_d( angle, from ), to );

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE example;
  BEGIN_OPENSCAD;
    include <units_angle.scad>;

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
