//! Triangle solutions mathematical functions.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2015-2019

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

//! Compute the side lengths of a triangle given its vertex coordinates.
/***************************************************************************//**
  \param    c <coords-3d|coords-2d>  A list of 3d or 2d vertex
            coordinates [v1, v2, v3].
  \param    s <integer> The initial side.

  \returns  <decimal-list-3> A list of side lengths.

  \details

    Each side length is opposite its corresponding vertex.
*******************************************************************************/
function triangle_ppp2sss
(
  c,
  s = 1
) =
  let
  (
    v1 = c[0],
    v2 = c[1],
    v3 = c[2],

    s1 = distance_pp(v2, v3),
    s2 = distance_pp(v1, v3),
    s3 = distance_pp(v1, v2)
  )
    (s == 1) ? [s1, s2, s3]
  : (s == 2) ? [s2, s3, s1]
  :            [s3, s1, s2];

//! Compute the vertex coordinates of a triangle given its side lengths in 2D.
/***************************************************************************//**
  \param    l <decimal-list-3> The list of side lengths [s1, s2, s3].
  \param    s <integer> The side on the x-axis [1, 2, 3].
  \param    cw <boolean> Order vertices clockwise.

  \returns  <coords-2d> A list of vertex coordinates [v1, v2, v3].

  \details

    No verification is performed to ensure that the given sides specify
    a valid triangle. Specifically, The legnth of the longest side must
    be greater than the sum of the lengths of the remaining two sides.
*******************************************************************************/
function triangle2d_sss2ppp
(
  l,
  s = 2,
  cw = true
) =
  let
  (
    s1 = (s == 1) ? (cw) ? l[2] : l[1]
       : (s == 2) ? (cw) ? l[0] : l[2]
       :            (cw) ? l[1] : l[0],

    s2 = (s == 1) ? l[0]
       : (s == 2) ? l[1]
       :            l[2],

    s3 = (s == 1) ? (cw) ? l[1] : l[2]
       : (s == 2) ? (cw) ? l[2] : l[0]
       :            (cw) ? l[0] : l[1],

    // solution
    // v1 at origin, s2 on x-axis, cw
    c1 = origin2d,
    c2 = [(-s1*s1 + s2*s2 + s3*s3) / (2*s2),
          sqrt(s3*s3 - pow((-s1*s1 + s2*s2 + s3*s3) / (2*s2), 2))],
    c3 = [s2, 0],

    v1 = (s == 1) ? (cw) ? c3 : c2
       : (s == 2) ? (cw) ? c1 : c3
       :            (cw) ? c2 : c1,

    v2 = (s == 1) ? c1
       : (s == 2) ? c2
       :            c3,

    v3 = (s == 1) ? (cw) ? c2 : c3
       : (s == 2) ? (cw) ? c3 : c1
       :            (cw) ? c1 : c2
  )
    [v1, v2, v3];

//! Compute the area of a triangle given its vertex coordinates in 2D.
/***************************************************************************//**
  \param    c <coords-2d> A list of vertex coordinates [v1, v2, v3].
  \param    s <boolean> Return the vertex ordering sign.

  \returns  <decimal> The area of the given triangle.
*******************************************************************************/
function triangle2d_area
(
  c,
  s = false
) =
  let
  (
    sa = is_left_ppp(p1=c[0], p2=c[1], p3=c[2]) / 2
  )
    (s == false) ? abs(sa) : sa;

//! Compute the centroid of a triangle.
/***************************************************************************//**
  \param    c <coords-3d|coords-2d>  A list of 3d or 2d vertex
            coordinates [v1, v2, v3].
  \param    d <integer> The number of dimensions [2:3].

  \returns  <point-3d|point-2d> The centroid coordinate.

  \details

    When \p d is assigned \b 0, \p d is set to the minimun number of
    coordinates of the vertices in \p c.

    See [Wikipedia] for more information.

  [Wikipedia]: https://en.wikipedia.org/wiki/Centroid
*******************************************************************************/
function triangle_centroid
(
  c,
  d = 2
) =
  let
  (
    v1 = c[0],
    v2 = c[1],
    v3 = c[2],

    e  = (d == 0) ? min(len(v1), len(v2), len(v3)) : d
  )
    [ for (i=[0:e-1]) (v1[i] + v2[i] + v3[i])/3 ];

