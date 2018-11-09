//! Length units and conversions.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2015-2018

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

    \amu_pathid parent  (++path)
    \amu_pathid group   (++path ++stem)

  \ingroup \amu_eval(${parent} ${group})
*******************************************************************************/

//----------------------------------------------------------------------------//
// group.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \addtogroup \amu_eval(${parent})
  @{

  \defgroup \amu_eval(${group}) Lengths
  \brief    Length units and conversions.

  \details

    These functions allow for lengths to be specified with units.
    Lengths specified with units are independent of (\ref base_unit_length).
    There are also unit conversion functions for converting from one unit
    to another.

    The table below enumerates the supported units.

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

      \dontinclude \amu_scope(index=1).scad
      \skip include
      \until to="mm");

    \b Result (base_unit_length = \b mm):  \include \amu_scope(index=1)_mm.log
    \b Result (base_unit_length = \b cm):  \include \amu_scope(index=1)_cm.log
    \b Result (base_unit_length = \b mil): \include \amu_scope(index=1)_mil.log
    \b Result (base_unit_length = \b in):  \include \amu_scope(index=1)_in.log

    \b Example (equivalent lengths)

    \image html  length_dim_qvga_top.png "Unit Lengths"
    \image latex length_dim_qvga_top.eps "Unit Lengths" width=4in

  @{
*******************************************************************************/

//----------------------------------------------------------------------------//

//! <string> The base unit for length measurements.
base_unit_length = "mm";

//! Return the long name for a length unit identifier.
/***************************************************************************//**
  \param    u <string> A length unit identifier.

  \returns  <string> The long name for a length unit identifier.
            Returns \b undef for identifiers that are not defined.

  \private
*******************************************************************************/
function unit_length_name_id_lookup
(
  u = base_unit_length
) = u == "pm"   ? "picometer"
  : u == "nm"   ? "nanometer"
  : u == "um"   ? "micrometer"
  : u == "mm"   ? "millimeter"
  : u == "cm"   ? "centimeter"
  : u == "dm"   ? "decimeter"
  : u ==  "m"   ? "meter"
  : u == "km"   ? "kilometer"
  : u == "thou" ? "thousandth"
  : u == "mil"  ? "thousandth"
  : u == "in"   ? "inch"
  : u == "ft"   ? "feet"
  : u == "yd"   ? "yard"
  : u == "mi"   ? "mile"
  : undef;

//! Return the long name for a length unit identifier with dimension.
/***************************************************************************//**
  \param    u <string> A length unit identifier.
  \param    d <integer> A dimension. One of [1|2|3].

  \returns  <string> The long name for a length unit identifier with
            dimension.
            Returns \b undef for identifiers or dimensions that are
            not defined.

  \private
*******************************************************************************/
function unit_length_name_symbol
(
  u = base_unit_length,
  d = 1
) = d == 1 ?      unit_length_name_id_lookup( u )
  : d == 2 ? str( unit_length_name_id_lookup( u ), "^2" )
  : d == 3 ? str( unit_length_name_id_lookup( u ), "^3" )
  : undef;

//! Return the long name for a length unit identifier with dimension.
/***************************************************************************//**
  \copydetails unit_length_name_symbol()

  \private
*******************************************************************************/
function unit_length_name_word
(
  u = base_unit_length,
  d = 1
) = d == 1 ?                 unit_length_name_id_lookup( u )
  : d == 2 ? str( "square ", unit_length_name_id_lookup( u ) )
  : d == 3 ? str( "cubic ",  unit_length_name_id_lookup( u ) )
  : undef;

//! Return the name for a length unit identifier with dimension.
/***************************************************************************//**
  \param    w <boolean> \b true for word and \b false for symbol format.

  \copydetails unit_length_name_symbol()
*******************************************************************************/
function unit_length_name
(
  u = base_unit_length,
  d = 1,
  w = false
) = w == true ? unit_length_name_word( u, d )
  :             unit_length_name_symbol( u, d );

//! Convert a value from millimeters to other units.
/***************************************************************************//**
  \param    v <decimal> A value to convert.
  \param    to <string> The units to which the value should be converted.

  \returns  <decimal> The conversion result.
            Returns \b undef for identifiers that are not defined.

  \private
*******************************************************************************/
function unit_length_mm_to
(
  v,
  to
) = to == "pm"    ? ( v * 1000000000.0 )
  : to == "nm"    ? ( v * 1000000.0 )
  : to == "um"    ? ( v * 1000.0 )
  : to == "mm"    ? ( v )
  : to == "cm"    ? ( v / 10.0 )
  : to == "dm"    ? ( v / 100.0 )
  : to ==  "m"    ? ( v / 1000.0 )
  : to == "km"    ? ( v / 1000000.0 )
  : to == "thou"  ? ( v / 0.0254 )
  : to == "mil"   ? ( v / 0.0254 )
  : to == "in"    ? ( v / 25.4 )
  : to == "ft"    ? ( v / 304.8 )
  : to == "yd"    ? ( v / 914.4 )
  : to == "mi"    ? ( v / 1609344.0 )
  : undef;

//! Convert a value from some units to millimeters.
/***************************************************************************//**
  \param    v <decimal> A value to convert.
  \param    from <string> The units of the value to be converted.

  \returns  <decimal> The conversion result.
            Returns \b undef for identifiers that are not defined.

  \private
*******************************************************************************/
function unit_length_to_mm
(
  v,
  from
) = v / unit_length_mm_to( 1, from );

//! Convert a value from from one units to another.
/***************************************************************************//**
  \param    v <decimal> A value to convert.
  \param    from <string> The units of the value to be converted.
  \param    to <string> A units to which the value should be converted.

  \returns  <decimal> The conversion result.
            Returns \b undef for identifiers that are not defined.

  \private
*******************************************************************************/
function unit_length_convert
(
  v,
  from = base_unit_length,
  to   = base_unit_length
) = unit_length_mm_to( unit_length_to_mm( v, from ), to );

//! Convert a value from from one units to another with dimensions.
/***************************************************************************//**
  \param    v <decimal> A value to convert.
  \param    from <string> The units of the value to be converted.
  \param    to <string> A units to which the value should be converted.
  \param    d <integer> A dimension. One of [1|2|3].

  \returns  <decimal> The conversion result.
            Returns \b undef for identifiers or dimensions that are
            not defined.
*******************************************************************************/
function convert_length
(
  v,
  from = base_unit_length,
  to   = base_unit_length,
  d    = 1
) = d == 1 ?    ( unit_length_convert(v, from, to)    )
  : d == 2 ? pow( unit_length_convert(v, from, to), 2 )
  : d == 3 ? pow( unit_length_convert(v, from, to), 3 )
  : undef;

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE example;
  BEGIN_OPENSCAD;
    include <units/length.scad>;

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
    include --path "${INCLUDE_PATH}" {config_base,config_csg}.mfs;

    defines   name "units" define "base_unit_length" strings "mm cm mil in";
    variables add_opts_combine "units";

    include --path "${INCLUDE_PATH}" script_std.mfs;
  END_MFSCRIPT;
END_SCOPE;

BEGIN_SCOPE dim;
  BEGIN_OPENSCAD;
    include <units/length.scad>;

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
    include --path "${INCLUDE_PATH}" {config_base,config_png}.mfs;

    views     name "views" translate "0,60,0" distance "400" views "top";
    variables add_opts_combine "views";

    include --path "${INCLUDE_PATH}" script_std.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
