//! Scalar data type tests.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2015-2023

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

    \amu_define group_name  (Scalar Identification)
    \amu_define group_brief (Scalar data type tests.)
    \amu_define parent_id   (identify)

  \amu_include (include/amu/pgid_path_pid_pstem_pg.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// validation.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/validate_log_th.amu)
  \amu_include (include/amu/validate_log_td.amu)
  \amu_include (include/amu/validate_results.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)

  \details

  \amu_define group_references
  (
    [ottf]: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Type_Test_Functions "OpenSCAD Type Test Functions"
  )

  \amu_include (include/amu/validate_summary.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//! Test if a value is a single non-iterable value.
/***************************************************************************//**
  \param    v \<value> A value.

  \returns  <boolean> \b true when the value is a single non-iterable
            value and \b false otherwise.

  \details

     input value | function return
    :-----------:|:-----------------:
     \em number  | \b  true
     \em boolean | \b  true
     \em string  | \b  false
     \em list    | \b  false
     \em range   | \b  true
     \b  undef   | \b  true
     \b  inf     | \b  true
     \b  nan     | \b  true

  \note     The empty list and empty string return \b true.
*******************************************************************************/
function is_scalar
(
  v
) = !is_string(v) && !is_list(v);

//! Test if a value is defined.
/***************************************************************************//**
  \param    v \<value> A value.

  \returns  <boolean> \b true when the value is defined
            and \b false otherwise.

  \details

  \note     Starting with version 2019.05, this function is now
            provided directly by OpenSCAD via a built-in [type test
            function][ottf] \c is_undef().

  \amu_eval (${group_references})
*******************************************************************************/
function is_defined
(
  v
) = is_undef(v) ? false : true;

//! Test if a value is not defined.
/***************************************************************************//**
  \param    v \<value> A value.

  \returns  <boolean> \b true when the value is not defined
            and \b false otherwise.

  \details

  \note     Starting with version 2019.05, this function is now
            provided directly by OpenSCAD via a built-in [type test
            function][ottf] \c is_undef().

  \amu_eval (${group_references})
*******************************************************************************/
function not_defined
(
  v
) = is_undef(v);

//! Test if a numerical value is 'nan' (not a number).
/***************************************************************************//**
  \param    v \<value> A numerical value.

  \returns  <boolean> \b true when the value is determined to be
            \b nan (Not A Number) and \b false otherwise.
*******************************************************************************/
function is_nan
(
  v
) = (v != v);

//! Test if a numerical value is infinite.
/***************************************************************************//**
  \param    v \<value> A numerical value.

  \returns  <boolean> \b true when the value is determined to be
            \b inf (greater than the largest OpenSCAD representable
            number) and \b false otherwise.
*******************************************************************************/
function is_inf
(
  v
) = ( v == (number_max * number_max) );

//! Test if a value is a number.
/***************************************************************************//**
  \param    v \<value> A value.

  \returns  <boolean> \b true when the value is a number
            and \b false otherwise.

  \details

  \note     Starting with version 2019.05, this function is now
            provided directly by OpenSCAD via a built-in [type test
            function][ottf] \c is_num().

  \amu_eval (${group_references})
*******************************************************************************/
function is_number
(
  v
) = is_num(v);

//! Test if a value is an integer.
/***************************************************************************//**
  \param    v \<value> A value.

  \returns  <boolean> \b true when the value is an integer and \b false
            otherwise.
*******************************************************************************/
function is_integer
(
  v
) = !is_num(v) ? false
  : ((v % 1) == 0);

//! Test if a value is a decimal.
/***************************************************************************//**
  \param    v \<value> A value.

  \returns  <boolean> \b true when the value is a decimal and \b false
            otherwise.
*******************************************************************************/
function is_decimal
(
  v
) = !is_num(v) ? false
  : ((v % 1) > 0);

//! Test if a value is a range definition.
/***************************************************************************//**
  \param    v \<value> A value.

  \returns  <boolean> \b true when the value is a range definition
            and \b false otherwise.

  \details

  \note     A range is determined to be a value which does not fit in
            any other category. Specifically, It is a value that is not
            {\b undef, \b nan or \b inf}, and is neither of {\em list,
            \em number, \em bool, or \em string}.

  \internal
    This exclusion test should be replaced by a suitable inclusion test
    when possible.
  \endinternal
*******************************************************************************/
function is_range
(
  v
) = !is_undef(v) &&
    !is_nan(v) &&
    !is_inf(v) &&
    !is_list(v) &&
    !is_num(v) &&
    !is_bool(v) &&
    !is_string(v);

//! Test if a numerical value is even.
/***************************************************************************//**
  \param    v \<value> A numerical value.

  \returns  <boolean> \b true when the value is determined to be an \em even
            integer and \b false otherwise (The value may be positive or
            negative).
*******************************************************************************/
function is_even
(
  v
) = !is_integer(v) ? false
  : ((v % 2) == 0);

//! Test if a numerical value is odd.
/***************************************************************************//**
  \param    v \<value> A numerical value.

  \returns  <boolean> \b true when the value is determined to be an \em odd
            integer and \b false otherwise (The value may be positive or
            negative).
*******************************************************************************/
function is_odd
(
  v
) = !is_integer(v) ? false
  : ((v % 2) != 0);

//! Test if a numerical value is between an upper and lower bounds.
/***************************************************************************//**
  \param    v <number> A numerical value.
  \param    l <number> The minimum value.
  \param    u <number> The maximum value.

  \returns  <boolean> \b true when the value is equal to or between the
            upper and lower bounds and \b false otherwise. Returns \b false
            when either of \p v, \p l, or \p u is not a number.
*******************************************************************************/
function is_between
(
  v,
  l,
  u
) = !(is_num(v) && is_num(l) && is_num(u)) ? false
  : ((v >= l) && (v <=u));

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

    t = true; f = false; u = undef; s = number_max;

    function get_v1( id ) = table_get_value(test_r, test_c, id, "v1");
    module log_test( m ) { log_type ( "omdl_test", m ); }
    module log_skip( fn ) { log_test ( str("ignore: '", fn, "'") ); }
    module test_1v( fn, fr, id )
    {
      td = table_get_value(test_r, test_c, id, "td");
      ev = table_get_value(good_r, good_c, fn, id);

      if ( ev != s )
      {
        d = str(fn, "(", get_v1(id), ")=", ev);
        m = validate( d=d, cv=fr, t="eq", ev=ev );

        if ( !validate( cv=fr, t="eq", ev=ev, pf=true ) )
          log_test( str(id, " ", m, " ---> \"", td, "\"") );
        else
          log_test( str(id, " ", m) );
      }
      else
        log_test( str(id, " -skip-: '", fn, "(", td, ")'") );
    }

    log_test( str("openscad version ", version()) );

    // test-values columns
    test_c = [ ["id", "identifier"], ["td", "description"], ["v1", "value 1"] ];

    // test-values rows
    test_r =
    [
      ["t01", "The undefined value",        undef],
      ["t02", "An odd integer",             1],
      ["t03", "An small even integer",      10],
      ["t04", "A large integer",            100000000],
      ["t05", "A small decimal (epsilon)",  aeps],
      ["t06", "The max number",             number_max],
      ["t07", "The min number",             number_min],
      ["t08", "The max number^2",           number_max * number_max],
      ["t09", "The invalid number nan",     0 / 0],
      ["t10", "The boolean true",           true],
      ["t11", "The boolean false",          false],
      ["t12", "A character string",         "a"],
      ["t13", "A string",                   "This is a longer string"],
      ["t14", "The empty string",           empty_str],
      ["t15", "The empty list",             empty_lst],
      ["t16", "A 1-tuple list of undef",    [undef]],
      ["t17", "A 1-tuple list",             [10]],
      ["t18", "A 3-tuple list",             [1, 2, 3]],
      ["t19", "A list of lists",            [[1,2,3], [4,5,6], [7,8,9]]],
      ["t20", "A shorthand range",          [0:9]],
      ["t21", "A range",                    [0:0.5:9]]
    ];
    table_check( test_r, test_c, false );   // sanity-test

    test_ids = table_get_row_ids( test_r );

    // expected columns: ("id" + one column for each test)
    good_c = pmerge([concat("id", test_ids), concat("identifier", test_ids)]);

    // expected rows: ("golden" test results), use 's' to skip test
    good_r =
    [ // function       01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21
      ["is_scalar",     t, t, t, t, t, t, t, t, t, t, t, f, f, f, f, f, f, f, f, t, t],
      ["is_defined",    f, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t],
      ["not_defined",   t, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f],
      ["is_nan",        f, f, f, f, f, f, f, f, t, f, f, f, f, f, f, f, f, f, f, f, f],
      ["is_inf",        f, f, f, f, f, f, f, t, f, f, f, f, f, f, f, f, f, f, f, f, f],
      ["is_number",     f, t, t, t, t, t, t, t, f, f, f, f, f, f, f, f, f, f, f, f, f],
      ["is_integer",    f, t, t, t, f, t, t, f, f, f, f, f, f, f, f, f, f, f, f, f, f],
      ["is_decimal",    f, f, f, f, t, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f],
      ["is_range",      f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, t, t],
      ["is_even",       f, f, t, t, f, t, t, f, f, f, f, f, f, f, f, f, f, f, f, f, f],
      ["is_odd",        f, t, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f],
      ["is_between_MM", f, t, t, t, t, t, t, f, f, f, f, f, f, f, f, f, f, f, f, f, f],

      ["is_bool",       f, f, f, f, f, f, f, f, f, t, t, f, f, f, f, f, f, f, f, f, f],
      ["is_string",     f, f, f, f, f, f, f, f, f, f, f, t, t, t, f, f, f, f, f, f, f],
      ["is_list",       f, f, f, f, f, f, f, f, f, f, f, f, f, f, t, t, t, t, t, f, f]
    ];
    table_check( good_r, good_c, false );   // sanity-test

    // Indirect function calls would be very useful here!!!
    for (vid=test_ids) test_1v( "is_scalar", is_scalar(get_v1(vid)), vid );
    for (vid=test_ids) test_1v( "is_defined", is_defined(get_v1(vid)), vid );
    for (vid=test_ids) test_1v( "not_defined", not_defined(get_v1(vid)), vid );
    for (vid=test_ids) test_1v( "is_nan", is_nan(get_v1(vid)), vid );
    for (vid=test_ids) test_1v( "is_inf", is_inf(get_v1(vid)), vid );
    for (vid=test_ids) test_1v( "is_number", is_number(get_v1(vid)), vid );
    for (vid=test_ids) test_1v( "is_integer", is_integer(get_v1(vid)), vid );
    for (vid=test_ids) test_1v( "is_decimal", is_decimal(get_v1(vid)), vid );
    for (vid=test_ids) test_1v( "is_range", is_range(get_v1(vid)), vid );
    for (vid=test_ids) test_1v( "is_even", is_even(get_v1(vid)), vid );
    for (vid=test_ids) test_1v( "is_odd", is_odd(get_v1(vid)), vid );
    for (vid=test_ids) test_1v( "is_between_MM", is_between(get_v1(vid),number_min,number_max), vid );

    // OpenSCAD built-in functions: is_undef() and is_num() are tested above
    for (vid=test_ids) test_1v( "is_bool", is_bool(get_v1(vid)), vid );
    for (vid=test_ids) test_1v( "is_string", is_string(get_v1(vid)), vid );
    for (vid=test_ids) test_1v( "is_list", is_list(get_v1(vid)), vid );

    // end-of-tests
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {config_base,config_term}.mfs;
    include --path "${INCLUDE_PATH}" script_std.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
