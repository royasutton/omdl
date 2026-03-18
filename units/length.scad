//! Length units and conversions.
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

    \amu_define group_name  (Length Units)
    \amu_define group_brief (Length units and conversions.)

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

  - \p v is the numeric value to convert. It has no default and must
    always be supplied by the caller. For \p d = 1 it may be a scalar
    or a list; the conversion is applied element-wise. For \p d = 2
    or \p d = 3 it must be a scalar.
  - \p from identifies the source unit; defaults to
    \ref length_unit_default.
  - \p to identifies the target unit; defaults to
    \ref length_unit_base.
  - \p d is the dimensional exponent: 1 (linear), 2 (area), 3
    (volume). Values outside [1|2|3] yield \b undef.
  - \p u is a unit-identifier string used in name-lookup functions;
    defaults to \ref length_unit_default.
  - \p w selects word (\b true) vs symbol (\b false) format in
    name-return functions; defaults to \b false.

  \b Return \b values

  - All functions return \b undef for unrecognised unit identifiers
    or out-of-range dimension values. Callers are responsible for
    testing return values when inputs may be dynamic.

  \b Global \b configuration

  - \ref length_unit_base sets the storage base unit for the entire
    design. It defaults to \c "mm" and is intended to be overridden
    at the top of a design file or within a child scope before any
    length function is called.
  - \ref length_unit_default sets the assumed input unit when \p from
    or \p u is not specified. It also defaults to \c "mm" and may be
    overridden in the same way.
  - Both variables must be assigned before any length function is
    called; changing them after assignments that depend on them have
    already been evaluated has no effect on those prior results.

  \b Unit \b identifiers

  - Unit identifier strings are case-sensitive and lowercase
    (e.g. \c "mm", \c "in").
  - The identifiers \c "thou" and \c "mil" denote the same physical
    unit (one thousandth of an inch, 0.0254 mm) and are
    interchangeable in all conversion functions.

  \b Shorthand \b functions

  - The \c l_mm() and \c l_in() helpers are convenience wrappers
    that fix \p from to their named unit and \p to to
    \ref length_unit_base. The \p d parameter is forwarded and
    defaults to 1. Use the full \ref length function when a
    non-default target unit is required.

  These functions allow for lengths to be specified with units. Lengths
  specified with units are independent of (\ref length_unit_base).
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

  \amu_define title           (Length base units example)
  \amu_define scope_id        (example)
  \amu_define output_scad     (true)
  \amu_define output_console  (false)
  \amu_include (include/amu/scope.amu)

  \amu_define output_scad     (false)
  \amu_define output_console  (true)

  \amu_define title           (length_unit_base=mm)
  \amu_define scope_id        (example_mm)
  \amu_include (include/amu/scope.amu)

  \amu_define title           (length_unit_base=cm)
  \amu_define scope_id        (example_cm)
  \amu_include (include/amu/scope.amu)

  \amu_define title           (length_unit_base=mil)
  \amu_define scope_id        (example_mil)
  \amu_include (include/amu/scope.amu)

  \amu_define title           (length_unit_base=in)
  \amu_define scope_id        (example_in)
  \amu_include (include/amu/scope.amu)

  /+
    include diagram
  +/
  \amu_define title           (Equivalent lengths)
  \amu_define image_views     (top)
  \amu_define image_size      (qvga)
  \amu_define scope_id        (equivalents)
  \amu_include (include/amu/scope_diagrams_3d.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// members
//----------------------------------------------------------------------------//

//! <string> The base units for value storage.
//! \note This variable is intended to be overridden at the top of a
//!   design file or in a child scope. All length functions that omit
//!   the \p to parameter will convert to this unit.
length_unit_base = "mm";

//! <string> The default units when unspecified.
//! \note This variable is intended to be overridden at the top of a
//!   design file or in a child scope. All length functions that omit
//!   the \p from or \p u parameter will assume this unit.
length_unit_default = "mm";

//! Return the long name for a length unit identifier.
/***************************************************************************//**
  \param    u <string> A length unit identifier.

  \returns  <string> The long name for a length unit identifier.
            Returns \b undef for identifiers that are not defined.

  \private
*******************************************************************************/
function _length_unit_name_1d
(
  u = length_unit_default
) = u == "pm"   ? "picometer"
  : u == "nm"   ? "nanometer"
  : u == "um"   ? "micrometer"
  : u == "mm"   ? "millimeter"
  : u == "cm"   ? "centimeter"
  : u == "dm"   ? "decimeter"
  : u ==  "m"   ? "meter"
  : u == "km"   ? "kilometer"
  : u == "thou" ? "thou (thousandth)"
  : u == "mil"  ? "mil (thousandth)"
  : u == "in"   ? "inch"
  : u == "ft"   ? "feet"
  : u == "yd"   ? "yard"
  : u == "mi"   ? "mile"
  : undef;

//! Return the name for a length unit identifier with dimension.
/***************************************************************************//**
  \param    u <string> A length unit identifier.
  \param    d <integer> The unit dimension. One of [1|2|3].
  \param    w <boolean> \b true for word and \b false for symbol format.

  \returns  <string> The long name for a length unit identifier with
            dimension. Returns \b undef for identifiers or dimensions
            that are not defined.
*******************************************************************************/
function length_unit_name
(
  u = length_unit_default,
  d = 1,
  w = false
) = (w == false) ?
    (
        d == 1 ?      _length_unit_name_1d( u )
      : d == 2 ? str( _length_unit_name_1d( u ), "^2" )
      : d == 3 ? str( _length_unit_name_1d( u ), "^3" )
      : undef
    )
  :
    (
        d == 1 ?                 _length_unit_name_1d( u )
      : d == 2 ? str( "square ", _length_unit_name_1d( u ) )
      : d == 3 ? str( "cubic ",  _length_unit_name_1d( u ) )
      : undef
    );

//! Convert a value from millimeters to other units.
/***************************************************************************//**
  \param    v  <decimal-list | decimal> The value to convert.
  \param    to <string> The units to which the value should be converted.
               Defaults to \ref length_unit_base.

  \returns  <decimal-list | decimal> The conversion result.
            Returns \b undef for identifiers that are not defined.

  \private
*******************************************************************************/
function _length_unit_mm2
(
  v,
  to = length_unit_base
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
  \param    v    <decimal-list | decimal> The value to convert.
  \param    from <string> The units of the value to be converted.
                 Defaults to \ref length_unit_default.

  \returns  <decimal-list | decimal> The conversion result.
            Returns \b undef for identifiers that are not defined.

  \private
*******************************************************************************/
function _length_unit_2mm
(
  v,
  from = length_unit_default
) = let( factor = _length_unit_mm2( 1, from ) )
    (factor == undef) ? undef : v / factor;

//! Convert a value from one unit to another (1-dimensional).
/***************************************************************************//**
  \param    v    <decimal-list | decimal> The value to convert.
  \param    from <string> The units of the value to be converted.
                 Defaults to \ref length_unit_default.
  \param    to   <string> The units to which the value should be
                 converted. Defaults to \ref length_unit_base.
                 Conversion to \c "mm" is short-circuited: the
                 intermediate mm to step is skipped.

  \returns  <decimal-list | decimal> The conversion result.
            Returns \b undef for identifiers that are not defined.

  \private
*******************************************************************************/
function _length_1d
(
  v,
  from = length_unit_default,
  to   = length_unit_base
) = (from == to) ? v
    // short-circuit: 2mm is the final result when target is millimeters
  : (to == "mm") ? _length_unit_2mm( v, from )
  : _length_unit_mm2( _length_unit_2mm( v, from ), to );

//! Convert a length value from one unit to another, with optional dimensional scaling.
/***************************************************************************//**
  \param    v    <decimal-list | decimal> The value to convert. May be
                 a list when \p d = 1; must be a scalar when \p d = 2
                 or 3.
  \param    from <string> The units of the value to be converted.
                 Defaults to \ref length_unit_default.
  \param    to   <string> The units to which the value should be
                 converted. Defaults to \ref length_unit_base.
  \param    d    <integer> The unit dimension. One of [1|2|3].

  \returns  <decimal> The conversion result. For \p d = 1 returns the
            converted value; for \p d = 2 or 3 returns the converted
            linear value raised to the corresponding power. Returns \b
            undef for identifiers, dimensions, or input types that are
            not defined.
*******************************************************************************/
function length
(
  v,
  from = length_unit_default,
  to   = length_unit_base,
  d    = 1
) =
    // for d>1, 'v' must be a scalar; lists are only valid for d=1
    (d != 1 && is_list(v)) ? undef
    // d=1: scalar or list, element-wise conversion via _length_1d
  : d == 1 ? _length_1d(v, from, to)
    // d=2,3: convert the linear value once, then raise to the power
  : let( c = _length_1d(v, from, to) )
    d == 2 ? pow( c, 2 )
  : d == 3 ? pow( c, 3 )
    // undefined for other dimensions
  : undef;

//! Recover a linear length from an area or volume value, then convert units.
/***************************************************************************//**
  \param    v    <decimal> The area or volume value to invert. Must be
                 a scalar for \p d = 2 or 3; may be a list for \p d = 1.
  \param    from <string> The units of the input value \p v.
                 Defaults to \ref length_unit_base.
  \param    to   <string> The units to which the recovered linear value
                 should be converted. Defaults to \ref length_unit_default.
  \param    d    <integer> The unit dimension. One of [1|2|3].

  \returns  <decimal> The linear conversion result. For \p d = 1 converts
            \p v directly; for \p d = 2 takes the square root of \p v
            before converting; for \p d = 3 takes the cube root.
            Returns \b undef for identifiers, dimensions, or input
            types that are not defined.
*******************************************************************************/
function length_inv
(
  v,
  from = length_unit_base,
  to   = length_unit_default,
  d    = 1
) =
    // for d>1, 'v' must be a scalar; lists are only valid for d=1
    (d != 1 && is_list(v)) ? undef
    // d=1: scalar or list, element-wise conversion via _length_1d
  : d == 1 ? _length_1d(v, from, to)
  : d == 2 ? _length_1d(sqrt(v),        from, to)
  : d == 3 ? _length_1d(pow(v, 1/3.0),  from, to)
    // undefined for other dimensions
  : undef;

//----------------------------------------------------------------------------//
// shorthand conversions
//----------------------------------------------------------------------------//

//! \name Shorts
//! @{
//!
//! Convenience wrappers around \ref length that fix the \p from unit
//! to a named unit and the \p to unit to \ref length_unit_base.
//! The \p d parameter is forwarded (default 1). Use \ref length
//! directly when a non-default target unit or list input with d > 1
//! is required.

//! Shorthand length conversion for millimeters.
/***************************************************************************//**
  \param    v <decimal> The value to convert.
  \param    d <integer> The unit dimension. One of [1|2|3].

  \returns  <decimal> The conversion result.
*******************************************************************************/
function l_mm(v, d=1) = length(v=v, from="mm", d=d);

//! Shorthand length conversion for inches.
/***************************************************************************//**
  \param    v <decimal> The value to convert.
  \param    d <integer> The unit dimension. One of [1|2|3].

  \returns  <decimal> The conversion result.
*******************************************************************************/
function l_in(v, d=1) = length(v=v, from="in", d=d);

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

    length_unit_base = "mm";
    length_unit_default = "in";

    // get unit names
    bu = length_unit_name(length_unit_base);
    du = length_unit_name();

    // absolute length measurements in base unit.
    c1 = length(1/8);
    c2 = length(3.175, "mm");
    c3 = length(25, "mil");
    c4 = length(1, "ft", d=3);

    // convert between units.
    c5 = length(10, from="mil", to="in");
    c6 = length(10, from="ft", to="mm");

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

    defines   name "units" define "length_unit_base" strings "mm cm mil in";
    variables add_opts_combine "units";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

/*
BEGIN_SCOPE equivalents;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;

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

      l1l = length( uv, "in", un );
      l1u = length_unit_name( un );
      l1s = str( l1l, " ", l1u );

      translate( [0, ts, 0] )
      text( text=l1s, size=ts, font="Courier:style=bold italic", halign="center", valign="center" );
    }

    unv = ["um", "mm", "cm", "mil", "in"];
    for( un = unv )
      translate( [0, 30 * search([un], unv)[0], 0] ) dim( 1, un );
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;

    views     name "views" translate "0,60,0" distance "400" views "top";
    variables add_opts_combine "views";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
