//! Polygon shapes, conversions, properties, and tests functions.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2015-2024

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

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_include (include/amu/includes_required.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// shape generation
//----------------------------------------------------------------------------//

//! \name Shapes
//! @{

//! Compute coordinates for an n-sided regular polygon in 2D.
/***************************************************************************//**
  \param    n <integer> The number of sides.
  \param    r <decimal> The circumradius of the circumcircle.
  \param    a <decimal> The inradius of the incircle.
  \param    c <point-2d> The center coordinate [x, y].
  \param    o <decimal> The rotational angular offset.
  \param    vr <decimal> The vertex rounding radius.
  \param    cw <boolean> Use clockwise point ordering.

  \returns  <coords-2d> A list of coordinates points [[x, y], ...].

  \details

    The radius can be specified by either the circumradius \p r or the
    inradius \p a. If both are specified, \p r is used.

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
  c = origin2d,
  o = 0,
  vr,
  cw = true
) =
  let
  (
    s = is_defined(r) ? r
      : is_defined(a) ? a / cos(180/n)
      : 0,

    b = (cw == true) ? [360:-(360/n):1] : [0:(360/n):359]
  )
  [
    for (a = b)
      let( v = [s*cos(a+o), s*sin(a+o)] + c )
      is_undef(vr) ? v : v - vr/cos(180/n) * unit_l(v)
  ];

//! Compute coordinates along a line in 2D.
/***************************************************************************//**
  \param    p1 <point-2d> The line initial coordinate [x, y].
  \param    p2 <point-2d> The line terminal coordinate [x, y].
  \param    l <line-2d> The line or vector.

  \param    x <decimal-list | decimal> A list of \p x coordinates
            [\p x1, \p x2, ...] or a single \p x coordinate at which to
            interpolate along the line.
  \param    y <decimal-list | decimal> A list of \p y coordinates
            [\p y1, \p y2, ...] or a single \p y coordinate at which to
            interpolate along the line.

  \param    r <decimal-list | decimal> A list of ratios
            [\p r1, \p r2, ...] or a single ratio \p r. The position
            ratio along line \p p1 (\p r=\b 0) to \p p2 (\p r=\b 1).

  \param    fs <decimal> A fixed segment size between each point along
            the line.
  \param    ft <decimal> A fixed segment size between each point,
            centered, beginning at \p p1 and terminating at \p p2.
  \param    fn <integer> A fixed number of equally spaced points.

  \returns  <coords-2d> A list of coordinates points [[x, y], ...].

  \details

    Linear interpolation is used to compute each point along the line.
    The order of precedence for line specification is: \p l then \p p1
    and \p p2. The order of precedence for interpolation is: \p x, \p
    y, \p r, \p fs, \p ft, \p fn.
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

 //
 // zdx = (tp[0] == ip[0]),                                   // is delta-x zero
 // zdy = (tp[1] == ip[1]),                                   // is delta-y zero
 //
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
  \param    c <point-2d> The arc center coordinate [x, y].
  \param    v1 <line-2d | decimal> The arc start angle.
            A 2d line, vector, or decimal angle 1.
  \param    v2 <line-2d | decimal> The arc end angle.
            A 2d line, vector, or decimal angle 2.
  \param    fn <integer> The number of [facets] (optional).
  \param    cw <boolean> Sweep clockwise along arc from the head of
            vector \p v1 to the head of vector \p v2 when \p cw =
            \b true, and counter clockwise when \p cw = \b false.

  \returns  <coords-2d> A list of coordinates points [[x, y], ...].

  \details

    The arc coordinates will have radius \p r centered about \p c
    contained within the heads of vectors \p v1 and \p v2. The arc will
    start at the point coincident to \p v1 and will end at the point
    coincident to \p v2. When vectors \p v1 and \p v2 are parallel, the
    arc will be a complete circle. When \p fn is undefined, its value
    is determined by get_fn().

  [facets]: \ref get_fn()
*******************************************************************************/
function polygon_arc_p
(
  r  = 1,
  c  = origin2d,
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

    // positive arc sweep angle
    vas = angle_ll(va2, va1, false),
    vap = (vas == 0) ? 360 : vas,

    // arc cw and ccw signed sweep step
    sas = (((cw == true) ? 0 : 360) - vap)/naf
  )
  [
    for (as = [0 : naf])
      let (aa = iap + as * sas)
      c + r * [cos(aa), sin(aa)]
  ];

//! Compute coordinates for an elliptical sector in 2D.
/***************************************************************************//**
  \param    r <decimal-list-2 | decimal> The elliptical radius. A list
            [rx, ry] of decimals or a single decimal for (rx=ry).
  \param    c <point-2d> The center coordinate [x, y].
  \param    v1 <line-2d | decimal> The sector angle 1.
            A 2d line, vector, or decimal.
  \param    v2 <line-2d | decimal> The sector angle 2.
            A 2d line, vector, or decimal.
  \param    s <boolean> Use signed vector angle conversions. When
            \b false, positive angle conversion will be used.
  \param    fn <integer> The number of [facets] (optional).
  \param    cw <boolean> The coordinate point ordering.

  \returns  <coords-2d> A list of coordinates points [[x, y], ...].

  \details

    The coordinates will be between angle 1 and angle 2 and will be
    ordered clockwise. The sector sweep direction can be controlled by
    the sign of the angles. When \p fn is undefined, its value is
    determined by get_fn().

  [facets]: \ref get_fn()
*******************************************************************************/
function polygon_elliptical_sector_p
(
  r = 1,
  c = origin2d,
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
      if (va1 != va2) c,
      for (i = as)
        let (pa = ((af-i)*va1 + i*va3) / af)
        c + [rx*cos(pa), ry*sin(pa)]
    ]
  )
  (cw == true) ? pp : reverse(pp);

