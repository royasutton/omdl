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

//! <boolean> Extrude 2D drafted constructions to 3D.
$draft_make_3d = false;

//! <integer> Arc fragment size for line construction.
$draft_line_fn = 4;

//! <integer> Arc fragment size for arrowhead construction.
$draft_arrow_fn = 8;

//! <integer> Line construction drafting scale multiplier.
$draft_scale = 1;

//! <integer> Sheet construction drafting scale multiplier.
draft_sheet_scale = 1;

//! <string> Drafting sheet size identifier.
/***************************************************************************//**
  \amu_scope scope_in (index=2)
  \amu_file th_in (file="${scope_in}.log" first=1 last=1 ++rmecho ++rmnl ++read)
  \amu_file td_in (file="${scope_in}.log" first=2 last=6 ++rmecho ++rmnl ++read)

  \amu_scope scope_mm (index=3)
  \amu_file th_mm  (file="${scope_mm}.log" first=1  last=1 ++rmecho ++rmnl ++read)
  \amu_file td_mma (file="${scope_mm}.log" first=7  last=12 ++rmecho ++rmnl ++read)
  \amu_file td_mmb (file="${scope_mm}.log" first=13 last=0 ++rmecho ++rmnl ++read)

  \details

    \b ANSI sheet sizes (inches):
    \amu_table (columns=3 column_headings=${th_in} cell_texts=${td_in})

    \b ISO-A sheet sizes (millimeters):
    \amu_table (columns=3 column_headings=${th_mm} cell_texts=${td_mma})

    \b ISO-B sheet sizes (millimeters):
    \amu_table (columns=3 column_headings=${th_mm} cell_texts=${td_mmb})
*******************************************************************************/
draft_sheet_size = "A";

//! <string> Drafting sheet configuration identifier.
/***************************************************************************//**
  \details

    Available configurations:

      name        | description
    :-------------|:--------------------------------------------------------
      \b L84TS    | Small sheet landscape layout with 8x4 traditional zones
      \b P48TS    | Small sheet Portrait layout with 4x8 traditional zones
*******************************************************************************/
draft_sheet_config = "L84TS";

//! <string-list> List of active drafting layer names.
/***************************************************************************//**
  \details

    Layer identifiers may be assigned arbitrary names. A set of default
    names are used when not explicitly assigned. Multiple layers can be
    set active as in the following example.

    \b Example:

    \code{.C}
    draft_layers_show = ["default", "sheet", "dim"];
    \endcode
*******************************************************************************/
draft_layers_show = ["all"];

//! Get drafting configuration default helper function.
/***************************************************************************//**
  \param    k <string> A map key.

  \returns  \<value> The default value from the configuration map if it
            exists.

  \sa draft_defaults_map.
*******************************************************************************/
function draft_get_default
(
  k
) = map_get_value(draft_defaults_map, k);

