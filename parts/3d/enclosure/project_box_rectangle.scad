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
  \param  wth  <integer> wall thickness

  \details

    \amu_define title         (Project box bottom section example)
    \amu_define image_views   (top front right diag)
    \amu_define image_size    (sxga)
    \amu_define image_columns (4)

    \amu_include (include/amu/scope_diagrams_3d.amu)
*******************************************************************************/
module project_box_rectangle
(
  wth,      // wall thickness
  size,     // enclosed base size [x, y]
  h,        // enclosure height extrusion

  vr,       // wall corner rounding radius
  vrm,      // {0, 1, 2]} : wall corner rounding mode

  inset,    // wall inset [x, y]

  lip,      // lip = [ mode, height, base pct, taper pct, alignment ]
  lid,      // lid height extrusion, see: extrude_linear_mss()
  rib,      // ribs = [ mode, rib:[w, hx, hy], pct:[x, y, z], number:[x, y, z] ]
  wall,     // walls = [ config, inst-list ], config = [], inst-list = []
  post,     //

  mode = 0, // mode = [size-inside, int-mask, scale-both]
  align = 0,
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

    // B5: wall limits (mode dependent)
    max_x   = first( wall_xy) - 2*(wth - eps);
    max_y   = second(wall_xy) - 2*(wth - eps);
    max_z   = binary_bit_is(rib_m, 5, 1) ? (wall_h + lip_h) : wall_h;

    // B6: configurable global offset (to align with lower lip)
    rib_lo  = binary_bit_is(rib_m, 6, 1) ? [0, 0, -lip_h] : zero3d;

    // rib width and extrusion configuration
    rib_edx = [[1, 1], [9/10, 1], [8/10, 1], [6/10, 1], [2/10, 1]]; // defaults
    rib_edy = [for (e=rib_edx) reverse(e)];

    rib_sd  = defined_e_or(rib, 1,
      [
        wth*2,
        [[wth, rib_edx]],
        [[wth, rib_edy]]
      ]
    );

    rib_w   = defined_e_or(rib_sd, 0, rib_sd);
    rib_hx  = defined_e_or(rib_sd, 1, [[rib_w/2, rib_edx]]);
    rib_hy  = defined_e_or(rib_sd, 2, [[rib_w/2, rib_edy]]);

    // rib coverage percentages
    rcp_d   = defined_e_or(rib, 2, 20);

    rcp_x   = defined_e_or(rcp_d, 0, rcp_d);
    rcp_y   = defined_e_or(rcp_d, 1, rcp_x);
    rcp_z   = defined_e_or(rcp_d, 2, rcp_y);

    // calculated rib counts based on coverage percentage
    crc_x   = max([0, floor(max_x/rib_w * rcp_x / 100)]);
    crc_y   = max([0, floor(max_y/rib_w * rcp_y / 100)]);
    crc_z   = max([0, floor(max_z/rib_w * rcp_z / 100)]);

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
        [ 1, [max_y, max_z], [cnt_y, cnt_z], [[90, 0, -90], [max_x/2, 0, max_z/2]] ],
        [ 2, [max_x, max_z], [cnt_x, cnt_z], [[90, 0, 0], [0, max_y/2, max_z/2]] ],
        [ 3, [max_y, max_z], [cnt_y, cnt_z], [[90, 0, 90], [-max_x/2, 0, max_z/2]] ],
        [ 4, [max_x, max_z], [cnt_x, cnt_z], [[-90, 0, 0], [0, -max_y/2, max_z/2]] ],
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

    // 'max_z' may include 0 to 2 'lip_h' (ie: one at top and bottom)
    max_z   = wall_h + min(2, binary_iw2i(wall_m, 2, 4)) * lip_h;

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
                (i == 1) ? [max_z - def_dw/2, cfg_rt]       // top
              : (i == 2) ? [cfg_rb, max_z - def_dw/2]       // base
              : (i == 3) ? [cfg_rb, max_z - def_dw, cfg_rt] // top & base
              :  max_z;                                     // none

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

      // assign defaults when not specified with wall instance
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

      echo(strl(["wall: max [x, y, z] = ", [max_x, max_y, max_z]]));

      echo(strl(["wall: default width = ", def_dw]));
      echo(strl(["wall: default extrusion = ", def_he]));
      echo(strl(["wall: default edge rounding = ", def_vr]));
      echo(strl(["wall: default edge rounding mode = ", def_vrm]));

      echo(strl(["wall: count = ", wall_cnt]));

      echo(strl(["wall: global offset = ", wall_lo]));
    }
  }

  // posts
  module construct_posts()
  {
    /*
      +----------------+
      | Data Structure |
      +----------------+

      post = [ config, inst-list ]

      config = [ mode, defaults-list ]
      defaults-list = [ size:[p, h], he ]

      inst-list = [ inst, inst, ..., inst ]

      inst = [ type, move:[x,y,z], size:[p, h], he ]
      type: { 0: male, 1: female }
    */

  }

  // limit child to shape envelop
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

  //
  //
  // global parameter calculation
  //
  //

  // decode mode configurations
  mode_size_in  = binary_bit_is(mode, 0, 1);
  mode_int_mask = binary_bit_is(mode, 1, 1);
  mode_scale_io = binary_bit_is(mode, 2, 1);

  // specified base size
  size_x        = defined_e_or(size, 0, size);
  size_y        = defined_e_or(size, 1, size_x);

  // specified wall extrusion height
  // calculate total extrusion 'h_h' height of all sections
  hv            = is_defined(h) ? [for (e=h) is_list(e) ? first(e) : e] : [0];
  h_h           = sum(hv);

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
  encl_z        = (mode_size_in == true) ? wall_h + lip_h +lid_h : h_h;

  // exterior size of wall x and y
  wall_xy       = [encl_x + wall_ox, encl_y + wall_oy];

  if (verb > 0)
  {
    szint_x = first (wall_xy) - 2*wth;
    szint_y = second(wall_xy) - 2*wth;
    szint_z = wall_h + lip_h;

    echo(strl(["box: exterior dimensions [x, y, z] = ", [encl_x, encl_y, encl_z]]));
    echo(strl(["box: interior dimensions [x, y, z] = ", [szint_x, szint_y, szint_z]]));
  }

  //
  //
  //  box and feature construction
  //
  //

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
    construct_posts();
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
    include <parts/3d/enclosure/project_box_rectangle.scad>;

    wth = 2;

    lid_rounding = [for (s=[0:1/32:1/8]) 1-pow(s,2)/2];
    lid_profile  = [[wth/3, reverse(lid_rounding)], wth/3, [wth/3, lid_rounding]];

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
      wall = [13, [[1, -11.5], [1, +11.5] ]]
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

