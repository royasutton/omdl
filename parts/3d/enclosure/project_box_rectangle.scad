//! A rectangular box maker for project boxes, enclosures and housings.
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

    \amu_define group_name  (Rectangular project box)
    \amu_define group_brief (Rectangular prism project box generator.)

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

//! A rectangular box maker for project boxes, enclosures and housings.
/***************************************************************************//**
  \param  wth   <decimal> wall thickness.

  \param  h     <datastruct | decimal> box extrusion height;
                structured data or a single decimal to set the box
                height (see detail below).

  \param  size  <decimal-list-2 | decimal> box base size; a list [x, y]
                or a single decimal for (x=y).

  \param  vr    <decimal-list-4 | decimal> wall corner rounding radius;
                a list [v1r, v2r, v3r, v4r] or a single decimal for
                (v1r=v2r=v3r=v4r).

  \param  vrm   <integer-list-4 | integer> wall corner rounding mode =
                {0:none, 1:round, 2:bevel}; a list [v1rm, v2rm, v3rm,
                v4rm] or a single decimal for (v1rm=v2rm=v3rm=v4rm).

  \param  inset <decimal-list-2 | decimal> wall-to-lid negative offset;
                a list [x, y] or a single decimal for (x=y).

  \param  lid   <datastruct | decimal> lid extrusion height;
                structured data or a single decimal to set the lid
                height (see detail below).

  \param  lip   <datastruct | integer> wall lip; structured data or a
                single integer to set the lip mode (see detail below).

  \param  rib   <datastruct | integer> wall ribs; structured data or a
                single integer to set the rib mode (see detail below).

  \param  wall  <datastruct> interior walls; structured data
                (see detail below).

  \param  post  <datastruct> posts; structured data
                (see detail below).

  \param  align <integer-list-3> box alignment; a list [x, y, z]
                (see detail below).

  \param  mode  <integer> mode of operation configuration
                (see detail below).

  \param  verb  <integer> console output verbosity
                {0=quiet, 1=info, 2=details}.

  \details

    Construct a rectangular enclosure for electronic and or other
    project boxes of the like. This module is structured to construct
    no more than one exterior top or bottom cover and four exterior
    walls for each invocation. Therefore, a minimum of two invocations
    are required to construct a complete enclosure with six side (top,
    walls, and bottom). Only the parameters \p wth and \p size are
    require. All others are optional.

    In a simple case, a box would consist of a (1) cover with attached
    walls and (2) a separate opposite cover to close the box. This
    would require exactly two invocations. More than two invocations
    can be used to construct boxes with multiple mid-sections and/or
    removable covers on one or both sides as shown in the following
    example.

    \amu_define scope_id      (example_multiple)
    \amu_define title         (Muilti-section project box example)
    \amu_define image_views   (front diag)
    \amu_define image_size    (sxga)

    \amu_include (include/amu/scope_diagrams_3d.amu)

    Notice that the middle sections omit the \p lid parameter to skip
    lid construction in this example. The edge rounding during shape
    construction is performed using the function polygon_round_eve_all_p().
    Refer to its documentation for more information on the rounding
    mode options and descriptions.

    ## Parameter defaults

    Default values are calculated for all parameters. In some cases,
    the defaults are calculated based on supplied user values. For
    example, screw post diameters are calculated based on the supplied
    screw size for the post instance. Whenever a configuration consists
    of a list of values, there is no requirement to supply values for
    the entire list. Generally speaking, the list may be terminated at
    the parameter of interest. The caveat is for parameters of interest
    that comes after those which are not of interest. In this case, the
    prior values may be assigned a custom value or may be assigned the
    value \b undef to use the calculated default as shown below.

    \code{.C}
    partial_config = [ 12.42, [1,2], [2,1], 0, [1,2], 31, [1,2,3], 0 ];
       full_config = [ undef, undef, undef, 2, undef, 31 ];
    \endcode

    ## Multi-value and structured parameters

    ### h, lid

    The box wall height and box lid height are linear extrusions
    created using the function extrude_linear_mss(). This allows for
    flexible scaling along the extrusion as described in that functions
    description. The box bottom section example below shows how this
    scaling can be used to create features, such as corner rounding and
    face protrusion, along the lid and box height.

    ### lip

    The box walls can have a lip which interfaces with adjacent
    sections. The adjacent section should constructed with an opposite
    overhang.

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | integer           | required          | mode
      1 | decimal           | wth/2             | height
      2 | decimal           | 45                | base width percentage of wall
      3 | decimal           | 10                | top taper width percentage of wall
      4 | integer           | 0                 | alignment

    #### lip[0]: mode

    Value is a bit-encoded integer.

      b | description
    ---:|:---------------------------------------
      0 | upper and inside edge of wall
      1 | upper and outer edge of wall
      2 | lower and inside edge of wall
      3 | lower and outer edge of wall

    #### lip[4]: alignment

      v | description
    ---:|:---------------------------------------
      0 | maximum lips gap
      1 | minimum lips gap with backfield
      2 | minimum lips gap

    ### rib

    The exterior box wall and lid rigidity can be reinforced using a
    configurable grid of rib-like structures.

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | integer           | required          | mode
      1 | datastruct        | (see below)       | base and height extrusions
      2 | decimal-list-3    | 10                | [x, y, h] coverage percentage
      3 | integer-list-3    | (calculated)      | [x, y, h] grid count override

    #### rib[0]: mode

    Value is a bit-encoded integer.

      b | description
    ---:|:---------------------------------------
      0 | no ribs on lid
      1 | no ribs on wall x+
      2 | no ribs on wall y+
      3 | no ribs on wall x-
      4 | no ribs on wall y-
    5-6 | lip coverage count (2-bit encoded integer)
      7 | align ribs to bottom of lower lips

    #### rib[1]: base and height extrusion

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | decimal           | wth               | rib base width
      1 | decimal-list-2    | [[wth, rib_edx]]  | x-axis oriented rib height extrusion
      2 | decimal-list-2    | [[wth, rib_edy]]  | y-axis oriented rib height extrusion

    The constants \p rib_edx and \p rib_edy are defaults that
    approximates a half-ellipse rib shape. The extrusion is performed
    using the function extrude_linear_mss(). See its documentation for
    a description to defining values to replace these defaults.

    ### wall

    [ config, inst-list ]

    ### post

    [ config, inst-list ]

    ### align

    The x, y, and z axis of the box can be aligned independently.

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | integer           | 0                 | x-axis alignment
      1 | integer           | 0                 | y-axis alignment
      2 | integer           | 0                 | z-axis alignment

    #### align[0-1]: x/y axis alignment

      v | description
    ---:|:---------------------------------------
      0 | center
      1 | exterior enclosure negative x/y edge
      2 | interior enclosure negative x/y edge
      3 | interior enclosure positive x/y edge
      4 | exterior enclosure positive x/y edge

    #### align[2]: z-axis alignment

      v | description
    ---:|:---------------------------------------
      0 | bottom enclosure
      1 | bottom of wall
      2 | middle of enclosure
      3 | middle of wall
      4 | top of wall
      5 | top of enclosure

    ### mode

    Value is a bit-encoded integer.

      b | description
    ---:|:---------------------------------------
      0 | size is specified for enclosure interior
      1 | remove features outside of enclosure envelope
      2 | scale interior with exterior wall during extrusion

    \amu_define scope_id      (example_bottom)
    \amu_define title         (Project box bottom section example)
    \amu_define image_views   (top front right diag)
    \amu_define image_size    (sxga)
    \amu_define image_columns (4)

    \amu_include (include/amu/scope_diagrams_3d.amu)
*******************************************************************************/
module project_box_rectangle
(
  wth,
  h,
  size,

  vr,
  vrm,

  inset,

  lid,
  lip,
  rib,
  wall,
  post,

  align,
  mode = 0,
  verb = 0
)
{
  //
  //
  // helper modules and functions
  //
  //

  // exterior walls
  module construct_exterior_walls( envelop=false )
  {
    // re-scale total extrusion height of 'h' equally to 'wall_h'
    // and extrude scaled version 'hs' to maintain proper wall height
    hs  = !is_list(h) ?
          wall_h
        : let( sf=wall_h/h_h )
          [ for (e=h) !is_list(e) ? e * sf : [ first(e) * sf, second(e) ] ];

    if ( mode_scale_io == true )
    { // scale inner and outer wall together
      extrude_linear_mss(hs)
      difference_cs( envelop == false )
      {
        pg_rectangle(wall_xy + 0*[wth, wth], vr=vr, vrm=vrm_ci, center=true);
        pg_rectangle(wall_xy - 2*[wth, wth], vr=vr, vrm=vrm_ci, center=true);
      }
    }
    else
    { // scale outer wall only
      difference_cs( envelop == false )
      {
        extrude_linear_mss(hs)
        pg_rectangle(wall_xy + 0*[wth, wth], vr=vr, vrm=vrm_ci, center=true);

        translate([0, 0, -10*eps/2])
        extrude_linear_mss(wall_h + 10*eps)
        pg_rectangle(wall_xy - 2*[wth, wth], vr=vr, vrm=vrm_ci, center=true);
      }
    }

    if (verb > 0)
    {
      // generate list of all scale factors in extrusion [x, y]
      sf_x  = !is_list(h) ?
              1
            : let( sf = [ for (e=h) !is_list(e) ? 1 : [ for (f=second(e)) !is_list(f) ? f : first(f) ] ] )
              merge_s( sf );

      sf_y   = !is_list(h) ?
              1
            : let( sf = [ for (e=h) !is_list(e) ? 1 : [ for (f=second(e)) !is_list(f) ? f : second(f) ] ] )
              merge_s( sf );

      echo(strl(["wall: extrusion scale factors [x-min, x-max] = ", [min(sf_x), max(sf_x)]]));
      echo(strl(["wall: extrusion scale factors [y-min,y- max] = ", [min(sf_y), max(sf_y)]]));
      echo(strl(["wall: height (ignoring ribs) = ", wall_h]));
      echo(strl(["wall: total interior height (ignoring ribs) = ", wall_h + lip_h]));
    }
  }

  // wall lips
  module construct_lips( envelop=false )
  {
    // 'lip_h', bit '1', is set globally (ensure coherency with bits of 'lip')
    // wall lip: mode, height, base pct, taper pct, alignment
    lip_m         = defined_e_or(lip, 0, lip);
    lip_bw        = defined_e_or(lip, 2, 45);
    lip_tw        = defined_e_or(lip, 3, 10);
    lip_a         = defined_e_or(lip, 4, 0);

    // calculate lip bevel scaling factor
    //  scale control parameter is percentage of wall thickness
    sf = 2*wth / max(wall_xy) * lip_tw/100;

    // inner lip alignment method selection
    lip_ro = select_ci( [1,2,3], lip_a );

    translate( [0, 0, wall_h/2] )
    for
    (
      z =
      [ // [mode, r-offset, z-offset, hc]
        [3,      0, -1, [1 + sf, 1]],     // outer, lower
        [2, lip_ro, -1, [1 - sf, 1]],     // inner, lower
        [1,      0, +1, [1, 1 + sf]],     // outer, upper
        [0, lip_ro, +1, [1, 1 - sf]]      // inner, upper
      ]
    )
    {
      if ( binary_bit_is(lip_m, first(z), 1) == true )
      {
        hc  = z[3];
        ro  = second(z);

        // addition
        h1  = (ro == 0) ? [lip_h + 0 * eps]
            :             [lip_h + 0 * eps, hc];

        s1  = (ro == 0) ? wall_xy - 0 * [wth, wth] * lip_bw/100
            : (ro == 1) ? wall_xy - 2 * [wth, wth] * (1-lip_bw/100)
            : (ro == 2) ? wall_xy - 2 * [wth, wth] * lip_bw/100
            :             wall_xy - 2 * [wth, wth] * lip_bw/100;

        // removal
        h2  = (ro == 0) ? [lip_h + 10 * eps, hc]
            :             [lip_h + 10 * eps];

        s2  = (ro == 0) ? wall_xy - 2 * [wth, wth] * lip_bw/100
            : (ro == 1) ? wall_xy - 2 * [wth, wth]
            : (ro == 2) ? wall_xy - 2 * [wth, wth]
            :             wall_xy - 4 * [wth, wth] * lip_bw/100;

        translate([0, 0, (wall_h + lip_h - eps)/2 * third(z)])
        difference_cs( envelop == false )
        {
          extrude_linear_uss(h1, center=true)
          pg_rectangle(s1, vr=vr, vrm=vrm_ci, center=true);

          extrude_linear_uss(h2, center=true)
          pg_rectangle(s2, vr=vr, vrm=vrm_ci, center=true);
        }
      }
    }

    if (verb > 0)
    {
      echo(strl(["lip: mode = ", lip_m]));
      echo(strl(["lip: height = ", lip_h]));
      echo(strl(["lip: base width percentage = ", lip_bw]));
      echo(strl(["lip: top reduction percentage = ", lip_tw]));
      echo(strl(["lip: inner lip alignment index = ", lip_a]));
    }
  }

  // lid extrusion
  module construct_lid()
  {
    mirror([0, 0, 1])
    translate([0, 0, -eps])
    extrude_linear_mss(lid)
    pg_rectangle([encl_x, encl_y] + 0*[wth, wth], vr=vr, vrm=vrm_ci, center=true);

    if (verb > 0)
    {
      echo(strl(["lid: extrusion = ", lid]));
      echo(strl(["lid: height = ", lid_h]));
    }
  }

  // ribs
  module construct_ribs()
  {
    /*
      +----------------+
      | Data Structure |
      +----------------+

      ribs = [ mode, rib:[w, hx, hy], pct:[x, y, z], number:[x, y, z] ]

    */

    // mode
    rib_m   = defined_e_or(rib, 0, rib);

    // B5-6: wall limits (mode dependent)
    max_x   = first( wall_xy) - 2*(wth - eps);
    max_y   = second(wall_xy) - 2*(wth - eps);

    // 'max_h' may include 0 to 2 'lip_h' (ie: one at top and bottom)
    max_h   = wall_h + min(2, binary_iw2i(rib_m, 2, 5)) * lip_h;

    // B7: configurable global offset (to align with lower lip)
    rib_lo  = binary_bit_is(rib_m, 7, 1) ? [0, 0, -lip_h] : zero3d;

    // rib width and extrusion configuration
    rib_edx = [[1, 1], [9/10, 1], [8/10, 1], [6/10, 1], [2/10, 1]]; // defaults
    rib_edy = [for (e=rib_edx) reverse(e)];

    rib_sd  = defined_e_or(rib, 1, [ wth, [[wth, rib_edx]], [[wth, rib_edy]] ] );

    rib_w   = defined_e_or(rib_sd, 0, rib_sd);
    rib_hx  = defined_e_or(rib_sd, 1, [[rib_w, rib_edx]]);
    rib_hy  = defined_e_or(rib_sd, 2, [[rib_w, rib_edy]]);

    // rib coverage percentages
    rcp_d   = defined_e_or(rib, 2, 10);

    rcp_x   = defined_e_or(rcp_d, 0, rcp_d);
    rcp_y   = defined_e_or(rcp_d, 1, rcp_x);
    rcp_z   = defined_e_or(rcp_d, 2, rcp_y);

    // calculated rib counts based on coverage percentage
    crc_x   = max([0, floor(max_x/rib_w * rcp_x / 100)]);
    crc_y   = max([0, floor(max_y/rib_w * rcp_y / 100)]);
    crc_z   = max([0, floor(max_h/rib_w * rcp_z / 100)]);

    // rib count assignment
    cnt_d   = defined_e_or(rib, 3, [crc_x, crc_y, crc_z]);

    cnt_x   = defined_e_or(cnt_d, 0, cnt_d);
    cnt_y   = defined_e_or(cnt_d, 1, cnt_x);
    cnt_z   = defined_e_or(cnt_d, 2, cnt_y);

    //
    //
    // construct ribs
    //
    //

    translate(rib_lo)
    for
    (
      i =
      [ // [ B0-4: mode-bit, size:[x, y], count:[x, y], xform:[r, t] ]
        [ 0, [max_x, max_y], [cnt_x, cnt_y], [[0, 0, 0], [0, 0, 0]] ],
        [ 1, [max_y, max_h], [cnt_y, cnt_z], [[90, 0, -90], [max_x/2, 0, max_h/2]] ],
        [ 2, [max_x, max_h], [cnt_x, cnt_z], [[90, 0, 0], [0, max_y/2, max_h/2]] ],
        [ 3, [max_y, max_h], [cnt_y, cnt_z], [[90, 0, 90], [-max_x/2, 0, max_h/2]] ],
        [ 4, [max_x, max_h], [cnt_x, cnt_z], [[-90, 0, 0], [0, -max_y/2, max_h/2]] ],
      ]
    )
    {
      if ( binary_bit_is(rib_m, first(i), 0) == true )
      {
        si = second(i);   // size [x, y]
        ni = third(i);    // number [x, y]
        xi = i[3];        // transform [r, t]

        sx = first(si);
        sy = second(si);

        nx = first(ni);
        ny = second(ni);

        translate(second(xi))
        rotate(first(xi))
        union()
        {
          // ribs-x
          if (nx > 0)
          for (i = [0: nx-1])
          translate([(sx/nx*(1-nx)/2) + (sx/nx * i), 0, 0])
          extrude_linear_mss(rib_hx)
          square([rib_w, sy], center=true);

          // ribs-y
          if (ny > 0)
          for (i = [0: ny-1])
          translate([0, (sy/ny*(1-ny)/2) + (sy/ny * i), 0])
          extrude_linear_mss(rib_hy)
          square([sx, rib_w], center=true);
        }
      }
    }

    if (verb > 0)
    {
      // calculate rib heights
      rib_hxd = sum( [for (e=rib_hx) is_list(e) ? first(e) : e] );
      rib_hyd = sum( [for (e=rib_hy) is_list(e) ? first(e) : e] );

      // only when there are ribs on the lid (mode-bit '0' is for the lid)
      // can not be greater than max xy height less negative lower offset
      rib_rwh = wall_h + lip_h
              - max( 0, max([rib_hxd, rib_hyd]) + third(rib_lo) )
              * ( (binary_bit_is(rib_m, 0, 0) == true) ? 1 : 0 );

      echo(strl(["rib: mode = ", rib_m]));
      echo(strl(["rib: width = ", rib_w]));
      echo(strl(["rib: extrusion x = ", rib_hx]));
      echo(strl(["rib: height x = ", rib_hxd]));
      echo(strl(["rib: extrusion y = ", rib_hy]));
      echo(strl(["rib: height y = ", rib_hyd]));
      echo(strl(["rib: coverage [x, y, z] = ", [rcp_x, rcp_y, rcp_z]]));
      echo(strl(["rib: count [x, y, z] = ", [cnt_x, cnt_y, cnt_z]]));

      echo(strl(["rib: global offset = ", rib_lo]));
      echo(strl(["rib: remaining wall height = ", rib_rwh]));
    }
  }

  // interior walls
  module construct_interior_walls()
  {
    /*
      +----------------+
      | Data Structure |
      +----------------+

      wall = [ config, inst-list ]

      config = [ mode, defaults-list ]
      defaults-list = [ dw, he, vr, vrm ]

      inst-list = [ inst, inst, ..., inst ]

      inst = [ type, move:[x,y,z], scale:[x,y,z], rotate:[x,y,z], size:[x,y], he, vr, vrm ]
      type: { 0: horizontal, 1: vertical }
    */

    // wall
    config  = defined_e_or(wall, 0, wall);
    inst_l  = defined_e_or(wall, 1, empty_lst);

    // configuration
    wall_m  = defined_e_or(config, 0, config);
    defs_l  = defined_e_or(config, 1, empty_lst);

    // set a few values early for dependent defaults
    def_dw  = defined_e_or(defs_l, 0, wth);

    // B4-5: wall limits (mx, my, mz)
    max_x   = first( wall_xy) - 2*(wth - eps);
    max_y   = second(wall_xy) - 2*(wth - eps);

    // 'max_h' may include 0 to 2 'lip_h' (ie: one at top and bottom)
    max_h   = wall_h + min(2, binary_iw2i(wall_m, 2, 4)) * lip_h;

    // B6: global lower-lip offset
    wall_lo = binary_bit_is(wall_m, 6, 1) ? [0, 0, -lip_h] : zero3d;

    // B0-1: default wall end rounding
    cfg_vrm = let( i = binary_iw2i(wall_m, 2, 0) )
                (i == 1) ? [ 3,  4, 3,  4]                  // fillet
              : (i == 2) ? [ 9, 10, 9, 10]                  // bevel
              : (i == 3) ? [ 7,  8, 7,  8]                  // round
              :  0;                                         // none

    // top & base wall extrusion rounding factors (for horizontal wall)
    cfg_rt  = [ def_dw/2, [[1, 1], [1, 90/100], [1, 50/100]] ];
    cfg_rb  = [ def_dw/2, [[1, 1 + 25/100], [1, 1 + 7/100], [1, 1]] ];

    // B2-3: default wall extrusion rounding
    cfg_he = let( i = binary_iw2i(wall_m, 2, 2) )
                (i == 1) ? [max_h - def_dw/2, cfg_rt]       // top
              : (i == 2) ? [cfg_rb, max_h - def_dw/2]       // base
              : (i == 3) ? [cfg_rb, max_h - def_dw, cfg_rt] // top & base
              :  max_h;                                     // none

    // configured configuration defaults
    def_he  = defined_e_or(defs_l, 1, cfg_he);
    def_vr  = defined_e_or(defs_l, 2, def_dw);
    def_vrm = defined_e_or(defs_l, 3, cfg_vrm);

    //
    //
    // construct walls
    //
    //

    // process wall instance list
    translate(wall_lo)
    for (inst=inst_l)
    {
      inst_t    = defined_e_or(inst, 0, inst);        // type

      inst_m    = defined_e_or(inst, 1, zero3d);      // *move
      inst_f    = defined_e_or(inst, 2, [1, 1, 1]);   // scale
      inst_r    = defined_e_or(inst, 3, zero3d);      // rotate

      inst_s    = defined_e_or(inst, 4, undef);       // *size
      inst_he   = defined_e_or(inst, 5, undef);       // *he
      inst_vr   = defined_e_or(inst, 6, undef);       // *vr
      inst_vrm  = defined_e_or(inst, 7, undef);       // *vrm

      //
      // default value updates based on wall type: (0=horizontal, 1=vertical)
      //

      // move vector
      type_m    = is_list(inst_m) ?
                  inst_m
                : (inst_t == 0) ?
                    [0, inst_m]
                  : [inst_m, 0];

      // max length horizontal or vertical base shape
      tdef_s    = (inst_t == 0) ?
                  [max_x, def_dw]
                : [def_dw, max_y];

      // wall base extrusion (adjusted for vertical walls)
      tdef_he   = !is_list(def_he) ?
                  def_he                    // use specified scalar value
                : (inst_t == 0) ?
                    def_he                  // horizontal: use list as defined
                  : [ for (he=def_he)       // vertical: reverse [x, y] scale factors
                        !is_list(he) ?
                          he
                        : [ first(he), [ for (s=second(he)) reverse(s) ] ]
                    ];

      // wall-end rounding radii (adjusted for vertical walls)
      tdef_vr   = !is_list(def_vr) ?
                  def_vr
                : (inst_t == 0) ?
                    def_vr
                  : shift(def_vr, n=-1, r=false, c=true);

      // wall-end rounding modes (adjusted for vertical walls)
      tdef_vrm  = !is_list(def_vrm) ?
                  def_vrm
                : (inst_t == 0) ?
                    def_vrm
                  : shift(def_vrm, n=+1, r=false, c=true);

      //
      // assign defaults when not specified with wall instance
      //

      s   = defined_or(inst_s, tdef_s);
      he  = defined_or(inst_he, tdef_he);
      vr  = defined_or(inst_vr, tdef_vr);
      vrm = defined_or(inst_vrm, tdef_vrm);

      //
      // construct wall instance
      //

      translate(type_m)
      scale(inst_f)
      rotate(inst_r)
      extrude_linear_mss(he)
      pg_rectangle(s, vr=vr, vrm=vrm, center=true);

      if (verb > 1)
        echo(strl(["wall-inst: [type, move, scale, rotation, size, he, vr, vrm] = ",
                  [inst_t, inst_m, inst_f, inst_r, s, he, vr, vrm]]));
    }

    if (verb > 0)
    {
      // handle special case: a single horizontal or vertical wall
      wall_cnt = is_list(inst_l) ? len(inst_l) : 1;

      echo(strl(["wall: configuration = ", config]));
      echo(strl(["wall: mode = ", wall_m]));

      echo(strl(["wall: max [x, y, h] = ", [max_x, max_y, max_h]]));

      echo(strl(["wall: default width = ", def_dw]));
      echo(strl(["wall: default extrusion = ", def_he]));
      echo(strl(["wall: default edge rounding = ", def_vr]));
      echo(strl(["wall: default edge rounding mode = ", def_vrm]));

      echo(strl(["wall: count = ", wall_cnt]));

      echo(strl(["wall: global offset = ", wall_lo]));
    }
  }

  // posts and screw holes
  module construct_posts( add=false, remove=false )
  {
    /*
      +----------------+
      | Data Structure |
      +----------------+

      post = [ config, inst-list ]

      config = [ mode, defaults-list ]
      mode = [ b0:post-rnd, b1:fin-rnd, b2:h0-thru-lid, b3:lip_h-posts ]
      defaults-list = [ hole0, hole1, post1, hole2, post2, fins, hp-dd ]
      hole | post = [ d, h, ho, vr, vrm ]
      fins = [ c, da, w, d-sf, h-sf, vr, vrm ]
      hp-dd = [g-t0, g-t1, c-d, h1-dd, p1-dd, h2-dd, p2-dd ]

      inst-list = [ inst, inst, ..., inst ]
      inst = [  type:{0, 1}, align:[x,y,z], move:[x,y,z], rotate:[x,y,z],
                hole0, hole1, post, fins ]
      type: { 0: normal, 1: recessed }
    */

    // post
    config  = defined_e_or(post, 0, post);
    inst_l  = defined_e_or(post, 1, empty_lst);

    // configuration
    post_m  = defined_e_or(config, 0, config);
    defs_l  = defined_e_or(config, 1, empty_lst);

    max_x   = first( wall_xy) - 2*(wth - eps);
    max_y   = second(wall_xy) - 2*(wth - eps);
    max_h   = wall_h;

    // rounding configuration constants
    cfg_p_vrm_filet = [0, 1, 4, 0];
    cfg_p_vrm_bevel = [0, 5, 10, 0];
    cfg_p_vr_sf     = [0, 1/2, 3/2, 0];

    cfg_f_vrm_filet = [4, 0, 3];
    cfg_f_vrm_bevel = [10, 0, 9];
    cfg_f_vr_sf     = [2, 0, 1];

    // mode dependent configuration
    cfg_p_vrm       = binary_bit_is(post_m, 0, 1) ? cfg_p_vrm_bevel : cfg_p_vrm_filet;
    cfg_f_vrm       = binary_bit_is(post_m, 1, 1) ? cfg_f_vrm_bevel : cfg_f_vrm_filet;
    cfg_h0          = binary_bit_is(post_m, 2, 1) ? lid_h : 0;

    cfg_p1_lip_h    = binary_bit_is(post_m, 3, 1) ? lip_h : 0;  // maintain inverse
    cfg_p2_lip_h    = binary_bit_is(post_m, 3, 0) ? lip_h : 0;

    //
    // configured configuration defaults
    //

    def_h0      = defined_e_or(defs_l, 0, empty_lst);
    def_h1      = defined_e_or(defs_l, 1, empty_lst);
    def_p1      = defined_e_or(defs_l, 2, empty_lst);
    def_h2      = defined_e_or(defs_l, 3, empty_lst);
    def_p2      = defined_e_or(defs_l, 4, empty_lst);
    def_f       = defined_e_or(defs_l, 5, empty_lst);

    def_hp_dd   = defined_e_or(defs_l, 6, empty_lst);

    // late-bound diameters dependent hole size; relative to 'def_h0_d'

    // screw hole gaps: size augmentation for normal and recess holes
    def_h0_0_gd = defined_e_or(def_hp_dd, 0, 0);
    def_h0_1_gd = defined_e_or(def_hp_dd, 1, 0);

    // common addition to all posts and secondary holes
    def_hp_cd   = defined_e_or(def_hp_dd, 2, wth/2);

    def_h1_dd   = defined_e_or(def_hp_dd, 3, 0.0) * wth + def_hp_cd;
    def_p1_dd   = defined_e_or(def_hp_dd, 4, 3.0) * wth + def_hp_cd;
    def_h2_dd   = defined_e_or(def_hp_dd, 5, 2.0) * wth + def_hp_cd;
    def_p2_dd   = defined_e_or(def_hp_dd, 6, 4.0) * wth + def_hp_cd;

    // hole0: normal & recessed screw common hole
    def_h0_d    = defined_e_or(def_h0, 0, 3.25);
    def_h0_h    = defined_e_or(def_h0, 1, max_h + lip_h - wth*2);
    def_h0_ho   = defined_e_or(def_h0, 2, wth*2);
    def_h0_vr   = defined_e_or(def_h0, 3, 0);
    def_h0_vrm  = defined_e_or(def_h0, 4, 0);

    // hole1: normal thru lid hole
    //def_h1_d  = defined_e_or(def_h1, 0, def_h0_d + def_h1_dd);
    def_h1_h    = defined_e_or(def_h1, 1, cfg_h0);
    def_h1_ho   = defined_e_or(def_h1, 2, -cfg_h0);
    def_h1_vr   = defined_e_or(def_h1, 3, 0);
    def_h1_vrm  = defined_e_or(def_h1, 4, 0);
    // post1: normal mount post
    //def_p1_d  = defined_e_or(def_p1, 0, def_h0_d  + def_p1_dd);
    def_p1_h    = defined_e_or(def_p1, 1, max_h + cfg_p1_lip_h);
    def_p1_ho   = defined_e_or(def_p1, 2, 0);
    def_p1_vr   = defined_e_or(def_p1, 3, cfg_p_vr_sf * wth);
    def_p1_vrm  = defined_e_or(def_p1, 4, cfg_p_vrm);

    // hole2: recessed access hole thru lid
    //def_h2_d  = defined_e_or(def_h2, 0, def_h0_d  + def_h2_dd);
    def_h2_h    = defined_e_or(def_h2, 1, max_h + cfg_p2_lip_h + lid_h - wth*2);
    def_h2_ho   = defined_e_or(def_h2, 2, -lid_h);
    def_h2_vr   = defined_e_or(def_h2, 3, cfg_p_vr_sf * wth/2);
    def_h2_vrm  = defined_e_or(def_h2, 4, cfg_p_vrm);
    // post2: recessed access post
    //def_p2_d  = defined_e_or(def_p2, 0, def_h0_d  + def_p2_dd);
    def_p2_h    = defined_e_or(def_p2, 1, max_h + cfg_p2_lip_h);
    def_p2_ho   = defined_e_or(def_p2, 2, 0);
    def_p2_vr   = defined_e_or(def_p2, 3, cfg_p_vr_sf * wth);
    def_p2_vrm  = defined_e_or(def_p2, 4, cfg_p_vrm);

    // post fins
    def_f_c     = defined_e_or(def_f, 0, 4);
    def_f_da    = defined_e_or(def_f, 1, 360);
    def_f_w     = defined_e_or(def_f, 2, wth);
    def_f_d_sf  = defined_e_or(def_f, 3, 1/5);
    def_f_h_sf  = defined_e_or(def_f, 4, 5/8);
    def_f_vr    = defined_e_or(def_f, 5, cfg_f_vr_sf * wth);
    def_f_vrm   = defined_e_or(def_f, 6, cfg_f_vrm);

    //
    //
    // construct posts
    //
    //

    // construct a cylinder with optional fins
    module cylinder_fins
    (
      en,
      d, h, vr, vrm, ho,
      fc=0, fda, fw, fdsf=1, fhsf=1, fvr, fvrm,
      eps=0
    )
    {
      module post_fins(d, c, da, w, b, h, vr, vrm)
      {
        if (verb > 2)
          echo(strl(["post-inst-fins: [d, c, da, w, b, h, vr, vrm] = ",
                      [d, c, da, w, b, h, vr, vrm]]));

        for (i = [0:c-1])
        {
          rotate([90, 0, da/c * i + 180])
          translate([-d/2 - b, 0, 0])
          extrude_linear_mss(w, center=true)
          pg_triangle_sas([h, 90, b], vr=vr, vrm=vrm);
        }
      }

      if (en == true)
      {
        if (verb > 2)
          echo(strl(["post-inst-cylinder: [d, h, vr, vrm, ho, fc, eps] = ",
                      [d, h, vr, vrm, ho, fc, eps]]));

        translate([0, 0, ho - eps/2])
        {
          rotate_extrude()
          pg_rectangle([d/2, h + eps], vr=vr, vrm=vrm);

          if ( fc > 0 )
          {
            fb    = d * fdsf;
            fh    = h * fhsf;

            post_fins(d, fc, fda, fw, fb, fh, fvr, fvrm);
          }
        }
      }

    }

    // pre-processing message
    if (verb > 0)
    {
      post_cfm  = ( add == true  && remove == false ) ? "add"
                : ( add == false && remove == true  ) ? "remove"
                : ( add == true  && remove == true  ) ? "add & remove"
                : "do nothing";

      echo(strl(["post: construction phase = ", post_cfm]));
    }

    // process 'post' instance list
    for (inst=inst_l)
    {
      inst_t    = defined_e_or(inst, 0, inst);        // type {0, 1}
      inst_a    = defined_e_or(inst, 1, undef);       // align [x, y, z]
      inst_m    = defined_e_or(inst, 2, zero3d);      // move [x, y, z]
      inst_r    = defined_e_or(inst, 3, zero3d);      // rotate [x, y, z]

      inst_h0   = defined_e_or(inst, 4, undef);       // hole0
      inst_h1   = defined_e_or(inst, 5, undef);       // hole1
      inst_p    = defined_e_or(inst, 6, undef);       // post
      inst_f    = defined_e_or(inst, 7, undef);       // fins

      // alignment
      inst_ax   = defined_e_or(inst_a, 0, undef);
      inst_ay   = defined_e_or(inst_a, 1, undef);
      inst_az   = defined_e_or(inst_a, 2, 0);

      inst_zx   = is_undef( inst_ax ) ? 0
                : ( binary_bit_is(inst_ax, 0, 0) ? -1 : +1 ) * (max_x + wth)/2;

      inst_zy   = is_undef( inst_ay ) ? 0
                : ( binary_bit_is(inst_ay, 0, 0) ? -1 : +1 ) * (max_y + wth)/2;

      inst_zz   = ( binary_bit_is(inst_az, 0, 0) ? 0 : -lid_h );

      //
      // default value updates based on post type: (0=normal, 1=recessed)
      //

      // hole0:
      tdef_h0_gd  = (inst_t == 0) ? def_h0_0_gd : def_h0_1_gd;

      // hole1:
      tdef_h_dd   = (inst_t == 0) ? def_h1_dd : def_h2_dd;
      //tdef_h1_d = (inst_t == 0) ? def_h1_d : def_h2_d;
      tdef_h1_h   = (inst_t == 0) ? def_h1_h : def_h2_h;
      tdef_h1_ho  = (inst_t == 0) ? def_h1_ho : def_h2_ho;
      tdef_h1_vr  = (inst_t == 0) ? def_h1_vr : def_h2_vr;
      tdef_h1_vrm = (inst_t == 0) ? def_h1_vrm : def_h2_vrm;

      // post:
      tdef_p_dd   = (inst_t == 0) ? def_p1_dd : def_p2_dd;
      //tdef_p_d  = (inst_t == 0) ? def_p1_d : def_p2_d;
      tdef_p_h    = (inst_t == 0) ? def_p1_h : def_p2_h;
      tdef_p_ho   = (inst_t == 0) ? def_p1_ho : def_p2_ho;
      tdef_p_vr   = (inst_t == 0) ? def_p1_vr : def_p2_vr;
      tdef_p_vrm  = (inst_t == 0) ? def_p1_vrm : def_p2_vrm;

      //
      // assign defaults when not specified with post instance
      //

      // hole0: screw hole
      h0_en  = (remove == true);

      h0_d    = defined_e_or(inst_h0, 0, def_h0_d);
      h0_h    = defined_e_or(inst_h0, 1, def_h0_h);
      h0_ho   = defined_e_or(inst_h0, 2, def_h0_ho);
      h0_vr   = defined_e_or(inst_h0, 3, def_h0_vr);
      h0_vrm  = defined_e_or(inst_h0, 4, def_h0_vrm);

      h0_dwg  = h0_d + tdef_h0_gd;    // screw hole with gap

      // hole1: thru lid hole
      h1_en  = (remove == true);

      h1_d    = defined_e_or(inst_h1, 0, h0_d + tdef_h_dd);
      h1_h    = defined_e_or(inst_h1, 1, tdef_h1_h);
      h1_ho   = defined_e_or(inst_h1, 2, tdef_h1_ho);
      h1_vr   = defined_e_or(inst_h1, 3, tdef_h1_vr);
      h1_vrm  = defined_e_or(inst_h1, 4, tdef_h1_vrm);

      // post: post and fins
      p_en   = (add == true);

      p_d     = defined_e_or(inst_p, 0, h0_d + tdef_p_dd);
      p_h     = defined_e_or(inst_p, 0, tdef_p_h);
      p_ho    = defined_e_or(inst_p, 0, tdef_p_ho);
      p_vr    = defined_e_or(inst_p, 0, tdef_p_vr);
      p_vrm   = defined_e_or(inst_p, 0, tdef_p_vrm);

      f_c     = defined_e_or(inst_f, 0, def_f_c);
      f_da    = defined_e_or(inst_f, 1, def_f_da);
      f_w     = defined_e_or(inst_f, 2, def_f_w);
      f_d_sf  = defined_e_or(inst_f, 3, def_f_d_sf);
      f_h_sf  = defined_e_or(inst_f, 4, def_f_h_sf);
      f_vr    = defined_e_or(inst_f, 5, def_f_vr);
      f_vrm   = defined_e_or(inst_f, 6, def_f_vrm);

      //
      // construct post instance
      //

      translate(inst_m)                       // do separately to allow for 2d
      translate([inst_zx, inst_zy, inst_zz])  //  moves in 'inst_m' of form [x, y]
      rotate(inst_r)
      union()
      {
        cylinder_fins(p_en, p_d, p_h, p_vr, p_vrm, p_ho, f_c, f_da, f_w, f_d_sf, f_h_sf, f_vr, f_vrm);

        cylinder_fins(h0_en, h0_dwg, h0_h, h0_vr, h0_vrm, h0_ho, eps=10*eps);
        cylinder_fins(h1_en, h1_d,   h1_h, h1_vr, h1_vrm, h1_ho, eps=10*eps);
      }

      if (verb > 1)
        echo(strl(["post-inst: [type, align, move, rotation, hole0, hole1, post, fins] = ",
                  [inst_t, inst_a, inst_m, inst_r, inst_h0, inst_h1, inst_p, inst_f]]));
    }

    // post-processing message
    if (verb > 0)
    {
      // handle special case: a single post
      post_cnt  = is_list(inst_l) ? len(inst_l) : 1;

      echo(strl(["post: configuration = ", config]));
      echo(strl(["post: mode = ", post_m]));

      echo(strl(["post: count = ", post_cnt]));
    }
  }

  // limit child to wall interior volume
  module envelop_assembly( envelop=false )
  {
    if ( envelop == true )
    {
      intersection()
      {
        union()
        {
          construct_exterior_walls( true );
          construct_lips( true );
        }

        children();
      }
    }
    else
    {
      children();
    }
  }

  // assembly feature additions
  module assembly_add()
  {
    if ( wall_h > 0 )
    {
      construct_exterior_walls();
    }

    if ( is_defined( lip ) )
    {
      construct_lips();
    }

    if ( lid_h > 0 )
    {
      construct_lid();
    }

    //
    // better to apply envelop_assembly() to union of all?
    //

    if ( is_defined( rib ) )
    {
      envelop_assembly( mode_int_mask == true )
      construct_ribs();
    }

    if ( is_defined( wall ) )
    {
      envelop_assembly( mode_int_mask == true )
      construct_interior_walls();
    }

    if ( is_defined( post ) )
    {
      envelop_assembly( mode_int_mask == true )
      construct_posts( add=true);
    }
  }

  // assembly feature removals
  module assembly_remove()
  {
    if ( is_defined( post ) )
    {
      construct_posts( remove=true);
    }
  }

  //
  //
  // global parameter calculation
  //
  //

  // decode mode configurations
  mode_size_in  = binary_bit_is(mode, 0, 1);
  mode_int_mask = binary_bit_is(mode, 1, 1);
  mode_scale_io = binary_bit_is(mode, 2, 1);

  // specified wall extrusion height
  // calculate total extrusion 'h_h' height of all sections
  hv            = is_defined(h) ? [for (e=h) is_list(e) ? first(e) : e] : [0];
  h_h           = sum(hv);

  // specified base size
  size_x        = defined_e_or(size, 0, size);
  size_y        = defined_e_or(size, 1, size_x);

  // limit rounding mode to those options that make sense; set={0, 1, 5}
  // limit each element when 'vrm' is a list
  vrm_ci        = is_list(vrm) ?
                  [for (e=vrm) select_ci(v=[0, 1, 5], i=e, l=false)]
                : select_ci(v=[0, 1, 5], i=vrm, l=false);

  // wall lip default height (set to zero when there is no lip)
  // 'lip_h', bit '1', is set globally (ensure coherency with bits of 'lip')
  lip_hd        = is_defined(lip) ? wth/2 : 0;
  lip_h         = defined_e_or(lip, 1, lip_hd);

  // lid extrusion height (calculate total height of all sections)
  lid_hv        = is_defined(lid) ? [for (e=lid) is_list(e) ? first(e) : e] : [0];
  lid_h         = sum(lid_hv);

  // wall height
  wall_h        = (mode_size_in == true) ? h_h - lip_h : h_h - lip_h - lid_h;

  // wall x and y insets (usually negative, but allow positive)
  wall_od       = ( is_defined(inset) && is_scalar(inset) ) ? inset : 0;
  wall_ox       = defined_e_or(inset, 0, wall_od) * -1;
  wall_oy       = defined_e_or(inset, 1, wall_od) * -1;

  // exterior envelope of enclosure [encl_x, encl_y, encl_z]
  encl_x        = (mode_size_in == true) ? size_x + 2*wth - wall_ox : size_x;
  encl_y        = (mode_size_in == true) ? size_y + 2*wth - wall_oy : size_y;
  encl_z        = (mode_size_in == true) ? wall_h + lip_h + lid_h : h_h;

  // exterior size of wall x and y
  wall_xy       = [encl_x + wall_ox, encl_y + wall_oy];

  // interior size of enclosure
  szint_x = first (wall_xy) - 2*wth;
  szint_y = second(wall_xy) - 2*wth;
  szint_z = wall_h + lip_h;

  if (verb > 0)
  {
    echo(strl(["box: exterior dimensions [x, y, z] = ", [encl_x, encl_y, encl_z]]));
    echo(strl(["box: interior dimensions [x, y, z] = ", [szint_x, szint_y, szint_z]]));
  }

  //
  //
  //  box and feature construction
  //
  //

  align_x = select_ci ( [0, -encl_x, -szint_x, +szint_x, +encl_x ]/2,
                        defined_e_or(align, 0, 0), false );

  align_y = select_ci ( [0, -encl_y, -szint_y, +szint_y, +encl_y ]/2,
                        defined_e_or(align, 1, 0), false );

  align_z = select_ci ( [lid_h, 0, lid_h -encl_z/2, -wall_h/2, -wall_h, -wall_h -lip_h],
                        defined_e_or(align, 2, 0), false );

  translate([align_x, align_y, align_z])
  difference()
  {
    assembly_add();
    assembly_remove();
  }
}

