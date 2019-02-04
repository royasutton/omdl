//! Drafting defaults and configurations.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2019

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

    \amu_define group_name  (Config)
    \amu_define group_brief (Drafting defaults and configurations.)

  \amu_include (include/amu/pgid_path_pstem_g.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

$draft_line_fn = 4;
$draft_arrow_fn = 8;

draft_make_3d = false;
draft_sheet_size = "A";
draft_sheet_config = "L84TS";
draft_layers_show = ["all"];

draft_scaler = 1;

//! .
/***************************************************************************//**
*******************************************************************************/
function draft_get_default
(
  k
) = map_get_value(draft_defaults_map, k);

draft_defaults_s1_map =
[
  //
  // fonts
  //

  ["font-szr",                  "Liberation Sans"],       // sheet zone reference

  ["font-tbh",                  "Liberation Sans"],       // title block headings
  ["font-tbe",                  "Liberation Sans"],       // title block entries

  ["font-tt",                   "Liberation Sans"],       // table titles
  ["font-th",                   "Liberation Sans"],       // table headings
  ["font-te",                   "Liberation Sans"],       // table entries

  //
  // make 3d
  //

  ["make-3d-height",            length(1, "mm")],         // make 3d extrude height

  //
  // lines
  //

  ["line-width-min",            length(0.2, "mm")],       // lines
  ["line-segment-min",          length(1.25, "mm")],      // dashed-lines
  ["line-use-hull",             true],                    // draft_line_pp() uses hull()

  //
  // arrows
  //

  ["arrow-line-length-min",     length(4.0, "mm")],       // arrowhead
  ["arrow-angle-min",           angle(15, "d")],

  //
  // table
  //

  ["table-cmh",                 length(1/4,"in")],        // horizontal width minimum
  ["table-cmv",                 length(1/4,"in")],        // vertical height minimum
  ["table-coh",                 +1],                      // horizontal line ordering
  ["table-cov",                 -1],                      // vertical line ordering
  ["table-hlines",              consts(5,[0,0])],         // horizontal lines
  ["table-vlines",              consts(3,[0,0])],         // vertical line
  ["table-txt-fmt",             [empty_str, [-1,-1],      // text format
                                [2/5,-9/10], [0,-1-1/5],
                                0, 1, ["left", "center"]]],

  //
  // note
  //

  ["note-cmh",                  length(1/4,"in")],        // horizontal width minimum
  ["note-cmv",                  length(1/4,"in")],        // vertical height minimum

  //
  // dim
  //

  // leader
  ["dim-leader-cmh",            length(1/4,"in")],        // horizontal width minimum
  ["dim-leader-cmv",            length(1/4,"in")],        // vertical height minimum
  ["dim-leader-weight",         1],
  ["dim-leader-style",          1],
  ["dim-leader-arrow",          [2,1]],
  ["dim-leader-box-weight",     1],
  ["dim-leader-box-style",      1],

  // line
  ["dim-line-cmh",              length(1/8,"in")],        // horizontal width minimum
  ["dim-line-cmv",              length(1/8,"in")],        // vertical height minimum
  ["dim-line-weight",           1],
  ["dim-line-style",            1],
  ["dim-line-extension-style",  1],
  ["dim-line-arrow",            2],
  ["dim-line-text-place",       [0,1]],
  ["dim-line-text-size",        undef],
  ["dim-line-rnd-mode",         [1,2]],                   // [mode, figures]
  ["dim-line-distance",         length(3/8,"in")],
  ["dim-line-offset",           length(1/32,"in")],
  ["dim-line-extension-length", length(2/8,"in")],

  // radius
  ["dim-radius-cmh",            length(1/8,"in")],        // horizontal width minimum
  ["dim-radius-cmv",            length(1/8,"in")],        // vertical height minimum
  ["dim-radius-weight",         1],
  ["dim-radius-style",          1],
  ["dim-radius-arrow",          2],
  ["dim-radius-text-place",     [0,1]],
  ["dim-radius-text-size",      undef],
  ["dim-radius-rnd-mode",       [1,2]],                   // [mode, figures]
  ["dim-radius-offset",         0],

  //
  // layers
  //

  ["layers-default",            ["all", "default"]],      // default layers
  ["layers-sheet",              ["all", "sheet"]],
  ["layers-table",              ["all", "table"]],
  ["layers-note",               ["all", "note"]],
  ["layers-titleblock",         ["all", "titleblock"]],
  ["layers-dim",                ["all", "dim"]]
];

draft_defaults_map = draft_defaults_s1_map;

//! .
/***************************************************************************//**
*******************************************************************************/
function draft_sheet_get_value
(
  ci
) = table_get_value
    (
      r=draft_sheet_sizes_tr,
      c=draft_sheet_sizes_tc,
      ri=draft_sheet_size,
      ci=ci
    );

draft_sheet_sizes_tc =
[
  ["id", "sheet size"], ["sdx", "sheet x-dimension"], ["sdy", "sheet y-dimension"]
];

draft_sheet_sizes_tr =
[
  ["A", length(8.5, "in"), length(11, "in")],
  ["B", length( 11, "in"), length(17, "in")],
  ["C", length( 17, "in"), length(22, "in")],
  ["D", length( 22, "in"), length(34, "in")],
  ["E", length( 34, "in"), length(44, "in")],

  ["A4", length(210, "mm"), length( 297, "mm")],
  ["A3", length(297, "mm"), length( 420, "mm")],
  ["A2", length(420, "mm"), length( 594, "mm")],
  ["A1", length(594, "mm"), length( 841, "mm")],
  ["A0", length(841, "mm"), length(1189, "mm")],
  ["B1", length(707, "mm"), length(1000, "mm")],
];

//! .
/***************************************************************************//**
*******************************************************************************/
function draft_config_get_value
(
  ci
) = table_get_value
    (
      r=draft_sheet_config_tr,
      c=draft_sheet_config_tc,
      ri=draft_sheet_config,
      ci=ci
    );

draft_sheet_config_tc =
[
  ["id",  "configuration name"],

  ["sll", "sheet landscape layout"],
  ["smx", "sheet margin x"],
  ["smy", "sheet margin y"],
  ["szm", "zone margin xy"],

  ["zox", "zone ordering x"],
  ["zoy", "zone ordering y"],
  ["zlx", "zone labels x"],
  ["zly", "zone labels y"],
  ["zrf", "zone reference font"],
  ["zfs", "zone font scaling"],

  // lines: [ weight, {style | [style]} ]
  ["slc", "sheet line config"],
  ["flc", "frame line config"],
  ["zlc", "zone line config"],
  ["glc", "grid line config"],
  ["olc", "origin line and arrow config"]
];

draft_sheet_config_tr =
[
  [
    "L84TS",

    true,
    length(3/4, "in"),
    length(1/2, "in"),
    length(3/16, "in"),

    -1,
    +1,
    ["A", "B", "C", "D", "E", "F", "G", "H" ],
    ["1", "2", "3", "4" ],
    draft_get_default("font-szr"),
    5/8,

    [1,[4,3,2,5]],
    8,
    4,
    [1/2,3],
    [3,1,13/8, [1,1,0,1,3]]
  ],

  [
    "P48TS",

    false,
    length(1/2, "in"),
    length(3/4, "in"),
    length(3/16, "in"),

    -1,
    +1,
    ["A", "B", "C", "D" ],
    ["1", "2", "3", "4", "5", "6", "7", "8" ],
    draft_get_default("font-szr"),
    5/8,

    [1,[4,3,2,5]],
    8,
    4,
    [1/2,3],
    [3,1,13/8, [1,1,0,1,3]]
  ]
];

//! .
/***************************************************************************//**
*******************************************************************************/
draft_title_block_map =
[
  // table cell horizontal width minimum
  [ "cmh",    length(3/8, "in") ],

  // table cell vertical height minimum
  [ "cmv",    length(3/8, "in") ],

  // table cell horizontal line ordering
  [ "coh",    -1 ],

  // table cell vertical line ordering
  [ "cov",    +1 ],

  // table horizontal lines
  // height-factor, [vl-start, vl-end], line-weight, line-style
  [ "hlines",
      [
        [0,   [0, 11], 3, 1],
        [3/2, [0, 11], 3, 1],
        [1,   [1,  8], 1, 1],
        [1/2, [0,  1], 1, 1],
        [1/2, [1, 11], 1, 1],
        [1/2, [0,  1], 1, 1],
        [1/2, [1,  6], 1, 1],
        [1,   [0, 11], 3, 1]
      ]
  ],

  // table vertical lines
  // width-factor, [hl-start, hl-end], line-weight, line-style
  [ "vlines",
      [
        [0,   [0,  7], 3, 1],
        [4,   [1,  7], 1, 1],
        [1,   [0,  1], 1, 1],
        [1,   [0,  1], 1, 1],
        [1,   [1,  4], 1, 1],
        [3,   [1,  4], 1, 1],
        [3/4, [4,  7], 1, 1],
        [2,   [1,  4], 1, 1],
        [1,   [1,  4], 1, 1],
        [1,   [1,  4], 1, 1],
        [1/2, [0,  1], 1, 1],
        [2,   [0,  7], 3, 1]
      ]
  ],

  /*
    text configuration format:

    [
      0:"text", 1:<align-point>, 2:<align-offset>, 3:<mline-offset>,
      4:rotate, 5:text-scale, 6:<text-align>, 7:"font",
      8:spacing, 9:direction, 10:language, 11:script
    ]

      <align-point>   = [hl-align, vl-align]
      <align-offset>  = [h-offset, v-offset]
      <mline-offset>  = [h-offset, v-offset]  // multi-line
      <text-align>    = [halign, valign]
  */

  // zone heading text configuration defaults
  [ "hdefs",
      [
        empty_str, [ 0, +1], [ 0, -1], [0, -1-4/10],  0,   1,
        ["center", "center"], draft_get_default("font-tbh")
      ]
  ],

  // zone entry text configuration defaults
  [ "edefs",
      [
        empty_str, [ 0, +1], [ 0, -2-1/2], [0, -1-4/10],  0, 3/2,
        ["center", "center"], draft_get_default("font-tbe")
      ]
  ],

  /*
    title block configuration format:

    [ <vl-limits>, <hl-limits>, hidden, <heading-text>, <entry-text> ]

      <vl-limits> = [vl-start, vl-end]
      <hl-limits> = [hl-start, hl-end]
   */
  [ "zones",
      [
        [ [ 3, 10], [ 0,  1], 0, ["TITLE1"] ],
        [ [ 5,  7], [ 1,  2], 0, ["DATE"] ],
        [ [ 5,  7], [ 2,  4], 0, ["DRAWN BY"] ],
        [ [ 0,  2], [ 0,  1], 0, ["DRAWING NUMBER"] ],
        [ [ 0,  1], [ 1,  3], 0, ["SHEET"] ],
        [ [ 9, 11], [ 1,  4], 0, ["PROJECTION"] ],
        [ [ 0,  1], [ 5,  7], 0, ["MATERIAL"] ],
        [ [ 0,  1], [ 3,  5], 0, ["TREATMENT"] ],
        [ [ 4,  5], [ 2,  4], 0, ["CHECKED BY"] ],
        [ [ 1,  4], [ 2,  4], 0, ["APPROVED BY"] ],
        [ [ 1,  6], [ 6,  7], 0, ["NOTE1"] ],
        [ [ 1,  6], [ 4,  6], 0, ["NOTE2"] ],
        [ [ 6, 11], [ 4,  7], 0, ["NOTE3"] ],
        [ [ 8,  9], [ 1,  4], 0, ["SCALE"],   [str("1:", draft_scaler), [0,0], [0,0]] ],
        [ [ 7,  8], [ 2,  4], 0, ["UNITS"],   [length_unit_base] ],
        [ [ 7,  8], [ 1,  2], 0, ["SIZE"],    [draft_sheet_size] ],
        [ [10, 11], [ 0,  1], 0, ["LOGO"],    ["omdl"] ]
      ]
  ]
];

//! .
/***************************************************************************//**
*******************************************************************************/
draft_table_format_common_map =
[
  [ "cmh",  length(1/4, "in") ],
  [ "cmv",  length(1/4, "in") ],
  [ "coh",  +1 ],
  [ "cov",  -1 ],

  [ "hlines",
      [
        [2,   1],    // top
        [2,   1],    // bottom
        [2,   1],    // title
        [1,   1],    // headings
        [1/2, 1]     // rows
      ]
  ],
  [ "vlines",
      [
        [2,   1],     // left
        [2,   1],     // right
        [1/2, 1]      // cols...
      ]
  ],

  [ "tdefs",
      [
        empty_str, [ 0, -1], [ 0, -1/2-4/10], [0, -1-2/10], 0, 1,
        ["center", "center"], draft_get_default("font-tt")
      ]
  ]
];

draft_table_format_ccc_map =
concat
(
  draft_table_format_common_map,
  [
    [ "hdefs",
        [
          empty_str, [ 0, -1], [ 0, -1/2-3/10], [0, -1-2/10], 0, 1,
          ["center", "center"], draft_get_default("font-th")
        ]
    ],
    [ "edefs",
        [
          empty_str, [ 0, -1], [ 0, -1/2-4/10], [0, -1-2/10], 0, 1,
          ["center", "center"], draft_get_default("font-te")
        ]
    ]
  ]
);

draft_table_format_cll_map =
concat
(
  draft_table_format_common_map,
  [
    [ "hdefs",
        [
          empty_str, [-1, -1], [2/5,  -4/5], [0, -1-1/5], 0, 1,
          ["left", "center"], draft_get_default("font-th")
        ]
    ],
    [ "edefs",
        [
          empty_str, [-1, -1], [2/5, -9/10], [0, -1-1/5], 0, 1,
          ["left", "center"], draft_get_default("font-te")
        ]
    ]
  ]
);

draft_table_format_crr_map =
concat
(
  draft_table_format_common_map,
  [
    [ "hdefs",
        [
          empty_str, [+1, -1], [-2/5,  -4/5], [0, -1-1/5], 0, 1,
          ["right", "center"], draft_get_default("font-th")
        ]
    ],
    [ "edefs",
        [
          empty_str, [+1, -1], [-2/5, -9/10], [0, -1-1/5], 0, 1,
          ["right", "center"], draft_get_default("font-te")
        ]
    ]
  ]
);

//! @}
//! @}

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