//! Compute the coordinates for a rounded trapezoid in 2D space.
/***************************************************************************//**
  \param    b <decimal-list-2 | decimal> The base lengths. A list [b1, b2]
            of 2 decimals or a single decimal for (b1=b2).
  \param    h <decimal> The perpendicular height between bases.
  \param    l <decimal> The left side leg length.
  \param    a <decimal> The angle between the lower base and left leg.
  \param    o <point-2d> The origin offset coordinate [x, y].
  \param    cw <boolean> Polygon vertex ordering.

  \returns  <coords-2d> A list of coordinates points [[x, y], ...].

  \details

    When both \p h and \p l are specified, \p h has precedence. The
    function generates [parallelograms], rectangles, and squares with
    the appropriate parameter assignments. See [Wikipedia] for more
    general information on trapezoids.

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
  let
  (
    b1 = defined_e_or(b, 0, b),
    b2 = defined_e_or(b, 1, b1),

    // trapezoid vertices from origin
    p1 = o,
    p2 = o  + (is_undef(h) ? l*[cos(a), sin(a)] : h*[cos(a), 1]),
    p3 = p2 + [b2, 0],
    p4 = o  + [b1, 0],

    // cw ordering
    pp  = [p4, p1, p2, p3]
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
    inradius \p a. If both are specified, \p r is used.
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
    inradius \p a. If both are specified, \p r is used.
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
  \param    c <coords-2d> A list of 2d cartesian coordinates
            [[x, y], ...].
  \param    p <integer-list-list> An \em optional list of paths that
            define one or more closed shapes where each is a list of
            coordinate indexes.

  \returns  <decimal> The sum of all polygon primary and secondary
            perimeter lengths.

  \details

    When \p p is not defined, the listed order of the coordinates will
    be used.
*******************************************************************************/
function polygon_perimeter
(
  c,
  p
) =
  let
  (
    pm = defined_or(p, [consts(len(c))]),

    lv =
    [
      for (k = pm) let (n = len(k))
        for (i=[0 : n-1]) let (j = (i == 0) ? n-1 : i-1)
          distance_pp(c[k[j]], c[k[i]])
    ]
  )
  sum(lv);

