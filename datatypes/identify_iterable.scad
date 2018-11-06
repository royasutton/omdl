//! Iterable data type identification.
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

*******************************************************************************/

//----------------------------------------------------------------------------//
// validation.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \page tv_datatypes_identify
    \li \subpage tv_datatypes_identify_iterable

  \page tv_datatypes_identify_iterable Iterables
    \li \subpage tv_datatypes_identify_iterable_s
    \li \subpage tv_datatypes_identify_iterable_r

  \page tv_datatypes_identify_iterable_s Script
    \dontinclude identify_iterable_validate.scad
    \skip include
    \until end-of-tests
  \page tv_datatypes_identify_iterable_r Results
    \include identify_iterable_validate.log
*******************************************************************************/

//----------------------------------------------------------------------------//
// group.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \addtogroup datatypes_identify
  @{

  \defgroup datatypes_identify_iterable Iterables
  \brief    Iterable data type identification.

  \details

    See validation \ref tv_datatypes_identify_iterable_r "results".
  @{
*******************************************************************************/

//----------------------------------------------------------------------------//

//! Test if a list of values equal a comparison value.
/***************************************************************************//**
  \param    v \<list> A list of values.
  \param    cv \<value> A comparison value.

  \returns  <boolean> \b true when all elements equal the value \p cv
            and \b false otherwise.

  \details

  \warning  Always returns \b true when the list is empty.
*******************************************************************************/
function all_equal
(
  v,
  cv
) = !is_iterable(v) ? (v == cv)
  : is_empty(v) ? true
  : (first(v) != cv) ? false
  : all_equal(ntail(v), cv);

//! Test if any element of a list of values equal a comparison value.
/***************************************************************************//**
  \param    v \<list> A list of values.
  \param    cv \<value> A comparison value.

  \returns  <boolean> \b true when any element equals the value \p cv
            and \b false otherwise.

  \details

  \warning  Always returns \b false when the list is empty.
*******************************************************************************/
function any_equal
(
  v,
  cv
) = !is_iterable(v) ? (v == cv)
  : is_empty(v) ? false
  : (first(v) == cv) ? true
  : any_equal(ntail(v), cv);

//! Test if no element of a list of values is undefined.
/***************************************************************************//**
  \param    v \<list> A list of values.

  \returns  <boolean> \b true when no element is undefined
            and \b false otherwise.

  \details

  \warning  Always returns \b true when the list is empty.
*******************************************************************************/
function all_defined(v) = !any_equal(v, undef);

//! Test if any element of a list of values is undefined.
/***************************************************************************//**
  \param    v \<list> A list of values.

  \returns  <boolean> \b true when any element is undefined
            and \b false otherwise.

  \details

  \warning  Always returns \b false when the list is empty.
*******************************************************************************/
function any_undefined(v) = any_equal(v, undef);

//! Test if all elements of a list of values are scalars.
/***************************************************************************//**
  \param    v \<list> A list of values.

  \returns  <boolean> \b true when all elements are scalar values
            and \b false otherwise.
            Returns \b true when the list is a single scalar value.

  \details

  \warning  Always returns \b true when the list is empty.
*******************************************************************************/
function all_scalars
(
  v
) = not_defined(v) ? undef
  : is_scalar(v) ? true
  : is_empty(v) ? true
  : !is_scalar(first(v)) ? false
  : all_scalars(ntail(v));

//! Test if all elements of a list of values are lists.
/***************************************************************************//**
  \param    v \<list> A list of values.

  \returns  <boolean> \b true when all elements are lists
            and \b false otherwise.
            Returns \b true when the list is a single list value.

  \details

  \warning  Always returns \b true when the list is empty.
*******************************************************************************/
function all_lists
(
  v
) = not_defined(v) ? undef
  : is_scalar(v) ? false
  : is_empty(v) ? true
  : !is_list(first(v)) ? false
  : all_lists(ntail(v));

//! Test if all elements of a list of values are strings.
/***************************************************************************//**
  \param    v \<list> A list of values.

  \returns  <boolean> \b true when all elements are string values
            and \b false otherwise.
            Returns \b true when the list is a single string value.

  \details

  \warning  Always returns \b true when the list is empty.
*******************************************************************************/
function all_strings
(
  v
) = not_defined(v) ? undef
  : is_scalar(v) ? false
  : is_empty(v) ? true
  : !is_string(first(v)) ? false
  : all_strings(ntail(v));

//! Test if all elements of a list of values are numbers.
/***************************************************************************//**
  \param    v \<list> A list of values.

  \returns  <boolean> \b true when all elements are numerical values
            and \b false otherwise.
            Returns \b true when the list is a single numerical value.

  \details

  \warning  Always returns \b true when the list is empty.
*******************************************************************************/
function all_numbers
(
  v
) = not_defined(v) ? undef
  : is_scalar(v) ? is_number(v)
  : is_empty(v) ? true
  : !is_number(first(v)) ? false
  : all_numbers(ntail(v));

//! Test if all elements of a list of values are lists of a specified length.
/***************************************************************************//**
  \param    v \<list> A list of values.
  \param    l <integer> The test length.

  \returns  <boolean> \b true when all elements are lists of the specified
            length and \b false otherwise.
            Returns \b true when the list is a single list of length \p l.

  \details

  \warning  Always returns \b true when \p v is empty.
*******************************************************************************/
function all_len
(
  v,
  l
) = not_defined(v) ? undef
  : is_scalar(v) ? false
  : is_empty(v) ? true
  : (len(first(v)) != l) ? false
  : all_len(ntail(v),l);

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE validate;
  BEGIN_OPENSCAD;
    include <console.scad>;
    include <datatypes/datatypes-base.scad>;
    include <datatypes/table.scad>;
    include <validation.scad>;

    show_passing = true;    // show passing tests
    show_skipped = true;    // show skipped tests

    echo( str("OpenSCAD Version ", version()) );

    // test-values columns
    test_c =
    [
      ["id", "identifier"],
      ["td", "description"],
      ["tv", "test value"]
    ];

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
      ["t11", "Test list 01",               [undef]],
      ["t12", "Test list 02",               [1]],
      ["t13", "Test list 03",               [1, 2, 3]],
      ["t14", "Test list 04",               [[1], [2], [3], [4], [5]]],
      ["t15", "Test list 05",               [[1,2], [2,3]]],
      ["t16", "Test list 06",               [[1,2], [2,3], [4,5], "ab"]],
      ["t17", "Test list 07",               [[1,2,3], [4,5,6], [7,8,9], ["a", "b", "c"]]],
      ["t18", "Test list 08",               [1, 2, 3, undef]],
      ["t19", "Test list 09",               [undef, undef, undef, undef]],
      ["t20", "Test list 10",               [[undef], [undef], [undef]]],
      ["t21", "Test list 11",               [true, true, true, true, false]],
      ["t22", "Test list 12",               [true, false, false, false, false]],
      ["t23", "Test list 13",               [true, true, true, true]]
    ];

    test_ids = get_table_ridl( test_r );

    // expected columns: ("id" + one column for each test)
    good_c = pmerge([concat("id", test_ids), concat("identifier", test_ids)]);

    // expected rows: ("golden" test results), use 's' to skip test
    t = true;   // shortcuts
    f = false;
    u = undef;
    s = -1;     // skip test

    good_r =
    [ // function           01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23
      ["all_equal_T",       f, f, t, f, f, f, t, t, f, f, f, f, f, f, f, f, f, f, f, f, f, f, t],
      ["all_equal_F",       f, f, f, t, f, f, t, t, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f],
      ["all_equal_U",       t, f, f, f, f, f, t, t, f, f, t, f, f, f, f, f, f, f, t, f, f, f, f],
      ["any_equal_T",       f, f, t, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, t, t, t],
      ["any_equal_F",       f, f, f, t, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, t, t, f],
      ["any_equal_U",       t, f, f, f, f, f, f, f, f, f, t, f, f, f, f, f, f, t, t, f, f, f, f],
      ["all_defined",       f, t, t, t, t, t, t, t, t, t, f, t, t, t, t, t, t, f, f, t, t, t, t],
      ["any_undefined",     t, f, f, f, f, f, f, f, f, f, t, f, f, f, f, f, f, t, t, f, f, f, f],
      ["all_scalars",       u, t, t, t, f, f, s, s, s, s, t, t, t, f, f, f, f, t, t, f, t, t, t],
      ["all_lists",         u, f, f, f, f, f, t, t, f, f, f, f, f, t, t, f, t, f, f, t, f, f, f],
      ["all_strings",       u, f, f, f, t, t, t, s, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f],
      ["all_numbers",       u, t, f, f, f, f, s, s, f, f, f, t, t, f, f, f, f, f, f, f, f, f, f],
      ["all_len_1",         u, f, f, f, t, t, s, s, f, f, f, f, f, t, f, f, f, f, f, t, f, f, f],
      ["all_len_2",         u, f, f, f, f, f, s, s, f, f, f, f, f, f, t, t, f, f, f, f, f, f, f],
      ["all_len_3",         u, f, f, f, f, f, s, s, f, f, f, f, f, f, f, f, t, f, f, f, f, f, f]
    ];

    // sanity-test tables
    table_check( test_r, test_c, false );
    table_check( good_r, good_c, false );

    // validate helper function and module
    function get_value( vid ) = get_table_v(test_r, test_c, vid, "tv");
    module run_test( fname, fresult, vid )
    {
      value_text = get_table_v(test_r, test_c, vid, "td");
      pass_value = get_table_v(good_r, good_c, fname, vid);

      test_pass = validate( cv=fresult, t="equals", ev=pass_value, pf=true );
      test_text = validate( str(fname, "(", get_value(vid), ")=", pass_value), fresult, "equals", pass_value );

      if ( pass_value != s )
      {
        if ( !test_pass )
          log_warn( str(vid, "(", value_text, ") ", test_text) );
        else if ( show_passing )
          log_info( str(vid, " ", test_text) );
      }
      else if ( show_skipped )
        log_info( str(vid, " *skip*: '", fname, "(", value_text, ")'") );
    }

    // Indirect function calls would be very useful here!!!
    for (vid=test_ids) run_test( "all_equal_T", all_equal(get_value(vid),t), vid );
    for (vid=test_ids) run_test( "all_equal_F", all_equal(get_value(vid),f), vid );
    for (vid=test_ids) run_test( "all_equal_U", all_equal(get_value(vid),u), vid );
    for (vid=test_ids) run_test( "any_equal_T", any_equal(get_value(vid),t), vid );
    for (vid=test_ids) run_test( "any_equal_F", any_equal(get_value(vid),f), vid );
    for (vid=test_ids) run_test( "any_equal_U", any_equal(get_value(vid),u), vid );
    for (vid=test_ids) run_test( "all_defined", all_defined(get_value(vid)), vid );
    for (vid=test_ids) run_test( "any_undefined", any_undefined(get_value(vid)), vid );
    for (vid=test_ids) run_test( "all_scalars", all_scalars(get_value(vid)), vid );
    for (vid=test_ids) run_test( "all_lists", all_lists(get_value(vid)), vid );
    for (vid=test_ids) run_test( "all_strings", all_strings(get_value(vid)), vid );
    for (vid=test_ids) run_test( "all_numbers", all_numbers(get_value(vid)), vid );
    for (vid=test_ids) run_test( "all_len_1", all_len(get_value(vid),1), vid );
    for (vid=test_ids) run_test( "all_len_2", all_len(get_value(vid),2), vid );
    for (vid=test_ids) run_test( "all_len_3", all_len(get_value(vid),3), vid );

    // end-of-tests
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {config_base,config_csg}.mfs;
    include --path "${INCLUDE_PATH}" script_std.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
