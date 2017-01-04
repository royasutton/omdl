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
  \page tv_math Computations Validation
    \li \subpage tv_math_vector
*******************************************************************************/
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \page tv_math_vector Point, Vector and Plane
    \li \subpage tv_math_vector_s
    \li \subpage tv_math_vector_r
  \page tv_math_vector_s Validation Script
    \dontinclude math_validate_vector.scad
    \skip include
    \until end-of-tests
  \page tv_math_vector_r Validation Results
    \include math_validate_vector.log
*******************************************************************************/
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \addtogroup math
  @{

  \defgroup math_vector Point, Vector and Plane
  \brief    Point, vector, and plane computations.

  \details

    See validation \ref tv_math_vector_r "results".
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

//! Compute scalar triple product of two vectors in a Euclidean 3D-space.
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
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE validate;
  BEGIN_SCOPE vector;
    BEGIN_OPENSCAD;
      include <math.scad>;
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
        ["norm_v",
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
        farg_text = vstr(append(", ", rselect(get_value(vid), [0:fname_argc-1]), r=false, j=false, l=false));
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
      for (vid=run_ids) run("norm_v",vid) test( "norm_v", norm_v(gv(vid,0),gv(vid,1),gv(vid,2),gv(vid,3),gv(vid,4),gv(vid,5)), vid );
      for (vid=run_ids) run("are_coplanar_vvv",vid) test( "are_coplanar_vvv", are_coplanar_vvv(gv(vid,0),gv(vid,1),gv(vid,2),gv(vid,3),gv(vid,4),gv(vid,5)), vid );

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