//! Compute the signed area of a polygon in a Euclidean 2d-space.
/***************************************************************************//**
  \param    c <coords-2d> A list of 2d cartesian coordinates
            [[x, y], ...].
  \param    p <integer-list-list> An \em optional list of paths that
            define one or more closed shapes where each is a list of
            coordinate indexes.
  \param    s <boolean> Return the vertex ordering sign.

  \returns  <decimal> The area of the given polygon.

  \details

    See [Wikipedia] for more information.

    When \p p is not defined, the listed order of the coordinates will
    be used.

  \warning  This function does not track secondary shapes subtraction as
            implemented by the polygon() function.

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

    av =
    [
      for (k = pm) let (n = len(k))
        for (i=[0 : n-1]) let (j = (i == 0) ? n-1 : i-1)
          (c[k[j]][0] + c[k[i]][0]) * (c[k[i]][1] - c[k[j]][1])
    ],

    sa = sum(av)/2
  )
  (s == false) ? abs(sa) : sa;

//! Compute the area of a polygon in a Euclidean 3d-space.
/***************************************************************************//**
  \param    c <coords-3d> A list of 3d cartesian coordinates
            [[x, y, z], ...].
  \param    p <integer-list-list> An \em optional list of paths that
            define one or more closed shapes where each is a list of
            coordinate indexes.
  \param    n <vector-3d> An \em optional normal vector, [x, y, z],
            to the polygon plane. When not given, a normal vector is
            constructed from the first three points of the primary path.

  \returns  <decimal> The area of the given polygon.

  \details

    Function patterned after [Dan Sunday, 2012].

    When \p p is not defined, the listed order of the coordinates will
    be used.

  \warning  This function does not track secondary shapes subtraction as
            implemented by the polygon() function.

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
  \param    c <coords-2d> A list of 2d cartesian coordinates
            [[x, y], ...].
  \param    p <integer-list-list> An \em optional list of paths that
            define one or more closed shapes where each is a list of
            coordinate indexes.

  \returns  <point-2d> The center of mass of the given polygon.

  \details

    See [Wikipedia] for more information.

    When \p p is not defined, the listed order of the coordinates will
    be used.

  \warning  This function does not track secondary shapes subtraction as
            implemented by the polygon() function.

    [Wikipedia]: https://en.wikipedia.org/wiki/Centroid#Centroid_of_polygon
*******************************************************************************/
function polygon_centroid
(
  c,
  p
) =
  let
  (
    pm = defined_or(p, [consts(len(c))]),

    cv =
    [
      for (k = pm) let (n = len(k))
        for (i=[0 : n-1])
        let
        (
          j  = (i == 0) ? n-1 : i-1,

          xc = c[k[j]][0],
          yc = c[k[j]][1],

          xn = c[k[i]][0],
          yn = c[k[i]][1],

          cd = (xc*yn - xn*yc)
        )
          [(xc + xn) * cd, (yc + yn) * cd]
    ],

    sc = sum(cv),
    sa = polygon_area(c, pm, true)
  )
  sc/(6*sa);

