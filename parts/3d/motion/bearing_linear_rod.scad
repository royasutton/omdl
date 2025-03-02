//! Linear rod ball and sled bearing.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2023-2024

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

    \amu_define group_name  (Linear rod bearing)
    \amu_define group_brief (Linear rod ball and sled bearing.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group and macros.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_define includes_required_add
  (
    tools/operation_cs.scad
  )
  \amu_include (include/amu/includes_required.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//! Transform 2d or 3d shape into a linear rod ball or sled bearing.
/***************************************************************************//**
  \param    pipe <decimal-list-2> pipe or rod diameter [outer, inner].

  \param    ball <decimal> ball bearing diameter.

  \param    count <integer> ball bearing tunnel count.

  \param    angle <decimal> ball bearing tunnel angle.

  \param    h <data-list-3> bearing block height.

  \param    tunnel <decimal-list-2> ball bearing tunnel size.

  \param    feed <decimal-list-4> ball bearing feed specification.

  \param    load <integer> ball bearing feed load position
            (0=none, 1=inner, 2=outer, 3=top, 4=bottom).

  \param    offset <integer> pipe-to-bearing alignment offset mode
            (0=ball-tunnel, 1=ball, 2=ball-tunnel + 50% of gap).

  \param    delta <decimal> pipe-to-bearing alignment absolute adjustment.

  \param    gap <decimal> ball bearing gap percentage.

  \param    reveal <decimal> ball bearing reveal percentage.

  \param    dilate <decimal> ball bearing circulation tunnel-return
            enlargement percentage.

  \param    type <integer> bearing type (0=ball, 1=slide).

  \param    align <integer> bearing block zero alignment location.
            (0=+block_h/2, 1=+tunnel_h/2, 2=center, 3=-tunnel_h/2, 4=-block_h/2)

  \param    verb <integer> verbosity (0=quiet).

  \param    view <integer-list-3> bearing block internal view
            (0=block, 1=pipe-tunnel, 2=ball-tunnel). Use, for example,
            [1, 2] to view multiple.
  \details

    This module transforms a child object into a linear bearing. By
    default, a 2d profile is extruded into a linear bearing, but the
    parameter \p h can be configured to operated on a 3d child object.

    The parameters \p pipe, \p ball, \p count, \p angle, and \p h are
    required but the remaining are optional. Default values are used
    for all unspecified parameters. Default values are also used for
    unspecified elements positions for parameter that accepts a list of
    values. For example, the following table are all valid
    specifications for \p h:

     parameter h            | value description
    :-----------------------|:--------------------------------------------------------
     10.5                   | bearing block height, defaults for remaining
     [10.5]                 | same as above
     [10.5, 5]              | block height and end cap thickness
     [10.5, undef, false]   | block height and extrusion options only
     [10.5, 5, false]       | block height, end cap thickness and extrusion

    A single scalar value can be used to specify the first value of a
    multi-value parameter as shown in the above table.

    Multi-value parameters
    ----------------------

    \b h

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | decimal           | required          | total bearing height
      1 | decimal           | ball/4            | bearing end-cap height
      2 | boolean           | \b true           | extrude child object

    \b tunnel

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | decimal           | ball/4            | perpendicular tunnel dimension
      1 | decimal           | ball              | tunnel corner turn radius

    \b feed

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | decimal           | 1                 | ball bearing feeder size factor
      1 | decimal           | 0                 | tunnel position factor [0:1]
      2 | decimal           | 0                 | rotation angle
      3 | decimal           | tunnel-diameter   | ball bearing feeder length

    When the first value position of \p feed is assigned 0, the feed
    option is disabled. The bearing feed can also be disabled by
    assigning \p load = 0.

    \amu_define title         (Bearing example)
    \amu_define image_views   (top right diag)
    \amu_define image_size    (sxga)

    \amu_define notes_diagrams
    ( This example uses the \p view options to see the bearing internals.
      Click image above to expand. )

    \amu_include (include/amu/scope_diagrams_3d.amu)
*******************************************************************************/
module make_bearing_linear_rod
(
  pipe,
  ball,
  count,
  angle,
  h,
  tunnel,
  feed,
  load = 1,
  offset = 1,
  delta = 0,
  gap = 10,
  reveal = 50,
  dilate = 15,
  type = 0,
  align = 2,
  verb = 0,
  view
)
{
  // diameters
  pipe_od               = defined_e_or(pipe, 0, pipe);
  pipe_id               = defined_e_or(pipe, 1, 0);

  ball_d                = ball;

  // ball tunnel: count, folding-angle
  ball_tunnel_c         = count;
  ball_tunnel_a         = angle;

  // bearing block: height, end-cap height, and extrusion
  bearing_block_h       = defined_e_or(h, 0, h);
  bearing_end_cap_h     = defined_e_or(h, 1, ball_d/4);
  extrude_profile       = defined_e_or(h, 2, true);

  // ball tunnel: width, end-radius
  ball_tunnel_w         = defined_e_or(tunnel, 0, ball_d / 4);
  ball_tunnel_r         = defined_e_or(tunnel, 1, ball_d * 1);

  // ball tunnel diameter (gap adjustment: add for ball, subtract for slide)
  ball_tunnel_d         = ball_d + (ball_d * gap/100) * ((type == 0) ? +1 : -1);

  // ball tunnel: length, height
  ball_tunnel_l         = bearing_block_h - (ball_tunnel_r*2 + ball_tunnel_d + bearing_end_cap_h*2);
  ball_tunnel_h         = bearing_block_h - bearing_end_cap_h*2;

  // ball bearing feed: ratio, position[0:1], angle, length
  bearing_feed_r        = is_defined(feed) ? defined_e_or(feed, 0, feed) : 1;
  bearing_feed_p        = defined_e_or(feed, 1, 0);
  bearing_feed_a        = defined_e_or(feed, 2, 0);
  bearing_feed_l        = defined_e_or(feed, 3, ball_tunnel_d);

  // ball bearing feed alignment: translate, rotate, translate
  // 0: at pipe
  // 1: outer return
  // 2: top
  // 3: bottom
  ball_feed_alignment =
  [
    [ [-(ball_tunnel_r + ball_tunnel_w/2), -(bearing_feed_p * ball_tunnel_l - ball_tunnel_l/2), 0],
      [0, 90 - ball_tunnel_a + bearing_feed_a, 0],
      [0, 0, -(bearing_feed_l/2 + ball_tunnel_d/4)] ],
    [ [+(ball_tunnel_r + ball_tunnel_w/2), +(bearing_feed_p * ball_tunnel_l - ball_tunnel_l/2), 0],
      [0, 90 - ball_tunnel_a + bearing_feed_a, 0],
      [0, 0, +(bearing_feed_l/2 + ball_tunnel_d/4)] ],
    [ [+(bearing_feed_p * ball_tunnel_w - ball_tunnel_w/2), +(ball_tunnel_h/2 - ball_tunnel_d/2), 0],
      [90 + bearing_feed_a, 0, 0],
      [0, 0, -(bearing_feed_l/2 + ball_tunnel_d/4)] ],
    [ [-(bearing_feed_p * ball_tunnel_w - ball_tunnel_w/2), -(ball_tunnel_h/2 - ball_tunnel_d/2), 0],
      [90 + bearing_feed_a, 0, 0],
      [0, 0, +(bearing_feed_l/2 + ball_tunnel_d/4)] ]
  ];

  // pipe to ball offset (alignment & pipe tunnel diameter)
  // 0: pipe to ball-tunnel
  // 1: pipe to ball
  // 2: pipe to ball minus 50% of gap (pipe to ball-tunnel + 50% of gap)

  // ball to pipe alignment: ball tunnel radial translate
  ball_pipe_alignment = pipe_od/2 + delta +
  [
    ball_tunnel_d/2,
    ball_d/2,
    ball_d/2 - (ball_d * gap/100)/2
  ][offset];

  // pipe tunnel diameter to expose ball bearing reveal
  pipe_tunnel_d = pipe_od +
  [
    ball_d/2 * (reveal/100),
    ball_d/2 * (reveal/100) - ball_d * gap/(100*2),
    ball_d/2 * (reveal/100) - ball_d * gap/(100*4)
  ][offset];

  // ball tunnel alignment
  module align_ball_tunnel()
  {
    repeat_radial(n=ball_tunnel_c, r=pipe_od/2)
    translate([ball_pipe_alignment, 0, 0])
    rotate([0, 0, ball_tunnel_a])
    translate([ball_tunnel_w/2 + ball_tunnel_r, 0, 0])
    rotate([90, 0, 0])
    children();
  }

  // build ball bearing tunnel
  module build_tunnel_path(r, l, s=1, m=255)
  {
    lx = l[0];
    ly = l[1];

    // return path scale factor
    sr = 1 + s/100;

    // corner rotation
    for
    (
      i = [
             [+lx/2, +ly/2,   0, 1, [sr, sr]],
             [-lx/2, +ly/2,  90, 3, [sr,  1]],
             [-lx/2, -ly/2, 180, 5, [ 1, sr]],
             [+lx/2, -ly/2, 270, 7, [sr, sr]]
          ]
    )
    if ( binary_bit_is(m, i[3], 1) )
    {
      translate([i[0], i[1], 0])
      rotate([0, 0, i[2]])
      extrude_rotate_trs(r=r, ra=90, s=i[4])
      children();
    }

    // linear extrusion
    for
    (
      i = [
            [ +r +lx/2,    +ly/2,   0, ly, 0, sr],
            [    -lx/2, +r +ly/2,  90, lx, 2, sr],
            [ -r -lx/2,    -ly/2, 180, ly, 4,  1],
            [     lx/2, -r -ly/2, 270, lx, 6, sr]
          ]
    )
    if ( binary_bit_is(m, i[4], 1) )
    {
      translate([i[0], i[1], 0])
      rotate([90, 0, i[2]])
      translate([0, 0, -eps])
      linear_extrude(height=i[3] + eps*2)
      scale(i[5])
      rotate([0, 0, 0])
      children();
    }
  }

  // bearing block zero alignment
  translate
  ( select_ci
    ( [ [0, 0, +bearing_block_h/2],
        [0, 0, +ball_tunnel_h/2],
        [0, 0, 0],
        [0, 0, -ball_tunnel_h/2],
        [0, 0, -bearing_block_h/2]
      ], align, false
    )
  )
  union_cs()
  {
    // construct bearing
    difference_cs( c=true, s=view )
    {
      // bearing block
      extrude_linear_mss(bearing_block_h, center=true, c=extrude_profile)
      children();

      // pipe tunnel
      extrude_linear_mss(bearing_block_h + eps*2, center=true)
      circle(d=pipe_tunnel_d);

      // ball tunnels
      if ( type == 0 )
      align_ball_tunnel()
      union_cs()
      { // tunnel
        build_tunnel_path(r=ball_tunnel_r, l=[ball_tunnel_w, ball_tunnel_l], s=dilate)
        circle(d=ball_tunnel_d);

        // feed
        if ( is_between(load, 1, len(ball_feed_alignment)) )
        translate( ball_feed_alignment[load-1][0] )
        rotate( ball_feed_alignment[load-1][1] )
        translate( ball_feed_alignment[load-1][2] )
        extrude_linear_mss(bearing_feed_l + ball_tunnel_d/2, center=true)
        circle(d=bearing_feed_r * ball_d);

        // report ball bearing count
        if ( verb > 0 )
        {
          ball_path = 2 * pi * ball_tunnel_r + (ball_tunnel_w+ball_tunnel_l)*2;
          echo(ball_path=ball_path, ball_count=ball_path/ball_d);
        }
      }
    }

    // add solid slide bearing
    if ( type == 1 )
    align_ball_tunnel()
    build_tunnel_path(r=ball_tunnel_r, l=[ball_tunnel_w, ball_tunnel_l], m=(8+16+32))
    circle(d=ball_tunnel_d + eps);

    // internal view assist
    if ( is_defined(view) )
    {
      // bearing block
      %extrude_linear_mss(bearing_block_h, center=true, c=extrude_profile)
      children();

      // pipe
      %color("black")
      extrude_linear_mss(bearing_block_h + eps*2, center=true)
      difference_cs(pipe_id>0){circle(d=pipe_od); circle(d=pipe_id);}
    }
  }
}

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE example;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <tools/operation_cs.scad>;
    include <parts/3d/motion/bearing_linear_rod.scad>;

    emt  = [length(0.706, "in"), length(0.622, "in")];
    ball = length(6, "mm");

    r = 21.5; h = ball*8; c = 6; a = 85;

    make_bearing_linear_rod
    (
       pipe = emt,
       ball = ball,
      count = c,
      angle = a,
          h = [h, undef, false],
       view = 2,
        $fn = 36
    )
    minkowski()
    {
      linear_extrude(h-ball, center=true)
      rotate(a) ngon(n=c, r=r);
      sphere(r=ball/2);
    }

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "top right diag";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
