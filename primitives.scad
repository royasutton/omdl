//! Mathematical primitive functions.
/***************************************************************************//**
  \file   primitives.scad
  \author Roy Allen Sutton
  \date   2015-2016

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

  \note Include this library file using the \b include statement.

  \ingroup math prim_test prim_vector
*******************************************************************************/

include <constants.scad>;

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \page tv_prim Primitives Validation
    \li \subpage tv_prim_test
    \li \subpage tv_prim_vector
*******************************************************************************/
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \page tv_prim_test Variable Tests Validation
    \li \subpage tv_prim_test_g1_s
    \li \subpage tv_prim_test_g1_r
    \li \subpage tv_prim_test_g2_s
    \li \subpage tv_prim_test_g2_r

  \page tv_prim_test_g1_s Validation Script (group1)
    \dontinclude primitives_validate_test_g1.scad
    \skip include
    \until end-of-tests
  \page tv_prim_test_g1_r Validation Results (group1)
    \include primitives_validate_test_g1.log

  \page tv_prim_test_g2_s Validation Script (group2)
    \dontinclude primitives_validate_test_g2.scad
    \skip include
    \until end-of-tests
  \page tv_prim_test_g2_r Validation Results (group2)
    \include primitives_validate_test_g2.log
*******************************************************************************/
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \addtogroup math
  @{

  \defgroup prim_test Variable Tests
  \brief    Variable property test primitives.

  \details

    See validation results
    \ref tv_prim_test_g1_r "group1" and \ref tv_prim_test_g2_r "group2".
  @{
*******************************************************************************/
//----------------------------------------------------------------------------//

//! Test if a value is defined.
/***************************************************************************//**
  \param    v <value> A value.
  \returns  <boolean> \b false when the value equals \b undef and \b true
            otherwise.
*******************************************************************************/
function is_defined( v ) = (v == undef) ? false : true;

//! Test if a value is not defined.
/***************************************************************************//**
  \param    v <value> A value.
  \returns  <boolean> \b true when the value equals \b undef and \b false
            otherwise.
*******************************************************************************/
function not_defined( v ) = (v == undef) ? true : false;

//! Test if a vector is empty.
/***************************************************************************//**
  \param    v <vector> A vector.
  \returns  <boolean> \b true when the vector (or string) is empty
            and \b false otherwise.
*******************************************************************************/
function is_empty( v ) = (len(v) == 0);

//! Test if a value is scalar.
/***************************************************************************//**
  \param    v <value> A value.
  \returns  <boolean> \b true when the value is scalar
            and \b false otherwise.

  \details

     value is      | defined result
    :-------------:|:-----------------:
     \b undef      | not defined
     integer       | \b true
     decimal       | \b true
     boolean       | \b true
     string        | \b false
     vector        | \b false
     range         | not defined

    A scalar value consists of a single value.
*******************************************************************************/
function is_scalar( v ) = (len(v) == undef);

//! Test if a value is a vector.
/***************************************************************************//**
  \param    v <value> A value.
  \returns  <boolean> \b true when the value is a vector
            and \b false otherwise.

  \details

     value is      | defined result
    :-------------:|:-----------------:
     \b undef      | not defined
     integer       | \b false
     decimal       | \b false
     boolean       | \b false
     string        | \b true
     vector        | \b true
     range         | \b false

    A vector value consists of one or more comma-separated values within
    braces.
*******************************************************************************/
function is_vector( v ) = (len(v) != undef);

//! Test if a value is a string.
/***************************************************************************//**
  \param    v <value> A value.
  \returns  <boolean> \b true when the value is a string
            and \b false otherwise.
*******************************************************************************/
function is_string( v ) = (str(v) == v);

//! Test if a value is one of the predefined boolean constants.
/***************************************************************************//**
  \param    v <value> A value.
  \returns  <boolean> \b true when the value is one of the predefined
            boolean constants <tt>[true|false]</tt> and \b false otherwise.
*******************************************************************************/
function is_bool
(
  v
) = is_string(v) ? false
  : (str(v) == "true") ? true
  : (str(v) == "false") ? true
  : false;

//! Test if a value is an integer.
/***************************************************************************//**
  \param    v <value> A value.
  \returns  <boolean> \b true when the value is an integer
            and \b false otherwise.
*******************************************************************************/
function is_integer
(
  v
) = not_defined(v) ? false
  : ((v % 1) == 0);

//! Test if a value is a decimal.
/***************************************************************************//**
  \param    v <value> A value.
  \returns  <boolean> \b true when the value is a decimal
            and \b false otherwise.
*******************************************************************************/
function is_decimal( v ) = ((v % 1) > 0);

//! Test if a value is a range definition.
/***************************************************************************//**
  \param    v <value> A value.
  \returns  <boolean> \b true when the value is a range definition
            and \b false otherwise.

  \details

  \internal
    Currently a range is determined to be that which does not fit in any
    other value category. This is likely to fail as OpenSCAD matures.
    This exclusion test should be replaced by a suitable inclusion test
    when possible.
  \endinternal
*******************************************************************************/
function is_range
(
  v
) = is_defined(v) &&
    !is_vector(v) &&
    !is_string(v) &&
    !is_bool(v) &&
    !is_integer(v) &&
    !is_decimal(v) &&
    !is_nan(v) &&
    !is_inf(v);

//! Test if a numerical value is invalid (Not A Number).
/***************************************************************************//**
  \param    v <value> A decimal or integer value.
  \returns  <boolean> \b true when the number is determined to be \b nan
            and \b false otherwise.
*******************************************************************************/
function is_nan( v ) = ( v != v );

//! Test if a numerical value is greater than the largest representable number.
/***************************************************************************//**
  \param    v <value> A decimal or integer value.
  \returns  <boolean> \b true when the number is determined to equal \b inf
            and \b false otherwise.
*******************************************************************************/
function is_inf( v ) = ( v == (number_max * number_max) );

//! Test if a numerical value is even.
/***************************************************************************//**
  \param    v <value> A numerical value.
  \returns  <boolean> \b true when the number is determined to be even
            and \b false otherwise.

  \details

  \note     The value must be valid (\c v != \b nan) and defined
            (\c v != \b undef) but may be positive or negative. Any
            numeric value that is not an integer returns \b false.
*******************************************************************************/
function is_even( v ) = !is_integer(v) ? false : ((v % 2) == 0);

//! Test if a numerical value is odd.
/***************************************************************************//**
  \param    v <value> A numerical value.
  \returns  <boolean> \b true when the number is determined to be odd
            and \b false otherwise.

  \details

  \note     The value must be valid (\c v != \b nan) and defined
            (\c v != \b undef) but may be positive or negative. Any
            numeric value that is not an integer returns \b false.
*******************************************************************************/
function is_odd( v ) = !is_integer(v) ? false : ((v % 2) != 0);

//! Test that all vector elements equal a comparison value.
/***************************************************************************//**
  \param    v <vector> A vector.
  \param    cv <value> A comparison value.
  \returns  <boolean> \b true when all vector elements equal the value \p cv
            and \b false otherwise.

  \warning  Always returns \b true when \p v is a single value containing
            either \b empty_v or \b empty_str.
*******************************************************************************/
function all_equal
(
  v,
  cv
) = !is_vector(v) ? (v == cv)
  : is_empty(v) ? true
  : (first(v) != cv) ? false
  : all_equal(tail(v), cv);

//! Test if any vector element equals a comparison value.
/***************************************************************************//**
  \param    v <vector> A vector.
  \param    cv <value> A comparison value.
  \returns  <boolean> \b true when any vector element equals the value \p cv
            and \b false otherwise.

  \warning  Always returns \b false when \p v is a single value containing
            either \b empty_v or \b empty_str.
*******************************************************************************/
function any_equal
(
  v,
  cv
) = !is_vector(v) ? (v == cv)
  : is_empty(v) ? false
  : (first(v) == cv) ? true
  : any_equal(tail(v), cv);

//! Test that no vector element is undefined.
/***************************************************************************//**
  \param    v <vector> A vector.
  \returns  <boolean> \b true when no vector element equals \b undef
            and \b false otherwise.

  \warning  Always returns \b true when \p v is a single value containing
            either \b empty_v or \b empty_str.
*******************************************************************************/
function all_defined(v) = !any_equal(v, undef);

//! Test if any vector element is undefined.
/***************************************************************************//**
  \param    v <vector> A vector.
  \returns  <boolean> \b true when any vector element equals \b undef
            and \b false otherwise.

  \warning  Always returns \b false when \p v is a single value containing
            either \b empty_v or \b empty_str.
*******************************************************************************/
function any_undefined(v) = any_equal(v, undef);

//! Test if all vector elements are scalars.
/***************************************************************************//**
  \param    v <vector> A vector.
  \returns  <boolean> \b true when all vector elements are scalar values
            and \b false otherwise.
            Returns the value of \p v when it is not defined.

  \warning  Always returns \b true when \p v is a single value containing
            either \b empty_v or \b empty_str.
*******************************************************************************/
function all_scalars
(
  v
) = not_defined(v) ? v
  : is_scalar(v) ? true
  : is_empty(v) ? true
  : !is_scalar(first(v)) ? false
  : all_scalars(tail(v));

//! Test if all vector elements are vectors.
/***************************************************************************//**
  \param    v <vector> A vector.
  \returns  <boolean> \b true when all vector elements are vector values
            and \b false otherwise.
            Returns the value of \p v when it is not defined.

  \note     This function distinguishes between vectors and strings. If any
            vectors element is a strings, \b false will be returned.

  \warning  Always returns \b true when \p v is a single value containing
            either \b empty_v or \b empty_str.
*******************************************************************************/
function all_vectors
(
  v
) = not_defined(v) ? v
  : is_scalar(v) ? false
  : is_empty(v) ? true
  : is_string(first(v)) ? false
  : !is_vector(first(v)) ? false
  : all_vectors(tail(v));

//! Test if all vector elements are strings.
/***************************************************************************//**
  \param    v <vector> A vector.
  \returns  <boolean> \b true when all vector elements are string values
            and \b false otherwise.
            Returns the value of \p v when it is not defined.

  \warning  Always returns \b true when \p v is a single value containing
            either \b empty_v or \b empty_str.
*******************************************************************************/
function all_strings
(
  v
) = not_defined(v) ? v
  : is_scalar(v) ? false
  : is_empty(v) ? true
  : !is_string(first(v)) ? false
  : all_strings(tail(v));

//! Test if all vector elements are vectors (or strings) of a given length.
/***************************************************************************//**
  \param    v <vector> A vector.
  \param    l <integer> The length.
  \returns  <boolean> \b true when all vector elements are vectors
            (or strings) with length equal to \p l and \b false otherwise.
            Returns the value of \p v when it is not defined.

  \warning  Always returns \b true when \p v is a single value containing
            either \b empty_v or \b empty_str.
*******************************************************************************/
function all_len
(
  v,
  l
) = not_defined(v) ? v
  : is_scalar(v) ? false
  : is_empty(v) ? true
  : (len(first(v)) != l) ? false
  : all_len(tail(v),l);

//! @}
//! @}

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \page tv_prim_vector Vector Operations Validation
    \li \subpage tv_prim_vector_s
    \li \subpage tv_prim_vector_r
  \page tv_prim_vector_s Validation Script
    \dontinclude primitives_validate_vector.scad
    \skip include
    \until end-of-tests
  \page tv_prim_vector_r Validation Results
    \include primitives_validate_vector.log
*******************************************************************************/
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \addtogroup math
  @{

  \defgroup prim_vector Vector Operations
  \brief    Vector operation primitives.

  \details

    See validation \ref tv_prim_vector_r "results".
  @{
*******************************************************************************/
//----------------------------------------------------------------------------//

//! Return the first element of a vector.
/***************************************************************************//**
  \param    v <vector> A vector.
  \returns  The first element of the vector.
            Returns the value of \p v when it is not defined or not a vector.
            Returns \b undef when it is an empty vector (or string).
*******************************************************************************/
function first
(
  v
) = !is_vector(v) ? v
  : v[0];

//! Return the last element of a vector.
/***************************************************************************//**
  \param    v <vector> A vector.
  \returns  The last element of the vector.
            Returns the value of \p v when it is not defined or not a vector.
            Returns \b undef when it is an empty vector (or string).
*******************************************************************************/
function last
(
  v
) = not_defined(v) ? v
  : !is_vector(v) ? v
  : is_empty(v) ? undef
  : v[len(v)-1];

//! Return a new vector containing the first element of a vector.
/***************************************************************************//**
  \param    v <vector> A vector.
  \returns  A new vector containing the first element of the vector.
            Returns the value of \p v when it is not defined or not a vector.
            Returns \b undef when it is an empty vector (or string).
*******************************************************************************/
function head
(
  v
) = not_defined(v) ? v
  : !is_vector(v) ? v
  : is_empty(v) ? undef
  : [first(v)];

//! Return a new vector containing all but the first element of a vector.
/***************************************************************************//**
  \param    v <vector> A vector.
  \returns  A new vector containing all but the first element of the vector.
            Returns the value of \p v when it is not defined or not a vector.
            Returns \b undef when it is an empty vector (or string).
*******************************************************************************/
function tail
(
  v
) = not_defined(v) ? v
  : !is_vector(v) ? v
  : is_empty(v) ? undef
  : (len(v) == 1) ? empty_v
  : [for (i = [1 : len(v)-1]) v[i]];

//! Return a copy of a vector with its elements in reverse order.
/***************************************************************************//**
  \param    v <vector> A vector.
  \returns  A copy of the vector with its elements in reversed order.
            Returns the value of \p v when it is not defined, not a vector,
            or it is an empty vector (or string).
*******************************************************************************/
function reverse
(
  v
) = not_defined(v) ? v
  : !is_vector(v) ? v
  : is_empty(v) ? v
  : concat( reverse(tail(v)), head(v) );

//! Return a new vector containing a select element of a vector of vectors.
/***************************************************************************//**
  \param    v <vector> A vector.
  \param    f <boolean> Select each vectors first element.
  \param    l <boolean> Select each vectors last element.
  \param    e <integer> A vector element index selection.
  \returns  A new vector composed by choosing the selected element from
            each member-vector of the given vector \p v.
            Returns the value of \p v when it is not defined, not a vector,
            or it is an empty vector (or string).

  \details

  \note     When more than one selection criteria is specified, the
            order of priority is: \p e, \p l, \p f.
*******************************************************************************/
function eselect
(
  v,
  f = true,
  l = false,
  e
) = not_defined(v) ? v
  : !is_vector(v) ? v
  : is_empty(v) ? v
  : is_defined(e) ? concat( [first(v)[e]], eselect(tail(v), f, l, e) )
  : (l == true) ? concat( [last(first(v))], eselect(tail(v), f, l, e) )
  : (f == true) ? concat( [first(first(v))], eselect(tail(v), f, l, e) )
  : undef;

//! Element-wise concatenation of two or more vectors.
/***************************************************************************//**
  \param    v <vector> A vector of two or more vectors.
  \returns  A new vector constructed from the element-wise concatenation
            of the vectors in \p v. The length will be limited by the
            vector with the least number of elements.
            Returns the value of \p v when it is not defined, it is not
            a vector, it is an empty vector (or string), or when any
            element of \p v is not a vector.
            Returns \b empty_v for any vector with two or more elements
            where there exists one or more elements that are an empty
            vector (or string).

  \details

    \b Example
    \code{.C}
    v1=["a", "b", "c", "d"];
    v2=[1, 2, 3];

    echo( econcat( [v1, v2] ) );
    \endcode

    \b Result
    \code{.C}
    ECHO: [["a", 1], ["b", 2], ["c", 3]]
    \endcode
*******************************************************************************/
function econcat
(
  v
) = not_defined(v) ? v
  : !is_vector(v) ? v
  : is_empty(v) ? v
  : any_undefined([for (i = v) len(i)]) ? v       // any element not a vector?
  : (min([for (i = v) len(i)]) == 0) ? empty_v    // any element empty?
  : let
    (
      t = [for (i = [0 : len(v)-1]) tail(v[i])],
      h = [for (i = [0 : len(v)-1]) first(v[i])]
    )
    concat([h], econcat(t));

//! Convert and concatenate vector elements into a single string.
/***************************************************************************//**
  \param    v <vector> A vector of values.
  \returns  A new string constructed by converting the elements of the
            vector to strings and concatenating.
            Returns the value of \p v when it is not defined, not a vector,
            or it is an empty vector (or string).

  \details

    \b Example
    \code{.C}
    v1=["a", "b", "c", "d"];
    v2=[1, 2, 3];

    echo( estr(concat(v1, v2)) );
    \endcode

    \b Result
    \code{.C}
    ECHO: "abcd123"
    \endcode
*******************************************************************************/
function estr
(
  v
) = not_defined(v) ? v
  : !is_vector(v) ? v
  : is_empty(v) ? v
  : (len(v) == 1) ? str(first(v))
  : str(first(v), estr(tail(v)));

//! Sort the elements of a vector using the quick sort method.
/***************************************************************************//**
  \param    v <vector> A vector.
  \returns  A new vector with element sorted in ascending order.
            Returns the value of \p v when it is not defined, not a vector,
            or it is an empty vector (or string).

  \details

  \warning This implementation relies on the comparison operators
           '<' and '>' which expect the operands to be either two scalar
           numbers or two strings. Therefore this function only produce
           valid results for a vector containing all scalar numbers or all
           strings.

    See [Wikipedia](https://en.wikipedia.org/wiki/Quicksort)
    for more information.
*******************************************************************************/
function qsort
(
  v
) = not_defined(v) ? v
  : !is_vector(v) ? v
  : is_empty(v) ? v
  : let
    (
      mp = v[floor(len(v)/2)],

      lt = [for (i = [0 : len(v)-1]) if (v[i]  < mp) v[i]],
      eq = [for (i = [0 : len(v)-1]) if (v[i] == mp) v[i]],
      gt = [for (i = [0 : len(v)-1]) if (v[i]  > mp) v[i]]

    )
    concat(qsort(lt), eq, qsort(gt));

//! Compute the sum of a range of vector elements.
/***************************************************************************//**
  \param    v <vector> A vector of numerical values.
  \param    e <integer> The vector element index at which to end summation.
  \param    b <integer> The vector element index at which to begin summation.
  \returns  <decimal> The summation of the vector elements.
            Returns the value of \p v when it is not defined.
            Returns \b undef when it is not a vector.
            Returns \b 0 when it is an empty vector (or string).
*******************************************************************************/
function ersum
(
  v,
  e,
  b=0
) = not_defined(v) ? v
  : !is_vector(v) ? undef
  : is_empty(v) ? 0
  : (e == b) ? v[e]
  : v[e] + ersum(v, e-1, b);

//! Compute the sum of all of the vector elements.
/***************************************************************************//**
  \param    v <vector> A vector of numerical values.
  \returns  <decimal> The summation of all of the vector elements.
            Returns the value of \p v when it is not defined.
            Returns \b undef when it is not a vector.
            Returns \b 0 when it is an empty vector (or string).
*******************************************************************************/
function esum
(
  v
) = ersum( v, len( v ) - 1, 0);

//! Value defined or default operation.
/***************************************************************************//**
  \param    v <value> A value.
  \param    d <value> A default value.
  \returns  The value \p v when it is defined or the value \p d otherwise.
*******************************************************************************/
function defined_or
(
  v,
  d
) = is_defined(v) ? v
  : d;

//! Vector element defined or default operation.
/***************************************************************************//**
  \param    v <vector> A vector.
  \param    e <integer> A vector element index.
  \param    d <value> A default value.
  \returns  The value of vector element \p e, namely <tt>v[e]</tt>, when it
            exists or the value \p d otherwise.
*******************************************************************************/
function edefined_or
(
  v,
  e,
  d
) = (len(v) > e) ? v[e]
  : d;

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE validate;
  BEGIN_SCOPE test;
    BEGIN_SCOPE g1;
      BEGIN_OPENSCAD;
        include <primitives.scad>;
        use <table.scad>;
        use <console.scad>;
        use <validation.scad>;

        show_passed  = true;    // show test that pass
        show_skipped = true;    // show skipped tests

        echo( str("OpenSCAD Version ", version()) );

        // test-values columns
        test_c =
        [
          ["id", "identifier"],
          ["td", "description"],
          ["tv", "vale"]
        ];

        // test-values rows
        test_r =
        [
          ["t01", "The undefined value",        undef],
          ["t02", "An odd integer",             1],
          ["t03", "An small even integer",      10],
          ["t04", "A large integer",            100000000],
          ["t05", "A small decimal (epsilon)",  eps],
          ["t06", "The max number",             number_max],
          ["t07", "The min number",             number_min],
          ["t08", "The max number^2",           number_max * number_max],
          ["t09", "The invalid number nan",     0 / 0],
          ["t10", "The boolean true",           true],
          ["t11", "The boolean false",          false],
          ["t12", "A character",                "a"],
          ["t13", "A string",                   "This is a longer string"],
          ["t14", "The empty string",           empty_str],
          ["t15", "The empty vector",           empty_v],
          ["t16", "A 1-tuple vector of undef",  [undef]],
          ["t17", "A 1-tuple vector",           [10]],
          ["t18", "A 3-tuple vector",           [1, 2, 3]],
          ["t19", "A vector of vectors",        [[1,2,3], [4,5,6], [7,8,9]]],
          ["t20", "A shorthand range",          [0:9]],
          ["t21", "A range",                    [0:0.5:9]]
        ];

        test_ids = table_get_row_ids( test_r );

        // expected columns: ("id" + one column for each test)
        good_c = econcat([concat("id", test_ids), concat("identifier", test_ids)]);

        // expected rows: ("golden" test results), use 's' to skip test
        t = true;   // shortcuts
        f = false;
        u = undef;
        s = -1;     // skip test

        good_r =
        [ // function     01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21
          ["is_defined",  f, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t],
          ["not_defined", t, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f],
          ["is_empty",    f, f, f, f, f, f, f, f, f, f, f, f, f, t, t, f, f, f, f, f, f],
          ["is_scalar",   s, t, t, t, t, t, t, t, t, t, t, f, f, f, f, f, f, f, f, s, s],
          ["is_vector",   s, f, f, f, f, f, f, f, f, f, f, t, t, t, t, t, t, t, t, f, f],
          ["is_string",   f, f, f, f, f, f, f, f, f, f, f, t, t, t, f, f, f, f, f, f, f],
          ["is_bool",     f, f, f, f, f, f, f, f, f, t, t, f, f, f, f, f, f, f, f, f, f],
          ["is_integer",  f, t, t, t, f, t, t, f, f, f, f, f, f, f, f, f, f, f, f, f, f],
          ["is_decimal",  f, f, f, f, t, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f],
          ["is_range",    f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, t, t],
          ["is_nan",      f, f, f, f, f, f, f, f, t, f, f, f, f, f, f, f, f, f, f, f, f],
          ["is_inf",      f, f, f, f, f, f, f, t, f, f, f, f, f, f, f, f, f, f, f, f, f],
          ["is_even",     s, f, t, t, f, t, t, s, s, s, s, s, s, s, s, s, s, s, s, s, s],
          ["is_odd",      s, t, f, f, f, f, f, s, s, s, s, s, s, s, s, s, s, s, s, s, s]
        ];

        // sanity-test tables
        table_check( test_r, test_c, false );
        table_check( good_r, good_c, false );

        // validate helper function and module
        function get_value( vid ) = table_get(test_r, test_c, vid, "tv");
        module run_test( fname, fresult, vid )
        {
          value_text = table_get(test_r, test_c, vid, "td");
          pass_value = table_get(good_r, good_c, fname, vid);

          test_pass = validate( cv=fresult, t=pass_value, pf=true );
          test_text = validate( str(fname, "(", get_value(vid), ")=", pass_value), fresult, pass_value );


          if ( pass_value != s )
          {
            if ( !test_pass )
              log_warn( str(vid, "(", value_text, ") ", test_text) );
            else if ( show_passed )
              log_info( str(vid, " ", test_text) );
          }
          else if ( show_skipped )
            log_info( str(vid, " *skip*: '", fname, "(", value_text, ")'") );
        }

        // Indirect function calls would be very useful here!!!
        for (vid=test_ids) run_test( "is_defined", is_defined(get_value(vid)), vid );
        for (vid=test_ids) run_test( "not_defined", not_defined(get_value(vid)), vid );
        for (vid=test_ids) run_test( "is_empty", is_empty(get_value(vid)), vid );
        for (vid=test_ids) run_test( "is_scalar", is_scalar(get_value(vid)), vid );
        for (vid=test_ids) run_test( "is_vector", is_vector(get_value(vid)), vid );
        for (vid=test_ids) run_test( "is_string", is_string(get_value(vid)), vid );
        for (vid=test_ids) run_test( "is_bool", is_bool(get_value(vid)), vid );
        for (vid=test_ids) run_test( "is_integer", is_integer(get_value(vid)), vid );
        for (vid=test_ids) run_test( "is_decimal", is_decimal(get_value(vid)), vid );
        for (vid=test_ids) run_test( "is_range", is_range(get_value(vid)), vid );
        for (vid=test_ids) run_test( "is_nan", is_nan(get_value(vid)), vid );
        for (vid=test_ids) run_test( "is_inf", is_inf(get_value(vid)), vid );
        for (vid=test_ids) run_test( "is_even", is_even(get_value(vid)), vid );
        for (vid=test_ids) run_test( "is_odd", is_odd(get_value(vid)), vid );

        // end-of-tests
      END_OPENSCAD;

      BEGIN_MFSCRIPT;
        include --path "${INCLUDE_PATH}" {config_base,config_csg}.mfs;
        include --path "${INCLUDE_PATH}" script_std.mfs;
      END_MFSCRIPT;
    END_SCOPE;

    BEGIN_SCOPE g2;
      BEGIN_OPENSCAD;
        include <primitives.scad>;
        use <table.scad>;
        use <console.scad>;
        use <validation.scad>;

        show_passed  = true;    // show test that pass
        show_skipped = true;    // show skipped tests

        echo( str("OpenSCAD Version ", version()) );

        // test-values columns
        test_c =
        [
          ["id", "identifier"],
          ["td", "description"],
          ["tv", "vale"]
        ];

        // test-values rows
        test_r =
        [
          ["t01", "The undefined value",        undef],
          ["t02", "An odd integer",             1],
          ["t03", "The boolean true",           true],
          ["t04", "The boolean false",          false],
          ["t05", "A character",                "a"],
          ["t06", "A string",                   "This is a longer string"],
          ["t07", "The empty string",           empty_str],
          ["t08", "The empty vector",           empty_v],
          ["t09", "A shorthand range",          [0:9]],
          ["t10", "A range",                    [0:0.5:9]],
          ["t11", "Test vector 01",             [undef]],
          ["t12", "Test vector 02",             [1]],
          ["t13", "Test vector 03",             [1, 2, 3]],
          ["t14", "Test vector 04",             [[1], [2], [3], [4], [5]]],
          ["t15", "Test vector 05",             [[1,2], [2,3]]],
          ["t16", "Test vector 06",             [[1,2], [2,3], [4,5], "ab"]],
          ["t17", "Test vector 07",             [[1,2,3], [4,5,6], [7,8,9], ["a", "b", "c"]]],
          ["t18", "Test vector 08",             [1, 2, 3, undef]],
          ["t19", "Test vector 09",             [undef, undef, undef, undef]],
          ["t20", "Test vector 10",             [[undef], [undef], [undef]]],
          ["t21", "Test vector 11",             [true, true, true, true, false]],
          ["t22", "Test vector 12",             [true, false, false, false, false]],
          ["t23", "Test vector 13",             [true, true, true, true]]
        ];

        test_ids = table_get_row_ids( test_r );

        // expected columns: ("id" + one column for each test)
        good_c = econcat([concat("id", test_ids), concat("identifier", test_ids)]);

        // expected rows: ("golden" test results), use 's' to skip test
        t = true;   // shortcuts
        f = false;
        u = undef;
        s = -1;     // skip test

        good_r =
        [ // function       01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23
          ["all_equal_T",   f, f, t, f, f, f, t, t, f, f, f, f, f, f, f, f, f, f, f, f, f, f, t],
          ["all_equal_F",   f, f, f, t, f, f, t, t, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f],
          ["all_equal_U",   t, f, f, f, f, f, t, t, f, f, t, f, f, f, f, f, f, f, t, f, f, f, f],
          ["any_equal_T",   f, f, t, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, t, t, t],
          ["any_equal_F",   f, f, f, t, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, t, t, f],
          ["any_equal_U",   t, f, f, f, f, f, f, f, f, f, t, f, f, f, f, f, f, t, t, f, f, f, f],
          ["all_defined",   f, t, t, t, t, t, t, t, t, t, f, t, t, t, t, t, t, f, f, t, t, t, t],
          ["any_undefined", t, f, f, f, f, f, f, f, f, f, t, f, f, f, f, f, f, t, t, f, f, f, f],
          ["all_scalars",   u, t, t, t, f, f, s, s, s, s, t, t, t, f, f, f, f, t, t, f, t, t, t],
          ["all_vectors",   u, f, f, f, f, f, t, t, f, f, f, f, f, t, t, f, t, f, f, t, f, f, f],
          ["all_strings",   u, f, f, f, t, t, t, s, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f],
          ["all_len_1",     u, f, f, f, t, t, s, s, f, f, f, f, f, t, f, f, f, f, f, t, f, f, f],
          ["all_len_2",     u, f, f, f, f, f, s, s, f, f, f, f, f, f, t, t, f, f, f, f, f, f, f],
          ["all_len_3",     u, f, f, f, f, f, s, s, f, f, f, f, f, f, f, f, t, f, f, f, f, f, f]
        ];

        // sanity-test tables
        table_check( test_r, test_c, false );
        table_check( good_r, good_c, false );

        // validate helper function and module
        function get_value( vid ) = table_get(test_r, test_c, vid, "tv");
        module run_test( fname, fresult, vid )
        {
          value_text = table_get(test_r, test_c, vid, "td");
          pass_value = table_get(good_r, good_c, fname, vid);

          test_pass = validate( cv=fresult, t="eq", ev=pass_value, pf=true );
          test_text = validate( str(fname, "(", get_value(vid), ")=", pass_value), fresult, "eq", pass_value );

          if ( pass_value != s )
          {
            if ( !test_pass )
              log_warn( str(vid, "(", value_text, ") ", test_text) );
            else if ( show_passed )
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
        for (vid=test_ids) run_test( "all_vectors", all_vectors(get_value(vid)), vid );
        for (vid=test_ids) run_test( "all_strings", all_strings(get_value(vid)), vid );
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
  END_SCOPE;

  BEGIN_SCOPE vector;
    BEGIN_OPENSCAD;
      include <primitives.scad>;
      use <table.scad>;
      use <console.scad>;
      use <validation.scad>;

      show_passed  = true;    // show test that pass
      show_skipped = true;    // show skipped tests

      echo( str("OpenSCAD Version ", version()) );

      // test-values columns
      test_c =
      [
        ["id", "identifier"],
        ["td", "description"],
        ["tv", "vale"]
      ];

      // test-values rows
      test_r =
      [
        ["t01", "The undefined value",        undef],
        ["t02", "The empty vector",           empty_v],
        ["t03", "A range",                    [0:0.5:9]],
        ["t04", "A string",                   "A string"],
        ["t05", "Test vector 01",             ["orange","apple","grape","banana"]],
        ["t06", "Test vector 02",             ["b","a","n","a","n","a","s"]],
        ["t07", "Test vector 03",             [undef]],
        ["t08", "Test vector 04",             [[1,2],[2,3]]],
        ["t09", "Test vector 05",             ["ab",[1,2],[2,3],[4,5]]],
        ["t10", "Test vector 06",             [[1,2,3],[4,5,6],[7,8,9],["a","b","c"]]],
        ["t11", "Vector of integers 0 to 15", [for (i=[0:15]) i]]
      ];

      test_ids = table_get_row_ids( test_r );

      // expected columns: ("id" + one column for each test)
      good_c = econcat([concat("id", test_ids), concat("identifier", test_ids)]);

      // expected rows: ("golden" test results), use 's' to skip test
      skip = -1;  // skip test

      good_r =
      [ // function
        ["first",
          undef,                                              // t01
          undef,                                              // t02
          [0:0.5:9],                                          // t03
          "A",                                                // t04
          "orange",                                           // t05
          "b",                                                // t06
          undef,                                              // t07
          [1,2],                                              // t08
          "ab",                                               // t09
          [1,2,3],                                            // t10
          0                                                   // t11
        ],
        ["last",
          undef,                                              // t01
          undef,                                              // t02
          [0:0.5:9],                                          // t03
          "g",                                                // t04
          "banana",                                           // t05
          "s",                                                // t06
          undef,                                              // t07
          [2,3],                                              // t08
          [4,5],                                              // t09
          ["a","b","c"],                                      // t10
          15                                                  // t11
        ],
        ["head",
          undef,                                              // t01
          undef,                                              // t02
          [0:0.5:9],                                          // t03
          ["A"],                                              // t04
          ["orange"],                                         // t05
          ["b"],                                              // t06
          [undef],                                            // t07
          [[1,2]],                                            // t08
          ["ab"],                                             // t09
          [[1,2,3]],                                          // t10
          [0]                                                 // t11
        ],
        ["tail",
          undef,                                              // t01
          undef,                                              // t02
          [0:0.5:9],                                          // t03
          [" ","s","t","r","i","n","g"],                      // t04
          ["apple","grape","banana"],                         // t05
          ["a","n","a","n","a","s"],                          // t06
          empty_v,                                            // t07
          [[2,3]],                                            // t08
          [[1,2],[2,3],[4,5]],                                // t09
          [[4,5,6],[7,8,9],["a","b","c"]],                    // t10
          [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]               // t11
        ],
        ["reverse",
          undef,                                              // t01
          empty_v,                                            // t02
          [0:0.5:9],                                          // t03
          ["g","n","i","r","t","s"," ","A"],                  // t04
          ["banana","grape","apple","orange"],                // t05
          ["s","a","n","a","n","a","b"],                      // t06
          [undef],                                            // t07
          [[2,3],[1,2]],                                      // t08
          [[4,5],[2,3],[1,2],"ab"],                           // t09
          [["a","b","c"],[7,8,9],[4,5,6],[1,2,3]],            // t10
          [15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0]             // t11

        ],
        ["econcat",
          undef,                                              // t01
          empty_v,                                            // t02
          [0:0.5:9],                                          // t03
          [["A"," ","s","t","r","i","n","g"]],                // t04
          [
            ["o","a","g","b"],["r","p","r","a"],
            ["a","p","a","n"],["n","l","p","a"],
            ["g","e","e","n"]
          ],                                                  // t05
          [["b","a","n","a","n","a","s"]],                    // t06
          [undef],                                            // t07
          [[1,2],[2,3]],                                      // t08
          [["a",1,2,4],["b",2,3,5]],                          // t09
          [[1,4,7,"a"],[2,5,8,"b"],[3,6,9,"c"]],              // t10
          [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]             // t11
        ],
        ["estr",
          undef,                                              // t01
          empty_v,                                            // t02
          [0:0.5:9],                                          // t03
          "A string",                                         // t04
          "orangeapplegrapebanana",                           // t05
          "bananas",                                          // t06
          "undef",                                            // t07
          "[1, 2][2, 3]",                                     // t08
          "ab[1, 2][2, 3][4, 5]",                             // t09
          "[1, 2, 3][4, 5, 6][7, 8, 9][\"a\", \"b\", \"c\"]", // t10
          "0123456789101112131415"                            // t11
        ],
        ["qsort",
          undef,                                              // t01
          empty_v,                                            // t02
          [0:0.5:9],                                          // t03
          [" ","A","g","i","n","r","s","t"],                  // t04
          ["apple","banana","grape","orange"],                // t05
          ["a","a","a","b","n","n","s"],                      // t06
          [undef],                                            // t07
          skip,                                               // t08
          skip,                                               // t09
          skip,                                               // t10
          [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]             // t11
        ],
        ["esum",
          undef,                                              // t01
          0,                                                  // t02
          undef,                                              // t03
          undef,                                              // t04
          undef,                                              // t05
          undef,                                              // t06
          undef,                                              // t07
          [3,5],                                              // t08
          undef,                                              // t09
          [undef,undef,undef],                                // t10
          120                                                 // t11
        ],
        ["eselect_F",
          undef,                                              // t01
          empty_v,                                            // t02
          [0:0.5:9],                                          // t03
          ["A"," ","s","t","r","i","n","g"],                  // t04
          ["o","a","g","b"],                                  // t05
          ["b","a","n","a","n","a","s"],                      // t06
          [undef],                                            // t07
          [1,2],                                              // t08
          ["a",1,2,4],                                        // t09
          [1,4,7,"a"],                                        // t10
          [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]             // t11
        ],
        ["eselect_L",
          undef,                                              // t01
          empty_v,                                            // t02
          [0:0.5:9],                                          // t03
          ["A"," ","s","t","r","i","n","g"],                  // t04
          ["e","e","e","a"],                                  // t05
          ["b","a","n","a","n","a","s"],                      // t06
          [undef],                                            // t07
          [2,3],                                              // t08
          ["b",2,3,5],                                        // t09
          [3,6,9,"c"],                                        // t10
          [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]             // t11
        ],
        ["eselect_1",
          undef,                                              // t01
          empty_v,                                            // t02
          [0:0.5:9],                                          // t03
          skip,                                               // t04
          ["r","p","r","a"],                                  // t05
          skip,                                               // t06
          [undef],                                            // t07
          [2,3],                                              // t08
          ["b",2,3,5],                                        // t09
          [2,5,8,"b"],                                        // t10
          skip                                                // t11
        ],
        ["defined_or_D",
          "default",                                          // t01
          empty_v,                                            // t02
          [0:0.5:9],                                          // t03
          "A string",                                         // 04
          ["orange","apple","grape","banana"],                // t05
          ["b","a","n","a","n","a","s"],                      // t06
          [undef],                                            // t07
          [[1,2],[2,3]],                                      // t08
          ["ab",[1,2],[2,3],[4,5]],                           // t09
          [[1,2,3],[4,5,6],[7,8,9],["a","b","c"]],            // t10
          [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]             // t11
        ],
        ["edefined_or_DE3",
          "default",                                          // t01
          "default",                                          // t02
          "default",                                          // t03
          "t",                                                // t04
          "banana",                                           // t05
          "a",                                                // t06
          "default",                                          // t07
          "default",                                          // t08
          [4,5],                                              // t09
          ["a","b","c"],                                      // t10
          3                                                   // t11
        ]
      ];

      // sanity-test tables
      table_check( test_r, test_c, false );
      table_check( good_r, good_c, false );

      // validate helper function and module
      function get_value( vid ) = table_get(test_r, test_c, vid, "tv");
      module run_test( fname, fresult, vid )
      {
        value_text = table_get(test_r, test_c, vid, "td");
        pass_value = table_get(good_r, good_c, fname, vid);

        test_pass = validate( cv=fresult, t="eq", ev=pass_value, pf=true );
        test_text = validate( str(fname, "(", get_value(vid), ")=", pass_value), fresult, "eq", pass_value );

        if ( pass_value != skip )
        {
          if ( !test_pass )
            log_warn( str(vid, "(", value_text, ") ", test_text) );
          else if ( show_passed )
            log_info( str(vid, " ", test_text) );
        }
        else if ( show_skipped )
          log_info( str(vid, " *skip*: '", fname, "(", value_text, ")'") );
      }

      // Indirect function calls would be very useful here!!!
      for (vid=test_ids) run_test( "first", first(get_value(vid)), vid );
      for (vid=test_ids) run_test( "last", last(get_value(vid)), vid );
      for (vid=test_ids) run_test( "head", head(get_value(vid)), vid );
      for (vid=test_ids) run_test( "tail", tail(get_value(vid)), vid );
      for (vid=test_ids) run_test( "reverse", reverse(get_value(vid)), vid );
      for (vid=test_ids) run_test( "econcat", econcat(get_value(vid)), vid );
      for (vid=test_ids) run_test( "estr", estr(get_value(vid)), vid );
      for (vid=test_ids) run_test( "qsort", qsort(get_value(vid)), vid );
      for (vid=test_ids) run_test( "esum", esum(get_value(vid)), vid );
      for (vid=test_ids) run_test( "eselect_F", eselect(get_value(vid),f=true), vid );
      for (vid=test_ids) run_test( "eselect_L", eselect(get_value(vid),l=true), vid );
      for (vid=test_ids) run_test( "eselect_1", eselect(get_value(vid),e=1), vid );
      for (vid=test_ids) run_test( "defined_or_D", defined_or(get_value(vid),"default"), vid );
      for (vid=test_ids) run_test( "edefined_or_DE3", edefined_or(get_value(vid),3,"default"), vid );

      // end-of-tests
    END_OPENSCAD;

    BEGIN_MFSCRIPT;
      include --path "${INCLUDE_PATH}" {config_base,config_csg}.mfs;
      include --path "${INCLUDE_PATH}" script_std.mfs;
    END_MFSCRIPT;
  END_SCOPE;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
