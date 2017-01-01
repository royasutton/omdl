//! Mathematical functions.
/***************************************************************************//**
  \file   math.scad
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

  \ingroup math math_vector math_ngon math_triangle
*******************************************************************************/

include <primitives.scad>;

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \addtogroup math
  @{

  \defgroup math_vector Point, Vector and Plane
  \brief    Point, vector, and plane computations.
  @{
*******************************************************************************/
//----------------------------------------------------------------------------//

//! Compute the distance between two points in a Euclidean 1, 2, or 3D-space.
/***************************************************************************//**
  \param    p1 <vector> A 1, 2, or 3-tuple of coordinates.
  \param    p2 <vector> A 1, 2, or 3-tuple of coordinates.

  \returns  <decimal> The distance between the two points.
            Returns \b 'undef' when x and y do not have same number of terms
            or for n-tuple where n>3.

  \details

    When \p p2 is not given, it is assumed to be at the origin.
*******************************************************************************/
function distance_pp
(
  p1,
  p2
) = let
    (
      x=p1,
      y=defined_or( p2, consts(len(p1), 0) )
    )
    all_len([x, y], 1) ?
      abs
      (
        x[0] - y[0]
      )
  : all_len([x, y], 2) ?
      sqrt
      (
          (x[0] - y[0]) * (x[0] - y[0])
        + (x[1] - y[1]) * (x[1] - y[1])
      )
  : all_len([x, y], 3) ?
      sqrt
      (
          (x[0] - y[0]) * (x[0] - y[0])
        + (x[1] - y[1]) * (x[1] - y[1])
        + (x[2] - y[2]) * (x[2] - y[2])
      )
  : undef ;

//! Compute the dot product of two vectors.
/***************************************************************************//**
  \param    v1t <vector> Vector 1 head. An n-tuple of coordinates.
  \param    v2t <vector> Vector 2 head. An n-tuple of coordinates.

  \param    v1i <vector> Vector 1 tail. An n-tuple of coordinates.
  \param    v2i <vector> Vector 2 tail. An n-tuple of coordinates.

  \returns  <decimal> The dot product of the two vectors.
            Returns \b 'undef' when vector coordinates do not have same
            number of terms, n.

  \details

    Each vector may be specified by both its head and tail coordinates.
    When specified by head coordinate only, the tail is assumed to
    be at origin.

    See [Wikipedia](https://en.wikipedia.org/wiki/Dot_product)
    for more information.
*******************************************************************************/
function dot_vv
(
  v1t,
  v2t,
  v1i,
  v2i
) = all_defined([v1i, v2i]) ? ((v1t-v1i) * (v2t-v2i)) : (v1t * v2t);

//! Compute the cross product of two vectors in a Euclidean 3D-space (2D).
/***************************************************************************//**
  \param    v1t <vector> Vector 1 head. A 2 or 3-tuple of coordinates.
  \param    v2t <vector> Vector 2 head. A 2 or 3-tuple of coordinates.

  \param    v1i <vector> Vector 1 tail. A 2 or 3-tuple of coordinates.
  \param    v2i <vector> Vector 2 tail. A 2 or 3-tuple of coordinates.

  \returns  <decimal> The cross product of the two vectors.
            Returns \b 'undef' when vector coordinates do not have same
            number of terms, n.

  \details

    Each vector may be specified by both its head and tail coordinates.
    When specified by head coordinate only, the tail is assumed to
    be at origin.

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
function cross_vv
(
  v1t,
  v2t,
  v1i,
  v2i
) = all_defined([v1i, v2i]) ? cross((v1t-v1i), (v2t-v2i)) : cross(v1t, v2t);

//! Compute scalar triple product of two vectors in a Euclidean 2 or 3D-space.
/***************************************************************************//**
  \param    v1t <vector> Vector 1 head. A 2 or 3-tuple of coordinates.
  \param    v2t <vector> Vector 2 head. A 2 or 3-tuple of coordinates.
  \param    v3t <vector> Vector 3 head. A 2 or 3-tuple of coordinates.

  \param    v1i <vector> Vector 1 tail. A 2 or 3-tuple of coordinates.
  \param    v2i <vector> Vector 2 tail. A 2 or 3-tuple of coordinates.
  \param    v3i <vector> Vector 3 tail. A 2 or 3-tuple of coordinates.

  \returns  <decimal> The scalar triple product of the three vectors.
            Returns \b 'undef' when vector coordinates do not have same
            number of terms, n.

  \details

    Each vector may be specified by both its head and tail coordinates.
    When specified by head coordinate only, the tail is assumed to
    be at origin.

    [v1, v2, v3] = v1 * (v2 x v3)

    See [Wikipedia] (https://en.wikipedia.org/wiki/Triple_product)
    for more information.
*******************************************************************************/
function striple_vvv
(
  v1t,
  v2t,
  v3t,
  v1i,
  v2i,
  v3i
) = all_defined([v1i, v2i, v3i]) ?      // tails specified
    dot_vv
    (
      v1t=v1t,
      v2t=cross_vv( v1t=v2t, v2t=v3t, v1i=v2i, v2i=v3i ),
      v1i=v1i,
      v2i=all_len([v1t, v2t, v3t, v1i, v2i, v3i], 3) ? origin3d : 0
    )
  : dot_vv                              // heads only
    (
      v1t=v1t, v2t=cross_vv( v1t=v2t, v2t=v3t )
    );

//! Compute the angle between two vectors in a Euclidean 2 or 3D-space.
/***************************************************************************//**
  \param    v1t <vector> Vector 1 head. A 2 or 3-tuple of coordinates.
  \param    v2t <vector> Vector 2 head. A 2 or 3-tuple of coordinates.

  \param    v1i <vector> Vector 1 tail. A 2 or 3-tuple of coordinates.
  \param    v2i <vector> Vector 2 tail. A 2 or 3-tuple of coordinates.

  \returns  <decimal> The angle between the two vectors in degrees.
            Returns \b 'undef' when vector coordinates do not have same
            number of terms or when the vectors do not intersect.

  \details

    Each vector may be specified by both its head and tail coordinates.
    When specified by head coordinate only, the tail is assumed to
    be at origin.

  \note For 3D vectors, a normal vector is required to uniquely
        identify the perpendicular plane and axis of rotation for the
        two vectors. This function calculates the positive angle, and
        the plane and axis of rotation will be that which fits this
        assumed positive angle.

  \sa angle_vvn().
*******************************************************************************/
function angle_vv
(
  v1t,
  v2t,
  v1i,
  v2i
) = all_len([v1t, v2t, v1i, v2i], 2) ?  // 2D, tails specified
    atan2
    (
      cross_vv( v1t=v1t, v2t=v2t, v1i=v1i, v2i=v2i ),
      dot_vv( v1t=v1t, v2t=v2t, v1i=v1i, v2i=v2i )
    )
  : all_len([v1t, v2t, v1i, v2i], 3) ?  // 3D, tails specified
    atan2
    (
      distance_pp( cross_vv( v1t=v1t, v2t=v2t, v1i=v1i, v2i=v2i ) ),
      dot_vv( v1t=v1t, v2t=v2t, v1i=v1i, v2i=v2i )
    )
  : all_len([v1t, v2t], 2) ?            // 2D, heads only
    atan2
    (
      cross_vv( v1t=v1t, v2t=v2t ),
      dot_vv( v1t=v1t, v2t=v2t )
    )
  : all_len([v1t, v2t], 3) ?            // 3D, heads only
    atan2
    (
      distance_pp( cross_vv( v1t=v1t, v2t=v2t ) ),
      dot_vv( v1t=v1t, v2t=v2t )
    )
  : undef ;

//! Compute the angle between two vectors in a Euclidean 3D-space.
/***************************************************************************//**
  \param    v1t <vector> Vector 1 head. A 3-tuple of coordinates.
  \param    v2t <vector> Vector 2 head. A 3-tuple of coordinates.
  \param    nvt <vector> Normal vector head. A 3-tuple of coordinates.

  \param    v1i <vector> Vector 1 tail. A 3-tuple of coordinates.
  \param    v2i <vector> Vector 2 tail. A 3-tuple of coordinates.
  \param    nvi <vector> Normal vector tail. A 3-tuple of coordinates.

  \returns  <decimal> The angle between the two vectors in degrees.
            Returns \b 'undef' when vector coordinates do not have same
            number of terms or when the vectors do not intersect.

  \details

    Each vector may be specified by both its head and tail coordinates.
    When specified by head coordinate only, the tail is assumed to
    be at origin.

  \sa angle_vv().
*******************************************************************************/
function angle_vvn
(
  v1t,
  v2t,
  nvt,
  v1i,
  v2i,
  nvi
) = all_len([v1t, v2t, nvt, v1i, v2i, nvi], 3) ?
    atan2
    (
      striple_vvv
      (
        v1t=nvt, v2t=v1t, v3t=v2t, v1i=nvi, v2i=v1i, v3i=v2i
      ),
      dot_vv( v1t=v1t, v2t=v2t, v1i=v1i, v2i=v2i )
    )
  : undef ;

//! Compute the normalized unit vector for a 1, 2, or 3 term vector.
/***************************************************************************//**
  \param    vt <vector> Vector head. A 1, 2, or 3-tuple of coordinates.
  \param    vi <vector> Vector tail. A 1, 2, or 3-tuple of coordinates.

  \returns  <vector> The vector normalized to its unit-vector.
            Returns \b 'undef' when vector coordinates do not have same
            number of terms or for n-tuple where n>3.

  \details

    The vector may be specified by both its head and tail coordinates.
    When specified by head coordinate only, the tail is assumed to
    be at origin.
*******************************************************************************/
function norm_v
(
  vt,
  vi
) = all_defined([vt, vi]) ? (vt-vi) / distance_pp(vt, vi)
  : any_equal([1, 2, 3], len(vt)) ? vt / distance_pp(vt)
  : undef ;

//! Test if three vectors are coplanar in Euclidean 3D-space.
/***************************************************************************//**
  \param    v1t <vector> Vector 1 head. A 3-tuple of coordinates.
  \param    v2t <vector> Vector 2 head. A 3-tuple of coordinates.
  \param    v3t <vector> Vector 3 head. A 3-tuple of coordinates.

  \param    v1i <vector> Vector 1 tail. A 3-tuple of coordinates.
  \param    v2i <vector> Vector 2 tail. A 3-tuple of coordinates.
  \param    v3i <vector> Vector 3 tail. A 3-tuple of coordinates.

  \returns  <boolean> \b true when all three vectors are coplanar,
            and \b false otherwise.
  \details

    Each vector may be specified by both its head and tail coordinates.
    When specified by head coordinate only, the tail is assumed to
    be at origin.

    See [Wikipedia] (https://en.wikipedia.org/wiki/Coplanarity)
    for more information.

  \note Coplanar vectors must all be within the same plane. However,
        this function can test if vectors are in a plane that is
        parallel to a coplanar plane by using non-zero vector tails.
*******************************************************************************/
function are_coplanar_vvv
(
  v1t,
  v2t,
  v3t,
  v1i,
  v2i,
  v3i
) = ( striple_vvv( v1t, v2t, v3t, v1i, v2i, v3i ) == 0 );

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

  \returns  <vector> A vector [v1, v2, ..., vn] of vectors [x, y] of
            coordinates.

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
    (vr == undef) ? v : v - vr/cos(180/n) * norm_v(vt=v)
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

  \returns  <vector> A vector [v1, v2, v3] of vectors [x, y] of coordinates.

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
  origin2d,
  [s1, 0],
  [
    ( s1*s1 + s3*s3 - (s2*s2) ) / ( 2*s1 ),
    sqrt( s3*s3 - pow( ( s1*s1 + s3*s3 - (s2*s2) ) / ( 2*s1 ), 2 ) )
  ]
];

//! Compute the vertices of a plane triangle given its side lengths.
/***************************************************************************//**
  \param    v <vector> of decimal side lengths.

  \returns  <vector> A vector [v1, v2, v3] of vectors [x, y] of coordinates.

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
  \param    v1 <vector> A vector [x, y] for vertex 1 coordinates.
  \param    v2 <vector> A vector [x, y] for vertex 2 coordinates.
  \param    v3 <vector> A vector [x, y] for vertex 3 coordinates.

  \returns  <vector> A vector [s1, s2, s3] of lengths.

  \note     Vertices are numbered counterclockwise.
*******************************************************************************/
function triangle_ppp2vl
(
  v1,
  v2,
  v3
) = [ distance_pp(v1, v2), distance_pp(v2, v3), distance_pp(v3, v1) ];

//! Compute the side lengths of a triangle given its vertices.
/***************************************************************************//**
  \param    v <vector> A vector [v1, v2, v3] of vectors [x, y] coordinates.

  \returns  <vector> A vector [s1, s2, s3] of lengths.

  \note     Vertices are numbered counterclockwise.
*******************************************************************************/
function triangle_vp2vl
(
  v
) = triangle_ppp2vl( v1=v[0], v2=v[1], v3=v[2]);

//! Compute the centroid (geometric center) of a triangle.
/***************************************************************************//**
  \param    v1 <vector> A vector [x, y] for vertex 1 coordinates.
  \param    v2 <vector> A vector [x, y] for vertex 2 coordinates.
  \param    v3 <vector> A vector [x, y] for vertex 3 coordinates.

  \returns  <vector> A vector [x, y] of coordinates.
*******************************************************************************/
function triangle_centroid_ppp
(
  v1,
  v2,
  v3
) = [ (v1[0] + v2[0] + v3[0])/3, (v1[1] + v2[1] + v3[1])/3 ];

//! Compute the centroid (geometric center) of a triangle.
/***************************************************************************//**
  \param    v <vector> A vector [v1, v2, v3] of vectors [x, y] coordinates.

  \returns  <vector> A vector [x, y] of coordinates.
*******************************************************************************/
function triangle_centroid_vp
(
  v
) = triangle_centroid_ppp( v1=v[0], v2=v[1], v3=v[2]);

//! Compute the coordinate for the triangle's incircle.
/***************************************************************************//**
  \param    v1 <vector> A vector [x, y] for vertex 1 coordinates.
  \param    v2 <vector> A vector [x, y] for vertex 2 coordinates.
  \param    v3 <vector> A vector [x, y] for vertex 3 coordinates.

  \returns  <vector> A vector [x, y] of coordinates.

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
        v1[0] * distance_pp(v2, v3)
      + v2[0] * distance_pp(v3, v1)
      + v3[0] * distance_pp(v1, v2)
    )
    / ( distance_pp(v1, v2) + distance_pp(v2, v3) + distance_pp(v3, v1) )
  ),
  (
    (
        v1[1] * distance_pp(v2, v3)
      + v2[1] * distance_pp(v3, v1)
      + v3[1] * distance_pp(v1, v2)
    )
    / ( distance_pp(v1, v2) + distance_pp(v2, v3) + distance_pp(v3, v1) )
  )
];

//! Compute the coordinate for the triangle's incircle.
/***************************************************************************//**
  \param    v <vector> A vector [v1, v2, v3] of vectors [x, y] coordinates.

  \returns  <vector> A vector [x, y] of coordinates.

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
  \param    v1 <vector> A vector [x, y] for vertex 1 coordinates.
  \param    v2 <vector> A vector [x, y] for vertex 2 coordinates.
  \param    v3 <vector> A vector [x, y] for vertex 3 coordinates.

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
      ( - distance_pp(v1, v2) + distance_pp(v2, v3) + distance_pp(v3, v1) )
    * ( + distance_pp(v1, v2) - distance_pp(v2, v3) + distance_pp(v3, v1) )
    * ( + distance_pp(v1, v2) + distance_pp(v2, v3) - distance_pp(v3, v1) )
  )
  / ( distance_pp(v1, v2) + distance_pp(v2, v3) + distance_pp(v3, v1) )
) / 2;

//! Compute the inradius of a triangle's incircle.
/***************************************************************************//**
  \param    v <vector> A vector [v1, v2, v3] of vectors [x, y] coordinates.

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
