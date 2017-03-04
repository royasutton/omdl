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

  \ingroup math math_vecalg math_oshapes math_triangle
*******************************************************************************/

include <datatypes.scad>;

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \page tv_math Math
    \li \subpage tv_math_vecalg
    \li \subpage tv_math_bitwise
*******************************************************************************/
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \page tv_math_vecalg Vector Algebra
    \li \subpage tv_math_vecalg_s
    \li \subpage tv_math_vecalg_r
  \page tv_math_vecalg_s Script
    \dontinclude math_validate_vecalg.scad
    \skip include
    \until end-of-tests
  \page tv_math_vecalg_r Results
    \include math_validate_vecalg.log
*******************************************************************************/
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \addtogroup math
  @{

  \defgroup math_vecalg Vector Algebra
  \brief    Algebraic operations on Euclidean vectors.

  \details

    See validation \ref tv_math_vecalg_r "results".
  @{
*******************************************************************************/
//----------------------------------------------------------------------------//

//! Compute the distance between two points in a Euclidean 1, 2, or 3D-space.
/***************************************************************************//**
  \param    p1 <vector> A 1, 2, or 3-tuple coordinate.
  \param    p2 <vector> A 1, 2, or 3-tuple coordinate.

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
  \param    v1t <vector> Vector 1 head. An n-tuple coordinate.
  \param    v2t <vector> Vector 2 head. An n-tuple coordinate.

  \param    v1i <vector> Vector 1 tail. An n-tuple coordinate.
  \param    v2i <vector> Vector 2 tail. An n-tuple coordinate.

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
  \param    v1t <vector> Vector 1 head. A 2 or 3-tuple coordinate.
  \param    v2t <vector> Vector 2 head. A 2 or 3-tuple coordinate.

  \param    v1i <vector> Vector 1 tail. A 2 or 3-tuple coordinate.
  \param    v2i <vector> Vector 2 tail. A 2 or 3-tuple coordinate.

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

//! Compute scalar triple product of two vectors in a Euclidean 3D-space.
/***************************************************************************//**
  \param    v1t <vector> Vector 1 head. A 2 or 3-tuple coordinate.
  \param    v2t <vector> Vector 2 head. A 2 or 3-tuple coordinate.
  \param    v3t <vector> Vector 3 head. A 2 or 3-tuple coordinate.

  \param    v1i <vector> Vector 1 tail. A 2 or 3-tuple coordinate.
  \param    v2i <vector> Vector 2 tail. A 2 or 3-tuple coordinate.
  \param    v3i <vector> Vector 3 tail. A 2 or 3-tuple coordinate.

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

  \warning  For 2D vectors, this function produces a 2D \e non-scalar
            vector result. The cross produce function computes the 2x2
            determinant of the 2D vectors <tt>(v2 x v3)</tt>, which is
            a scalar value, and this value is \e multiplied by \c v1,
            which results in a 2D vector.
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
  \param    v1t <vector> Vector 1 head. A 2 or 3-tuple coordinate.
  \param    v2t <vector> Vector 2 head. A 2 or 3-tuple coordinate.

  \param    v1i <vector> Vector 1 tail. A 2 or 3-tuple coordinate.
  \param    v2i <vector> Vector 2 tail. A 2 or 3-tuple coordinate.

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
  \param    v1t <vector> Vector 1 head. A 3-tuple coordinate.
  \param    v2t <vector> Vector 2 head. A 3-tuple coordinate.
  \param    nvt <vector> Normal vector head. A 3-tuple coordinate.

  \param    v1i <vector> Vector 1 tail. A 3-tuple coordinate.
  \param    v2i <vector> Vector 2 tail. A 3-tuple coordinate.
  \param    nvi <vector> Normal vector tail. A 3-tuple coordinate.

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
  \param    vt <vector> Vector head. A 1, 2, or 3-tuple coordinate.
  \param    vi <vector> Vector tail. A 1, 2, or 3-tuple coordinate.

  \returns  <vector> The vector normalized to its unit-vector.
            Returns \b 'undef' when vector coordinates do not have same
            number of terms or for n-tuple where n>3.

  \details

    The vector may be specified by both its head and tail coordinates.
    When specified by head coordinate only, the tail is assumed to
    be at origin.
*******************************************************************************/
function unit_v
(
  vt,
  vi
) = all_defined([vt, vi]) ? (vt-vi) / distance_pp(vt, vi)
  : any_equal([1, 2, 3], len(vt)) ? vt / distance_pp(vt)
  : undef ;

//! Test if three vectors are coplanar in Euclidean 3D-space.
/***************************************************************************//**
  \param    v1t <vector> Vector 1 head. A 3-tuple coordinate.
  \param    v2t <vector> Vector 2 head. A 3-tuple coordinate.
  \param    v3t <vector> Vector 3 head. A 3-tuple coordinate.

  \param    v1i <vector> Vector 1 tail. A 3-tuple coordinate.
  \param    v2i <vector> Vector 2 tail. A 3-tuple coordinate.
  \param    v3i <vector> Vector 3 tail. A 3-tuple coordinate.

  \param    d \<number> A positive numerical distance, proximity, or tolerance.

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
  v3i,
  d = 0.000001
) = n_almost_equal(striple_vvv( v1t, v2t, v3t, v1i, v2i, v3i ), 0, d);

//! Test if a point is left|on|right of an infinite line in a Euclidean 2D-space.
/***************************************************************************//**
  \param    p1 <vector> A 2-tuple coordinate.
  \param    p2 <vector> A 2-tuple coordinate.
  \param    p3 <vector> A 2-tuple coordinate.

  \returns  <decimal> (\b > 0) for \p p3 \em left of the line through
            \p p1 and \p p2, (\b = 0) for p3  \em on the line, and
            (\b < 0) for p3  right of the line.

  \details
    Function patterned after [Dan Sunday, 2012].

    [Dan Sunday, 2012]: http://geomalgorithms.com/a01-_area.html
*******************************************************************************/
function is_left_ppp
(
  p1,
  p2,
  p3
) = ((p2[0]-p1[0]) * (p3[1]-p1[1]) - (p3[0]-p1[0]) * (p2[1]-p1[1]));

//! @}
//! @}

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \addtogroup math
  @{

  \defgroup math_oshapes Other Shapes
  \brief    Mathematical functions for other shapes.
  @{
*******************************************************************************/
//----------------------------------------------------------------------------//

//! Compute the vertices for an n-sided regular polygon.
/***************************************************************************//**
  \param    n <decimal> The number of sides.
  \param    r <decimal> The vertex circumradius of the circumcircle.
  \param    a <decimal> The inradius of the incircle.
  \param    vr <decimal> The vertex rounding radius.
  \param    cw <boolean> Use clockwise point ordering.

  \returns  <vector> A vector [v1, v2, ..., vn] of vectors [x, y] of
            coordinate points.

  \details

    \b Example
    \code{.C}
    vr=5;

    hull()
    {
      for ( p = rpolygon_vp( r=20, n=5, vr=vr ) )
        translate( p )
        circle( r=vr );
    }
    \endcode

  \note     The radius can be specified by either the circumradius \p r
            or the inradius \p a. If both are specified, \p r is used.
*******************************************************************************/
function rpolygon_vp
(
  n,
  r,
  a,
  vr,
  cw = false
) =
[
  let
  (
    s = is_defined(r) ? r
      : is_defined(a) ? a / cos(180/n)
      : 0,

    b = (cw == true) ? [360:-(360/n):1] : [0:(360/n):359]
  )
  for ( a = b )
    let( v = [s*cos(a), s*sin(a)] )
    not_defined(vr) ? v : v - vr/cos(180/n) * unit_v(vt=v)
];

//! Compute the area of an n-sided regular polygon.
/***************************************************************************//**
  \param    n <decimal> The number of sides.
  \param    r <decimal> The vertex circumradius of the circumcircle.
  \param    a <decimal> The inradius of the incircle.

  \returns  <decimal> Area of the n-sided regular polygon.

  \details

  \note     The radius can be specified by either the circumradius \p r
            or the inradius \p a. If both are specified, \p r is used.
*******************************************************************************/
function rpolygon_area
(
  n,
  r,
  a
) = is_defined(r) ? pow(r, 2) * n * sin(360/n) / 2
  : is_defined(a) ? pow(a, 2) * n * tan(180/n)
  : 0;

//! Compute the perimeter of an n-sided regular polygon.
/***************************************************************************//**
  \param    n <decimal> The number of sides.
  \param    r <decimal> The vertex circumradius of the circumcircle.
  \param    a <decimal> The inradius of the incircle.

  \returns  <decimal> Perimeter length of the n-sided regular polygon.

  \details

  \note     The radius can be specified by either the circumradius \p r
            or the inradius \p a. If both are specified, \p r is used.
*******************************************************************************/
function rpolygon_perimeter
(
  n,
  r,
  a
) = is_defined(r) ? 2 * n * r * sin(180/n)
  : is_defined(a) ? 2 * n * a * tan(180/n)
  : 0;

//! @}
//! @}

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \addtogroup math
  @{

  \defgroup math_triangle Triangles
  \brief    Triangle mathematical functions.

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

  \returns  <vector> A vector [v1, v2, v3] of vectors [x, y] coordinates.

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

  \returns  <vector> A vector [v1, v2, v3] of vectors [x, y] coordinates.

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

//! Compute the signed area of a triangle given its vertices.
/***************************************************************************//**
  \param    v1 <vector> A 2-tuple coordinate.
  \param    v2 <vector> A 2-tuple coordinate.
  \param    v3 <vector> A 2-tuple coordinate.
  \param    s <boolean> Return the vertex ordering sign.

  \returns  <decimal> The area of the given triangle.
*******************************************************************************/
function triangle_area_ppp
(
  v1,
  v2,
  v3,
  s = false
) =
  let( sa = is_left_ppp(p1=v1, p2=v2, p3=v3) / 2 )
  (s == false) ? abs(sa) : sa;

//! Compute the signed area of a triangle given its vertices.
/***************************************************************************//**
  \param    v <vector> A vector [v1, v2, v3] of vectors [x, y] coordinates.
  \param    s <boolean> Return the vertex ordering sign.

  \returns  <decimal> The area of the given triangle.
*******************************************************************************/
function triangle_area_vp
(
  v,
  s = false
) =
  let( sa = is_left_ppp(p1=v[0], p2=v[1], p3=v[2]) / 2 )
  (s == false) ? abs(sa) : sa;

//! Compute the centroid (geometric center) of a triangle.
/***************************************************************************//**
  \param    v1 <vector> A vector [x, y] for vertex 1.
  \param    v2 <vector> A vector [x, y] for vertex 2.
  \param    v3 <vector> A vector [x, y] for vertex 3.

  \returns  <vector> A vector [x, y] coordinate.
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

  \returns  <vector> A vector [x, y] coordinate.
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

  \returns  <vector> A vector [x, y] coordinate.

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

  \returns  <vector> A vector [x, y] coordinate.

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

//! Test the vertex ordering, or orientation, of a triangle.
/***************************************************************************//**
  \param    v1 <vector> A 2-tuple coordinate.
  \param    v2 <vector> A 2-tuple coordinate.
  \param    v3 <vector> A 2-tuple coordinate.

  \returns  <boolean> \b true if the vertices are ordered clockwise,
            \b false if the vertices are ordered counterclockwise, and
            \b undef if the ordering can not be determined.
*******************************************************************************/
function triangle_is_cw_ppp
(
  v1,
  v2,
  v3
) =
  let
  (
    il = is_left_ppp(p1=v1, p2=v2, p3=v3)
  )
    (il < 0) ? true
  : (il > 0) ? false
  : undef;

//! Test the vertex ordering, or orientation, of a triangle.
/***************************************************************************//**
  \param    v <vector> A vector [v1, v2, v3] of vectors [x, y] coordinates.

  \returns  <boolean> \b true if the vertices are ordered clockwise,
            \b false if the vertices are ordered counterclockwise, and
            \b undef if the ordering can not be determined.
*******************************************************************************/
function triangle_is_cw_vp
(
  v
) =
  let
  (
    il = is_left_ppp(p1=v[0], p2=v[1], p3=v[2])
  )
    (il < 0) ? true
  : (il > 0) ? false
  : undef;

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE validate;
  BEGIN_SCOPE vecalg;
    BEGIN_OPENSCAD;
      include <math.scad>;
      use <datatypes_table.scad>;
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
        ["fac", "Function argument count",    undef],
        ["crp", "Result precision",           undef],
        ["t01", "All undefined",              [undef,undef,undef,undef,undef,undef]],
        ["t02", "All empty vector",           [empty_v,empty_v,empty_v,empty_v,empty_v,empty_v]],
        ["t03", "All scalars",                [60, 50, 40, 30, 20, 10]],
        ["t04", "All 1D vectors",             [[99], [58], [12], [42], [15], [1]]],
        ["t05", "All 2D vectors",             [
                                                [99,2], [58,16], [12,43],
                                                [42,13], [15,59], [1,85]
                                              ]],
        ["t06", "All 3D vectors",             [
                                                [199,20,55], [158,116,75], [12,43,90],
                                                [42,13,34], [15,59,45], [62,33,69]
                                              ]],
        ["t07", "All 4D vectors",             [
                                                [169,27,35,10], [178,016,25,20], [12,43,90,30],
                                                [42,13,34,60], [15,059,45,50], [62,33,69,40]
                                              ]],
        ["t08", "Orthogonal vectors",         [
                                                +x_axis3d_uv, +y_axis3d_uv, +z_axis3d_uv,
                                                -x_axis3d_uv, -y_axis3d_uv, -z_axis3d_uv,
                                              ]],
        ["t09", "Coplanar vectors",           [
                                                +x_axis3d_uv, +y_axis3d_uv, [2,2,0],
                                                origin3d, origin3d, origin3d,
                                              ]]
      ];

      test_ids = table_get_row_ids( test_r );

      // expected columns: ("id" + one column for each test)
      good_c = pmerge([concat("id", test_ids), concat("identifier", test_ids)]);

      // expected rows: ("golden" test results), use 'skip' to skip test
      skip = -1;  // skip test

      good_r =
      [ // function
        ["distance_pp",
          2,                                                  // fac
          4,                                                  // crp
          undef,                                              // t01
          undef,                                              // t02
          undef,                                              // t03
          41,                                                 // t04
          43.3244,                                            // t05
          106.2873,                                           // t06
          undef,                                              // t07
          1.4142,                                             // t08
          1.4142                                              // t09
        ],
        ["dot_vv",
          4,                                                  // fac
          4,                                                  // crp
          undef,                                              // t01
          undef,                                              // t02
          400,                                                // t03
          1392,                                               // t04
          1269,                                               // t05
          17888,                                              // t06
          22599,                                              // t07
          1,                                                  // t08
          -2                                                  // t09
        ],
        ["cross_vv",
          4,                                                  // fac
          4,                                                  // crp
          skip,                                               // t01
          skip,                                               // t02
          skip,                                               // t03
          skip,                                               // t04
          917,                                                // t05
          [2662,-11727,21929],                                // t06
          skip,                                               // t07
          [1,-1,1],                                           // t08
          [0,0,-1]                                            // t09
        ],
        ["striple_vvv",
          6,                                                  // fac
          4,                                                  // crp
          skip,                                               // t01
          skip,                                               // t02
          skip,                                               // t03
          skip,                                               // t04
          [-75981,14663],                                     // t05
          199188,                                             // t06
          skip,                                               // t07
          8,                                                  // t08
          0                                                   // t09
        ],
        ["angle_vv",
          4,                                                  // fac
          4,                                                  // crp
          undef,                                              // t01
          undef,                                              // t02
          undef,                                              // t03
          undef,                                              // t04
          35.8525,                                            // t05
          54.4261,                                            // t06
          undef,                                              // t07
          60,                                                 // t08
          153.4350                                            // t09
        ],
        ["angle_vvn",
          6,                                                  // fac
          4,                                                  // crp
          skip,                                               // t01
          skip,                                               // t02
          skip,                                               // t03
          skip,                                               // t04
          skip,                                               // t05
          83.2771,                                            // t06 (verify)
          skip,                                               // t07
          90,                                                 // t08
          0                                                   // t09
        ],
        ["unit_v",
          2,                                                  // fac
          4,                                                  // crp
          undef,                                              // t01
          undef,                                              // t02
          undef,                                              // t03
          [1],                                                // t04
          [0.9464,-0.3231],                                   // t05
          [0.3857,-0.9032,-0.1882],                           // t06
          undef,                                              // t07
          [0.7071,-0.7071,0],                                 // t08
          [0.7071,-0.7071,0]                                  // t09
        ],
        ["are_coplanar_vvv",
          6,                                                  // fac
          4,                                                  // crp
          skip,                                               // t01
          skip,                                               // t02
          skip,                                               // t03
          skip,                                               // t04
          skip,                                               // t05
          false,                                              // t06
          skip,                                               // t07
          false,                                              // t08
          true                                                // t09
        ]
      ];

      // sanity-test tables
      table_check( test_r, test_c, false );
      table_check( good_r, good_c, false );

      // validate helper function and module
      function get_value( vid ) = table_get(test_r, test_c, vid, "tv");
      function gv( vid, e ) = get_value( vid )[e];
      module run( fname, vid )
      {
        value_text = table_get(test_r, test_c, vid, "td");

        if ( table_get(good_r, good_c, fname, vid) != skip )
          children();
        else if ( show_skipped )
          log_info( str("*skip*: ", vid, " '", fname, "(", value_text, ")'") );
      }
      module test( fname, fresult, vid )
      {
        value_text = table_get(test_r, test_c, vid, "td");
        fname_argc = table_get(good_r, good_c, fname, "fac");
        comp_prcsn = table_get(good_r, good_c, fname, "crp");
        pass_value = table_get(good_r, good_c, fname, vid);

        test_pass = validate(cv=fresult, t="almost", ev=pass_value, p=comp_prcsn, pf=true);
        farg_text = vstr(eappend(", ", rselect(get_value(vid), [0:fname_argc-1]), r=false, j=false, l=false));
        test_text = validate(str(fname, "(", farg_text, ")=~", pass_value), fresult, "almost", pass_value, comp_prcsn);

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
      run_ids = delete( test_ids, mv=["fac", "crp"] );
      for (vid=run_ids) run("distance_pp",vid) test( "distance_pp", distance_pp(gv(vid,0),gv(vid,1),gv(vid,2),gv(vid,3),gv(vid,4),gv(vid,5)), vid );
      for (vid=run_ids) run("dot_vv",vid) test( "dot_vv", dot_vv(gv(vid,0),gv(vid,1),gv(vid,2),gv(vid,3),gv(vid,4),gv(vid,5)), vid );
      for (vid=run_ids) run("cross_vv",vid) test( "cross_vv", cross_vv(gv(vid,0),gv(vid,1),gv(vid,2),gv(vid,3),gv(vid,4),gv(vid,5)), vid );
      for (vid=run_ids) run("striple_vvv",vid) test( "striple_vvv", striple_vvv(gv(vid,0),gv(vid,1),gv(vid,2),gv(vid,3),gv(vid,4),gv(vid,5)), vid );
      for (vid=run_ids) run("angle_vv",vid) test( "angle_vv", angle_vv(gv(vid,0),gv(vid,1),gv(vid,2),gv(vid,3),gv(vid,4),gv(vid,5)), vid );
      for (vid=run_ids) run("angle_vvn",vid) test( "angle_vvn", angle_vvn(gv(vid,0),gv(vid,1),gv(vid,2),gv(vid,3),gv(vid,4),gv(vid,5)), vid );
      for (vid=run_ids) run("unit_v",vid) test( "unit_v", unit_v(gv(vid,0),gv(vid,1),gv(vid,2),gv(vid,3),gv(vid,4),gv(vid,5)), vid );
      for (vid=run_ids) run("are_coplanar_vvv",vid) test( "are_coplanar_vvv", are_coplanar_vvv(gv(vid,0),gv(vid,1),gv(vid,2),gv(vid,3),gv(vid,4),gv(vid,5)), vid );
      // not tested: is_left_ppp()

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
