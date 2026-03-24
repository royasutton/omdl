//! Triangle shapes, conversions, properties, and tests functions.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2015-2019, 2026

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

  \amu_include (include/amu/doxyg_init_pd_gds_ipg.amu)
*******************************************************************************/

// auto-tests (add to test results page)
/***************************************************************************//**
  \amu_include (include/amu/validate_log.amu)
  \amu_include (include/amu/validate_results.amu)
*******************************************************************************/

// group(s) begin (test summary and includes-required)
/***************************************************************************//**
  \amu_include (include/amu/doxyg_define_in_parent_open.amu)
  \amu_include (include/amu/validate_summary.amu)
  \amu_include (include/amu/includes_required.amu)
*******************************************************************************/

// member-wide reference definitions
/***************************************************************************//**
  \amu_define note_no_validation
  (
    \note No validation is performed on the input values. Degenerate or
          invalid input will produce undef, nan, or inf without warning
          unless an assert is present.
  )

  \amu_define html_image_w  (512)
  \amu_define latex_image_w (2.25in)
  \amu_include (include/amu/scope_diagram_2d_object.amu)
*******************************************************************************/

// member-wide documentation and conventions
/***************************************************************************//**
  \addtogroup \amu_eval(${group})
  \details
  \anchor \amu_eval(${group})_conventions
  \par Conventions

    The following conventions apply to all functions in this group.
    - \p c is always a list of three coordinate points \c [v1, v2, v3];
      \p v is always a scalar input list (sides and/or angles), with
      element order encoded in the function name
      (e.g. triangle_sas2sss takes \c [s1, a3, s2]).
    - Side lengths s1, s2, s3 are each \b opposite the corresponding
      vertex; angles a1, a2, a3 are \b at the corresponding vertex,
      in \b degrees.
    - \p vi is the vertex-selector parameter (1-indexed: \b 1 = v1,
      \b 2 = v2, \b 3 = v3); out-of-range values return a stated
      fallback without error.
    - \p d controls output dimensionality: \p d = \b 2 (default)
      silently discards the z-component of 3d input; \p d = \b 3
      preserves it; \p d = \b 0 auto-detects from the minimum
      coordinate length of \p c.
    - \p cw = \b true (default) orders output vertices \b clockwise;
      \p s = \b true in triangle2d_area() returns a signed area --
      \b negative for clockwise, \b positive for counter-clockwise --
      matching polygon_area().
    - No input validation is performed unless an explicit \c assert is
      present; degenerate input (collinear vertices, zero sides,
      angles >= 180 degrees) produces \b undef, \b nan, or \b inf silently.
    - The rounding functions triangle2d_vround3_center() and
      triangle2d_vround3_tangents() operate on vertex \b v2 (c[1])
      only; rotate \p c to round a different vertex.
    - Lengths are in the units of the input coordinate space; area in
      square units; angles in degrees.

  See [Wikipedia](https://en.wikipedia.org/wiki/Triangle) for more
  general information.
*******************************************************************************/

//----------------------------------------------------------------------------//
// members
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
// shape generation
//----------------------------------------------------------------------------//

//! \name Shapes
//! @{

//! Compute the side lengths of a triangle given its vertex coordinates.
/***************************************************************************//**
  \param    c <points-3d | points-2d>  A list, [v1, v2, v3], the 3d or
              2d vertex coordinates.

  \returns  <decimal-list-3> A list of side lengths [s1, s2, s3].

  \details

    Each side length is opposite the corresponding vertex.

    \amu_eval ( object=triangle_ppp2sss ${object_diagram_2d} )

    See [Wikipedia] for more information.

  \amu_eval(${note_no_validation})

  [Wikipedia]: https://en.wikipedia.org/wiki/Solution_of_triangles
*******************************************************************************/
function triangle_ppp2sss
(
  c
) =
  let
  (
    v1 = c[0],
    v2 = c[1],
    v3 = c[2],

    s1 = distance_pp(v2, v3),
    s2 = distance_pp(v3, v1),
    s3 = distance_pp(v1, v2)
  )
  [s1, s2, s3];