//! Compute the winding number of a polygon about a point in a Euclidean 2d-space.
/***************************************************************************//**
  \param    c <coords-2d> A list of 2d cartesian coordinates
            [[x, y], ...].
  \param    p <integer-list-list> An \em optional list of paths that
            define one or more closed shapes where each is a list of
            coordinate indexes.
  \param    t <point-2d> A test point coordinate [x, y].

  \returns  <integer> The winding number.

  \details

    Computes the [winding number], the total number of counterclockwise
    turns that the polygon paths makes around the test point in a
    Euclidean 2d-space. Will be 0 \em iff the point is outside of the
    polygon. Function patterned after [Dan Sunday, 2012].

  \copyright

    Copyright 2000 softSurfer, 2012 Dan Sunday
    This code may be freely used and modified for any purpose
    providing that this copyright notice is included with it.
    iSurfer.org makes no warranty for this code, and cannot be held
    liable for any real or imagined damage resulting from its use.
    Users of this code must verify correctness for their application.

    [Dan Sunday, 2012]: http://geomalgorithms.com/a03-_inclusion.html
    [winding number]: https://en.wikipedia.org/wiki/Winding_number

    When \p p is not defined, the listed order of the coordinates will
    be used.

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

    wv =
    [
      for (k = pm) let (n = len(k))
        for (i=[0 : n-1])
        let
        (
          j = (i == 0) ? n-1 : i-1,

          t = (
                (c[k[j]][1] <= t[1]) && (c[k[i]][1] >  t[1])
                && (is_left_ppp(c[k[j]], c[k[i]], t) > 0)
              ) ? +1
            : (
                (c[k[j]][1] >  t[1]) && (c[k[i]][1] <= t[1])
                && (is_left_ppp(c[k[j]], c[k[i]], t) < 0)
              ) ? -1
            : 0
        )
          t
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
  \param    c <coords-2d> A list of 2d cartesian coordinates
            [[x, y], ...].
  \param    p <integer-list-list> An \em optional list of paths that
            define one or more closed shapes where each is a list of
            coordinate indexes.

  \returns  <boolean> \b true if the vertex are ordered \em clockwise,
            \b false if the vertex are \em counterclockwise ordered, and
            \b undef if the ordering can not be determined.

  \details

    When \p p is not defined, the listed order of the coordinates will
    be used.
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
  \param    c <coords-2d> A list of 2d cartesian coordinates
            [[x, y], ...].
  \param    p <integer-list-list> An \em optional list of paths that
            define one or more closed shapes where each is a list of
            coordinate indexes.

  \returns  <boolean> \b true if the polygon is \em convex, \b false
            otherwise.

  \details

    When \p p is not defined, the listed order of the coordinates will
    be used.
*******************************************************************************/
function polygon_is_convex
(
  c,
  p
) = is_undef(c) ? undef
  : len(c) < 3 ? undef
  : !all_len(c, 2) ? undef
  : let
    (
      pm = defined_or(p, [consts(len(c))]),

      sv =
      [
        for (k = pm) let (n = len(k))
          for (i=[0 : n-1])
            sign(cross_ll([c[k[i]], c[k[(i+1)%n]]], [c[k[(i+1)%n]], c[k[(i+2)%n]]]))
      ],

      us = unique(sv)
    )
    (len(us) == 1);