//! Compute the center coordinate of a triangle's incircle in 2D.
/***************************************************************************//**
  \param    c <coords-2d> A list of vertex coordinates [v1, v2, v3].

  \returns  <point-2d> The incircle center coordinate [x, y].

  \details

    The interior point for which distances to the sides of the triangle
    are equal. See [Wikipedia] for more information.

  [Wikipedia]: https://en.wikipedia.org/wiki/Incircle_and_excircles_of_a_triangle
*******************************************************************************/
function triangle2d_incenter
(
  c
) =
  let
  (
    v1 = c[0],
    v2 = c[1],
    v3 = c[2],

    d1 = distance_pp(v2, v3),
    d2 = distance_pp(v3, v1),
    d3 = distance_pp(v1, v2)
  )
    [
      ( (v1[0] * d1 + v2[0] * d2 + v3[0] * d3) / (d3 + d1 + d2) ),
      ( (v1[1] * d1 + v2[1] * d2 + v3[1] * d3) / (d3 + d1 + d2) )
    ];

//! Compute the inradius of a triangle's incircle in 2D.
/***************************************************************************//**
  \param    c <coords-2d> A list of vertex coordinates [v1, v2, v3].

  \returns  <decimal> The incircle radius.

  \details

    See [Wikipedia] for more information.

  [Wikipedia]: https://en.wikipedia.org/wiki/Incircle_and_excircles_of_a_triangle
*******************************************************************************/
function triangle2d_inradius
(
  c
) =
  let
  (
    v1 = c[0],
    v2 = c[1],
    v3 = c[2],

    d1 = distance_pp(v2, v3),
    d2 = distance_pp(v3, v1),
    d3 = distance_pp(v1, v2)
  )
    sqrt( ((-d3+d1+d2) * (+d3-d1+d2) * (+d3+d1-d2)) / (d3+d1+d2) ) / 2;

//! Compute the center coordinate of a triangle's excircle in 2D.
/***************************************************************************//**
  \param    c <coords-2d> A list of vertex coordinates [v1, v2, v3].
  \param    v <integer> Return coordinate opposite vertex \p v.

  \returns  <point-2d> The excircle center coordinate [x, y].

  \details

    A circle outside of the triangle specified by \p v1, \p v2, and \p
    v3, tangent to the side opposite \p v and tangent to the
    extensions of the other two sides away from \p v. See [Wikipedia]
    for more information.

  [Wikipedia]: https://en.wikipedia.org/wiki/Incircle_and_excircles_of_a_triangle
*******************************************************************************/
function triangle2d_excenter
(
  c,
  v = 1
) =
  let
  (
    v1 = c[0],
    v2 = c[1],
    v3 = c[2],

    d1 = distance_pp(v2, v3),
    d2 = distance_pp(v3, v1),
    d3 = distance_pp(v1, v2)
  )
    (v == 1) ? [ ((-d1*v1[0]+d2*v2[0]+d3*v3[0])/(-d1+d2+d3)),
                  ((-d1*v1[1]+d2*v2[1]+d3*v3[1])/(-d1+d2+d3)) ]
  : (v == 2) ? [ ((+d1*v1[0]-d2*v2[0]+d3*v3[0])/(+d1-d2+d3)),
                  ((+d1*v1[1]-d2*v2[1]+d3*v3[1])/(+d1-d2+d3)) ]
  : (v == 3) ? [ ((+d1*v1[0]+d2*v2[0]-d3*v3[0])/(+d1+d2-d3)),
                  ((+d1*v1[1]+d2*v2[1]-d3*v3[1])/(+d1+d2-d3)) ]
  : origin2d;

//! Compute the exradius of a triangle's excircle in 2D.
/***************************************************************************//**
  \param    c <coords-2d> A list of vertex coordinates [v1, v2, v3].
  \param    v <integer> Return coordinate opposite vertex \p v.

  \returns  <decimal> The excircle radius of the excircle opposite \p v.

  \details

    See [Wikipedia] for more information.

  [Wikipedia]: https://en.wikipedia.org/wiki/Incircle_and_excircles_of_a_triangle
*******************************************************************************/
function triangle2d_exradius
(
  c,
  v = 1
) =
  let
  (
    v1 = c[0],
    v2 = c[1],
    v3 = c[2],

    d1 = distance_pp(v2, v3),
    d2 = distance_pp(v3, v1),
    d3 = distance_pp(v1, v2),
    s  = (+d1+d2+d3)/2
  )
    (v == 1) ? sqrt(s * (s-d2) * (s-d3) / (s-d1))
  : (v == 2) ? sqrt(s * (s-d1) * (s-d3) / (s-d2))
  : (v == 3) ? sqrt(s * (s-d1) * (s-d2) / (s-d3))
  : 0;

