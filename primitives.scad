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
  \returns  <boolean> \b true when the value is defined
            and \b false otherwise.
*******************************************************************************/
function is_defined( v ) = (v == undef) ? false : true;

//! Test if a value is not defined.
/***************************************************************************//**
  \param    v <value> A value.
  \returns  <boolean> \b true when the value is not defined
            and \b false otherwise.
*******************************************************************************/
function not_defined( v ) = (v == undef) ? true : false;

//! Test if an iterable value is empty.
/***************************************************************************//**
  \param    v <value> An iterable value.
  \returns  <boolean> \b true when the iterable value has zero elements
            and \b false otherwise.
*******************************************************************************/
function is_empty( v ) = (len(v) == 0);

//! Test if a value is a single non-iterable value.
/***************************************************************************//**
  \param    v <value> A value.
  \returns  <boolean> \b true when the value is a single non-iterable value
            and \b false otherwise.

  \details

     value is      | defined result
    :-------------:|:-----------------:
     \b undef      | \b true
     \b inf        | \b true
     \b nan        | \b true
     integer       | \b true
     decimal       | \b true
     boolean       | \b true
     string        | \b false
     vector        | \b false
     range         | not defined
*******************************************************************************/
function is_scalar( v ) = (len(v) == undef);

//! Test if a value has multiple parts and is iterable.
/***************************************************************************//**
  \param    v <value> A value.
  \returns  <boolean> \b true when the value is an iterable multi-part value
            and \b false otherwise.

  \details

     value is      | defined result
    :-------------:|:-----------------:
     \b undef      | \b false
     \b inf        | \b false
     \b nan        | \b false
     integer       | \b false
     decimal       | \b false
     boolean       | \b false
     string        | \b true
     vector        | \b true
     range         | not defined
*******************************************************************************/
function is_iterable( v ) = (len(v) != undef);

//! Test if a value is a string.
/***************************************************************************//**
  \param    v <value> A value.
  \returns  <boolean> \b true when the value is a string
            and \b false otherwise.
*******************************************************************************/
function is_string( v ) = (str(v) == v);

//! Test if a value is a vector.
/***************************************************************************//**
  \param    v <value> A value.
  \returns  <boolean> \b true when the value is a vector
            and \b false otherwise.
*******************************************************************************/
function is_vector( v ) =  is_iterable(v) && !is_string(v);

//! Test if a value is a boolean constant.
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

//! Test if a value is a number.
/***************************************************************************//**
  \param    v <value> A value.
  \returns  <boolean> \b true when the value is a number
            and \b false otherwise.

  \warning  Returns \b true even for numerical values that are considered
            infinite and invalid.
*******************************************************************************/
function is_number( v ) = is_defined(v % 1);

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
    !is_iterable(v) &&
    !is_bool(v) &&
    !is_integer(v) &&
    !is_decimal(v) &&
    !is_nan(v) &&
    !is_inf(v);

//! Test if a numerical value is invalid.
/***************************************************************************//**
  \param    v <value> A numerical value.
  \returns  <boolean> \b true when the value is determined to be \b nan
            (Not A Number) and \b false otherwise.
*******************************************************************************/
function is_nan( v ) = ( v != v );

//! Test if a numerical value is infinite.
/***************************************************************************//**
  \param    v <value> A numerical value.
  \returns  <boolean> \b true when the value is determined to be
            \b inf (greater than the largest representable number)
            and \b false otherwise.
*******************************************************************************/
function is_inf( v ) = ( v == (number_max * number_max) );

//! Test if a numerical value is even.
/***************************************************************************//**
  \param    v <value> A numerical value.
  \returns  <boolean> \b true when the value is determined to be \e even
            and \b false otherwise.

  \details

  \note     The value must be valid and defined but may be positive or
            negative. Any value that is not an integer returns \b false.
*******************************************************************************/
function is_even( v ) = !is_integer(v) ? false : ((v % 2) == 0);

//! Test if a numerical value is odd.
/***************************************************************************//**
  \param    v <value> A numerical value.
  \returns  <boolean> \b true when the value is determined to be \e odd
            and \b false otherwise.

  \details

  \note     The value must be valid and defined but may be positive or
            negative. Any value that is not an integer returns \b false.
*******************************************************************************/
function is_odd( v ) = !is_integer(v) ? false : ((v % 2) != 0);

//! Test that all elements of an iterable value equal a comparison value.
/***************************************************************************//**
  \param    v <value> An iterable value.
  \param    cv <value> A comparison value.
  \returns  <boolean> \b true when all elements equal the value \p cv
            and \b false otherwise.

  \warning  Always returns \b true when \p v is empty.
*******************************************************************************/
function all_equal
(
  v,
  cv
) = !is_iterable(v) ? (v == cv)
  : is_empty(v) ? true
  : (first(v) != cv) ? false
  : all_equal(tail(v), cv);

