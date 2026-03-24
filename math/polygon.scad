//! Polygon shapes, conversions, properties, and tests functions.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2015-2024,2026

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

    \amu_define group_name  (Polygons)
    \amu_define group_brief (Polygon mathematical functions; 2-polytope.)

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
  \amu_define note_p_not_defined
  (
    \note When \p p is not defined, the listed order of the coordinates
          will be used.
  )

  \amu_define warning_secondary_shapes
  (
    \warning  This function does not track secondary shapes subtraction
              as implemented by the polygon() function.
  )
*******************************************************************************/

// member-wide documentation and conventions
/***************************************************************************//**
  \addtogroup \amu_eval(${group})
  \details
  \anchor \amu_eval(${group})_conventions
  \par Conventions

    All functions in this group operate on polygons defined by a list
    of 2d cartesian coordinates \p c and an optional list of paths \p p,
    following OpenSCAD's native \c polygon() convention:

    - Coordinates are given as \c [[x,y], ...].
    - When \p p is not supplied, the listed order of the coordinates is
      used as the single implicit path; see the \c note_p_not_defined
      note attached to individual functions.
    - The primary (outer boundary) path is ordered \b counter-clockwise
      when viewed from above in the standard 2d coordinate system (y-up).
      Secondary (hole) paths must use the \b opposite winding to the
      primary path, matching the convention of OpenSCAD's \c polygon()
      and \c linear_extrude().
    - Shape-generation functions (polygon_regular_p(),
      polygon_trapezoid_p(), polygon_arc_sweep_p(),
      polygon_arc_fillet_p(), polygon_arc_blend_p(),
      polygon_elliptical_sector_p(), etc.) and curve-generation
      functions (polygon_bezier_p(), polygon_spline_p())
      default to \p cw = \b true and therefore produce \b clockwise
      output.  Callers that pass generated coordinates directly to \c
      polygon() or to property/test functions that assume CCW winding
      must either pass \p cw = \b false to the generator, or reverse
      the coordinate list after the fact.
    - Functions in this library that require a specific winding — such as
      polygon_linear_extrude_pf() — call polygon_is_clockwise() and
      normalise the winding internally; callers are \em not required to
      pre-normalise their input.
*******************************************************************************/

//----------------------------------------------------------------------------//
// members
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
// helper functions
//----------------------------------------------------------------------------//

//! Test whether vertex \p i of a polygon path forms a valid ear.
/***************************************************************************//**
  \param    c     <points-2d> A list of 2d cartesian coordinates [[x, y], ...].

  \param    path  <integer-list> An ordered list of coordinate indexes
                  defining the current (possibly reduced) polygon path.

  \param    i     <integer> The index into \p path of the candidate ear tip.

  \returns  <boolean> \b true if vertex \p path[\p i] is a valid ear tip,
            \b false otherwise.

  \details

    A vertex is a valid ear when two conditions both hold: the triangle
    formed by the previous, current, and next vertices is wound
    counter-clockwise (i.e. the tip is a convex vertex), and no other
    vertex remaining in \p path lies strictly inside that triangle.

    Assumes the path is wound counter-clockwise. If the input was
    clockwise it must be reversed before calling this function. The
    point-in-triangle test uses polygon_wn_is_p_inside() on the
    three-vertex triangle. Uses any_equal() to test whether any
    interior-point test returned \b true.

  \private
*******************************************************************************/
function _polygon_is_ear
(
  c,
  path,
  i
) =
  let
  (
    n   = len(path),
    ip  = (i == 0)   ? n-1 : i-1,
    in_ = (i == n-1) ? 0   : i+1,

    vp  = c[path[ip]],
    vc  = c[path[i]],
    vn  = c[path[in_]],

    // ear tip must be a convex vertex in CCW winding: vc is left of vp to vn
    convex = (is_left_ppp(vp, vn, vc) > 0),

    // triangle as a 3-point coordinate list for inclusion test
    tri = [vp, vc, vn],

    // no other path vertex may lie strictly inside the ear triangle
    no_interior =
      convex &&
      !any_equal
      (
        [for (j = [0 : n-1])
          if (j != ip && j != i && j != in_)
            polygon_wn_is_p_inside(c=tri, t=c[path[j]])
        ],
        true
      )
  )
  convex && no_interior;

//! Recursively triangulate a simple polygon path by ear clipping.
/***************************************************************************//**
  \param    c       <points-2d> A list of 2d cartesian coordinates
                    [[x, y], ...].

  \param    path    <integer-list> An ordered list of coordinate indexes
                    defining the current (possibly reduced) polygon path.
                    Must be wound counter-clockwise.

  \param    tris    <integer-list-list> Accumulated triangle list; pass
                    \b empty_lst on the initial call. Defaults to
                    \b empty_lst.

  \returns  <integer-list-list> A list of triangles [[i0, i1, i2], ...]
            where each entry is a CCW-wound triple of coordinate indexes
            into \p c.

  \details

    Implements the ear-clipping triangulation algorithm. At each step
    the first valid ear found in \p path is clipped: its triangle is
    appended to \p tris and its tip vertex is removed from \p path.
    Recursion continues until \p path is reduced to 3 vertices, at
    which point the final triangle is appended and the accumulated list
    is returned.

    Assumes \p path is wound counter-clockwise. The caller is
    responsible for normalizing winding before the initial call (see
    _polygon_cap_triangles()).

    In the degenerate case where no ear is found in a pass over all
    remaining vertices (which can occur for self-intersecting or
    otherwise malformed paths), a \b echo warning is emitted and the
    accumulated triangles so far are returned. This prevents infinite
    recursion at the cost of an incomplete triangulation.

  \private
*******************************************************************************/
function _polygon_clip_ears
(
  c,
  path,
  tris = empty_lst
) =
  let ( n = len(path) )
  (n == 3)
  ? concat(tris, [[path[0], path[1], path[2]]])
  : let
    (
      ear_i = first
              (
                [for (i = [0 : n-1]) if (_polygon_is_ear(c, path, i)) i]
              )
    )
    is_undef(ear_i)
    ? let
      (
        _ = echo("WARNING: _polygon_clip_ears: no ear found — path may be self-intersecting or degenerate. Triangulation is incomplete.")
      )
      tris
    : let
      (
        ip  = (ear_i == 0)   ? n-1 : ear_i-1,
        in_ = (ear_i == n-1) ? 0   : ear_i+1,

        tri      = [path[ip], path[ear_i], path[in_]],
        new_path = [for (j = [0 : n-1]) if (j != ear_i) path[j]]
      )
      _polygon_clip_ears(c, new_path, concat(tris, [tri]));

//! Triangulate one cap face of a polygon path for use with polyhedron().
/***************************************************************************//**
  \param    c      <points-2d> A list of 2d cartesian coordinates [[x, y], ...].

  \param    path   <integer-list> An ordered list of coordinate indexes
                   defining the polygon path to triangulate.

  \param    cw     <boolean> \b true if \p path is wound clockwise,
                   \b false if counter-clockwise.

  \param    flip   <boolean> When \b true each output triangle's vertex
                   order is reversed. Used to produce the top cap with
                   outward-pointing normals. Default \b false.

  \param    offset <integer> Added to every index in the output triangles.
                   Used to shift top cap indices into the upper z-layer.
                   Default \b 0.

  \returns  <integer-list-list> A list of triangles [[i0, i1, i2], ...]
            with \p offset applied to all indices, and winding reversed
            when \p flip is \b true. Returns \b empty_lst when
            triangulation fails (see _polygon_clip_ears()).

  \details

    Normalizes the path to CCW winding before ear clipping so that
    _polygon_clip_ears() and _polygon_is_ear() can assume a fixed
    winding. If the original path was CW the path is reversed prior to
    clipping. After clipping, each triangle's index order is reversed
    if \p flip is \b true, and \p offset is added to all indices to map
    into the correct z-layer of the polyhedron point list.

  \private
*******************************************************************************/
function _polygon_cap_triangles
(
  c,
  path,
  cw,
  flip   = false,
  offset = 0
) =
  let
  (
    norm_path = (cw == true) ? reverse(path) : path,

    raw_tris  = _polygon_clip_ears(c, norm_path),

    out_tris  =
      [
        for (tri = raw_tris)
          let (t = flip ? [tri[2], tri[1], tri[0]] : tri)
          [t[0] + offset, t[1] + offset, t[2] + offset]
      ]
  )
  (len(raw_tris) == 0) ? empty_lst : out_tris;

//! Compute the sequential edge index pairs for one or more polygon paths.
/***************************************************************************//**
  \param    pm <integer-list-list> A list of paths where each path is an
               ordered list of coordinate indexes into a coordinate array.

  \returns  <integer-list-list> A flat list of index pairs [[j, i], ...]
            where for each path of length \p n, \p j and \p i are
            consecutive coordinate indexes with wrap-around: the pair
            [n-1, 0] closes the polygon. The returned list is flat
            across all paths with no per-path grouping.

  \details

    Yields one index pair per vertex per path, representing the edge
    from vertex \p j (previous) to vertex \p i (current). The closing
    edge from the last vertex back to the first is always included.
    Callers dereference into their coordinate array as needed: \c
    c[pair[0]] and \c c[pair[1]].

    This helper contains no reference to a coordinate array; it
    operates purely on path index lists. It is the caller's
    responsibility to pass the correct \p pm, including any
    default-path construction via \c defined_or().

  \private
*******************************************************************************/
function _polygon_edge_indices
(
  pm
) =
  [
    for (k = pm)
      let (n = len(k))
      for (i = [0 : n-1])
        let (j = (i == 0) ? n-1 : i-1)
        [k[j], k[i]]
  ];

//! Compute the sequential vertex index triples for one or more polygon paths.
/***************************************************************************//**
  \param    pm <integer-list-list> A list of paths where each path is an
               ordered list of coordinate indexes into a coordinate array.

  \returns  <integer-list-list> A flat list of index triples
            [[prev, curr, next], ...] where for each path of length
            \p n, \p prev, \p curr, and \p next are consecutive
            coordinate indexes with wrap-around at both ends. The
            returned list is flat across all paths with no per-path
            grouping.

  \details

    Yields one index triple per vertex per path, representing the
    vertex neighborhood of \p curr: the preceding vertex \p prev and
    the following vertex \p next. Both ends wrap: at \p i=0, \p prev =
    \p n-1; at \p i = \p n-1, \p next = 0. Callers dereference into
    their coordinate array as needed: \c c[triple[0]], \c c[triple[1]],
    \c c[triple[2]].

    This helper contains no reference to a coordinate array; it
    operates purely on path index lists. It is the caller's
    responsibility to pass the correct \p pm, including any
    default-path construction via \c defined_or().

  \private
*******************************************************************************/
function _polygon_vertex_indices
(
  pm
) =
  [
    for (k = pm)
      let (n = len(k))
      for (i = [0 : n-1])
        let
        (
          prev = (i == 0)   ? n-1 : i-1,
          next = (i == n-1) ? 0   : i+1
        )
        [k[prev], k[i], k[next]]
  ];

