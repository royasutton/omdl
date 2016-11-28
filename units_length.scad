//! Length units and conversions.
/***************************************************************************//**
  \file   units_length.scad
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

  \ingroup units units_length
*******************************************************************************/

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \addtogroup units
  @{

  \defgroup units_length Length
  \brief    Length units and conversions.

  \details

    These functions allow for lengths to be specified with units.
    Lengths specified with units are independent of (\ref base_unit_length).
    There are also unit conversion functions for converting from one unit
    to another.

    The table below enumerates the supported unit identifiers and their
    descriptions.

     units id  | description
    :---------:|:----------------------:
     pm        | picometer
     nm        | nanometer
     um        | micrometer
     mm        | millimeter
     cm        | centimeter
     dm        | decimeter
      m        | meter
     km        | kilometer
     thou, mil | thousandth of an inch
     in        | inch
     ft        | feet
     yd        | yard
     mi        | mile

    \b Example

      \dontinclude units_length_example.scad
      \skip include
      \until to="mm");

    result (base_unit_length = \b mm):  \include units_length_example_mm.log
    result (base_unit_length = \b cm):  \include units_length_example_cm.log
    result (base_unit_length = \b mil): \include units_length_example_mil.log
    result (base_unit_length = \b in):  \include units_length_example_in.log

    \b Example (equivalent lengths)

    \image html  units_length_dim_qvga_top.png "Unit Lengths"
    \image latex units_length_dim_qvga_top.eps "Unit Lengths" width=4in

  @{
*******************************************************************************/
//----------------------------------------------------------------------------//

//! <string> Base unit for length measurements.
base_unit_length = "mm";

//! Return the name of the given length \p unit identifier.
/***************************************************************************//**
  \param    units <string> A length unit identifier.
  \returns  <string> The units name for the given length unit identifier.
            Returns \b 'undef' for identifiers that are not defined.
  \private
*******************************************************************************/
function unit_length_name_id_lookup
(
  units = base_unit_length
) = units == "pm"   ? "picometer"
  : units == "nm"   ? "nanometer"
  : units == "um"   ? "micrometer"
  : units == "mm"   ? "millimeter"
  : units == "cm"   ? "centimeter"
  : units == "dm"   ? "decimeter"
  : units ==  "m"   ? "meter"
  : units == "km"   ? "kilometer"
  : units == "thou" ? "thousandth"
  : units == "mil"  ? "thousandth"
  : units == "in"   ? "inch"
  : units == "ft"   ? "feet"
  : units == "yd"   ? "yard"
  : units == "mi"   ? "mile"
  : undef;

//! Return the name of the given \p unit identifier with dimension (symbol).
/***************************************************************************//**
  \param    units <string> A length unit identifier.
  \param    d <decimal> A dimension set to one of \p [1|2|3].
  \returns  <string> The units name for the given length unit identifier with
            is specified dimension. Returns \b 'undef' for identifiers or
            dimensions that are not defined.
  \private
*******************************************************************************/
function unit_length_name_symbol
(
  units = base_unit_length,
  d = 1
) = d == 1 ?      unit_length_name_id_lookup( units )
  : d == 2 ? str( unit_length_name_id_lookup( units ), "^2" )
  : d == 3 ? str( unit_length_name_id_lookup( units ), "^3" )
  : undef;

//! Return the name of the given \p unit identifier with dimension (word).
/***************************************************************************//**
  \copydetails unit_length_name_symbol()
  \private
*******************************************************************************/
function unit_length_name_word
(
  units = base_unit_length,
  d = 1
) = d == 1 ?                 unit_length_name_id_lookup( units )
  : d == 2 ? str( "square ", unit_length_name_id_lookup( units ) )
  : d == 3 ? str( "cubic ",  unit_length_name_id_lookup( units ) )
  : undef;

//! Return the name of the given \p unit identifier with dimension.
/***************************************************************************//**
  \param    w <boolean> \b true: use word format, \b false: use symbol format.
  \copydetails unit_length_name_symbol()
*******************************************************************************/
function unit_length_name
(
  units = base_unit_length,
  d = 1,
  w = false
) = w == true ? unit_length_name_word( units, d )
  :             unit_length_name_symbol( units, d );

//! Convert the \p value from millimeters to \p to units.
/***************************************************************************//**
  \param    value <decimal> A value to convert.
  \param    to <string> The units to which the value should be converted.
  \returns  <decimal> The conversion result. Returns \b 'undef' for identifiers
            that are not defined.
  \private
*******************************************************************************/
function unit_length_mm_to
(
  value,
  to
) = to == "pm"    ? ( value * 1000000000.0 )
  : to == "nm"    ? ( value * 1000000.0 )
  : to == "um"    ? ( value * 1000.0 )
  : to == "mm"    ? ( value )
  : to == "cm"    ? ( value / 10.0 )
  : to == "dm"    ? ( value / 100.0 )
  : to ==  "m"    ? ( value / 1000.0 )
  : to == "km"    ? ( value / 1000000.0 )
  : to == "thou"  ? ( value / 0.0254 )
  : to == "mil"   ? ( value / 0.0254 )
  : to == "in"    ? ( value / 25.4 )
  : to == "ft"    ? ( value / 304.8 )
  : to == "yd"    ? ( value / 914.4 )
  : to == "mi"    ? ( value / 1609344.0 )
  : undef;

//! Convert the \p value from \p from units to millimeters.
/***************************************************************************//**
  \param    value <decimal> A value to convert.
  \param    from <string> The units of the value to be converted.
  \returns  <decimal> The conversion result. Returns \b 'undef' for identifiers
            that are not defined.
  \private
*******************************************************************************/
function unit_length_to_mm
(
  value,
  from
) = value / unit_length_mm_to( 1, from );

//! Convert the \p value from \p from units to \p to units.
/***************************************************************************//**
  \param    value <decimal> A value to convert.
  \param    from <string> The units of the value to be converted.
  \param    to <string> A units to which the value should be converted.
  \returns  <decimal> The conversion result. Returns \b 'undef' for identifiers
            that are not defined.
  \private
*******************************************************************************/
function unit_length_convert
(
  value,
  from = base_unit_length,
  to   = base_unit_length
) = unit_length_mm_to( unit_length_to_mm( value, from ), to );

//! Convert the \p value from \p from units to \p to units with dimensions.
/***************************************************************************//**
  \param    value <decimal> A value to convert.
  \param    from <string> The units of the value to be converted.
  \param    to <string> A units to which the value should be converted.
  \param    d <decimal> The dimension set to one of \p [1|2|3].
  \returns  <decimal> The conversion result. Returns \b 'undef' for identifiers or
            dimensions that are not defined.
*******************************************************************************/
function convert_length
(
  value,
  from = base_unit_length,
  to   = base_unit_length,
  d    = 1
) = d == 1 ?    ( unit_length_convert(value, from, to)    )
  : d == 2 ? pow( unit_length_convert(value, from, to), 2 )
  : d == 3 ? pow( unit_length_convert(value, from, to), 3 )
  : undef;

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE example;
  BEGIN_OPENSCAD;
    include <units_length.scad>;

    base_unit_length = "mm";

    // get base unit name
    un = unit_length_name();

    // absolute length measurements in base unit.
    c1 = convert_length(1/8, "in");
    c2 = convert_length(3.175, "mm");
    c3 = convert_length(25, "mil");
    c4 = convert_length(1, "ft", d=3);

    // convert between units.
    c5 = convert_length(10, from="mil", to="in");
    c6 = convert_length(10, from="ft", to="mm");

    echo( un=un );
    echo( c1=c1 );
    echo( c2=c2 );
    echo( c3=c3 );
    echo( c4=c4 );
    echo( c5=c5 );
    echo( c6=c6 );
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {config_std,config_csg}.mfs;
    defines   name "units" define "base_unit_length" strings "mm cm mil in";
    variables add_opts_combine "units";
    include --path "${INCLUDE_PATH}" script_std.mfs;
  END_MFSCRIPT;
END_SCOPE;

BEGIN_SCOPE dim;
  BEGIN_OPENSCAD;
    include <units_length.scad>;

    module dim( uv=1, un="cm" ) {
      mx = 200.0;
      my = 1;
      tx = my;
      ty = mx / 10;
      ts = mx / 25;

      color( "black" )
      union() {
        square( [mx, my], true );
        translate([-mx/2,0,0]) square( [tx, ty], true );
        translate([+mx/2,0,0]) square( [tx, ty], true );
      }

      l1l = convert_length( uv, "in", un );
      l1u = unit_length_name( un );
      l1s = str( l1l, " ", l1u );

      translate( [0, ts, 0] )
      text( text=l1s, size=ts, font="Courier:style=bold italic", halign="center", valign="center" );
    }

    unv = ["um", "mm", "cm", "mil", "in"];
    for( un = unv )
      translate( [0, 30 * search([un], unv)[0], 0] ) dim( 1, un );
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {config_std,config_png}.mfs;
    views     name "views" translate "0,60,0" distance "400" views "top";
    variables add_opts_combine "views";
    include --path "${INCLUDE_PATH}" script_std.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
