//! List data type tests.
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

    \amu_define group_name  (List Identification)
    \amu_define group_brief (List data type tests.)
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

//! Test to see if two numerical vectors are sufficiently equal.
/***************************************************************************//**
  \param    v1 <vector-Nd> A vector 1 in an 'N' dimensional space.
  \param    v2 <vector-Nd> A vector 2 in an 'N' dimensional space.
  \param    p <number> The numerical precision.

  \returns  <boolean> \b true when the distance between \p v1 and \p v2
            is less than \p d and \b false otherwise. Returns \b false
            when either \p v1 or \p v2 are not numerical vectors of the
            same length.

  \details

    Can compare two scalar numbers as well. To compare general lists of
    non-numerical values see almost_equal().
*******************************************************************************/
function n_almost_equal
(
  v1,
  v2,
  p = 6
) = !all_numbers(concat(v1, v2)) ? false                    // must be all numbers
  : all_scalars(concat([v1], [v2])) ?                       // compare if scalars?
    ( (sqrt((v1-v2)*(v1-v2)) * pow(10, p)) < 1 )            // -> compare as scalars
  : !all_lists(concat([v1], [v2])) ? false                  // requires all lists or false
  : (len(v1) != len(v2)) ? false                            // size must be equal
  : ( (sqrt((v1-v2)*(v1-v2)) * pow(10, p)) < 1 );           // -> compare as vectors

//! Test if all elements of two iterable values are sufficiently equal.
/***************************************************************************//**
  \param    v1 \<iterable> An iterable data type value 1.
  \param    v2 \<iterable> An iterable data type value 2.
  \param    p <number> The precision for numerical comparisons.

  \returns  <boolean> \b true when all elements of each iterable value
            are \em sufficiently equal and \b false otherwise.

  \details

    The iterable values can be of mixed data types. All numerical
    comparisons are performed using the specified precision. All
    non-numeric comparisons test for equality. When both \p v1 and \p
    v2 are both numerical vectors, the function n_almost_equal()
    provides a more efficient test.
*******************************************************************************/
function almost_equal
(
  v1,
  v2,
  p = 6
) = all_numbers(concat(v1, v2)) ? n_almost_equal(v1, v2, p) // all numerical
  : all_scalars(concat([v1], [v2])) ? (v1 == v2)            // all single values
  : (is_string(v1) || is_string(v2)) ? (v1 == v2)           // either is a string
  : !all_iterables(concat([v1], [v2])) ? false              // false if either not iterable
  : !almost_equal(first(v1), first(v2), p) ? false          // compare first elements
  : almost_equal(ntail(v1), ntail(v2), p);                  // compare remaining elements

