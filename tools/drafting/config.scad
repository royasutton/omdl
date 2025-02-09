//! Drafting defaults and configurations.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2019-2024

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
// global configuration variables
//----------------------------------------------------------------------------//

//! \name Variables
//! @{

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
  \details

    <b>Sheet sizes</b>

    \amu_define output_scad (false)
    \amu_define output_console (false)

    \amu_define title (Available sizes in inches)
    \amu_define scope_id (sheet_sizes_in)
    \amu_include (include/amu/scope_table.amu)

    \amu_define title (Available sizes in mm)
    \amu_define scope_id (sheet_sizes_mm)
    \amu_include (include/amu/scope_table.amu)
*******************************************************************************/
draft_sheet_size = "A";

//! <string> Drafting sheet configuration identifier.
/***************************************************************************//**
  \details

    Available configurations:

    \amu_define title (Sheet configurations)
    \amu_define scope_id (sheet_config)
    \amu_define output_scad (false)
    \amu_define output_console (false)

    \amu_include (include/amu/scope_table.amu)

    \amu_define title (Configuration keys)
    \amu_define scope_id (sheet_config_keys)
    \amu_define output_scad (false)
    \amu_define output_console (false)

    \amu_include (include/amu/scope_table.amu)
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

//! @}

//! \name Getters
//! @{

//----------------------------------------------------------------------------//
// drafting style defaults:
//
//  (1) configuration getter function
//  (2) configuration map "style1"
//  (3) user assignable style map variable
//----------------------------------------------------------------------------//

//! Get drafting configuration default helper function.
/***************************************************************************//**
  \param    k <string> A map key.

  \returns  \<value> The value associated with key \p k in the
            configuration map assigned to \ref draft_config_map.

  \details

    \b Example:

    \verbatim
      layers = draft_get_config("layers-dim");
      dimll1 = draft_get_config("dim-leader-length");
    \endverbatim

  \sa draft_config_map.
*******************************************************************************/
function draft_get_config
(
  k
) = map_get_value(draft_config_map, k);

//! @}

//! \name Maps
//! @{

//! <map> A drafting configuration map; style1.
/***************************************************************************//**
  \details

    Configuration values for drafting primitives and tools. Specific
    values can be overridden as shown in \ref draft_config_map or
    completely new maps may assembled to implement new styles as
    desired.

    \amu_define title (style1)
    \amu_define scope_id (dfraft_style1)
    \amu_define output_scad (false)
    \amu_define output_console (false)
    \amu_define notes_table (All dimensions are in millimeters.)

    \amu_include (include/amu/scope_table.amu)

  \hideinitializer
*******************************************************************************/
draft_config_map_style1 =
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

//! @}

//! \name Variables
//! @{

//! <map> Drafting configuration defaults map.
/***************************************************************************//**
  \details

    The following examples demonstrates how to override select values
    of an existing configuration map.

    \b Example:

    \code{.C}
    draft_config_map =
      map_merge
      (
        [ // define value overrides first
          ["line-use-hull", false],
          ["dim-offset", length(2/64)],
          ["dim-leader-length", length(3/8)],
          ["dim-line-distance", length(3/8)],
          ["dim-line-extension-length", length(2/8)]
        ],
          // start with existing style map
          draft_config_map_style1
      );
    \endcode
*******************************************************************************/
draft_config_map = draft_config_map_style1;

//! @}

//! \name Getters
//! @{

//----------------------------------------------------------------------------//
// sheet size:
//
//  (1) configuration getter function
//  (2) internal table definitions
//----------------------------------------------------------------------------//

//! Get sheet size value helper function.
/***************************************************************************//**
  \param    ci <string> The column identifier.

  \returns  \<value> The value of the identified column for the
            configured sheet size set by \ref draft_sheet_size.

  \details

    \b Example:

    \verbatim
      std = draft_get_sheet_size(ci="std");

      sdx = draft_get_sheet_size(ci="sdx") * draft_sheet_scale;
      sdy = draft_get_sheet_size(ci="sdy") * draft_sheet_scale;
    \endverbatim

  \sa draft_sheet_size.
*******************************************************************************/
function draft_get_sheet_size
(
  ci
) = table_get_value
    (
      r=draft_sheet_size_tr,
      c=draft_sheet_size_tc,
      ri=draft_sheet_size,
      ci=ci
    );

//! <map> sheet sizes data table columns definition.
/***************************************************************************//**
  \hideinitializer
  \private
*******************************************************************************/
draft_sheet_size_tc =
[
  ["id", "sheet size"],
  ["std", "standard"],
  ["sdx", "sheet x-dimension"],
  ["sdy", "sheet y-dimension"]
];