//----------------------------------------------------------------------------//
// shape generation
//----------------------------------------------------------------------------//

//! \name Shapes
//! @{

//! Compute coordinates for an n-sided regular polygon in 2D.
/***************************************************************************//**
  \param    n   <integer> The number of sides.

  \param    r   <decimal> The circumradius of the circumcircle.

  \param    a   <decimal> The inradius of the incircle.

  \param    o   <point-2d> The center coordinate [x, y].

  \param    ao  <decimal> The rotational angular offset in degrees.

  \param    vr  <decimal> The vertex rounding radius. Each computed
                vertex is offset inward by \p vr / cos(180/\p n) along
                the radial direction from \p o to the vertex. This is
                correct for any value of \p o.

  \param    cw  <boolean> Vertex ordering. When \b true vertices are
                generated clockwise (decreasing angle from \p ao); when
                \b false they are generated counter-clockwise
                (increasing angle from \p ao). Always produces exactly
                \p n vertices.

  \returns  <points-2d> A list of exactly \p n coordinate points
            [[x, y], ...], one per polygon vertex.

  \details

    Both \p n and at least one of \p r or \p a must be provided. When
    neither \p r nor \p a is defined, the circumradius defaults to 0
    and an \em n-pointed degenerate polygon at \p o is returned.

    The radius can be specified by either the circumradius \p r or the
    inradius \p a. If both are specified, \p r is used.

    Vertex angles are computed as \p ao ± \p i × (360/\p n) for \p i in
    [0, n-1], giving exact uniform angular spacing with no
    floating-point accumulation across the range. The closing vertex at
    0° is always included.

    \b Example
    \code{.C}
    vr=5;

    hull()
    {
      for ( p = polygon_regular_p( r=20, n=5, vr=vr ) )
        translate( p )
        circle( r=vr );
    }
    \endcode

    See [Wikipedia] for more information.

  [Wikipedia]: https://en.wikipedia.org/wiki/Regular_polygon
*******************************************************************************/
function polygon_regular_p
(
  n,
  r,
  a,
  o = origin2d,
  ao = 0,
  vr,
  cw = true
) =
  let
  (
    s = is_defined(r) ? r
      : is_defined(a) ? a / cos(180/n)
      : 0,

    step = 360/n
  )
  [
    for (i = [0 : n-1])
      let
      (
        ai = (cw == true) ? ao - i*step : ao + i*step,
        v  = o + s * [cos(ai), sin(ai)]
      )
      is_undef(vr) ? v : v - vr/cos(180/n) * unit_l(v - o)
  ];

//! Compute coordinates along a line in 2D.
/***************************************************************************//**
  \param    p1 <point-2d> The line initial coordinate [x, y].

  \param    p2 <point-2d> The line terminal coordinate [x, y].

  \param    l <line-2d> The line or vector.

  \param    x <decimal-list | decimal> A list of \p x coordinates
              [\p x1, \p x2, ...] or a single \p x coordinate at which
              to interpolate along the line.

  \param    y <decimal-list | decimal> A list of \p y coordinates
              [\p y1, \p y2, ...] or a single \p y coordinate at which
              to interpolate along the line.

  \param    r <decimal-list | decimal> A list of ratios
              [\p r1, \p r2, ...] or a single ratio \p r. The position
              ratio along line \p p1 (\p r=\b 0) to \p p2 (\p r=\b 1).

  \param    fs  <decimal> A fixed segment size between each point along
                the line.

  \param    ft  <decimal> A fixed segment size between each point,
                centered, beginning at \p p1 and terminating at \p p2.

  \param    fn  <integer> A fixed number of equally spaced points.

  \returns  <points-2d> A list of coordinates points [[x, y], ...].
            Returns \b undef when the requested interpolation axis is
            degenerate for the given line orientation (see \details).

  \details

    Linear interpolation is used to compute each point along the line.
    The order of precedence for line specification is: \p l then \p p1
    and \p p2. The order of precedence for interpolation is: \p x, \p
    y, \p r, \p fs, \p ft, \p fn.

    When the line is vertical (delta-x ≈ 0), the interpolation axis
    switches to \em y. Querying by \p x on a vertical line returns \b
    undef. Querying by \p y on a horizontal line (zero delta-y) also
    returns \b undef. In all other cases a list of interpolated
    coordinates is returned.
*******************************************************************************/
function polygon_line_p
(
  p1 = origin2d,
  p2 = x_axis2d_uv,
  l,

  x,      // coordinate x [or vector of]
  y,      // coordinate y [or vector of]
  r,      // factor [0,1] [or vector of]

  fs,     // fixed size
  ft,     // fixed size centered and terminating
  fn = 1  // number
) =
  let
  (
    ip  = is_defined(l) ? line_ip(l) : p1,
    tp  = is_defined(l) ? line_tp(l) : p2,

    zdx = almost_eq_nv(tp[0], ip[0]),                         // is delta-x zero
    zdy = almost_eq_nv(tp[1], ip[1]),                         // is delta-y zero

    // axis: 'y' if zdx, else use 'x'
    a   = zdx ? 1 : 0,

    // sign / direction of line
    s   = (tp[a] > ip[a]) ? +1 : -1,

    pl  = is_defined(x) ? is_list(x) ? x : [x]
        : is_defined(y) ? is_list(y) ? y : [y]

        // list of ratios
        : is_defined(r) ?
          [for (i=is_list(r) ? r : [r]) (i*(tp[a]-ip[a])+ip[a])]

        // fixed segment size
        : is_defined(fs) ?
          let
          (
            // scale by line x-projection iff using 'x' (ie: zdx != 0)
            sx = fs * (zdx ? 1 : cos(angle_ll(x_axis2d_uv, s*[ip, tp])))
          )
          [for (i=[ip[a] : s*sx : tp[a]]) i]

        // fixed segment size centered
        : is_defined(ft) ?
          let
          (
            // scale by line x-projection iff using 'x' (ie: zdx != 0)
            sx = ft * (zdx ? 1 : cos(angle_ll(x_axis2d_uv, s*[ip, tp]))),
            // center offset
            co = ( abs(tp[a]-ip[a]) - sx*floor(abs(tp[a]-ip[a])/sx) )/2
          )
          [ip[a], for (i=[ip[a] + s*co : s*sx : tp[a]]) i, tp[a]]

        // fixed number
        : [for (i=[0:fn]) (i*(tp[a]-ip[a])/fn+ip[a])]
  )
    (a == 1) ?
    is_defined(x) ? undef                                     // (a == 1)
  : [ for (py = pl) interpolate2d_l_pp(ip, tp, y=py) ]        // interpolate for 'x'
  : is_defined(y) && zdy ? undef                              // (a == 0)
  : [ for (px = pl) interpolate2d_l_pp(ip, tp, x=px) ];       // interpolate for 'y'

//! Compute coordinates of an arc with constant radius between two vectors in 2D.
/***************************************************************************//**
  \param    r <decimal> The arc radius.

  \param    o <point-2d> The arc center coordinate [x, y].

  \param    v1  <line-2d | decimal> The arc start angle.
                A 2d line, vector, or decimal angle 1.

  \param    v2  <line-2d | decimal> The arc end angle.
                A 2d line, vector, or decimal angle 2.

  \param    fn  <integer> The number of [facets] \(optional\).

  \param    cw  <boolean> Sweep direction. When \b true the arc sweeps
                clockwise from the head of \p v1 to the head of \p v2;
                when \b false it sweeps counter-clockwise. The returned
                list always contains \p fn + 1 points (both endpoints
                included).

  \returns  <points-2d> A list of coordinates points [[x, y], ...].

  \details

    The arc coordinates will have radius \p r centered about \p o
    contained within the heads of vectors \p v1 and \p v2. The arc will
    start at the point coincident to \p v1 and will end at the point
    coincident to \p v2. When vectors \p v1 and \p v2 are parallel, or
    when the positive sweep angle is within the almost_eq_nv() tolerance
    of zero (nearly parallel), the sweep angle is forced to 360° and a
    full circle is returned. When \p fn is undefined, its value is
    determined by get_fn().

    \note To round a polygon corner with a tangent arc whose center is
          derived automatically from the corner geometry, use
          polygon_arc_fillet_p().

  [facets]: \ref get_fn()
*******************************************************************************/
function polygon_arc_sweep_p
(
  r  = 1,
  o  = origin2d,
  v1 = x_axis2d_uv,
  v2 = x_axis2d_uv,
  fn,
  cw = true
) =
  let
  (
    // number of arc facets
    naf = defined_or(fn, get_fn(r)),

    // create vectors if numerical angles have been specified.
    va1 = is_number(v1) ? [cos(v1), sin(v1)] : v1,
    va2 = is_number(v2) ? [cos(v2), sin(v2)] : v2,

    // arc positive start angle
    iap = angle_ll(x_axis2d_uv, va1, false),

    // positive arc sweep angle; treat near-zero as full circle
    vas = angle_ll(va2, va1, false),
    vap = almost_eq_nv(vas, 0) ? 360 : vas,

    // arc cw and ccw signed sweep step
    sas = (((cw == true) ? 0 : 360) - vap)/naf
  )
  [
    for (as = [0 : naf])
      let (aa = iap + as * sas)
      o + r * [cos(aa), sin(aa)]
  ];