//! Test if a point is inside a polygon in a Euclidean 2d-space using winding number.
/***************************************************************************//**
  \param    c <coords-2d> A list of 2d cartesian coordinates
            [[x, y], ...].
  \param    p <integer-list-list> An \em optional list of paths that
            define one or more closed shapes where each is a list of
            coordinate indexes.
  \param    t <point-2d> A test point coordinate [x, y].

  \returns  <boolean> \b true when the point is \em inside the polygon and
            \b false otherwise.

  \details

    When \p p is not defined, the listed order of the coordinates will
    be used.

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
  \param    c <coords-2d> A list of 2d cartesian coordinates
            [[x, y], ...].
  \param    p <integer-list-list> An \em optional list of paths that
            define one or more closed shapes where each is a list of
            coordinate indexes.
  \param    t <point-2d> A test point coordinate [x, y].

  \returns  <boolean> \b true when the point is \em inside the polygon and
            \b false otherwise.

  \details

    See [Wikipedia] for more information.

    When \p p is not defined, the listed order of the coordinates will
    be used.

  \warning  This function does not track secondary shapes subtraction as
            implemented by the polygon() function.

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
  \param    c <coords-2d> A list of 2d cartesian coordinates
            [[x, y], ...].
  \param    p <integer-list-list> An \em optional list of paths that
            define one or more closed shapes where each is a list of
            coordinate indexes.
  \param    h <decimal> The polyhedron height.
  \param    centroid <boolean> Center polygon centroid at z-axis.
  \param    center <boolean> Center polyhedron height about xy-plane.

  \returns  <datastruct> A structure <tt>[points, faces]</tt>, where
            \c points are <coords-3d> and \c faces are a
            <integer-list-list>, that define the bounding box of the
            given polyhedron.

  \details

    When \p p is not defined, the listed order of the coordinates will
    be used.
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
    pm = defined_or(p, [consts(len(c))]),
    pn = len([for (pi = pm) for (ci = pi) 1]),

    po = (centroid == true) ? polygon_centroid(c, p) : origin2d,
    zr = (center == true) ? [-h/2, h/2] : [0, h],

    cw = polygon_is_clockwise (c, p),

    pp = [for (zi = zr) for (pi = pm) for (ci = pi) concat(c[ci] - po, zi)],
    pf =
    [
      [for (pi = pm) for (ci = pi) ci],
      [for (pi = pm) for (cn = [len(pi)-1 : -1 : 0]) pi[cn] + pn],
      for (pi = pm) for (ci = pi)
        (cw == true)
        ? [ci, ci+pn, (ci+1)%pn+pn, (ci+1)%pn]
        : [ci, (ci+1)%pn, (ci+1)%pn+pn, ci+pn]
    ]
  )
  [pp, pf];

//! @}

//----------------------------------------------------------------------------//
// shape rounding
//----------------------------------------------------------------------------//

//! \name Rounding
//! @{

//! Compute coordinates for a constant radius vertex round between two edge vectors in 2D.
/***************************************************************************//**
  \param    r <decimal> The round radius.
  \param    m <integer> The round mode.
  \param    c <point-2d> The round center coordinate [x, y].
  \param    v1 <line-2d | decimal> The round start angle.
            A 2d line, vector, or decimal angle 1.
  \param    v2 <line-2d | decimal> The round end angle.
            A 2d line, vector, or decimal angle 2.
  \param    fn <integer> The number of [facets].
  \param    cw <boolean> The coordinate point ordering.

  \returns  <coords-2d> A list of coordinates points [[x, y], ...].

  \details

    Normally, angle 1 should be less than angle 2. The edge coordinates
    will start at angle 1, end at angle 2, and will have radius \p r
    along a rounded transition from edge 1 to 2. When \p cw = \b true
    the coordinates will start at edge 1 and increase toward edge 2.
    When \p cw = \b false this ordering is reversed.

    The round mode may be one of the following:

     mode | name        | description
     :---:|:-----------:|:--------------------------------
       1  | fillet      | fillet from one edge to the next
       2  | round       | round from one edge to the next
       3  | chamfer     | bevel from one edge to the next

  [facets]: \ref get_fn()
*******************************************************************************/
function polygon_round_eve_p
(
  r  = 1,
  m  = 1,
  c  = origin2d,
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
    etc = [c + r*unit_l(va1), c, c + r*unit_l(va2)],

    // tangent circle radius
    tcr = (m == 1) ?triangle2d_exradius(etc, 2) : 0,

    // tangent circle center coordinate
    tcc = (m == 1) ?(c-r/(r-tcr) * triangle2d_excenter(etc, 2)) * (tcr-r)/tcr : c,

    // distance from vertex to inflection points
    vim = (m == 1) ? sqrt( pow(distance_pp(c, tcc),2) - pow(r,2) ) : r,

    // inflection coordinates
    tc1 = c + vim*unit_l(va1),
    tc2 = c + vim*unit_l(va2),

    // vertex rounding coordinate point list
    vpl = (m == 1) ? polygon_arc_p(r=r, c=tcc, v1=[tcc, tc1], v2=[tcc, tc2], fn=fn, cw=true)
        : (m == 2) ? polygon_arc_p(r=r, c=tcc, v1=[tcc, tc1], v2=[tcc, tc2], fn=fn, cw=false)
        : empty_lst,

    // cw ordering
    pp = concat([tc1], vpl, [tc2])
  )
  (cw == true) ? pp : reverse(pp);

