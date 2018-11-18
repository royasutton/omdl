//! List data type tests.
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

    \amu_pathid path    (++path)

    \amu_define parent  (${path}_identify)
    \amu_pathid group   (++path ++stem)

  \ingroup \amu_eval(${parent} ${group})
*******************************************************************************/

//----------------------------------------------------------------------------//
// validation.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \page tv_\amu_eval(${parent})
    \li \subpage tv_\amu_eval(${group})

  \page tv_\amu_eval(${group}) Lists
    \li \subpage tv_\amu_eval(${group})_s
    \li \subpage tv_\amu_eval(${group})_r

  \page tv_\amu_eval(${group})_s Script
    \dontinclude \amu_scope(index=1).scad
    \skip include
    \until end-of-tests

  \page tv_\amu_eval(${group})_r Results
    \include \amu_scope(index=1).log
*******************************************************************************/

//----------------------------------------------------------------------------//
// group.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \addtogroup \amu_eval(${parent})
  @{

  \defgroup \amu_eval(${group}) Lists
  \brief    List data type tests.

  \details

    See validation \ref tv_\amu_eval(${group})_r "results".
  @{
*******************************************************************************/

//----------------------------------------------------------------------------//

//! Test if all elements of two lists of numbers are sufficiently equal.
/***************************************************************************//**
  \param    v1 <number-list> A list of numbers 1.
  \param    v2 <number-list> A list of numbers 2.
  \param    p <number> The numerical precision.

  \returns  <boolean> \b true when the distance between \p v1 and \p v2
            is less than \p d and \b false otherwise.
            Returns \b false when either list contains a non-numerica
            values, or when the lists are not of the same length.

  \details

    The 'distance' between two numbers must be less than pow(10,-p) to
    be considered almost equal.

  \note     To compare general lists of values see almost_equal().
*******************************************************************************/
function n_almost_equal
(
  v1,
  v2,
  p = 6
) = (len(v1) != len(v2)) ? false
  : ( (sqrt((v1-v2)*(v1-v2)) * pow(10, p)) < 1 );

//! Test if all numerical elements of two lists of values are sufficiently equal.
/***************************************************************************//**
  \param    v1 \<list> A list of values 1.
  \param    v2 \<list> A list of values 2.
  \param    p <number> The numerical precision.

  \returns  <boolean> \b true when all elements of each lists are
            sufficiently equal and \b false otherwise.

  \details

    The 'distance' between two numbers must be less than pow(10,-p) to
    be considered almost equal. All numerical comparisons are performed
    to the specified precision. All non-numeric comparisons test for
    equality.

  \note     If the lists are scalar numbers, the function n_almost_equal()
            provides a more efficient test.

  \warning  Always returns \b true when both lists are empty.
*******************************************************************************/
function almost_equal
(
  v1,
  v2,
  p = 6
) = all_numbers([v1, v2]) ? n_almost_equal(v1, v2, p)
  : all_scalars([v1, v2]) ? (v1 == v2)
  : (is_string(v1) || is_string(v2)) ? (v1 == v2)
  : all_equal([v1, v2], empty_lst) ? true
  : any_equal([v1, v2], empty_lst) ? false
  : !almost_equal(first(v1), first(v2), p) ? false
  : almost_equal(ntail(v1), ntail(v2), p);

//! Order to lists of arbitrary values.
/***************************************************************************//**
  \param    v1 \<list> A list of values 1.
  \param    v2 \<list> A list of values 2.
  \param    s <boolean> Order ranges by their numerical sum.

  \returns  <integer> \b -1 when <tt>(v2 < v1)</tt>,
                      \b +1 when <tt>(v2 > v1)</tt>, and
                      \b  0 when <tt>(v2 == v1)</tt>.

  \details

    The following table summarizes how values are ordered.

     order | type     | \p s      | intra-type ordering
    :-----:|:--------:|:---------:|:--------------------------------------
      1    | \b undef |           | (singular)
      2    | number   |           | numerical comparison
      3    | boolean  |           | \b false \< \b true
      4    | string   |           | lexical comparison
      5    | list     |           | lengths then element-wise comparison
      6    | range    | \b true   | compare sum of range elements
      6    | range    | \b false  | lengths then element-wise comparison

  \note     When comparing two lists of equal length, the comparison
            continue element-by-element until an ordering can be
            determined. Two lists are equal when all elements have been
            compared and no ordering has been determined.

  \warning  The performance of element-wise comparisons of lists degrades
            with list size.
  \warning  The sum of a range may exceeded the intermediate variable
            storage capacity for long ranges.
*******************************************************************************/
function compare
(
  v1,
  v2,
  s = true
) = let( v2_nd = not_defined(v2) )
    not_defined(v1) ?
    (
      v2_nd ? 0
    : 1 // others are greater
    )
  // v1 a number
  : let( v2_in = is_number(v2) )
    is_number(v1) ?
    (
      v2_nd ? -1
    : v2_in ?
      (
        (v1 > v2) ? -1
      : (v2 > v1) ? +1
      : 0
      )
    : 1 // others are greater
    )
  // v1 a boolean
  : let( v2_ib = is_boolean(v2) )
    is_boolean(v1) ?
    (
      (v2_nd || v2_in) ? -1
    : v2_ib ?
      (
        ((v1 == true)  && (v2 == false)) ? -1   // defined: true > false
      : ((v1 == false) && (v2 == true))  ? +1
      : 0
      )
    : 1 // others are greater
    )
  // v1 a string
  : let( v2_is = is_string(v2) )
    is_string(v1) ?
    (
      (v2_nd || v2_in || v2_ib) ? -1
    : v2_is ?
      (
        (v1 > v2) ? -1
      : (v2 > v1) ? +1
      : 0
      )
    : 1 // others are greater
    )
  // v1 a list
  : let( v2_il = is_list(v2) )
    is_list(v1) ?
    (
      (v2_nd || v2_in || v2_ib || v2_is) ? -1
    : v2_il ?
      (
        let
        (
          l1 = len(smerge(v1, true)),           // get total element count
          l2 = len(smerge(v2, true))
        )
        (l1 > l2) ? -1                          // longest list is greater
      : (l2 > l1) ? +1
      : ((l1 == 0) && (l2 == 0)) ? 0            // reached end, are equal
      : let
        (
          cf = compare(first(v1), first(v2), s) // compare first elements
        )
        (cf != 0) ? cf                          // not equal, ordering determined
      : compare(ntail(v1), ntail(v2), s)        // equal, check remaining
      )
    : 1 // others are greater
    )
  // v1 assume a range.
  : is_range(v2) ?
    (
      (v1 == v2) ? 0                            // equal range definitions
      // compare range sums
    : (s == true) ?
      (
        let
        (
          rs1 = sum(v1),                        // compute range sums
          rs2 = sum(v2)
        )
        (rs1 > rs2) ? -1                        // greatest sum is greater
      : (rs2 > rs1) ? +1
      : 0                                       // sums equal
      )
      // compare range lists
    : (
        let
        (
          rv1 = [for (i=v1) i],                 // convert to lists
          rv2 = [for (i=v2) i],
          rl1 = len(rv1),                       // get lengths
          rl2 = len(rv2)
        )
        (rl1 > rl2) ? -1                        // longest range is greater
      : (rl2 > rl1) ? +1
      : compare(rv1, rv2, s)                    // equal so compare as lists
      )
    )
  // v2 not a range so v1 > v2
  : -1;

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

    echo( str("openscad version ", version()) );

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
      ["n_almost_equal_AA", f, t, f, f, f, f, f, f, f, f, f, t, t, f, f, f, f, f, f, f, f, f, f],
      ["almost_equal_AA",   t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t],
      ["almost_equal_T",    f, f, t, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f],
      ["almost_equal_F",    f, f, f, t, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f],
      ["almost_equal_U",    t, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f],
      ["compare_AA",        t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t]
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
        else
          log_info( str(vid, " ", test_text) );
      }
      else
        log_info( str(vid, " *skip*: '", fname, "(", value_text, ")'") );
    }

    // Indirect function calls would be very useful here!!!
    for (vid=test_ids) run_test( "n_almost_equal_AA", n_almost_equal(get_value(vid),get_value(vid)), vid );
    for (vid=test_ids) run_test( "almost_equal_AA", almost_equal(get_value(vid),get_value(vid)), vid );
    for (vid=test_ids) run_test( "almost_equal_T", almost_equal(get_value(vid),t), vid );
    for (vid=test_ids) run_test( "almost_equal_F", almost_equal(get_value(vid),f), vid );
    for (vid=test_ids) run_test( "almost_equal_U", almost_equal(get_value(vid),u), vid );
    for (vid=test_ids) run_test( "compare_AA", compare(get_value(vid),get_value(vid)) == 0, vid );

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