//! Compute coordinates for a circular fillet arc between two rays in 2D.
/***************************************************************************//**
  \param    r   <decimal> The fillet radius. Must be greater than zero.

  \param    o   <point-2d> The corner coordinate [x, y] — the vertex where
                the two rays \p v1 and \p v2 meet.

  \param    v1  <line-2d | decimal> The first ray direction (incoming edge).
                A 2d line, vector, or decimal angle in degrees. The fillet
                begins at the tangent point on this ray.

  \param    v2  <line-2d | decimal> The second ray direction (outgoing edge).
                A 2d line, vector, or decimal angle in degrees. The fillet
                ends at the tangent point on this ray.

  \param    fn  <integer> The number of [facets] \(optional\). When
                undefined, its value is determined by get_fn() evaluated at
                the fillet radius \p r.

  \param    cw  <boolean> Point ordering. When \b true the returned list
                runs from the tangent point on \p v1 to the tangent point
                on \p v2 in the clockwise direction; when \b false the list
                is reversed to run counter-clockwise. Defaults to \b true,
                consistent with polygon_arc_sweep_p() and the other
                shape-generation functions in this group.

  \returns  <points-2d> A list of coordinates points [[x, y], ...] tracing
            the fillet arc from the tangent point on \p v1 to the tangent
            point on \p v2. Returns \b empty_lst when the two rays are
            (anti-)parallel within the almost_eq_nv() tolerance.

  \details

    A circular fillet of radius \p r is tangent to both rays \p v1 and
    \p v2 that originate at the corner vertex \p o. The function computes
    and returns only the arc of the fillet circle that lies between the
    two tangent points; it does \em not include the corner vertex \p o or
    the tangent points' projections back along the rays. The resulting
    point list can be spliced directly into a polygon path in place of the
    sharp corner at \p o to round it.

  [facets]: \ref get_fn()
*******************************************************************************/
function polygon_arc_fillet_p
(
  r  = 1,
  o  = origin2d,
  v1 = x_axis2d_uv,
  v2 = y_axis2d_uv,
  fn,
  cw = true
) =
  assert( r > 0, "polygon_arc_fillet_p: fillet radius r must be greater than zero." )
  let
  (
    // normalise v1 / v2 to unit direction vectors from o
    d1 = unit_l( is_number(v1) ? [cos(v1), sin(v1)] : (len(v1) == 2 && is_list(v1[0])) ? v1[1] - v1[0] : v1 ),
    d2 = unit_l( is_number(v2) ? [cos(v2), sin(v2)] : (len(v2) == 2 && is_list(v2[0])) ? v2[1] - v2[0] : v2 ),

    cos_full = d1 * d2,                                  // dot product
    sin_half = sqrt( max(0, (1 - cos_full) / 2) ),       // sin(α), always ≥ 0

    degenerate = almost_eq_nv(sin_half, 0)
  )
  degenerate ? empty_lst
  : let
    (
      // bisector unit vector (points "into" the corner, toward the fillet center)
      bisector = unit_l(d1 + d2),

      // distance from o to the fillet circle center along the bisector
      dist_to_center = r / sin_half,

      // fillet circle center
      fc = o + dist_to_center * bisector,

      // arc start angle: direction from fc toward the tangent point on v1
      cos_half = sqrt( max(0, (1 + cos_full) / 2) ),
      tan_half = sin_half / cos_half,

      tp1 = o + (r / tan_half) * d1,
      tp2 = o + (r / tan_half) * d2,

      // angles from fillet center to each tangent point
      a1 = angle_ll(x_axis2d_uv, tp1 - fc, false),
      a2 = angle_ll(x_axis2d_uv, tp2 - fc, false)
    )
    polygon_arc_sweep_p( r=r, o=fc, v1=a1, v2=a2, fn=fn, cw=cw );


//! Compute coordinates for a circular arc blend between two line segments in 2D.
/***************************************************************************//**
  \param    p1  <point-2d> The start point of the incoming segment [x, y].

  \param    p2  <point-2d> The corner vertex coordinate [x, y] — the point
                where the two segments meet.

  \param    p3  <point-2d> The end point of the outgoing segment [x, y].

  \param    r   <decimal> The blend radius. Must be greater than zero.

  \param    fn  <integer> The number of [facets] \(optional\). When
                undefined, its value is determined by get_fn() evaluated at
                the blend radius \p r.

  \param    cw  <boolean> Point ordering. When \b true the returned list
                runs from the tangent point on the incoming segment to the
                tangent point on the outgoing segment in the clockwise
                direction; when \b false the list is reversed to run
                counter-clockwise. Defaults to \b true, consistent with
                polygon_arc_fillet_p() and the other shape-generation
                functions in this group.

  \returns  <points-2d> A list of coordinate points [[x, y], ...] tracing
            the blend arc from the tangent point on the incoming segment
            to the tangent point on the outgoing segment. Returns
            \b empty_lst when the two segments are (anti-)parallel within
            the almost_eq_nv() tolerance.

  \details

    Computes a circular fillet arc of radius \p r that is tangent to
    both the incoming segment \p p1 to \p p2 and the outgoing segment
    \p p2 to \p p3. The returned arc replaces the sharp corner at \p p2
    and can be spliced directly into a polygon path to produce a
    rounded vertex.

    The function derives the incoming and outgoing ray directions from
    the three supplied points and delegates to polygon_arc_fillet_p().
    The corner vertex \p p2 is not included in the returned list; only
    the arc points between the two tangent points are returned.

    \b Example
    \code{.C}
    $fn = 32;

    c = [[0,0], [10,0], [10,10], [0,10]];

    // replace the corner at c[1] with a blend arc of radius 3
    blend = polygon_arc_blend_p( p1=c[0], p2=c[1], p3=c[2], r=3 );

    polygon( concat( [c[0]], blend, [c[2]], [c[3]] ) );
    \endcode

  [facets]: \ref get_fn()
*******************************************************************************/
function polygon_arc_blend_p
(
  p1,
  p2,
  p3,
  r  = 1,
  fn,
  cw = true
) =
  polygon_arc_fillet_p
  (
    r  = r,
    o  = p2,
    v1 = p2 - p1,
    v2 = p3 - p2,
    fn = fn,
    cw = cw
  );

//! Compute coordinates for an elliptical sector in 2D.
/***************************************************************************//**
  \param    r <decimal-list-2 | decimal> The elliptical radius. A list
              [rx, ry] of decimals where \p rx is the x-axis radius and
              \p ry is the y-axis radius, or a single decimal for
              (rx=ry).

  \param    o <point-2d> The center coordinate [x, y].

  \param    v1  <line-2d | decimal> The sector angle 1.
                A 2d line, vector, or decimal.

  \param    v2  <line-2d | decimal> The sector angle 2.
                A 2d line, vector, or decimal.

  \param    s <boolean> Use signed vector angle conversions. When
              \b false, positive angle conversion will be used.

  \param    fn  <integer> The number of [facets] \(optional\).

  \param    cw  <boolean> Coordinate point ordering. When \b true the
                returned list is in the natural computed order; when \b
                false the list is reversed.

  \returns  <points-2d> A list of coordinates points [[x, y], ...].

  \details

    The coordinates sweep from angle \p v1 to angle \p v2. When \p v1
    and \p v2 are equal, a full ellipse is returned. The sweep
    direction is determined by the signs of the angles; a positive
    delta sweeps counter-clockwise and a negative delta sweeps
    clockwise, regardless of the \p cw ordering parameter (which only
    controls whether the returned list is reversed).

    When \p v1 and \p v2 are not equal, the origin point \p o is
    prepended to the coordinate list, forming a closed pie-sector shape
    when passed directly to \c polygon(). For a full ellipse, \p o is
    omitted and the result is a closed ring of perimeter points.

    The parameter \p s controls how vector angles are converted to
    decimal degrees. When \p s = \b true (default), signed angle
    conversion is used, so vectors below the x-axis yield negative
    angles. When \p s = \b false, all angles are mapped to [0, 360).
    This affects sector orientation when \p v1 or \p v2 are given as 2d
    lines or vectors rather than explicit decimal angles.

    When \p fn is undefined, its value is determined by get_fn().

  [facets]: \ref get_fn()
*******************************************************************************/
function polygon_elliptical_sector_p
(
  r = 1,
  o = origin2d,
  v1 = x_axis2d_uv,
  v2 = x_axis2d_uv,
  s = true,
  fn,
  cw = true
) =
  let
  (
    rx  = defined_e_or(r, 0, r),
    ry  = defined_e_or(r, 1, rx),

    va1 = is_number(v1) ? v1 : angle_ll(x_axis2d_uv, v1, s),
    va2 = is_number(v2) ? v2 : angle_ll(x_axis2d_uv, v2, s),

    // full return when angles are equal
    va3 = (va1 == va2) ? va2+360 : va2,

    // number of arc facets
    af  = defined_or(fn, get_fn((rx+ry)/2)),

    // point generation ordering
    as  = (va3 > va1) ? [af:-1:0] : [0:af],

    // cw ordering
    pp =
    [
      if (va1 != va2) o,
      for (i = as)
        let (pa = ((af-i)*va1 + i*va3) / af)
        o + [rx*cos(pa), ry*sin(pa)]
    ]
  )
  (cw == true) ? pp : reverse(pp);

//! Compute the coordinates for a rounded trapezoid in 2D space.
/***************************************************************************//**
  \param    b <decimal-list-2 | decimal> The base lengths. A list [b1,
              b2] of 2 decimals or a single decimal for (b1=b2).

  \param    h <decimal> The perpendicular height between bases. Takes
              precedence over \p l when both are specified. When
              neither \p h nor \p l is specified, \p l defaults to 1.

  \param    l <decimal> The left side leg length. Used only when \p h
              is not specified; the resulting height is \p l × sin(\p
              a).

  \param    a <decimal> The angle in degrees between the lower base and
              the left leg. When \p h is specified, restricted to [45,
              135] to keep the upper-left vertex above the lower base.

  \param    o <point-2d> The origin offset coordinate [x, y].

  \param    cw  <boolean> Polygon vertex ordering.

  \returns  <points-2d> A list of exactly 4 coordinate points
            [[x, y], ...] defining the trapezoid vertices.

  \details

    The four vertices are computed from the origin \p o as follows: \p
    p1 = \p o (lower-left), \p p2 = upper-left leg endpoint, \p p3 = \p
    p2 + [\p b2, 0] (upper-right), \p p4 = \p o + [\p b1, 0]
    (lower-right). The lower base has length \p b1 and the upper base
    has length \p b2.

    When both \p h and \p l are specified, \p h takes precedence and
    the actual leg length is derived from \p h and \p a. When only \p l
    is given, the perpendicular height is \p l × sin(\p a). If \p h is
    specified, the angle \p a is restricted to the range [45, 135] to
    keep the upper-left vertex above the lower base.

    Special cases: when \p b is a single decimal (\p b1 = \p b2) and \p
    a = 90 the result is a rectangle; when additionally \p b1 = \p h
    the result is a square. When \p a ≠ 90 and \p b1 = \p b2 the result
    is a parallelogram.

    See [Wikipedia] for more general information on trapezoids.

  [Wikipedia]: https://en.wikipedia.org/wiki/Trapezoid
  [parallelograms]: https://en.wikipedia.org/wiki/Parallelogram
*******************************************************************************/
function polygon_trapezoid_p
(
  b = 1,
  h,
  l = 1,
  a = 90,
  o = origin2d,
  cw = true
) =
  assert
  (
    !( !is_undef(h) && !is_between(a, 45, 135) ),
    "given h, the angle a is restricted to the range [45, 135]."
  )
  let
  (
    b1 = defined_e_or(b, 0, b),
    b2 = defined_e_or(b, 1, b1),

    // trapezoid vertices from origin
    p1 = o,
    p2 = o  + (is_undef(h) ? l*[cos(a), sin(a)] : h*[cos(2*a - 90), 1]),
    p3 = p2 + [b2, 0],
    p4 = o  + [b1, 0],

    // cw ordering
    pp  = [p1, p2, p3, p4]
  )
  (cw == true) ? pp : reverse(pp);

//! @}

//----------------------------------------------------------------------------//
// curves
//----------------------------------------------------------------------------//

//! \name Curves
//! @{

