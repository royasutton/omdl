//! Mathematical primitive functions.
/***************************************************************************//**
  \file   primitives.scad
  \author Roy Allen Sutton
  \date   2015-2017

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
  \page tv_prim_test Variable Tests
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

//----------------------------------------------------------------------------//
// group 1
//----------------------------------------------------------------------------//

//! Test if a value is defined.
/***************************************************************************//**
  \param    v \<value> A value.

  \returns  <boolean> \b true when the value is defined
            and \b false otherwise.
*******************************************************************************/
function is_defined( v ) = (v == undef) ? false : true;

//! Test if a value is not defined.
/***************************************************************************//**
  \param    v \<value> A value.

  \returns  <boolean> \b true when the value is not defined
            and \b false otherwise.
*******************************************************************************/
function not_defined( v ) = (v == undef) ? true : false;

//! Test if an iterable value is empty.
/***************************************************************************//**
  \param    v \<value> An iterable value.

  \returns  <boolean> \b true when the iterable value has zero elements
            and \b false otherwise.
*******************************************************************************/
function is_empty( v ) = (len(v) == 0);

//! Test if a value is a single non-iterable value.
/***************************************************************************//**
  \param    v \<value> A value.

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
  \param    v \<value> A value.

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
  \param    v \<value> A value.

  \returns  <boolean> \b true when the value is a string
            and \b false otherwise.
*******************************************************************************/
function is_string( v ) = (str(v) == v);

//! Test if a value is a vector.
/***************************************************************************//**
  \param    v \<value> A value.

  \returns  <boolean> \b true when the value is a vector
            and \b false otherwise.
*******************************************************************************/
function is_vector( v ) =  is_iterable(v) && !is_string(v);

//! Test if a value is a boolean constant.
/***************************************************************************//**
  \param    v \<value> A value.

  \returns  <boolean> \b true when the value is one of the predefined
            boolean constants <tt>[true|false]</tt> and \b false otherwise.
*******************************************************************************/
function is_boolean
(
  v
) = is_string(v) ? false
  : (str(v) == "true") ? true
  : (str(v) == "false") ? true
  : false;

//! Test if a value is an integer.
/***************************************************************************//**
  \param    v \<value> A value.

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
  \param    v \<value> A value.

  \returns  <boolean> \b true when the value is a decimal
            and \b false otherwise.
*******************************************************************************/
function is_decimal( v ) = ((v % 1) > 0);

//! Test if a value is a number.
/***************************************************************************//**
  \param    v \<value> A value.

  \returns  <boolean> \b true when the value is a number
            and \b false otherwise.

  \warning  Returns \b true even for numerical values that are considered
            infinite and invalid.
*******************************************************************************/
function is_number( v ) = is_defined(v % 1);

//! Test if a value is a range definition.
/***************************************************************************//**
  \param    v \<value> A value.

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
    !is_boolean(v) &&
    !is_integer(v) &&
    !is_decimal(v) &&
    !is_nan(v) &&
    !is_inf(v);

//! Test if a numerical value is invalid.
/***************************************************************************//**
  \param    v \<value> A numerical value.

  \returns  <boolean> \b true when the value is determined to be \b nan
            (Not A Number) and \b false otherwise.
*******************************************************************************/
function is_nan( v ) = ( v != v );

//! Test if a numerical value is infinite.
/***************************************************************************//**
  \param    v \<value> A numerical value.

  \returns  <boolean> \b true when the value is determined to be
            \b inf (greater than the largest representable number)
            and \b false otherwise.
*******************************************************************************/
function is_inf( v ) = ( v == (number_max * number_max) );

//! Test if a numerical value is even.
/***************************************************************************//**
  \param    v \<value> A numerical value.

  \returns  <boolean> \b true when the value is determined to be \e even
            and \b false otherwise.

  \details

  \note     The value must be valid and defined but may be positive or
            negative. Any value that is not an integer returns \b false.
*******************************************************************************/
function is_even( v ) = !is_integer(v) ? false : ((v % 2) == 0);

//! Test if a numerical value is odd.
/***************************************************************************//**
  \param    v \<value> A numerical value.

  \returns  <boolean> \b true when the value is determined to be \e odd
            and \b false otherwise.

  \details

  \note     The value must be valid and defined but may be positive or
            negative. Any value that is not an integer returns \b false.
*******************************************************************************/
function is_odd( v ) = !is_integer(v) ? false : ((v % 2) != 0);

//----------------------------------------------------------------------------//
// group 2
//----------------------------------------------------------------------------//

//! Test if all elements of a value equal a comparison value.
/***************************************************************************//**
  \param    v \<value> A value or an iterable value.
  \param    cv \<value> A comparison value.

  \returns  <boolean> \b true when all elements equal the value \p cv
            and \b false otherwise.

  \details

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

//! Test if any element of a value equals a comparison value.
/***************************************************************************//**
  \param    v \<value> A value or an iterable value.
  \param    cv \<value> A comparison value.

  \returns  <boolean> \b true when any element equals the value \p cv
            and \b false otherwise.

  \details

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

//! Test if no element of a value is undefined.
/***************************************************************************//**
  \param    v \<value> A value or an iterable value.

  \returns  <boolean> \b true when no element is undefined
            and \b false otherwise.

  \details

  \warning  Always returns \b true when \p v is empty.
*******************************************************************************/
function all_defined(v) = !any_equal(v, undef);

//! Test if any element of a value is undefined.
/***************************************************************************//**
  \param    v \<value> A value or an iterable value.

  \returns  <boolean> \b true when any element is undefined
            and \b false otherwise.

  \details

  \warning  Always returns \b false when \p v is empty.
*******************************************************************************/
function any_undefined(v) = any_equal(v, undef);

