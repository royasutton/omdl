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

  \ingroup math math_vecalg math_linalg math_oshapes math_triangle
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

//----------------------------------------------------------------------------//
// group 1: points
//----------------------------------------------------------------------------//

//! Compute the distance between two Euclidean points.
/***************************************************************************//**
  \param    p1 <point> A n-tuple coordinate.
  \param    p2 <point> A n-tuple coordinate.

  \returns  <decimal> The distance between the two points.
            Returns \b 'undef' when points do not have equal dimensions.

  \details

    When \p p2 is not given, it is assumed to be at the origin.
*******************************************************************************/
function distance_pp
(
  p1,
  p2
) = let(d = len(p1))
    !(d > 0) ? abs(p1 - defined_or(p2, 0))
  : is_defined(p2) ?
    sqrt(sum([for (i=[0:d-1]) (p1[i]-p2[i])*(p1[i]-p2[i])]))
  : sqrt(sum([for (i=[0:d-1]) p1[i]*p1[i]]));

//! Test if a point is left, on, or right of an infinite line in a Euclidean 2D-space.
/***************************************************************************//**
  \param    p1 <point> A 2-tuple coordinate.
  \param    p2 <point> A 2-tuple coordinate.
  \param    p3 <point> A 2-tuple coordinate.

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

//----------------------------------------------------------------------------//
// group 2: vectors
//----------------------------------------------------------------------------//

//! Return the number of dimensions of a Euclidean vector or line.
/***************************************************************************//**
  \param    v <vector> A vector or a line.

  \returns  <integer> The number of dimensions.
*******************************************************************************/
function dimensions_v
(
  v
) = is_defined(len(v[0])) ? len(v[0]) : len(v);

//! Shift a Euclidean vector or line to the origin.
/***************************************************************************//**
  \param    v <vector> A vector or a line.

  \returns  <integer> The vector or line shifted to the origin.
*******************************************************************************/
function to_origin_v
(
  v
) = not_defined(len(v[0])) ? v
  : (len(v) == 1) ? v[0]
  : (len(v) == 2) ? (v[1]-v[0])
  : undef;

//! Compute the dot product of two vectors.
/***************************************************************************//**
  \param    v1 <vector> A n-dimensional vector 1.
  \param    v2 <vector> A n-dimensional vector 2.

  \returns  <decimal> The dot product of \p v1 with \p v2.
            Returns \b 'undef' when vector do not have the same
            dimensions.

  \details

    See [Wikipedia] for more information.

    [Wikipedia]: https://en.wikipedia.org/wiki/Dot_product
*******************************************************************************/
function dot_vv
(
  v1,
  v2
) = (to_origin_v(v1) * to_origin_v(v2));

//! Compute the cross product of two vectors in a Euclidean 3D-space (2D).
/***************************************************************************//**
  \param    v1 <vector> A 2 or 3-dimensional vector 1.
  \param    v2 <vector> A 2 or 3-dimensional vector 2.

  \returns  <decimal> The cross product of \p v1 with \p v2.
            Returns \b 'undef' when vector do not have the same
            dimensions.

  \details

    See Wikipedia [cross] and [determinant] for more information.

  \note     Although the cross product of two vectors is defined only
            in 3D space, this function will return the 2x2 determinant
            for 2D vectors.

  [cross]: https://en.wikipedia.org/wiki/Cross_product
  [determinant]: https://en.wikipedia.org/wiki/Determinant
*******************************************************************************/
function cross_vv
(
  v1,
  v2
) = cross(to_origin_v(v1), to_origin_v(v2));

//! Compute the scalar triple product of three vectors in a Euclidean 3D-space (2D).
/***************************************************************************//**
  \param    v1 <vector> A 2 or 3-dimensional vector 1.
  \param    v2 <vector> A 2 or 3-dimensional vector 2.
  \param    v3 <vector> A 2 or 3-dimensional vector 2.

  \returns  <decimal> The scalar triple product of the three vectors.
            Returns \b 'undef' when vector do not have the same
            dimensions.

  \details

    [v1, v2, v3] = v1 * (v2 x v3)

    See [Wikipedia] for more information.

  \warning  For 2D vectors, this function produces a 2D vector result.
            The cross product computes the 2x2 determinant of the
            vectors <tt>(v2 x v3)</tt>, a scalar value, which is then
            \e multiplied by vector \c v1.

  [Wikipedia]: https://en.wikipedia.org/wiki/Triple_product
*******************************************************************************/
function striple_vvv
(
  v1,
  v2,
  v3
) = dot_vv(to_origin_v(v1), cross_vv(v2, v3));