//! Compute coordinates for a degree-n Bézier curve in 2D.
/***************************************************************************//**
  \param    c   <points-2d> A list of 2d control point coordinates
                [[x, y], ...]. The curve interpolates \p c[0] and
                \p c[last] and approximates the interior control points.
                Minimum 2 points required (degree 1, linear).

  \param    fn  <integer> The number of [facets] \(optional\). When
                undefined, its value is determined by get_fn() using the
                chord length of the control polygon as a proxy radius.

  \param    cw  <boolean> Point ordering. When \b true the returned list
                is in the natural computed order (t = 0 to 1); when \b
                false the list is reversed. Defaults to \b true.

  \returns  <points-2d> A list of \p fn + 1 coordinate points [[x, y], ...]
            sampled uniformly in the parameter \p t member of [0, 1], including
            both endpoints.

  \details

    Evaluates the Bézier curve defined by the control polygon \p c
    using the de Casteljau algorithm. The degree of the curve is
    `len(c) - 1`. Common cases:

    - Degree 1 (2 points): straight line segment.
    - Degree 2 (3 points): quadratic Bézier.
    - Degree 3 (4 points): cubic Bézier.
    - Higher degrees are supported but may exhibit Runge-like oscillation.

    The de Casteljau algorithm is used for its numerical stability. At
    each parameter value \p t it performs `degree` rounds of linear
    interpolation on the current level's point list until a single
    point remains. No external helper functions are required.

    \b Example
    \code{.C}
    $fn = 32;

    ctrl = [ [0,0], [5,20], [15,20], [20,0] ];

    polygon( polygon_bezier_p( c=ctrl ) );
    \endcode

  [facets]: \ref get_fn()
*******************************************************************************/
function polygon_bezier_p
(
  c,
  fn,
  cw = true
) =
  let
  (
    // chord-length sum as proxy for get_fn() radius
    chord = sum( [for (i = [0 : len(c)-2]) distance_pp( c[i], c[i+1] )] ),
    nf    = defined_or( fn, get_fn( chord / (2 * pi) ) ),

    // de Casteljau evaluation at parameter t in [0,1]
    // recursively interpolates the point list until one point remains
    de_casteljau =
      function (cp, t)
        (len(cp) == 1) ? cp[0]
        : de_casteljau
          (
            [for (i = [0 : len(cp)-2]) (1-t)*cp[i] + t*cp[i+1]],
            t
          ),

    pp =
      [
        for (i = [0 : nf])
          de_casteljau( c, i / nf )
      ]
  )
  (cw == true) ? pp : reverse(pp);

//! Compute coordinates for a Catmull-Rom spline through a list of knot points in 2D.
/***************************************************************************//**
  \param    c      <points-2d> A list of 2d knot coordinates [[x, y], ...].
                   The curve passes through every knot. Minimum 2 points
                   required. When \p closed is \b false the curve runs from
                   \p c[0] to \p c[last]; when \p closed is \b true it
                   also returns from \p c[last] back to \p c[0].

  \param    fn     <integer> The number of [facets] per segment \(optional\).
                   Each segment is the span between two consecutive knot
                   points. When undefined, the per-segment value is
                   determined by get_fn() evaluated at the segment chord
                   length divided by \p 2π.

  \param    closed <boolean> When \b true the spline is closed: a segment
                   is added from the last knot back to the first, and the
                   phantom knots at both ends are wrapped accordingly.
                   Defaults to \b false.

  \param    cw     <boolean> Point ordering. When \b true the returned list
                   is in the natural computed order; when \b false the list
                   is reversed. Defaults to \b true.

  \returns  <points-2d> A list of coordinate points [[x, y], ...] tracing
            the spline. For an open spline with \p n knots and \p fn facets
            per segment the list contains `(n-1) × fn + 1` points. For a
            closed spline it contains `n × fn` points (the closing knot is
            not duplicated).

  \details

    Implements the centripetal Catmull-Rom spline. Each interior segment
    \p i (from knot \p i to knot \p i+1) uses the four control points
    \p c[i-1], \p c[i], \p c[i+1], \p c[i+2] to form a smooth
    cubic. Phantom knots at the ends of an open spline are synthesised by
    reflecting: the phantom before \p c[0] mirrors \p c[1], and the
    phantom after \p c[last] mirrors \p c[last-1].

    \b Example
    \code{.C}
    $fn = 32;

    knots = [ [0,0], [5,10], [15,10], [20,0], [15,-10], [5,-10] ];

    polygon( polygon_spline_p( c=knots, closed=true ) );
    \endcode

  [facets]: \ref get_fn()
*******************************************************************************/
function polygon_spline_p
(
  c,
  fn,
  closed = false,
  cw     = true
) =
  let
  (
    n  = len(c),

    // build the augmented knot list with phantom end-points
    // open:   reflect c[1] before c[0] and c[n-2] after c[n-1]
    // closed: wrap last and first knots to the phantom positions
    kp =
      closed ?
        concat( [c[n-1]], c, [c[0]], [c[1]] )
      : concat( [2*c[0] - c[1]], c, [2*c[n-1] - c[n-2]] ),

    // number of segments
    ns = closed ? n : n - 1,

    // Catmull-Rom segment sampler; returns fn+1 or fn points
    //   kp  — augmented knot array
    //   seg — segment index (0-based, into original c)
    //   last_seg — true when this is the final segment of an open spline
    cr_seg =
      function (kp, seg, nf, last_seg)
        let
        (
          p0 = kp[seg],        // phantom / previous knot
          p1 = kp[seg+1],      // segment start knot
          p2 = kp[seg+2],      // segment end knot
          p3 = kp[seg+3],      // next / phantom knot

          end_i = last_seg ? nf : nf - 1
        )
        [
          for (i = [0 : end_i])
            let
            (
              t  = i / nf,
              t2 = t * t,
              t3 = t2 * t
            )
            0.5 * (
                2*p1
              + (-p0 + p2)               * t
              + (2*p0 - 5*p1 + 4*p2 - p3) * t2
              + (-p0 + 3*p1 - 3*p2 + p3)  * t3
            )
        ],

    pp =
      [
        for (seg = [0 : ns-1])
          let
          (
            chord  = distance_pp( c[seg % n], c[(seg+1) % n] ),
            nf     = defined_or( fn, max(1, get_fn( chord / (2*pi) )) ),
            last_s = (!closed) && (seg == ns-1)
          )
          for (pt = cr_seg(kp, seg, nf, last_s))
            pt
      ]
  )
  (cw == true) ? pp : reverse(pp);

//! @}

//----------------------------------------------------------------------------//
// shape properties
//----------------------------------------------------------------------------//

//! \name Properties
//! @{

//! Compute the perimeter of an n-sided regular polygon in 2D.
/***************************************************************************//**
  \param    n <integer> The number of sides.

  \param    r <decimal> The vertex circumradius of the circumcircle.

  \param    a <decimal> The inradius of the incircle.

  \returns  <decimal> Perimeter length of the n-sided regular polygon.

  \details

    The radius can be specified by either the circumradius \p r or the
    inradius \p a. If both are specified, \p r is used. Returns 0 when
    neither is defined.

    Formulae used:
    \code
      P = 2 × n × r × sin(180/n)   (from circumradius r)
      P = 2 × n × a × tan(180/n)   (from inradius a)
    \endcode
*******************************************************************************/
function polygon_regular_perimeter
(
  n,
  r,
  a
) = is_defined(r) ? 2 * n * r * sin(180/n)
  : is_defined(a) ? 2 * n * a * tan(180/n)
  : 0;

//! Compute the area of an n-sided regular polygon in 2D.
/***************************************************************************//**
  \param    n <integer> The number of sides.

  \param    r <decimal> The vertex circumradius of the circumcircle.

  \param    a <decimal> The inradius of the incircle.

  \returns  <decimal> Area of the n-sided regular polygon.

  \details

    The radius can be specified by either the circumradius \p r or the
    inradius \p a. If both are specified, \p r is used. Returns 0 when
    neither is defined.

    Formulae used:
    \code
      A = r² × n × sin(360/n) / 2   (from circumradius r)
      A = a² × n × tan(180/n)       (from inradius a)
    \endcode
*******************************************************************************/
function polygon_regular_area
(
  n,
  r,
  a
) = is_defined(r) ? pow(r, 2) * n * sin(360/n) / 2
  : is_defined(a) ? pow(a, 2) * n * tan(180/n)
  : 0;

//! Calculate the perimeter length of a polygon in 2d.
/***************************************************************************//**
  \param    c <points-2d> A list of 2d cartesian coordinates
              [[x, y], ...].

  \param    p <integer-list-list> An \em optional list of paths that
              define one or more closed shapes where each is a list of
              coordinate indexes.

  \returns  <decimal> The sum of all polygon primary and secondary
            perimeter lengths.

  \details

    Computes the total perimeter by summing the Euclidean distance
    between each consecutive pair of vertices in every path, including
    the closing edge from the last vertex back to the first. Uses
    _polygon_edge_indices() to enumerate edge pairs.

  \amu_eval (${note_p_not_defined})
*******************************************************************************/
function polygon_perimeter
(
  c,
  p
) =
  let
  (
    pm = defined_or(p, [consts(len(c))]),
    ei = _polygon_edge_indices(pm)
  )
  sum([for (e = ei) distance_pp(c[e[0]], c[e[1]])]);

//! Compute the signed area of a polygon in a Euclidean 2d-space.
/***************************************************************************//**
  \param    c <points-2d> A list of 2d cartesian coordinates
              [[x, y], ...].

  \param    p <integer-list-list> An \em optional list of paths that
              define one or more closed shapes where each is a list of
              coordinate indexes.

  \param    s <boolean> Return the signed area. When \b true the raw
              signed value is returned: negative for clockwise vertex
              ordering and positive for counter-clockwise. When \b
              false (default) the absolute area is returned.

  \returns  <decimal> The area of the given polygon.

  \details

    Uses the shoelace formula applied to all edge pairs enumerated by
    _polygon_edge_indices(). See [Wikipedia] for more information.

  \amu_eval (${note_p_not_defined})

  \amu_eval (${warning_secondary_shapes})

  [Wikipedia]: https://en.wikipedia.org/wiki/Shoelace_formula
*******************************************************************************/
function polygon_area
(
  c,
  p,
  s = false
) =
  let
  (
    pm = defined_or(p, [consts(len(c))]),
    ei = _polygon_edge_indices(pm),
    sa =  sum
          (
            [
              for (e = ei)
               (c[e[0]][0] + c[e[1]][0]) * (c[e[1]][1] - c[e[0]][1])
            ]
          ) / 2
  )
  (s == false) ? abs(sa) : sa;