//! Test if all elements of a value are scalars.
/***************************************************************************//**
  \param    v \<value> A value or an iterable value.

  \returns  <boolean> \b true when all elements are scalar values
            and \b false otherwise.
            Returns \b true when \p v is a single scalar value.
            Returns the value of \p v when it is not defined.

  \details

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

//! Test if all elements of a value are vectors.
/***************************************************************************//**
  \param    v \<value> A value or an iterable value.

  \returns  <boolean> \b true when all elements are vector values
            and \b false otherwise.
            Returns \b true when \p v is a single vector value.
            Returns the value of \p v when it is not defined.

  \details

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

//! Test if all elements of a value are strings.
/***************************************************************************//**
  \param    v \<value> A value or an iterable value.

  \returns  <boolean> \b true when all elements are string values
            and \b false otherwise.
            Returns \b true when \p v is a single string value.
            Returns the value of \p v when it is not defined.

  \details

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

//! Test if all elements of a value are numbers.
/***************************************************************************//**
  \param    v \<value> A value or an iterable value.

  \returns  <boolean> \b true when all elements are numerical values
            and \b false otherwise.
            Returns \b true when \p v is a single numerical value.
            Returns the value of \p v when it is not defined.

  \details

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

//! Test if all elements of a value have a given length.
/***************************************************************************//**
  \param    v \<value> A value or an iterable value.
  \param    l <integer> The length.

  \returns  <boolean> \b true when all elements have length equal to \p l
            and \b false otherwise.
            Returns the value of \p v when it is not defined.

  \details

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

//! Test if all elements of two values are approximately equal.
/***************************************************************************//**
  \param    v1 \<value> A value or an iterable value 1.
  \param    v2 \<value> A value or an iterable value 2.
  \param    p \<number> A numerical precision.

  \returns  <boolean> \b true when all elements of each values are
            sufficiently equal and \b false otherwise. All numerical
            comparisons are performed with precision limited by \p p. All
            non-numeric comparisons test for exact equality.

  \details

  \note     The parameter \p p indicated the number of digits of precision
            for each numerical comparison.

  \warning  Always returns \b true when \p v is empty.
*******************************************************************************/
function almost_equal
(
  v1,
  v2,
  p = 4
) = all_scalars([v1, v2]) ?
    (
      all_numbers([v1, v2]) ? ( (abs(v1-v2) * pow(10, p)) < 1 )
    : (v1 == v2)
    )
  : (is_string(v1) || is_string(v2)) ? (v1 == v2)
  : all_equal([v1, v2], empty_v) ? true
  : any_equal([v1, v2], empty_v) ? false
  : !almost_equal(first(v1), first(v2), p) ? false
  : almost_equal(tail(v1), tail(v2), p);

//! Compare any two values (may be iterable and/or of different types).
/***************************************************************************//**
  \param    v1 \<value> A value or an iterable value 1.
  \param    v2 \<value> A value or an iterable value 2.
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
      3    | string   |           | lexical comparison
      4    | boolean  |           | \b false \< \b true
      5    | vector   |           | lengths then element-wise comparison
      6    | range    | \b true   | compare sum of range elements
      6    | range    | \b false  | lengths then element-wise comparison

  \note     When comparing two vectors of equal length, the comparison
            continue element-by-element until an ordering can be
            determined. Two vectors are declared equal when all elements
            have been compared and no ordering has been determined.

  \warning  The performance of element-wise comparisons of vectors
            degrades exponentially with vector size.
  \warning  The sum of a range may quickly exceeded the intermediate
            variable storage capacity for long ranges.
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
  // v1 a string
  : let( v2_is = is_string(v2) )
    is_string(v1) ?
    (
      (v2_nd || v2_in) ? -1
    : v2_is ?
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
      (v2_nd || v2_in || v2_is) ? -1
    : v2_ib ?
      (
        ((v1 == true)  && (v2 == false)) ? -1   // defined: true > false
      : ((v1 == false) && (v2 == true))  ? +1
      : 0
      )
    : 1 // others are greater
    )
  // v1 a vector
  : let( v2_iv = is_vector(v2) )
    is_vector(v1) ?
    (
      (v2_nd || v2_in || v2_is || v2_ib) ? -1
    : v2_iv ?
      (
        let
        (
          l1 = len(smerge(v1, true)),           // get total element count
          l2 = len(smerge(v2, true))
        )
        (l1 > l2) ? -1                          // longest vector is greater
      : (l2 > l1) ? +1
      : ((l1 == 0) && (l2 == 0)) ? 0            // reached end, are equal
      : let
        (
          cf = compare(first(v1), first(v2), s) // compare first elements
        )
        (cf != 0) ? cf                          // not equal, ordering determined
      : compare(tail(v1), tail(v2), s)          // equal, check remaining
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
      // compare range vectors
    : (
        let
        (
          rv1 = [for (i=v1) i],                 // convert to vectors
          rv2 = [for (i=v2) i],
          rl1 = len(rv1),                       // get lengths
          rl2 = len(rv2)
        )
        (rl1 > rl2) ? -1                        // longest range is greater
      : (rl2 > rl1) ? +1
      : compare(rv1, rv2, s)                    // equal so compare as vectors
      )
    )
  // v2 not a range so v1 > v2
  : -1;

//! @}
//! @}

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \page tv_prim_vector Vector Operations
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

//----------------------------------------------------------------------------//
// create / convert
//----------------------------------------------------------------------------//

//! Create a vector of constant elements.
/***************************************************************************//**
  \param    l <integer> The vector length.
  \param    v \<value> The element value.

  \returns  <vector> With \p l copies of the element value \p v.
            Returns \b empty_v when \p l is not a number or if
            <tt>(l < 1)</tt>.

  \details

  \note     When \p v is not specified, each element is assigned the value
            of its index position.
*******************************************************************************/
function consts
(
  l,
  v
) = (l<1) ? empty_v
  : !is_number(l) ? empty_v
  : is_defined(v) ? [for (i=[0:1:l-1]) v]
  : [for (i=[0:1:l-1]) i];

