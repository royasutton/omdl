//! Turtle-style step language to generate coordinate points for polygon construction.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2024

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

//! Interprets a turtle-style step language to generate coordinate points for polygon construction.
/***************************************************************************//**
  \param    s <datastruct> The list of steps.
  \param    i <point-2d> The initial coordinate [x, y].
  \param    c <integer> (an internal recursion step count)

  \returns  <point-2d-list> The list of coordinate points.

  \details

  This function is a lightweight interpreter that converts a list of
  operation steps into coordinate points for polygon construction. It
  provides a convenient mechanism for defining polygons using a
  compact, step-based notation inspired by the Turtle graphics
  geometric drawing language. Each step produces one or more output
  points according to the schema described below.

  Data structure schema:

  name            | schema
  ---------------:|:----------------------------------------------
  s               | [ step, step, ..., step ]
  step            | [ operation, arguments ]
  arguments       | [ arg, arg, ..., arg ]

  The following table summarizes the supported operations and their
  semantics.

   operation  | short | arguments         | output coordinate point
  :-----------|:-----:|:-----------------:|:-----------------------
   move_xy    | mxy   | [x, y]            | [x, y]
   move_x     | mx    | x                 | [x, i.y]
   move_y     | my    | y                 | [i.x, y]
   delta_xy   | dxy   | [x, y]            | i + [x, y]
   delta_x    | dx    | x                 | i + [x, 0]
   delta_y    | dy    | y                 | i + [0, y]
   delta_xa   | dxa   | [x, a]            | i + [ x, x * tan(a) ]
   delta_ya   | dya   | [y, a]            | i + l y / tan(a), y ]
   delta_v    | dv    | [m, a]            | i + line(m, a)
   arc_pv     | apv   | [c, v, cw, fn]    | (see below)
   arc_vv     | avv   | [v, v, cw, fn]    | (see below)

  When an operation requires only a single argument, the argument may
  be specified either as a scalar value or as a single-element list.

  ## Operations

  ### arc_pv

    e | data type                             | parameter description
  ---:|:-------------------------------------:|:------------------------------------
    c | <point-2d>                            | arc center point [x, y]
    v | <point-2d> \| <decimal>               | arc stop angle [x, y] or a
   cw | <boolean>                             | arc sweep direction
   fn | <integer>                             | the number of [facets] \(optional\)

  This operation constructs an arc about a center point specified as a
  coordinate. The arc begins at the angle defined by the vector `[c,
  i]` and ends at the angle defined by either the vector `[c, v]` or by
  the scalar angle \p v (in degrees). The sweep direction is controlled
  by \p cw; when \p cw is set to \p true, the arc is swept clockwise
  from the start angle to the stop angle. The optional parameter \p fn
  specifies the number of facets and, when omitted, is determined
  automatically by get_fn().


  ### arc_vv

    e | data type                             | parameter description
  ---:|:-------------------------------------:|:------------------------------------
    c | <decimal-list-2>                      | arc center point [m, a]
    v | <point-2d> \| <decimal>               | arc stop angle [x, y] or a
   cw | <boolean>                             | arc sweep direction
   fn | <integer>                             | the number of [facets] \(optional\)

  This operation constructs an arc about a center point specified as a
  vector `[m, a]` originating from the current position. The arc begins
  at the angle defined by the vector `[c, i]` and ends at the angle
  defined by either the vector `[c, v]` or by the scalar angle \p v (in
  degrees). The sweep direction is controlled by \p cw; when \p cw is
  set to \p true, the arc is swept clockwise from the start angle to
  the stop angle. The optional parameter \p fn specifies the number of
  facets and, when omitted, is determined automatically by get_fn().

  \amu_define title           (Motor mount plate design example)
  \amu_define image_views     (top diag)
  \amu_define image_size      (sxga)
  \amu_define scope_id        (turtle_path_2d_p)
  \amu_define output_scad     (true)

  \amu_include (include/amu/scope_diagrams_3d.amu)

  The corners of this example 2d design plate have been rounded with
  the library function polygon_round_eve_all_p().

  [facets]: \ref get_fn()
  [Turtle graphics]: https://en.wikipedia.org/wiki/Turtle_(robot)
*******************************************************************************/
function turtle_path_2d_p
(
  s,
  i = origin2d,
  c = 0
) = ! is_list( s ) ? empty_lst
  : let
    ( // get current step
      stp = first( s ),

      // get operation and argument vector
      opr = first( stp ),
      arv = second( stp ),
      arc = is_undef( arv ) ? 0 : is_list( arv ) ? len( arv ) : 1,

      // assign arguments
      a1  = defined_e_or( arv, 0, arv ),
      a2  = defined_e_or( arv, 1, undef ),
      a3  = defined_e_or( arv, 2, undef ),
      a4  = defined_e_or( arv, 3, undef ),

      // compute coordinate point(s) for current operation
      p = (opr == "mxy" || opr == "move_xy"  ) && (arc == 2) ? [a1, a2]

        : (opr == "mx"  || opr == "move_x"   ) && (arc == 1) ? [a1, i.y]
        : (opr == "my"  || opr == "move_y"   ) && (arc == 1) ? [i.x, a1]

        : (opr == "dxy" || opr == "delta_xy" ) && (arc == 2) ? i + [a1, a2]

        : (opr == "dx"  || opr == "delta_x"  ) && (arc == 1) ? i + [a1, 0]
        : (opr == "dy"  || opr == "delta_y"  ) && (arc == 1) ? i + [0, a1]

        : (opr == "dxa" || opr == "delta_xa" ) && (arc == 2) ? i + [a1, a1 * tan(a2)]
        : (opr == "dya" || opr == "delta_ya" ) && (arc == 2) ? i + [a1 / tan(a2), a1]

        : (opr == "dv"  || opr == "delta_v"  ) && (arc == 2) ? line_tp( line2d_new(m=a1, a=a2, p1=i) )

        : (opr == "apv" || opr == "arc_pv"   ) && ((arc == 3) || (arc == 4)) ?
          let
          ( // handle scalar angle or compute angle from vector
            v2  = is_list(a2) ? [a1, a2] : a2
          )
          polygon_arc_p( r=distance_pp(i, a1), c=a1, v1=[a1, i], v2=v2, cw=a3, fn=a4 )

        : (opr == "avv" || opr == "arc_vv"   ) && ((arc == 3) || (arc == 4)) ?
          let
          ( // calculate center point 'b1' from given vector [m, a] in 'a1'
            b1 = line_tp( line2d_new(m=first(a1), a=second(a1), p1=i) ),
            v2 = is_list(a2) ? [b1, a2] : a2
          )
          polygon_arc_p( r=distance_pp(i, b1), c=b1, v1=[b1, i], v2=v2, cw=a3, fn=a4 )

        : assert
          ( false,
            str ( "ERROR at '", stp, "', num='", c, "', operation='", opr
                  , "', argc='", arc, "', argv='", arv,"'" )
          ),

      ls  = len( s ),               // current step count
      lp  = len( p ),               // points count in current step
      cp  = (lp > 2) ? p : [p],     // point-list for current step
      ni  = (lp > 2) ? last(p) : p  // initial point for next step
    )
    // check if have reached last step (ls == 1)?
    //  yes : terminate recursion
    //   no : pop current step and process remaining
    ( ls == 1 ) ? cp : concat( cp, turtle_path_2d_p( tailn(s), ni, c+1 ) );

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE turtle_path_2d_p;
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
      ["delta_xy", [w3, h3]],
      ["delta_x",  w1+w2-w3*2],
      ["delta_xy", [w3, -h3]],
      ["move_y",   0],
      ["move_x",   0],
    ];

    // convert the step moves into coordinates
    pp = turtle_path_2d_p( sm );

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
