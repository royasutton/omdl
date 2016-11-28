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

  \ingroup math math_test math_vector math_ngon math_triangle
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

//! Test if a number is invalid, or not a number.
/***************************************************************************//**
  \param    n <decimal> A decimal value.
  \returns  <boolean> \b true when the number is \b nan and \b false otherwise.
*******************************************************************************/
function is_nan( n ) = ( n != n );

//! Test if a number is greater than largest representable number.
/***************************************************************************//**
  \param    n <decimal> A decimal value.
  \returns  <boolean> \b true when the number is \b inf and \b false otherwise.
*******************************************************************************/
function is_inf( n ) = ( n == (1e200*1e200) );

//! Test if a integer number is even.
/***************************************************************************//**
  \param    n <integer> An integer value.
  \returns  <boolean> \b true when the number is even and \b false otherwise.
*******************************************************************************/
function is_even( n ) = ( ((n % 2) == 0) ? true : false );

//! Test if a integer number is odd.
/***************************************************************************//**
  \param    n <integer> An integer value.
  \returns  <boolean> \b true when the number is odd and \b false otherwise.
*******************************************************************************/
function is_odd( n ) = ( ((n % 2) == 0) ? false : true );

//! @}
//! @}

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \addtogroup math
  @{

  \defgroup math_vector Point and vector
  \brief    Point, vector, and plane computations.
  @{
*******************************************************************************/
//----------------------------------------------------------------------------//

//! Compute the sum of a range of vector terms.
/***************************************************************************//**
  \param    v <vector> A vector n-tuple of values.
  \param    e <decimal> The vector term at which to end summation.
  \param    b <decimal> The vector term at which to begin summation.
  \returns  <decimal> The summation of the vector terms.
*******************************************************************************/
function sum_vr
(
  v,
  e,
  b=0
) = ( (e == b) ? v[e] : v[e] + sum_vr(v, e-1, b) );

//! Compute the sum of the vector terms.
/***************************************************************************//**
  \param    v <vector> A vector n-tuple of values.
  \returns  <decimal> The summation of the vector terms.
*******************************************************************************/
function sum_v
(
  v
) = sum_vr( v, len( v ) - 1, 0);

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

  \defgroup math_ngon n-sided polygon
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

  \defgroup math_triangle Triangles
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