//! Convert all vector elements to strings and concatenate.
/***************************************************************************//**
  \param    v <vector> A vector of values.

  \returns  <string> Constructed by converting each element of the vector
            to a string and concatenating together.
            Returns \b undef when \p v is not defined.

  \details

    \b Example
    \code{.C}
    v1=["a", "b", "c", "d"];
    v2=[1, 2, 3];

    echo( vstr(concat(v1, v2)) );
    \endcode

    \b Result
    \code{.C}
    ECHO: "abcd123"
    \endcode
*******************************************************************************/
function vstr
(
  v
) = not_defined(v) ? undef
  : !is_iterable(v) ? str(v)
  : is_empty(v) ? empty_str
  : (len(v) == 1) ? str(first(v))
  : str(first(v), vstr(tail(v)));

//! Compute the sum of a vector of numbers.
/***************************************************************************//**
  \param    v <range|vector> A vector of numerical values.
  \param    i1 <integer> The element index at which to begin summation
            (first when not specified).
  \param    i2 <integer> The element index at which to end summation
            (last when not specified).

  \returns  <decimal> The summation of elements over the index range.
            Returns \b v when it is a scalar number.
            Returns 0 when \p v is empty.
            Returns \b undef when \p v is not defined or is not iterable
            and not a number.
*******************************************************************************/
function sum
(
  v,
  i1,
  i2
) = not_defined(v) ? undef
  : is_empty(v) ? 0
  : is_number(v) ? v
  : is_range(v) ? sum([for (i=v) i], i1, i2)
  : !is_iterable(v) ? undef
  : let
    (
      s = is_defined(i1) ? min(max(i1,0),len(v)-1) : 0,
      i = is_defined(i2) ? max(min(i2,len(v)-1),0) : len(v)-1
    )
    (i == s) ? v[i]
  : v[i] + sum(v, s, i-1);

//----------------------------------------------------------------------------//
// select
//----------------------------------------------------------------------------//

//! Return a defined or default value.
/***************************************************************************//**
  \param    v \<value> A value.
  \param    d \<value> A default value.

  \returns  \<value> \p v when it is defined or \p d otherwise.
*******************************************************************************/
function defined_or
(
  v,
  d
) = is_defined(v) ? v : d;

//! Return a defined vector element or default value.
/***************************************************************************//**
  \param    v <vector> A vector.
  \param    i <integer> An element index.
  \param    d \<value> A default value.

  \returns  \<value> <tt>v[i]</tt> when it is defined or \p d otherwise.
*******************************************************************************/
function edefined_or
(
  v,
  i,
  d
) = (len(v) > i) ? v[i] : d;

//! Return the first element of an iterable value.
/***************************************************************************//**
  \param    v \<value> An iterable value.

  \returns  \<value> The first element of \p v.
            Returns \b undef when \p v is not defined, is not iterable,
            or is empty.
*******************************************************************************/
function first
(
  v
) = !is_iterable(v) ? undef
  : v[0];

//! Return the last element of an iterable value.
/***************************************************************************//**
  \param    v \<value> An iterable value.

  \returns  \<value> The last element of \p v.
            Returns \b undef when \p v is not defined, is not iterable,
            or is empty.
*******************************************************************************/
function last
(
  v
) = not_defined(v) ? undef
  : !is_iterable(v) ? undef
  : is_empty(v) ? undef
  : v[len(v)-1];

//! Return a vector containing the first element of an iterable value.
/***************************************************************************//**
  \param    v \<value> An iterable value.

  \returns  <vector> Containing the first element of \p v.
            Returns \b undef when \p v is not defined, is not iterable,
            or is empty.
*******************************************************************************/
function head
(
  v
) = not_defined(v) ? undef
  : !is_iterable(v) ? undef
  : is_empty(v) ? undef
  : [first(v)];

//! Return a vector containing all but the first element of an iterable value.
/***************************************************************************//**
  \param    v \<value> An iterable value.

  \returns  <vector> Containing all but the first element of \p v.
            Returns \b empty_v when \p v contains a single element.
            Returns \b undef when \p v is not defined, is not iterable,
            or is empty.
*******************************************************************************/
function tail
(
  v
) = not_defined(v) ? undef
  : !is_iterable(v) ? undef
  : is_empty(v) ? undef
  : (len(v) == 1) ? empty_v
  : [for (i = [1 : len(v)-1]) v[i]];

//! Select a range of elements from an iterable value.
/***************************************************************************//**
  \param    v \<value> An iterable value.
  \param    i <range|vector|integer> Index selection.

  \returns  <vector> Containing the vector element indexes selected in \p i.
            Returns \b undef when \p i does not map to an element of \p v.
            Returns \b empty_v when \p v is empty.
            Returns \b undef when \p v is not defined or is not iterable.
*******************************************************************************/
function rselect
(
  v,
  i
) = !all_defined([v, i]) ? undef
  : !is_iterable(v) ? undef
  : is_empty(v) ? empty_v
  : is_number(i) && ((i<0) || (i>(len(v)-1))) ? undef
  : is_vector(i) && ((min([for (y=i) y])<0) || (max([for (y=i) y])>(len(v)-1))) ? undef
  : is_range(i) && ((min([for (y=i) y])<0) || (max([for (y=i) y])>(len(v)-1))) ? undef
  : let
    (
      s = is_number(i) ? [i] : i
    )
    [for (j = [for (k=s) k]) v[j]];