//! Compute the coordinate of a triangle's circumcenter.
/***************************************************************************//**
  \param    c <coords-3d|coords-2d>  A list of 3d or 2d vertex
            coordinates [v1, v2, v3].
  \param    d <integer> The number of dimensions [2:3].

  \returns  <point-3d|point-2d> The circumcenter coordinate.

  \details

    A circle that passes through all of the vertices of the triangle.
    The radius is the distance from the circumcenter to any of vertex.
    When \p d is assigned \b 0, \p d is set to the minimun number of
    coordinates of the vertices in \p c. See [Wikipedia] for more
    information.

  [Wikipedia]: https://en.wikipedia.org/wiki/Circumscribed_circle
*******************************************************************************/
function triangle_circumcenter
(
  c,
  d = 2
) =
  let
  (
    v1 = c[0],
    v2 = c[1],
    v3 = c[2],

    s2a = sin( 2 * angle_ll([v1, v3], [v1, v2]) ),
    s2b = sin( 2 * angle_ll([v2, v1], [v2, v3]) ),
    s2c = sin( 2 * angle_ll([v3, v2], [v3, v1]) ),

    e  = (d == 0) ? min(len(v1), len(v2), len(v3)) : d
  )
    [ for (i=[0:e-1]) (v1[i]*s2a + v2[i]*s2b + v3[i]*s2c) / (s2a+s2b+s2c) ];

//! Compute the rounding center coordinate for a given radius of a triangle vertex in 2D.
/***************************************************************************//**
  \param    c <coords-2d> A list of vertex coordinates [v1, v2, v3].
  \param    r <decimal> The vertex rounding radius.

  \returns  <decimal> The rounding center coordinate.
*******************************************************************************/
function triangle2d_vround3_center
(
  c,
  r
) = let( ir = triangle2d_inradius(c) )
    (c[1]-r/(r-ir) * triangle2d_incenter(c)) * (ir-r)/ir;

//! Compute the rounding tangent coordinates for a given radius of a triangle vertex in 2D.
/***************************************************************************//**
  \param    c <coords-2d> A list of vertex coordinates [v1, v2, v3].
  \param    r <decimal> The vertex rounding radius.

  \returns  <decimal> The rounding tangent coordinates [t1, t2].
*******************************************************************************/
function triangle2d_vround3_tangents
(
  c,
  r
) = let
    (
      rc = triangle2d_vround3_center(c, r),
      im = sqrt( pow(distance_pp(c[1], rc),2) - pow(r,2) ),
      t1 = c[1] + im * unit_l([c[1], c[0]]),
      t2 = c[1] + im * unit_l([c[1], c[2]])
    )
    [t1, t2];

//! Test the vertex ordering, or orientation, of a triangle in 2D.
/***************************************************************************//**
  \param    c <coords-2d> A list of vertex coordinates [v1, v2, v3].

  \returns  <boolean> \b true if the vertices are ordered clockwise,
            \b false if the vertices are ordered counterclockwise, and
            \b undef if the ordering can not be determined.
*******************************************************************************/
function triangle2d_is_cw
(
  c
) =
  let
  (
    il = is_left_ppp(p1=c[0], p2=c[1], p3=c[2])
  )
    (il < 0) ? true
  : (il > 0) ? false
  : undef;

//! Test if a point is inside a triangle in 2d.
/***************************************************************************//**
  \param    c <coords-2d> A list of vertex coordinates [v1, v2, v3].
  \param    p <point-2d> A test point coordinate [x, y].

  \returns  <boolean> \b true when the point is inside the polygon and
            \b false otherwise.

  \details

    See [Wikipedia] for more information.

    [Wikipedia]: https://en.wikipedia.org/wiki/Barycentric_coordinate_system
*******************************************************************************/
function triangle2d_is_pit
(
  c,
  p
) =
  let
  (
    v1 = c[0],
    v2 = c[1],
    v3 = c[2],

    d = ((v2[1]-v3[1]) * (v1[0]-v3[0]) + (v3[0]-v2[0]) * (v1[1]-v3[1]))
  )
    (d == 0) ? true
  : let
  (
    a = ((v2[1]-v3[1]) * ( p[0]-v3[0]) + (v3[0]-v2[0]) * ( p[1]-v3[1])) / d
  )
    (a < 0) ? false
  : let
  (
    b = ((v3[1]-v1[1]) * ( p[0]-v3[0]) + (v1[0]-v3[0]) * ( p[1]-v3[1])) / d
  )
    (b < 0) ? false
  : ((a + b) < 1);

//! @}
//! @}

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