//! Compute the side lengths of a triangle given two sides and the included angle.
/***************************************************************************//**
  \param    v <decimal-list-3> A list, [s1, a3, s2], the side lengths
              and the included angle.

  \returns  <decimal-list-3> A list of side lengths [s1, s2, s3].

  \details

    Each side length is opposite the corresponding vertex.

    \amu_eval ( object=triangle_sas2sss ${object_diagram_2d} )

    See [Wikipedia] for more information.

  \amu_eval(${note_no_validation})

  [Wikipedia]: https://en.wikipedia.org/wiki/Solution_of_triangles
*******************************************************************************/
function triangle_sas2sss
(
  v
) =
  let
  (
    s1 = v[0],
    a3 = v[1],
    s2 = v[2],

    s3 = sqrt( s1*s1 + s2*s2 - 2*s1*s2*cos(a3) )
  )
  [s1, s2, s3];

//! Compute the side lengths of a triangle given a side and two adjacent angles.
/***************************************************************************//**
  \param    v <decimal-list-3> A list, [a1, s3, a2], the side length
              and two adjacent angles.

  \returns  <decimal-list-3> A list of side lengths [s1, s2, s3].

  \details

    Each side length is opposite the corresponding vertex.

    \amu_eval ( object=triangle_asa2sss ${object_diagram_2d} )

    No validation is performed on the input values. If \p a1 and \p a2
    sum to 180° or more, the derived angle a3 = 180 - a1 - a2 is zero
    or negative and sin(a3) is zero or negative, causing division by
    zero or producing negative side lengths without warning.

  [Wikipedia]: https://en.wikipedia.org/wiki/Solution_of_triangles
*******************************************************************************/
function triangle_asa2sss
(
  v
) =
  let
  (
    a1 = v[0],
    s3 = v[1],
    a2 = v[2],

    a3 = 180 - a1 - a2,

    s1 = s3 * sin( a1 ) / sin( a3 ),
    s2 = s3 * sin( a2 ) / sin( a3 )
  )
  [s1, s2, s3];

//! Compute the side lengths of a triangle given a side, one adjacent and the opposite angle.
/***************************************************************************//**
  \param    v <decimal-list-3> A list, [a1, a2, s1], a side length,
              one adjacent and the opposite angle.

  \returns  <decimal-list-3> A list of side lengths [s1, s2, s3].

  \details

    Each side length is opposite the corresponding vertex.

    \amu_eval ( object=triangle_aas2sss ${object_diagram_2d} )

    No validation is performed on the input values. If \p a1 and \p a2
    sum to 180° or more, sin(a3) is zero or negative and division by
    zero or negative side lengths result without warning. If \p a1 is
    zero, division by sin(a1) also produces inf or nan.

  [Wikipedia]: https://en.wikipedia.org/wiki/Solution_of_triangles
*******************************************************************************/
function triangle_aas2sss
(
  v
) =
  let
  (
    a1 = v[0],
    a2 = v[1],
    s1 = v[2],

    a3 = 180 - a1 - a2,

    s2 = s1 * sin( a2 ) / sin( a1 ),
    s3 = s1 * sin( a3 ) / sin( a1 )
  )
  [s1, s2, s3];

//! Compute a set of vertex coordinates for a triangle given its side lengths in 2D.
/***************************************************************************//**
  \param    v <decimal-list-3> A list, [s1, s2, s3], the side lengths.

  \param    a <integer> The axis alignment index
              < \b x_axis_ci | \b y_axis_ci >.

  \param    cw <boolean> Order vertices clockwise.

  \returns  <points-2d> A list of vertex coordinates [v1, v2, v3],
            when \p cw = \b true, else [v1, v3, v2].

  \details

    Each side length is opposite the corresponding vertex. The triangle
    will be constructed with \em v1 at the origin. Side \em s2 will be
    on the 'x' axis or side \em s3 will be on the 'y' axis as
    determined by parameter \p a.

    \amu_eval ( object=triangle2d_sss2ppp ${object_diagram_2d} )

    No verification is performed to ensure that the given sides specify
    a valid triangle. See [Wikipedia] for more information.

  [Wikipedia]: https://en.wikipedia.org/wiki/Solution_of_triangles
*******************************************************************************/
function triangle2d_sss2ppp
(
  v,
  a  = x_axis_ci,
  cw = true
) =
  let
  (
    s1  = v[0],
    s2  = v[1],
    s3  = v[2],

    _   = assert
          (
            s1 > 0 && s2 > 0 && s3 > 0
            && s1 < s2+s3 && s2 < s1+s3 && s3 < s1+s2,
            "triangle2d_sss2ppp: sides must be positive and satisfy the triangle inequality."
          ),

    v1  = origin2d,

    v2  = (a == x_axis_ci) ?
          // law of cosines
          let(x = (-s1*s1 + s2*s2 + s3*s3) / (2*s2))
          [x, sqrt(s3*s3 - x*x)]
        : [0, s3],

    v3  = (a == x_axis_ci) ?
          [s2, 0]
          // law of cosines
        : let(y = (-s1*s1 + s2*s2 + s3*s3) / (2*s3))
          [sqrt(s2*s2 - y*y), y]
  )
    (cw == true) ? [v1, v2, v3] : [v1, v3, v2];