//! Compute the area of a polygon in a Euclidean 3d-space.
/***************************************************************************//**
  \param    c <points-3d> A list of 3d cartesian coordinates
              [[x, y, z], ...].

  \param    p <integer-list-list> An \em optional list of paths that
              define one or more closed shapes where each is a list of
              coordinate indexes.

  \param    n <vector-3d> An \em optional normal vector, [x, y, z],
              to the polygon plane. When not given, a normal vector is
              constructed from the first three points of the primary
              path.

  \returns  <decimal> The area of the given polygon.

  \details

    Computes the area using a coordinate-projection method: the dominant
    axis of the polygon's normal vector is identified, the polygon is
    projected onto the perpendicular plane, and the 2D shoelace formula
    is applied with a correction factor derived from the normal vector
    magnitude. Function patterned after [Dan Sunday, 2012].

    When \p n is not supplied the normal is derived from the first three
    vertices of the primary path. An assertion is raised if those three
    vertices are collinear (i.e. the derived normal is the zero vector),
    because no valid projection axis exists in that case. Supply an
    explicit \p n to override when the first three vertices are known to
    be collinear but the polygon as a whole is non-degenerate.

  \amu_eval (${note_p_not_defined})

  \amu_eval (${warning_secondary_shapes})

  [Dan Sunday, 2012]: http://geomalgorithms.com/a01-_area.html
*******************************************************************************/
function polygon3d_area
(
  c,
  p,
  n
) =
  let
  (
    pm = defined_or(p, [consts(len(c))]),
    nv = defined_or(n, cross_ll([c[pm[0][0]], c[pm[0][1]]], [c[pm[0][0]], c[pm[0][2]]])),

    // planarity guard: the first three vertices must not be collinear when
    // n is derived automatically; a zero normal makes the projection axis
    // undefined and causes a division-by-zero in sf below.
    _check_planar =
    assert
    (
      distance_pp(nv) > 0,
      strl
      ([
        "polygon3d_area: first three vertices are collinear;",
        " cannot determine polygon plane. Supply an explicit normal n."
      ])
    ),

    ac = [abs(nv[0]), abs(nv[1]), abs(nv[2])],
    am = max(ac),
    ai = (am == ac[2]) ? 2 : (am == ac[1]) ? 1 : 0,

    pv = [
          for (k = pm) let (m = len(k))
            for (i=[1 : m])
              c[k[i%m]][(ai+1)%3] * (c[k[(i+1)%m]][(ai+2)%3] - c[k[(i-1)%m]][(ai+2)%3])
         ],

    sf = (distance_pp(nv)/(2*nv[ai]))
  )
  (sum(pv) * sf);

//! Compute the center of mass of a polygon in a Euclidean 2d-space.
/***************************************************************************//**
  \param    c <points-2d> A list of 2d cartesian coordinates
              [[x, y], ...].

  \param    p <integer-list-list> An \em optional list of paths that
              define one or more closed shapes where each is a list of
              coordinate indexes.

  \returns  <point-2d> The center of mass of the given polygon.

  \details

    Uses the shoelace-derived centroid formula applied to all edge pairs
    enumerated by _polygon_edge_indices(). See [Wikipedia] for more
    information.

  \amu_eval (${note_p_not_defined})

  \amu_eval (${warning_secondary_shapes})

  \warning  Returns \b undef (division by zero) for degenerate polygons
            with zero signed area, such as collinear point sets or
            self-intersecting shapes whose positive and negative areas
            cancel.

  [Wikipedia]: https://en.wikipedia.org/wiki/Centroid#Centroid_of_polygon
*******************************************************************************/
function polygon_centroid
(
  c,
  p
) =
  let
  (
    pm  = defined_or(p, [consts(len(c))]),
    ei  = _polygon_edge_indices(pm),
    cv  = [
            for (e = ei)
              let
               (
                 xc = c[e[0]][0],  yc = c[e[0]][1],
                 xn = c[e[1]][0],  yn = c[e[1]][1],
                 cd = xc*yn - xn*yc
               )
               [(xc + xn) * cd, (yc + yn) * cd]
          ],
    sc  = sum(cv),
    sa  = polygon_area(c, pm, true)
  )
  sc / (6 * sa);

//! Compute the winding number of a polygon about a point in a Euclidean 2d-space.
/***************************************************************************//**
  \param    c <points-2d> A list of 2d cartesian coordinates
              [[x, y], ...].

  \param    p <integer-list-list> An \em optional list of paths that
              define one or more closed shapes where each is a list of
              coordinate indexes.

  \param    t <point-2d> A test point coordinate [x, y].

  \returns  <integer> The winding number. Positive values indicate the
            point is enclosed by net counter-clockwise turns; negative
            values indicate net clockwise turns; zero means the point
            is outside the polygon.

  \details

    Computes the [winding number], the total number of counterclockwise
    turns that the polygon paths makes around the test point in a
    Euclidean 2d-space. Will be 0 \em iff the point is outside of the
    polygon. The result for a test point exactly on a polygon edge is
    implementation-defined. Uses _polygon_edge_indices() to enumerate
    edge pairs. Function patterned after [Dan Sunday, 2012].

  \note

    Copyright 2000 softSurfer, 2012 Dan Sunday This code may be freely
    used and modified for any purpose providing that this copyright
    notice is included with it. iSurfer.org makes no warranty for this
    code, and cannot be held liable for any real or imagined damage
    resulting from its use. Users of this code must verify correctness
    for their application.

    [Dan Sunday, 2012]: http://geomalgorithms.com/a03-_inclusion.html
    [winding number]: https://en.wikipedia.org/wiki/Winding_number

  \amu_eval (${note_p_not_defined})

  \warning  Where there are secondary paths, the vertex ordering of each
             must be the same as the primary path.
*******************************************************************************/
function polygon_winding
(
  c,
  p,
  t
) =
  let
  (
    pm = defined_or(p, [consts(len(c))]),
    ei = _polygon_edge_indices(pm),
    wv =  [
            for (e = ei)
              (c[e[0]][1] <= t[1] && c[e[1]][1] >  t[1] && is_left_ppp(c[e[0]], c[e[1]], t) > 0) ?  1
            : (c[e[0]][1] >  t[1] && c[e[1]][1] <= t[1] && is_left_ppp(c[e[0]], c[e[1]], t) < 0) ? -1
            : 0
          ]
  )
  sum(wv);

//! @}

//----------------------------------------------------------------------------//
// shape property tests
//----------------------------------------------------------------------------//

//! \name Tests
//! @{

//! Test the vertex ordering of a polygon in a Euclidean 2d-space.
/***************************************************************************//**
  \param    c <points-2d> A list of 2d cartesian coordinates
              [[x, y], ...].

  \param    p <integer-list-list> An \em optional list of paths that
              define one or more closed shapes where each is a list of
              coordinate indexes.

  \returns  <boolean> \b true if the vertex are ordered \em clockwise,
            \b false if the vertex are \em counterclockwise ordered, and
            \b undef if the ordering can not be determined.

  \details

    Uses the sign of the polygon's signed area (shoelace formula). A
    negative signed area indicates clockwise vertex ordering in the
    standard 2d coordinate system (y-up). Returns \b undef for
    degenerate polygons with zero signed area (e.g. collinear
    vertices).

    \note  Two separate winding conventions coexist in this library.
           Shape-generation functions (polygon_regular_p(),
           polygon_trapezoid_p(), polygon_elliptical_sector_p(), etc.)
           all default to \p cw = \b true, producing clockwise output.
           OpenSCAD's \c polygon() and \c linear_extrude() treat the
           primary path as counter-clockwise and hole paths as clockwise.
           Callers that bridge the two layers must reverse the coordinate
           list (or pass \p cw = \b false) as appropriate. Functions in
           this library that require a specific winding — such as
           polygon_linear_extrude_pf() — call polygon_is_clockwise()
           and normalise internally; callers are not required to
           pre-normalise their input.

  \amu_eval (${note_p_not_defined})
*******************************************************************************/
function polygon_is_clockwise
(
  c,
  p
) =
  let
  (
    sa = polygon_area(c, p, true)
  )
    (sa < 0) ? true
  : (sa > 0) ? false
  : undef;

//! Test the convexity of a polygon in a Euclidean 2d-space.
/***************************************************************************//**
  \param    c <points-2d> A list of 2d cartesian coordinates
              [[x, y], ...].

  \param    p <integer-list-list> An \em optional list of paths that
              define one or more closed shapes where each is a list of
              coordinate indexes.

  \returns  <boolean> \b true if the polygon is \em convex, \b false
            otherwise.

  \details

    Tests convexity by computing the cross product sign of each
    consecutive edge pair using _polygon_vertex_indices() to enumerate
    vertex triples. A polygon is convex when all cross products have
    the same sign (all left-turns or all right-turns). Collinear edges
    produce a cross product of zero, which counts as a distinct sign
    value and will cause the function to return \b false even for
    otherwise convex polygons with collinear points on an edge. Returns
    \b undef when \p c is undefined, has fewer than 3 points, or
    contains non-2d coordinates.

  \amu_eval (${note_p_not_defined})
*******************************************************************************/
function polygon_is_convex
(
  c,
  p
) = is_undef(c) ? undef
  : len(c) < 3  ? undef
  : !all_len(c, 2) ? undef
  : let
    (
      pm = defined_or(p, [consts(len(c))]),
      vi = _polygon_vertex_indices(pm),
      sv =  [
              for (triple = vi)
                sign
                (
                  cross_ll
                  (
                    [c[triple[0]], c[triple[1]]],
                    [c[triple[1]], c[triple[2]]]
                  )
                )
            ],
      us = unique(sv)
    )
    (len(us) == 1);

//! Test if a point is inside a polygon in a Euclidean 2d-space using winding number.
/***************************************************************************//**
  \param    c <points-2d> A list of 2d cartesian coordinates
              [[x, y], ...].

  \param    p <integer-list-list> An \em optional list of paths that
              define one or more closed shapes where each is a list of
              coordinate indexes.

  \param    t <point-2d> A test point coordinate [x, y].

  \returns  <boolean> \b true when the point is \em inside the polygon and
            \b false otherwise.

  \details

    Delegates to polygon_winding() and returns \b true when the winding
    number is non-zero. A winding number of zero indicates the point is
    outside all enclosed regions. The result for a test point exactly
    on a polygon edge is implementation-defined (see
    polygon_winding()).

  \amu_eval (${note_p_not_defined})

  \sa polygon_winding for warning about secondary shapes.
*******************************************************************************/
function polygon_wn_is_p_inside
(
  c,
  p,
  t
) = (polygon_winding(c=c, p=p, t=t) != 0);

//! Test if a point is inside a polygon in a Euclidean 2d-space using angle summation.
/***************************************************************************//**
  \param    c <points-2d> A list of 2d cartesian coordinates
              [[x, y], ...].

  \param    p <integer-list-list> An \em optional list of paths that
              define one or more closed shapes where each is a list of
              coordinate indexes.

  \param    t <point-2d> A test point coordinate [x, y].

  \returns  <boolean> \b true when the point is \em inside the polygon and
            \b false otherwise.

  \details

    Tests point inclusion by summing the signed angles subtended by
    each polygon edge as seen from the test point \p t. For a point
    strictly inside a simple polygon the absolute sum approximates
    360°; for a point outside it approximates 0°. The threshold used is
    180° to distinguish the two cases, which is reliable for
    non-degenerate simple polygons. Points exactly on an edge produce
    an undefined result.

    See [Wikipedia] for more information.

  \amu_eval (${note_p_not_defined})

  \amu_eval (${warning_secondary_shapes})

  [Wikipedia]: https://en.wikipedia.org/wiki/Point_in_polygon
*******************************************************************************/
function polygon_as_is_p_inside
(
  c,
  p,
  t
) =
  let
  (
    pm = defined_or(p, [consts(len(c))]),

    av =
    [
      for (k = pm) let (n = len(k))
        for (i=[0 : n-1])
        let
        (
          j = (i == 0) ? n-1 : i-1
        )
          angle_ll([t, c[k[i]]], [t, c[k[j]]])
    ],

    sa = abs(sum(av))
  )
  (sa > 180);