//! Select an element from each iterable value.
/***************************************************************************//**
  \param    v <vector> A vector of iterable values.
  \param    f <boolean> Select the first element.
  \param    l <boolean> Select the last element.
  \param    i <integer> Select a numeric element index position.

  \returns  <vector> Containing the selected element of each iterable value
            of \p v.
            Returns \b empty_v when \p v is empty.
            Returns \b undef when \p v is not defined or is not iterable.

  \details

  \note     When more than one selection criteria is specified, the
            order of precedence is: \p i, \p l, \p f.
*******************************************************************************/
function eselect
(
  v,
  f = true,
  l = false,
  i
) = not_defined(v) ? undef
  : !is_iterable(v) ? undef
  : is_empty(v) ? empty_v
  : is_defined(i) ? concat( [first(v)[i]], eselect(tail(v), f, l, i) )
  : (l == true) ? concat( [last(first(v))], eselect(tail(v), f, l, i) )
  : (f == true) ? concat( [first(first(v))], eselect(tail(v), f, l, i) )
  : undef;

//----------------------------------------------------------------------------//
// reorder
//----------------------------------------------------------------------------//

//! Serial-merge vectors of iterable values.
/***************************************************************************//**
  \param    v <vector> A vector of iterable values.
  \param    r <boolean> Recursively merge iterable elements.

  \returns  <vector> Containing the serial-wise element concatenation
            of each element in \p v.
            Returns \b empty_v when \p v is empty.
            Returns \b undef when \p v is not defined.

  \details

  \note     A string, although iterable, is treated as a merged unit.
*******************************************************************************/
function smerge
(
  v,
  r = false
) = not_defined(v) ? undef
  : !is_iterable(v) ? [v]
  : is_empty(v) ? empty_v
  : is_string(v) ? [v]
  : ((r == true) && is_iterable(first(v))) ?
    concat(smerge(first(v), r), smerge(tail(v), r))
  : concat(first(v), smerge(tail(v), r));

//! Parallel-merge vectors of iterable values.
/***************************************************************************//**
  \param    v <vector> A vector of iterable values.
  \param    j <boolean> Join each merge as a vector.

  \returns  <vector> Containing the parallel-wise element concatenation
            of each iterable value in \p v.
            Returns \b empty_v when any element value in \p v is empty.
            Returns \b undef when \p v is not defined or when any element
            value in \p v is not iterable.

  \details

    \b Example
    \code{.C}
    v1=["a", "b", "c", "d"];
    v2=[1, 2, 3];

    echo( pmerge( [v1, v2], true ) );
    echo( pmerge( [v1, v2], false ) );
    \endcode

    \b Result
    \code{.C}
    ECHO: [["a", 1], ["b", 2], ["c", 3]]
    ECHO: ["a", 1, "b", 2, "c", 3]
    \endcode

  \note     The resulting vector length will be limited by the iterable
            value with the shortest length.
  \note     A string, although iterable, is treated as a merged unit.
*******************************************************************************/
function pmerge
(
  v,
  j = true
) = not_defined(v) ? undef
  : !is_iterable(v) ? undef
  : is_empty(v) ? empty_v
  : is_string(v) ? [v]
  : let
    (
      l = [for (i = v) len(i)]          // element lengths
    )
    any_undefined(l) ? undef            // any element not iterable?
  : (min(l) == 0) ? empty_v             // any element empty?
  : let
    (
      h = [for (i = v) first(i)],
      t = [for (i = v) tail(i)]
    )
    (j == true) ? concat([h], pmerge(t, j))
  : concat(h, pmerge(t, j));

//! Reverse the elements of an iterable value.
/***************************************************************************//**
  \param    v \<value> An iterable value.

  \returns  <vector> Containing the elements of \p v in reversed order.
            Returns \b empty_v when \p v is empty.
            Returns \b undef when \p v is not defined or is not iterable.
*******************************************************************************/
function reverse
(
  v
) = not_defined(v) ? undef
  : !is_iterable(v) ? undef
  : is_empty(v) ? empty_v
  : [for (i = [len(v)-1 : -1 : 0]) v[i]];

//! Sort the numeric or string elements of a vector using quick sort.
/***************************************************************************//**
  \param    v <vector> A vector of values.
  \param    r <boolean> Reverse sort order.

  \returns  <vector> With elements sorted in ascending order.
            Returns \b undef when \p v is not all strings or all numbers.
            Returns \b undef when \p v is not defined or is not a vector.

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
  v,
  r = false
) = not_defined(v) ? undef
  : !is_vector(v) ? undef
  : is_empty(v) ? empty_v
  : !(all_strings(v) || all_numbers(v)) ? undef  // not all numbers or strings
  : let
    (
      mp = v[floor(len(v)/2)],

      lt = [for (i = v) if (i  < mp) i],
      eq = [for (i = v) if (i == mp) i],
      gt = [for (i = v) if (i  > mp) i]

    )
    (r == true) ? concat(qsort(gt, r), eq, qsort(lt, r))
  : concat(qsort(lt, r), eq, qsort(gt, r));

//! Hierarchically sort all elements of a vector using quick sort.
/***************************************************************************//**
  \param    v <vector> A vector of values.
  \param    d <integer> Recursive sort depth.
  \param    r <boolean> Reverse sort order.
  \param    s <boolean> Order ranges by their numerical sum.

  \returns  <vector> With all elements sorted in ascending order.
            Returns \b undef when \p v is not defined or is not a vector.

  \details

    Elements are sorted using the \ref compare function. See its documentation
    for a description of the parameter \p s. To recursively sort all elements,
    set \p d greater than, or equal to, the maximum level of hierarchy in
    \p v.

    See [Wikipedia](https://en.wikipedia.org/wiki/Quicksort)
    for more information.
*******************************************************************************/
function qsort2
(
  v,
  d = 0,
  r = false,
  s = true
) = not_defined(v) ? undef
  : !is_vector(v) ? undef
  : is_empty(v) ? empty_v
  : let
    (
      mp = v[floor(len(v)/2)],

      lt =
      [
        for (i = v)
          if (compare(mp, i, s) == -1)
            ((d > 0) && is_vector(i)) ? qsort2(i, d-1, r, s) : i
      ],
      eq =
      [
        for (i = v)
          if (compare(mp, i, s) ==  0)
            ((d > 0) && is_vector(i)) ? qsort2(i, d-1, r, s) : i
      ],
      gt =
      [
        for (i = v)
          if (compare(mp, i, s) == +1)
            ((d > 0) && is_vector(i)) ? qsort2(i, d-1, r, s) : i
      ]
    )
    (r == true) ? concat(qsort2(gt, d, r, s), eq, qsort2(lt, d, r, s))
  : concat(qsort2(lt, d, r, s), eq, qsort2(gt, d, r, s));

