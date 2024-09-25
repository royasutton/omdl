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

    \amu_define group_name  (Scalar Tests)
    \amu_define group_brief (Tests to differentiate scalar data types.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
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
  \amu_include (include/amu/includes_required.amu)

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

    function fmt( id, td, v1, v2, v3 ) = table_validate_fmt(id, td, v1, v2, v3);
    function v1(db, id) = table_validate_get_v1(db, id);
    t = true; f = false; u = undef; s = validation_skip;

    tbl_test_values =
    [
      fmt("t01", "The undefined value",        undef),
      fmt("t02", "An odd integer",             1),
      fmt("t03", "An small even integer",      10),
      fmt("t04", "A large integer",            100000000),
      fmt("t05", "A small decimal (epsilon)",  eps),
      fmt("t06", "The max number",             number_max),
      fmt("t07", "The min number",             number_min),
      fmt("t08", "The max number^2",           number_max * number_max),
      fmt("t09", "The invalid number nan",     0 / 0),
      fmt("t10", "The boolean true",           true),
      fmt("t11", "The boolean false",          false),
      fmt("t12", "A character string",         "a"),
      fmt("t13", "A string",                   "This is a longer string"),
      fmt("t14", "The empty string",           empty_str),
      fmt("t15", "The empty list",             empty_lst),
      fmt("t16", "A 1-tuple list of undef",    [undef]),
      fmt("t17", "A 1-tuple list",             [10]),
      fmt("t18", "A 3-tuple list",             [1, 2, 3]),
      fmt("t19", "A list of lists",            [[1,2,3], [4,5,6], [7,8,9]]),
      fmt("t20", "A shorthand range",          [0:9]),
      fmt("t21", "A range",                    [0:0.5:9])
    ];

    tbl_test_answers =
    [ // function       01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21
      ["is_scalar",     t, t, t, t, t, t, t, t, t, t, t, f, f, f, f, f, f, f, f, t, t],
      ["is_defined",    f, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t],
      ["is_nan",        f, f, f, f, f, f, f, f, t, f, f, f, f, f, f, f, f, f, f, f, f],
      ["is_inf",        f, f, f, f, f, f, f, t, f, f, f, f, f, f, f, f, f, f, f, f, f],
      ["is_number",     f, t, t, t, t, t, t, t, f, f, f, f, f, f, f, f, f, f, f, f, f],
      ["is_integer",    f, t, t, t, f, t, t, f, f, f, f, f, f, f, f, f, f, f, f, f, f],
      ["is_decimal",    f, f, f, f, t, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f],
      ["is_range",      f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, t, t],
      ["is_even",       f, f, t, t, f, t, t, f, f, f, f, f, f, f, f, f, f, f, f, f, f],
      ["is_odd",        f, t, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f],
      ["is_between_MM", f, t, t, t, t, t, t, f, f, f, f, f, f, f, f, f, f, f, f, f, f],

      ["is_undef",      t, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f],
      ["is_bool",       f, f, f, f, f, f, f, f, f, t, t, f, f, f, f, f, f, f, f, f, f],
      ["is_string",     f, f, f, f, f, f, f, f, f, f, f, t, t, t, f, f, f, f, f, f, f],
      ["is_list",       f, f, f, f, f, f, f, f, f, f, f, f, f, f, t, t, t, t, t, f, f]
    ];

    db = table_validate_init( tbl_test_values, tbl_test_answers );

    table_validate_start( db );
    test_ids = table_validate_get_ids( db );

    for (id=test_ids) table_validate( db, id, "is_scalar", 1, is_scalar( v1(db,id)) );
    for (id=test_ids) table_validate( db, id, "is_defined", 1, is_defined( v1(db,id)) );
    for (id=test_ids) table_validate( db, id, "is_nan", 1, is_nan( v1(db,id)) );
    for (id=test_ids) table_validate( db, id, "is_inf", 1, is_inf( v1(db,id)) );
    for (id=test_ids) table_validate( db, id, "is_number", 1, is_number( v1(db,id)) );
    for (id=test_ids) table_validate( db, id, "is_integer", 1, is_integer( v1(db,id)) );
    for (id=test_ids) table_validate( db, id, "is_decimal", 1, is_decimal( v1(db,id)) );
    for (id=test_ids) table_validate( db, id, "is_range", 1, is_range( v1(db,id)) );
    for (id=test_ids) table_validate( db, id, "is_even", 1, is_even( v1(db,id)) );
    for (id=test_ids) table_validate( db, id, "is_odd", 1, is_odd( v1(db,id)) );
    for (id=test_ids) table_validate( db, id, "is_between_MM", 1, is_between( v1(db,id), number_min, number_max ) );

    // OpenSCAD built-in functions: is_undef() and is_num() are tested above
    for (id=test_ids) table_validate( db, id, "is_undef", 1, is_undef( v1(db,id)) );
    for (id=test_ids) table_validate( db, id, "is_bool", 1, is_bool( v1(db,id)) );
    for (id=test_ids) table_validate( db, id, "is_string", 1, is_string( v1(db,id)) );
    for (id=test_ids) table_validate( db, id, "is_list", 1, is_list( v1(db,id)) );

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_term}.mfs;
    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