//! @}

//----------------------------------------------------------------------------//
// shape transforms
//----------------------------------------------------------------------------//

//! \name Transforms
//! @{

//! Convert a polygon in 2D to a polyhedron by adding a height dimension.
/***************************************************************************//**
  \param    c <points-2d> A list of 2d cartesian coordinates
              [[x, y], ...].

  \param    p <integer-list-list> An \em optional list of paths that
              define one or more closed shapes where each is a list of
              coordinate indexes.

  \param    h <decimal> The polyhedron height.

  \param    centroid  <boolean> Center polygon centroid at z-axis.

  \param    center  <boolean> Center polyhedron height about xy-plane.

  \returns  <datastruct> A structure <tt>[points, faces]</tt>, where
            \c points are <points-3d> and \c faces are a
            <integer-list-list>, suitable for use with \c polyhedron().

  \details

    Extrudes the 2D polygon into a closed 3D polyhedron by duplicating
    the coordinate list at two z-levels and constructing bottom, top,
    and side faces.

    Each path in \p p produces its own set of triangulated cap faces
    (bottom and top) via ear-clipping triangulation, and its own band
    of quad side faces. This correctly handles multi-path polygons with
    holes, provided hole paths carry winding opposite to the primary
    path, matching the convention used by \c polygon() and
    \c linear_extrude().

    Bottom cap triangles follow each path's own vertex winding; top cap
    triangles are reversed so that all face normals point outward.
    Side face quad winding is determined per-path by calling
    polygon_is_clockwise() on each path's coordinates and signed area.

    \warning  Triangulation uses ear clipping, which is correct for
              simple (non-self-intersecting) polygons only. If a path
              is self-intersecting, a warning is emitted via \b echo
              and the triangulation for that path will be incomplete,
              producing a non-manifold solid.

    \warning  An assertion is raised if any path is degenerate (zero
              signed area), because the winding direction cannot be
              determined and the resulting polyhedron faces would be
              incorrect. Degenerate paths include collinear vertex sets
              and self-intersecting shapes whose positive and negative
              areas cancel exactly.

    \note     Hole correctness depends on the caller providing hole
              paths with winding opposite to the primary path, matching
              the \c polygon() convention.

    When \p centroid is \b true, the polygon centroid is computed and
    subtracted from all x/y coordinates before extrusion, centering the
    shape on the z-axis.

    When \p center is \b true the z-range is [-h/2, h/2]; otherwise it
    is [0, h].

  \amu_eval (${note_p_not_defined})
*******************************************************************************/
function polygon_linear_extrude_pf
(
  c,
  p,
  h = 1,
  centroid = false,
  center = false
) =
  let
  (
    pm  = defined_or(p, [consts(len(c))]),
    pn  = len([for (pi = pm) for (ci = pi) 1]),   // total vertex count across all paths

    po  = (centroid == true) ? polygon_centroid(c, p) : origin2d,
    zr  = (center == true) ? [-h/2, h/2] : [0, h],

    // per-path flat index base within one z-layer
    po_offsets =
      [
        for (i = [0 : len(pm)-1])
          len([for (j = [0 : i-1]) for (ci = pm[j]) 1])
      ],

    // per-path winding: true = clockwise, determined via polygon_is_clockwise()
    // so that this function stays consistent with the public API.  An explicit
    // assert guards the undef case (degenerate / zero-area path) so that the
    // silent (undef < 0) == false fallback can never produce wrong face winding.
    cw_per_path =
      [
        for (pi = pm)
        let (cw = polygon_is_clockwise(c, [pi]))
        assert
        (
          !is_undef(cw),
          "degenerate path (zero signed area) — winding cannot be determined."
        )
        cw
      ],

    // points: z=zr[0] layer followed by z=zr[1] layer, preserving path order
    pp =
      [
        for (zi = zr) for (pi = pm)
          for (ci = pi) concat(c[ci] - po, zi)
      ],

    pf =
    [
      // bottom cap: ear-clipped triangles per path, base winding
      for (k = [0 : len(pm)-1])
        for (tri = _polygon_cap_triangles
                   (
                     c      = c,
                     path   = pm[k],
                     cw     = cw_per_path[k],
                     flip   = false,
                     offset = po_offsets[k]
                   ))
        tri,

      // top cap: ear-clipped triangles per path, winding reversed for outward normals
      for (k = [0 : len(pm)-1])
        for (tri = _polygon_cap_triangles
                   (
                     c      = c,
                     path   = pm[k],
                     cw     = cw_per_path[k],
                     flip   = true,
                     offset = po_offsets[k] + pn
                   ))
        tri,

      // side faces: one quad per edge, per path, no cross-path index bleed
      for (k = [0 : len(pm)-1])
        let (pi = pm[k], pl = len(pi), base = po_offsets[k])
        for (li = [0 : pl-1])
          let (ci = base + li, ni = base + (li+1)%pl)
          (cw_per_path[k] == true) ?
            [ci, ci+pn, ni+pn, ni]
          : [ci, ni, ni+pn, ci+pn]
    ]
  )
  [pp, pf];

//! @}

//----------------------------------------------------------------------------//
// profiles
//----------------------------------------------------------------------------//

//! \name Profiles
//! @{

//! Compute coordinates for a constant radius vertex round between two edge vectors in 2D.
/***************************************************************************//**
  \param    r <decimal> The round radius.

  \param    m <integer> The round mode.

  \param    o <point-2d> The vertex coordinate [x, y] at which the two
              edge vectors meet (the corner being rounded).

  \param    v1  <line-2d | decimal> The first edge direction.
                A 2d line, vector, or decimal angle.

  \param    v2  <line-2d | decimal> The second edge direction.
                A 2d line, vector, or decimal angle.

  \param    fn  <integer> The number of [facets] \(optional\).

  \param    cw  <boolean> Coordinate point ordering. When \b true the
                list runs from the inflection point on edge 1 toward
                the inflection point on edge 2; when \b false the order
                is reversed.

  \returns  <points-2d> A list of coordinates points [[x, y], ...]
            beginning at the inflection point on \p v1, followed by the
            arc (or chamfer) segment, and ending at the inflection point
            on \p v2. These points replace the original corner vertex
            in a polygon path.

  \details

    Computes the replacement coordinate sequence for a single polygon
    corner at \p o between edges \p v1 and \p v2. Normally, edge angle
    1 should be less than edge angle 2.

    The round mode may be one of the following:

     mode | name        | description
     :---:|:-----------:|:--------------------------------
       1  | fillet      | concave arc (inward, tangent to both edges)
       2  | round       | convex arc (outward, tangent to both edges)
       3  | chamfer     | straight bevel between the two inflection points

  [facets]: \ref get_fn()
*******************************************************************************/
function polygon_round_eve_p
(
  r  = 1,
  m  = 1,
  o  = origin2d,
  v1 = x_axis2d_uv,
  v2 = y_axis2d_uv,
  fn,
  cw = true
) =
  let
  (
    // create vectors if numerical angles have been specified.
    va1 = is_number(v1) ? [cos(v1), sin(v1)] : v1,
    va2 = is_number(v2) ? [cos(v2), sin(v2)] : v2,

    // triangle coordinates for edge corner in cw order
    etc = [o + r*unit_l(va1), o, o + r*unit_l(va2)],

    // tangent circle radius
    tcr = (m == 1) ?triangle2d_exradius(etc, 2) : 0,

    // tangent circle center coordinate
    tcc = (m == 1) ?(o-r/(r-tcr) * triangle2d_excenter(etc, 2)) * (tcr-r)/tcr : o,

    // distance from vertex to inflection points
    vim = (m == 1) ? sqrt( pow(distance_pp(o, tcc),2) - pow(r,2) ) : r,

    // inflection coordinates
    tc1 = o + vim*unit_l(va1),
    tc2 = o + vim*unit_l(va2),

    // vertex rounding coordinate point list
    vpl = (m == 1) ? polygon_arc_sweep_p(r=r, o=tcc, v1=[tcc, tc1], v2=[tcc, tc2], fn=fn, cw=true)
        : (m == 2) ? polygon_arc_sweep_p(r=r, o=tcc, v1=[tcc, tc1], v2=[tcc, tc2], fn=fn, cw=false)
        : empty_lst,

    // cw ordering
    pp = concat([tc1], vpl, [tc2])
  )
  (cw == true) ? pp : reverse(pp);

