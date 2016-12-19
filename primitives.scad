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
  \addtogroup math
  @{

  \defgroup prim_test General Tests
  \brief    Numerical property test primitives.
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
            and \b false otherwise. Returns \b true for \b empty_v.
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
            and \b false otherwise. Returns \b false for \b empty_v.
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
  \returns  <boolean> \b true when no vector element equals \p undef
            and \b false otherwise.
*******************************************************************************/
function all_defined(v) = !any_equal(v, undef);

//! Test if any vector element is undefined.
/***************************************************************************//**
  \param    v <vector> A vector.
  \returns  <boolean> \b true when any vector element equals \p undef
            and \b false otherwise.
*******************************************************************************/
function any_undefined(v) = any_equal(v, undef);

//! @}
//! @}

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \addtogroup math
  @{

  \defgroup prim_vector Vector Operations
  \brief    Vector operation primitives.
  @{
*******************************************************************************/
//----------------------------------------------------------------------------//

//! Return the first element of a vector.
/***************************************************************************//**
  \param    v <vector> A vector.
  \returns  The first element of the vector.
            Returns \b undef when \p v is not defined, is not a vector,
            or is empty.
*******************************************************************************/
function first
(
  v
) = v[0];

//! Return the last element of a vector.
/***************************************************************************//**
  \param    v <vector> A vector.
  \returns  The last element of the vector.
            Returns \b undef when \p v is not defined, is not a vector,
            or is empty.
*******************************************************************************/
function last
(
  v
) = not_defined(v) ? undef
  : !is_vector(v) ? undef
  : is_empty(v) ? undef
  : v[len(v)-1];

//! Return a new vector containing the first element of a vector.
/***************************************************************************//**
  \param    v <vector> A vector.
  \returns  A new vector containing the first element of the vector.
            Returns \b undef when \p v is not defined, is not a vector,
            or is empty.
*******************************************************************************/
function head
(
  v
) = not_defined(v) ? undef
  : !is_vector(v) ? undef
  : is_empty(v) ? undef
  : [first(v)];

//! Return a new vector containing all but the first element of a vector.
/***************************************************************************//**
  \param    v <vector> A vector.
  \returns  A new vector containing all but the first element of the vector.
            Returns \b undef when \p v is not defined, is not a vector,
            or is empty.
*******************************************************************************/
function tail
(
  v
) = not_defined(v) ? undef
  : !is_vector(v) ? undef
  : is_empty(v) ? undef
  : (len(v) == 1) ? empty_v
  : [for (i = [1 : len(v)-1]) v[i]];

//! Return a copy of a vector with its elements in reverse order.
/***************************************************************************//**
  \param    v <vector> A vector.
  \returns  A copy of the vector with its elements in reversed order.
            Returns \b undef when \p v is not defined or is not a vector.
*******************************************************************************/
function reverse
(
  v
) = not_defined(v) ? undef
  : !is_vector(v) ? undef
  : is_empty(v) ? empty_v
  : concat( reverse(tail(v)), head(v) );

//! Return a new vector containing a select element of a vector of vectors.
/***************************************************************************//**
  \param    v <vector> A vector.
  \param    f <boolean> Select each vectors first element.
  \param    l <boolean> Select each vectors last element.
  \param    e <integer> A vector element index selection.
  \returns  A new vector composed by choosing the selected element from
            each member-vector of the given vector \p v.
            Returns \b undef when \p v is not defined or is not a vector.

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
) = not_defined(v) ? undef
  : !is_vector(v) ? undef
  : is_empty(v) ? empty_v
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
) = is_empty(v) ? empty_v
  : (min([for (i = v) len(i)]) == 0) ? empty_v
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
) = not_defined(v) ? undef
  : !is_vector(v) ? undef
  : is_empty(v) ? empty_str
  : (len(v) == 1) ? str(first(v))
  : str(first(v), estr(tail(v)));

//! Sort the elements of a vector using the quick sort method.
/***************************************************************************//**
  \param    v <vector> A vector.
  \returns  A new vector with element sorted in ascending order.

  \details

  \warning This implementation relies on the OpenSCAD comparison operators
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
) = is_empty(v) ? empty_v
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
*******************************************************************************/
function ersum
(
  v,
  e,
  b=0
) = (e == b) ? v[e]
  : v[e] + ersum(v, e-1, b);

//! Compute the sum of all of the vector elements.
/***************************************************************************//**
  \param    v <vector> A vector of numerical values.
  \returns  <decimal> The summation of all of the vector elements.
*******************************************************************************/
function esum
(
  v
) = ersum( v, len( v ) - 1, 0);

//! Value defined or default operation.
/***************************************************************************//**
  \param    v <value> A value.
  \param    d <value> A default value.
  \returns  The value \p v when it is defined
            or the value \p d otherwise.
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
// end of file
//----------------------------------------------------------------------------//
