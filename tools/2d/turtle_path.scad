//! Turtle-style step language to generate coordinate points for polygon construction.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2024,2026

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

    \amu_define group_name  (Turtle)
    \amu_define group_brief (Turtle-style step language to generate coordinate points for polygon construction..)

  \amu_include (include/amu/doxyg_init_pd_gds_ipg.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/doxyg_define_in_parent_open.amu)
  \amu_include (include/amu/includes_required.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// private helper functions
//----------------------------------------------------------------------------//

//! Dispatches a line segment to a straight or wave-line constructor.
/***************************************************************************//**
  \param    p0  <point-2d> The line start coordinate [x, y].
  \param    t   <point-2d> The line end coordinate [x, y].
  \param    wc  <datastruct> The waveform configuration `[p, a, w, m]`;
                undef for straight line.
  \param    fn  <integer> The number of [facets]; optional.

  \returns  <point-2d-list> The list of coordinate points.

  \details

  Dispatches to either a straight line or a wave-line based on whether
  \p wc is defined. When \p wc is undef, returns `[t]` as a
  single-element point list. When \p wc is defined, delegates to
  polygon_line_wave_p() using the waveform configuration parameters.

  [facets]: \ref get_fn()

  \private
*******************************************************************************/
function _polygon_turtle_path_p_line_p
(
  p0,
  t,
  wc,
  fn
) = is_undef( wc ) ? [t]
  : polygon_line_wave_p( p1=p0, p2=t, p=wc[0], a=wc[1], w=wc[2], m=wc[3], fn=fn );

//! Recursively evaluates a sub-step list n times, threading state between iterations.
/***************************************************************************//**
  \param    sub_s   <datastruct> The sub-step list to repeat.
  \param    n       <integer> The number of iterations remaining.
  \param    p0      <point-2d> The current position.
  \param    h       <decimal> The current heading in degrees.
  \param    _p0_g   <point-2d> The global origin coordinate.

  \returns  <datastruct> `[point-2d-list, decimal]`; the concatenated
            point list of all iterations and the final heading after
            the last iteration.

  \private
*******************************************************************************/
function _polygon_turtle_path_p_repeat
(
  sub_s,
  n,
  p0,
  h,
  _p0_g
) = (n <= 0) ? [empty_lst, h]
  : let
    (
      result  = polygon_turtle_path_p( sub_s, p0, h, 1, 0, _p0_g ),
      pts     = result[0],
      next_p0 = is_empty(pts) ? p0 : last(pts),
      next_h  = result[1]
    )
    (n == 1) ? result
    : let
      (
        rest = _polygon_turtle_path_p_repeat( sub_s, n-1, next_p0, next_h, _p0_g )
      )
      [ concat( pts, rest[0] ), rest[1] ];

//----------------------------------------------------------------------------//
// interpreter
//----------------------------------------------------------------------------//

//! Interprets a turtle-style step language to generate coordinate points for polygon construction.
/***************************************************************************//**
  \param    s     <datastruct> The list of steps.

  \param    p0    <point-2d> The initial coordinate [x, y].

  \param    h     <decimal> The current heading in degrees; 0 =
                  positive x-axis, positive angles rotate
                  counter-clockwise.

  \param    m     <integer> The return mode. When \b 0 (default),
                  returns a `<point-2d-list>`. When \b 1, returns
                  `[point-2d-list, decimal]` where the second element
                  is the final heading after all steps have been
                  evaluated.

  \param    _s_n  <integer> The current step number.

  \param    _p0_g  <point-2d> The global origin coordinate [x, y].

  \returns  (1) <point-2d-list> when \p m is \b 0;
            (2) <datastruct> `[point-2d-list, decimal]` when \p m is \b 1.

  The returned list contains the coordinate points of the path
  described in the list of steps \p s. When \p m is \b 1 the final
  heading is appended as the second element of the returned pair.

  \details

  This function is a lightweight interpreter that converts a list of
  operation steps into coordinate points for polygon construction. It
  provides a convenient mechanism for defining polygons using a
  compact, step-based notation inspired by the Turtle graphics
  geometric drawing language. Each step produces one or more output
  points according to the schema described below.

  Data structure schema:

   name             | schema
  -----------------:|:----------------------------------------------
   s                | [ step, step, ..., step ]
   step             | [ operation, arg1, arg2, arg3, arg4 ]

  ## Operations

  The following table summarizes the supported operations, arguments,
  and their semantics.

   operation         | short   | arguments                                    || output coordinate point(s)
  :-----------------:|:-------:|:--------------------:|:----------------------:|:-----------------------:
   ^                 | ^       | minimum arguments    | extended arguments     | ^
   <h3> heading operations </h3> |||||
   \ref turn_left    | tl      | a                                            || (none)
   \ref turn_right   | tr      | a                                            || (none)
   <h3> line operations </h3> |||||
   \ref close        | cl      | (none)               | wc, fn                 | _p0_g
   \ref goto_xy      | gxy     | x, y                 | x, y, wc, fn           | [x, y]
   \ref goto_x       | gx      | x                    | x, wc, fn              | [x, p0.y]
   \ref goto_y       | gy      | y                    | y, wc, fn              | [p0.x, y]
   \ref delta_xy     | dxy     | x, y                 | x, y, wc, fn           | p0 + [x, y]
   \ref delta_x      | dx      | x                    | x, wc, fn              | p0 + [x, 0]
   \ref delta_y      | dy      | y                    | y, wc, fn              | p0 + [0, y]
   \ref delta_xa     | dxa     | x, a                 | x, a, wc, fn           | p0 + [ x, x * tan(a) ]
   \ref delta_ya     | dya     | y, a                 | y, a, wc, fn           | p0 + [ y / tan(a), y ]
   \ref move_ar      | mar     | m, a                 | m, a, wc, fn           | p0 + line(m, a)
   \ref move_rr      | mrr     | m, a                 | m, a, wc, fn           | p0 + line(m, h+a)
   \ref move_fw      | mfw     | m                    | m, wc, fn              | p0 + line(m, h)
   <h3> arc operations </h3> |||||
   \ref arc_fw       | afw     | r, a                 | r, a, [o], fn          | \ref arc_fw    "(see below)"
   \ref arc_pv       | apv     | c, v, cw, fn                                 || \ref arc_pv    "(see below)"
   \ref arc_vv       | avv     | v, v, cw, fn                                 || \ref arc_vv    "(see below)"
   \ref arc_blend    | ab      | p2, p3, r            | p2, p3, r, fn          | \ref arc_blend "(see below)"
   <h3> curve operations </h3> |||||
   \ref bezier       | bz      | ctrl_pts             | ctrl_pts, [o], fn      | \ref bezier    "(see below)"
   \ref spline       | spl     | knots                | knots, [o], fn         | \ref spline    "(see below)"
   <h3> sub-step operations </h3> |||||
   \ref repeat       | rpt     | steps                | steps, n               | \ref repeat    "(see below)"
   \ref repeat_mx    | rptmx   | steps, axis          | steps, axis, [o]       | \ref repeat_mx "(see below)"
   \ref repeat_my    | rptmy   | steps, axis          | steps, axis, [o]       | \ref repeat_my "(see below)"
   \ref transform    | xfrm    | steps, r             | steps, r, t, mn, [o]   | \ref transform "(see below)"
   <h3> point operations </h3> |||||
   \ref path_p       | pp      | [p1, p2, ..., pn]                            || \ref path_p    "(see below)"

  The two argument columns divide the minimum form from the extended
  form: the left column shows the minimum required arguments, and the
  right column shows the extended form with additional optional
  parameters.

  Some operations may generate either straight or periodic waveform
  lines. When a periodic waveform line is desired, additional
  parameters specify the waveform configuration and period fragment
  count as shown in the table above.

  ## Wave-line waveform configuration

    e | data type             | default value | parameter description
  :--:|:---------------------:|:-------------:|:------------------------------------
   \* | datastruct            | required      | \p wc : waveform configuration `[p, a, w, m]`
   \* | integer               |               | \p fn : number of [facets]; optional

  #### wc

    e | data type             | default value | parameter description
  :--:|:---------------------:|:-------------:|:------------------------------------
    0 | decimal               | see below     | \p p : period length
    1 | decimal-list-3 \| decimal | see below | \p a : amplitude configuration
    2 | datastruct \| integer | see below     | \p w : waveform shape configuration
    3 | datastruct \| integer | see below     | \p m : time-axis remapping mode configuration

  Wave-line constructs a line with periodic waveform lateral
  displacement to the next point using \p polygon_line_wave_p(). See
  its documentation for more details and default value. All line
  operations accept the optional \p wc and \p fn parameters to produce
  a wave-line in place of a straight segment.

  ## Heading operations

  \subsubsection turn_left

  Rotates the current heading counter-clockwise by \p a degrees.
  Produces no output coordinate points; only the heading \p h is
  updated for subsequent steps.

  \subsubsection turn_right

  Rotates the current heading clockwise by \p a degrees. Produces no
  output coordinate points; only the heading \p h is updated for
  subsequent steps.

  ## Line operations

  \subsubsection close

  Closes the path by returning to the global origin \p _p0_g with a
  straight or wave-line segment. When no arguments are given, a
  straight line is drawn. The global origin is set automatically on the
  first step and remains fixed for the lifetime of the recursion.

  \subsubsection goto_xy

  Moves to the absolute coordinate `[x, y]`, ignoring the current
  position.

  \subsubsection goto_x

  Moves to the absolute x-axis coordinate \p x, retaining the current
  y-axis coordinate.

  \subsubsection goto_y

  Moves to the absolute y-axis coordinate \p y, retaining the current
  x-axis coordinate.

  \subsubsection delta_xy

  Moves from the current position by the relative offset `[x, y]`.

  \subsubsection delta_x

  Moves from the current position by the relative x-axis offset \p x,
  with no y-axis displacement.

  \subsubsection delta_y

  Moves from the current position by the relative y-axis offset \p y,
  with no x-axis displacement.

  \subsubsection delta_xa

    e | data type             | default value | parameter description
  :--:|:---------------------:|:-------------:|:------------------------------------
    0 | decimal               | required      | \p x : x-axis displacement
    1 | decimal               | required      | \p a : angle in degrees from the x-axis

  Moves from the current position by the relative offset `[x, x *
  tan(a)]`, where the y-axis displacement is derived from the x-axis
  displacement \p x and the angle \p a. This is convenient when the
  horizontal extent of a step is known and the slope angle is the
  natural constraint.

  \subsubsection delta_ya

    e | data type             | default value | parameter description
  :--:|:---------------------:|:-------------:|:------------------------------------
    0 | decimal               | required      | \p y : y-axis displacement
    1 | decimal               | required      | \p a : angle in degrees from the x-axis

  Moves from the current position by the relative offset `[y / tan(a),
  y]`, where the x-axis displacement is derived from the y-axis
  displacement \p y and the angle \p a. This is the complement of \p
  delta_xa and is convenient when the vertical extent of a step is
  known and the slope angle is the natural constraint.

  \subsubsection move_ar

    e | data type             | default value | parameter description
  :--:|:---------------------:|:-------------:|:------------------------------------
    0 | decimal               | required      | \p m : radial distance
    1 | decimal               | required      | \p a : absolute angle in degrees

  Moves from the current position by distance \p m at the absolute
  angle \p a, measured from the positive x-axis. The heading \p h is
  not consulted.

  \subsubsection move_rr

    e | data type             | default value | parameter description
  :--:|:---------------------:|:-------------:|:------------------------------------
    0 | decimal               | required      | \p m : radial distance
    1 | decimal               | required      | \p a : angle offset in degrees relative to current heading

  Moves from the current position by distance \p m at an angle of `h +
  a`, where \p h is the current heading. When \p a is zero this
  operation is equivalent to \p move_fw.

  \subsubsection move_fw

  Moves forward from the current position by distance \p m along the
  current heading \p h. Equivalent to \p move_rr with \p a set to zero.

  ## Arc operations

  \subsubsection arc_fw

    e | data type             | default value | parameter description
  :--:|:---------------------:|:-------------:|:------------------------------------
    0 | decimal               | required      | \p r : arc radius; must be positive
    1 | decimal               | required      | \p a : signed sweep angle in degrees; positive = CCW (left turn), negative = CW (right turn)
    2 | datastruct            |               | \p [o] : options `[update_heading]`; optional; assign \b undef to accept all option defaults when only \p fn is needed
    3 | integer               |               | \p fn : number of [facets]; optional

  #### arc_fw[2]: o

    e | data type             | default value | parameter description
  :--:|:---------------------:|:-------------:|:------------------------------------
    0 | boolean               | true          | \p update_heading : when \b true the heading is advanced by \p a degrees on exit; when \b false the entry heading \p h is restored

  Sweeps an arc of radius \p r through the signed angle \p a starting
  from the current position \p p0 and following the current heading \p
  h. The arc center lies perpendicular to \p h at distance \p r: to the
  left (`h + 90°`) when \p a is positive and to the right (`h - 90°`)
  when \p a is negative. The arc is delegated to polygon_arc_sweep_p().
  Returns \b empty_lst when \p a is zero. By default the heading is
  updated to `h + a` on exit, so chained `arc_fw` steps flow naturally
  without manual heading bookkeeping. Pass `[o] = [false]` to suppress
  the heading update. Pass `[o] = undef` to accept all option defaults
  while still supplying \p fn.

  \subsubsection arc_pv

    e | data type             | default value | parameter description
  :--:|:---------------------:|:-------------:|:------------------------------------
    0 | point-2d              | required      | \p c : arc center point [x, y]
    1 | point-2d \| decimal   | required      | \p v : arc stop angle [x, y] or a
    2 | boolean               | required      | \p cw : arc sweep direction
    3 | integer               |               | \p fn : the number of [facets]; optional

  This operation constructs an arc about a center point specified as a
  coordinate. The arc begins at the angle defined by the vector `[c,
  p0]` and ends at the angle defined by either the vector `[c, v]` or
  by the scalar angle \p v (in degrees). The sweep direction is
  controlled by \p cw; when \p cw is set to \p true, the arc is swept
  clockwise from the start angle to the stop angle. The optional
  parameter \p fn specifies the number of facets and, when omitted, is
  determined automatically by get_fn().

  \subsubsection arc_vv

    e | data type             | default value | parameter description
  :--:|:---------------------:|:-------------:|:------------------------------------
    0 | decimal-list-2        | required      | \p c : arc center point [m, a]
    1 | point-2d \| decimal   | required      | \p v : arc stop angle [x, y] or a
    2 | boolean               | required      | \p cw : arc sweep direction
    3 | integer               |               | \p fn : number of [facets]; optional

  This operation constructs an arc about a center point specified as a
  vector `[m, a]` originating from the current position. The arc begins
  at the angle defined by the vector `[c, p0]` and ends at the angle
  defined by either the vector `[c, v]` or by the scalar angle \p v (in
  degrees). The sweep direction is controlled by \p cw; when \p cw is
  set to \p true, the arc is swept clockwise from the start angle to
  the stop angle. The optional parameter \p fn specifies the number of
  facets and, when omitted, is determined automatically by get_fn().

  \subsubsection arc_blend

    e | data type             | default value | parameter description
  :--:|:---------------------:|:-------------:|:------------------------------------
    0 | point-2d              | required      | \p p2 : corner vertex coordinate [x, y]; the point where the two segments meet
    1 | point-2d              | required      | \p p3 : end point of the outgoing segment [x, y]
    2 | decimal               | required      | \p r : blend radius; must be positive
    3 | integer               |               | \p fn : number of [facets]; optional

  Replaces the sharp corner at \p p2 with a circular arc of radius \p r
  that is tangent to both the incoming segment `[p0, p2]` and the
  outgoing segment `[p2, p3]`. The current position \p p0 supplies the
  start point of the incoming segment. Only the arc points are emitted;
  the corner vertex \p p2 is not included. Delegates to
  polygon_arc_blend_p(). The heading \p h is not updated by this
  operation.

  ## Curve operations

  \subsubsection bezier

    e | data type             | default value | parameter description
  :--:|:---------------------:|:-------------:|:------------------------------------
    0 | point-2d-list         | required      | \p ctrl_pts : Bézier control point list [[x, y], ...]
    1 | datastruct            |               | \p [o] : options `[prepend_p0]`; optional; assign \b undef to accept all option defaults when only \p fn is needed
    2 | integer               |               | \p fn : number of [facets]; optional

  #### bezier[1]: o

    e | data type             | default value | parameter description
  :--:|:---------------------:|:-------------:|:------------------------------------
    0 | boolean               | true          | \p prepend_p0 : when \b true the current position \p p0 is automatically prepended to \p ctrl_pts as the first control point

  Evaluates a degree-n Bézier curve defined by the control point list
  \p ctrl_pts using the de Casteljau algorithm. When \p prepend_p0 is
  \b true (the default) the current position \p p0 is inserted as the
  first control point so the curve departs smoothly from the last
  emitted point. Pass `[o] = [false]` when \p ctrl_pts already contains
  the intended start point. Pass `[o] = undef` to accept all option
  defaults while still supplying \p fn. The heading \p h is not updated
  by this operation. Delegates to polygon_bezier_p().

  \subsubsection spline

    e | data type             | default value | parameter description
  :--:|:---------------------:|:-------------:|:------------------------------------
    0 | point-2d-list         | required      | \p knots : Catmull-Rom knot list [[x, y], ...]
    1 | datastruct            |               | \p [o] : options `[prepend_p0, closed]`; optional; assign \b undef to accept all option defaults when only \p fn is needed
    2 | integer               |               | \p fn : facets per segment; optional

  #### spline[1]: o

    e | data type             | default value | parameter description
  :--:|:---------------------:|:-------------:|:------------------------------------
    0 | boolean               | true          | \p prepend_p0 : when \b true the current position \p p0 is automatically prepended to \p knots as the first knot
    1 | boolean               | false         | \p closed : when \b true a closing segment is added from the last knot back to the first knot

  Evaluates a centripetal Catmull-Rom spline through the knot list \p
  knots. The curve passes through every knot point. When \p prepend_p0
  is \b true (the default) the current position \p p0 is inserted as
  the first knot so the spline departs from the last emitted point.
  When \p closed is \b true a closing segment from the last knot back
  to the first is included. Pass `[o] = undef` to accept all option
  defaults while still supplying \p fn. The heading \p h is not updated
  by this operation. Delegates to polygon_spline_p().

  ## Sub-step operations

  \subsubsection repeat

    e | data type             | default value | parameter description
  :--:|:---------------------:|:-------------:|:------------------------------------
    0 | datastruct            | required      | \p steps : sub-step list
    1 | integer               | 1             | \p n : number of repetitions; optional

  Evaluates the sub-step list \p steps \p n times in sequence. Each
  iteration begins where the previous left off, carrying \p p0, \p h,
  and \p _p0_g forward between iterations. The heading evolved inside
  the sub-steps carries back into the outer step list after all
  iterations complete. When \p n is omitted the sub-steps are evaluated
  once, making \p repeat useful as a plain grouping mechanism. Nesting
  is supported to arbitrary depth.

  \subsubsection repeat_mx

    e | data type             | default value | parameter description
  :--:|:---------------------:|:-------------:|:------------------------------------
    0 | datastruct            | required      | \p steps : sub-step list
    1 | decimal               | 0             | \p axis : scalar offset of the mirror axis from \p p0 along the y-axis; optional
    2 | datastruct            |               | \p o : options `[reverse, heading, mirror_start]`; optional

  #### repeat_mx[2]: o

    e | data type             | default value | parameter description
  :--:|:---------------------:|:-------------:|:------------------------------------
    0 | boolean               | true          | \p reverse : reverse the mirrored point list for correct polygon winding
    1 | boolean               | true          | \p heading : when true, carry the final heading of the forward pass back into the outer step list; when false, restore the entry heading
    2 | boolean               | true          | \p mirror_start : begin the mirrored pass from \p p0; when false, begin from the end of the forward pass

  Evaluates \p steps once to produce a forward point list, then mirrors
  all output points about a horizontal axis at `p0.y + axis`. The
  mirrored list is appended after the forward list to produce a
  top-bottom symmetric profile in a single operation. The options
  bundle \p o controls winding order, heading continuity, and the start
  point of the mirrored pass. Nesting is supported to arbitrary depth.

  \subsubsection repeat_my

    e | data type             | default value | parameter description
  :--:|:---------------------:|:-------------:|:------------------------------------
    0 | datastruct            | required      | \p steps : sub-step list
    1 | decimal               | 0             | \p axis : scalar offset of the mirror axis from \p p0 along the x-axis; optional
    2 | datastruct            |               | \p o : options `[reverse, heading, mirror_start]`; optional

  #### repeat_my[2]: o

    e | data type             | default value | parameter description
  :--:|:---------------------:|:-------------:|:------------------------------------
    0 | boolean               | true          | \p reverse : reverse the mirrored point list for correct polygon winding
    1 | boolean               | true          | \p heading : when true, carry the final heading of the forward pass back into the outer step list; when false, restore the entry heading
    2 | boolean               | true          | \p mirror_start : begin the mirrored pass from \p p0; when false, begin from the end of the forward pass

  Evaluates \p steps once to produce a forward point list, then mirrors
  all output points about a vertical axis at `p0.x + axis`. The
  mirrored list is appended after the forward list to produce a
  left-right symmetric profile in a single operation. The options
  bundle \p o controls winding order, heading continuity, and the start
  point of the mirrored pass. Nesting is supported to arbitrary depth.

  \subsubsection transform

    e | data type             | default value | parameter description
  :--:|:---------------------:|:-------------:|:------------------------------------
    0 | datastruct            | required      | \p steps : sub-step list
    1 | decimal               | required      | \p r : rotation angle in degrees, applied about \p p0
    2 | point-2d              | [0, 0]        | \p t : translation vector `[x, y]`; optional
    3 | vector-2d             | undef         | \p mn : mirror normal vector `[nx, ny]`; applied before rotation; optional
    4 | datastruct            |               | \p o : options `[update_p0, update_h]`; optional

  #### transform[4]: o

    e | data type             | default value | parameter description
  :--:|:---------------------:|:-------------:|:------------------------------------
    0 | boolean               | false         | \p update_p0 : when \b true, advance the parent \p p0 to the last transformed point after the operation
    1 | boolean               | o[0]          | \p update_h : when \b true, update the parent \p h to `h_final + r` after the operation; defaults to \p update_p0 when not specified

  Evaluates \p steps to produce a point list, then applies a 2D affine
  transformation to every output point via transform_p(). Mirror \p mn
  is applied first about the entry position \p p0, followed by rotation
  \p r about \p p0, then translation \p t. When \p mn is \b undef no
  mirror is applied. When both options are false (the default) the
  parent \p p0 and \p h are unchanged after the operation, making \p
  transform a pure geometric post-processor. \p update_p0 and \p
  update_h may be set independently: for example, pass `[true, false]`
  to advance \p p0 to the last transformed point while preserving the
  entry heading, or `[false, true]` to carry the rotated heading forward
  while keeping the turtle anchored at its entry position. When only
  \p update_p0 is supplied (e.g. `[true]`), \p update_h inherits the
  same value. Nesting is supported to arbitrary depth.

  ## Point operations

  \subsubsection path_p

    e | data type             | default value | parameter description
  :--:|:---------------------:|:-------------:|:------------------------------------
    0 | point-2d-list         | required      | path list of 2d points

  Inserts a list of 2D points `[x, y]` into the output at the current
  step, specified as a single argument containing the point list. Care
  should be taken to ensure a smooth transition between the end of the
  previous step and the start of the inserted points.

  \amu_define title           (Motor mount plate design example)
  \amu_define image_views     (top diag)
  \amu_define image_size      (sxga)
  \amu_define scope_id        (polygon_turtle_path_p)
  \amu_define output_scad     (true)

  \amu_include (include/amu/scope_diagrams_3d.amu)

  The corners of this example 2d design plate have been rounded with
  the library function polygon_round_eve_all_p().

  [facets]: \ref get_fn()
  [Turtle graphics]: https://en.wikipedia.org/wiki/Turtle_(robot)
*******************************************************************************/
function polygon_turtle_path_p
(
  s,
  p0  = origin2d,
  h   = 0,
  m   = 0,
  _s_n = 0,
  _p0_g
) =
  ! is_list( s ) ? ( m == 1 ? [empty_lst, h] : empty_lst )
  : let
    (
      // get current step
      step = first( s ),

      // get operation, argument vector, and argument count
      oper = first( step ),
      argv = tailn( step ),
      argc = is_undef( argv ) ? 0 : is_list( argv ) ? len( argv ) : 1,

      // assign arguments
      a1 = argv[0],
      a2 = argv[1],
      a3 = argv[2],
      a4 = argv[3],
      a5 = argv[4],

      //
      // compute the coordinate point(s) and heading for this operation step.
      // ph = [point-2d-list, heading] for every branch.
      //
      ph =
          //
          // heading; turn left (counter-clockwise)
          //
          is_oneof( oper, ["turn_left", "tl"] ) && (argc > 0) ?
            [ empty_lst, h + a1 ]

          //
          // heading; turn right (clockwise)
          //
        : is_oneof( oper, ["turn_right", "tr"] ) && (argc > 0) ?
            [ empty_lst, h - a1 ]

          //
          // lines; close path (return to global origin)
          //
        : is_oneof( oper, ["close", "cl"] ) ?
            let
            (
              g  = defined_or( _p0_g, p0 ),  // step-1 guard
              wc = a1,
              fn = a2
            )
            [ _polygon_turtle_path_p_line_p( p0=p0, t=g, wc=wc, fn=fn ), h ]

          //
          // lines; goto (absolute position)
          //
        : is_oneof( oper, ["goto_xy", "gxy"] ) && (argc > 1) ?
            let( t = [a1, a2], wc = a3, fn = a4 )
            [ _polygon_turtle_path_p_line_p( p0=p0, t=t, wc=wc, fn=fn ), h ]

        : is_oneof( oper, ["goto_x", "gx"] ) && (argc > 0) ?
            let( t = [a1, p0.y], wc = a2, fn = a3 )
            [ _polygon_turtle_path_p_line_p( p0=p0, t=t, wc=wc, fn=fn ), h ]

        : is_oneof( oper, ["goto_y", "gy"] ) && (argc > 0) ?
            let( t = [p0.x, a1], wc = a2, fn = a3 )
            [ _polygon_turtle_path_p_line_p( p0=p0, t=t, wc=wc, fn=fn ), h ]

          //
          // lines; delta
          //
        : is_oneof( oper, ["delta_xy", "dxy"] ) && (argc > 1) ?
            let( t = p0 + [a1, a2], wc = a3, fn = a4 )
            [ _polygon_turtle_path_p_line_p( p0=p0, t=t, wc=wc, fn=fn ), h ]

        : is_oneof( oper, ["delta_x", "dx"] ) && (argc > 0) ?
            let( t = p0 + [a1, 0], wc = a2, fn = a3 )
            [ _polygon_turtle_path_p_line_p( p0=p0, t=t, wc=wc, fn=fn ), h ]

        : is_oneof( oper, ["delta_y", "dy"] ) && (argc > 0) ?
            let( t = p0 + [0, a1], wc = a2, fn = a3 )
            [ _polygon_turtle_path_p_line_p( p0=p0, t=t, wc=wc, fn=fn ), h ]

          //
          // lines; delta angle
          //
        : is_oneof( oper, ["delta_xa", "dxa"] ) && (argc > 1) ?
            let( t = p0 + [a1, a1 * tan(a2)], wc = a3, fn = a4 )
            [ _polygon_turtle_path_p_line_p( p0=p0, t=t, wc=wc, fn=fn ), h ]

        : is_oneof( oper, ["delta_ya", "dya"] ) && (argc > 1) ?
            let( t = p0 + [a1 / tan(a2), a1], wc = a3, fn = a4 )
            [ _polygon_turtle_path_p_line_p( p0=p0, t=t, wc=wc, fn=fn ), h ]

          //
          // lines; move radial absolute
          //
        : is_oneof( oper, ["move_ar", "mar"] ) && (argc > 1) ?
            let( t = line_tp( line2d_new(m=a1, a=a2, p1=p0) ), wc = a3, fn = a4 )
            [ _polygon_turtle_path_p_line_p( p0=p0, t=t, wc=wc, fn=fn ), h ]

          //
          // lines; move radial relative (to current heading)
          //
        : is_oneof( oper, ["move_rr", "mrr"] ) && (argc > 1) ?
            let( t = line_tp( line2d_new(m=a1, a=h+a2, p1=p0) ), wc = a3, fn = a4 )
            [ _polygon_turtle_path_p_line_p( p0=p0, t=t, wc=wc, fn=fn ), h ]

          //
          // lines; move forward (along current heading)
          //
        : is_oneof( oper, ["move_fw", "mfw"] ) && (argc > 0) ?
            let( t = line_tp( line2d_new(m=a1, a=h, p1=p0) ), wc = a2, fn = a3 )
            [ _polygon_turtle_path_p_line_p( p0=p0, t=t, wc=wc, fn=fn ), h ]

          //
          // arc; forward sweep (heading-relative, optional heading update)
          //
        : is_oneof( oper, ["arc_fw", "afw"] ) && (argc > 1) ?
            let
            (
              r   = a1,
              a   = a2,
              o   = a3,
              fn  = a4,
              upd = defined_eonb_or( o, 0, true ),

              // arc center: perpendicular to heading, left for a>0 right for a<0
              perp_sign = (a >= 0) ? 1 : -1,
              h_perp    = h + perp_sign * 90,
              c_arc     = p0 + r * [cos(h_perp), sin(h_perp)],

              // start and end angles measured from arc center
              a_start   = h + perp_sign * (-90),   // direction c_arc to p0
              a_end     = a_start + a,              // sweep by a (signed)

              pts = (a == 0) ? empty_lst
                  : polygon_arc_sweep_p
                    (
                      r  = r,
                      o  = c_arc,
                      v1 = a_start,
                      v2 = a_end,
                      fn = fn,
                      cw = (a < 0)
                    ),

              out_h = upd ? h + a : h
            )
            [ pts, out_h ]

          //
          // arc; center point
          //
        : is_oneof( oper, ["arc_pv", "apv"] ) && (argc > 2) ?
            let( v2 = is_list(a2) ? [a1, a2] : a2 )
            [
              polygon_arc_sweep_p( r=distance_pp(p0, a1), o=a1, v1=[a1, p0], v2=v2, cw=a3, fn=a4 ),
              h
            ]

          //
          // arc; center vector
          //
        : is_oneof( oper, ["arc_vv", "avv"] ) && (argc > 2) ?
            let
            (
              b1 = line_tp( line2d_new(m=first(a1), a=second(a1), p1=p0) ),
              v2 = is_list(a2) ? [b1, a2] : a2
            )
            [
              polygon_arc_sweep_p( r=distance_pp(p0, b1), o=b1, v1=[b1, p0], v2=v2, cw=a3, fn=a4 ),
              h
            ]

          //
          // arc; blend corner (tangent arc through corner vertex)
          //
        : is_oneof( oper, ["arc_blend", "ab"] ) && (argc > 2) ?
            [
              polygon_arc_blend_p( p1=p0, p2=a1, p3=a2, r=a3, fn=a4 ),
              h
            ]

          //
          // curve; Bézier (degree-n, de Casteljau)
          //
        : is_oneof( oper, ["bezier", "bz"] ) && (argc > 0) ?
            let
            (
              ctrl_pts  = a1,
              o         = a2,
              fn        = a3,
              pre       = defined_eonb_or( o, 0, true ),
              pts       = pre ? concat( [p0], ctrl_pts ) : ctrl_pts
            )
            [ polygon_bezier_p( c=pts, fn=fn ), h ]

          //
          // curve; Catmull-Rom spline (through knots)
          //
        : is_oneof( oper, ["spline", "spl"] ) && (argc > 0) ?
            let
            (
              knots   = a1,
              o       = a2,
              fn      = a3,
              pre     = defined_eonb_or( o, 0, true ),
              closed  = defined_e_or   ( o, 1, false ),
              pts     = pre ? concat( [p0], knots ) : knots
            )
            [ polygon_spline_p( c=pts, fn=fn, closed=closed ), h ]

          //
          // sub-steps; repeat
          //
        : is_oneof( oper, ["repeat", "rpt"] ) && (argc > 0) ?
            let
            (
              sub_s  = a1,
              n      = defined_or( a2, 1 ),
              result = _polygon_turtle_path_p_repeat( sub_s, n, p0, h, _p0_g )
            )
            result  // already [pts, final_h]

          //
          // sub-steps; repeat mirror-x (about horizontal axis)
          //
        : is_oneof( oper, ["repeat_mx", "rptmx"] ) && (argc > 0) ?
            let
            (
              sub_s = a1,
              axis  = defined_or( a2, 0 ),
              o     = a3,
              rev   = defined_eonb_or( o, 0, true ),
              kh    = defined_e_or   ( o, 1, true ),
              ms    = defined_e_or   ( o, 2, true ),

              // forward pass — recover points and final heading
              fwd_r      = polygon_turtle_path_p( sub_s, p0, h, 1, _s_n, _p0_g ),
              fwd        = fwd_r[0],
              fwd_h      = fwd_r[1],
              fwd_p0_end = is_empty(fwd) ? p0 : last(fwd),

              // mirror axis origin: p0.y + axis offset
              ax_o    = [ p0.x, p0.y + axis ],

              // start point for mirrored pass (reflected onto axis)
              mir_p0  = ms ? mirror_p( [p0],         [0,1], ax_o )[0]
                           : mirror_p( [fwd_p0_end], [0,1], ax_o )[0],

              // mirrored pass: run sub-steps from reflected start
              mir_raw = polygon_turtle_path_p( sub_s, mir_p0, h, 1, _s_n, _p0_g ),

              // reflect output points back about the axis using mirror_p
              mir     = mirror_p( mir_raw[0], [0,1], ax_o ),
              mir_out = rev ? list_reverse(mir) : mir,

              // heading carried back: forward final heading or entry heading
              out_h   = kh ? fwd_h : h
            )
            [ concat( fwd, mir_out ), out_h ]

          //
          // sub-steps; repeat mirror-y (about vertical axis)
          //
        : is_oneof( oper, ["repeat_my", "rptmy"] ) && (argc > 0) ?
            let
            (
              sub_s = a1,
              axis  = defined_or( a2, 0 ),
              o     = a3,
              rev   = defined_eonb_or( o, 0, true ),
              kh    = defined_e_or   ( o, 1, true ),
              ms    = defined_e_or   ( o, 2, true ),

              // forward pass — recover points and final heading
              fwd_r      = polygon_turtle_path_p( sub_s, p0, h, 1, _s_n, _p0_g ),
              fwd        = fwd_r[0],
              fwd_h      = fwd_r[1],
              fwd_p0_end = is_empty(fwd) ? p0 : last(fwd),

              // mirror axis origin: p0.x + axis offset
              ax_o    = [ p0.x + axis, p0.y ],

              // start point for mirrored pass (reflected onto axis)
              mir_p0  = ms ? mirror_p( [p0],         [1,0], ax_o )[0]
                           : mirror_p( [fwd_p0_end], [1,0], ax_o )[0],

              // mirrored pass: run sub-steps from reflected start
              mir_raw = polygon_turtle_path_p( sub_s, mir_p0, h, 1, _s_n, _p0_g ),

              // reflect output points back about the axis using mirror_p
              mir     = mirror_p( mir_raw[0], [1,0], ax_o ),
              mir_out = rev ? list_reverse(mir) : mir,

              // heading carried back: forward final heading or entry heading
              out_h   = kh ? fwd_h : h
            )
            [ concat( fwd, mir_out ), out_h ]

          //
          // sub-steps; transform (rotate then translate)
          //
        : is_oneof( oper, ["transform", "xfrm"] ) && (argc > 1) ?
            let
            (
              sub_s  = a1,
              r      = a2,
              t      = defined_or( a3, [0,0] ),
              mn     = a4,
              o      = a5,
              upd_p0 = defined_eonb_or( o, 0, false ),
              upd_h  = defined_e_or   ( o, 1, upd_p0 ),

              // evaluate sub-steps — recover points and final heading
              sub_r = polygon_turtle_path_p( sub_s, p0, h, 1, _s_n, _p0_g ),
              sub_h = sub_r[1],

              // apply mirror about p0, rotation about p0, then translation
              xfmd  = transform_p( c=sub_r[0], m=mn, a=r, t=t, o=p0 ),

              // heading: rotated sub-step final heading when updating, else entry heading
              out_h = upd_h ? sub_h + r : h
            )
            [ xfmd, out_h ]

          //
          // points
          //
        : is_oneof( oper, ["path_p", "pp"] ) && (argc > 0) ?
            [ a1, h ]

          //
          // assert error
          //
        : assert
          (
            false,
            strl
            ([
                "ERROR: p0=", p0, ", h=", h, ", _s_n=", _s_n, ", _p0_g=", _p0_g,
                ", operation=", oper, ", argv=", argv, ", argc=", argc
            ])
          ),

      //
      // unpack this step's point list and evolved heading from ph
      //
      p         = ph[0],
      step_h    = ph[1],

      //
      // recursion next step updates
      //

      next_s    = tailn(s),

      // transform: advance only when upd_p0=true, else restore entry position
      // repeat, repeat_mx, repeat_my: always advance to end of combined output
      next_p0   = let ( end_p = is_empty(p) ? p0 : last(p) )
                  is_oneof( oper, ["transform", "xfrm"] ) ?
                  let ( upd_p0 = defined_eonb_or( a5, 0, false ) )
                  upd_p0 ? end_p : p0
                : end_p,

      // transform: only update when upd_h=true, heading already encoded in step_h
      next_h    = is_oneof( oper, ["transform", "xfrm"] ) ?
                  let
                  (
                    upd_p0 = defined_eonb_or( a5, 0, false ),
                    upd_h  = defined_e_or   ( a5, 1, upd_p0 )
                  )
                  upd_h ? step_h : h
                : step_h,

      next_s_n  = _s_n + 1,
      next_p0_g = defined_or( _p0_g, p0 ),

      //
      // recurse or terminate — single recursive call, unpack once
      //
      term      = len(s) == 1,

      rest      = term ? [empty_lst, next_h]
                : polygon_turtle_path_p( next_s, next_p0, next_h, 1, next_s_n, next_p0_g ),

      result    = term ? p      : concat( p, rest[0] ),
      final_h   = term ? next_h : rest[1]
    )
    m == 1 ? [result, final_h] : result;

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE polygon_turtle_path_p;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <tools/2d/turtle_path.scad>;

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
      ["goto_y",   0],
      ["goto_x",   0],
    ];

    // convert the step moves into coordinates
    pp = polygon_turtle_path_p( sm );

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

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
