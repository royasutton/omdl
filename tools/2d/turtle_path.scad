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
// private helper functions
//----------------------------------------------------------------------------//

//! Dispatches a line segment to a straight or wave-line constructor.
/***************************************************************************//**
  \param    p0 <point-2d> The line start coordinate [x, y].
  \param    t <point-2d> The line end coordinate [x, y].
  \param    wc <datastruct> The waveform configuration `[p, a, w, m]`; undef for straight line.
  \param    fn <integer> The number of [facets]; optional.

  \returns  <point-2d-list> The list of coordinate points.

  \details

  Dispatches to either a straight line or a wave-line based on whether
  \p wc is defined. When \p wc is undef, returns `[t]` as a
  single-element point list. When \p wc is defined, delegates to
  polygon_line_wave_p() using the waveform configuration parameters.

  [facets]: \ref get_fn()

  \private
*******************************************************************************/
function _polygon_turtle_path_2d_p_line_p
(
  p0,
  t,
  wc,
  fn
) = is_undef( wc ) ? [t]
  : polygon_line_wave_p( p1=p0, p2=t, p=wc[0], a=wc[1], w=wc[2], m=wc[3], fn=fn );

//----------------------------------------------------------------------------//
// interpreter
//----------------------------------------------------------------------------//

//! Interprets a turtle-style step language to generate coordinate points for polygon construction.
/***************************************************************************//**
  \param    s     <datastruct> The list of steps.

  \param    p0    <point-2d> The initial coordinate [x, y].

  \param    h     <decimal> The current heading in degrees; 0 = positive
                  x-axis, positive angles rotate counter-clockwise

  \param    s_n   <integer> The current step number.

  \param    p0_g  <<point-2d> The global origin coordinate [x, y].


  \returns  <point-2d-list> The list of coordinate points of the path
            described in the list of steps \p s.

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

   operation    | short   | arguments (line)      | arguments (wave-line) | output coordinate point(s)
  :------------:|:-------:|:---------------------:|:---------------------:|:-----------------------:
   move_xy      | mxy     | x, y                  | x, y, wc, fn          | [x, y]
   move_x       | mx      | x                     | x, wc, fn             | [x, p0.y]
   move_y       | my      | y                     | y, wc, fn             | [p0.x, y]
   delta_xy     | dxy     | x, y                  | x, y, wc, fn          | p0 + [x, y]
   delta_x      | dx      | x                     | x, wc, fn             | p0 + [x, 0]
   delta_y      | dy      | y                     | y, wc, fn             | p0 + [0, y]
   delta_xa     | dxa     | x, a                  | x, a, wc, fn          | p0 + [ x, x * tan(a) ]
   delta_ya     | dya     | y, a                  | y, a, wc, fn          | p0 + l y / tan(a), y ]
   delta_v      | dv      | m, a                  | m, a, wc, fn          | p0 + line(m, a)
   arc_pv       | apv     | c, v, cw, fn          | (not supported)       | (see below)
   arc_vv       | avv     | v, v, cw, fn          | (not supported)       | (see below)
   path_p       | pp      | [p1, p2, ..., pn]     | (not supported)       | (see below)

  Some operations may generate either straight or periodic waveform
  lines. When a periodic waveform line is desired, additional
  parameters specify the waveform configuration and period fragment
  count as shown in the table above.

  ### Wave-line waveform configuration

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
  its documentation for more details and default value.

  ### arc_pv

    e | data type             | default value | parameter description
  :--:|:---------------------:|:-------------:|:------------------------------------
    0 | point-2d              | required      | \p c : arc center point [x, y]
    1 | point-2d \| decimal   | required      | \p v : arc stop angle [x, y] or a
    2 | boolean               | required      | \p cw : arc sweep direction
    3 | integer               |               | \p fn : the number of [facets]; optional

  This operation constructs an arc about a center point specified as a
  coordinate. The arc begins at the angle defined by the vector `[c,
  p0]` and ends at the angle defined by either the vector `[c, v]` or by
  the scalar angle \p v (in degrees). The sweep direction is controlled
  by \p cw; when \p cw is set to \p true, the arc is swept clockwise
  from the start angle to the stop angle. The optional parameter \p fn
  specifies the number of facets and, when omitted, is determined
  automatically by get_fn().

  ### arc_vv

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

  ### path_p

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
  \amu_define scope_id        (polygon_turtle_path_2d_p)
  \amu_define output_scad     (true)

  \amu_include (include/amu/scope_diagrams_3d.amu)

  The corners of this example 2d design plate have been rounded with
  the library function polygon_round_eve_all_p().

  [facets]: \ref get_fn()
  [Turtle graphics]: https://en.wikipedia.org/wiki/Turtle_(robot)
*******************************************************************************/
function polygon_turtle_path_2d_p
(
  s,
  p0 = origin2d,
  h = 0,
  s_n = 0,
  p0_g
) =
  ! is_list( s ) ? empty_lst
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

      //
      // compute the coordinate point(s) list for this operation step
      //
      p =
          //
          // lines; move
          //
          (oper == "move_xy" || oper == "mxy") && (argc > 1) ?
            let
            (
              t  = [a1, a2],
              wc = a3,
              fn = a4
            )
            _polygon_turtle_path_2d_p_line_p( p0=p0, t=t, wc=wc, fn=fn )

        : (oper == "move_x" || oper == "mx") && (argc > 0) ?
            let
            (
              t  = [a1, p0.y],
              wc = a2,
              fn = a3
            )
            _polygon_turtle_path_2d_p_line_p( p0=p0, t=t, wc=wc, fn=fn )

        : (oper == "move_y" || oper == "my") && (argc > 0) ?
            let
            (
              t  = [p0.x, a1],
              wc = a2,
              fn = a3
            )
            _polygon_turtle_path_2d_p_line_p( p0=p0, t=t, wc=wc, fn=fn )

          //
          // lines; delta
          //
        : (oper == "delta_xy" || oper == "dxy") && (argc > 1) ?
            let
            (
              t  = p0 + [a1, a2],
              wc = a3,
              fn = a4
            )
            _polygon_turtle_path_2d_p_line_p( p0=p0, t=t, wc=wc, fn=fn )

        : (oper == "delta_x"   || oper == "dx") && (argc > 0) ?
            let
            (
              t  = p0 + [a1, 0],
              wc = a2,
              fn = a3
            )
            _polygon_turtle_path_2d_p_line_p( p0=p0, t=t, wc=wc, fn=fn )

        : (oper == "delta_y"   || oper == "dy") && (argc > 0) ?
            let
            (
              t  = p0 + [0, a1],
              wc = a2,
              fn = a3
            )
            _polygon_turtle_path_2d_p_line_p( p0=p0, t=t, wc=wc, fn=fn )

          //
          // lines; delta angle
          //
        : (oper == "delta_xa"  || oper == "dxa") && (argc > 1) ?
            let
            (
              t  = p0 + [a1, a1 * tan(a2)],
              wc = a3,
              fn = a4
            )
            _polygon_turtle_path_2d_p_line_p( p0=p0, t=t, wc=wc, fn=fn )

        : (oper == "delta_ya"  || oper == "dya") && (argc > 1) ?
            let
            (
              t  = p0 + [a1 / tan(a2), a1],
              wc = a3,
              fn = a4
            )
            _polygon_turtle_path_2d_p_line_p( p0=p0, t=t, wc=wc, fn=fn )

          //
          // lines; delta vector
          //
        : (oper == "delta_v"   || oper == "dv") && (argc > 1) ?
            let
            (
              t  = line_tp( line2d_new(m=a1, a=a2, p1=p0) ),
              wc = a3,
              fn = a4
            )
            _polygon_turtle_path_2d_p_line_p( p0=p0, t=t, wc=wc, fn=fn )

          //
          // arc; center point
          //
        : (oper == "arc_pv" || oper == "apv") && (argc > 2) ?
          let
          ( // handle scalar angle or compute angle from vector
            v2  = is_list(a2) ? [a1, a2] : a2
          )
          polygon_arc_p( r=distance_pp(p0, a1), c=a1, v1=[a1, p0], v2=v2, cw=a3, fn=a4 )

          //
          // arc; center vector
          //
        : (oper == "arc_vv" || oper == "avv") && (argc > 2) ?
          let
          ( // calculate center point 'b1' from given vector [m, a] in 'a1'
            b1 = line_tp( line2d_new(m=first(a1), a=second(a1), p1=p0) ),
            v2 = is_list(a2) ? [b1, a2] : a2
          )
          polygon_arc_p( r=distance_pp(p0, b1), c=b1, v1=[b1, p0], v2=v2, cw=a3, fn=a4 )

          //
          // points
          //
        : (oper == "path_p" || oper == "pp") && (argc > 0) ?
          let
          (
            point_list = a1
          )
          point_list

          //
          // assert error
          //
        : assert
          (
            false,
            strl
            ([
                "ERROR: p0=", p0, ", h=", h, ", s_n=", s_n, ", p0_g=", p0_g,
                ", operation=", oper, ", argv=", argv, ", argc=", argc
            ])
          ),

      //
      // updates for next recursion step
      //
      next_s    = tailn(s),
      next_p0   = is_empty( p ) ? p0 : last( p ),
      next_h    = h,
      next_s_n  = s_n + 1,
      next_p0_g = is_undef( p0_g ) ? p0 : p0_g
    )
    ( len( s ) == 1 ) ?
      p
    : concat
      (
        p,
        polygon_turtle_path_2d_p( next_s, next_p0, next_h, next_s_n, next_p0_g )
      );

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE polygon_turtle_path_2d_p;
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
      ["move_y",   0],
      ["move_x",   0],
    ];

    // convert the step moves into coordinates
    pp = polygon_turtle_path_2d_p( sm );

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