//! Test if any element of an iterable value equals a comparison value.
/***************************************************************************//**
  \param    v <value> An iterable value.
  \param    cv <value> A comparison value.
  \returns  <boolean> \b true when any element equals the value \p cv
            and \b false otherwise.

  \warning  Always returns \b false when \p v is empty.
*******************************************************************************/
function any_equal
(
  v,
  cv
) = !is_iterable(v) ? (v == cv)
  : is_empty(v) ? false
  : (first(v) == cv) ? true
  : any_equal(tail(v), cv);

//! Test that no element of an iterable value is undefined.
/***************************************************************************//**
  \param    v <value> An iterable value.
  \returns  <boolean> \b true when no element is undefined
            and \b false otherwise.

  \warning  Always returns \b true when \p v is empty.
*******************************************************************************/
function all_defined(v) = !any_equal(v, undef);

//! Test if any element of an iterable value is undefined.
/***************************************************************************//**
  \param    v <value> An iterable value.
  \returns  <boolean> \b true when any element is undefined
            and \b false otherwise.

  \warning  Always returns \b false when \p v is empty.
*******************************************************************************/
function any_undefined(v) = any_equal(v, undef);

//! Test if all elements of an iterable value are scalars.
/***************************************************************************//**
  \param    v <value> An iterable value.
  \returns  <boolean> \b true when all elements are scalar values
            and \b false otherwise.
            Returns \b true when \p v is a single scalar value.
            Returns the value of \p v when it is not defined.

  \warning  Always returns \b true when \p v is empty.
*******************************************************************************/
function all_scalars
(
  v
) = not_defined(v) ? v
  : is_scalar(v) ? true
  : is_empty(v) ? true
  : !is_scalar(first(v)) ? false
  : all_scalars(tail(v));

//! Test if all elements of an iterable value are vectors.
/***************************************************************************//**
  \param    v <value> An iterable value.
  \returns  <boolean> \b true when all elements are vector values
            and \b false otherwise.
            Returns \b true when \p v is a single vector value.
            Returns the value of \p v when it is not defined.

  \warning  Always returns \b true when \p v is empty.
*******************************************************************************/
function all_vectors
(
  v
) = not_defined(v) ? v
  : is_scalar(v) ? false
  : is_empty(v) ? true
  : !is_vector(first(v)) ? false
  : all_vectors(tail(v));

//! Test if all elements of an iterable value are strings.
/***************************************************************************//**
  \param    v <value> An iterable value.
  \returns  <boolean> \b true when all elements are string values
            and \b false otherwise.
            Returns \b true when \p v is a single string value.
            Returns the value of \p v when it is not defined.

  \warning  Always returns \b true when \p v is empty.
*******************************************************************************/
function all_strings
(
  v
) = not_defined(v) ? v
  : is_scalar(v) ? false
  : is_empty(v) ? true
  : !is_string(first(v)) ? false
  : all_strings(tail(v));

//! Test if all elements of an iterable value are numbers.
/***************************************************************************//**
  \param    v <value> An iterable value.
  \returns  <boolean> \b true when all elements are numerical values
            and \b false otherwise.
            Returns \b true when \p v is a single numerical value.
            Returns the value of \p v when it is not defined.

  \warning  Always returns \b true when \p v is empty.
*******************************************************************************/
function all_numbers
(
  v
) = not_defined(v) ? v
  : is_scalar(v) ? is_number(v)
  : is_empty(v) ? true
  : !is_number(first(v)) ? false
  : all_numbers(tail(v));

//! Test if all elements of an iterable value have a given length.
/***************************************************************************//**
  \param    v <value> An iterable value.
  \param    l <integer> The length.
  \returns  <boolean> \b true when all elements have length equal to \p l
            and \b false otherwise.
            Returns the value of \p v when it is not defined.

  \warning  Always returns \b true when \p v is empty.
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

//! Return the first element of an iterable value.
/***************************************************************************//**
  \param    v <value> An iterable value.
  \returns  The first element of \p v.
            Returns the value of \p v when it is not defined or is not iterable.
            Returns \b undef when \p v is empty.
*******************************************************************************/
function first
(
  v
) = !is_iterable(v) ? v
  : v[0];

//! Return the last element of an iterable value.
/***************************************************************************//**
  \param    v <value> An iterable value.
  \returns  The last element of \p v.
            Returns the value of \p v when it is not defined or is not iterable.
            Returns \b undef when \p v is empty.
*******************************************************************************/
function last
(
  v
) = not_defined(v) ? v
  : !is_iterable(v) ? v
  : is_empty(v) ? undef
  : v[len(v)-1];

