//! Mathematical functions.
/***************************************************************************//**
  \file   math.scad
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

  \ingroup math math_test math_vec_ops math_vec_comp math_ngon math_triangle
*******************************************************************************/

include <constants.scad>;

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \addtogroup math
  @{

  \defgroup math_test General Tests
  \brief    General numerical property tests.
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
*******************************************************************************/
function is_even( v ) = ( ((v % 2) == 0) ? true : false );

//! Test if a numerical value is odd.
/***************************************************************************//**
  \param    v <value> A numerical value.
  \returns  <boolean> \b true when the number is determined to be odd
            and \b false otherwise.
*******************************************************************************/
function is_odd( v ) = ( ((v % 2) == 0) ? false : true );

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

  \defgroup math_vec_ops Vector Operations
  \brief    Common vector operations.
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
/***************************************************************************//**
  \addtogroup math
  @{

  \defgroup math_vec_comp Point, Vector and Plane
  \brief    Point, vector, and plane computations.
  @{
*******************************************************************************/
//----------------------------------------------------------------------------//

//! Compute the distance between two points in a Euclidean 1, 2, or 3D-space.
/***************************************************************************//**
  \param    x <vector> A 1, 2, or 3-tuple vector of values.
  \param    y <vector> A 1, 2, or 3-tuple vector of values.
  \returns  <decimal> The distance between two points. Returns \b 'undef'
            when x and y do not have same number of terms and for n-tuple
            with n>3.
*******************************************************************************/
function distance_p2p
(
  x,
  y
) = ( len(x) + len(y) ) == 2 ?
      abs
      (
        x[0] - y[0]
      )
  : ( len(x) + len(y) ) == 4 ?
      sqrt
      (
          (x[0] - y[0]) * (x[0] - y[0])
        + (x[1] - y[1]) * (x[1] - y[1])
      )
  : ( len(x) + len(y) ) == 6 ?
      sqrt
      (
          (x[0] - y[0]) * (x[0] - y[0])
        + (x[1] - y[1]) * (x[1] - y[1])
        + (x[2] - y[2]) * (x[2] - y[2])
      )
  : undef ;

//! Compute the dot product of two vectors.
/***************************************************************************//**
  \param    v1t <vector> Vector 1 head. An n-tuple vector of values.
  \param    v1i <vector> Vector 1 tail. An n-tuple vector of values.
  \param    v2t <vector> Vector 2 head. An n-tuple vector of values.
  \param    v2i <vector> Vector 2 tail. An n-tuple vector of values.
  \returns  <decimal> The dot product of the two vectors. Returns \b 'undef'
            when vector coordinates do not have same number of terms, n.

  \details

    See [Wikipedia](https://en.wikipedia.org/wiki/Dot_product)
    for more information.
*******************************************************************************/
function dot_pp2pp
(
  v1t,
  v1i,
  v2t,
  v2i
) = ((v1t-v1i) * (v2t-v2i));

//! Compute the dot product of two vectors.
/***************************************************************************//**
  \param    v1 <vector> Vector 1 head. An n-tuple vector of values.
  \param    v2 <vector> Vector 2 head. An n-tuple vector of values.
  \returns  <decimal> The dot product of the two vectors. Returns \b 'undef'
            when vector coordinates do not have same number of terms, n.

  \details

    Vector tails at origin.
*******************************************************************************/
function dot_p2p
(
  v1,
  v2
) = (v1 * v2);

//! Compute the cross product (determinant) of two vectors in a Euclidean 3D-space (2D).
/***************************************************************************//**
  \param    v1t <vector> Vector 1 head. A 2 or 3-tuple vector of values.
  \param    v1i <vector> Vector 1 tail. A 2 or 3-tuple vector of values.
  \param    v2t <vector> Vector 2 head. A 2 or 3-tuple vector of values.
  \param    v2i <vector> Vector 2 tail. A 2 or 3-tuple vector of values.
  \returns  <decimal> The dot product of the two vectors. Returns \b 'undef'
            when vector coordinates do not have same number of terms, n.

  \details

    See Wikipedia [cross](https://en.wikipedia.org/wiki/Cross_product)
    and [determinant] (https://en.wikipedia.org/wiki/Determinant)
    for more information.

  \note Although the cross product of two vectors is defined only in 3D
        space, this function will return the 2x2 determinant for a 2D
        vector.

  \internal
    The support of 2D vectors by the OpenSCAD \c cross() functions is not
    documented in the OpenSCAD manual. Its behavior could change in the
    future.
  \endinternal
*******************************************************************************/
function cross_pp2pp
(
  v1t,
  v1i,
  v2t,
  v2i
) = cross((v1t-v1i), (v2t-v2i));

//! Compute the cross product (determinant) of two vectors in a Euclidean 3D-space (2D).
/***************************************************************************//**
  \param    v1 <vector> Vector 1 head. A 2 or 3-tuple vector of values.
  \param    v2 <vector> Vector 2 head. A 2 or 3-tuple vector of values.
  \returns  <decimal> The dot product of the two vectors. Returns \b 'undef'
            when vector coordinates do not have same number of terms, n.

  \details

    Vector tails at origin.
*******************************************************************************/
function cross_p2p
(
  v1,
  v2
) = cross(v1, v2);

//! Compute scalar triple product of two vectors in a Euclidean 2 or 3D-space.
/***************************************************************************//**
  \param    v1t <vector> Vector 1 head. A 2 or 3-tuple vector of values.
  \param    v1i <vector> Vector 1 tail. A 2 or 3-tuple vector of values.
  \param    v2t <vector> Vector 2 head. A 2 or 3-tuple vector of values.
  \param    v2i <vector> Vector 2 tail. A 2 or 3-tuple vector of values.
  \param    v3t <vector> Vector 3 head. A 2 or 3-tuple vector of values.
  \param    v3i <vector> Vector 3 tail. A 2 or 3-tuple vector of values.
  \returns  <decimal> The scalar triple product of the three vectors.
            Returns \b 'undef' when vector coordinates do not have same
            number of terms, n.

  \details

    [v1, v2, v3] = v1 * (v2 x v3)

    See [Wikipedia] (https://en.wikipedia.org/wiki/Triple_product)
    for more information.
*******************************************************************************/
function striple_pp2pp
(
  v1t,
  v1i,
  v2t,
  v2i,
  v3t,
  v3i
) = len(v1t) + len(v1i) + len(v2t) + len(v2i) + len(v3t) + len(v3i) == 12 ?
      dot_pp2pp
      (
        v1t=v1t,
        v1i=v1i,
        v2t=cross_pp2pp( v1t=v2t, v1i=v2i, v2t=v3t, v2i=v3i ),
        v2i=0
      )
  : len(v1t) + len(v1i) + len(v2t) + len(v2i) + len(v3t) + len(v3i) == 18 ?
      dot_pp2pp
      (
        v1t=v1t,
        v1i=v1i,
        v2t=cross_pp2pp( v1t=v2t, v1i=v2i, v2t=v3t, v2i=v3i ),
        v2i=[0,0,0]
      )
  : undef ;

//! Compute the cross product (determinant) of two vectors in a Euclidean 3D-space (2D).
/***************************************************************************//**
  \param    v1 <vector> Vector 1 head. A 2 or 3-tuple vector of values.
  \param    v2 <vector> Vector 2 head. A 2 or 3-tuple vector of values.
  \param    v3 <vector> Vector 3 head. A 2 or 3-tuple vector of values.
  \returns  <decimal> The scalar triple product of the three vectors.
            Returns \b 'undef' when vector coordinates do not have same
            number of terms, n.

  \details

    Vector tails at origin.
*******************************************************************************/
function striple_p2p
(
  v1,
  v2,
  v3
) = len(v1) + len(v2) + len(v2) == 6 ?
      striple_pp2pp
      (
        v1t=v1,
        v1i=[0,0],
        v2t=v2,
        v2i=[0,0],
        v3t=v3,
        v3i=[0,0]
      )
  : len(v1) + len(v2)+ len(v2)  == 9 ?
      striple_pp2pp
      (
        v1t=v1,
        v1i=[0,0,0],
        v2t=v2,
        v2i=[0,0,0],
        v3t=v3,
        v3i=[0,0,0]
      )
  : undef ;

//! Compute the angle between two vectors in a Euclidean 2 or 3D-space.
/***************************************************************************//**
  \param    v1t <vector> Vector 1 head. A 2 or 3-tuple vector of values.
  \param    v1i <vector> Vector 1 tail. A 2 or 3-tuple vector of values.
  \param    v2t <vector> Vector 2 head. A 2 or 3-tuple vector of values.
  \param    v2i <vector> Vector 2 tail. A 2 or 3-tuple vector of values.
  \param    nt <vector> Normal vector head. A 3-tuple vector of values.
  \param    ni <vector> Normal vector tail. A 3-tuple vector of values.
  \returns  <decimal> The angle between the two vectors. Returns \b 'undef'
            when vector coordinates do not have same number of terms or when
            the vectors do not intersect.

  \details

  \note For 3D vectors, a normal vector \p n is required to identify
        the perpendicular plane and axis of rotation for for two vectors.
*******************************************************************************/
function angle_pp2pp
(
  v1t,
  v1i,
  v2t,
  v2i,
  nt,
  ni
) = len(v1t) + len(v1i) + len(v2t) + len(v2i) == 8 ?
      atan2
      (
        cross_pp2pp( v1t=v1t, v1i=v1i, v2t=v2t, v2i=v2i ),
        dot_pp2pp( v1t=v1t, v1i=v1i, v2t=v2t, v2i=v2i )
      )
  : len(v1t) + len(v1i) + len(v2t) + len(v2i) == 12 ?
      atan2
      (
        cross_pp2pp( v1t=v1t, v1i=v1i, v2t=v2t, v2i=v2i ),
        dot_pp2pp( v1t=v1t, v1i=v1i, v2t=v2t, v2i=v2i )
      )
  : undef ;

//! Compute the angle between two vectors in a Euclidean 2 or 3D-space.
/***************************************************************************//**
  \param    v1 <vector> Vector 1 head. A 2 or 3-tuple vector of values.
  \param    v2 <vector> Vector 2 head. A 2 or 3-tuple vector of values.
  \param    n <vector> Normal vector head. A 3-tuple vector of values.
  \returns  <decimal> The angle between the two vectors. Returns \b 'undef'
            when vector coordinates do not have same number of terms or when
            the vectors do not intersect.

  \details

    Vector tails at origin.

  \note For 3D vectors, a normal vector \p n is required to identify
        the perpendicular plane and axis of rotation for for two vectors.
*******************************************************************************/
function angle_p2p
(
  v1,
  v2,
  n
) = len(v1) + len(v2) == 4 ?
      angle_pp2pp( v1t=v1, v1i=[0,0], v2t=v2, v2i=[0,0] )
  : len(v1) + len(v2) == 6 ?
      angle_pp2pp( v1t=v1, v1i=[0,0,0], v2t=v2, v2i=[0,0,0], nt=n, ni=[0,0,0] )
  : undef ;

//! Compute the unit vector for a 1, 2, or 3 term vector.
/***************************************************************************//**
  \param    vt <vector> Vector head. A 1, 2, or 3-tuple vector of values.
  \param    vi <vector> Vector tail. A 1, 2, or 3-tuple vector of values.
  \returns  <vector> The vector normalized to the unit-vector.
            Returns \b 'undef' when vector coordinates do not have same number
            of terms or for n-tuple with n>3.
*******************************************************************************/
function normalized_pp
(
  vt,
  vi
) = (vt-vi) / distance_p2p(vt, vi);

//! Compute the unit vector for a 1, 2, or 3 term vector.
/***************************************************************************//**
  \param    v <vector> Vector head. A 1, 2, or 3-tuple vector of values.
  \returns  <vector> The vector normalized to the unit-vector.
            Returns \b 'undef' for n-tuple with n>3.

  \details

    Vector tail assumed to be at origin.
*******************************************************************************/
function normalized_p
(
  v
) = len(v) == 1 ? sign( v[0] )
  : len(v) == 2 ? normalized_pp( vt=v, vi=[0,0] )
  : len(v) == 3 ? normalized_pp( vt=v, vi=[0,0,0] )
  : undef ;

//! Test if three vectors are coplanar in Euclidean 3D-space.
/***************************************************************************//**
  \param    v1t <vector> Vector 1 head. A 3-tuple vector of values.
  \param    v1i <vector> Vector 1 tail. A 3-tuple vector of values.
  \param    v2t <vector> Vector 2 head. A 3-tuple vector of values.
  \param    v2i <vector> Vector 2 tail. A 3-tuple vector of values.
  \param    v3t <vector> Vector 3 head. A 3-tuple vector of values.
  \param    v3i <vector> Vector 3 tail. A 3-tuple vector of values.
  \returns  <boolean> \b true when all three vectors are coplanar,
            and \b false otherwise.
  \details

    See [Wikipedia] (https://en.wikipedia.org/wiki/Coplanarity)
    for more information.

  \note When unspecified, vector initiate at the origin. In order for the
        vectors to be coplanar, they must all be within the same plane.
        This function can also be used to test if vectors are in a plane
        that is parallel to a coplanar plane by using non-zero vector
        tails.
*******************************************************************************/
function are_coplanar
(
  v1t,
  v1i,
  v2t,
  v2i,
  v3t,
  v3i
) = ( dot_pp2pp
      (
        v1t=v1t,
        v1i=(v1i == undef) ? [0,0,0] : v1i,
        v2t=cross_pp2pp
            (
              v1t=v2t,
              v1i=(v2i == undef) ? [0,0,0] : v2i,
              v2t=v3t,
              v2i=(v3i == undef) ? [0,0,0] : v3i
            ),
        v2i=[0,0,0]
      ) == 0
    );

//! @}
//! @}

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \addtogroup math
  @{

  \defgroup math_ngon n-gon Solutions
  \brief    Regular n-sided polygon computations.
  @{
*******************************************************************************/
//----------------------------------------------------------------------------//

//! Compute the vertices for an n-sided equiangular/equilateral regular polygon.
/***************************************************************************//**
  \param    n <decimal> The number of sides.
  \param    r <decimal> The ngon vertex radius.
  \param    vr <decimal> The vertex rounding radius.
  \returns  <vector> A vector [v1, v2, ..., vn] of vectors [x, y] of decimal
            vertex coordinates.

    \b Example
    \code{.C}
    vr=5;

    hull()
    {
      for ( p = ngon_vp( r=20, n=5, vr=vr ) )
        translate( p )
        circle( r=vr );
    }
    \endcode
*******************************************************************************/
function ngon_vp
(
  n,
  r,
  vr
) =
[
  for ( a = [0:(360/n):359] )
    let( v = [r*cos(a), r*sin(a)] )
    (vr == undef) ? v : v - vr/cos(180/n) * normalized_p(v=v)
];

//! @}
//! @}

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \addtogroup math
  @{

  \defgroup math_triangle Triangle Solutions
  \brief    Triangle computations.

  \details

    See [Wikipedia](https://en.wikipedia.org/wiki/Triangle)
    for more information.

  @{
*******************************************************************************/
//----------------------------------------------------------------------------//

//! Compute the vertices of a plane triangle given its side lengths.
/***************************************************************************//**
  \param    s1 <decimal> The length of the side 1.
  \param    s2 <decimal> The length of the side 2.
  \param    s3 <decimal> The length of the side 3.
  \returns  <vector> A vector [v1, v2, v3] of vectors [x, y] of decimal
            coordinates.

  \details

    Vertex \p v1 at the origin. Geometry required that \p s1 + \p s2 is greater
    then \p s3. Coordinates \p v3:[x, y] will be \b 'nan' when specified
    triangle does not exists.

  \note     Side length \p s1 is measured along the positive x-axis.
  \note     Sides are numbered counterclockwise.
*******************************************************************************/
function triangle_lll2vp
(
  s1,
  s2,
  s3
) =
[
  [0, 0],
  [s1, 0],
  [
    ( s1*s1 + s3*s3 - (s2*s2) ) / ( 2*s1 ),
    sqrt( s3*s3 - pow( ( s1*s1 + s3*s3 - (s2*s2) ) / ( 2*s1 ), 2 ) )
  ]
];

//! Compute the vertices of a plane triangle given its side lengths.
/***************************************************************************//**
  \param    v <vector> of decimal side lengths.
  \returns  <vector> A vector [v1, v2, v3] of vectors [x, y] of decimal
            coordinates.

  \details

    Vertex \p vs[0] at the origin. Geometry required that \p vs[0] + \p vs[1]
    is greater then \p vs[2]. Coordinates \p v3:[x, y] will be \b 'nan' when
    specified triangle does not exists.

  \note     Side length \p vs[0] is measured along the positive x-axis.
  \note     Sides are numbered counterclockwise.
*******************************************************************************/
function triangle_vl2vp
(
  v
) = triangle_lll2vp( s1=v[0], s2=v[1], s3=v[2] );

//! Compute the side lengths of a triangle given its vertices.
/***************************************************************************//**
  \param    v1 <vector> A vector [x, y] for vertex 1.
  \param    v2 <vector> A vector [x, y] for vertex 2.
  \param    v3 <vector> A vector [x, y] for vertex 3.
  \returns  <vector> A vector [s1, s2, s3] decimals.

  \note     Vertices are numbered counterclockwise.
*******************************************************************************/
function triangle_ppp2vl
(
  v1,
  v2,
  v3
) = [ distance_p2p(v1, v2), distance_p2p(v2, v3), distance_p2p(v3, v1) ];

//! Compute the side lengths of a triangle given its vertices.
/***************************************************************************//**
  \param    v <vector> A vector [v1, v2, v3] of vectors [x, y].
  \returns  <vector> A vector [s1, s2, s3] decimals.

  \note     Vertices are numbered counterclockwise.
*******************************************************************************/
function triangle_vp2vl
(
  v
) = triangle_ppp2vl( v1=v[0], v2=v[1], v3=v[2]);

//! Compute the centroid (geometric center) of a triangle.
/***************************************************************************//**
  \param    v1 <vector> A vector [x, y] for vertex 1.
  \param    v2 <vector> A vector [x, y] for vertex 2.
  \param    v3 <vector> A vector [x, y] for vertex 3.
  \returns  <vector> A vector [x, y] decimals.
*******************************************************************************/
function triangle_centroid_ppp
(
  v1,
  v2,
  v3
) = [ (v1[0] + v2[0] + v3[0])/3, (v1[1] + v2[1] + v3[1])/3 ];

//! Compute the centroid (geometric center) of a triangle.
/***************************************************************************//**
  \param    v <vector> A vector [v1, v2, v3] of vectors [x, y].
  \returns  <vector> A vector [x, y] decimals.
*******************************************************************************/
function triangle_centroid_vp
(
  v
) = triangle_centroid_ppp( v1=v[0], v2=v[1], v3=v[2]);

//! Compute the coordinate for the triangle's incircle.
/***************************************************************************//**
  \param    v1 <vector> A vector [x, y] for vertex 1.
  \param    v2 <vector> A vector [x, y] for vertex 2.
  \param    v3 <vector> A vector [x, y] for vertex 3.
  \returns  <vector> A vector [x, y] decimals.

  \details

    The interior point for which distances to the sides of the triangle
    are equal.
*******************************************************************************/
function triangle_incenter_ppp
(
  v1,
  v2,
  v3
) =
[
  (
    (
        v1[0] * distance_p2p(v2, v3)
      + v2[0] * distance_p2p(v3, v1)
      + v3[0] * distance_p2p(v1, v2)
    )
    / ( distance_p2p(v1, v2) + distance_p2p(v2, v3) + distance_p2p(v3, v1) )
  ),
  (
    (
        v1[1] * distance_p2p(v2, v3)
      + v2[1] * distance_p2p(v3, v1)
      + v3[1] * distance_p2p(v1, v2)
    )
    / ( distance_p2p(v1, v2) + distance_p2p(v2, v3) + distance_p2p(v3, v1) )
  )
];

//! Compute the coordinate for the triangle's incircle.
/***************************************************************************//**
  \param    v <vector> A vector [v1, v2, v3] of vectors [x, y].
  \returns  <vector> A vector [x, y] decimals.

  \details

    The interior point for which distances to the sides of the triangle
    are equal.
*******************************************************************************/
function triangle_incenter_vp
(
  v
) = triangle_incenter_ppp( v1=v[0], v2=v[1], v3=v[2]);

//! Compute the inradius of a triangle's incircle.
/***************************************************************************//**
  \param    v1 <vector> A vector [x, y] for vertex 1.
  \param    v2 <vector> A vector [x, y] for vertex 2.
  \param    v3 <vector> A vector [x, y] for vertex 3.
  \returns  <decimal> The incircle radius.
*******************************************************************************/
function triangle_inradius_ppp
(
  v1,
  v2,
  v3
) =
sqrt
(
  (
      ( - distance_p2p(v1, v2) + distance_p2p(v2, v3) + distance_p2p(v3, v1) )
    * ( + distance_p2p(v1, v2) - distance_p2p(v2, v3) + distance_p2p(v3, v1) )
    * ( + distance_p2p(v1, v2) + distance_p2p(v2, v3) - distance_p2p(v3, v1) )
  )
  / ( distance_p2p(v1, v2) + distance_p2p(v2, v3) + distance_p2p(v3, v1) )
) / 2;

//! Compute the inradius of a triangle's incircle.
/***************************************************************************//**
  \param    v <vector> A vector [v1, v2, v3] of vectors [x, y].
  \returns  <decimal> The incircle radius.
*******************************************************************************/
function triangle_inradius_vp
(
  v
) = triangle_inradius_ppp( v1=v[0], v2=v[1], v3=v[2]);

//! @}
//! @}

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