//! \<table> sheet sizes data table rows.
/***************************************************************************//**
  \hideinitializer
  \private
*******************************************************************************/
draft_sheet_size_tr =
[
  // ANSI
  [ "A", "ANSI", length( 8.5, "in"), length(  11, "in")],
  [ "B", "ANSI", length(  11, "in"), length(  17, "in")],
  [ "C", "ANSI", length(  17, "in"), length(  22, "in")],
  [ "D", "ANSI", length(  22, "in"), length(  34, "in")],
  [ "E", "ANSI", length(  34, "in"), length(  44, "in")],

  // ISO A
  ["A5", "ISO A", length( 149, "mm"), length( 210, "mm")],
  ["A4", "ISO A", length( 210, "mm"), length( 297, "mm")],
  ["A3", "ISO A", length( 297, "mm"), length( 420, "mm")],
  ["A2", "ISO A", length( 420, "mm"), length( 594, "mm")],
  ["A1", "ISO A", length( 594, "mm"), length( 841, "mm")],
  ["A0", "ISO A", length( 841, "mm"), length(1189, "mm")],

  // ISO B
  ["B5", "ISO B", length( 177, "mm"), length( 250, "mm")],
  ["B4", "ISO B", length( 250, "mm"), length( 354, "mm")],
  ["B3", "ISO B", length( 354, "mm"), length( 500, "mm")],
  ["B2", "ISO B", length( 500, "mm"), length( 707, "mm")],
  ["B1", "ISO B", length( 707, "mm"), length(1000, "mm")],
  ["B0", "ISO B", length(1000, "mm"), length(1414, "mm")],

  // Others
  ["Letter",    "Other", length( 215.9, "mm"), length( 279.4, "mm")],
  ["Legal",     "Other", length( 215.9, "mm"), length( 355.6, "mm")],
  ["Executive", "Other", length( 190.5, "mm"), length( 254.0, "mm")],
  ["C5E",       "Other", length( 163.0, "mm"), length( 229.0, "mm")],
  ["Comm10",    "Other", length( 105.0, "mm"), length( 241.0, "mm")],
  ["DLE",       "Other", length( 110.0, "mm"), length( 220.0, "mm")],
  ["Folio",     "Other", length( 210.0, "mm"), length( 330.0, "mm")],
  ["Ledger",    "Other", length( 432.0, "mm"), length( 279.0, "mm")],
  ["Tabloid",   "Other", length( 279.0, "mm"), length( 432.0, "mm")]
];

//----------------------------------------------------------------------------//
// sheet layout configuration:
//
//  (1) configuration getter function
//  (2) internal table definitions
//----------------------------------------------------------------------------//

//! Get sheet configuration value helper function.
/***************************************************************************//**
  \param    ci <string> The column identifier.

  \returns  \<value> The value of the identified column for the
            current sheet configured by \ref draft_sheet_config.

  \details

    \b Example:

    \verbatim
      zoy = draft_get_sheet_config(ci="zoy")

      smx = draft_get_sheet_config(ci="smx") * draft_sheet_scale;
      smy = draft_get_sheet_config(ci="smy") * draft_sheet_scale;
    \endverbatim

  \sa draft_sheet_config.
*******************************************************************************/
function draft_get_sheet_config
(
  ci
) = table_get_value
    (
      r=draft_sheet_config_tr,
      c=draft_sheet_config_tc,
      ri=draft_sheet_config,
      ci=ci
    );