//! @}
//! @}


//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE example_multiple;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <tools/operation_cs.scad>;
    include <parts/3d/enclosure/project_box_rectangle.scad>;

    wth = 2; h = 8; sx = 75; sy = 50; vr = 5; vrm = 2;

    translate([0,0,0])                              // bottom
    project_box_rectangle( wth=wth, h=h, size=[sx,sy], vr=vr, vrm=vrm, lip=1, lid=wth );

    for (z = [1,3]) translate([0,0, (h+4)*z])       // mid-sections
    project_box_rectangle( wth=wth, h=h, size=[sx,sy], vr=vr, vrm=vrm, lip=9 );

    translate([0,0,(h+4)*4 + h]) mirror([0,0,1])    // top
    project_box_rectangle( wth=wth, h=h, size=[sx,sy], vr=vr, vrm=vrm, lip=2, lid=wth );

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "front diag";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;

BEGIN_SCOPE example_bottom;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <tools/operation_cs.scad>;
    include <parts/3d/enclosure/project_box_rectangle.scad>;

    $fn = 18;

    wth = 1;

    lid_rounding = [for (s=[0:1/32:1/8]) 1-pow(s,2)/2];
    lid_profile  = [[wth/3, reverse(lid_rounding)], wth/3, [wth/3, lid_rounding]];

    // set default post support fin count to '0' and assign 'undef'
    //   to other parameters to  use their default values.
    function post(x, o) =
      [
        [0, [undef, undef, undef, undef, undef, [0]]],
        [
          [x, [0,0], [+1,+1]*o], [x, [0,1], [+1,-1]*o],
          [x, [1,0], [-1,+1]*o], [x, [1,1], [-1,-1]*o],
        ]
      ];

    project_box_rectangle
    (
      wth = wth,
      size = [100, 60],
      h = [[1, [1.05,1]], 7, [5, [1,.99,1]], 6, [6, [1,1.05,1]]],
      vr = 2,
      vrm = 1,

      inset = 5,

      lip = 1,
      lid = lid_profile,
      rib = 0,
      wall = [13, [[1, -11.5], [1, +11.5] ]],
      post = post(0, wth*3.25),

      mode = 1
    );

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "top front right diag";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//

