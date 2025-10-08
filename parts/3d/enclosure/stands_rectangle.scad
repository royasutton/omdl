//! A stand maker for rectangular prism project boxes, housings, and enclosures.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2025

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

    \amu_define group_name  (Rectangular Stand)
    \amu_define group_brief (Stand maker for rectangular prism enclosures.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group and macros.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_include (include/amu/includes_required.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//! A stand maker for rectangular project boxes, housings, and enclosures.
/***************************************************************************//**
  \param  size    <decimal-list-3 | decimal> dimension(s); a list
                  [w, d, h], the width, depth, and height, or a single
                  decimal for width.

  \param  offset  <decimal> the case seat vertical offset.

  \param  brace   <decimal> the stand brace member percentage of
                  (seat + offset).

  \param  count   <integer> the number of enclosures.

  \param  space   <decimal> the additional separation space between
                  multiple enclosures.

  \param  form    <integer> the stand form {0 : 6}. Form 6 can be used
                  as a top brace for a multi-enclosure stand.

  \param  mode    <integer> the size specification mode
                  {0: size of case, 1: size of stand}.

  \details

    Construct a stand for a rectangular prism enclosure. A
    multi-enclosure stand can be constructed using the \p count
    parameter. The size can refer to the enclosure size or the stand
    size as controlled by the \p mode parameter. The \p form = 6 is
    useful for creating top braces for multi-enclosure stands.

    \amu_define scope_id      (example)
    \amu_define title         (Muilti-enclosure example)
    \amu_define image_views   (right front diag)
    \amu_define image_size    (sxga)

    \amu_include (include/amu/scope_diagrams_3d.amu)
*******************************************************************************/
module stand_rectangle
(
  size,

  offset = 0,
  brace = 1/2,

  count = 1,
  space = 0,

  form = 0,
  mode = 0
)
{
  // decode size
  size_w  = defined_e_or(size, 0, size);
  size_d  = defined_e_or(size, 1, (mode == 0) ? size_w*6 : size_w);
  size_h  = defined_e_or(size, 2, (mode == 0) ? size_w*7 : size_w);

  // size specification mode: 0=case, 1=stand
  width   = (mode == 0) ? size_w   : size_w;
  depth   = (mode == 0) ? size_d/6 : size_d;
  height  = (mode == 0) ? size_h/7 : size_h;

  // stand end section profile size
  standx  = width*3/4;
  standy  = height;

  // curve transition
  curvex  = standy*4/25;
  curvey  = standy/4;

  // seat width and feature thickness
  seatx   = standx/8;
  seaty   = standy/4;

  // stand end upper thickness
  wall    = (standx + standy)/12;

  // polygon form set 0
  pg_fs0 =
    let
    (
      x1 = 0,
      x2 = seatx,
      x3 = seatx + wall,
      x4 = x3 + curvex,
      x5 = seatx + standx,

      x6 = seatx + wall + space,
      x7 = x6 + seatx,

      y1 = 0,
      y2 = seaty + offset,
      y3 = standy + offset,
      y4 = curvey,
      y5 = wall,

      r  = wall
    )
    [
      [ // center section (same for all)
        [[x1, y1], [x1, y2], [x2, y2], [x2, y3], [x6, y3], [x6, y2], [x7, y2], [x7, y1]],
        [r/10, 0, r/5, r/5, 0, r/10, r*2/5, r*2/5],
        [1, 0, 1, 1, 0, 1, 1, 1]
      ],
      [ // end section (original curved)
        [[x1, y1], [x1, y2], [x2, y2], [x2, y3], [x3, y3], [x4, y4], [x5, y5], [x5, y1]],
        [r/10, 0, r/5, r*3/5, r*4/5, r, r/5, r*2/5],
        [1, 0, 1, 1, 1, 1, 1, 1]
      ],
      [ // end section (original beveled)
        [[x1, y1], [x1, y2], [x2, y2], [x2, y3], [x3, y3], [x4, y4], [x5, y5], [x5, y1]],
        [r/10, 0, r/5, r*3/5, r, r, r/5, r*2/5],
        [1, 0, 1, 1, 5, 1, 1, 1]
      ],
      [ // end section (rectangular rounded)
        [[x1, y1], [x1, y2], [x2, y2], [x2, y3], [x3, y3], [x3, y5], [x5, y5], [x5, y1]],
        [r/10, 0, r/5, r*3/5, r, r, r/5, r*2/5],
        [1, 0, 1, 1, 1, 1, 1, 1]
      ],
      [ // end section (rectangular beveled small)
        [[x1, y1], [x1, y2], [x2, y2], [x2, y3], [x3, y3], [x3, y5], [x5, y5], [x5, y1]],
        [r/10, 0, r/5, r*3/5, r, r, r/5, r*2/5],
        [1, 0, 1, 1, 5, 1, 1, 1]
      ],
      [ // end section (rectangular beveled large)
        [[x1, y1], [x1, y2], [x2, y2], [x2, y3], [x3, y3], [x3, y5], [x5, y5], [x5, y1]],
        [r/10, 0, r/5, r*3/5, r*2, r, r/5, r*2/5],
        [1, 0, 1, 1, 5, 1, 1, 1]
      ],
      [ // end section (original, triangular)
        [[x1, y1], [x1, y2], [x2, y2], [x2, y3], [x3, y3], [x5, y5], [x5, y1]],
        [r/10, 0, r/5, r*3/5, r, r/5, r*2/5],
        [1, 0, 1, 1, 1, 1, 1]
      ]
    ];

  // select polygon forms (default = first)
  pg_f =
    select_ci
    ( [
        [ pg_fs0[1], pg_fs0[0] ],
        [ pg_fs0[2], pg_fs0[0] ],
        [ pg_fs0[3], pg_fs0[0] ],
        [ pg_fs0[4], pg_fs0[0] ],
        [ pg_fs0[5], pg_fs0[0] ],
        [ pg_fs0[6], pg_fs0[0] ],
        [ pg_fs0[0], pg_fs0[0] ]
      ], form, false
    );

  pg_fe = first( pg_f );
  pg_fc = second( pg_f );

  // round polygons
  pg_end = polygon_round_eve_all_p( c=first(pg_fe), vr=second(pg_fe), vrm=third(pg_fe) );
  pg_cnt = polygon_round_eve_all_p( c=first(pg_fc), vr=second(pg_fc), vrm=third(pg_fc) );

  //
  // construct stand
  //

  linear_extrude(depth)
  union()
  {
    span = width + wall + space;
    oset = seatx + wall/2 + space/2;

    // center section(s)
    for (x = [0:count-2])
    translate([ span*x - span*(count-2)/2 - oset, 0])
    polygon( pg_cnt );

    // section tie(s)
    for (x=[0:count-1])
    translate([ span*x - span*(count-1)/2, (seaty+offset)/2])
    square([width, (seaty+offset)*brace], center=true);

    // end sections
    for (x = [0, 1])
    mirror([x, 0, 0])
    translate([ span*count/2 - oset, 0])
    polygon( pg_end );
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
    include <parts/3d/enclosure/stands_rectangle.scad>;

    rotate([90, 0, 0])
    {
      e = [35, 125, 125]; w = first(e);
      c = 3; o = 8 + 3/4; s = 2 + 17/32;

      translate([0, 0, -w/2 + w])
      stand_rectangle( size=w, count=c );

      translate([0, 0, -w/2 - w])
      stand_rectangle( size=w, count=c );

      translate([0, third(e)+o*2, -w/2])
      mirror([0, 1, 0])
      stand_rectangle( size=w, count=c, form=6 );

      %for (x = [-1, 0, +1])
      translate([(w+s*2)*x, second(e)/2+o, 0])
      cube(e, center=true);
    }

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "right front diag";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//