//! Compare the sort order any two arbitrary data type values.
/***************************************************************************//**
  \param    v1 \<value> Any valid values 1.
  \param    v2 \<value> Any valid values 2.
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
      5    | list     |           | compare (1) lengths, then (2) element-wise
      6    | range    | \b true   | compare sum of range elements
      6    | range    | \b false  | compare (1) lengths, then (2) element-wise

    When comparing two lists of equal length, the comparison continues
    with successive elements until an ordering can be determined. Two
    lists are equal when all elements have been compared and no
    ordering has been determined.

  \warning  The performance of element-wise comparisons degrades
            exponentially with list size and the sum of a range may
            exceeded the intermediate variable storage capacity for
            long ranges.
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
  : let( v2_ib = is_bool(v2) )
    is_bool(v1) ?
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
  // v1 a range.
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
    include <omdl-base.scad>;
    include <common/validation.scad>;

    t = true; f = false; u = undef; s = number_max;

    function get_v1( id ) = table_get_value(test_r, test_c, id, "v1");
    function get_v2( id ) = table_get_value(test_r, test_c, id, "v2");
    module log_test( m ) { log_type ( "omdl_test", m ); }
    module log_skip( fn ) { log_test ( str("ignore: '", fn, "'") ); }
    module test_2v( fn, fr, id )
    {
      td = table_get_value(test_r, test_c, id, "td");
      ev = table_get_value(good_r, good_c, fn, id);

      if ( ev != s )
      {
        d = str(fn, "(", get_v1(id), ",", get_v2(id), ")=", ev);
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
    test_c = [ ["id", "identifier"], ["td", "description"], ["v1", "value 1"], ["v2", "value 2"] ];

    // test-values rows
    test_r =
    [
      ["t01", "The undefined value",          undef,
                                              undef
      ],
      ["t02", "Integers",                     2121,
                                              2100
      ],
      ["t03", "Equal srings",                 "This is a test",
                                              "This is a test"
      ],
      ["t04", "Non-equal srings",             "This is test v1",
                                              "This is test v2"
      ],
      ["t05", "Non-equal srings 2",           "v1 this is test v1",
                                              "v2 this is test v2"
      ],
      ["t06", "Empty strings",                empty_str,
                                              empty_str
      ],
      ["t07", "Empty lists",                  empty_lst,
                                              empty_lst
      ],
      ["t08", "Non-equal short ranges",       [0:9],
                                              [-1:9]
      ],
      ["t09", "Equal ranges",                 [0:9],
                                              [0:9]
      ],
      ["t10", "Long and short ranges",        [0:0.5:9],
                                              [0:9]
      ],
      ["t11", "Lists with num-3 + undef",     [1, 2, 3, undef],
                                              [undef, 1, 2, 3]
      ],
      ["t12", "4D vector and scalar",         [21, 32, 35],
                                              19
      ],
      ["t13", "Unequal 3D vectors",           [1, 2, 3],
                                              [3, 2, 1]
      ],
      ["t14", "equal 5D vectors",             [10, 12, 33, 98, 100],
                                              [10, 12, 33, 98, 100]
      ],
      ["t15", "close 5D vectors",             [09.999, 11.999, 32.999, 97.999,  99.999],
                                              [10.001, 12.001, 33.001, 98.001, 100.001]
      ],
      ["t16", "Equal tuples list-3",          [[1,2,3], [4,5,6], [7,8,9]],
                                              [[1,2,3], [4,5,6], [7,8,9]]
      ],
      ["t17", "Equal mixed-tuples list",      [[1,2,3], [4,5,6], [7,8,9], ["a", "b", "c"]],
                                              [[1,2,3], [4,5,6], [7,8,9], ["a", "b", "c"]]
      ],
      ["t18", "List-4 all = undef",           [undef, undef, undef, undef],
                                              [undef, undef, undef, undef]
      ],
      ["t19", "List of equal num lists-1",    [[1], [2], [3], [4], [5]],
                                              [[1], [2], [3], [4], [5]]
      ],
      ["t20", "List-4 of close number pairs", [[1,2], [3,4], [5,6], [7,8]],
                                              [[1.001,2.001], [3.001,4.001], [5.001,6.001], [7.001,8.001]]
      ]
    ];
    table_check( test_r, test_c, false );   // sanity-test

    test_ids = table_get_row_ids( test_r );

    // expected columns: ("id" + one column for each test)
    good_c = pmerge([concat("id", test_ids), concat("identifier", test_ids)]);

    good_r =
    [ // function            01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20
      ["n_almost_equal_p4",   f, f, f, f, f, f, f, f, f, f, f, f, f, t, f, f, f, f, f, f],
      ["n_almost_equal_p2",   f, f, f, f, f, f, f, f, f, f, f, f, f, t, t, f, f, f, f, f],
      ["almost_equal_p2",     t, f, t, f, f, t, t, f, t, f, f, f, f, t, t, t, t, t, t, t],
      ["compare",             0,-1, 0,+1,+1, 0, 0,-1, 0,+1,-1,-1,+1, 0,+1, 0, 0, 0, 0,+1],
    ];
    table_check( good_r, good_c, false );   // sanity-test

    // Indirect function calls would be very useful here!!!
    for (vid=test_ids) test_2v( "n_almost_equal_p4", n_almost_equal(get_v1(vid),get_v2(vid),4), vid );
    for (vid=test_ids) test_2v( "n_almost_equal_p2", n_almost_equal(get_v1(vid),get_v2(vid),2), vid );
    for (vid=test_ids) test_2v( "almost_equal_p2", almost_equal(get_v1(vid),get_v2(vid),2), vid );
    for (vid=test_ids) test_2v( "compare", compare(get_v1(vid),get_v2(vid)), vid );

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