//! Return a vector containing the first element of an iterable value.
/***************************************************************************//**
  \param    v <value> An iterable value.
  \returns  A new vector containing the first element of \p v.
            Returns the value of \p v when it is not defined or is not iterable.
            Returns \b undef when \p v is empty.
*******************************************************************************/
function head
(
  v
) = not_defined(v) ? v
  : !is_iterable(v) ? v
  : is_empty(v) ? undef
  : [first(v)];

//! Return a vector containing all but the first element of an iterable value.
/***************************************************************************//**
  \param    v <value> An iterable value.
  \returns  A new vector containing all but the first element of \p v.
            Returns the value of \p v when it is not defined or is not iterable.
            Returns \b empty_v when \p v contains a single element.
            Returns \b undef when \p v is empty.
*******************************************************************************/
function tail
(
  v
) = not_defined(v) ? v
  : !is_iterable(v) ? v
  : is_empty(v) ? undef
  : (len(v) == 1) ? empty_v
  : [for (i = [1 : len(v)-1]) v[i]];

//! Return a vector containing the elements of an iterable value in reverse order.
/***************************************************************************//**
  \param    v <value> An iterable value.
  \returns  A new vector with the elements of \p v in reversed order.
            Returns the value of \p v when it is not defined, is not iterable,
            or is empty.
*******************************************************************************/
function reverse
(
  v
) = not_defined(v) ? v
  : !is_iterable(v) ? v
  : is_empty(v) ? v
  : concat( reverse(tail(v)), head(v) );

//! Return a vector containing select elements of each iterable vector member.
/***************************************************************************//**
  \param    v <vector> A vector of iterable values.
  \param    f <boolean> Select the first element of each iterable value.
  \param    l <boolean> Select the last element of each iterable value.
  \param    e <integer> Select an element index for each iterable value.
  \returns  A new vector containing the selected element of each iterable
            value of \p v.
            Returns the value of \p v when it is not defined, is not iterable,
            or is empty.

  \details

  \note     When more than one selection criteria is specified, the
            order of precedence is: \p e, \p l, \p f.
*******************************************************************************/
function eselect
(
  v,
  f = true,
  l = false,
  e
) = not_defined(v) ? v
  : !is_iterable(v) ? v
  : is_empty(v) ? v
  : is_defined(e) ? concat( [first(v)[e]], eselect(tail(v), f, l, e) )
  : (l == true) ? concat( [last(first(v))], eselect(tail(v), f, l, e) )
  : (f == true) ? concat( [first(first(v))], eselect(tail(v), f, l, e) )
  : undef;

//! Return a vector containing the element-wise concatenation of iterable values.
/***************************************************************************//**
  \param    v <vector> A vector of iterable values.
  \returns  A new vector constructed from the element-wise concatenation
            of each iterable value in \p v. The length will be limited by
            the iterable value with the shortest length.
            Returns the value of \p v when it is not defined, is empty, or
            when any element of \p v (including \p v itself) is not iterable.
            Returns \b empty_v when any iterable value in \p v is empty.

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
  : !is_iterable(v) ? v
  : is_empty(v) ? v
  : any_undefined([for (i = v) len(i)]) ? v       // any element not iterable?
  : (min([for (i = v) len(i)]) == 0) ? empty_v    // any element empty?
  : let
    (
      t = [for (i = [0 : len(v)-1]) tail(v[i])],
      h = [for (i = [0 : len(v)-1]) first(v[i])]
    )
    concat([h], econcat(t));

//! Concatenate vector elements into a single string.
/***************************************************************************//**
  \param    v <vector> A vector of values.
  \returns  A new string constructed by converting each element of the
            vector to a string and concatenating together.
            Returns the value of \p v when it is not defined, is not iterable,
            or is empty.

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
  : !is_iterable(v) ? v
  : is_empty(v) ? v
  : (len(v) == 1) ? str(first(v))
  : str(first(v), estr(tail(v)));

//! Sort the elements of an iterable value using the quick sort method.
/***************************************************************************//**
  \param    v <value> An iterable value.
  \returns  A new vector with elements sorted in ascending order.
            Returns the value of \p v when it is not defined, is not iterable,
            or is empty.

  \details

  \warning This implementation relies on the comparison operators
           '<' and '>' which expect the operands to be either two scalar
           numbers or two strings. Therefore, this function returns \b undef
           for vectors containing anything other than all scalar numbers
           or all strings.

    See [Wikipedia](https://en.wikipedia.org/wiki/Quicksort)
    for more information.
*******************************************************************************/
function qsort
(
  v
) = not_defined(v) ? v
  : !(all_strings(v) || all_numbers(v)) ? undef  // not all numbers or strings
  : !is_iterable(v) ? v                          // a single number or string
  : is_empty(v) ? v
  : let
    (
      mp = v[floor(len(v)/2)],

      lt = [for (i = [0 : len(v)-1]) if (v[i]  < mp) v[i]],
      eq = [for (i = [0 : len(v)-1]) if (v[i] == mp) v[i]],
      gt = [for (i = [0 : len(v)-1]) if (v[i]  > mp) v[i]]

    )
    concat(qsort(lt), eq, qsort(gt));