//! Compute coordinates that round all of the vertices between each adjacent edges in 2D.
/***************************************************************************//**
  \param    c <points-2d> A list of \em n 2d cartesian coordinates
              [[x1, y1], [x2, y2], ..., [xn, yn]].

  \param    vr  <decimal-list-n | decimal> The vertices rounding radius.
                A list [v1r, v2r, v3r, ... vnr] of \em n decimals or a
                single decimal for (v1r=v2r=v3r= ... =vnr). Undefined
                vertices are not rounded.

  \param    vrm <integer-list-n | integer> The vertices rounding mode.
                A list [v1rm, v2rm, v3rm, ... vnrm] of \em n integers
                or a single integer for (v1rm=v2rm=v3rm= ... =vnrm).
                Mode 0 returns the vertex coordinate unchanged and
                disables rounding for that vertex regardless of \p vr.
                Undefined vertices are not rounded.

  \param    vfn <integer-list-n> The vertices arc fragment number.
                A list [v1fn, v2fn, v3fn, ... vnfn] of \em n integers
                or a single integer for (v1fn=v2fn=v3fn= ... =vnfn).
                When any \p vfn entry is \b undef, the special
                variables \p $fa, \p $fs, and \p $fn control facet
                generation for that vertex.

  \param    w <boolean> Wrap-at-end during 3-point coordinate selection.
              When \b true (default), the first and last vertices are
              included in the rounding sequence, connecting the polygon
              end back to its start. When \b false, the first and last
              vertices are returned unmodified, which is useful for
              open paths where the endpoints should remain fixed.

  \param    cw  <boolean> Polygon vertex ordering.

  \returns  <points-2d> A new list of coordinates points [[x, y], ...]
            that define the polygon with rounded vertices.

  \details

    Assumes polygon is defined in 2D space on the x-y plane. There
    should be no repeating adjacent vertices along the polygon path
    (ie: no adjacent vertex with identical coordinates). Any vertex
    determined to be collinear with its adjacent previous and next
    vertex is returned unmodified.

    Each vertex may be individually rounded using one of the following
    modes:

     mode | name                |        description
     :---:|:-------------------:|:--------------------------------------
       0  | none                | return vertex unchanged
       1  | round               | previous to next edge round
       2  | e-hollow / i-circle | previous to next edge inverse round
       3  | n-fillet            | next edge pass return fillet
       4  | p-fillet            | previous edge pass return fillet
       5  | chamfer             | previous to next edge bevel
       6  | e-circle / i-hollow | previous to next edge inverse round
       7  | n-round             | next edge pass return round
       8  | p-round             | previous edge pass return round
       9  | n-chamfer           | next edge pass return bevel
      10  | p-chamfer           | previous edge pass return bevel

    The following diagrams demonstrate each rounding mode by on the
    upper right vertex of a rectangular polygon.

    \amu_define  title          (Rounding modes)
    \amu_combine image_views    (prefix="top" "1 2 3 4 5 6 7 8 9 10")
    \amu_define  image_size     (vga)
    \amu_define  scope_id       (polygon_round_eve_all_p_modes)
    \amu_define  output_scad    (false)
    \amu_define  html_image_w   (128)
    \amu_define  image_columns  (5)

    \amu_include (include/amu/scope_diagrams_3d.amu)

    \amu_undefine               (html_image_w image_columns)

    Vertex arc fragments can be specified using \p vfn. When any \p vfn
    entry is \b undef, the special variables \p $fa, \p $fs, and \p $fn
    control facet generation. Each vertex is processed using 3-point
    selection (the previous and following vertex). Collinear vertices
    (where the previous, current, and next points are co-linear) are
    automatically detected and returned unmodified regardless of the
    specified \p vr and \p vrm values. The resulting triangle \ref
    triangle2d_incenter "incircles" and \ref triangle2d_excenter
    "excircles" are used to create the round and fillet \ref
    polygon_arc_sweep_p "arc" segments. All arcs and chamfers use constant
    radius.

    \amu_define title           (Rounding example)
    \amu_define image_views     (top)
    \amu_define image_size      (sxga)
    \amu_define scope_id        (polygon_round_eve_all_p_example)
    \amu_define output_scad     (true)

    \amu_include (include/amu/scope_diagrams_3d.amu)
*******************************************************************************/
function polygon_round_eve_all_p
(
  c,
  vr = 0,
  vrm = 1,
  vfn,
  w = true,
  cw = true
) =
  let
  (
    // constant vertex rounding radius, mode, and facets
    crr = is_scalar(vr) ? vr : 0,
    crm = is_scalar(vrm) ? vrm : 0,
    cfn = is_scalar(vfn) ? vfn : undef,

    // function assumes cw order, reverse if required
    cp  = (cw == true) ? c : reverse(c),

    // adjacent vertices sequence [ [v[n-1], v[n], v[n+1]] ... ]
    avl = sequence_ns(cp, 3, w=w),

    // polygon coordinate point list
    ppl =
    [
      for ( i = [0 : len(avl)-1] )
      let
      (
        av  = avl[i],                     // vertices [vp, vc, vn]

        vp  = first(av),                  // vertex coordinate v[n-1]
        vc  = second(av),                 // vertex coordinate v[n]
        vn  = third(av),                  // vertex coordinate v[n+1]

        il  = is_left_ppp(vp, vn, vc),    // identify position of vc

        rr  = defined_e_or(vr, i, crr),   // vertex rounding radius
        rm  = (rr == 0) ? 0               // vertex rounding mode
            : (il == 0) ? 0               // vp,vc,vn collinear, set rm=0
            : defined_e_or(vrm, i, crm),
        fn  = defined_e_or(vfn, i, cfn),  // vertex rounding arc fragments

        // reverse arc sweep on interior corners
        // not relevant for rm={0|5|9|10}
        ras = (il < 0),

        // tangent circle radius
        tcr = (rm == 0) ? 0
            : (rm == 1 || rm == 2) ?
              triangle2d_inradius(av)
            : (rm == 3) ?
              triangle2d_exradius(av, 1)
            : (rm == 4) ?
              triangle2d_exradius(av, 3)
            : 0,

        // tangent circle center coordinate
        tcc = (rm == 0) ? origin2d
            : (rm == 1 || rm == 2) ?
              (vc-rr/(rr-tcr) * triangle2d_incenter(av)) * (tcr-rr)/tcr
            : (rm == 3) ?
              (vc-rr/(rr-tcr) * triangle2d_excenter(av, 1)) * (tcr-rr)/tcr
            : (rm == 4) ?
              (vc-rr/(rr-tcr) * triangle2d_excenter(av, 3)) * (tcr-rr)/tcr
            : origin2d,

        // distance from vertex to inflection points
        vim = (rm == 0) ? 0
            : (rm <= 4) ?
              sqrt( pow(distance_pp(vc, tcc),2) - pow(rr,2) )
            : rr,

        // inflection coordinates
        tc1 = (rm == 0 || rm > 10) ? origin2d
            : (rm == 3 || rm == 7 || rm == 9) ?
              vc + vim * unit_l([vp, vc])
            : vc + vim * unit_l([vc, vp]),

        tc2 = (rm == 0 || rm > 10) ? origin2d
            : (rm == 4 || rm == 8 || rm == 10) ?
              vc + vim * unit_l([vn, vc])
            : vc + vim * unit_l([vc, vn]),

        // vertex rounding coordinate point list
        vpl = (rm == 0 || rm > 10) ? [vc]
            : (rm == 1) ?
              polygon_arc_sweep_p(r=rr, o=tcc, v1=[tcc, tc1], v2=[tcc, tc2], fn=fn, cw=!ras)
            : (rm == 2 || rm == 3 || rm == 4) ?
              polygon_arc_sweep_p(r=rr, o=tcc, v1=[tcc, tc1], v2=[tcc, tc2], fn=fn, cw=ras)
            : (rm == 6 || rm == 7 || rm == 8) ?
              polygon_arc_sweep_p(r=rr, o=vc, v1=[vc, tc1], v2=[vc, tc2], fn=fn, cw=!ras)
            : [tc1, tc2]
      )
      vpl
    ],

    // polygon points
    pp = merge_s( ppl )
  )
  (cw == true) ? pp : reverse(pp);

