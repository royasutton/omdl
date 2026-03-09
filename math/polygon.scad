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

  [facets]: \ref get_fn()
*******************************************************************************/
function polygon_arc_p
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
    \c u ∈ [0, 1).

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
    log_1ms = (remap == 2) ? log(0.5) / log(1 - safe_s) : 0
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
                m_phase = defined_e_or(m, 1, 1/2),
                m_skew  = defined_e_or(m, 2, 1/2),
                m_blend = defined_e_or(m, 3, 1/2),

                safe_skew = max(min(m_skew, 1 - grid_fine), grid_fine),
                u_phase   = (u + m_phase) - floor(u + m_phase),
                u_skew    = u < safe_skew ?
                    0.5 * pow(u / safe_skew, log(0.5) / log(safe_skew))
                  : 0.5 + 0.5 * pow((u - safe_skew) / (1 - safe_skew), log(0.5) / log(1 - safe_skew))
              )
              (1 - m_blend) * u_phase + m_blend * u_skew
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
    the closing edge from the last vertex back to the first.

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
  \param    c <points-2d> A list of 2d cartesian coordinates
              [[x, y], ...].

  \param    p <integer-list-list> An \em optional list of paths that
              define one or more closed shapes where each is a list of
              coordinate indexes.

  \returns  <point-2d> The center of mass of the given polygon.

  \details

    Uses the shoelace-derived centroid formula. See [Wikipedia] for
    more information.

    When \p p is not defined, the listed order of the coordinates will
    be used.

  \warning  This function does not track secondary shapes subtraction as
            implemented by the polygon() function.

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
    implementation-defined. Function patterned after [Dan Sunday,
    2012].

  \copyright

    Copyright 2000 softSurfer, 2012 Dan Sunday This code may be freely
    used and modified for any purpose providing that this copyright
    notice is included with it. iSurfer.org makes no warranty for this
    code, and cannot be held liable for any real or imagined damage
    resulting from its use. Users of this code must verify correctness
    for their application.

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

          wn = (
                (c[k[j]][1] <= t[1]) && (c[k[i]][1] >  t[1])
                && (is_left_ppp(c[k[j]], c[k[i]], t) > 0)
              ) ? +1
            : (
                (c[k[j]][1] >  t[1]) && (c[k[i]][1] <= t[1])
                && (is_left_ppp(c[k[j]], c[k[i]], t) < 0)
              ) ? -1
            : 0
        )
          wn
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
  \param    c <points-2d> A list of 2d cartesian coordinates
              [[x, y], ...].

  \param    p <integer-list-list> An \em optional list of paths that
              define one or more closed shapes where each is a list of
              coordinate indexes.

  \returns  <boolean> \b true if the polygon is \em convex, \b false
            otherwise.

  \details

    Tests convexity by computing the cross product sign of each
    consecutive edge pair. A polygon is convex when all cross products
    have the same sign (all left-turns or all right-turns). Collinear
    edges produce a cross product of zero, which counts as a distinct
    sign value and will cause the function to return \b false even for
    otherwise convex polygons with collinear points on an edge. Returns
    \b undef when \p c is undefined, has fewer than 3 points, or
    contains non-2d coordinates.

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
    and side faces. Bottom face winding follows the input vertex order;
    top face winding is reversed to produce outward-facing normals.

    Side faces are generated per-path, with next-vertex wrapping
    performed within each path independently. Multi-path inputs
    (polygons with holes defined by secondary paths) are therefore
    handled correctly; each path contributes its own closed band of
    side faces with no cross-path index bleed.

    When \p centroid is \b true, the polygon centroid is computed and
    subtracted from all x/y coordinates before extrusion, centering the
    shape on the z-axis.

    When \p center is \b true the z-range is [-h/2, h/2]; otherwise it
    is [0, h].

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
    vpl = (m == 1) ? polygon_arc_p(r=r, o=tcc, v1=[tcc, tc1], v2=[tcc, tc2], fn=fn, cw=true)
        : (m == 2) ? polygon_arc_p(r=r, o=tcc, v1=[tcc, tc1], v2=[tcc, tc2], fn=fn, cw=false)
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
              polygon_arc_p(r=rr, o=tcc, v1=[tcc, tc1], v2=[tcc, tc2], fn=fn, cw=!ras)
            : (rm == 2 || rm == 3 || rm == 4) ?
              polygon_arc_p(r=rr, o=tcc, v1=[tcc, tc1], v2=[tcc, tc2], fn=fn, cw=ras)
            : (rm == 6 || rm == 7 || rm == 8) ?
              polygon_arc_p(r=rr, o=vc, v1=[vc, tc1], v2=[vc, tc2], fn=fn, cw=!ras)
            : [tc1, tc2]
      )
      vpl
    ],

    // polygon points
    pp = merge_s( ppl )
  )
  (cw == true) ? pp : reverse(pp);

//! @}

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

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