//! Compute the angle between two vectors in a Euclidean 2 or 3D-space.
/***************************************************************************//**
  \param    v1 <vector> A 2 or 3-dimensional vector 1.
  \param    v2 <vector> A 2 or 3-dimensional vector 2.

  \returns  <decimal> The angle between the two vectors in degrees.
            Returns \b 'undef' when vector do not have the same
            dimensions or when the vectors do not intersect.

  \details

  \note     For 3D vectors, a normal vector is required to uniquely
            identify the perpendicular plane and axis of rotation for
            the two vectors. This function calculates the positive
            angle, and the plane and axis of rotation will be that
            which fits this assumed positive angle.

  \sa angle_vvn().
*******************************************************************************/
function angle_vv
(
  v1,
  v2
) = let(d = dimensions_v(v1))
    (d == 2) ? atan2(cross_vv(v1, v2), dot_vv(v1, v2))
  : (d == 3) ? atan2(distance_pp(cross_vv(v1, v2)), dot_vv(v1, v2))
  : undef;

//! Compute the angle between two vectors in a Euclidean 3D-space.
/***************************************************************************//**
  \param    v1 <vector> A 3-dimensional vector 1.
  \param    v2 <vector> A 3-dimensional vector 2.
  \param    nv <vector> A 3-dimensional normal vector.

  \returns  <decimal> The angle between the two vectors in degrees.
            Returns \b 'undef' when vector do not have the same
            dimensions or when the vectors do not intersect.

  \details

  \sa angle_vv().
*******************************************************************************/
function angle_vvn
(
  v1,
  v2,
  nv
) = atan2(striple_vvv(nv, v1, v2), dot_vv(v1, v2));

//! Compute the normalized unit vector of a Euclidean vector.
/***************************************************************************//**
  \param    v <vector> A vector or a line.

  \returns  <vector> The normalized unit vector.
*******************************************************************************/
function unit_v
(
  v
) = to_origin_v(v) / distance_pp(to_origin_v(v));

//! Test if three vectors are coplanar in Euclidean 3D-space.
/***************************************************************************//**
  \param    v1 <vector> A 3-dimensional vector 1.
  \param    v2 <vector> A 3-dimensional vector 2.
  \param    v3 <vector> A 3-dimensional vector 3.

  \param    d <integer> A positive numerical distance, proximity, or
            tolerance. The number of decimal places to check.

  \returns  <boolean> \b true when all three vectors are coplanar,
            and \b false otherwise.
  \details

    See [Wikipedia] for more information.

  \note     When vectors are specified with start and end points, this
            function tests if vectors are in a planes parallel to the
            coplanar.

  [Wikipedia]: https://en.wikipedia.org/wiki/Coplanarity
*******************************************************************************/
function are_coplanar_vvv
(
  v1,
  v2,
  v3,
  d = 6
) = (dround(striple_vvv(v1, v2, v3), d) ==  0);