//! <matrix-2xN> A drafting configuration defaults map (style1).
/***************************************************************************//**
  \amu_scope scope (index=1)
  \amu_file mh (file="${scope}.log" first=1 last=1 ++rmecho ++rmnl ++read)
  \amu_file md (file="${scope}.log" first=2 last=0 ++rmecho ++rmnl ++read)

  \details

    Configuration values for drafting primitives and tools. Specific
    values can be overridden as shown in \ref draft_defaults_map or
    completely new maps may assembled to implement new styles as
    desired.

    All lengths are in millimeters:
    \amu_table (columns=2 column_headings=${mh} cell_texts=${md})

  \hideinitializer
*******************************************************************************/
draft_defaults_style1_map =
[
  //
  // fonts
  //

  ["font-sheet-zone-reference",         "Liberation Sans"],

  ["font-title-block-heading",          "Liberation Sans"],
  ["font-title-block-entry",            "Liberation Sans"],

  ["font-table-title",                  "Liberation Sans"],
  ["font-table-heading",                "Liberation Sans"],
  ["font-table-entry",                  "Liberation Sans"],

  //
  // make 3d
  //

  ["make-3d-height",                    length(1, "mm")],

  //
  // lines
  //

  ["line-width-min",                    length(0.2, "mm")],
  ["line-segment-min",                  length(1.25, "mm")],
  ["line-use-hull",                     true],

  //
  // arrows
  //

  ["arrow-line-length-min",             length(4.0, "mm")],
  ["arrow-angle-min",                   angle(15, "d")],

  //
  // table
  //

  ["table-cmh",                         length(1/4,"in")],        // horizontal width minimum
  ["table-cmv",                         length(1/4,"in")],        // vertical height minimum
  ["table-coh",                         +1],                      // horizontal line ordering
  ["table-cov",                         -1],                      // vertical line ordering
  ["table-hlines",                      consts(5,[0,0])],         // horizontal lines
  ["table-vlines",                      consts(3,[0,0])],         // vertical line
  ["table-text-format",                 [empty_str, [-1,-1],
                                        [2/5,-9/10], [0,-1-1/5],
                                        0, 1, ["left", "center"]]],

  //
  // note
  //

  ["note-cmh",                          length(1/4,"in")],
  ["note-cmv",                          length(1/4,"in")],

  //
  // dim
  //

  // common
  ["dim-cmh",                           length(1/8,"in")],
  ["dim-cmv",                           length(1/8,"in")],
  ["dim-text-place",                    [0,1]],
  ["dim-text-size",                     undef],
  ["dim-round-mode",                    [1,2]],                   // [mode, digits]
  ["dim-offset",                        length(1/32,"in")],

  // leader
  ["dim-leader-length",                 length(1/2,"in")],
  ["dim-leader-weight",                 1],
  ["dim-leader-style",                  1],
  ["dim-leader-arrow",                  [2,1]],
  ["dim-leader-box-weight",             1],
  ["dim-leader-box-style",              1],

  // line
  ["dim-line-weight",                   1],
  ["dim-line-style",                    1],
  ["dim-line-arrow",                    2],
  ["dim-line-extension-style",          1],
  ["dim-line-extension-length",         length(2/8,"in")],
  ["dim-line-distance",                 length(3/8,"in")],

  // radius
  ["dim-radius-weight",                 1],
  ["dim-radius-style",                  1],
  ["dim-radius-arrow",                  2],

  // angle
  ["dim-angle-weight",                  1],
  ["dim-angle-style",                   1],
  ["dim-angle-arrow",                   2],
  ["dim-angle-extension-style",         3],
  ["dim-angle-extension-ratio",         1],

  // center
  ["dim-center-length",                 length(1/16,"in")],
  ["dim-center-weight",                 1/2],
  ["dim-center-style",                  1],
  ["dim-center-extension-style",        3],

  //
  // layers
  //

  ["layers-default",                    ["all", "default"]],
  ["layers-sheet",                      ["all", "sheet"]],
  ["layers-table",                      ["all", "table"]],
  ["layers-note",                       ["all", "note"]],
  ["layers-titleblock",                 ["all", "titleblock"]],
  ["layers-dim",                        ["all", "dim"]]
];

//! <matrix-2xN> Drafting configuration defaults map.
/***************************************************************************//**
  \details

    The following examples demonstrates how to override select values
    of an existing configuration map.

    \b Example:

    \code{.C}
    draft_defaults_map =
      map_merge
      (
        [ // define overrides first
          ["line-use-hull", false],
          ["dim-offset", length(2/64)],
          ["dim-leader-length", length(3/8)],
          ["dim-line-distance", length(3/8)],
          ["dim-line-extension-length", length(2/8)]
        ],
          // merge with existing style
          draft_defaults_style1_map
      );
    \endcode
*******************************************************************************/
draft_defaults_map = draft_defaults_style1_map;

//! Get sheet size value helper function.
/***************************************************************************//**
  \param    ci <string> The column identifier.

  \returns  \<value> The value of the identified column for the
            configured sheet size set by \ref draft_sheet_size.
*******************************************************************************/
function draft_sheet_get_size
(
  ci
) = table_get_value
    (
      r=draft_sheet_size_tr,
      c=draft_sheet_size_tc,
      ri=draft_sheet_size,
      ci=ci
    );

//! <matrix-2x3> sheet sizes data table columns definition.
/***************************************************************************//**
  \private
  \hideinitializer
*******************************************************************************/
draft_sheet_size_tc =
[
  ["id", "sheet size"], ["sdx", "sheet x-dimension"], ["sdy", "sheet y-dimension"]
];

