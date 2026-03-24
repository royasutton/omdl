//! List data type inspection.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2015-2023,2026

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

    \amu_define group_name  (List Inspection)
    \amu_define group_brief (List inspection operations.)

  \amu_include (include/amu/doxyg_init_pd_gds_ipg.amu)
*******************************************************************************/

// auto-tests (add to test results page)
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

  - Two-list parameters use \p v1 and \p v2.
  - The decimal-places parameter is always \p p.
  - almost_eq() applies a relative tolerance of \c eps (the library
    epsilon constant) by default; \p p overrides the number of significant
    decimal places used in the comparison.
  - compare() establishes a total order across OpenSCAD types:
    undef < number < boolean < string < list < range.
    Within each type, the natural ordering applies (numeric for numbers,
    lexicographic for strings, element-wise for lists).
  - list_get_value() performs a linear key search; for large maps prefer
    the map group functions which offer O(1) key lookup via search().
*******************************************************************************/

//----------------------------------------------------------------------------//
// members
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
// Iterable
//----------------------------------------------------------------------------//

//! \name Iterable
//! @{

//! Test to see if two numerical vectors are sufficiently equal.
/***************************************************************************//**
  \param    v1 <vector-n> The n-length vector 1.
  \param    v2 <vector-n> The n-length vector 2.
  \param    p <number> The numerical precision.

  \returns  (1) <boolean> \c true when the distance between \p v1 and
                \p v2 is less than \p d and \c false otherwise.
            (2) Returns \c false when either \p v1 or \p v2 are not
                numerical vectors of the same length.

  \details

    Can also compare two scalar numbers. To compare general lists of
    non-numerical values see almost_eq().
*******************************************************************************/
function almost_eq_nv
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
  \param    v1 <iterable> An iterable data type value 1.
  \param    v2 <iterable> An iterable data type value 2.
  \param    p <number> The precision for numerical comparisons.

  \returns  (1) <boolean> \c true when all elements of each iterable
                value are \em sufficiently equal and \c false
                otherwise.

  \details

    The iterable values can be of mixed data types. All numerical
    comparisons are performed using the specified precision. All
    non-numeric comparisons test for equality. When both \p v1 and \p
    v2 are both numerical vectors, the function almost_eq_nv()
    provides a more efficient test.
*******************************************************************************/
function almost_eq
(
  v1,
  v2,
  p = 6
) = all_numbers(concat(v1, v2)) ? almost_eq_nv(v1, v2, p)     // all numerical
  : all_scalars(concat([v1], [v2])) ? (v1 == v2)              // all single values
  : (is_string(v1) || is_string(v2)) ? (v1 == v2)             // either is a string
  : !all_iterables(concat([v1], [v2])) ? false                // false if either not iterable
  : !almost_eq(first(v1), first(v2), p) ? false               // compare first elements
  : almost_eq(tailn(v1), tailn(v2), p);                       // compare remaining elements