//! Compute coordinates that round all of the vertices between each adjacent edges in 2D.
/***************************************************************************//**
  \param    c <coords-2d> A list of \em n 2d cartesian coordinates
            [[x1, y1], [x2, y2], ..., [xn, yn]].
  \param    vr <decimal-list-n | decimal> The vertices rounding radius.
            A list [v1r, v2r, v3r, ... vnr] of \em n decimals or a
            single decimal for (v1r=v2r=v3r= ... =vnr). Undefined
            vertices are not rounded.
  \param    vrm <integer-list-n | integer> The vertices rounding mode.
            A list [v1rm, v2rm, v3rm, ... vnrm] of \em n integers or a
            single integer for (v1rm=v2rm=v3rm= ... =vnrm). Undefined
            vertices are not rounded.
  \param    vfn <integer-list-n> The vertices arc fragment number.
            A list [v1fn, v2fn, v3fn, ... vnfn] of \em n integers or a
            single integer for (v1fn=v2fn=v3fn= ... =vnfn).
  \param    w <boolean> Wrap-at-end during 3-point coordinate selection.
  \param    cw <boolean> Polygon vertex ordering.

  \returns  <coords-2d> A new list of coordinates points [[x, y], ...]
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

    Vertex arc fragments can be specified using \p vfn. When any \p
    vnfn is \b undef, the special variables \p $fa, \p $fs, and \p $fn
    control facet generation. Each vertex is processed using 3-point
    (the previous and following vertex). The resulting triangle \ref
    triangle2d_incenter "incircles" and \ref triangle2d_excenter
    "excircles" are used to create the round and fillet \ref
    polygon_arc_p "arc" segments. All arcs and chamfers use constant
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
              polygon_arc_p(r=rr, c=tcc, v1=[tcc, tc1], v2=[tcc, tc2], fn=fn, cw=!ras)
            : (rm == 2 || rm == 3 || rm == 4) ?
              polygon_arc_p(r=rr, c=tcc, v1=[tcc, tc1], v2=[tcc, tc2], fn=fn, cw=ras)
            : (rm == 6 || rm == 7 || rm == 8) ?
              polygon_arc_p(r=rr, c=vc, v1=[vc, tc1], v2=[vc, tc2], fn=fn, cw=!ras)
            : [tc1, tc2]
      )
      vpl
    ],

    // polygon points
    pp = merge_s( ppl )
  )
  (cw == true) ? pp : reverse(pp);

//! @}

//----------------------------------------------------------------------------//
// interpreter
//----------------------------------------------------------------------------//

//! \name Interpreter
//! @{

//! Generate list of coordinate points from simple step move notation.
/***************************************************************************//**
  \param    s <datastruct-list> The list of step moves.
  \param    i <point-2d> The initial coordinate [x, y].

  \returns  <point-2d-list> The list of coordinate point list.

  \details

    This function is a simple interpreter that converts a list of move
    commands into coordinate points for the construction of polygons.
    Each move command produces a single new output point and may be
    specified as an absolute coordinate or may be relative to the
    previous coordinate point. The steps are specified by a list which
    include the command along with one or two command arguments.

     Move step definition:

      datastruct types                  | syntax
    :-----------------------------------|:----------------------------
     [ <string>, <number>, (<number>)]  | [ command, arg1, (arg2) ]

    The following table summarized the commands and their semantics.

     command    | short | argc | arg1 | arg2 | output coordinate point
    :-----------|:-----:|:----:|:----:|:----:|:-----------------------
     move_xy    | mxy   | 2    | x    | y    | [x, y]
     move_x     | mx    | 1    | x    | -    | [x, i.y]
     move_y     | my    | 1    | y    | -    | [i.x, y]
     delta_xy   | dxy   | 2    | x    | y    | i + [x, y]
     delta_x    | dx    | 1    | x    | -    | i + [x, 0]
     delta_y    | dy    | 1    | y    | -    | i + [0, y]
     delta_xv   | dxv   | 2    | x    | a    | i + [ x, x * tan(a) ]
     delta_yv   | dyv   | 2    | y    | a    | i + l y / tan(a), y ]
     delta_mv   | dmv   | 2    | m    | a    | i + line(m, a)

    This functions provides a convenient way to construct polygons
    using a simple notation based on incremental steps.

    \amu_define title           (Motor mount plate design example)
    \amu_define image_views     (top diag)
    \amu_define image_size      (sxga)
    \amu_define scope_id        (polygon_turtle_p)
    \amu_define output_scad     (true)

    \amu_include (include/amu/scope_diagrams_3d.amu)

    The corners of this example 2d design plate have been rounded with
    the library function polygon_round_eve_all_p(). This functions is
    inspired by the implementation of the [Turtle graphics] geometric
    drawing language.

    [Turtle graphics]: https://en.wikipedia.org/wiki/Turtle_(robot)
*******************************************************************************/
function polygon_turtle_p
(
  s,
  i = origin2d,
) = ! is_list( s ) ? empty_lst
  : let
    ( // get next step definition
       m = first( s ),

      // get move operation and arguments
       o =  first( m ),
      a1 = second( m ),
      a2 =  third( m ),

      // compute coordinate point for step operation
       p = (o == "mxy" || o == "move_xy"  ) ? [a1, a2]

         : (o == "mx"  || o == "move_x"   ) ? [a1, i.y]
         : (o == "my"  || o == "move_y"   ) ? [i.x, a1]

         : (o == "dxy" || o == "delta_xy" ) ? i + [a1, a2]

         : (o == "dx"  || o == "delta_x"  ) ? i + [a1, 0]
         : (o == "dy"  || o == "delta_y"  ) ? i + [0, a1]

         : (o == "dxv" || o == "delta_xv" ) ? i + [a1, a1 * tan(a2)]
         : (o == "dyv" || o == "delta_yv" ) ? i + [a1 / tan(a2), a1]

         : (o == "dmv" || o == "delta_mv" ) ? line_tp( line2d_new(m=a1, a=a2, p1=i) )

         : [str("ERROR at step: ", o)]
    )
    // check if have reached last move
    //  yes : terminate recursion
    //   no : pop current step and process remaining
    ( len( s ) == 1 ) ? [p] : concat( [p], polygon_turtle_p( tailn(s), p ) );

//! @}

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE polygon_turtle_p;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;

    $fn=36;

    h1 = 7.5;   h2 = 5;     h3 = 7.5;
    w1 = 5;     w2 = 20;    w3 = 5;
    r1 = 5;     r2 = 1/2;   rr = 1;

    sm =
    [
      ["delta_y",  h1],
      ["delta_x",  w1],
      ["delta_y",  h2],
      ["delta_xy", w3, h3],
      ["delta_x",  w1+w2-w3*2],
      ["delta_xy", w3, -h3],
      ["move_y",   0],
      ["move_x",   0],
    ];

    // convert the step moves into coordinates
    pp = polygon_turtle_p( sm );

    // round all of the vertices
    rp = polygon_round_eve_all_p( pp, rr );

    difference()
    {
      polygon( rp );

      c = [w1+w2/2+r1/2, h1+h2/2];
      translate(c) circle(r=r1);
      for(x=[-1,1], y=[-1,1]) translate(c+[x,y]*r1) circle(r=r2);
    }

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
