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

    \amu_define group_name  (Iterable Identification)
    \amu_define group_brief (Iterable data type tests.)
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
  \param    v \<value> An iterable value.

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
  \param    v \<list> An iterable data type value.
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
  : all_equal(ntail(v), cv);

//! Test if any element of an iterable value equal a comparison value.
/***************************************************************************//**
  \param    v \<list> An iterable data type value.
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
  : any_equal(ntail(v), cv);

//! Test if no element of an iterable value has an undefined value.
/***************************************************************************//**
  \param    v \<list> An iterable data type value.

  \returns  <boolean> \b true when no element of \p v has its value
            equal to \b undef and \b false otherwise. Returns \b true
            when the list \p v is empty.
*******************************************************************************/
function all_defined(v) = !any_equal(v, undef);

//! Test if at least one element of an iterable value has a defined value.
/***************************************************************************//**
  \param    v \<list> An iterable data type value.

  \returns  <boolean> \b true when any element of \p v has a defined
            value and \b false otherwise. Returns \b false when \p v is
            empty.
*******************************************************************************/
function any_defined(v) = !all_equal(v, undef);

//! Test if at least one element of an iterable value has an undefined value.
/***************************************************************************//**
  \param    v \<list> An iterable data type value.

  \returns  <boolean> \b true when any element of \p v has an undefined
            value and \b false otherwise. Returns \b false when \p v is
            empty.
*******************************************************************************/
function any_undefined(v) = any_equal(v, undef);

//! Test if all elements of an iterable value are scalar values.
/***************************************************************************//**
  \param    v \<list> An iterable data type value.

  \returns  <boolean> \b true when all elements of \p v are scalar
            values and \b false otherwise. Returns \b true when \p v is
            a single scalar value and \b true when the \p v is an empty
            list, empty string, or undefined.
*******************************************************************************/
function all_scalars
(
  v
) = !is_iterable(v) ? true
  : is_empty(v) ? true
  : !is_scalar(first(v)) ? false
  : all_scalars(ntail(v));

//! Test if all elements of an iterable value are iterable.
/***************************************************************************//**
  \param    v \<list> An iterable data type value.

  \returns  <boolean> \b true when all elements of \p v are iterable
            and \b false otherwise. Returns \b true when \p v is a
            single iterable value and returns \b true when \p v is an
            empty list or empty string. Returns \b false when \p v is
            undefined.
*******************************************************************************/
function all_iterables
(
  v
) = !is_iterable(v) ? false
  : is_empty(v) ? true
  : !is_iterable(first(v)) ? false
  : all_iterables(ntail(v));

