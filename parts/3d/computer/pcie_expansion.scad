//! A PCI Express expansion chassis and/or enclosure generator.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2026

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

    \amu_define group_name  (PCIe Expansion)
    \amu_define group_brief (PCI Express expansion chassis and/or enclosure generator.)

  \amu_include (include/amu/doxyg_init_pd_gds_ipg.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/doxyg_define_in_parent_open.amu)
  \amu_define includes_required_add
  (
    shapes/select_common_2d.scad
    shapes/select_common_3d.scad
    transforms/base_cs.scad
    transforms/layout.scad
    models/2d/joint/dovetail.scad
    parts/3d/fastener/clamps.scad
    parts/3d/enclosure/project_box_rectangle.scad
  )
  \amu_include (include/amu/includes_required.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// global configuration
//----------------------------------------------------------------------------//

//! \name Configuration: PCI-E standard
//! @{

//! <map> PCI-E standard specifications common to full and half-length cards.
//! \hideinitializer
pcie_spec_common =
[
  //! \cond DOXYGEN_SHOULD_SKIP_THIS
  ["h_connector_max",                   11.25],
  ["l_keya_2_bkto",                     59.05],
  ["w_bkt_width",                       18.42],
  ["w_pcb_mth",                          1.57],
  ["h_rbpcbt_2_fngrb",                   3.40],
  ["bkt_mth",                            0.86],
  ["h_bkt_tab",                          5.07],
  ["w_bkt_tabo",                         4.11],
  ["l_card_max_full",                  312.00],
  ["l_card_max_half",                  167.65],
  //! \endcond
];

//! <map> PCI-E full-length card standard specifications.
//! \hideinitializer
pcie_spec_full =
[
  //! \cond DOXYGEN_SHOULD_SKIP_THIS
  ["h_card_max",                       111.15],
  ["h_card_max_2_pciblck",             106.65],
  ["h_pciblck_2_bktb",                 100.36],
  ["h_bktb_2_bkttabb",                 120.02],
  ["w_bkt_tab",                         10.20],
  ["wh_copen_window",          [12.06, 89.90]],
  ["h_bktb_2_copen",                    10.16],
  ["w_pcb_2_copen",                      0.35],
  ["wl_mnt_tab",       [+21.59 - 2.54, 11.43]],
  ["w_mnt_tab_o",     -1.57/2 + 18.42 - 21.59],
  ["wl_mnt_hole_o",  [-1.57/2 - 1.27, -64.13]],
  //! \endcond
];

//! <map> PCI-E half-length card standard specifications.
//! \hideinitializer
pcie_spec_half =
[
  //! \cond DOXYGEN_SHOULD_SKIP_THIS
  ["h_card_max",                        68.90],
  ["h_card_max_2_pciblck",              64.40],
  ["h_pciblck_2_bktb",                  63.58],
  ["h_bktb_2_bkttabb",                  79.20],
  ["w_bkt_tab",                         10.19],
  ["wh_copen_window", [12.07, 54.53 + 5.08*2]],
  ["h_bktb_2_copen",              9.04 - 5.08],
  ["w_pcb_2_copen",                      0.37],
  ["wl_mnt_tab",               [18.59, 11.84]],
  ["w_mnt_tab_o",              +1.57/2 + 0.37],
  ["wl_mnt_hole_o", [+1.57/2 + 14.71, -65.40]],
  //! \endcond
];

//! @}

//! \name Configuration: Riser board
//! @{

//! \cond DOXYGEN_SHOULD_SKIP_THIS
riser_map_doc =
[
  ["bottom_clearance",   "Vertical clearance under riser board"],
  ["slot_count",         "Riser physical slot count (fixed)"],
  ["vslot_count",        "Riser virtual slot count (user adjustable)"],
  ["multi_slot_offset",  "PCI-E multi-slot, slot-to-slot spacing"],
  ["slot1_to_edge1",     "Riser board slot-1 to adjacent edge distance"],
  ["slotn_to_edgen",     "Riser board slot-n to adjacent edge distance"],
  ["slot_key_to_edgef",  "Riser board key to front edge distance"],
  ["slot_link_width",    "Slot connector link width {1|4|8|16}"],
  ["pcb_length",         "Riser board PCB length front to rear"],
  ["pcb_th",             "Riser board PCB thickness"],
  ["mount_holes",        "Riser board mount holes; referenced to slot-1 key"],
  ["mount_holes_add",    "Riser board mount holes additions"],
  ["post_rotate",        "Mount post rotation in degrees"],
  ["post_fins",          "Mount post fin configuration: see project_box_rectangle()"],
  ["post_hole_d",        "Mount post hole diameter"],
  ["post_pad_d",         "Mount post diameter"]
];
//! \endcond

//! <map> USB 3.0 PCE164P-NO3 VER 007 1-slot riser board.
/***************************************************************************//**
  \details

    A configuration for the PCE164P-NO3 VER 007 1-slot riser board.
    This is the default riser board and can be used as a basis for
    constructing new riser board configuration.

    \amu_define title (Riser board configuration)
    \amu_define scope_id (riser_PCE164P_NO3_VER_007)
    \amu_define output_scad (false)
    \amu_define output_console (false)

    \amu_include (include/amu/scope_table.amu)

  \hideinitializer
*******************************************************************************/
riser_PCE164P_NO3_VER_007 =
[
  //! \cond DOXYGEN_SHOULD_SKIP_THIS
  ["bottom_clearance",        3],
  ["slot_count",              1],
  ["vslot_count",             0],
  ["multi_slot_offset",   20.32],
  ["slot1_to_edge1",         15],
  ["slotn_to_edgen",         28],
  ["slot_key_to_edgef",  113.25],
  ["slot_link_width",        16],
  ["pcb_length",         127.75],
  ["pcb_th",               1.75],
  ["mount_holes",
    let
    (
      w1 = 36.00,
      l1 = 96.50,
      ko = [-11.50, -11.00]
    )
    [
      [ 0,  0] + ko,
      [w1,  0] + ko,
      [ 0, l1] + ko,
      [w1, l1] + ko
    ]
  ],
  ["mount_holes_add",     undef],
  ["post_rotate",            45],
  ["post_fins",             [4]],
  ["post_hole_d",          3.00],
  ["post_pad_d",    2.75 * 3.00]
  //! \endcond
];

//! <map> AAAPCIE4HUB multiplier HUB 4-slot riser board.
/***************************************************************************//**
  \details

    A configuration for the AAAPCIE4HUB multiplier HUB 1-slot riser board.

    \amu_define title (Riser board configuration)
    \amu_define scope_id (riser_AAAPCIE4HUB)
    \amu_define output_scad (false)
    \amu_define output_console (false)

    \amu_include (include/amu/scope_table.amu)

  \hideinitializer
*******************************************************************************/
riser_AAAPCIE4HUB =
[
  //! \cond DOXYGEN_SHOULD_SKIP_THIS
  ["bottom_clearance",        3],
  ["slot_count",              4],
  ["vslot_count",             0],
  ["multi_slot_offset",   20.32],
  ["slot1_to_edge1",         12],
  ["slotn_to_edgen",         12],
  ["slot_key_to_edgef",      74],
  ["slot_link_width",         1],
  ["pcb_length",             99],
  ["pcb_th",                1.5],
  ["mount_holes",
    let
    (
      w1 = 20.00,
      w2 = 77.00,
      l1 = 46.00,
      ko = [-9.00, -7.0]
    )
    [
      [ 0,  0] + ko,
      [w1,  0] + ko,
      [w2,  0] + ko,
      [ 0, l1] + ko,
      [w1, l1] + ko,
      [w2, l1] + ko
    ]
  ],
  ["mount_holes_add",     undef],
  ["post_rotate",            45],
  ["post_fins",             [4]],
  ["post_hole_d",          3.00],
  ["post_pad_d",    2.75 * 3.00]
  //! \endcond
];

//! <map> SFF-8612 4X lane to 16X 1-slot riser board.
/***************************************************************************//**
  \details

    A configuration for the SFF-8612 4X lane to 16X 1-slot riser board.

    \amu_define title (Riser board configuration)
    \amu_define scope_id (riser_SFF_8612_4X_to_PCI_E_16X)
    \amu_define output_scad (false)
    \amu_define output_console (false)

    \amu_include (include/amu/scope_table.amu)

  \hideinitializer
*******************************************************************************/
riser_SFF_8612_4X_to_PCI_E_16X =
[
  //! \cond DOXYGEN_SHOULD_SKIP_THIS
  ["bottom_clearance",        0],
  ["slot_count",              1],
  ["vslot_count",             0],
  ["multi_slot_offset",   20.32],
  ["slot1_to_edge1",       5.75],
  ["slotn_to_edgen",      37.00],
  ["slot_key_to_edgef",   89.50],
  ["slot_link_width",        16],
  ["pcb_length",         122.00],
  ["pcb_th",               1.75],
  ["mount_holes",
    let
    (
      w1 =  37.00,
      l1 = 116.00,
      ko = [-3.00, -29.00]
    )
    [
      [ 0,  0] + ko,
      [w1,  0] + ko,
      [ 0, l1] + ko,
      [w1, l1] + ko
    ]
  ],
  ["mount_holes_add",     undef],
  ["post_rotate",            45],
  ["post_fins",             [4]],
  ["post_hole_d",          2.75],
  ["post_pad_d",    2.75 * 2.75]
  //! \endcond
];

//! @}

//! \name Configuration: Enclosure
//! @{

//! \cond DOXYGEN_SHOULD_SKIP_THIS
enclosure_map_doc =
[
  ["rounding",            "Enclosure corner rounding radius"],
  ["wth",                 "Enclosure minimum wall thickness"],
  ["board_count",         "Enclosure riser board count"],
  ["multi_board_offset",  "Multi-riser inter board offset"],
  ["space_add_edge1",     "Space to add to riser edge-1"],
  ["space_add_edgen",     "Space to add to riser edge-n"],
  ["space_add_length",    "Space to add to riser end length"],
  ["space_add_height",    "Space to add to enclosure height"],
  ["space_min_length",    "Enclosure minimum interior length"],
  ["space_min_height",    "Enclosure minimum interior height"],
  ["rb_min_clearance",    "Riser board minimum bottom clearance"],
  ["rib_pcb_gap",         "Rib removal gap for PCIE and riser board PCB"],
  ["lips_sides",          "Sides lips specification: see project_box_rectangle()"],
  ["lips_base",           "Base lips specification: see project_box_rectangle()"],
  ["lips_cover",          "Cover lips specification: see project_box_rectangle()"],
  ["walls",               "Enclosure interior walls: see project_box_rectangle()"],
  ["ribs",                "Enclosure wall rib specification: see project_box_rectangle()"],
  ["posts_sides_conf",    "Post configuration sides: [mode, default]: see project_box_rectangle()"],
  ["posts_base_conf",     "Post configuration base: [mode, default]: see project_box_rectangle()"],
  ["posts_cover_conf",    "Post configuration cover: [mode, default]: see project_box_rectangle()"],
  ["posts_sides",         "Post instances sides only: see project_box_rectangle()"],
  ["posts_base",          "Post instances base only: see project_box_rectangle()"],
  ["posts_cover",         "Post instances cover only: see project_box_rectangle()"],
  ["posts",               "Post instances for sides, base and cover: see project_box_rectangle()"],
  ["clamps_base",         "Enclosure base clamps: see clamp_zt_1p()"],
  ["holes_sides",         "Enclosure side hole instances: see project_box_rectangle()"],
  ["holes_base",          "Enclosure base hole instances: see project_box_rectangle()"],
  ["holes_cover",         "Enclosure cover hole instances: see project_box_rectangle()"],
  ["shapes_sides",        "Enclosure side shapes instances: see project_box_rectangle()"],
  ["shapes_base",         "Enclosure base shapes instances: see project_box_rectangle()"],
  ["shapes_cover",        "Enclosure cover shapes instances: see project_box_rectangle()"],
  ["bracket_window_gap",  "Bracket connector window gap [w]"],
  ["bracket_shoe_gap_p",  "Bracket shoe gap% [w, l, h]"],
  ["bracket_shoe_offset", "Bracket shoe vertical offset [h]"],
  ["bracket_mount_tab",   "Bracket mount tab configuration"],
  ["cut_sides",           "Enclosure sides cut [insets, vr, vrm]"],
  ["mode_rounding",       "Enclosure rounding mode: {0|1|2}"],
  ["mode_sides",          "Enclosure sides mode"],
  ["mode_proj_box",       "Mode for project_box_rectangle() module"],
  ["verb_proj_box",       "Verbosity for project_box_rectangle()"]
];
//! \endcond

//! <map> Default enclosure configuration.
/***************************************************************************//**
  \details

    The default enclosure configuration map.

    \amu_define title (Default enclosure configuration)
    \amu_define scope_id (enclosure_def)
    \amu_define output_scad (false)
    \amu_define output_console (false)

    \amu_include (include/amu/scope_table.amu)

    ## Multi-value and structured parameters

    ### bracket_mount_tab

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | decimal           |                   | thickness
      1 | decimal           |                   | tab-boarders (width addition)
      2 | decimal           |                   | screw hole diameter
      3 | decimal-list-4 \| decimal |           | tab rounding
      4 | decimal-list-4 \| decimal |           | tab rounding modes
      4 | decimal-list-5 \| decimal |           | dovetail configuration: see joint2d_dovetail() \p t

    ### clamps_base

    #### Data structure schema:

    name            | schema
    ---------------:|:----------------------------------------------
    clamps_base     | [[configuration, instances]]

    #### Data structure fields: clamps_base[0]: configuration

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | decimal-list-2       |                | wire hole size [w, h]
      1 | decimal-list-2       |                | zip-tie hole size [w, h]
      2 | decimal-list-3       |                | clamp envelope size [w, h, d]
      3 | datastruct           |                | tunnel configuration: see clamp_zt_1p() \p tunnel
      4 | decimal-list3-list-4 |                | vr [clamp, wire, tunnel]
      5 | integer-list3-list-4 |                | vrm [clamp, wire, tunnel]

    #### Data structure fields: clamps_base[1]: instances

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | integer-list-2    |                   | enclosure side [w, l]
      1 | decimal           |                   | clamp rotate [z]
      2 | integer           |                   | clamp align [d]
      3 | decimal-list-2    |                   | clamp move [w, l]
      4 | datastruct        |                   | side passage hole

    #### Data structure fields: clamps_base[1]: instances[4]: side passage hole

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | binary            |                   | enabled
      1 | decimal           |                   | vertical cut extension
      2 | datastruct        |                   | wall cone: see clamp_cg() \p cone

    ### cut_sides

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | decimal-list-4    |                   | edge cut insets: [bb, bt, ft, fb]
      1 | decimal-list-4    |                   | cut rounding: [bb, bt, ft, fb]
      2 | integer-list-4    |                   | cut rounding mode: [bb, bt, ft, fb]

    ### holes_sides

    See the documentation for project_box_rectangle() under the section
    for \p hole configuration for more details on hole specification.

    ### shapes_sides

    See the documentation for project_box_rectangle() under the section
    for \p shape configuration for more details on shape specification.

    ### posts

    See the documentation for project_box_rectangle() under the section
    for \p post configuration for more details on post specification.

    ### mode_sides

    Integer value is binary encoded.

      b | description
    ---:|:---------------------------------------
      0 | Add mount tab shelves
      1 | Hull adjacent-slot mount tab shelf
      2 | Hull removal of adjacent-slot connector windows
      3 | Hull removal of adjacent-slot ribs from wall
      4 | Hull removal of adjacent-slot bracket slide-down space
      5 | Enable enclosure side cutting
      6 | Cut enclosure front (positive side)
      7 | Cut enclosure rear (negative side near bracket)
      8 | Remove ribs on front enclosure wall for riser PCB
      9 | Remove ribs on front enclosure wall for PCIE card PCB

  \hideinitializer
*******************************************************************************/
enclosure_def =
[
  //! \cond DOXYGEN_SHOULD_SKIP_THIS
  ["rounding",                  6.75],
  ["wth",                        2.0],

  ["board_count",                  1],
  ["multi_board_offset",           0],

  ["space_add_edge1",              0],
  ["space_add_edgen",              0],
  ["space_add_length",             0],
  ["space_add_height",             0],

  ["space_min_length",             0],
  ["space_min_height",             0],

  ["rb_min_clearance",             0],

  ["rib_pcb_gap",                1/2],

  ["lips_sides",               1 + 8],
  ["lips_base",                    1],
  ["lips_cover",                   2],

  ["walls",
    undef
  ],

  ["ribs",                         0],

  ["posts_sides_conf",
    [
      0,                                  //  mode (binary encoded integer)
      [                                   //  defaults
        undef,                            //    hole0
        undef,                            //    hole1
        undef,                            //    post1
        undef,                            //    hole2
        undef,                            //    post2
        undef,                            //    fins0
        undef,                            //    fins1
        undef                             //    calculation
      ]
    ]
  ],
  ["posts_base_conf",
    [
      0,                                  //  mode (binary encoded integer)
      [                                   //  defaults
        undef,                            //    hole0
        undef,                            //    hole1
        undef,                            //    post1
        undef,                            //    hole2
        undef,                            //    post2
        undef,                            //    fins0
        undef,                            //    fins1
        undef                             //    calculation
      ]
    ]
  ],
  ["posts_cover_conf",
    [
      0,                                  //  mode (binary encoded integer)
      [                                   //  defaults
        undef,                            //    hole0
        undef,                            //    hole1
        undef,                            //    post1
        undef,                            //    hole2
        undef,                            //    post2
        undef,                            //    fins0
        undef,                            //    fins1
        undef                             //    calculation
      ]
    ]
  ],
  ["posts_sides",
    let(u=undef, t=2, o=7.5, f=[4, 120, u, 1/6])
    [
      [t, [-1,-1], [+o,+o], 180, u, u, u, f],
      [t, [-1,+1], [+o,-o], 090, u, u, u, f],
      [t, [+1,-1], [-o,+o], 270, u, u, u, f],
      [t, [+1,+1], [-o,-o], 000, u, u, u, f]
    ]
  ],
  ["posts_base",
    let(u=undef, t=3, o=7.5, f=[2, 180, u, 1/6])
    [
      [t, [-1,-1], [+o,+o], 000, u, u, u, f],
      [t, [-1,+1], [+o,-o], 270, u, u, u, f],
      [t, [+1,-1], [-o,+o], 090, u, u, u, f],
      [t, [+1,+1], [-o,-o], 180, u, u, u, f]
    ]
  ],
  ["posts_cover",
    let(u=undef, t=3, o=7.5, f=[2, 180, u, 1/6])
    [
      [t, [-1,-1], [+o,+o], 000, u, u, u, f],
      [t, [-1,+1], [+o,-o], 270, u, u, u, f],
      [t, [+1,-1], [-o,+o], 090, u, u, u, f],
      [t, [+1,+1], [-o,-o], 180, u, u, u, f]
    ]
  ],
  ["posts",
    undef
  ],

  ["clamps_base",
    [                                     // clamp set list [[conf, inst]]
      [                                   // set-0: [conf, inst]
        [                                 // set-0, 0: configuration
          [7.00, 4.75],                   // wire hole size [w, h]
          [5.50, 2.25],                   // zip-tie hole size [w, h]
          [20, 10, 10],                   // clamp envelope size [w, h, d]
          [                               // tunnel configuration
            3,                            //  0: corner radius
            [0],                          //  1: instance offset list
            binary_ishl(2, 0)             //  2: mode w-sel, h-sel, window
              + binary_ishl(2, 2)
              + binary_ishl(0, 4),
            [0, -1.00],                   //  3: radial offset [w, h]
            [0, -0.25]                    //  4: position offset [w, h]
          ],
          [3.00, 1.00, 1.25],             // vr [clamp, wire, tunnel]
          undef                           // vrm [clamp, wire, tunnel]
        ],
        [                                 // set-0, 1: instance list
          [
            [0,1],                        // enclosure side [w, l]
            0,                            // clamp rotate [z]
            1,                            // clamp align [d]
            [0,0],                        // clamp move [w, l]
            [                             // side passage hole
              true,                       //  enabled
              5 + 3/64,                   //  vertical cut extension
              [1, 2.5, 1/2, 31]           //  wall cone configuration [side, w, h, mode]
            ]
          ]
        ]
      ]
    ]
  ],

  ["holes_sides",
    [
      [
        [2, [5/2, 6]],
        -1,
        [
          0,
          [0,0,1/2],
          [90,0,90],
          0,
          30,
          [0, -10],
          [20, 3],
          [+10.75, -10.75],
          [true, false]
        ]
      ],
      [
        [3, [5/2,10], 1.5],
        -1,
        [
          0,
          [0,0,-1/2],
          [90,0,90],
          0,
          0,
          [0, +5.5],
          18,
          10.75,
          true
        ]
      ]
    ]
  ],
  ["holes_base",
    undef
  ],
  ["holes_cover",
    undef
  ],

  ["shapes_sides",
    undef
  ],
  ["shapes_base",
    undef
  ],
  ["shapes_cover",
    undef
  ],

  ["bracket_window_gap",        2.00],
  ["bracket_shoe_gap_p",      25/100],
  ["bracket_shoe_offset",      -2.00],
  ["bracket_mount_tab",
    [
      3.25,                               // thickness
      4.00,                               // tab-boarders (width addition)
      3.125,                              // screw hole diameter
      [3,3,5,5],                          // tab rounding
      [1,1,4,3],                          // tab rounding modes
      [5.0, 6.0, 2.0, 3/4, 1/4]           // dovetail configuration: see joint2d_dovetail(t)
    ]
  ],

  ["cut_sides",
    [
      [18, 12, 10, 10],                   // edge cut insets: [bb, bt, ft, fb]
      [10, 15, 0, 0],                     // cut rounding: [bb, bt, ft, fb]
      [1, 4, 0, 0]                        // cut rounding mode: [bb, bt, ft, fb]
    ]
  ],

  ["mode_rounding",                2],
  ["mode_sides",                   0],
  ["mode_proj_box",                0],
  ["verb_proj_box",                0]
  //! \endcond
];

//! @}

//----------------------------------------------------------------------------//
// global variables
//----------------------------------------------------------------------------//

//! \name Variables
//! @{

//! <boolean> Set to true to check configuration structure.
pcie_expansion_debug = false;

//! <boolean> Set to true for verbose configuration checking.
pcie_expansion_debug_verbose = false;

//! <map> Default riser board configuration.
riser_pcb_def = riser_PCE164P_NO3_VER_007;

//! @}

//----------------------------------------------------------------------------//
// functions
//----------------------------------------------------------------------------//

//! \name Functions
//! @{

//! Get riser board size for riser configuration.
/***************************************************************************//**
  \param    riser_pcb <map> The riser board configuration.
  \param    slots <integer> Optional slot count override.

  \returns  <decimal-list-3> The riser board size [w, l, h].
*******************************************************************************/
function pcie_expansion_rb_size
(
  riser_pcb,

  vslots
) =
  let
  (
    rb_vslot_count        = is_undef( vslots ) ?
                            map_get_value(riser_pcb, "vslot_count")
                          : vslots,

    rb_slot_count         = map_get_value(riser_pcb, "slot_count"),

    rb_slot1_to_edge1     = map_get_value(riser_pcb, "slot1_to_edge1"),
    rb_slotn_to_edgen     = map_get_value(riser_pcb, "slotn_to_edgen"),
    rb_multi_slot_offset  = map_get_value(riser_pcb, "multi_slot_offset"),
    rb_slot_key_to_edgef  = map_get_value(riser_pcb, "slot_key_to_edgef"),
    rb_pcb_length         = map_get_value(riser_pcb, "pcb_length"),
    rb_pcb_th             = map_get_value(riser_pcb, "pcb_th"),

    w = rb_slot1_to_edge1
      + (rb_slot_count + max(0, rb_vslot_count) - 1) * rb_multi_slot_offset
      + rb_slotn_to_edgen,

    l = rb_pcb_length,

    h = rb_pcb_th
  )
  [ w, l, h ];

//! Get enclosure internal or external size.
/***************************************************************************//**
  \param    pcie_base <map> PCI-E standard common configuration.
  \param    pcie_form <map> PCI-E half or full configuration.
  \param    riser_pcb <map> The riser board configuration.
  \param    enclosure <map> The enclosure design configuration.

  \param    riser_pcb_width <decimal> The riser board width.

  \param    external <boolean> Set \b true to return external size and
            \b false for internal size.

  \returns  <decimal-list-3> The enclosure size [w, l, h].
*******************************************************************************/
function pcie_expansion_size
(
  pcie_base = pcie_spec_common,
  pcie_form = pcie_spec_half,
  riser_pcb = riser_pcb_def,
  enclosure = enclosure_def,

  riser_pcb_width,

  external = false
) =
  let
  (
    riser_width             = is_undef( riser_pcb_width ) ?
                              first( pcie_expansion_rb_size(riser_pcb) )
                            : riser_pcb_width,

    // pcie
    pcie_spec               = map_merge(pcie_form, pcie_base),

    pcie_l_keya_2_bkto      = map_get_value(pcie_spec, "l_keya_2_bkto"),
    pcie_h_card_max         = map_get_value(pcie_spec, "h_card_max"),
    pcie_h_rbpcbt_2_fngrb   = map_get_value(pcie_spec, "h_rbpcbt_2_fngrb"),

    // riser
    rb_bottom_clearance     = map_get_value(riser_pcb, "bottom_clearance"),
    rb_pcb_th               = map_get_value(riser_pcb, "pcb_th"),
    rb_slot_key_to_edgef    = map_get_value(riser_pcb, "slot_key_to_edgef"),

    // enclosure
    encl_wth                = map_get_value(enclosure, "wth"),
    encl_board_count        = map_get_value(enclosure, "board_count"),
    encl_multi_board_offset = map_get_value(enclosure, "multi_board_offset"),
    encl_space_add_edge1    = map_get_value(enclosure, "space_add_edge1"),
    encl_space_add_edgen    = map_get_value(enclosure, "space_add_edgen"),
    encl_space_add_length   = map_get_value(enclosure, "space_add_length"),
    encl_space_add_height   = map_get_value(enclosure, "space_add_height"),
    encl_space_min_length   = map_get_value(enclosure, "space_min_length"),
    encl_space_min_height   = map_get_value(enclosure, "space_min_height"),

    encl_rb_min_clearance   = map_get_value(enclosure, "rb_min_clearance"),

    // riser board mount post height = (rib height + board bottom clearance)
    rb_mount_post_height    = encl_wth
                            + max(rb_bottom_clearance, encl_rb_min_clearance),

    w = riser_width
      + (encl_board_count-1) * (riser_width + encl_multi_board_offset)
      + encl_space_add_edge1
      + encl_space_add_edgen,

    l = rb_slot_key_to_edgef
      + pcie_l_keya_2_bkto
      + encl_space_add_length,

    h = rb_mount_post_height
      + rb_pcb_th
      + pcie_h_rbpcbt_2_fngrb
      + pcie_h_card_max
      + encl_space_add_height,

    l_min = max(l, encl_space_min_length),
    h_min = max(h, encl_space_min_height)
  )
  ( external )  ? [ w, l_min, h_min ] + [ encl_wth*2, encl_wth*2, encl_wth*2 ]
                : [ w, l_min, h_min ];

//! Get list of slot key locations of all riser boards.
/***************************************************************************//**
  \param    pcie_base <map> PCI-E standard common configuration.
  \param    pcie_form <map> PCI-E half or full configuration.
  \param    riser_pcb <map> The riser board configuration.
  \param    enclosure <map> The enclosure design configuration.

  \param    riser_pcb_width <decimal> The riser board width.
  \param    enclosure_size <decimal-list-3> The enclosure's internal size.

  \param    center_w <boolean> Use center of the enclosure as zero for
            the widths.

  \param    zero_lh <boolean> Zero the lengths and heights for each
            slot location, corresponding to the enclosure location
            [center, bottom].

  \param    edge1_w <boolean> The initial offset is for each riser board
            edge-1 rather than the slot-1 for board edge identification.

  \param    adjust_h <boolean> Adjust all heights by the offset of the
            enclosure sides and cover relative to the base when
            assembled.

  \returns  <datastruct> The location <decimal-list-3> of each slot on
            each riser board; a <decimal-list-list-list-3> or
            (board.slot.location_wlh).
*******************************************************************************/
function pcie_expansion_rbs_keys
(
  pcie_base = pcie_spec_common,
  pcie_form = pcie_spec_half,
  riser_pcb = riser_pcb_def,
  enclosure = enclosure_def,

  riser_pcb_width,
  enclosure_size,

  center_w = true,
  zero_lh  = false,
  edge1_w  = false,
  adjust_h = false
) =
  let
  (
    riser_width   = is_undef( riser_pcb_width ) ?
                    first( pcie_expansion_rb_size(riser_pcb) )
                  : riser_pcb_width,

    encl_size_wlh = is_undef( enclosure_size ) ?
                    pcie_expansion_size
                    (
                      pcie_base,
                      pcie_form,
                      riser_pcb,
                      enclosure,

                      riser_width
                    )
                  : enclosure_size,

    // pcie
    pcie_spec               = map_merge(pcie_form, pcie_base),

    pcie_l_keya_2_bkto      = map_get_value(pcie_spec, "l_keya_2_bkto"),

    // riser
    rb_slot_count           = map_get_value(riser_pcb, "slot_count"),
    rb_vslot_count          = map_get_value(riser_pcb, "vslot_count"),
    rb_multi_slot_offset    = map_get_value(riser_pcb, "multi_slot_offset"),
    rb_slot1_to_edge1       = map_get_value(riser_pcb, "slot1_to_edge1"),
    rb_bottom_clearance     = map_get_value(riser_pcb, "bottom_clearance"),

    // enclosure
    encl_wth                = map_get_value(enclosure, "wth"),
    encl_board_count        = map_get_value(enclosure, "board_count"),
    encl_multi_board_offset = map_get_value(enclosure, "multi_board_offset"),
    encl_space_add_edge1    = map_get_value(enclosure, "space_add_edge1"),

    encl_rb_min_clearance   = map_get_value(enclosure, "rb_min_clearance"),

    // riser board mount post height = (rib height + board bottom clearance)
    rb_mount_post_height    = encl_wth
                            + max(rb_bottom_clearance, encl_rb_min_clearance),

    w_zero  = + encl_space_add_edge1
              + (    edge1_w ? 0 : rb_slot1_to_edge1 )
              - ( ! center_w ? 0 : first(encl_size_wlh)/2 ),

    l_zero  = zero_lh ? 0 : - second(encl_size_wlh)/2 + pcie_l_keya_2_bkto,
    h_zero  = zero_lh ? 0 : + encl_wth + rb_mount_post_height,

    h_zadj  = adjust_h ? -encl_wth*2 : 0
  )
  [ // each riser board
    for (rb_n = [0:encl_board_count-1])
    [ // each riser board slot
      for (rb_s = [0 : rb_slot_count + max(0, rb_vslot_count) - 1])
      let
      ( // instance offsets: board and board-slot
        w_oi  = rb_n * (riser_width + encl_multi_board_offset),
        w_os  = rb_s * rb_multi_slot_offset
      )
      [w_zero + w_oi + w_os, l_zero, h_zero + h_zadj]
    ]
  ];

//! @}

//----------------------------------------------------------------------------//
// modules
//----------------------------------------------------------------------------//

//! \name Modules
//! @{

//! \cond DOXYGEN_SHOULD_SKIP_THIS
if ( pcie_expansion_debug )
{
  verbose = pcie_expansion_debug_verbose;

  //
  // check maps
  //

  map_check(pcie_spec_common, verbose);
  map_check(pcie_spec_full, verbose);
  map_check(pcie_spec_half, verbose);

  map_check(riser_PCE164P_NO3_VER_007, verbose);
  map_check(riser_AAAPCIE4HUB, verbose);
  map_check(riser_SFF_8612_4X_to_PCI_E_16X, verbose);

  map_check(enclosure_def, verbose);
}
//! \endcond

//! Generate a PCI Express expansion open chassis or closed enclosure
/***************************************************************************//**
  \param    pcie_base <map> PCI-E standard common configuration.
  \param    pcie_form <map> PCI-E half or full configuration.
  \param    riser_pcb <map> The riser board configuration.
  \param    enclosure <map> The enclosure design configuration.

  \param    show_riser <boolean> Render model of riser board on the
            enclosure base.

  \param    part_color <color-list-6> a list of colors for each part;
            [base, sides,  cover, ...].

  \param    part <integer> The part to construct; A binary encoded
            integer value (see below).

  \param    mode <integer> The construction orientation mode with
            (0=design, 1=print, 2=assembled, 3=exploded, 4=build-plate).

  \param    verb <integer> The output console verbosity.

  \details

    This module is designed to construct chassis and enclosures for
    common Peripheral Component Interconnect Express (PCIe) riser
    boards, which provide external access to PCIe slots. These riser
    boards are commonly used to connect one or more GPUs, or other PCIe
    cards, externally to a computer system. The module offers the
    capability to generate both open chassis and closed enclosures.

    ## Multi-value and structured parameters

    ### part

    Integer value is binary encoded.

      b | description
    ---:|:---------------------------------------
      0 | base
      1 | sides with in-place bracket mount tab shelf
      2 | cover
      3 | sides with female dovetails for use with separate mount tab
      4 | separate bracket mount tab with male dovetails
      5 | mount tab dovetail joint test assembly (design mode)
      6 | mount tab  dovetail joint test build plate for fabrication

    Before fabricating a design that includes a dovetailed bracket
    mount tab, create and assemble a dovetail test joint to verify
    proper fit. Enable the test joint by setting part bit 6 to 1 (for
    example, `part = pow(2, 6))`. To refine or evaluate the dovetail
    configuration, model an assembled test joint by enabling \p part
    bit 5.

    \amu_define scope_id      (example)
    \amu_define title         (Enclosure customization example)
    \amu_define image_views   (front right back diag)
    \amu_define image_columns (4)
    \amu_define image_size    (sxga)
    \amu_define output_scad   (true)

    \amu_include (include/amu/scope_diagrams_3d.amu)

  [PCIe]: https://en.wikipedia.org/wiki/PCI_Express
*******************************************************************************/
module pcie_expansion
(
  pcie_base = pcie_spec_common,
  pcie_form = pcie_spec_half,
  riser_pcb = riser_pcb_def,
  enclosure = enclosure_def,

  show_riser = false,

  part_color,

  part  = 7,
  mode  = 3,

  verb  = 0
)
{
  //
  // enclosure base
  //
  module enclosure_base(enable = 1+2)
  {
    // enable: B0: base, B1: wire_clamp

    // base
    encl_bracket_shoe_offset  = map_get_value(enclosure, "bracket_shoe_offset");
    encl_holes_base           = map_get_value(enclosure, "holes_base");
    encl_shapes_base          = map_get_value(enclosure, "shapes_base");

    // sides and base
    encl_clamps_base          = map_get_value(enclosure, "clamps_base");
    encl_bracket_shoe_gap_p   = map_get_value(enclosure, "bracket_shoe_gap_p");

    // construct wire clamps
    module wire_clamps(mode)
    {
      for (clamp_sets = encl_clamps_base)
      {
        clamp_conf = first(clamp_sets);
        clamp_inst = second(clamp_sets);

        for (inst = clamp_inst)
        {
          eci_side    = defined_e_or( inst, 0, [0, 0] );
          eci_rotate  = defined_e_or( inst, 1, 0 );
          eci_align   = defined_e_or( inst, 2, 1 );
          eci_offset  = defined_e_or( inst, 3, [0, 0] );

          translate
          (
            [
              first(encl_size_wlh)/2 * first(eci_side) + first(eci_offset),
              second(encl_size_wlh)/2 * second(eci_side) + second(eci_offset),
              0
            ]
          )
          rotate([90, 0, eci_rotate])
          clamp_zt_1p
          (
            size    = clamp_conf[0],
            ztie    = clamp_conf[1],
            clamp   = clamp_conf[2],
            tunnel  = clamp_conf[3],
            vr      = clamp_conf[4],
            vrm     = clamp_conf[5],

            align   = [0, 1, eci_align],
            mode    = mode
          );
        }
      }
    }

    // model riser board
    module model_riser()
    {
      rb_slot_count         = map_get_value(riser_pcb, "slot_count");

      rb_slot1_to_edge1     = map_get_value(riser_pcb, "slot1_to_edge1");
      rb_slot_key_to_edgef  = map_get_value(riser_pcb, "slot_key_to_edgef");

      rb_slot_link_width    = map_get_value(riser_pcb, "slot_link_width");

      rb_mount_holes        = map_get_value(riser_pcb, "mount_holes");
      rb_post_hole_d        = map_get_value(riser_pcb, "post_hole_d");

      // pcie slot lane width map and slot key offset
      sm = [ [1, 25], [4, 39], [8, 56], [16, 89] ];
      ko = 14.50;

      // slot size for riser lane width (use 1x when undefined)
      ss = [7.50, defined_or(map_get_value(sm, rb_slot_link_width), 25), 11.25];

      // riser and slot fixed offsets
      ro = [-rb_slot1_to_edge1, -riser_size0.y + rb_slot_key_to_edgef, 0];
      so = [-ss.x/2, -ko, rb_pcb_th];

      for (wlh_rb_inst = slot_keys_wlh)
      {
        // riser board pcd and mount holes
        difference()
        {
          wlh_rb_inst_o = first( wlh_rb_inst );

          translate(wlh_rb_inst_o + ro)
          cube(riser_size0, center=false);

          for (p = rb_mount_holes)
            translate(wlh_rb_inst_o + concat(p, -eps*2))
            cylinder(d=rb_post_hole_d, h=rb_pcb_th+eps*4, center=false);
        }

        // riser board slots; only show physical slots (skip vslots)
        for (i = [0 : rb_slot_count-1])
        {
          wlh_slot_inst = wlh_rb_inst[i];

          translate(wlh_slot_inst + so)
          cube(ss, center=false);
        }
      }
    }

    // rise board mount posts
    rb_mount_post_insts =
      let
      (
        rb_mount_holes      = map_get_value(riser_pcb, "mount_holes"),
        rb_mount_holes_add  = map_get_value(riser_pcb, "mount_holes_add"),

        rb_post_rotate      = map_get_value(riser_pcb, "post_rotate"),
        rb_post_fins        = map_get_value(riser_pcb, "post_fins"),
        rb_post_hole_d      = map_get_value(riser_pcb, "post_hole_d"),
        rb_post_pad_d       = map_get_value(riser_pcb, "post_pad_d"),

        insts               = is_undef(rb_mount_holes_add) ?
                              rb_mount_holes
                            : concat(rb_mount_holes, rb_mount_holes_add)
      )
      [
        for (rb_s = slot_keys_wlh, pm_inst = insts)
        let
        (
          rb_s1   = first(rb_s),                    // board instance slot-1
          wl_o    = [first(rb_s1), second(rb_s1)],  // width and length offset
          post_h  = third(rb_s1) - encl_wth         // post height
        )
        [
          0,                        // type
          [0, 0],                   // zero
          wl_o + pm_inst,           // move
          rb_post_rotate,           // rotate
          undef,                    // hole0
          [rb_post_hole_d, post_h], // hole1
          [rb_post_pad_d, post_h],  // post
          rb_post_fins              // fins
        ]
      ];

    // merge all posts
    encl_posts_base_all =
      merge_post_inst_sets
      (
        encl_posts_base_conf,
        [ encl_posts_base, rb_mount_post_insts ],
        1, [ encl_posts ]
      );

    // reference: slot-1 of rb-1 [w, l, h]
    wlh_rb1s1_bwo =
    [
      -pcie_w_pcb_mth/2 - pcie_bkt_mth + pcie_w_bkt_tabo,

      -pcie_l_keya_2_bkto,

      rb_pcb_th
      + ( pcie_h_card_max - pcie_h_card_max_2_pciblck )
      + pcie_h_rbpcbt_2_fngrb
      + pcie_h_pciblck_2_bktb
      - pcie_h_bktb_2_bkttabb
    ];

    //
    // construct base
    //
    if ( binary_bit_is(enable, 0, 1) )
    difference()
    {
      // bracket shoe tab dimensions
      tab_sm  = 1 + encl_bracket_shoe_gap_p;
      tab_ho  = encl_bracket_shoe_offset;

      tab_so  = pcie_w_bkt_width * (1 - tab_sm)/4;

      tab_bw  = pcie_w_bkt_width * tab_sm;
      tab_tw  = pcie_w_bkt_tab * tab_sm;
      tab_tl  = pcie_bkt_mth * tab_sm;
      tab_th  = pcie_h_bkt_tab * tab_sm;

      // enclosure base with tab shoe blocks
      union()
      {
        // enclosure base
        project_box_rectangle
        (
          wth   = encl_wth,
          size  = firstn(encl_size_wlh, 2),
          lid   = encl_wth,
          h     = encl_wth,
          lip   = encl_lips_base,
          rib   = encl_ribs,
          wall  = encl_walls,
          post  = encl_posts_base_all,
          hole  = encl_holes_base,
          shape = encl_shapes_base,
          vr    = encl_rounding,
          vrm   = encl_mode_rounding,
          align = [0, 0, 0],
          mode  = binary_or(encl_mode_proj_box, 1),   // bit-0=1, others unchanged
          verb  = encl_verb_proj_box
        );

        // add tab shoe (as needed for minimal insertion = encl_wth)
        for (wlh_rb_inst = slot_keys_wlh)
          for (wlh_slot_inst = wlh_rb_inst)
            let
            (
              so  = wlh_slot_inst + wlh_rb1s1_bwo + [tab_so - encl_wth, 0, 0],
              // height for minimal insertion = encl_wth
              sh  = max(encl_wth*2, third(so) + encl_wth),
              vrm = [1, 1, 4 ,3],
              vr  = encl_wth/2
            )
            translate( firstn(so, 2) )
            extrude_linear_uss(sh)
            pg_rectangle([tab_tw+encl_wth*2, tab_tl + encl_wth], vrm=vrm, vr=vr);
      }

      // remove slot for bracket bottom shoe tab
      for (wlh_rb_inst = slot_keys_wlh)
        for (wlh_slot_inst = wlh_rb_inst)
          translate(wlh_slot_inst + wlh_rb1s1_bwo)
          rotate([90, 0, 0])
          translate([tab_so, tab_ho, -tab_tl])
          extrude_linear_uss(tab_tl)
          {
            pg_rectangle([tab_tw, tab_th]);
            pg_trapezoid(b=[tab_tw, tab_bw], h=tab_th, a=117.125, o=[0, tab_th]);
          }

      // remove wire clamp tunnels
      if ( binary_bit_is(enable, 1, 1) )
      wire_clamps(0);
    }

    // add wire clamps
    if ( binary_bit_is(enable, 1, 1) )
    wire_clamps(1);

    // model riser boards
    if ( show_riser == true )
    %model_riser();
  }

  //
  // enclosure sides
  //
  module enclosure_sides(enable = 1+2+4+8)
  {
    /*
      enable

        B0: sides
        B1: wire clamps passage hole
        B2: wire clamps passage cone
        B3: in-place bracket mount tab shelf
        B4: remove female dovetails from side for use with separate shelf
        B5: separate bracket mount tab shelf with male dovetails added

      mode_sides bits

        B0: add mount tab shelves
        B1: hull adjacent-slot mount tab shelf
        B2: hull removal of adjacent-slot connector windows
        B3: hull removal of adjacent-slot ribs from wall
        B4: hull removal of adjacent-slot bracket slide-down space
        B5: enable enclosure side cutting
        B6: cut enclosure front (positive side)
        B7: cut enclosure rear (negative side near bracket)
        B8: remove ribs on front edge of wall for riser PCB
        B9: remove ribs on front edge of wall for PCIE card PCB
    */

    // riser board
    rb_slot1_to_edge1         = map_get_value(riser_pcb, "slot1_to_edge1");

    // sides
    encl_rib_pcb_gap          = map_get_value(enclosure, "rib_pcb_gap");
    encl_mode_sides           = map_get_value(enclosure, "mode_sides");
    encl_cut_sides            = map_get_value(enclosure, "cut_sides");
    encl_holes_sides          = map_get_value(enclosure, "holes_sides");
    encl_shapes_sides         = map_get_value(enclosure, "shapes_sides");
    encl_bracket_mount_tab    = map_get_value(enclosure, "bracket_mount_tab");

    // sides and base
    encl_clamps_base          = map_get_value(enclosure, "clamps_base");
    encl_bracket_window_gap   = map_get_value(enclosure, "bracket_window_gap");

    // construct wire clamps and passage ways
    module wire_clamps_passage( mode )
    {
      for (clamp_sets = encl_clamps_base)
      {
        clamp_conf = first(clamp_sets);
        clamp_inst = second(clamp_sets);

        for (inst = clamp_inst)
        {
          eci_side    = defined_e_or( inst, 0, [0, 0] );
          eci_rotate  = defined_e_or( inst, 1, 0 );
          eci_align   = defined_e_or( inst, 2, 1 );
          eci_offset  = defined_e_or( inst, 3, [0, 0] );
          eci_passage = defined_e_or( inst, 4, [0, 0] );

          pass_enable = defined_e_or( eci_passage, 0, false );
          pass_hcut   = defined_e_or( eci_passage, 1, 0 );
          pass_cone   = defined_e_or( eci_passage, 2, undef );

          wire        = clamp_conf[0];

          if ( pass_enable )
          translate
          (
            [
              first(encl_size_wlh)/2 * first(eci_side) + first(eci_offset),
              second(encl_size_wlh)/2 * second(eci_side) + second(eci_offset),
              -pass_hcut/2
            ]
          )
          rotate([90, 0, eci_rotate])
          clamp_cg
          (
            size  = wire + [0, pass_hcut],
            cone  = pass_cone,
            wth   = encl_wth*2,
            gap   = 10,
            mode  = mode
          );
        }
      }
    }

    // bracket mount tab shelf and mount screw-hole
    module bracket_mount_tab_shelf
    (
      inplace = true,
      dovetail = false,
      dovetail_type = 0
    )
    {
      // selective move to bottom of sides with y-offset by encl_wth
      function zz_oy ( p ) = inplace ? p : [p.x, p.y - encl_wth*3, -encl_wth + wth];

      wth = defined_e_or(encl_bracket_mount_tab, 0, encl_wth);  // tab thickness
      wa  = defined_e_or(encl_bracket_mount_tab, 1, 0);         // tab width addition
      hd  = defined_e_or(encl_bracket_mount_tab, 2, 3.125);     // screw hole diameter
      vr  = defined_e_or(encl_bracket_mount_tab, 3, 0);         // tab rounding radius
      vrm = defined_e_or(encl_bracket_mount_tab, 4, 1);         // tab rounding modes
      dt  = defined_e_or(encl_bracket_mount_tab, 5, [5, 6]);    // dovetail configuration

      for (wlh_rb_inst = slot_keys_wlh)
      difference()
      {
        // mode_sides B1: hull adjacent-slot mount tab shelf
        hull_cs( binary_bit_is(encl_mode_sides, 1, 1) )
        for (wlh_slot_inst = wlh_rb_inst)
          translate( zz_oy (wlh_slot_inst + wlh_rb1s1_bwo) )
          {
            w_o = -wa + pcie_w_mnt_tab_o;
            l_o = -encl_wth;
            h_o = -wth;

            translate([w_o, l_o, h_o])
            mirror([0, 1, 0])
            extrude_linear_uss(wth, center=false)
            pg_rectangle(size=pcie_wl_mnt_tab + [2,0]*wa, vr=vr, vrm=vrm, center=false);
          }

        // mount tab screw hole
        for (wlh_slot_inst = wlh_rb_inst)
          translate( zz_oy (wlh_slot_inst + wlh_rb1s1_bwo) )
          {
            w_o = 0;
            l_o = +pcie_l_keya_2_bkto;
            h_o = -wth/2;

            translate([w_o, l_o, h_o] + concat(pcie_wl_mnt_hole_o, 0))
            cylinder(d=hd, h=wth+eps*4, center=true);
          }
      }

      // add dovetails
      for (wlh_rb_inst = slot_keys_wlh, wlh_slot_inst = wlh_rb_inst)
        translate( zz_oy (wlh_slot_inst + wlh_rb1s1_bwo) )
        {
          // dovetail configuration
          w   = first( pcie_wl_mnt_tab );
          d   = encl_wth + eps*4;

          w_o = pcie_w_mnt_tab_o;
          l_o = -encl_wth;
          h_o = -wth;

          translate([w_o, l_o, h_o])
          extrude_linear_uss(wth, center=false)
          joint2d_dovetail(t=dt, d=d, w=w, center=true, type=dovetail_type);
        }
    }

    // cut enclosure sides
    module cut_enclosure_sides( cut_sides )
    {
      // external enclosure size (ignoring protrusions).
      es  = encl_size_wlh
          + [2, 2, 1] * encl_wth
          + [4, 4, 2] * eps;

      sco = defined_e_or(cut_sides, 0, es.y/10);
      vr  = defined_e_or(cut_sides, 1, 0);
      vrm = defined_e_or(cut_sides, 2, 0);

      bbo = defined_e_or(sco, 0, sco);
      bto = defined_e_or(sco, 1, bbo);
      fto = defined_e_or(sco, 2, bto);
      fbo = defined_e_or(sco, 3, bbo);

      cp = polygon_round_eve_all_p
      (
        [
          [+(es.y/2 - fbo), 0],
          [-(es.y/2 - bbo), 0],
          [-(es.y/2 - bto), es.z],
          [+(es.y/2 - fto), es.z],
        ],
        vr=vr,
        vrm=vrm
      );

      translate([0, 0, -encl_wth])
      rotate([90, 0, 90])
      extrude_linear_uss(es.x * 2, center=true)
      union()
      {
        polygon( cp );

        // mode_sides B6-7: remove enclosure front and/or rear side walls
        for ( x = [0, 1] )
        if ( binary_bit_is(encl_mode_sides, 6+x, 1) )
        mirror([x, 0])
        pg_rectangle([es.y, es.z]);
      }
    }

    // merge all posts
    encl_posts_sides_all =
      merge_post_inst_sets
      (
        encl_posts_sides_conf,
        [ encl_posts_sides ],
        0, [ encl_posts ]
      );

    // reference: base to sides zero alignment
    wlh_s2b_ao = [ 0, 0, encl_wth*2 ];

    // reference: slot-1 of rb-1 [w, l, h]
    wlh_rb1s1_bwo =
    [
      0,

      -pcie_l_keya_2_bkto,

      rb_pcb_th
      + ( pcie_h_card_max - pcie_h_card_max_2_pciblck )
      + pcie_h_rbpcbt_2_fngrb
      + pcie_h_pciblck_2_bktb
    ] - wlh_s2b_ao;

    // decode ribs configuration
    decode_ribs = defined_e_or(encl_ribs, 0, encl_ribs);

    // mode bit-0=1, others unchanged (to ensure no ribs on lid section)
    masked_ribs = binary_or(decode_ribs, 1);

    // repackage ribs configuration
    encode_ribs = is_list(encl_ribs) ?
                  concat(masked_ribs, tailn(encl_ribs))
                : masked_ribs;

    //
    // construct sides
    //
    if ( binary_bit_is(enable, 0, 1) )
    difference()
    {
      union()
      {
        // enclosure sides
        project_box_rectangle
        (
          wth   = encl_wth,
          size  = firstn(encl_size_wlh, 2),
          lid   = undef,
          h     = third(encl_size_wlh),
          lip   = encl_lips_sides,
          rib   = encode_ribs,
          wall  = encl_walls,
          post  = encl_posts_sides_all,
          hole  = encl_holes_sides,
          shape = encl_shapes_sides,
          vr    = encl_rounding,
          vrm   = encl_mode_rounding,
          align = [0, 0, 0],
          mode  = binary_or(encl_mode_proj_box, 1),   // bit-0=1, others unchanged
          verb  = encl_verb_proj_box
        );

        // add cone to wire clamp passage hole
        if ( binary_bit_is(enable, 2, 1) )
        translate(wlh_s2b_ao)
        wire_clamps_passage(1);

        // mode_sides B0: add bracket mount tab shelf and mount screw-hole(s)
        if ( binary_bit_is(enable, 3, 1) && binary_bit_is(encl_mode_sides, 0, 1) )
        bracket_mount_tab_shelf(inplace=true, dovetail=false);
      }

      // project_box_rectangle() default rib height = encl_wth
      rib_h = encl_wth * 2;

      // bracket window features gap [w]
      gap_w = encl_bracket_window_gap;

      // remove per-board x per-slot features
      for (wlh_rb_inst = slot_keys_wlh)
      {
        // mode_sides B2: remove connector window
        hull_cs( binary_bit_is(encl_mode_sides, 2, 1) )
        for (wlh_slot_inst = wlh_rb_inst)
          translate(wlh_slot_inst + wlh_rb1s1_bwo)
          {
            w = pcie_wh_copen_window;                     // window
            e = encl_wth + rib_h;                         // extrude
            r = [-90, 0, 0];                              // rotation
            t = [ pcie_w_pcb_mth/2 + pcie_w_pcb_2_copen,
                  -encl_wth - eps*4,
                  -pcie_h_bktb_2_copen ];

            translate( t - [gap_w/2, 0, 0] ) rotate( r )
            extrude_linear_uss(e, center=false)
            pg_rectangle(size=w + [gap_w, 0, 0], center=false);
          }

        // mode_sides B3: remove ribs from wall
        hull_cs( binary_bit_is(encl_mode_sides, 3, 1) )
        for (wlh_slot_inst = wlh_rb_inst)
          translate(wlh_slot_inst + wlh_rb1s1_bwo)
          {
            w = [pcie_w_bkt_width, pcie_h_bktb_2_bkttabb];
            e = rib_h + eps*4;
            r = [-90, 0, 0];
            t = [ -pcie_w_pcb_mth/2 - pcie_bkt_mth, 0, 0 ];

            translate( t - [gap_w/2, 0, 0] ) rotate( r )
            extrude_linear_uss(e, center=false)
            pg_rectangle(size=w + [gap_w, 0, 0], center=false);
          }

        // mode_sides B4: remove slide-down space for bracket mount tab
        hull_cs( binary_bit_is(encl_mode_sides, 4, 1) )
        for (wlh_slot_inst = wlh_rb_inst)
          translate(wlh_slot_inst + wlh_rb1s1_bwo)
          {
            w = pcie_wl_mnt_tab + [0, rib_h];
            e = pcie_h_connector_max - pcie_h_rbpcbt_2_fngrb + pcie_bkt_mth;
            r = [0, 0, 0];
            t = [ pcie_w_mnt_tab_o, -second(pcie_wl_mnt_tab), 0 ];

            translate( t - [gap_w/2, 0, 0] ) rotate( r )
            extrude_linear_uss(e, center=false)
            pg_rectangle(size=w + [gap_w, 0, 0], center=false);
          }

        // mode_sides B8: remove ribs on front edge of wall for riser PCB
        if ( binary_bit_is(encl_mode_sides, 8, 1) )
        {
          // position of slot-1 of riser board instance
          wlh_rbs1 = first( wlh_rb_inst );

          // reference: slot-1 key on front interior wall at base of riser
          wlh_rb1s1_fwo =
          [
            wlh_rbs1.x - rb_slot1_to_edge1,
            encl_size_wlh.y/2,
            wlh_rbs1.z
          ];

          g = [encl_rib_pcb_gap, encl_rib_pcb_gap];

          translate( wlh_rb1s1_fwo )
          {
            w = [riser_size0.x, riser_size0.z] + g;
            e = rib_h + eps*8;
            r = [90, 0, 0];
            t = [ -g.x/2, eps*4, -g.y/2-rib_h ];

            translate( t ) rotate( r )
            extrude_linear_uss(e, center=false)
            pg_rectangle(size=w, center=false);
          }
        }

        // mode_sides B9: remove ribs on front edge of wall for PCIE card PCB
        if ( binary_bit_is(encl_mode_sides, 9, 1) )
        {
          for (wlh_slot_inst = wlh_rb_inst)
          {
            // reference: slot-1 key on front interior wall at base of riser
            wlh_rb1s1_fwo =
            [
              wlh_slot_inst.x,
              encl_size_wlh.y/2,
              wlh_slot_inst.z
            ];

            g = [encl_rib_pcb_gap, 0];

            translate( wlh_rb1s1_fwo )
            {
              w = [pcie_w_pcb_mth, encl_size_wlh.z] + g;
              e = rib_h + eps*8;
              r = [90, 0, 0];
              t = [ -g.x/2 - pcie_w_pcb_mth/2, eps*4, -g.y/2-rib_h ];

              translate( t ) rotate( r )
              extrude_linear_uss(e, center=false)
              pg_rectangle(size=w, center=false);
            }
          }
        }
      }

      // remove wire clamp passage hole
      if ( binary_bit_is(enable, 1, 1) )
      translate(wlh_s2b_ao)
      wire_clamps_passage(0);

      // mode_sides B5: cut sides for open enclosure modes
      if ( binary_bit_is(encl_mode_sides, 5, 1) )
      cut_enclosure_sides( encl_cut_sides );

      // remove bracket mount tab shelf dovetail slots
      if ( binary_bit_is(enable, 4, 1) && binary_bit_is(encl_mode_sides, 0, 1) )
        bracket_mount_tab_shelf(inplace=true, dovetail=true, dovetail_type=2);
    }

    //
    // separate bracket mount tab shelf with dovetail joint
    //
    if ( binary_bit_is(enable, 5, 1) && binary_bit_is(encl_mode_sides, 0, 1) )
      bracket_mount_tab_shelf(inplace=false, dovetail=true, dovetail_type=0);
  }

  //
  // enclosure cover
  //
  module enclosure_cover(enable = 1)
  {
    // enable: B0: base

    // cover
    encl_holes_cover          = map_get_value(enclosure, "holes_cover");
    encl_shapes_cover         = map_get_value(enclosure, "shapes_cover");

    // merge all posts
    encl_posts_cover_all =
      merge_post_inst_sets
      (
        encl_posts_cover_conf,
        [ encl_posts_cover ],
        1, [ encl_posts ]
      );

    //
    // construct cover
    //
    if ( binary_bit_is(enable, 0, 1) )
    mirror([ 0, 0, 1])
    project_box_rectangle
    (
      wth   = encl_wth,
      size  = firstn(encl_size_wlh, 2),
      lid   = encl_wth,
      h     = encl_wth*2,
      lip   = encl_lips_cover,
      rib   = encl_ribs,
      wall  = encl_walls,
      post  = encl_posts_cover_all,
      hole  = encl_holes_cover,
      shape = encl_shapes_cover,
      vr    = encl_rounding,
      vrm   = encl_mode_rounding,
      align = [0, 0, 0],
      mode  = binary_or(encl_mode_proj_box, 1),       // bit-0=1, others unchanged
      verb  = encl_verb_proj_box
    );
  }

  //
  // dovetail joint test assemble
  //
  module dovetail_test(select = 0)
  {
    encl_bracket_mount_tab = map_get_value(enclosure, "bracket_mount_tab");

    wth = defined_e_or(encl_bracket_mount_tab, 0, encl_wth);
    dt  = defined_e_or(encl_bracket_mount_tab, 5, [5, 6]);

    w   = first( pcie_wl_mnt_tab );
    d   = encl_wth + eps*4;
    x   = w / 5;

    // assembled joint
    if (select == 0)
    {
      difference()
      {
        translate([-x/2, +eps*2, -wth/2-eps*2])
        cube([w+x, d-eps*4, wth*3/2], center=false);
        extrude_linear_uss(wth, center=false)
        joint2d_dovetail(t=dt, d=d, w=w, center=true, type=2);
      }

      #union()
      {
        extrude_linear_uss(wth, center=false)
        joint2d_dovetail(t=dt, d=d, w=w, center=true, type=0);
        translate([-x/2, -d, 0])
        cube([w+x, d, wth], center=false);
      }
    }

    // test joint build plate for 3d printer
    if (select == 1)
    {
      // female joint printed horizontally
      translate([0, wth + d*2, 0])
      rotate([90, 0, 0])
      difference()
      {
        translate([-x/2, +eps*2, -wth/2-eps*2])
        cube([w+x, d-eps*4, wth*3/2], center=false);
        extrude_linear_uss(wth, center=false)
        joint2d_dovetail(t=dt, d=d, w=w, center=true, type=2);
      }

      // female joint printed vertically
      translate([0, 0, +wth/2])
      difference()
      {
        translate([-x/2, +eps*2, -wth/2-eps*2])
        cube([w+x, d-eps*4, wth*3/2], center=false);
        extrude_linear_uss(wth, center=false)
        joint2d_dovetail(t=dt, d=d, w=w, center=true, type=2);
      }

      // male joint
      translate([0, -d*2, 0])
      union()
      {
        extrude_linear_uss(wth, center=false)
        joint2d_dovetail(t=dt, d=d, w=w, center=true, type=0);
        translate([-x/2, -d, 0])
        cube([w+x, d, wth], center=false);
      }
    }
  }

  //
  // merge post instances
  //
  function merge_post_inst_sets
  (
    post_configuration,
    local_instance_sets,
    global_type_append,
    global_instance_sets
  ) =
    [
      post_configuration,

      [ // copy local instances unchanged
        for (set = local_instance_sets)
          for (instance = set)
            instance,

        // update type for global instances
        for (set = global_instance_sets)
          for (instance = set)
          let
          (
            type = first(instance),
            inst = tailn(instance)
          )
          concat(type + global_type_append, inst)
      ]
    ];

  //
  // module global variables
  //

  // pci specification:
  pcie_spec                 = map_merge(pcie_form, pcie_base);

  pcie_h_connector_max      = map_get_value(pcie_spec, "h_connector_max");
  pcie_l_keya_2_bkto        = map_get_value(pcie_spec, "l_keya_2_bkto");
  pcie_w_bkt_width          = map_get_value(pcie_spec, "w_bkt_width");
  pcie_w_pcb_mth            = map_get_value(pcie_spec, "w_pcb_mth");
  pcie_h_rbpcbt_2_fngrb     = map_get_value(pcie_spec, "h_rbpcbt_2_fngrb");
  pcie_bkt_mth              = map_get_value(pcie_spec, "bkt_mth");
  pcie_h_card_max           = map_get_value(pcie_spec, "h_card_max");
  pcie_h_card_max_2_pciblck = map_get_value(pcie_spec, "h_card_max_2_pciblck");
  pcie_h_pciblck_2_bktb     = map_get_value(pcie_spec, "h_pciblck_2_bktb");
  pcie_h_bktb_2_bkttabb     = map_get_value(pcie_spec, "h_bktb_2_bkttabb");
  pcie_w_bkt_tab            = map_get_value(pcie_spec, "w_bkt_tab");
  pcie_h_bkt_tab            = map_get_value(pcie_spec, "h_bkt_tab");
  pcie_w_bkt_tabo           = map_get_value(pcie_spec, "w_bkt_tabo");
  pcie_wh_copen_window      = map_get_value(pcie_spec, "wh_copen_window");
  pcie_h_bktb_2_copen       = map_get_value(pcie_spec, "h_bktb_2_copen");
  pcie_w_pcb_2_copen        = map_get_value(pcie_spec, "w_pcb_2_copen");
  pcie_wl_mnt_tab           = map_get_value(pcie_spec, "wl_mnt_tab");
  pcie_w_mnt_tab_o          = map_get_value(pcie_spec, "w_mnt_tab_o");
  pcie_wl_mnt_hole_o        = map_get_value(pcie_spec, "wl_mnt_hole_o");

  // riser board:
  rb_pcb_th                 = map_get_value(riser_pcb, "pcb_th");

  // enclosure: common (base, sides, cover)
  encl_rounding             = map_get_value(enclosure, "rounding");
  encl_mode_rounding        = map_get_value(enclosure, "mode_rounding");
  encl_wth                  = map_get_value(enclosure, "wth");
  encl_ribs                 = map_get_value(enclosure, "ribs");
  encl_lips_sides           = map_get_value(enclosure, "lips_sides");
  encl_lips_base            = map_get_value(enclosure, "lips_base");
  encl_lips_cover           = map_get_value(enclosure, "lips_cover");
  encl_walls                = map_get_value(enclosure, "walls");
  encl_mode_proj_box        = map_get_value(enclosure, "mode_proj_box");
  encl_verb_proj_box        = map_get_value(enclosure, "verb_proj_box");

  // enclosure: posts (base, sides, cover)
  encl_posts_sides_conf     = map_get_value(enclosure, "posts_sides_conf");
  encl_posts_base_conf      = map_get_value(enclosure, "posts_base_conf");
  encl_posts_cover_conf     = map_get_value(enclosure, "posts_cover_conf");
  encl_posts_sides          = map_get_value(enclosure, "posts_sides");
  encl_posts_base           = map_get_value(enclosure, "posts_base");
  encl_posts_cover          = map_get_value(enclosure, "posts_cover");
  encl_posts                = map_get_value(enclosure, "posts");

  // rise board width
  riser_size0   = pcie_expansion_rb_size(riser_pcb, 0);
  riser_size    = pcie_expansion_rb_size(riser_pcb);
  riser_width   = first( riser_size );

  // enclosure internal size
  encl_size_wlh = pcie_expansion_size
                  (
                    pcie_base,
                    pcie_form,
                    riser_pcb,
                    enclosure,

                    riser_width,
                    false
                  );

  // riser boards and slot key offsets
  slot_keys_wlh = pcie_expansion_rbs_keys
                  (
                    pcie_base,
                    pcie_form,
                    riser_pcb,
                    enclosure,

                    riser_width,
                    encl_size_wlh,

                    true,
                    false,
                    false
                  );

  //
  // main: enclosure construction
  //

  if (verb > 0)
  {
    encl_size_int = encl_size_wlh;
    encl_size_ext = pcie_expansion_size
                    (
                      pcie_base,
                      pcie_form,
                      riser_pcb,
                      enclosure,

                      riser_width,
                      true
                    );

    echo(strl([parent_module(0), ".size.exterior: [w, l, h] = ", encl_size_ext]));
    echo(strl([parent_module(0), ".size.interior: [w, l, h] = ", encl_size_int]));
  }

  // mode: construction orientation configurations [rotate, translate]
  rt_base_sides_cover =
    let
    (
      nop = [0, 0, 0],
      t   = encl_wth,
      w   = first(encl_size_wlh),
      h   = third(encl_size_wlh),
      s   = t * 10,           // "explode-view" separation
      b   = t * 8,            // build plate separation
      e   = eps*2             // assembled view overlap
    )
    [ // [0=design, 1=print, 2=assembled, 3=exploded, 4=build-plate]
      [ // base
        [nop, nop],
        [nop, nop],
        [nop, [0, 0,   -t-h/2+e]],
        [nop, [0, 0, -s-t-h/2]],
        [nop, [-b-w, 0, 0]]
      ],
      [ // sides
        [nop, nop],
        [nop, [0, 0, t]],
        [nop, [0, 0, t-h/2]],
        [nop, [0, 0, t-h/2]],
        [nop, [0, 0, t]],
      ],
      [ // cover
        [nop, nop],
        [[0, 180, 0], nop],
        [nop, [0, 0,   +t*2+h/2]],
        [nop, [0, 0, +s+t*2+h/2]],
        [[0, 180, 0], [b+w, 0, 0]]
      ]
    ];

  rt_base  = select_ci( first(rt_base_sides_cover), mode, false);
  rt_sides = select_ci(second(rt_base_sides_cover), mode, false);
  rt_cover = select_ci( third(rt_base_sides_cover), mode, false);

  // part construction control
  module construct_ctrl( bit, rt )
  {
    if ( binary_bit_is(part, bit, 1) )
    color(defined_e_or(part_color, bit, undef))
    translate(second(rt))
    rotate(first(rt))
    children();
  }

  // base
  construct_ctrl( 0, rt_base )
  enclosure_base();

  // sides with in-place bracket mount tab shelf
  construct_ctrl( 1, rt_sides )
  enclosure_sides(1+2+4+8);

  // cover
  construct_ctrl( 2, rt_cover )
  enclosure_cover();

  // sides with female dovetails for use with separate shelf
  construct_ctrl( 3, rt_sides )
  enclosure_sides(1+2+4+16);

  // separate bracket mount tab shelf with male dovetails
  construct_ctrl( 4, rt_sides )
  enclosure_sides(32);

  // dovetail joint test assembly
  construct_ctrl( 5, [zero3d, origin3d] )
  dovetail_test(0);

  // dovetail joint test build plate
  construct_ctrl( 6, [zero3d, origin3d] )
  dovetail_test(1);
}

//! @}

//! @}
//! @}


//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE example;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <shapes/select_common_2d.scad>;
    include <shapes/select_common_3d.scad>;
    include <transforms/base_cs.scad>;
    include <transforms/layout.scad>;
    include <models/2d/joint/dovetail.scad>;
    include <parts/3d/fastener/clamps.scad>;
    include <parts/3d/enclosure/project_box_rectangle.scad>;
    include <parts/3d/computer/pcie_expansion.scad>;

    encl_conf =
    [
      ["board_count",         1],
      ["space_min_length",  238],
      ["mode_sides",          1]
    ];

    custom_encl = map_merge( encl_conf, enclosure_def );
    map_check( custom_encl );

    pcie_expansion( enclosure=custom_encl, verb=1 );

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "front right back diag";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

/*
BEGIN_SCOPE riser_PCE164P_NO3_VER_007;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <transforms/base_cs.scad>;
    include <parts/3d/fastener/clamps.scad>;
    include <parts/3d/enclosure/project_box_rectangle.scad>;
    include <parts/3d/computer/pcie_expansion.scad>;

    map = riser_PCE164P_NO3_VER_007;
    doc = riser_map_doc;

    table_write
    (
      r = map_to_table( [map, doc], sort=true ),
      c = [["key","key"], ["value","value"], ["description","description"]]
    );
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_term}.mfs;
    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;

BEGIN_SCOPE riser_AAAPCIE4HUB;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <transforms/base_cs.scad>;
    include <parts/3d/fastener/clamps.scad>;
    include <parts/3d/enclosure/project_box_rectangle.scad>;
    include <parts/3d/computer/pcie_expansion.scad>;

    map = riser_AAAPCIE4HUB;
    doc = riser_map_doc;

    table_write
    (
      r = map_to_table( [map, doc], sort=true ),
      c = [["key","key"], ["value","value"], ["description","description"]]
    );
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_term}.mfs;
    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;

BEGIN_SCOPE riser_SFF_8612_4X_to_PCI_E_16X;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <transforms/base_cs.scad>;
    include <parts/3d/fastener/clamps.scad>;
    include <parts/3d/enclosure/project_box_rectangle.scad>;
    include <parts/3d/computer/pcie_expansion.scad>;

    map = riser_SFF_8612_4X_to_PCI_E_16X;
    doc = riser_map_doc;

    table_write
    (
      r = map_to_table( [map, doc], sort=true ),
      c = [["key","key"], ["value","value"], ["description","description"]]
    );
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_term}.mfs;
    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

/*
BEGIN_SCOPE enclosure_def;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <transforms/base_cs.scad>;
    include <parts/3d/fastener/clamps.scad>;
    include <parts/3d/enclosure/project_box_rectangle.scad>;
    include <parts/3d/computer/pcie_expansion.scad>;

    map = enclosure_def;
    doc = enclosure_map_doc;

    table_write
    (
      r = map_to_table( [map, doc], sort=true ),
      c = [["key","key"], ["value","value"], ["description","description"]]
    );
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