//! Compute the numerical sum of a range of vector elements.
/***************************************************************************//**
  \param    v <vector> A vector of numerical values.
  \param    b <integer> The vector element index at which to begin summation
            (first element when not specified).
  \param    e <integer> The vector element index at which to end summation
            (last element when not specified).
  \returns  <decimal> The summation of the elements.
            Returns \b undef when \p v is not defined, is not iterable,
            or is empty.
*******************************************************************************/
function esum
(
  v,
  b,
  e
) = let
    (
      s = is_defined(b) ? min(max(b,0),len(v)-1) : 0,
      i = is_defined(e) ? max(min(e,len(v)-1),0) : len(v)-1
    )
    not_defined(v) ? undef
  : !is_iterable(v) ? undef
  : is_empty(v) ? undef
  : (i == s) ? v[i]
  : v[i] + esum(v, s, i-1);

//! Choose defined or default value.
/***************************************************************************//**
  \param    v <value> A test value.
  \param    d <value> A default value.
  \returns  The value \p v when it is defined or the value \p d otherwise.
*******************************************************************************/
function defined_or
(
  v,
  d
) = is_defined(v) ? v
  : d;

//! Choose defined vector element or default value.
/***************************************************************************//**
  \param    v <vector> A vector.
  \param    e <integer> A test element index.
  \param    d <value> A default value.
  \returns  The value of vector element \p e, namely <tt>v[e]</tt>, when it
            is defined or the value \p d otherwise.
*******************************************************************************/
function edefined_or
(
  v,
  e,
  d
) = (len(v) > e) ? v[e]
  : d;

//! Create a vector with a repeating constant element.
/***************************************************************************//**
  \param    e <value> An element value.
  \param    n <integer> A copy count.
  \returns  A vector with \p n copies of the element value.
            Returns \b empty_v when \p n<1.
*******************************************************************************/
function evector
(
  e,
  n
) = (n<1) ? empty_v : [for (i=[0:1:n-1]) e];

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
          ["tv", "value"]
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
          ["t12", "A character string",         "a"],
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
          ["is_scalar",   t, t, t, t, t, t, t, t, t, t, t, f, f, f, f, f, f, f, f, s, s],
          ["is_iterable", f, f, f, f, f, f, f, f, f, f, f, t, t, t, t, t, t, t, t, s, s],
          ["is_vector",   f, f, f, f, f, f, f, f, f, f, f, f, f, f, t, t, t, t, t, s, s],
          ["is_string",   f, f, f, f, f, f, f, f, f, f, f, t, t, t, f, f, f, f, f, f, f],
          ["is_bool",     f, f, f, f, f, f, f, f, f, t, t, f, f, f, f, f, f, f, f, f, f],
          ["is_integer",  f, t, t, t, f, t, t, f, f, f, f, f, f, f, f, f, f, f, f, f, f],
          ["is_decimal",  f, f, f, f, t, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f],
          ["is_number",   f, t, t, t, t, t, t, t, t, f, f, f, f, f, f, f, f, f, f, f, f],
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
        for (vid=test_ids) run_test( "is_iterable", is_iterable(get_value(vid)), vid );
        for (vid=test_ids) run_test( "is_vector", is_vector(get_value(vid)), vid );
        for (vid=test_ids) run_test( "is_string", is_string(get_value(vid)), vid );
        for (vid=test_ids) run_test( "is_bool", is_bool(get_value(vid)), vid );
        for (vid=test_ids) run_test( "is_integer", is_integer(get_value(vid)), vid );
        for (vid=test_ids) run_test( "is_decimal", is_decimal(get_value(vid)), vid );
        for (vid=test_ids) run_test( "is_number", is_number(get_value(vid)), vid );
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
          ["tv", "value"]
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
          ["all_numbers",   u, t, f, f, f, f, s, s, f, f, f, t, t, f, f, f, f, f, f, f, f, f, f],
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
        ["tv", "value"]
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
          undef,                                              // t03
          [" ","A","g","i","n","r","s","t"],                  // t04
          ["apple","banana","grape","orange"],                // t05
          ["a","a","a","b","n","n","s"],                      // t06
          undef,                                              // t07
          undef,                                              // t08
          undef,                                              // t09
          undef,                                              // t10
          [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]             // t11
        ],
        ["esum",
          undef,                                              // t01
          undef,                                              // t02
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
