//! Mathematical functions of polygon primitive shapes.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2015-2023

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

    \amu_define group_name  (Polygon Primitives)
    \amu_define group_brief (Mathematical functions of polygon primitive shapes.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

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
      for ( p = polygon2d_regular_p( r=20, n=5, vr=vr ) )
        translate( p )
        circle( r=vr );
    }
    \endcode

    See [Wikipedia] for more information.

  [Wikipedia]: https://en.wikipedia.org/wiki/Regular_polygon
*******************************************************************************/
function polygon2d_regular_p
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

  \param    x <decimal-list|decimal> A list of \p x coordinates
            [\p x1, \p x2, ...] or a single \p x coordinate at which to
            interpolate along the line.
  \param    y <decimal-list|decimal> A list of \p y coordinates
            [\p y1, \p y2, ...] or a single \p y coordinate at which to
            interpolate along the line.

  \param    r <decimal-list|decimal> A list of ratios
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
function polygon2d_line_p
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
    zdx = almost_equal_nv(tp[0], ip[0]),                      // is delta-x zero
    zdy = almost_equal_nv(tp[1], ip[1]),                      // is delta-y zero

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
  : [ for (py = pl) interpolate2d_linear_pp(ip, tp, y=py) ]   // interpolate for 'x'
  : is_defined(y) && zdy ? undef                              // (a == 0)
  : [ for (px = pl) interpolate2d_linear_pp(ip, tp, x=px) ];  // interpolate for 'y'

//! Compute coordinates of an arc with constant radius between two vectors in 2D.
/***************************************************************************//**
  \param    r <decimal> The arc radius.
  \param    c <point-2d> The arc center coordinate [x, y].
  \param    v1 <line-2d|decimal> The arc start angle.
            A 2d line, vector, or decimal angle 1.
  \param    v2 <line-2d|decimal> The arc end angle.
            A 2d line, vector, or decimal angle 2.
  \param    fn <integer> The number of [facets].
  \param    cw <boolean> Sweep clockwise along arc from the head of
            vector \p v1 to the head of vector \p v2 when \p cw =
            \b true, and counter clockwise when \p cw = \b false.

  \returns  <coords-2d> A list of coordinates points [[x, y], ...].

  \details

    The arc coordinates will have radius \p r centered about \p c
    contained within the heads of vectors \p v1 and \p v2. The arc will
    start at the point coincident to \p v1 and will end at the point
    coincident to \p v2. When vectors \p v1 and \p v2 are parallel, the
    arc will be a complete circle.

  [facets]: \ref openscad_fn()
*******************************************************************************/
function polygon2d_arc_p
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
    naf = defined_or(fn, openscad_fn(r)),

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

//! Compute coordinates for an edge round with constant radius between two vectors in 2D.
/***************************************************************************//**
  \param    m <integer> The round mode.
  \param    r <decimal> The round radius.
  \param    c <point-2d> The round center coordinate [x, y].
  \param    v1 <line-2d|decimal> The round start angle.
            A 2d line, vector, or decimal angle 1.
  \param    v2 <line-2d|decimal> The round end angle.
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

  [facets]: \ref openscad_fn()
*******************************************************************************/
function polygon2d_round_p
(
  m  = 1,
  r  = 1,
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
    vpl = (m == 1) ? polygon2d_arc_p(r=r, c=tcc, v1=[tcc, tc1], v2=[tcc, tc2], fn=fn, cw=true)
        : (m == 2) ? polygon2d_arc_p(r=r, c=tcc, v1=[tcc, tc1], v2=[tcc, tc2], fn=fn, cw=false)
        : empty_lst,

    // cw ordering
    pp = concat([tc1], vpl, [tc2])
  )
  (cw == true) ? pp : reverse(pp);

//! Compute coordinates for an elliptical sector in 2D.
/***************************************************************************//**
  \param    r <decimal-list-2|decimal> The elliptical radius. A list
            [rx, ry] of decimals or a single decimal for (rx=ry).
  \param    c <point-2d> The center coordinate [x, y].
  \param    v1 <line-2d|decimal> The sector angle 1.
            A 2d line, vector, or decimal.
  \param    v2 <line-2d|decimal> The sector angle 2.
            A 2d line, vector, or decimal.
  \param    s <boolean> Use signed vector angle conversions. When
            \b false, positive angle conversion will be used.
  \param    fn <integer> The number of [facets].
  \param    cw <boolean> The coordinate point ordering.

  \returns  <coords-2d> A list of coordinates points [[x, y], ...].

  \details

    The coordinates will be between angle 1 and angle 2 and will be
    ordered clockwise. The sector sweep direction can be controlled by
    the sign of the angles.

  [facets]: \ref openscad_fn()
*******************************************************************************/
function polygon2d_elliptical_sector_p
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
    rx  = edefined_or(r, 0, r),
    ry  = edefined_or(r, 1, rx),

    va1 = is_number(v1) ? v1 : angle_ll(x_axis2d_uv, v1, s),
    va2 = is_number(v2) ? v2 : angle_ll(x_axis2d_uv, v2, s),

    // full return when angles are equal
    va3 = (va1 == va2) ? va2+360 : va2,

    // number of arc facets
    af  = defined_or(fn, openscad_fn((rx+ry)/2)),

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
  \param    b <decimal-list-2|decimal> The base lengths. A list [b1, b2]
            of 2 decimals or a single decimal for (b1=b2).
  \param    h <decimal> The perpendicular height between bases.
  \param    l <decimal> The left side leg length.
  \param    a <decimal> The angle between the lower base and left leg.
  \param    vr <decimal-list-4|decimal> The vertices rounding radius.
            A list [v1r, v2r, v3r, v4r] of 4 decimals or a single
            decimal for (v1r=v2r=v3r=v4r). Unspecified corners are not
            rounded.
  \param    vrm <integer-list-4|integer> The vertices rounding mode.
            A list [v1rm, v2rm, v3rm,v4rm] of 4 integers or a single
            integer for (v1rm=v2rm=v3rm=v4rm). Unspecified vertices are
            not rounded.
  \param    vfn <integer-list-4> The vertices arc fragment number.
            A list [v1fn, v2fn, v3fn, v4fn] of 4 integers or a single
            integer for (v1fn=v2fn=v3fn=v4fn).
  \param    cw <boolean> Polygon vertex ordering.

  \returns  <coords-2d> A list of coordinates points [[x, y], ...].

  \details

    When both \p h and \p l are specified, \p h has precedence.
    Each vertex may be assigned one of the available rounding
    \ref polygon2d_vertices_round3_p "modes". See [Wikipedia] for
    more information.

  [Wikipedia]: https://en.wikipedia.org/wiki/Trapezoid
*******************************************************************************/
function polygon2d_trapezoid_p
(
  b = 1,
  h,
  l = 1,
  a = 90,
  vr = 0,
  vrm = 1,
  vfn,
  cw = true
) =
  let
  (
    b1 = edefined_or(b, 0, b),
    b2 = edefined_or(b, 1, b1),

    // trapezoid vertices from origin
    p1 = [0, 0],
    p2 = is_defined(h)
       ? h*[cos(a), 1]
       : l*[cos(a), sin(a)],
    p3 = p2 + [b2, 0],
    p4 = [b1, 0],

    // cw ordering
    c  = [p4, p1, p2, p3],

    pp = polygon2d_vertices_round3_p(c=c, vr=vr, vrm=vrm, vfn=vfn, cw=true)
  )
  (cw == true) ? pp : reverse(pp);

//! @}
//! @}

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