//! <matrix-3xR> sheet sizes data table rows.
/***************************************************************************//**
  \private
  \hideinitializer
*******************************************************************************/
draft_sheet_size_tr =
[
  // ANSI
  [ "A", length( 8.5, "in"), length(  11, "in")],
  [ "B", length(  11, "in"), length(  17, "in")],
  [ "C", length(  17, "in"), length(  22, "in")],
  [ "D", length(  22, "in"), length(  34, "in")],
  [ "E", length(  34, "in"), length(  44, "in")],

  // ISO A
  ["A5", length( 149, "mm"), length( 210, "mm")],
  ["A4", length( 210, "mm"), length( 297, "mm")],
  ["A3", length( 297, "mm"), length( 420, "mm")],
  ["A2", length( 420, "mm"), length( 594, "mm")],
  ["A1", length( 594, "mm"), length( 841, "mm")],
  ["A0", length( 841, "mm"), length(1189, "mm")],

  // ISO B
  ["B5", length( 177, "mm"), length( 250, "mm")],
  ["B4", length( 250, "mm"), length( 354, "mm")],
  ["B3", length( 354, "mm"), length( 500, "mm")],
  ["B2", length( 500, "mm"), length( 707, "mm")],
  ["B1", length( 707, "mm"), length(1000, "mm")],
  ["B0", length(1000, "mm"), length(1414, "mm")]
];

//! Get sheet configuration value helper function.
/***************************************************************************//**
  \param    ci <string> The column identifier.

  \returns  \<value> The value of the identified column for the
            current sheet configured by \ref draft_sheet_config.
*******************************************************************************/
function draft_sheet_get_config
(
  ci
) = table_get_value
    (
      r=draft_sheet_config_tr,
      c=draft_sheet_config_tc,
      ri=draft_sheet_config,
      ci=ci
    );

//! <matrix-2xC> Sheet configuration data table columns definition.
/***************************************************************************//**
  \private
  \hideinitializer
*******************************************************************************/
draft_sheet_config_tc =
[
  ["id",  "configuration name"],

  // sheet layout
  ["sll", "sheet landscape layout"],
  ["smx", "sheet margin x"],
  ["smy", "sheet margin y"],
  ["szm", "zone margin xy"],

  // zone reference
  ["zox", "zone ordering x"],
  ["zoy", "zone ordering y"],
  ["zlx", "zone labels x"],
  ["zly", "zone labels y"],
  ["zrf", "zone reference font"],
  ["zfs", "zone font scaling"],

  // lines [ weight, {style | [style]} ]
  ["slc", "sheet line config"],
  ["flc", "frame line config"],
  ["zlc", "zone line config"],
  ["glc", "grid line config"],
  ["olc", "origin line and arrow config"]
];

//! <matrix-CxR> Sheet configuration data table rows.
/***************************************************************************//**
  \private
  \hideinitializer
*******************************************************************************/
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
    ["A", "B", "C", "D", "E", "F", "G", "H"],
    ["1", "2", "3", "4"],
    draft_get_default("font-sheet-zone-reference"),
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
    ["A", "B", "C", "D"],
    ["1", "2", "3", "4", "5", "6", "7", "8"],
    draft_get_default("font-sheet-zone-reference"),
    5/8,

    [1,[4,3,2,5]],
    8,
    4,
    [1/2,3],
    [3,1,13/8, [1,1,0,1,3]]
  ]
];