//----------------------------------------------------------------------------//
// grow / reduce
//----------------------------------------------------------------------------//

//! Strip all matching values from an iterable value.
/***************************************************************************//**
  \param    v <vector> A vector of values.
  \param    mv \<value> A match value.

  \returns  <vector> \p v with all elements equal to \p mv removed.
            Returns \b undef when \p v is not defined or is not iterable.
*******************************************************************************/
function strip
(
  v,
  mv = empty_v
) = not_defined(v) ? undef
  : !is_iterable(v) ? undef
  : is_empty(v) ? empty_v
  : (first(v) == mv) ? concat(strip(tail(v), mv))
  : concat(head(v), strip(tail(v), mv));

//! Append a value to each element of an iterable value.
/***************************************************************************//**
  \param    nv \<value> A new value to append.
  \param    v <vector> A vector of values.
  \param    r <boolean> Reduce vector element value before appending.
  \param    j <boolean> Join each appendage as a vector.
  \param    l <boolean> Append to last element.

  \returns  <vector> With \p nv appended to each element of \p v.
            Returns \b undef when \p v is not defined or is not iterable.

  \details

    \b Example
    \code{.C}
    v1=[["a"], ["b"], ["c"], ["d"]];
    v2=[1, 2, 3];

    echo( append( v2, v1 ) );
    echo( append( v2, v1, r=false ) );
    echo( append( v2, v1, j=false, l=false ) );
    \endcode

    \b Result
    \code{.C}
    ECHO: [["a", 1, 2, 3], ["b", 1, 2, 3], ["c", 1, 2, 3], ["d", 1, 2, 3]]
    ECHO: [[["a"], 1, 2, 3], [["b"], 1, 2, 3], [["c"], 1, 2, 3], [["d"], 1, 2, 3]]
    ECHO: ["a", 1, 2, 3, "b", 1, 2, 3, "c", 1, 2, 3, "d"]
    \endcode

  \note     Appending with reduction causes \p nv to be appended to the
            \e elements of each value of \p v that is a vector. Otherwise,
            \p nv is appended to the \e vector itself of each value of
            \p v that is a vector.
*******************************************************************************/
function append
(
  nv,
  v,
  r = true,
  j = true,
  l = true
) = not_defined(v) ? undef
  : !is_iterable(v) ? undef
  : is_empty(v) ? ((j == true) ? [concat(nv)] : concat(nv))
  : let
    (
      ce = (r == true) ? first(v) : head(v)
    )
    (len(v) == 1) ?
    (
      (j == true) ? (l == true) ? [concat(ce, nv)] : [ce]
      : (l == true) ? concat(ce, nv) : ce
    )
  : (j == true) ? concat([concat(ce, nv)], append(nv, tail(v), r, j, l))
  : concat(concat(ce, nv), append(nv, tail(v), r, j, l));

//! Insert a new value into an iterable value.
/***************************************************************************//**
  \param    nv \<value> A new value to insert.
  \param    v \<value> An iterable value.
  \param    i <integer> An index insert position.
  \param    mv <vector|string|value> Match value candidates
            (a vector of values, a string of characters, or a single value).
  \param    mi <integer> A match index.

  \returns  <vector> With \p nv inserted into \p v at the specified position.
            Returns \b undef when no value of \p mv exists in \p v.
            Returns \b undef when <tt>(mi + 1)</tt> exceeds the match count
            of the first matching element of \p mv.
            Returns \b undef when \p i does not map to an element of \p v.
            Returns \b undef when \p v is not defined or is not iterable.


  \details

  \note     The insert position can be specified by an index, an element
            match value, or vector of potential match values.
  \note     When \p mv is a vector of potential match values, the
            first matching value from \p mv that exists in \p v is selected.
  \note     When the selected matching value repeats in \p v, \p mi
            indicates which match is use as the insert position.
  \note     When more than one insert position criteria is specified, the
            order of precedence is: \p mv, \p i.
*******************************************************************************/
function insert
(
  nv,
  v,
  i = 0,
  mv,
  mi = 0
) = not_defined(v) ? undef
  : !is_iterable(v) ? undef
  : is_empty(v) ?
    (
      ( is_defined(mv) && any_equal(mv, empty_v)) ||
      (not_defined(mv) && (i == 0))
    ) ? concat(nv) : undef
  : ((i<0) || (i>len(v))) ? undef
  : let
    (
      m = is_string(v) ? mv : is_vector(mv) ? mv : [mv],
      p = is_defined(mv) ? first(strip(search(m, v, 0, 0)))[mi] : i,
      h = (p>0) ? [for (i = [0 : p-1]) v[i]] : empty_v,
      t = (p>len(v)-1) ? empty_v : [for (i = [p : len(v)-1]) v[i]]
    )
    all_equal([h, t], empty_v) ? undef : concat(h, nv, t);