//! Compare the sort order of any two values.
/***************************************************************************//**
  \param    v1 \<value> The values 1.
  \param    v2 \<value> The values 2.
  \param    s <boolean> Order ranges by their enumerated sum.

  \returns  (1) <integer> An integer value.

  \details

    Return values (rv) table.

     rv      | order of values
    :-------:|:-------------------
      \c -1  | `(v2 < v1)`
      \c  0  | `(v2 == v1)`
      \c +1  | `(v2 > v1)`

    The following table summarizes how data type values are ordered.

     order | type       | \p s      | intra-type ordering
    :-----:|:----------:|:---------:|:--------------------------------------
      1    | undef      |           | (singular)
      2    | number     |           | numerical comparison
      3    | boolean    |           | false \< true
      4    | string     |           | lexical comparison
      5    | list       |           | compare (1) lengths, then (2) element-wise
      6    | range      | true      | compare sum of range elements
      6    | range      | false     | compare (1) lengths, then (2) element-wise

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
) = let( v2_nd = is_undef(v2) )
    is_undef(v1) ?
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
        (v1 > v2) ? -1                              // compare numbers
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
        ((v1 == true)  && (v2 == false)) ? -1       // defined: true > false
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
        (v1 > v2) ? -1                              // compare strings
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
          n1 = len(v1),                             // get element count
          n2 = len(v2)
        )
        (n1 > n2) ? -1                              // longest list is greater
      : (n2 > n1) ? +1
      : ((n1 == 0) && (n2 == 0)) ? 0                // reached end, are equal
      : let
        (
          cf = compare(first(v1), first(v2), s)     // compare first elements
        )
        (cf != 0) ? cf                              // not equal, ordering determined
      : compare(tailn(v1), tailn(v2), s)            // equal, check remaining
      )
    : 1 // others are greater
    )
  // v1 a range.
  : is_range(v2) ?
    (
      (v1 == v2) ? 0                                // equal range definitions
      // compare range sums
    : (s == true) ?
      (
        let
        (
          rs1 = sum(v1),                            // compute range sums
          rs2 = sum(v2)
        )
        (rs1 > rs2) ? -1                            // greatest sum is greater
      : (rs2 > rs1) ? +1
      : 0                                           // sums equal
      )
      // compare range lists
    : (
        let
        (
          rv1 = [for (i=v1) i],                     // convert to lists
          rv2 = [for (i=v2) i],
          rl1 = len(rv1),                           // get lengths
          rl2 = len(rv2)
        )
        (rl1 > rl2) ? -1                            // longest range is greater
      : (rl2 > rl1) ? +1
      : compare(rv1, rv2, s)                        // equal so compare as lists
      )
    )
  // v2 not a range so v1 > v2
  : -1;

//! @}

//----------------------------------------------------------------------------//
// List
//----------------------------------------------------------------------------//

//! \name List
//! @{

//! Return the value of an indexed list element with output defaults and list composition.
/***************************************************************************//**
  \param    l <list> The input list.
  \param    i <integer> The input list element index.

  \param    dv \<value> The default return value.

  \param    s <integer> The output list size.

  \param    de \<value> The default element value for output list
            composition.

  \param    di <integer> The default output element index used when
            composing an output list from an input element that is not
            a list. Use `di = -1` to assign the value to all elements.

  \returns  For the input list element indexed as `e = l[i]`:
            - <b>For \p e a list</b>:
            -# When `s == 0`, returns (1) \p e[0], or (2a) \p dv if
              \p e[0] is undefined.
            -# When either \p de or \p s is undefined, returns (3a) \p e.
            -# When both \p de and \p s are defined with `s > 0`,
              returns (4) a list of size \p s in which any undefined
              elements of \p e are assigned \p de.
            - <b>For \p e not a list</b>:
            -# When `s == 0`, returns (2b) \p dv if \p e is undefined,
              and (3b) \p e otherwise.
            -# When either \p di or \p s is undefined, returns (2c) \p dv.
            -# When both \p di and \p s are defined with `s > 0`,
              returns (5) a list of size \p s with all elements
              assigned \p de if \p e is undefined, or (6) a list of
              size \p s with element \p [di] assigned \p e and all
              other elements assigned \p de.

  \details

    #### Return conditions summary

     no   | value     | description
    :----:|:---------:|:---------------------------------------------------
      1   | \p e[0]   | element 0 of the indexed element (remove from list)
      2   | \p dv     | default value
      3   | \p e      | the indexed element
      4   | composed  | assign \p de to all undefined elements of \p e
      5   | composed  | assign \p de to all elements of \p e
      6   | composed  | assign \p e to element(s) \p di and \p de to all other element \p e
*******************************************************************************/
function list_get_value
(
  l,
  i,
  dv,

  s,
  de,
  di = 0
) = !is_list(l) ? undef
  : let( e = l[i] )
    is_list( e ) ?
      // indexed element is a list: (2a), (1), (3a)
      (
        (s == 0) ?
          is_undef( e[0] ) ? dv
        : e[0]

      : let
        (
          use_iev = !is_integer( s ) || (s<1) || is_undef( de )
        )
        use_iev ? e

        // update output list: (4)
      : [ for (j = [0:s-1]) if ( !is_undef( e[j] ) ) e[j] else de ]
      )
      // indexed element is not a list: (2b), (3b), (2c)
    : (
        (s == 0) ?
          is_undef( e ) ? dv
        : e

      : let
        (
          use_d = !is_integer( s ) || (s<1) || !is_integer( di )
        )
        use_d ? dv

        // create output list: (5), (6)
      : is_undef( e ) ?
          [for (j = [0:s-1]) de]
        : [for (j = [0:s-1]) if (di == -1 || j == di) e else de]
      );

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

    function fmt( id, td, v1, v2, v3 ) = table_validate_fmt(id, td, v1, v2, v3);
    function v1(db, id) = table_validate_get_v1(db, id);
    function v2(db, id) = table_validate_get_v2(db, id);
    t = true; f = false; u = undef; s = validation_skip;

    tbl_test_values =
    [
      fmt("t01", "The undefined value",
          undef,
          undef
      ),
      fmt("t02", "Integers",
          2121,
          2100
      ),
      fmt("t03", "Equal srings",
          "This is a test",
          "This is a test"
      ),
      fmt("t04", "Non-equal srings",
          "This is test v1",
          "This is test v2"
      ),
      fmt("t05", "Non-equal srings 2",
          "v1 this is test v1",
          "v2 this is test v2"
      ),
      fmt("t06", "Empty strings",
          empty_str,
          empty_str
      ),
      fmt("t07", "Empty lists",
          empty_lst,
          empty_lst
      ),
      fmt("t08", "Non-equal short ranges",
          [0:9],
          [-1:9]
      ),
      fmt("t09", "Equal ranges",
          [0:9],
          [0:9]
      ),
      fmt("t10", "Long and short ranges",
          [0:0.5:9],
          [0:9]
      ),
      fmt("t11", "Lists with num-3 + undef",
          [1, 2, 3, undef],
          [undef, 1, 2, 3]
      ),
      fmt("t12", "3D vector and scalar",
          [21, 32, 35],
          19
      ),
      fmt("t13", "Unequal 3D vectors",
          [1, 2, 3],
          [3, 2, 1]
      ),
      fmt("t14", "equal 5D vectors",
          [10, 12, 33, 98, 100],
          [10, 12, 33, 98, 100]
      ),
      fmt("t15", "close 5D vectors",
          [09.999, 11.999, 32.999, 97.999,  99.999],
          [10.001, 12.001, 33.001, 98.001, 100.001]
      ),
      fmt("t16", "Equal tuples list-3",
          [[1,2,3], [4,5,6], [7,8,9]],
          [[1,2,3], [4,5,6], [7,8,9]]
      ),
      fmt("t17", "Equal mixed-tuples list",
          [[1,2,3], [4,5,6], [7,8,9], ["a", "b", "c"]],
          [[1,2,3], [4,5,6], [7,8,9], ["a", "b", "c"]]
      ),
      fmt("t18", "List-4, all undef",
          [undef, undef, undef, undef],
          [undef, undef, undef, undef]
      ),
      fmt("t19", "List of equal num lists-1",
          [[1], [2], [3], [4], [5]],
          [[1], [2], [3], [4], [5]]
      ),
      fmt("t20", "List-4 of close number pairs",
          [[1,2], [3,4], [5,6], [7,8]],
          [[1.001,2.001], [3.001,4.001], [5.001,6.001], [7.001,8.001]]
      )
    ];

    tbl_test_answers =
    [ // function            01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20
      ["almost_eq_nv_p4",     f, f, f, f, f, f, f, f, f, f, f, f, f, t, f, f, f, f, f, f],
      ["almost_eq_nv_p2",     f, f, f, f, f, f, f, f, f, f, f, f, f, t, t, f, f, f, f, f],
      ["almost_eq_p2",        t, f, t, f, f, t, t, f, t, f, f, f, f, t, t, t, t, t, t, t],
      ["compare",             0,-1, 0,+1,+1, 0, 0,-1, 0,-1,-1,-1,+1, 0,+1, 0, 0, 0, 0,+1],
    ];

    db = table_validate_init( tbl_test_values, tbl_test_answers );

    table_validate_start( db );
    test_ids = table_validate_get_ids( db );

    for (id=test_ids) table_validate( db, id, "almost_eq_nv_p4", 2, almost_eq_nv( v1(db,id), v2(db,id), 4) );
    for (id=test_ids) table_validate( db, id, "almost_eq_nv_p2", 2, almost_eq_nv( v1(db,id), v2(db,id), 2) );
    for (id=test_ids) table_validate( db, id, "almost_eq_p2", 2, almost_eq( v1(db,id), v2(db,id), 2) );
    for (id=test_ids) table_validate( db, id, "compare", 2, compare( v1(db,id), v2(db,id) ) );
    // list_get_value()

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