//! Test if all elements of an iterable value are lists.
/***************************************************************************//**
  \param    v \<list> An iterable data type value.
  \param    c \<integer> (\em internal) Count of passing comparasions.

  \returns  <boolean> \b true when all elements of \p v are lists
            and \b false otherwise. Returns \b true when \p v is a
            single iterable list.

  \details

  \note     The parameter \p c is an internal variable used to count
            the number of successful comparasion performed while
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
  : all_lists(ntail(v), c+1);

//! Test if all elements of an iterable value are strings.
/***************************************************************************//**
  \param    v \<list> An iterable data type value.
  \param    c \<integer> (\em internal) Count of passing comparasions.

  \returns  <boolean> \b true when all elements of \p v are strings
            and \b false otherwise. Returns \b true when \p v is a
            single string.

  \details

  \note     The parameter \p c is an internal variable used to count
            the number of successful comparasion performed while
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
  : all_strings(ntail(v), c+1);

//! Test if all elements of an iterable value are numbers.
/***************************************************************************//**
  \param    v \<list> An iterable data type value.
  \param    c \<integer> (\em internal) Count of passing comparasions.

  \returns  <boolean> \b true when all elements of \p v are numerical
            values and \b false otherwise. Returns \b true when \p v is
            a single numerical value.

  \details

  \note     The parameter \p c is an internal variable used to count
            the number of successful comparasion performed while
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
  : all_numbers(ntail(v), c+1);

//! Test if all elements of an iterable value are iterable with a fixed length.
/***************************************************************************//**
  \param    v \<list> An iterable data type value.
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
  : all_len(ntail(v),l, c+1);

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

    t = true; f = false; u = undef; s = -1;

    function get_value( id ) = table_get_value(test_r, test_c, id, "tv");
    module log_test( m ) { log_type ( "OMDL_TEST", m ); }
    module log_skip( fn ) { log_test ( str("not tested: '", fn, "'") ); }
    module run_test( fn, fr, id )
    {
      td = table_get_value(test_r, test_c, id, "td");
      ev = table_get_value(good_r, good_c, fn, id);

      if ( ev != s )
      {
        d=str(fn, "(", get_value(id), ")=", ev);
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
    test_c = [ ["id", "identifier"], ["td", "description"], ["tv", "test value"] ];

    // test-values rows
    test_r =
    [
      ["t01", "The undefined value",        undef],
      ["t02", "An odd integer",             1],
      ["t03", "The boolean true",           true],
      ["t04", "The boolean false",          false],
      ["t05", "A character string",         "a"],
      ["t06", "A string",                   "This is a longer string"],
      ["t07", "The empty string",           empty_str],
      ["t08", "The empty list",             empty_lst],
      ["t09", "A shorthand range",          [0:9]],
      ["t10", "A range",                    [0:0.5:9]],
      ["t11", "Single item list: 1 undef",  [undef]],
      ["t12", "Single item list: 1 number", [1]],
      ["t13", "List of 3 numbers",          [1, 2, 3]],
      ["t14", "List of single num lists",   [[1], [2], [3], [4], [5]]],
      ["t15", "List of number pairs",       [[1,2], [2,3]]],
      ["t16", "List of num pairs and str",  [[1,2], [2,3], [4,5], "ab"]],
      ["t17", "List of mixed tuples",       [[1,2,3], [4,5,6], [7,8,9], ["a", "b", "c"]]],
      ["t18", "List of number with undef",  [1, 2, 3, undef]],
      ["t19", "List of items, all = undef", [undef, undef, undef, undef]],
      ["t20", "List of lists, all = undef", [[undef], [undef], [undef]]],
      ["t21", "List of mixed booleans mt",  [true, true, true, true, false]],
      ["t22", "List of mixed booleans mf",  [true, false, false, false, false]],
      ["t23", "List of booleans = true",    [true, true, true, true]]
    ];
    table_check( test_r, test_c, false );   // sanity-test

    test_ids = table_get_row_ids( test_r );

    // expected columns: ("id" + one column for each test)
    good_c = pmerge([concat("id", test_ids), concat("identifier", test_ids)]);

    // expected rows: ("golden" test results), use 's' to skip test
    good_r =
    [ // function       01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23
      ["is_iterable",   f, f, f, f, t, t, t, t, f, f, t, t, t, t, t, t, t, t, t, t, t, t, t],
      ["is_empty",      t, t, t, t, f, f, t, t, t, t, f, f, f, f, f, f, f, f, f, f, f, f, f],
      ["all_equal_T",   f, f, t, f, f, f, t, t, f, f, f, f, f, f, f, f, f, f, f, f, f, f, t],
      ["all_equal_F",   f, f, f, t, f, f, t, t, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f],
      ["all_equal_U",   t, f, f, f, f, f, t, t, f, f, t, f, f, f, f, f, f, f, t, f, f, f, f],
      ["any_equal_T",   f, f, t, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, t, t, t],
      ["any_equal_F",   f, f, f, t, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, t, t, f],
      ["any_equal_U",   t, f, f, f, f, f, f, f, f, f, t, f, f, f, f, f, f, t, t, f, f, f, f],
      ["all_defined",   f, t, t, t, t, t, t, t, t, t, f, t, t, t, t, t, t, f, f, t, t, t, t],
      ["any_defined",   f, t, t, t, t, t, f, f, t, t, f, t, t, t, t, t, t, t, f, t, t, t, t],
      ["any_undefined", t, f, f, f, f, f, f, f, f, f, t, f, f, f, f, f, f, t, t, f, f, f, f],
      ["all_scalars",   t, t, t, t, f, f, t, t, t, t, t, t, t, f, f, f, f, t, t, f, t, t, t],
      ["all_iterables", f, f, f, f, t, t, t, t, f, f, f, f, f, t, t, t, t, f, f, t, f, f, f],
      ["all_lists",     f, f, f, f, f, f, f, t, f, f, f, f, f, t, t, f, t, f, f, t, f, f, f],
      ["all_strings",   f, f, f, f, t, t, t, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f],
      ["all_numbers",   f, t, f, f, f, f, f, f, f, f, f, t, t, f, f, f, f, f, f, f, f, f, f],
      ["all_len_1",     f, f, f, f, t, t, f, f, f, f, f, f, f, t, f, f, f, f, f, t, f, f, f],
      ["all_len_2",     f, f, f, f, f, f, f, f, f, f, f, f, f, f, t, t, f, f, f, f, f, f, f],
      ["all_len_3",     f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, t, f, f, f, f, f, f]
    ];
    table_check( good_r, good_c, false );   // sanity-test

    // Indirect function calls would be very useful here!!!
    for (vid=test_ids) run_test( "is_iterable", is_iterable(get_value(vid)), vid );
    for (vid=test_ids) run_test( "is_empty", is_empty(get_value(vid)), vid );
    for (vid=test_ids) run_test( "all_equal_T", all_equal(get_value(vid),t), vid );
    for (vid=test_ids) run_test( "all_equal_F", all_equal(get_value(vid),f), vid );
    for (vid=test_ids) run_test( "all_equal_U", all_equal(get_value(vid),u), vid );
    for (vid=test_ids) run_test( "any_equal_T", any_equal(get_value(vid),t), vid );
    for (vid=test_ids) run_test( "any_equal_F", any_equal(get_value(vid),f), vid );
    for (vid=test_ids) run_test( "any_equal_U", any_equal(get_value(vid),u), vid );
    for (vid=test_ids) run_test( "all_defined", all_defined(get_value(vid)), vid );
    for (vid=test_ids) run_test( "any_defined", any_defined(get_value(vid)), vid );
    for (vid=test_ids) run_test( "any_undefined", any_undefined(get_value(vid)), vid );
    for (vid=test_ids) run_test( "all_scalars", all_scalars(get_value(vid)), vid );
    for (vid=test_ids) run_test( "all_iterables", all_iterables(get_value(vid)), vid );
    for (vid=test_ids) run_test( "all_lists", all_lists(get_value(vid)), vid );
    for (vid=test_ids) run_test( "all_strings", all_strings(get_value(vid)), vid );
    for (vid=test_ids) run_test( "all_numbers", all_numbers(get_value(vid)), vid );
    for (vid=test_ids) run_test( "all_len_1", all_len(get_value(vid),1), vid );
    for (vid=test_ids) run_test( "all_len_2", all_len(get_value(vid),2), vid );
    for (vid=test_ids) run_test( "all_len_3", all_len(get_value(vid),3), vid );

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