//! <matrix-2xN> The default title block definition map.
/***************************************************************************//**
  \details

    Title blocks are constructed using zoned tables. A new title block
    layout can be constructed by defining a new zoned table map. This
    default map may be used as a starting point example.

  \sa draft_ztable().
  \hideinitializer
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
        ["center", "center"], draft_get_default("font-title-block-heading")
      ]
  ],

  // zone entry text configuration defaults
  [ "edefs",
      [
        empty_str, [ 0, +1], [ 0, -2-1/2], [0, -1-4/10],  0, 3/2,
        ["center", "center"], draft_get_default("font-title-block-entry")
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
        [ [ 8,  9], [ 1,  4], 0, ["SCALE"],   [str("1:", draft_sheet_scale), [0,0], [0,0]] ],
        [ [ 7,  8], [ 2,  4], 0, ["UNITS"],   [length_unit_base] ],
        [ [ 7,  8], [ 1,  2], 0, ["SIZE"],    [draft_sheet_size] ],
        [ [10, 11], [ 0,  1], 0, ["LOGO"],    ["omdl"] ]
      ]
  ]
];

//! <matrix-2xN> Table format map definitions; common.
/***************************************************************************//**
  \private
  \hideinitializer
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
        ["center", "center"], draft_get_default("font-table-title")
      ]
  ]
];

//! <matrix-2xN> Table format map definitions; centered-centered-centered justified.
/***************************************************************************//**
  \hideinitializer
*******************************************************************************/
draft_table_format_ccc_map =
concat
(
  draft_table_format_common_map,
  [
    [ "hdefs",
        [
          empty_str, [ 0, -1], [ 0, -1/2-3/10], [0, -1-2/10], 0, 1,
          ["center", "center"], draft_get_default("font-table-heading")
        ]
    ],
    [ "edefs",
        [
          empty_str, [ 0, -1], [ 0, -1/2-4/10], [0, -1-2/10], 0, 1,
          ["center", "center"], draft_get_default("font-table-entry")
        ]
    ]
  ]
);

//! <matrix-2xN> Table format map definitions; centered-left-left justified.
/***************************************************************************//**
  \hideinitializer
*******************************************************************************/
draft_table_format_cll_map =
concat
(
  draft_table_format_common_map,
  [
    [ "hdefs",
        [
          empty_str, [-1, -1], [2/5,  -4/5], [0, -1-1/5], 0, 1,
          ["left", "center"], draft_get_default("font-table-heading")
        ]
    ],
    [ "edefs",
        [
          empty_str, [-1, -1], [2/5, -9/10], [0, -1-1/5], 0, 1,
          ["left", "center"], draft_get_default("font-table-entry")
        ]
    ]
  ]
);

//! <matrix-2xN> Table format map definitions; centered-right-right justified.
/***************************************************************************//**
  \hideinitializer
*******************************************************************************/
draft_table_format_crr_map =
concat
(
  draft_table_format_common_map,
  [
    [ "hdefs",
        [
          empty_str, [+1, -1], [-2/5,  -4/5], [0, -1-1/5], 0, 1,
          ["right", "center"], draft_get_default("font-table-heading")
        ]
    ],
    [ "edefs",
        [
          empty_str, [+1, -1], [-2/5, -9/10], [0, -1-1/5], 0, 1,
          ["right", "center"], draft_get_default("font-table-entry")
        ]
    ]
  ]
);

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE config;
  BEGIN_SCOPE defaults;
    BEGIN_OPENSCAD;
      include <omdl-base.scad>;
      include <tools/drafting/draft-base.scad>;
      length_unit_base = "mm";

      map_write( draft_defaults_style1_map );
    END_OPENSCAD;

    BEGIN_MFSCRIPT;
      include --path "${INCLUDE_PATH}" {config_base,config_csg}.mfs;
      include --path "${INCLUDE_PATH}" script_std.mfs;
    END_MFSCRIPT;
  END_SCOPE;

  BEGIN_SCOPE sheet;
    BEGIN_SCOPE in;
      BEGIN_OPENSCAD;
        include <omdl-base.scad>;
        include <tools/drafting/draft-base.scad>;
        length_unit_base = "in";

        table_write( draft_sheet_size_tr, draft_sheet_size_tc );
      END_OPENSCAD;

      BEGIN_MFSCRIPT;
        include --path "${INCLUDE_PATH}" {config_base,config_csg}.mfs;
        include --path "${INCLUDE_PATH}" script_std.mfs;
      END_MFSCRIPT;
    END_SCOPE;

    BEGIN_SCOPE mm;
      BEGIN_OPENSCAD;
        include <omdl-base.scad>;
        include <tools/drafting/draft-base.scad>;
        length_unit_base = "mm";

        table_write( draft_sheet_size_tr, draft_sheet_size_tc );
      END_OPENSCAD;

      BEGIN_MFSCRIPT;
        include --path "${INCLUDE_PATH}" {config_base,config_csg}.mfs;
        include --path "${INCLUDE_PATH}" script_std.mfs;
      END_MFSCRIPT;
    END_SCOPE;
  END_SCOPE;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