//! Delete elements from an iterable value.
/***************************************************************************//**
  \param    v \<value> An iterable value.
  \param    i <range|vector|integer> Deletion Indexes.
  \param    mv <vector|string|value> Match value candidates
            (a vector of values, a string of characters, or a single value).
  \param    mc <integer> A match count.

  \returns  <vector> \p v with all specified element removed.
            Returns \b undef when \p i does not map to an element of \p v.
            Returns \b undef when \p v is not defined or is not iterable.

  \details

  \note     The elements to delete can be specified by an index position,
            a vector of index positions, an index range, an element match
            value, or a vector of element match values.
  \note     When \p mv is a vector of match values, all matching values
            from \p mv that exists in \p v are candidates for deletion.
            For each matching candidate, \p mc indicates the quantity to
            remove. If <tt>(mc == 0)</tt> all candidates are removed.
  \note     When more than one deletion criteria is specified, the
            order of precedence is: \p mv, \p i.
*******************************************************************************/
function delete
(
  v,
  i,
  mv,
  mc = 0
) = not_defined(v) ? undef
  : !is_iterable(v) ? undef
  : is_empty(v) ? empty_v
  : is_number(i) && ((i<0) || (i>(len(v)-1))) ? undef
  : is_vector(i) && ((min([for (y=i) y])<0) || (max([for (y=i) y])>(len(v)-1))) ? undef
  : is_range(i) && ((min([for (y=i) y])<0) || (max([for (y=i) y])>(len(v)-1))) ? undef
  : let
    (
      m = is_string(v) ? mv : is_vector(mv) ? mv : [mv],
      p = is_defined(mv) ?
        (
          (mc == 1) ? smerge(search(m, v, mc, 0), false)
          : smerge(search(m, v, mc, 0), false)
        )
        : is_number(i) ? [i]
        : is_vector(i) ? i
        : is_range(i) ? [for (y=i) y]
        : undef
    )
    [
      for (i = [0 : len(v)-1])
        if ( is_empty(first(search([i], p, 1, 0))) ) v[i]
    ];

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
        good_c = pmerge([concat("id", test_ids), concat("identifier", test_ids)]);

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
          ["is_string",   f, f, f, f, f, f, f, f, f, f, f, t, t, t, f, f, f, f, f, f, f],
          ["is_vector",   f, f, f, f, f, f, f, f, f, f, f, f, f, f, t, t, t, t, t, s, s],
          ["is_boolean",  f, f, f, f, f, f, f, f, f, t, t, f, f, f, f, f, f, f, f, f, f],
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
            else if ( show_passing )
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
        for (vid=test_ids) run_test( "is_string", is_string(get_value(vid)), vid );
        for (vid=test_ids) run_test( "is_vector", is_vector(get_value(vid)), vid );
        for (vid=test_ids) run_test( "is_boolean", is_boolean(get_value(vid)), vid );
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
        good_c = pmerge([concat("id", test_ids), concat("identifier", test_ids)]);

        // expected rows: ("golden" test results), use 's' to skip test
        t = true;   // shortcuts
        f = false;
        u = undef;
        s = -1;     // skip test

        good_r =
        [ // function         01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23
          ["all_equal_T",     f, f, t, f, f, f, t, t, f, f, f, f, f, f, f, f, f, f, f, f, f, f, t],
          ["all_equal_F",     f, f, f, t, f, f, t, t, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f],
          ["all_equal_U",     t, f, f, f, f, f, t, t, f, f, t, f, f, f, f, f, f, f, t, f, f, f, f],
          ["any_equal_T",     f, f, t, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, t, t, t],
          ["any_equal_F",     f, f, f, t, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, t, t, f],
          ["any_equal_U",     t, f, f, f, f, f, f, f, f, f, t, f, f, f, f, f, f, t, t, f, f, f, f],
          ["all_defined",     f, t, t, t, t, t, t, t, t, t, f, t, t, t, t, t, t, f, f, t, t, t, t],
          ["any_undefined",   t, f, f, f, f, f, f, f, f, f, t, f, f, f, f, f, f, t, t, f, f, f, f],
          ["all_scalars",     u, t, t, t, f, f, s, s, s, s, t, t, t, f, f, f, f, t, t, f, t, t, t],
          ["all_vectors",     u, f, f, f, f, f, t, t, f, f, f, f, f, t, t, f, t, f, f, t, f, f, f],
          ["all_strings",     u, f, f, f, t, t, t, s, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f],
          ["all_numbers",     u, t, f, f, f, f, s, s, f, f, f, t, t, f, f, f, f, f, f, f, f, f, f],
          ["all_len_1",       u, f, f, f, t, t, s, s, f, f, f, f, f, t, f, f, f, f, f, t, f, f, f],
          ["all_len_2",       u, f, f, f, f, f, s, s, f, f, f, f, f, f, t, t, f, f, f, f, f, f, f],
          ["all_len_3",       u, f, f, f, f, f, s, s, f, f, f, f, f, f, f, f, t, f, f, f, f, f, f],
          ["almost_equal_AA", t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t],
          ["almost_equal_T",  f, f, t, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f],
          ["almost_equal_F",  f, f, f, t, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f],
          ["almost_equal_U",  t, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f, f],
          ["compare_AA",      t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t, t]
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
        for (vid=test_ids) run_test( "all_vectors", all_vectors(get_value(vid)), vid );
        for (vid=test_ids) run_test( "all_strings", all_strings(get_value(vid)), vid );
        for (vid=test_ids) run_test( "all_numbers", all_numbers(get_value(vid)), vid );
        for (vid=test_ids) run_test( "all_len_1", all_len(get_value(vid),1), vid );
        for (vid=test_ids) run_test( "all_len_2", all_len(get_value(vid),2), vid );
        for (vid=test_ids) run_test( "all_len_3", all_len(get_value(vid),3), vid );
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
  END_SCOPE;

  BEGIN_SCOPE vector;
    BEGIN_OPENSCAD;
      include <primitives.scad>;
      use <table.scad>;
      use <console.scad>;
      use <validation.scad>;

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
      good_c = pmerge([concat("id", test_ids), concat("identifier", test_ids)]);

      // expected rows: ("golden" test results), use 's' to skip test
      skip = -1;  // skip test

      good_r =
      [ // function
        ["consts",
          empty_v,                                            // t01
          empty_v,                                            // t02
          empty_v,                                            // t03
          empty_v,                                            // t04
          empty_v,                                            // t05
          empty_v,                                            // t06
          empty_v,                                            // t07
          empty_v,                                            // t08
          empty_v,                                            // t09
          empty_v,                                            // t10
          empty_v                                             // t11
        ],
        ["vstr",
          undef,                                              // t01
          empty_str,                                          // t02
          "[0 : 0.5 : 9]",                                    // t03
          "A string",                                         // t04
          "orangeapplegrapebanana",                           // t05
          "bananas",                                          // t06
          "undef",                                            // t07
          "[1, 2][2, 3]",                                     // t08
          "ab[1, 2][2, 3][4, 5]",                             // t09
          "[1, 2, 3][4, 5, 6][7, 8, 9][\"a\", \"b\", \"c\"]", // t10
          "0123456789101112131415"                            // t11
        ],
        ["sum",
          undef,                                              // t01
          0,                                                  // t02
          85.5,                                               // t03
          undef,                                              // t04
          undef,                                              // t05
          undef,                                              // t06
          undef,                                              // t07
          [3,5],                                              // t08
          undef,                                              // t09
          [undef,undef,undef],                                // t10
          120                                                 // t11
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
        ],
        ["first",
          undef,                                              // t01
          undef,                                              // t02
          undef,                                              // t03
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
          undef,                                              // t03
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
          undef,                                              // t03
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
          undef,                                              // t03
          [" ","s","t","r","i","n","g"],                      // t04
          ["apple","grape","banana"],                         // t05
          ["a","n","a","n","a","s"],                          // t06
          empty_v,                                            // t07
          [[2,3]],                                            // t08
          [[1,2],[2,3],[4,5]],                                // t09
          [[4,5,6],[7,8,9],["a","b","c"]],                    // t10
          [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]               // t11
        ],
        ["rselect_02",
          undef,                                              // t01
          empty_v,                                            // t02
          undef,                                              // t03
          ["A"," ","s"],                                      // t04
          ["orange","apple","grape"],                         // t05
          ["b","a","n"],                                      // t06
          undef,                                              // t07
          undef,                                              // t08
          ["ab",[1,2],[2,3]],                                 // t09
          [[1,2,3],[4,5,6],[7,8,9]],                          // t10
          [0,1,2]                                             // t11
        ],
        ["eselect_F",
          undef,                                              // t01
          empty_v,                                            // t02
          undef,                                              // t03
          ["A"," ","s","t","r","i","n","g"],                  // t04
          ["o","a","g","b"],                                  // t05
          ["b","a","n","a","n","a","s"],                      // t06
          [undef],                                            // t07
          [1,2],                                              // t08
          ["a",1,2,4],                                        // t09
          [1,4,7,"a"],                                        // t10
          skip                                                // t11
        ],
        ["eselect_L",
          undef,                                              // t01
          empty_v,                                            // t02
          undef,                                              // t03
          ["A"," ","s","t","r","i","n","g"],                  // t04
          ["e","e","e","a"],                                  // t05
          ["b","a","n","a","n","a","s"],                      // t06
          [undef],                                            // t07
          [2,3],                                              // t08
          ["b",2,3,5],                                        // t09
          [3,6,9,"c"],                                        // t10
          skip                                                // t11
        ],
        ["eselect_1",
          undef,                                              // t01
          empty_v,                                            // t02
          undef,                                              // t03
          skip,                                               // t04
          ["r","p","r","a"],                                  // t05
          skip,                                               // t06
          [undef],                                            // t07
          [2,3],                                              // t08
          ["b",2,3,5],                                        // t09
          [2,5,8,"b"],                                        // t10
          skip                                                // t11
        ],
        ["smerge",
          undef,                                              // t01
          empty_v,                                            // t02
          [[0:0.5:9]],                                        // t03
          ["A string"],                                       // t04
          ["orange","apple","grape","banana"],                // t05
          ["b","a","n","a","n","a","s"],                      // t06
          [undef],                                            // t07
          [1,2,2,3],                                          // t08
          ["ab",1,2,2,3,4,5],                                 // t09
          [1,2,3,4,5,6,7,8,9,"a","b","c"],                    // t10
          [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]             // t11
        ],
        ["pmerge",
          undef,                                              // t01
          empty_v,                                            // t02
          undef,                                              // t03
          ["A string"],                                       // t04
          [
            ["o","a","g","b"],["r","p","r","a"],
            ["a","p","a","n"],["n","l","p","a"],
            ["g","e","e","n"]
          ],                                                  // t05
          [["b","a","n","a","n","a","s"]],                    // t06
          undef,                                              // t07
          [[1,2],[2,3]],                                      // t08
          [["a",1,2,4],["b",2,3,5]],                          // t09
          [[1,4,7,"a"],[2,5,8,"b"],[3,6,9,"c"]],              // t10
          undef                                               // t11
        ],
        ["reverse",
          undef,                                              // t01
          empty_v,                                            // t02
          undef,                                              // t03
          ["g","n","i","r","t","s"," ","A"],                  // t04
          ["banana","grape","apple","orange"],                // t05
          ["s","a","n","a","n","a","b"],                      // t06
          [undef],                                            // t07
          [[2,3],[1,2]],                                      // t08
          [[4,5],[2,3],[1,2],"ab"],                           // t09
          [["a","b","c"],[7,8,9],[4,5,6],[1,2,3]],            // t10
          [15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0]             // t11
        ],
        ["qsort",
          undef,                                              // t01
          empty_v,                                            // t02
          undef,                                              // t03
          undef,                                              // t04
          ["apple","banana","grape","orange"],                // t05
          ["a","a","a","b","n","n","s"],                      // t06
          undef,                                              // t07
          undef,                                              // t08
          undef,                                              // t09
          undef,                                              // t10
          [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]             // t11
        ],
        ["qsort2_HR",
          undef,                                              // t01
          empty_v,                                            // t02
          undef,                                              // t03
          undef,                                              // t04
          ["orange","grape","banana","apple"],                // t05
          ["s","n","n","b","a","a","a"],                      // t06
          [undef],                                            // t07
          [[3,2],[2,1]],                                      // t08
          [[5,4],[3,2],[2,1],"ab"],                           // t09
          [["c","b","a"],[9,8,7],[6,5,4],[3,2,1]],            // t10
          [15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0]             // t11
        ],
        ["strip",
          undef,                                              // t01
          empty_v,                                            // t02
          undef,                                              // t03
          ["A"," ","s","t","r","i","n","g"],                  // t04
          ["orange","apple","grape","banana"],                // t05
          ["b","a","n","a","n","a","s"],                      // t06
          [undef],                                            // t07
          [[1,2],[2,3]],                                      // t08
          ["ab",[1,2],[2,3],[4,5]],                           // t09
          [[1,2,3],[4,5,6],[7,8,9],["a","b","c"]],            // t10
          [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]             // t11
        ],
        ["append_T0",
          undef,                                              // t01
          [[0]],                                              // t02
          undef,                                              // t03
          [
            ["A",0],[" ",0],["s",0],["t",0],
            ["r",0],["i",0],["n",0],["g",0]
          ],                                                  // t04
          [
            ["orange",0],["apple",0],
            ["grape",0],["banana",0]
          ],                                                  // t05
          [
            ["b",0],["a",0],["n",0],["a",0],
            ["n",0],["a",0],["s",0]
          ],                                                  // t06
          [[undef,0]],                                        // t07
          [[1,2,0],[2,3,0]],                                  // t08
          [["ab",0],[1,2,0],[2,3,0],[4,5,0]],                 // t09
          [[1,2,3,0],[4,5,6,0],[7,8,9,0],["a","b","c",0]],    // t10
          [
            [0,0],[1,0],[2,0],[3,0],[4,0],[5,0],
            [6,0],[7,0],[8,0],[9,0],[10,0],[11,0],
            [12,0],[13,0],[14,0],[15,0]
          ]                                                   // t11
        ],
        ["insert_T0",
          undef,                                              // t01
          undef,                                              // t02
          undef,                                              // t03
          undef,                                              // t04
          ["orange",0,"apple","grape","banana"],              // t05
          ["b","a","n","a","n","a",0,"s"],                    // t06
          undef,                                              // t07
          [[1,2],0,[2,3]],                                    // t08
          ["ab",[1,2],0,[2,3],[4,5]],                         // t09
          undef,                                              // t10
          [0,1,2,3,4,0,5,6,7,8,9,10,11,12,13,14,15]           // t11
        ],
        ["delete_T0",
          undef,                                              // t01
          empty_v,                                            // t02
          undef,                                              // t03
          ["A"," ","s","t","r","i","n","g"],                  // t04
          ["orange","grape","banana"],                        // t05
          ["b","a","n","a","n","a"],                          // t06
          [undef],                                            // t07
          [[1,2]],                                            // t08
          ["ab",[1,2],[4,5]],                                 // t09
          [[1,2,3],[4,5,6],[7,8,9],["a","b","c"]],            // t10
          [0,1,2,3,4,6,7,8,9,10,11,12,13,14,15]               // t11
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

        test_pass = validate( cv=fresult, t="equals", ev=pass_value, pf=true );
        test_text = validate( str(fname, "(", get_value(vid), ")=", pass_value), fresult, "equals", pass_value );

        if ( pass_value != skip )
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
      for (vid=test_ids) run_test( "consts", consts(get_value(vid)), vid );
      for (vid=test_ids) run_test( "vstr", vstr(get_value(vid)), vid );
      for (vid=test_ids) run_test( "sum", sum(get_value(vid)), vid );
      for (vid=test_ids) run_test( "defined_or_D", defined_or(get_value(vid),"default"), vid );
      for (vid=test_ids) run_test( "edefined_or_DE3", edefined_or(get_value(vid),3,"default"), vid );
      for (vid=test_ids) run_test( "first", first(get_value(vid)), vid );
      for (vid=test_ids) run_test( "last", last(get_value(vid)), vid );
      for (vid=test_ids) run_test( "head", head(get_value(vid)), vid );
      for (vid=test_ids) run_test( "tail", tail(get_value(vid)), vid );
      for (vid=test_ids) run_test( "rselect_02", rselect(get_value(vid),i=[0:2]), vid );
      for (vid=test_ids) run_test( "eselect_F", eselect(get_value(vid),f=true), vid );
      for (vid=test_ids) run_test( "eselect_L", eselect(get_value(vid),l=true), vid );
      for (vid=test_ids) run_test( "eselect_1", eselect(get_value(vid),i=1), vid );
      for (vid=test_ids) run_test( "smerge", smerge(get_value(vid)), vid );
      for (vid=test_ids) run_test( "pmerge", pmerge(get_value(vid)), vid );
      for (vid=test_ids) run_test( "reverse", reverse(get_value(vid)), vid );
      for (vid=test_ids) run_test( "qsort", qsort(get_value(vid)), vid );
      for (vid=test_ids) run_test( "qsort2_HR", qsort2(get_value(vid), d=5, r=true), vid );
      for (vid=test_ids) run_test( "strip", strip(get_value(vid)), vid );
      for (vid=test_ids) run_test( "append_T0", append(0,get_value(vid)), vid );
      for (vid=test_ids) run_test( "insert_T0", insert(0,get_value(vid),mv=["x","r","apple","s",[2,3],5]), vid );
      for (vid=test_ids) run_test( "delete_T0", delete(get_value(vid),mv=["x","r","apple","s",[2,3],5]), vid );

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