//! @}
//! @}

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \addtogroup math
  @{

  \defgroup math_linalg Linear Algebra
  \brief    Linear algebra transformations on Euclidean coordinates.
  @{
*******************************************************************************/
//----------------------------------------------------------------------------//

//! Multiply all coordinates by a 4x4 3D-transformation matrix.
/***************************************************************************//**
  \param    c <vector> A vector of vertices where each is a n-tuple
            coordinate vector.
  \param    m <vector> An 4-tuple by 4-tuple transformation matrix.

  \returns  <vector> The vector of vertices with all coordinates multiplied
            by the 4x4 transformation matrix.

  \details

    See [Wikipedia] and [multmatrix] for more information.

    [Wikipedia]: https://en.wikipedia.org/wiki/Transformation_matrix
    [multmatrix]: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Transformations#multmatrix
*******************************************************************************/
function multmatrix_vp
(
  c,
  m
) =
  let
  (
    m11=m[0][0], m12=m[0][1], m13=m[0][2], m14=m[0][3],
    m21=m[1][0], m22=m[1][1], m23=m[1][2], m24=m[1][3],
    m31=m[2][0], m32=m[2][1], m33=m[2][2], m34=m[2][3]
  )
  [
    for (ci=c)
    let
    (
      x = ci[0], y = ci[1], z = ci[2]
    )
      [m11*x+m12*y+m13*z+m14, m21*x+m22*y+m23*z+m24, m31*x+m32*y+m33*z+m34]
  ];

//! Translate all coordinates by a constant vector.
/***************************************************************************//**
  \param    c <vector> A vector of vertices where each is a n-tuple
            coordinate vector.
  \param    v <vector> An n-tuple translation constant.

  \returns  <vector> The vector of vertices with the constant \p v added
            to each coordinate.

  \details

    See [Wikipedia] for more information and [transformation matrix].

    [Wikipedia]: https://en.wikipedia.org/wiki/Translation_(geometry)
    [transformation matrix]: https://en.wikipedia.org/wiki/Transformation_matrix
*******************************************************************************/
function translate_vp
(
  c,
  v
) = not_defined(v) ? c
  : let
    (
      d = len(first(c)),
      u = is_scalar(v) ? v : 0,
      w = [for (i=[0 : d-1]) edefined_or(v, i, u)]
    )
    [for (ci=c) [for (di=[0 : d-1]) ci[di] + w[di]]];

//! Rotate all coordinates about one or more coordinate axes.
/***************************************************************************//**
  \param    c <vector> A vector of vertices where each is a 3 or 2-tuple
            coordinate vector.
  \param    a <vector|scalar> A 3-tuple rotation vector [ax, ay, az],
            or a single scalar value to specify only az.
  \param    v <vector> A 3-tuple arbitrary axis for the rotation. When
            specified, the rotation angle will be the scalar \p a or az
            about the line \p v that passes through \p o.
  \param    o <vector> A 3-tuple arbitrary origin for the rotation.
            Ignored when \p v is not specified.

  \returns  <vector> The vector of vertices rotated as specified by \p a.
            Rotation order is rz, ry, rx.

  \details

    See [Wikipedia] for more information on [transformation matrix]
    and [axis rotation].

    [Wikipedia]: https://en.wikipedia.org/wiki/Rotation_matrix
    [transformation matrix]: https://en.wikipedia.org/wiki/Transformation_matrix
    [axis rotation]: http://inside.mines.edu/fs_home/gmurray/ArbitraryAxisRotation
*******************************************************************************/
function rotate_vp
(
  c,
  a,
  v,
  o = origin3d
) = not_defined(a) ? c
  : let
    (
      d  = len(first(c)),
      az = edefined_or(a, 2, is_scalar(a) ? a : 0),

      cg = cos(az), sg = sin(az),

      rc = (d == 2) ? [for (ci=c) [cg*ci[0]-sg*ci[1], sg*ci[0]+cg*ci[1]]]
         : (d != 3) ? c
         : (not_defined(v) || is_list(a)) ?
            let
            (
              ax = edefined_or(a, 0, 0),
              ay = edefined_or(a, 1, 0),

              ca = cos(ax), cb = cos(ay),
              sa = sin(ax), sb = sin(ay),

              m11 = cb*cg,
              m12 = cg*sa*sb-ca*sg,
              m13 = ca*cg*sb+sa*sg,

              m21 = cb*sg,
              m22 = ca*cg+sa*sb*sg,
              m23 = -cg*sa+ca*sb*sg,

              m31 = -sb,
              m32 = cb*sa,
              m33 = ca*cb
            )
            multmatrix_vp(c, [[m11,m12,m13,0], [m21,m22,m23,0], [m31,m32,m33,0]])
         :  let
            (
              vx  = v[0],  vy  = v[1],  vz  = v[2],
              vx2 = vx*vx, vy2 = vy*vy, vz2 = vz*vz,
              l2  = vx2 + vy2 + vz2
            )
            (l2 == 0) ? c
         :  let
            (
              ox = o[0], oy = o[1], oz = o[2],
              ll = sqrt(l2),
              oc = 1 - cg,

              m11 = vx2+(vy2+vz2)*cg,
              m12 = vx*vy*oc-vz*ll*sg,
              m13 = vx*vz*oc+vy*ll*sg,
              m14 = (ox*(vy2+vz2)-vx*(oy*vy+oz*vz))*oc+(oy*vz-oz*vy)*ll*sg,

              m21 = vx*vy*oc+vz*ll*sg,
              m22 = vy2+(vx2+vz2)*cg,
              m23 = vy*vz*oc-vx*ll*sg,
              m24 = (oy*(vx2+vz2)-vy*(ox*vx+oz*vz))*oc+(oz*vx-ox*vz)*ll*sg,

              m31 = vx*vz*oc-vy*ll*sg,
              m32 = vy*vz*oc+vx*ll*sg,
              m33 = vz2+(vx2+vy2)*cg,
              m34 = (oz*(vx2+vy2)-vz*(ox*vx+oy*vy))*oc+(ox*vy-oy*vx)*ll*sg
            )
            multmatrix_vp(c, [[m11,m12,m13,m14], [m21,m22,m23,m24], [m31,m32,m33,m34]])/l2
    )
    rc;

//! Scale all coordinates by a constant vector.
/***************************************************************************//**
  \param    c <vector> A vector of vertices where each is a n-tuple
            coordinate vector.
  \param    v <vector> An n-tuple scale constant.

  \returns  <vector> The vector of vertices with each coordinate scaled
            by the constant \p v.
*******************************************************************************/
function scale_vp
(
  c,
  v
) = not_defined(v) ? c
  : let
    (
      d = len(first(c)),
      u = is_scalar(v) ? v : 1,
      w = [for (i=[0 : d-1]) edefined_or(v, i, u)]
    )
    [for (ci=c) [for (di=[0 : d-1]) ci[di] * w[di]]];

//! Scale all coordinates proportionately to fit inside a region.
/***************************************************************************//**
  \param    c <vector> A vector of vertices where each is a n-tuple
            coordinate vector.
  \param    v <vector> An n-tuple region constant.

  \returns  <vector> The vector of vertices with each coordinate scaled
            proportionately to fit inside the given region.
*******************************************************************************/
function resize_vp
(
  c,
  v
) = not_defined(v) ? c
  : let
    (
      d = len(first(c)),
      u = is_scalar(v) ? v : 1,
      w = [for (i=[0 : d-1]) edefined_or(v, i, u)],
      m = [for (i=[0 : d-1]) let (cv = [for (ci=c) (ci[i])]) [min(cv), max(cv)]],
      s = [for (i=[0 : d-1]) second(m[i]) - first(m[i])]
    )
    [for (ci=c) [for (di=[0 : d-1]) ci[di]/s[di] * w[di]]];

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
  cw = true
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
    not_defined(vr) ? v : v - vr/cos(180/n) * unit_v(v)
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

//! Compute the vertices of a triangle given its side lengths.
/***************************************************************************//**
  \param    s1 <decimal> The length of the side 1.
  \param    s2 <decimal> The length of the side 2.
  \param    s3 <decimal> The length of the side 3.
  \param    cw <boolean> Order vertices clockwise.

  \returns  <vector> A vector [v1, v2, v3] of vectors [x, y] coordinates.

  \details

    Geometry requires that \p s1 + \p s2 is greater then \p s3. A
    coordinates will be \b 'nan' when specified triangle does not
    exists.

  \note     Vertex \p v1 at the origin. Side length \p s1 is measured
            along the positive x-axis.
*******************************************************************************/
function triangle_lll2vp
(
  s1,
  s2,
  s3,
  cw = true
) =
  let
  (
    v1 = origin2d,
    v2 = [s1, 0],
    v3 = [(s1*s1 + s3*s3 - (s2*s2)) / (2*s1),
          sqrt(s3*s3 - pow((s1*s1 + s3*s3 - (s2*s2)) / (2*s1), 2))]
  )
  (cw == true) ? [v1, v3, v2] : [v1, v2, v3];

//! Compute the vertices of a triangle given its side lengths.
/***************************************************************************//**
  \param    v <vector> of decimal side lengths.
  \param    cw <boolean> Order vertices clockwise.

  \returns  <vector> A vector [v1, v2, v3] of vectors [x, y] coordinates.

  \details

    Geometry requires that \p s1 + \p s2 is greater then \p s3. A
    coordinates will be \b 'nan' when specified triangle does not
    exists.

  \note     Vertex \p v1 at the origin. Side length \p s1 is measured
            along the positive x-axis.
*******************************************************************************/
function triangle_vl2vp
(
  v,
  cw = true
) = triangle_lll2vp( s1=v[0], s2=v[1], s3=v[2], cw=cw );

//! Compute the side lengths of a triangle given its vertices.
/***************************************************************************//**
  \param    v1 <vector> A vector [x, y] for vertex 1.
  \param    v2 <vector> A vector [x, y] for vertex 2.
  \param    v3 <vector> A vector [x, y] for vertex 3.

  \returns  <vector> A vector [s1, s2, s3] of lengths.

  \note     Side lengths ordered according to vertex ordering.
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

  \note     Side lengths ordered according to vertex ordering.
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

//! Test if a point is inside a triangle in a Euclidean 2D-space using Barycentric.
/***************************************************************************//**
  \param    v1 <vector> A 2-tuple coordinate.
  \param    v2 <vector> A 2-tuple coordinate.
  \param    v3 <vector> A 2-tuple coordinate.
  \param    t <vector> A test point 2-tuple coordinate [x, y].

  \returns  <boolean> \b true when the point is inside the polygon and
            \b false otherwise.

  \details

    See [Wikipedia] for more information.

    [Wikipedia]: https://en.wikipedia.org/wiki/Barycentric_coordinate_system
*******************************************************************************/
function triangle_is_pit_ppp
(
  v1,
  v2,
  v3,
  t
) = let (d = ((v2[1]-v3[1]) * (v1[0]-v3[0]) + (v3[0]-v2[0]) * (v1[1]-v3[1])))
    (d == 0) ? true
  : let (a = ((v2[1]-v3[1]) * ( t[0]-v3[0]) + (v3[0]-v2[0]) * ( t[1]-v3[1])) / d)
    (a < 0) ? false
  : let (b = ((v3[1]-v1[1]) * ( t[0]-v3[0]) + (v1[0]-v3[0]) * ( t[1]-v3[1])) / d)
    (b < 0) ? false
  : ((a + b) < 1);

//! Test if a point is inside a triangle in a Euclidean 2D-space using Barycentric.
/***************************************************************************//**
  \param    v <vector> A vector [v1, v2, v3] of vectors [x, y] coordinates.
  \param    t <vector> A test point 2-tuple coordinate [x, y].

  \returns  <boolean> \b true when the point is inside the polygon and
            \b false otherwise.
*******************************************************************************/
function triangle_is_pit_vp
(
  v,
  t
) = triangle_is_pit_ppp(v1=v[0], v2=v[1], v3=v[2], t=t);

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
          10,                                                 // t03
          41,                                                 // t04
          43.3244,                                            // t05
          106.2873,                                           // t06
          20.0499,                                            // t07
          1.4142,                                             // t08
          1.4142                                              // t09
        ],
        ["dimensions_v",
          2,                                                  // fac
          4,                                                  // crp
          2,                                                  // t01
          0,                                                  // t02
          2,                                                  // t03
          1,                                                  // t04
          2,                                                  // t05
          3,                                                  // t06
          4,                                                  // t07
          3,                                                  // t08
          3                                                   // t09
        ],
        ["to_origin_v",
          2,                                                  // fac
          4,                                                  // crp
          [undef, undef],                                     // t01
          empty_v,                                            // t02
          [60,50],                                            // t03
          [-41],                                              // t04
          [-41,14],                                           // t05
          [-41,96,20],                                        // t06
          [9,-11,-10,10],                                     // t07
          [-1,1,0],                                           // t08
          [-1,1,0]                                            // t09
        ],
        ["dot_vv",
          4,                                                  // fac
          4,                                                  // crp
          undef,                                              // t01
          undef,                                              // t02
          3900,                                               // t03
          -1230,                                              // t04
          -1650,                                              // t05
          -5230,                                              // t06
          1460,                                               // t07
          1,                                                  // t08
          0                                                   // t09
        ],
        ["cross_vv",
          4,                                                  // fac
          4,                                                  // crp
          skip,                                               // t01
          skip,                                               // t02
          skip,                                               // t03
          skip,                                               // t04
          810,                                                // t05
          [-4776,-1696,-1650],                                // t06
          skip,                                               // t07
          [-1,-1,1],                                          // t08
          [0,0,4]                                             // t09
        ],
        ["striple_vvv",
          6,                                                  // fac
          4,                                                  // crp
          skip,                                               // t01
          skip,                                               // t02
          skip,                                               // t03
          skip,                                               // t04
          [-14760,5040],                                      // t05
          -219976,                                            // t06
          skip,                                               // t07
          -2,                                                 // t08
          0                                                   // t09
        ],
        ["angle_vv",
          4,                                                  // fac
          4,                                                  // crp
          undef,                                              // t01
          undef,                                              // t02
          -2.9357,                                            // t03
          undef,                                              // t04
          153.8532,                                           // t05
          134.4573,                                           // t06
          undef,                                              // t07
          60,                                                 // t08
          90                                                  // t09
        ],
        ["angle_vvn",
          6,                                                  // fac
          4,                                                  // crp
          skip,                                               // t01
          skip,                                               // t02
          skip,                                               // t03
          skip,                                               // t04
          skip,                                               // t05
          -91.362,                                            // t06
          skip,                                               // t07
          -63.4349,                                           // t08
          0                                                   // t09
        ],
        ["unit_v",
          2,                                                  // fac
          4,                                                  // crp
          undef,                                              // t01
          undef,                                              // t02
          [.7682,0.6402],                                     // t03
          [-1],                                               // t04
          [-0.9464,0.3231],                                   // t05
          [-0.3857,0.9032,0.1882],                            // t06
          [0.44888,-0.5486,-0.4988,0.4988],                   // t07
          [-0.7071,0.7071,0],                                 // t08
          [-0.7071,0.7071,0]                                  // t09
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
      module test( fname, fresult, vid, pair )
      {
        value_text = table_get(test_r, test_c, vid, "td");
        fname_argc = table_get(good_r, good_c, fname, "fac");
        comp_prcsn = table_get(good_r, good_c, fname, "crp");
        pass_value = table_get(good_r, good_c, fname, vid);

        test_pass = validate(cv=fresult, t="almost", ev=pass_value, p=comp_prcsn, pf=true);
        farg_text = (pair == true)
                  ? vstr(eappend(", ", nssequence(rselect(get_value(vid), [0:fname_argc-1]), n=2, s=2), r=false, j=false, l=false))
                  : vstr(eappend(", ", rselect(get_value(vid), [0:fname_argc-1]), r=false, j=false, l=false));
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

      // group 1: points
      for (vid=run_ids) run("distance_pp",vid) test( "distance_pp", distance_pp(gv(vid,0),gv(vid,1)), vid, false );
      // not tested: is_left_ppp()

      // group 2: vectors
      for (vid=run_ids) run("dimensions_v",vid) test( "dimensions_v", dimensions_v([gv(vid,0),gv(vid,1)]), vid, true );
      for (vid=run_ids) run("to_origin_v",vid) test( "to_origin_v", to_origin_v([gv(vid,0),gv(vid,1)]), vid, true );
      for (vid=run_ids) run("dot_vv",vid) test( "dot_vv", dot_vv([gv(vid,0),gv(vid,1)],[gv(vid,2),gv(vid,3)]), vid, true );
      for (vid=run_ids) run("cross_vv",vid) test( "cross_vv", cross_vv([gv(vid,0),gv(vid,1)],[gv(vid,2),gv(vid,3)]), vid, true );
      for (vid=run_ids) run("striple_vvv",vid) test( "striple_vvv", striple_vvv([gv(vid,0),gv(vid,1)],[gv(vid,2),gv(vid,3)],[gv(vid,4),gv(vid,5)]), vid, true );
      for (vid=run_ids) run("angle_vv",vid) test( "angle_vv", angle_vv([gv(vid,0),gv(vid,1)],[gv(vid,2),gv(vid,3)]), vid, true );
      for (vid=run_ids) run("angle_vvn",vid) test( "angle_vvn", angle_vvn([gv(vid,0),gv(vid,1)],[gv(vid,2),gv(vid,3)],[gv(vid,4),gv(vid,5)]), vid, true );
      for (vid=run_ids) run("unit_v",vid) test( "unit_v", unit_v([gv(vid,0),gv(vid,1)]), vid, true );
      for (vid=run_ids) run("are_coplanar_vvv",vid) test( "are_coplanar_vvv", are_coplanar_vvv([gv(vid,0),gv(vid,1)],[gv(vid,2),gv(vid,3)],[gv(vid,4),gv(vid,5)]), vid, true );

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