//! @}

//----------------------------------------------------------------------------//
// shape properties
//----------------------------------------------------------------------------//

//! \name Properties
//! @{

//! Compute the area of a triangle given its vertex coordinates in 2D.
/***************************************************************************//**
  \param    c <points-2d> A list of vertex coordinates [v1, v2, v3].

  \param    s <boolean> When \b true, return the signed area; when
              \b false (default), return the absolute area.

  \returns  <decimal> The area of the given triangle, signed when
            \p s = \b true.

  \details

    When \p s = \b true the sign encodes vertex ordering: negative for
    clockwise and positive for counter-clockwise, following the same
    convention as polygon_area(). When \p s = \b false the absolute
    value is returned regardless of vertex ordering.

  \amu_eval(${note_no_validation})
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
  \param    c <points-3d | points-2d>  A list of 3d or 2d vertex
              coordinates [v1, v2, v3].

  \param    d <integer> The number of dimensions [2:3].

  \returns  <point-3d | point-2d> The centroid coordinate.

  \details

    The output dimensionality is controlled by \p d:
    - \p d = \b 2 (default): returns a 2d point using only the x and y
      components of each vertex. When 3d coordinates are passed with the
      default \p d = \b 2, the z-component is silently discarded.
    - \p d = \b 3: returns a 3d point using x, y, and z components.
    - \p d = \b 0: auto-detects dimensionality as the minimum coordinate
      length across all three vertices, useful for mixed-dimension input.

    See [Wikipedia] for more information.

  \amu_eval(${note_no_validation})

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
  \param    c <points-2d> A list of vertex coordinates [v1, v2, v3].

  \returns  <point-2d> The incircle center coordinate [x, y].

  \details

    The interior point for which distances to the sides of the triangle
    are equal. See [Wikipedia] for more information.

  \amu_eval(${note_no_validation})

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
  \param    c <points-2d> A list of vertex coordinates [v1, v2, v3].

  \returns  <decimal> The incircle radius.

  \details

    See [Wikipedia] for more information.

  \amu_eval(${note_no_validation})

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
  \param    c <points-2d> A list of vertex coordinates [v1, v2, v3].

  \param    vi  <integer> The vertex index (1, 2, or 3). Returns the
                excircle center opposite vertex \p vi.

  \returns  <point-2d> The excircle center coordinate [x, y].

  \details

    A circle outside of the triangle specified by \p v1, \p v2, and \p
    v3, tangent to the side opposite vertex \p vi and tangent to the
    extensions of the other two sides away from vertex \p vi. Returns
    \b origin2d for any \p vi value other than 1, 2, or 3.
    See [Wikipedia] for more information.

  \amu_eval(${note_no_validation})

  [Wikipedia]: https://en.wikipedia.org/wiki/Incircle_and_excircles_of_a_triangle
*******************************************************************************/
function triangle2d_excenter
(
  c,
  vi = 1
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
    (vi == 1) ? [ ((-d1*v1[0]+d2*v2[0]+d3*v3[0])/(-d1+d2+d3)),
                  ((-d1*v1[1]+d2*v2[1]+d3*v3[1])/(-d1+d2+d3)) ]
  : (vi == 2) ? [ ((+d1*v1[0]-d2*v2[0]+d3*v3[0])/(+d1-d2+d3)),
                  ((+d1*v1[1]-d2*v2[1]+d3*v3[1])/(+d1-d2+d3)) ]
  : (vi == 3) ? [ ((+d1*v1[0]+d2*v2[0]-d3*v3[0])/(+d1+d2-d3)),
                  ((+d1*v1[1]+d2*v2[1]-d3*v3[1])/(+d1+d2-d3)) ]
  : origin2d;

//! Compute the exradius of a triangle's excircle in 2D.
/***************************************************************************//**
  \param    c <points-2d> A list of vertex coordinates [v1, v2, v3].

  \param    vi  <integer> The vertex index (1, 2, or 3). Returns the
                exradius of the excircle opposite vertex \p vi.

  \returns  <decimal> The excircle radius opposite vertex \p vi, or
            \b 0 for any \p vi value other than 1, 2, or 3.

  \details

    The exradius opposite vertex \p vi is computed from the semi-perimeter
    \em s and the three side lengths using the formula
    r_i = sqrt(s * (s-s_j) * (s-s_k) / (s-s_i)), where s_i, s_j, s_k
    are the sides opposite each vertex in order. See [Wikipedia] for
    more information.

  \amu_eval(${note_no_validation})

  [Wikipedia]: https://en.wikipedia.org/wiki/Incircle_and_excircles_of_a_triangle
*******************************************************************************/
function triangle2d_exradius
(
  c,
  vi = 1
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
    (vi == 1) ? sqrt(s * (s-d2) * (s-d3) / (s-d1))
  : (vi == 2) ? sqrt(s * (s-d1) * (s-d3) / (s-d2))
  : (vi == 3) ? sqrt(s * (s-d1) * (s-d2) / (s-d3))
  : 0;

//! Compute the coordinate of a triangle's circumcenter.
/***************************************************************************//**
  \param    c <points-3d | points-2d>  A list of 3d or 2d vertex
              coordinates [v1, v2, v3].

  \param    d <integer> The number of dimensions [2:3].

  \returns  <point-3d | point-2d> The circumcenter coordinate.

  \details

    The circumcenter is the center of the circumscribed circle — the
    circle that passes through all three vertices. The circumradius is
    the distance from the circumcenter to any vertex.

    The output dimensionality is controlled by \p d:
    - \p d = \b 2 (default): returns a 2d point using only the x and y
      components of each vertex. When 3d coordinates are passed with the
      default \p d = \b 2, the z-component is silently discarded.
    - \p d = \b 3: returns a 3d point using x, y, and z components.
    - \p d = \b 0: auto-detects dimensionality as the minimum coordinate
      length across all three vertices, useful for mixed-dimension input.

    See [Wikipedia] for more information.

  \amu_eval(${note_no_validation})

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

//! @}

//----------------------------------------------------------------------------//
// shape property tests
//----------------------------------------------------------------------------//

//! \name Tests
//! @{

//! Test the vertex ordering, or orientation, of a triangle in 2D.
/***************************************************************************//**
  \param    c <points-2d> A list of vertex coordinates [v1, v2, v3].

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
  \param    c <points-2d> A list of vertex coordinates [v1, v2, v3].

  \param    p <point-2d> A test point coordinate [x, y].

  \returns  <boolean> \b true when the point is strictly inside the
            triangle, \b false when it is strictly outside, and
            \b undef when the triangle is degenerate (collinear vertices).

  \details

    Uses barycentric coordinates to test point inclusion. Points that
    lie exactly on an edge or vertex of the triangle are considered
    \b outside (strict interior test); the boundary is excluded.

    Returns \b undef when the three vertices are collinear (zero-area
    triangle), matching the convention used by triangle2d_is_cw() and
    triangle2d_area().

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
    (d == 0) ? undef
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

//----------------------------------------------------------------------------//
// shape rounding
//----------------------------------------------------------------------------//

//! \name Rounding
//! @{

//! Compute the rounding center coordinate for a given radius of a triangle vertex in 2D.
/***************************************************************************//**
  \param    c <points-2d> A list of vertex coordinates [v1, v2, v3].

  \param    r <decimal> The vertex rounding radius.

  \returns  <point-2d> The rounding arc center coordinate for vertex v2.

  \details

    Computes the center of the circular arc of radius \p r that rounds
    the corner at vertex \b v2 (c[1]). The arc is tangent to both edges
    meeting at v2.

    \p r must satisfy \b 0 < r < ir, where \em ir is the triangle's
    inradius (triangle2d_inradius()). Passing r >= ir causes division by
    zero and is caught by an internal assert.

    \note Only vertex v2 (c[1]) is supported. To round v1 or v3, rotate
          the vertex list so that the target vertex is at c[1] before
          calling.
*******************************************************************************/
function triangle2d_vround3_center
(
  c,
  r
) = let
    (
      ir = triangle2d_inradius(c),
      _  = assert
           (
             r < ir,
             "triangle2d_vround3_center: r must be less than the inradius ir; r >= ir causes division by zero."
           )
    )
    (c[1]-r/(r-ir) * triangle2d_incenter(c)) * (ir-r)/ir;

//! Compute the rounding tangent coordinates for a given radius of a triangle vertex in 2D.
/***************************************************************************//**
  \param    c <points-2d> A list of vertex coordinates [v1, v2, v3].

  \param    r <decimal> The vertex rounding radius.

  \returns  <points-2d> A list [t1, t2] of the two tangent point
            coordinates where the rounding arc meets the edges at v2.

  \details

    Computes the two points on the edges adjacent to vertex \b v2
    (c[1]) at which a rounding arc of radius \p r is tangent. t1 lies
    on the edge v2 to v1 and t2 lies on the edge v2 to v3.

    \p r must satisfy \b 0 < r < ir (the triangle's inradius); this
    constraint is enforced by triangle2d_vround3_center(), which is
    called internally.

    \note Only vertex v2 (c[1]) is supported. See
          triangle2d_vround3_center() for the convention on rounding
          other vertices.
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

//! @}

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE validate;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <common/validation.scad>;

    echo( str("openscad version ", version()) );
    for (i=[1:16]) echo( "not tested:" );

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_term}.mfs;
    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

/*
BEGIN_SCOPE diagram;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <transforms/base_cs.scad>;
    include <tools/2d/drafting/draft-base.scad>;

    module dt (vl = empty_lst, al = empty_lst, sl = empty_lst)
    {
      s = 10;
      t = [6, 8, 7];
      r = min(t)/len(t)*s;

      c = triangle2d_sss2ppp(t)*s;

      draft_polygon(c, w=s*2/3);
      draft_axes([[0,12], [0,7]]*s, ts=s/2);

      for (i = [0 : len(c)-1])
      {
        cv = c[i];
        os = shift_cd(shift_cd(v=c, n=i, r=false), 1, r=false, d=true);

        if ( !is_empty( find( mv=i, v=vl )) )
        draft_dim_leader(cv, v1=[mean(os), cv], l1=5, t=str("v", i+1), s=0, cmh=s*1, cmv=s);

        if ( !is_empty( find( mv=i, v=al )) )
        draft_dim_angle(o=cv, r=r, v1=[cv, second(os)], v2=[cv, first(os)], t=str("a", i+1), a=0, cmh=s, cmv=s);

        if ( !is_empty( find( mv=i, v=sl )) )
        draft_dim_line(p1=first(os), p2=second(os), t=str("s", i+1), cmh=s, cmv=s);
      }
    }

    object = "triangle_sas2sss";

    if (object == "triangle_ppp2sss") dt( vl = [0,1,2]);
    if (object == "triangle_sas2sss") dt( vl = [0,1,2], al = [2], sl = [0,1]);
    if (object == "triangle_asa2sss") dt( vl = [0,1,2], al = [0,1], sl = [2]);
    if (object == "triangle_aas2sss") dt( vl = [0,1,2], al = [0,1], sl = [0]);
    if (object == "triangle2d_sss2ppp") dt( sl = [0,1,2]);
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_svg}.mfs;

    defines   name "objects" define "object"
              strings "
                triangle_ppp2sss
                triangle_sas2sss
                triangle_asa2sss
                triangle_aas2sss
                triangle2d_sss2ppp
              ";
    variables add_opts_combine "objects";
    variables add_opts "--viewall --autocenter";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
