//! Triangle solutions mathematical functions.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2015-2018

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

    \amu_define group_name  (Triangles)
    \amu_define group_brief (Triangle mathematical functions.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
*******************************************************************************/

include <math-base.scad>;

//----------------------------------------------------------------------------//
// group.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)

  \details

    See [Wikipedia](https://en.wikipedia.org/wiki/Triangle)
    for more information.
*******************************************************************************/

//----------------------------------------------------------------------------//

//! Compute the vertex coordinates of a triangle given its side lengths.
/***************************************************************************//**
  \param    s1 <decimal> The length of the side 1.
  \param    s2 <decimal> The length of the side 2.
  \param    s3 <decimal> The length of the side 3.
  \param    cw <boolean> Order vertices clockwise.

  \returns  <coords-2d> A list of vertex coordinates [v1, v2, v3].

  \details

    Geometry requires that \p s1 + \p s2 is greater then \p s3. A
    coordinates will be \b 'nan' when specified triangle does not
    exists.

  \note     Vertex \p v1 at the origin. Side length \p s1 is measured
            along the positive x-axis.
*******************************************************************************/
function triangle_sss2lp
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

//! Compute the vertex coordinates of a triangle given its side lengths.
/***************************************************************************//**
  \param    v <decimal-list-3> The list of side lengths [s1, s2, s3].
  \param    cw <boolean> Order vertices clockwise.

  \returns  <coords-2d> A list of vertex coordinates [v1, v2, v3].

  \details

    Geometry requires that \p s1 + \p s2 is greater then \p s3. A
    coordinates will be \b 'nan' when specified triangle does not
    exists.

  \note     Vertex \p v1 at the origin. Side length \p s1 is measured
            along the positive x-axis.
*******************************************************************************/
function triangle_ls2lp
(
  v,
  cw = true
) = triangle_sss2lp( s1=v[0], s2=v[1], s3=v[2], cw=cw );

//! Compute the side lengths of a triangle given its vertex coordinates.
/***************************************************************************//**
  \param    v1 <point-2d> A vertex coordinate [x, y] for vertex 1.
  \param    v2 <point-2d> A vertex coordinate [x, y] for vertex 2.
  \param    v3 <point-2d> A vertex coordinate [x, y] for vertex 3.

  \returns  <decimal-list-3> A list of side lengths [s1, s2, s3].

  \note     Side lengths ordered according to vertex ordering.
*******************************************************************************/
function triangle_ppp2ls
(
  v1,
  v2,
  v3
) = [ distance_pp(v1, v2), distance_pp(v2, v3), distance_pp(v3, v1) ];

//! Compute the side lengths of a triangle given its vertex coordinates.
/***************************************************************************//**
  \param    v <coords-2d> A list of vertex coordinates [v1, v2, v3].

  \returns  <decimal-list-3> A list of side lengths [s1, s2, s3].

  \note     Side lengths ordered according to vertex ordering.
*******************************************************************************/
function triangle_lp2ls
(
  v
) = triangle_ppp2ls( v1=v[0], v2=v[1], v3=v[2]);

//! Compute the signed area of a triangle given its vertex coordinates.
/***************************************************************************//**
  \param    v1 <point-2d> A vertex coordinate [x, y] for vertex 1.
  \param    v2 <point-2d> A vertex coordinate [x, y] for vertex 2.
  \param    v3 <point-2d> A vertex coordinate [x, y] for vertex 3.
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

//! Compute the signed area of a triangle given its vertex coordinates.
/***************************************************************************//**
  \param    v <coords-2d> A list of vertex coordinates [v1, v2, v3].
  \param    s <boolean> Return the vertex ordering sign.

  \returns  <decimal> The area of the given triangle.
*******************************************************************************/
function triangle_area_lp
(
  v,
  s = false
) =
  let( sa = is_left_ppp(p1=v[0], p2=v[1], p3=v[2]) / 2 )
  (s == false) ? abs(sa) : sa;

//! Compute the centroid (geometric center) of a triangle.
/***************************************************************************//**
  \param    v1 <point-2d> A vertex coordinate [x, y] for vertex 1.
  \param    v2 <point-2d> A vertex coordinate [x, y] for vertex 2.
  \param    v3 <point-2d> A vertex coordinate [x, y] for vertex 3.

  \returns  <point-2d> The centroid coordinate point [x, y].
*******************************************************************************/
function triangle_centroid_ppp
(
  v1,
  v2,
  v3
) = [ (v1[0] + v2[0] + v3[0])/3, (v1[1] + v2[1] + v3[1])/3 ];

//! Compute the centroid (geometric center) of a triangle.
/***************************************************************************//**
  \param    v <coords-2d> A list of vertex coordinates [v1, v2, v3].

  \returns  <point-2d> The centroid coordinate point [x, y].
*******************************************************************************/
function triangle_centroid_lp
(
  v
) = triangle_centroid_ppp( v1=v[0], v2=v[1], v3=v[2]);

//! Compute the coordinate for the triangle's incircle.
/***************************************************************************//**
  \param    v1 <point-2d> A vertex coordinate [x, y] for vertex 1.
  \param    v2 <point-2d> A vertex coordinate [x, y] for vertex 2.
  \param    v3 <point-2d> A vertex coordinate [x, y] for vertex 3.

  \returns  <point-2d> The incircle coordinate point [x, y].

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
  \param    v <coords-2d> A list of vertex coordinates [v1, v2, v3].

  \returns  <point-2d> The incircle coordinate point [x, y].

  \details

    The interior point for which distances to the sides of the triangle
    are equal.
*******************************************************************************/
function triangle_incenter_lp
(
  v
) = triangle_incenter_ppp( v1=v[0], v2=v[1], v3=v[2]);

//! Compute the inradius of a triangle's incircle.
/***************************************************************************//**
  \param    v1 <point-2d> A vertex coordinate [x, y] for vertex 1.
  \param    v2 <point-2d> A vertex coordinate [x, y] for vertex 2.
  \param    v3 <point-2d> A vertex coordinate [x, y] for vertex 3.

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
  \param    v <coords-2d> A list of vertex coordinates [v1, v2, v3].

  \returns  <decimal> The incircle radius.
*******************************************************************************/
function triangle_inradius_lp
(
  v
) = triangle_inradius_ppp( v1=v[0], v2=v[1], v3=v[2]);

//! Test the vertex ordering, or orientation, of a triangle.
/***************************************************************************//**
  \param    v1 <point-2d> A vertex coordinate [x, y] for vertex 1.
  \param    v2 <point-2d> A vertex coordinate [x, y] for vertex 2.
  \param    v3 <point-2d> A vertex coordinate [x, y] for vertex 3.

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
  \param    v <coords-2d> A list of vertex coordinates [v1, v2, v3].

  \returns  <boolean> \b true if the vertices are ordered clockwise,
            \b false if the vertices are ordered counterclockwise, and
            \b undef if the ordering can not be determined.
*******************************************************************************/
function triangle_is_cw_lp
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

//! Test if a point is inside a triangle in a Euclidean 2d-space using Barycentric.
/***************************************************************************//**
  \param    v1 <point-2d> A vertex coordinate [x, y] for vertex 1.
  \param    v2 <point-2d> A vertex coordinate [x, y] for vertex 2.
  \param    v3 <point-2d> A vertex coordinate [x, y] for vertex 3.
  \param    t <point-2d> A test point coordinate [x, y].

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

//! Test if a point is inside a triangle in a Euclidean 2d-space using Barycentric.
/***************************************************************************//**
  \param    v <coords-2d> A list of vertex coordinates [v1, v2, v3].
  \param    t <point-2d> A test point coordinate [x, y].

  \returns  <boolean> \b true when the point is inside the polygon and
            \b false otherwise.
*******************************************************************************/
function triangle_is_pit_lp
(
  v,
  t
) = triangle_is_pit_ppp(v1=v[0], v2=v[1], v3=v[2], t=t);

//! @}
//! @}

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