//! Generate 2D coordinate points along a line with periodic waveform lateral displacement.
/***************************************************************************//**
  \param    p1  <point-2d> The line initial coordinate [x, y].

  \param    p2  <point-2d> The line terminal coordinate [x, y].

  \param    p <decimal> Period length; One full waveform cycle spans
              this distance along the line arc length.

  \param    a <decimal-list-3 | decimal> Amplitude configuration; a
              list [\p ma, \p na, \p oa] or a single decimal for (\p
              ma) (see below).

  \param    w <datastruct | integer> Waveform shape configuration;
              a list [\p shape, ...] or a single integer for (\p shape)
              (see below).

  \param    m <datastruct | integer> Time-axis remapping mode
              configuration; a list [\p remap, ...] or a single integer
              for (\p remap) (see below).

  \param    t <decimal-list-2 | decimal> Sampling range configuration;
              a list [\p t_min, \p t_max] or a single decimal for (\p
              t_min) (see below).

  \param    fn  <integer> Period fragment count; overrides the
                automatically computed step count (see below).

  \returns  <points-2d> A list of coordinate points [[x, y], ...]
            representing the waveform-displaced line, suitable for
            direct use with \c polygon().

  \details

    Computes a sequence of 2D points by walking arc-length steps along
    the line defined by \p p1 and \p p2, displacing each point
    laterally (perpendicular to the line direction) by a shaped
    periodic waveform. The unit normal direction is 90° CCW from the
    line tangent.

    The displacement formula applied at each point is:

    \code
      offset = oa + ma × sign(wave) × |wave|^(1/na)
    \endcode

    where \c wave is the waveform value at the remapped period position
    \c u member of [0, 1).

    Packed parameters \p a, \p w, \p m, and \p t each accept either a
    single scalar (selecting only the primary value) or a list where
    each index corresponds to a sub-parameter as described in the
    sections below.

    ## Multi-value and structured parameters

    ### a

      e | data type | default value | parameter description
    ---:|:---------:|:-------------:|:------------------------------------
      0 | decimal   | 1             | \p ma : maximum amplitude; peak perpendicular displacement from the line
      1 | decimal   | 1             | \p na : nonlinear amplitude exponent; applied after waveform evaluation
      2 | decimal   | 0             | \p oa : perpendicular offset; shifts the entire waveform baseline

    #### a[1]:na

      v | description
    ---:|:---------------------------------------
     <1 | peaks flatten, waveform widens
     =1 | linear, no reshaping
     >1 | peaks sharpen, waveform narrows

    ### w

    #### Shape selection

      v | shape            | sub-parameters
    ---:|:----------------:|:-------------------:
      0 | none             | (no displacement)
      1 | sine             | -
      2 | triangle         | -
      3 | square           | -
      4 | sawtooth         | -
      5 | sawtooth reverse | -
      6 | pulse            | \p duty
      7 | trapezoid        | \p rise, \p hold, \p fall
      8 | sine abs         | -
      9 | sine half        | -
     10 | lookup table     | \p lut

    All waveforms are normalized to [-1, 1] before amplitude scaling,
    so \p ma always represents the true peak displacement regardless of
    shape.

    #### Sub-parameters: pulse (shape=6)

      e | data type | default value | parameter description
    ---:|:---------:|:-------------:|:------------------------------------
      1 | decimal   | 1/2           | \p duty : fraction of the period spent at +1; range (0, 1)

    #### Sub-parameters: trapezoid (shape=7)

      e | data type | default value | parameter description
    ---:|:---------:|:-------------:|:------------------------------------
      1 | decimal   | 1/4           | \p rise : fraction of the period ramping from -1 to +1
      2 | decimal   | \p rise       | \p hold : fraction of the period at +1 (top hold)
      3 | decimal   | \p hold       | \p fall : fraction of the period ramping from +1 to -1

    \warning  \p w_rise + \p w_hold + \p w_fall must be <= 1.0. The
              remainder is the implicit bottom-hold duration.

    #### Sub-parameters: lookup table (shape=10)

      e | data type    | default value | parameter description
    ---:|:------------:|:-------------:|:------------------------------------
      1 | decimal-list | [0, 1]        | \p lut : list of amplitude values defining one period

    The values should be in [-1, 1] with a minimum 2 entries. The table
    is treated as periodic with interpolation between the last and
    first entry handles smooth looping

    ### m

    #### Mode selection

      v | mode  | description                                                               | sub-parameters
    ---:|:-----:|:-------------------------------------------------------------------------:|:---------------
      0 | none  | no remapping; waveform evaluated at natural u                             | -
      1 | phase | shifts peak and zero-crossings by a period fraction                       | \p shift
      2 | skew  | warps time axis; peak repositioned, zero-crossings fixed at boundaries    | \p shift
      3 | blend | interpolates in u-space between phase and skew before waveform evaluation | \p phase, \p skew, \p blend

    #### Sub-parameters: phase (mode=1)

      e | data type | default value | parameter description
    ---:|:---------:|:-------------:|:------------------------------------
      1 | decimal   | 1/2           | \p shift : fraction of the period to shift

    The range is [0, 1] where \b 0.0 = no shift, \b 0.5 = half-period
    shift (waveform inverts), \b 1.0 = full shift identical to \b 0.0.

    #### Sub-parameters: skew (mode=2)

      e | data type | default value | parameter description
    ---:|:---------:|:-------------:|:------------------------------------
      1 | decimal   | 1/2           | \p shift : fractional position within the period where the peak lands

    The range is (0, 1), clamped internally at \p grid_fine with \b
    0.25 = fast rise / slow fall, \b 0.5 = symmetric no skew, \b 0.75 =
    slow rise / fast fall.

    #### Sub-parameters: blend (mode=3)

      e | data type | default value | parameter description
    ---:|:---------:|:-------------:|:------------------------------------
      1 | decimal   | 1/2           | \p phase : phase-shift amount
      2 | decimal   | 1/2           | \p skew : skew target position
      3 | decimal   | 1/2           | \p blend : interpolation weight

    In blend mode, three sub-parameters work together to shape the
    waveform. \p phase shifts the peak and zero-crossings together by a
    fraction of the period, range [0, 1]. \p skew warps the time axis
    to reposition the peak at a fractional position within the period
    while the zero-crossings remain fixed at the period boundaries,
    range (0, 1). \p blend controls the interpolation weight between
    the two axes; \b 0.0 yields pure phase shift, \b 1.0 yields pure
    skew, and \b 0.5 applies an equal mix of both.

    ### t

      e | data type | default value | parameter description
    ---:|:---------:|:-------------:|:------------------------------------
      0 | decimal   | 0             | \p t_min : start of the sampling range;
      1 | decimal   | \p t_min + 1  | \p t_max : end of the sampling range;

    The arc length at \p t_min = \p t_min × \|p2 - p1\|; \b 0.0 =
    starts at \p p1; negative values extend behind \p p1. The arc
    length at \p t_max = \p t_max × \|p2 - p1\|; \b 1.0 = ends at \p
    p2; values above \b 1.0 extend beyond \p p2.

    The waveform phase is continuous across both boundaries. Period
    counting begins at \p p1 (t=0) and extends in both directions.
    Setting \p t_min < 0 or \p t_max > 1 does not clamp; the line
    direction and waveform extend naturally and indefinitely in either
    direction. The segment \p p1 to \p p2 defines orientation and scale
    only; it is not a hard boundary.

    ### fn

    When undefined, the fragment count is derived from \p get_fn(\p
    ma). See get_fn() for more information.

    The total number of sampled points is:

    \code
      steps = ceil( (len × (t_max - t_min) / p) × fn ) + 1
    \endcode

    where \p len = \|p2 - p1\|. Choosing an appropriate value:

    - \b Period: at minimum 20 fragments per period for smooth sine
      curves; sawtooth and triangle need fewer.
    - \b Nonlinearity: for \p na > 3, consider doubling the base
      fragment count to resolve sharp peaks.
    - \b Waveform: square and pulse have hard transitions that no
      fragment count can perfectly resolve; fragment count affects
      only the flat regions for these shapes.

    \amu_define title           (Line wave example)
    \amu_define image_views     (top)
    \amu_define image_size      (sxga)
    \amu_define scope_id        (polygon_line_wave_p)
    \amu_define output_scad     (true)

    \amu_include (include/amu/scope_diagrams_3d.amu)
*******************************************************************************/
function polygon_line_wave_p
(
  p1 = origin2d,
  p2 = x_axis2d_uv,

  p = 1,
  a = 1,

  w = 1,
  m = 0,

  t,

  fn
) =
  let
  (
    // decode/unpack parameters

    // wave period
    wp      = defined_or(p, 1),

    // max amplitude, nonlinear amplitude
    ma      = defined_eon_or(a, 0, 1),
    na      = defined_e_or  (a, 1, 1),
    oa      = defined_e_or  (a, 2, 0),

    // waveform shape
    shape   = defined_eon_or(w, 0, 1),

    // remapping mode
    remap   = defined_eon_or(m, 0, 0),

    // sampling rage start and end
    t_min   = defined_eon_or(t, 0, 0),
    t_max   = defined_e_or  (t, 1, t_min + 1),

    // waveform period fragments
    line_fn = defined_or(fn, get_fn( ma )),

    // line basis vectors
    dx      = p2[0] - p1[0],
    dy      = p2[1] - p1[1],
    len     = sqrt(dx*dx + dy*dy),

    // line steps; cycles * fragments per cycle
    steps   = ceil( (len * (t_max - t_min) / wp) * line_fn ),

    // unit tangent (along the line)
    tx      = dx / len,
    ty      = dy / len,

    // unit normal (perpendicular, 90° CCW)
    nx      = -ty,
    ny      =  tx,

    safe_n  = max(na, grid_fine),

    // hoist skew log constants (used in remap branches)
    safe_s  = (remap == 2 || remap == 3) ?
                let( s = defined_e_or(m, 1, 1/2) ) max(min(s, 1 - grid_fine), grid_fine)
              : 0,
    log_s   = (remap == 2) ? log(0.5) / log(safe_s) : 0,
    log_1ms = (remap == 2) ? log(0.5) / log(1 - safe_s) : 0,

    // hoist blend log constants (remap == 3); computed once here rather than
    // repeating log() calls on every loop iteration.
    blend_m_phase   = (remap == 3) ? defined_e_or(m, 1, 1/2) : 0,
    blend_m_skew    = (remap == 3) ? defined_e_or(m, 2, 1/2) : 0,
    blend_m_blend   = (remap == 3) ? defined_e_or(m, 3, 1/2) : 0,
    blend_safe_skew = (remap == 3) ?
                        max(min(blend_m_skew, 1 - grid_fine), grid_fine)
                      : 0,
    blend_log_s     = (remap == 3) ? log(0.5) / log(blend_safe_skew)       : 0,
    blend_log_1ms   = (remap == 3) ? log(0.5) / log(1 - blend_safe_skew)   : 0
  )
  // return coordinate points: base point + lateral displacement
  [
    for (i = [0 : steps])
      let
      (
        // line point
        tp      = t_min + (t_max - t_min) * (i / steps),

        // arc length along the line
        arc     = tp * len,

        u_raw   = (arc / wp) - floor(arc / wp),
        u       = u_raw < 0 ? u_raw + 1 : u_raw,

        // time axis remap
        u_remapped =
            // phase
            remap == 1 ?
              let
              (
                m_shift = defined_e_or(m, 1, 1/2)
              )
              (u + m_shift) - floor(u + m_shift)
            // skew
          : remap == 2 ?
              u < safe_s ?
                  0.5 * pow(u / safe_s, log_s)
                : 0.5 + 0.5 * pow((u - safe_s) / (1 - safe_s), log_1ms)
            // blend
          : remap == 3 ?
              let
              (
                u_phase = (u + blend_m_phase) - floor(u + blend_m_phase),
                u_skew  = u < blend_safe_skew ?
                    0.5 * pow(u / blend_safe_skew,              blend_log_s)
                  : 0.5 + 0.5 * pow((u - blend_safe_skew) / (1 - blend_safe_skew), blend_log_1ms)
              )
              (1 - blend_m_blend) * u_phase + blend_m_blend * u_skew
            // default is no remapping
          : u,

        // raw waveform; all accept u in [0,1) and return a value in [-1, 1]
        wave =
          let ( v = u_remapped )
            // sine
            shape == 1 ?
              sin(360 * v)
            // triangle
          : shape == 2 ?
              v < 0.25 ?  4 * v : v < 0.75 ?  2 - 4 * v : 4 * v - 4
            // square
          : shape == 3 ?
              v < 0.5 ? 1 : -1
            // sawtooth
          : shape == 4 ?
              2 * v - 1
            // sawtooth_reverse
          : shape == 5 ?
              1 - 2 * v
            // pulse
          : shape == 6 ?
              let
              (
                w_duty = defined_e_or(w, 1, 1/2)
              )
              v < w_duty ? 1 : -1
            // trapezoid
          : shape == 7 ?
              let
              (
                w_rise = defined_e_or(w, 1, 1/4),
                w_hold = defined_e_or(w, 2, w_rise),
                w_fall = defined_e_or(w, 3, w_hold)
              )
              v < w_rise                   ? -1 + 2 * (v / w_rise)
            : v < w_rise + w_hold          ?  1
            : v < w_rise + w_hold + w_fall ?  1 - 2 * ((v - w_rise - w_hold) / w_fall)
            :                                -1
            // sine_abs
          : shape == 8 ?
              2 * abs(sin(180 * v)) - 1
            // sine_half
          : shape == 9 ?
            v < 0.5 ? 2 * sin(360 * v) - 1 : -1
            // lookup table
          : shape == 10 ?
              let
              (
                w_lut  = defined_e_or(w, 1, [0, 1]),

                count  = len(w_lut),
                scaled = v * count,

                i0     = floor(scaled) % count,
                i1     = (i0 + 1) % count,        // wraps for smooth looping
                sf     = scaled - floor(scaled),
                v0     = w_lut[i0],
                v1     = w_lut[i1]
              )
              v0 + sf * (v1 - v0)
            // default is no waveform
            : 0,

        signv   = wave < 0 ? -1 : (wave > 0 ? 1 : 0),
        offset  = oa + ma * signv * pow(abs(wave), 1 / safe_n)
      )
      [ p1.x + arc * tx + offset * nx, p1.y + arc * ty + offset * ny ]
  ];

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
    for (i=[1:24]) echo( "not tested:" );

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_term}.mfs;
    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

/*
BEGIN_SCOPE polygon_line_wave_p;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;

    p = polygon_line_wave_p
        (
          p2 = [200, 0],
          p  = 40,
          a  = [15, 1]
        );

    polygon(p);

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "top diag";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

/*
BEGIN_SCOPE polygon_round_eve_all_p_modes;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;

    $fn=36;

    mode = 0;

    pp = polygon_trapezoid_p(10, 7);
    rp = polygon_round_eve_all_p( pp, 2.5, [0, 0, mode, 0] );

    polygon( rp );

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "vga";
    views     name "views" views "top";
    defines   name "modes" define "mode" integers "0 1 2 3 4 5 6 7 8 9 10";

    variables set_opts_combine "sizes views modes";
    variables add_opts "--viewall --autocenter";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

/*
BEGIN_SCOPE polygon_round_eve_all_p_example;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;

    $fn=36;

    c = [[1,1], [1,10], [10,12], [18,2]];
    r = [1, 1, 5, 8];
    m = [2, 3, 4, 3];
    n = [3, 8, undef, undef];

    p = polygon_round_eve_all_p(c=c, vr=r, vrm=m, vfn=n);

    polygon( p );

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "top";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
