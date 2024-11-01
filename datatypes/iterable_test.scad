//! Iterable data type tests.
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

    \amu_define group_name  (Iterable Tests)
    \amu_define group_brief (Tests to differentiate iterable data types.)

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

  \amu_include (include/amu/validate_summary.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//! Test if a value has multiple parts and is iterable.
/***************************************************************************//**
  \param    v \<value> A value.

  \returns  <boolean> \b true when the value is an iterable multi-part value
            and \b false otherwise.

  \details

     input value | function return
    :-----------:|:-----------------:
     \em number  | \b  false
     \em boolean | \b  false
     \em string  | \b  true
     \em list    | \b  true
     \em range   | \b  false
     \b  undef   | \b  false
     \b  inf     | \b  false
     \b  nan     | \b  false

  \note     The empty list and empty string return \b true.
*******************************************************************************/
function is_iterable
(
  v
) = is_string(v) || is_list(v);

//! Test if an iterable value is empty.
/***************************************************************************//**
  \param    v <iterable> An iterable data type value.

  \returns  <boolean> \b true when the iterable value has zero elements
            and \b false otherwise. Returns \b true when \p v is not
            an iterable value.
*******************************************************************************/
function is_empty
(
  v
) = !is_iterable(v) ? true
  : (len(v) == 0);

//! Test if all elements of an iterable value equal a comparison value.
/***************************************************************************//**
  \param    v <iterable> An iterable data type value.
  \param    cv \<value> A comparison value.

  \returns  <boolean> \b true when all elements of \p v equal the value
            \p cv and \b false otherwise. Returns \b true when \p v is
            empty.
*******************************************************************************/
function all_equal
(
  v,
  cv
) = !is_iterable(v) ? (v == cv)
  : is_empty(v) ? true
  : (first(v) != cv) ? false
  : all_equal(tailn(v), cv);

//! Test if any element of an iterable value equal a comparison value.
/***************************************************************************//**
  \param    v <iterable> An iterable data type value.
  \param    cv \<value> A comparison value.

  \returns  <boolean> \b true when any element of \p v equals the value
            \p cv and \b false otherwise. Returns \b false when \p v is
            empty.
*******************************************************************************/
function any_equal
(
  v,
  cv
) = !is_iterable(v) ? (v == cv)
  : is_empty(v) ? false
  : (first(v) == cv) ? true
  : any_equal(tailn(v), cv);

//! Test if all elements of an iterable value equal one of the comparison values.
/***************************************************************************//**
  \param    v <iterable> An iterable data type value.
  \param    cv \<value> An iterable of one more more comparison values.

  \returns  <boolean> \b true when all elements of \p v equal one of
            the values in \p cv and \b false otherwise.
            Returns \b true when \p v is empty.

  \details

    When \p v is a string, \p cv must also be a string.
*******************************************************************************/
function all_oneof
(
  v,
  cv
) = let
  (
     v_i = is_iterable(v),
    cv_i = is_iterable(cv)
  )
    (!v_i && !cv_i) ? (v == cv)
  : ( v_i && !cv_i) ? all_equal(v, cv)
  : (!v_i &&  cv_i) ? any_equal(cv, v)
    // v_i && cv_i: case 'v' is a string and 'cv' is not a string
  : (is_string(v) && !is_string(cv)) ? false
    // v_i && cv_i: remaining three cases
  : !any_equal(search(v, cv, 0, 0), empty_lst);

//! Test if no element of an iterable value has an undefined value.
/***************************************************************************//**
  \param    v <iterable> An iterable data type value.

  \returns  <boolean> \b true when no element of \p v has its value
            equal to \b undef and \b false otherwise. Returns \b true
            when the iterable \p v is empty.
*******************************************************************************/
function all_defined(v) = !any_equal(v, undef);

//! Test if at least one element of an iterable value has a defined value.
/***************************************************************************//**
  \param    v <iterable> An iterable data type value.

  \returns  <boolean> \b true when any element of \p v has a defined
            value and \b false otherwise. Returns \b false when \p v is
            empty.
*******************************************************************************/
function any_defined(v) = !all_equal(v, undef);

//! Test if at least one element of an iterable value has an undefined value.
/***************************************************************************//**
  \param    v <iterable> An iterable data type value.

  \returns  <boolean> \b true when any element of \p v has an undefined
            value and \b false otherwise. Returns \b false when \p v is
            empty.
*******************************************************************************/
function any_undefined(v) = any_equal(v, undef);

//! Test if all elements of an iterable value are scalar values.
/***************************************************************************//**
  \param    v <iterable> An iterable data type value.

  \returns  <boolean> \b true when all elements of \p v are scalar
            values and \b false otherwise. Returns \b true when \p v is
            a single scalar value and \b true when the \p v is an empty,
            or undefined.
*******************************************************************************/
function all_scalars
(
  v
) = !is_iterable(v) ? true
  : is_empty(v) ? true
  : !is_scalar(first(v)) ? false
  : all_scalars(tailn(v));

//! Test if all elements of an iterable value are iterable.
/***************************************************************************//**
  \param    v <iterable> An iterable data type value.

  \returns  <boolean> \b true when all elements of \p v are iterable
            and \b false otherwise. Returns \b true when \p v is a
            single iterable value and returns \b true when \p v is a
            empty. Returns \b false when \p v is undefined.
*******************************************************************************/
function all_iterables
(
  v
) = !is_iterable(v) ? false
  : is_empty(v) ? true
  : !is_iterable(first(v)) ? false
  : all_iterables(tailn(v));

//! Test if all elements of an iterable value are lists.
/***************************************************************************//**
  \param    v <iterable> An iterable data type value.
  \param    c <integer> (\em internal) Count of passing comparisons.

  \returns  <boolean> \b true when all elements of \p v are lists
            and \b false otherwise. Returns \b true when \p v is a
            single iterable list.

  \details

  \note     The parameter \p c is an internal variable used to count
            the number of successful comparisons performed while
            traversing \p v. This parameter should not be initialized
            under normal circumstances.
*******************************************************************************/
function all_lists
(
  v,
  c = 0
) = !is_iterable(v) ? false
  : is_empty(v) ? ((c>0) || is_list(v))
  : !is_list(first(v)) ? false
  : all_lists(tailn(v), c+1);

//! Test if all elements of an iterable value are strings.
/***************************************************************************//**
  \param    v <iterable> An iterable data type value.
  \param    c <integer> (\em internal) Count of passing comparisons.

  \returns  <boolean> \b true when all elements of \p v are strings
            and \b false otherwise. Returns \b true when \p v is a
            single string.

  \details

  \note     The parameter \p c is an internal variable used to count
            the number of successful comparisons performed while
            traversing \p v. This parameter should not be initialized
            under normal circumstances.
*******************************************************************************/
function all_strings
(
  v,
  c = 0
) = !is_iterable(v) ? false
  : is_empty(v) ? ((c>0) || is_string(v))
  : !is_string(first(v)) ? false
  : all_strings(tailn(v), c+1);

//! Test if all elements of an iterable value are numbers.
/***************************************************************************//**
  \param    v <iterable> An iterable data type value.
  \param    c <integer> (\em internal) Count of passing comparisons.

  \returns  <boolean> \b true when all elements of \p v are numerical
            values and \b false otherwise. Returns \b true when \p v is
            a single numerical value.

  \details

  \note     The parameter \p c is an internal variable used to count
            the number of successful comparisons performed while
            traversing \p v. This parameter should not be initialized
            under normal circumstances.
*******************************************************************************/
function all_numbers
(
  v,
  c = 0
) = !is_iterable(v) ? is_number(v)
  : is_empty(v) ? (c>0)
  : !is_number(first(v)) ? false
  : all_numbers(tailn(v), c+1);

//! Test if all elements of an iterable value are iterable with a fixed length.
/***************************************************************************//**
  \param    v <iterable> An iterable data type value.
  \param    l <integer> The required length of each value.

  \returns  <boolean> \b true when all elements of \p v are iterable
            values with lengths equal to \p l and \b false otherwise.
*******************************************************************************/
function all_len
(
  v,
  l,
  c = 0
) = !is_iterable(v) ? false
  : is_empty(v) ? (c>0)
  : !is_iterable(first(v)) ? false
  : (len(first(v)) != l) ? false
  : all_len(tailn(v),l, c+1);

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
      fmt("t01", "The undefined value",         undef),
      fmt("t02", "An odd integer",              1),
      fmt("t03", "The boolean true",            true),
      fmt("t04", "The boolean false",           false),
      fmt("t05", "A character string",          "a"),
      fmt("t06", "A string",                    "This is a longer string"),
      fmt("t07", "The empty string",            empty_str),
      fmt("t08", "The empty list",              empty_lst),
      fmt("t09", "A shorthand range",           [0:9]),
      fmt("t10", "A range",                     [0:0.5:9]),
      fmt("t11", "Single item list: 1 undef",   [undef]),
      fmt("t12", "Single item list: 1 number",  [1]),
      fmt("t13", "List of 3 numbers",           [1, 2, 3]),
      fmt("t14", "List of single num lists",    [[1], [2], [3], [4], [5]]),
      fmt("t15", "List of number pairs",        [[1,2], [2,3]]),
      fmt("t16", "List of num pairs and str",   [[1,2], [2,3], [4,5], "ab"]),
      fmt("t17", "List of mixed tuples",        [[1,2,3], [4,5,6], [7,8,9], ["a", "b", "c"]]),
      fmt("t18", "List of number with undef",   [1, 2, 3, undef]),
      fmt("t19", "List of items, all = undef",  [undef, undef, undef, undef]),
      fmt("t20", "List of lists, all = undef",  [[undef], [undef], [undef]]),
      fmt("t21", "List of mixed booleans mt",   [true, true, true, true, false]),
      fmt("t22", "List of mixed booleans mf",   [true, false, false, false, false]),
      fmt("t23", "List of booleans = true",     [true, true, true, true])
    ];

    tbl_test_answers =
    [ // function            01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23
      ["is_iterable",         f, f, f, f, t, t, t, t, f, f, t, t, t, t, t, t, t, t, t, t, t, t, t],
      ["is_empty",            t, t, t, t, f, f, t, t, t, t, f, f, f, f, f, f, f, f, f, f, f, f, f],
      ["all_equal_T",         f, f, t, f, f, f, t, t, f, f, f, f, f, f, f, f, f, f, f, f, f, f, t],
      ["all_equal_F",         f, f, f, t, f, f, t, t, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f],
      ["all_equal_U",         t, f, f, f, f, f, t, t, f, f, t, f, f, f, f, f, f, f, t, f, f, f, f],
      ["any_equal_T",         f, f, t, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, t, t, t],
      ["any_equal_F",         f, f, f, t, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, t, t, f],
      ["any_equal_U",         t, f, f, f, f, f, f, f, f, f, t, f, f, f, f, f, f, t, t, f, f, f, f],
      ["all_oneof_S1",        t, t, t, t, f, f, f, t, f, f, t, t, t, f, f, f, f, t, t, f, t, t, t],
      ["all_defined",         f, t, t, t, t, t, t, t, t, t, f, t, t, t, t, t, t, f, f, t, t, t, t],
      ["any_defined",         f, t, t, t, t, t, f, f, t, t, f, t, t, t, t, t, t, t, f, t, t, t, t],
      ["any_undefined",       t, f, f, f, f, f, f, f, f, f, t, f, f, f, f, f, f, t, t, f, f, f, f],
      ["all_scalars",         t, t, t, t, f, f, t, t, t, t, t, t, t, f, f, f, f, t, t, f, t, t, t],
      ["all_iterables",       f, f, f, f, t, t, t, t, f, f, f, f, f, t, t, t, t, f, f, t, f, f, f],
      ["all_lists",           f, f, f, f, f, f, f, t, f, f, f, f, f, t, t, f, t, f, f, t, f, f, f],
      ["all_strings",         f, f, f, f, t, t, t, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f],
      ["all_numbers",         f, t, f, f, f, f, f, f, f, f, f, t, t, f, f, f, f, f, f, f, f, f, f],
      ["all_len_1",           f, f, f, f, t, t, f, f, f, f, f, f, f, t, f, f, f, f, f, t, f, f, f],
      ["all_len_2",           f, f, f, f, f, f, f, f, f, f, f, f, f, f, t, t, f, f, f, f, f, f, f],
      ["all_len_3",           f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, t, f, f, f, f, f, f]
    ];

    db = table_validate_init( tbl_test_values, tbl_test_answers );

    table_validate_start( db );
    test_ids = table_validate_get_ids( db );

    for (id=test_ids) table_validate( db, id, "is_iterable", 1, is_iterable( v1(db,id) ) );
    for (id=test_ids) table_validate( db, id, "is_empty", 1, is_empty( v1(db,id) ) );
    for (id=test_ids) table_validate( db, id, "all_equal_T", 1, all_equal( v1(db,id), t ) );
    for (id=test_ids) table_validate( db, id, "all_equal_F", 1, all_equal( v1(db,id), f ) );
    for (id=test_ids) table_validate( db, id, "all_equal_U", 1, all_equal( v1(db,id), u ) );
    for (id=test_ids) table_validate( db, id, "any_equal_T", 1, any_equal( v1(db,id), t ) );
    for (id=test_ids) table_validate( db, id, "any_equal_F", 1, any_equal( v1(db,id), f ) );
    for (id=test_ids) table_validate( db, id, "any_equal_U", 1, any_equal( v1(db,id), u ) );
    for (id=test_ids) table_validate( db, id, "all_oneof_S1", 1, all_oneof( v1(db,id), [undef, 1, 2, 3, true, false] ) );
    for (id=test_ids) table_validate( db, id, "all_defined", 1, all_defined( v1(db,id) ) );
    for (id=test_ids) table_validate( db, id, "any_defined", 1, any_defined( v1(db,id) ) );
    for (id=test_ids) table_validate( db, id, "any_undefined", 1, any_undefined( v1(db,id) ) );
    for (id=test_ids) table_validate( db, id, "all_scalars", 1, all_scalars( v1(db,id) ) );
    for (id=test_ids) table_validate( db, id, "all_iterables", 1, all_iterables( v1(db,id) ) );
    for (id=test_ids) table_validate( db, id, "all_lists", 1, all_lists( v1(db,id) ) );
    for (id=test_ids) table_validate( db, id, "all_strings", 1, all_strings( v1(db,id) ) );
    for (id=test_ids) table_validate( db, id, "all_numbers", 1, all_numbers( v1(db,id) ) );

    for (id=test_ids) table_validate( db, id, "all_len_1", 1, all_len( v1(db,id), 1 ) );
    for (id=test_ids) table_validate( db, id, "all_len_2", 1, all_len( v1(db,id), 2 ) );
    for (id=test_ids) table_validate( db, id, "all_len_3", 1, all_len( v1(db,id), 3 ) );

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