//! <map> Sheet configuration data table columns definition.
/***************************************************************************//**
  \hideinitializer
  \private
*******************************************************************************/
draft_sheet_config_tc =
[
  ["id",  "configuration name"],
  ["info", "configuration description"],

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

//! \<table> Sheet configuration data table rows.
/***************************************************************************//**
  \hideinitializer
  \private
*******************************************************************************/
draft_sheet_config_tr =
[
  [
    "L84TS",
    "Small sheet landscape layout with 8x4 traditional zones",

    true,
    length(3/4, "in"),
    length(1/2, "in"),
    length(3/16, "in"),

    -1,
    +1,
    ["A", "B", "C", "D", "E", "F", "G", "H"],
    ["1", "2", "3", "4"],
    draft_get_config("font-sheet-zone-reference"),
    5/8,

    [1,[4,3,2,5]],
    8,
    4,
    [1/2,3],
    [3,1,13/8, [1,1,0,1,3]]
  ],

  [
    "P48TS",
    "Small sheet Portrait layout with 4x8 traditional zones",

    false,
    length(1/2, "in"),
    length(3/4, "in"),
    length(3/16, "in"),

    -1,
    +1,
    ["A", "B", "C", "D"],
    ["1", "2", "3", "4", "5", "6", "7", "8"],
    draft_get_config("font-sheet-zone-reference"),
    5/8,

    [1,[4,3,2,5]],
    8,
    4,
    [1/2,3],
    [3,1,13/8, [1,1,0,1,3]]
  ]
];

//! @}

//----------------------------------------------------------------------------//
// layout, style and formatting maps:
//----------------------------------------------------------------------------//

//! \name Maps
//! @{

//! <map> A title block map; style 1.
/***************************************************************************//**
  \details

    A title block is constructed using \ref draft_ztable "zoned tables".
    A new layout can be designed by defining a new map or by merging
    overrides to this style map. The map keys and structure depends on
    the implementation of the \ref draft_title_block "title block"
    rendering  operation.

  \sa draft_title_block().
  \sa draft_ztable().
  \hideinitializer
*******************************************************************************/
draft_title_block_map_style1 =
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
        ["center", "center"], draft_get_config("font-title-block-heading")
      ]
  ],

  // zone entry text configuration defaults
  [ "edefs",
      [
        empty_str, [ 0, +1], [ 0, -2-1/2], [0, -1-4/10],  0, 3/2,
        ["center", "center"], draft_get_config("font-title-block-entry")
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

//! <map> Table format map; common.
/***************************************************************************//**
  \hideinitializer
  \private
*******************************************************************************/
draft_table_format_map_common =
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
        ["center", "center"], draft_get_config("font-table-title")
      ]
  ]
];

//! <map> Table format map; centered, centered, centered --justified.
/***************************************************************************//**
  \hideinitializer
*******************************************************************************/
draft_table_format_map_ccc =
concat
(
  draft_table_format_map_common,
  [
    [ "hdefs",
        [
          empty_str, [ 0, -1], [ 0, -1/2-3/10], [0, -1-2/10], 0, 1,
          ["center", "center"], draft_get_config("font-table-heading")
        ]
    ],
    [ "edefs",
        [
          empty_str, [ 0, -1], [ 0, -1/2-4/10], [0, -1-2/10], 0, 1,
          ["center", "center"], draft_get_config("font-table-entry")
        ]
    ]
  ]
);

//! <map> Table format map; centered, left, left --justified.
/***************************************************************************//**
  \hideinitializer
*******************************************************************************/
draft_table_format_map_cll =
concat
(
  draft_table_format_map_common,
  [
    [ "hdefs",
        [
          empty_str, [-1, -1], [2/5,  -4/5], [0, -1-1/5], 0, 1,
          ["left", "center"], draft_get_config("font-table-heading")
        ]
    ],
    [ "edefs",
        [
          empty_str, [-1, -1], [2/5, -9/10], [0, -1-1/5], 0, 1,
          ["left", "center"], draft_get_config("font-table-entry")
        ]
    ]
  ]
);

//! <map> Table format map; centered, right, right --justified.
/***************************************************************************//**
  \hideinitializer
*******************************************************************************/
draft_table_format_map_crr =
concat
(
  draft_table_format_map_common,
  [
    [ "hdefs",
        [
          empty_str, [+1, -1], [-2/5,  -4/5], [0, -1-1/5], 0, 1,
          ["right", "center"], draft_get_config("font-table-heading")
        ]
    ],
    [ "edefs",
        [
          empty_str, [+1, -1], [-2/5, -9/10], [0, -1-1/5], 0, 1,
          ["right", "center"], draft_get_config("font-table-entry")
        ]
    ]
  ]
);

//! @}

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE dfraft_style1;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <tools/drafting/draft-base.scad>;
    length_unit_base = "mm";

    map_write( draft_config_map_style1 );
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_term}.mfs;
    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;

BEGIN_SCOPE sheet_sizes;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <tools/drafting/draft-base.scad>;
    length_unit_base = "in";

    table_write( draft_sheet_size_tr, draft_sheet_size_tc, heading_text=true );
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_term}.mfs;

    defines name "units" define "length_unit_base" strings "in mm";
    variables add_opts_combine "units";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;

BEGIN_SCOPE sheet_config;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <tools/drafting/draft-base.scad>;
    length_unit_base = "mm";

    table_write ( r=draft_sheet_config_tr, c=draft_sheet_config_tc,
                  cs=["id", "info"], heading_text=true );
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_term}.mfs;
    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;

BEGIN_SCOPE sheet_config_keys;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <tools/drafting/draft-base.scad>;
    length_unit_base = "mm";

    map_write( draft_sheet_config_tc );
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_term}.mfs;
    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
