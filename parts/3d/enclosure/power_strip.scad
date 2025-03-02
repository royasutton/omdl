//! A power strip maker for electrical receptacles and/or devices.
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

    \amu_define group_name  (Power Strip Maker)
    \amu_define group_brief (Electrical receptacle power strip generator.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_define includes_required_add
  (
    tools/operation_cs.scad
    models/3d/misc/omdl_logo.scad
    models/3d/fastener/screws.scad
    parts/3d/enclosure/clamps.scad
    parts/3d/enclosure/mounts.scad
    parts/3d/enclosure/project_box_rectangle.scad
  )
  \amu_include (include/amu/includes_required.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// global configuration variables
//----------------------------------------------------------------------------//

//! \name Maps
//! @{

//! <map> A single gang electrical device box configuration.
/***************************************************************************//**
  \details

    The default electrical device box configuration map.

    \amu_define title (Default device box configuration map)
    \amu_define scope_id (default_box)
    \amu_define output_scad (false)
    \amu_define output_console (false)
    \amu_define notes_table (Map key description is available in source. See the map)

    \amu_include (include/amu/scope_table.amu)

  \hideinitializer
*******************************************************************************/
power_strip_sg_default_box =
[
  ["wth",      2.0],                // box wall thickness
  ["roww",    50.0],                // receptacle row width
  ["dlts",  108.00],                // device length tab-to-tab space
  ["boxd",    25.0],                // box internal depth

  ["evrm",       2],                // box & cover rounding mode: {0|1|2}
  ["evr",      4.0],                // box & cover rounding radius

  ["cdms",   false],                // cover uses device mount screws: {true|false}

  ["lefb",       2],                // box lid edge finish: {0|1|2|3|4}
  ["lefc",       2],                // cover lid edge finish: {0|1|2|3|4}

  ["dlogo",   true],                // detail logo on box rear: {true|false}
  ["drimb",   true],                // detail rim on box rear: {true|false}
  ["drimc",   true],                // detail rim on cover top: {true|false}

  ["fins",  [3, 270, 3, 3/4]],      // post fins: [number, angle, width, length]

  ["ribs",  [0, 1.75] ],            // (1) box ribs configuration
  ["wmode",    426],                // (1) box wall mode
  ["wiab",   undef],                // (1) box wall instance additions
  ["pmode",    138],                // (1) box post mode (b7=1 required)
  ["piab",   undef],                // (1) box post instance additions
  ["piac",   undef],                // (1) cover post instance additions

  ["mpc2b",   true],                // mirror cover post additions in box: {true|false}
  ["mphda",      0],                // mirrored post hole diameter adjustment

  ["iscl",    15.0],                // input space: cord, switch, surge, etc
  ["oscl",       0],                // output space: wire-nuts, led, aux board, etc
  ["lscl",       0],                // left-side extra space
  ["rscl",       0],                // right-side extra space

  ["iwdo",    true],                // internal wall divisions on: {true|false}
  ["iwpd",    10.0],                // internal wall wire pass diameter
  ["iwps",      +1],                // internal wall wire pass side: {+1|-1}

  ["pwco",  [0, 0]],                // power cord connections offset: [x, z]
  ["pwcd",       7],                // power cord dimensions: {d|[w,h]}
  ["pwcs",       0],                // power cord clamp side: {0|1}
  ["pwct",    10.5],                // power cord clamp tab width
  ["pwcp",   undef],                // power cord clamp pinch bar percentage: [h, w]

  ["pwsd",     3.5],                // power cord clamp screw diameter
  ["pwsh",  [6, 3.5]],              // (2) power cord clamp screw head spec
  ["pwsn",  [5.75, 2.5]],           // (2) power cord clamp screw nut spec

  ["mtab", [4, 25, 4]],             // (3) mount tab: [screw, brace, vrm, vr, wth, size]
  ["mtabs",  undef],                // mount tab instances: [[edge, zero, move], ...]

  ["mslot", [4, [1, 1, 4]]],        // (4) mount slot: [screw, cover, size, scale, wth]
  ["mslots", undef]                 // mount slot instances: [[move, rotate, align], ...]
];
  /*
      (1): see project_box_rectangle() in omdl for descriptions
      (2): see screw_bore() in omdl for descriptions
      (3): see mount_screw_tab() in omdl for descriptions
      (4): see mount_screw_slot() in omdl for descriptions
   */

//! <map> A single gang electrical device mount configuration.
/***************************************************************************//**
  \details

    The default electrical device mount configuration map.

    \amu_define title (Default device mount configuration map)
    \amu_define scope_id (default_mount)
    \amu_define output_scad (false)
    \amu_define output_console (false)
    \amu_define notes_table (Map key description is available in source. See the map)

    \amu_include (include/amu/scope_table.amu)

  \hideinitializer
*******************************************************************************/
power_strip_sg_default_mount =
[
  ["mss",   length(3+9/32, "in")],  // device mount screw separation
  ["rmsd",  length(   1/8, "in")],  // mount screw hole diameter
  ["rmsh",  length(  3/32, "in")],  // mount screw head height
  ["rshc",  length(  5/16, "in")],  // mount screw head clearance
  ["rmth",  length(  1/16, "in")]   // mount tab height
];

//! <map> A single gang duplex receptacle cover configuration.
/***************************************************************************//**
  \details

    The default electrical device cover configuration map.

    \amu_define title (Default device cover configuration map)
    \amu_define scope_id (default_cover)
    \amu_define output_scad (false)
    \amu_define output_console (false)
    \amu_define notes_table (Map key description is available in source. See the map)

    \amu_include (include/amu/scope_table.amu)

  \hideinitializer
*******************************************************************************/
power_strip_sg_default_cover =
[
  ["drpo",  length(1+1/2, "in")],   // receptacle offset
  ["rpd",   length(1+3/8, "in")],   // receptacle diameter
  ["rpfl",  length(1+5/32, "in")],  // receptacle flat-to-flat height (1/32" added)
  ["rcsd",                          // cover center hole screw:
    [3.51, 7.50, 2.5, 1/2]]         // [diameter, head-diameter, head-height, tolerance]
];

//! \cond DOXYGEN_SHOULD_SKIP_THIS
map_check(power_strip_sg_default_box, false);
map_check(power_strip_sg_default_mount, false);
map_check(power_strip_sg_default_cover, false);
//! \endcond

//! @}

//----------------------------------------------------------------------------//
// modules
//----------------------------------------------------------------------------//

//! A power strip generator for single gang electrical receptacles.
/***************************************************************************//**
  \param  cols      <integer> device column count.

  \param  rows      <integer> device row count.

  \param  mode      <integer> part mode.

  \param  verb      <integer> console output verbosity {0|1|2}.

  \param  cm_box    <map> box configuration map.

  \param  cm_mount  <map> device mount configuration map.

  \param  cm_cover  <map> cover configuration map.

  \details

    This module constructs a power strip grid of standard [NEMA]
    electrical power receptacles. The number of columns and rows in the
    power strip are configurable as well as most aspects of the power
    strip enclosure box, receptacle device mounts, and device cover.
    The default configuration of the enclosure box, device mount, and
    device cover are specified in global variable maps.

    ### part mode

    Integer value is binary encoded.

      b | description
    ---:|:---------------------------------------
      0 | generate enclosure box
      1 | generate clamp top
      2 | generate enclosure cover

    The default configuration maps can be completely replaced with a
    user supplied maps or may be partially updated as shown in the
    following example.

    \amu_define scope_id      (example)
    \amu_define title         (Custom power strip example)
    \amu_define image_views   (bottom front diag)
    \amu_define image_size    (sxga)
    \amu_define output_scad   (true)

    \amu_include (include/amu/scope_diagrams_3d.amu)

  [NEMA]: https://en.wikipedia.org/wiki/NEMA_connector
*******************************************************************************/
module power_strip_sg
(
  cols = 1,
  rows = 1,

  mode = 7,
  verb = 1,

  cm_box = power_strip_sg_default_box,
  cm_mount = power_strip_sg_default_mount,
  cm_cover = power_strip_sg_default_cover
)
{
  //
  // local modules and functions
  //

  // lid edge finish; s:{0|1|2|3|4}
  function e ( s = 0 )
    = let
      (
        bs = 2/100
      )
      (s == 1) ? [wth*1/3, [wth*2/3, [1, 1-bs]]]
    : (s == 2) ? [wth*1/3, [wth*2/3, [for (s=[0:1/32:1/8]) 1-pow(s,2)]]]
    : (s == 3) ? [[wth*4/5, [1, 1+bs]], [wth*1/5, 1+bs]]
    : (s == 4) ? [[wth*4/5, [for (s=[0:1/32:1/8]) 1+pow(s,2)]], [wth*1/5, 1+pow(1/8,2)]]
    :  wth;

  // enclosure lips; m:{1=box, 2=cover}
  function l ( m = 0 )
    = let
      (
        rmsh = map_get_value(cm_mount, "rmsh")
      )
    [
      m,      // lip mode
      rmsh*2  // lip height
    ];

  // power cord connection z-offset
  function pczo ( d = 0 )
    = let
      (
        zo = defined_e_or(map_get_value(cm_box, "pwco"), 1, 0)
      )
    wth + (is_list(d) ? second(d) : d) * 5/4 + zo;

  // power connection clamp strap
  module clamp_strap()
  {
    // box power cord connection
    pwcd = map_get_value(cm_box, "pwcd");
    pwsd = map_get_value(cm_box, "pwsd");
    pwsh = map_get_value(cm_box, "pwsh");
    pwsn = map_get_value(cm_box, "pwsn");
    pwct = map_get_value(cm_box, "pwct");
    pwcp = map_get_value(cm_box, "pwcp");

    pwzo = pczo( pwcd );

    translate([0, 0, pwct - eps*2])
    clamp_cg(size=pwcd, clamp=[1, pwzo, [pwsd,undef,pwsh,pwsn], pwct, pwcp], wth=0, mode=2);
  }

  // power strip base
  module enclosure_box()
  {
    //
    // local modules
    //

    // convert cover post instance additions for box (x and y dimensions only)
    //  mirror: type, x-align, x-move, and xy-rotate, add diameter adjustment
    function piac_to_piab(pia)
    = [
        for (i=pia)
        let
        (
          mphda = map_get_value(cm_box, "mphda"),

          t = i[0],
          a = i[1],   ax = a[0],  ay = a[1],
          m = i[2],   mx = m[0],  my = m[1],
          r = i[3],
         h0 = i[4],
         h1 = i[5],
          p = i[6],
          f = i[7]
        )
        [
          t == 0 ? 1 : 0,
          [is_undef(ax) ? undef : -ax, ay],
          [is_undef(m)  ? undef : -mx, my],
           is_undef(r)  ? undef : -r,
          [h0[0], h0[1], h0[2], mphda, h0[4], h0[5], h0[6]],
          h1, p, f
        ]
      ];

    // screw mount tabs
    module mount_tabs()
    {
      mtab = map_get_value(cm_box, "mtab");

      // configuration and defaults
      s   = defined_e_or(mtab, 0, undef);
      b   = defined_e_or(mtab, 1, undef);
      vrm = defined_e_or(mtab, 2, undef);
      vr  = defined_e_or(mtab, 3, undef);
      w   = defined_e_or(mtab, 4, wth*2);
      sz  = defined_e_or(mtab, 5, undef);

      //
      // instantiate
      //

      mtabs = map_get_value(cm_box, "mtabs");

      if ( is_defined( mtabs ) )
      for ( i = mtabs )
      {
        e = defined_e_or(i, 0, 0);  // edge: {0|1|2|3}
        z = defined_e_or(i, 1, 0);  // zero
        m = defined_e_or(i, 2, 0);  // move

        if ( e == 0 )
        { // top edge
          translate([limit(z,-1,+1)*iw/2 + m, il/2 + wth - eps*2, 0])
          rotate([0, 0, 0])
          mount_screw_tab(wth=w, screw=s, brace=b, size=sz, vr=vr, vrm=vrm);
        } else
        if ( e == 1 )
        { // right edge
          translate([iw/2 + wth - eps*2, limit(z,-1,+1)*il/2 + m, 0])
          rotate([0, 0, -90])
          mount_screw_tab(wth=w, screw=s, brace=b, size=sz, vr=vr, vrm=vrm);
        } else
        if ( e == 2 )
        { // bottom edge
          translate([limit(z,-1,+1)*iw/2 + m, -(il/2 + wth - eps*2), 0])
          rotate([0, 0, 180])
          mount_screw_tab(wth=w, screw=s, brace=b, size=sz, vr=vr, vrm=vrm);
        } else
        if ( e == 3 )
        { // left edge
          translate([-(iw/2 + wth - eps*2), limit(z,-1,+1)*il/2 + m, 0])
          rotate([0, 0, +90])
          mount_screw_tab(wth=w, screw=s, brace=b, size=sz, vr=vr, vrm=vrm);
        }
      }
    }

    // screw mount slots
    module mount_slots(m)
    {
      mslot = map_get_value(cm_box, "mslot");

      // configuration and defaults
      s = defined_e_or(mslot, 0, undef);
      c = defined_e_or(mslot, 1, undef);
      l = defined_e_or(mslot, 2, undef);
      f = defined_e_or(mslot, 3, undef);
      w = defined_e_or(mslot, 4, wth);

      //
      // instantiate
      //

      mslots = map_get_value(cm_box, "mslots");

      if ( is_defined( mslots ) )
      for ( i = mslots )
      {
        // instance
        t = defined_e_or(i, 0, origin3d);
        r = defined_e_or(i, 1, 0);
        a = defined_e_or(i, 2, 0);

        translate(t)
        rotate(r)
        mount_screw_slot(wth=w, screw=s, cover=c, size=l, align=a, mode=m, f=f);
      }
    }

    // base internal wall wire holes
    module internal_wire_passage()
    {
      dlts = map_get_value(cm_box, "dlts");
      roww = map_get_value(cm_box, "roww");
      iscl = map_get_value(cm_box, "iscl");
      oscl = map_get_value(cm_box, "oscl");
      lscl = map_get_value(cm_box, "lscl");
      rscl = map_get_value(cm_box, "rscl");
      iwpd = map_get_value(cm_box, "iwpd");
      iwps = map_get_value(cm_box, "iwps");

      // offset from wall by "wth"
      zr = let
           (
             z = iw/2 - iwpd/2 - wth,
             s = (iwps>0) ? 1 : -1,
             o = (iwps>0) ? rscl : -lscl
           )
           z * s - o;
      sr = roww;

      nc = (oscl>0) ? cols : cols-1;
      zc = -il/2 - wth + iscl;
      sc = dlts + wth;

      // offset from bottom by 'wth"
      zo = wth*2 + iwpd/2;

      // for echo row and wall instance
      for (i=[0:rows-1], j=[0 : nc])
      translate([zr - i*sr * iwps, zc + j*sc, zo])
      rotate([90, 0, 0])
      cylinder(d=iwpd, h = wth+eps*8, center=true);
    }

    //
    // local variables
    //

    cdms = map_get_value(cm_box, "cdms");

    // box power cord connection
    pwcd = map_get_value(cm_box, "pwcd");
    pwcs = map_get_value(cm_box, "pwcs");
    pwsd = map_get_value(cm_box, "pwsd");
    pwsh = map_get_value(cm_box, "pwsh");
    pwsn = map_get_value(cm_box, "pwsn");
    pwct = map_get_value(cm_box, "pwct");
    pwcp = map_get_value(cm_box, "pwcp");

    pwzo = pczo( pwcd );
    pwxo = defined_e_or(map_get_value(cm_box, "pwco"), 0, 0);

    ih = map_get_value(cm_box, "boxd");

    // base ribs
    r = map_get_value(cm_box, "ribs");

    // base walls
    w = let
        (
           dlts = map_get_value(cm_box, "dlts"),
           iscl = map_get_value(cm_box, "iscl"),
           oscl = map_get_value(cm_box, "oscl"),
          wmode = map_get_value(cm_box, "wmode"),
           wiab = map_get_value(cm_box, "wiab"),
           iwdo = map_get_value(cm_box, "iwdo"),

          nc = (oscl>0) ? cols : cols-1,
          zc = -il/2 - wth + iscl,
          sc = dlts + wth
        )
      ( !iwdo ) ? undef
      : [ // wall configuration:mode
          wmode,

          // wall instances
          [
            for (j=[0 : nc]) [0, zc + j*sc],

            // add custom instances
            if ( is_defined(wiab) ) for (i=wiab) i
          ]
        ];

    // base screw posts
    p = let
        (
           dlts = map_get_value(cm_box, "dlts"),
           roww = map_get_value(cm_box, "roww"),
           iscl = map_get_value(cm_box, "iscl"),
           lscl = map_get_value(cm_box, "lscl"),
           fins = map_get_value(cm_box, "fins"),
          pmode = map_get_value(cm_box, "pmode"),
           piab = map_get_value(cm_box, "piab"),
           piac = map_get_value(cm_box, "piac"),
          mpc2b = map_get_value(cm_box, "mpc2b"),

            mss = map_get_value(cm_mount, "mss"),
           rmsd = map_get_value(cm_mount, "rmsd"),
           rmsh = map_get_value(cm_mount, "rmsh"),
           rmth = map_get_value(cm_mount, "rmth"),

          u = undef,

          zr = -iw/2 + roww/2 + lscl,
          sr = roww,

          zc = iscl + (dlts - mss)/2,
          sc = dlts + wth,
          dc = mss,

          h0 = [rmsd],
          p1 = [u, u, u, u, -rmth -(cdms?0:rmsh)],
           f = fins
        )
      [ // post configuration:mode
        pmode,

        // post instances
        [
          for (i=[0:rows-1], j=[0:cols-1])
            [2, [0, -1], [zr + i*sr, zc + j*sc,      0], 180, h0, u, p1, f ],
          for (i=[0:rows-1], j=[0:cols-1])
            [2, [0, -1], [zr + i*sr, zc + j*sc + dc, 0], 000, h0, u, p1, f ],

          // add custom instances
          if ( is_defined(piab) ) for (i=piab) i,

          // mirror custom cover instances
          if ( is_defined(piac) && mpc2b ) for (i=piac_to_piab(piac)) i
        ]
      ];

    // lid edge finish
    lf = e( map_get_value(cm_box, "lefb") );

    //
    // instances
    //

    difference()
    {
      union()
      {
        // base enclosure
        project_box_rectangle
        (
           wth = wth,
           lid = lf,
             h = ih, size = [iw, il],
           vrm = evrm, vr = evr,

           lip = l(1),
           rib = r,

          wall = w,
          post = p,

          mode = 1,

          verb = verb
        );

        // screw mount slot cover
        mount_slots(0);
      }
      // internal wall wire passage holes
      internal_wire_passage();

      // power cord hole (wth*4 to remove obstructing ribs)
      translate([pwxo, -il/2-wth/2, pwzo]) rotate([90, 0, 0])
      clamp_cg(size=pwcd, wth=wth*4, mode=0);

      // screw mount slot (negative)
      mount_slots(1);

      // detail: logo
      if ( map_get_value(cm_box, "dlogo") )
      {
        logod = map_get_value(cm_box, "roww")/2;

        translate([0, logod - il/2, 0])
        mirror([0, 1, 0]) rotate([0, 0, 180])
        omdl_logo(d=logod, b=true, t=true, a=1, $fn=36);
      }

      // detail: enclosure rim grove trim
      if ( map_get_value(cm_box, "drimb") )
      extrude_rotate_trl(r=evr, l=[iw-evr*2, il-evr*2])
      circle(d=wth/2);
    }

    // add power cord clamp bottom
    translate([pwxo, -il/2-wth/2, pwzo]) rotate([90, 0, 0])
    clamp_cg(size=pwcd, clamp=[pwcs, pwzo, [pwsd,undef,pwsh,pwsn], pwct, pwcp], cone=pwcs+1, wth=wth, mode=1);

    // add mount tabs
    mount_tabs();

    // report power cord hole size
    if ( verb > 0 )
    {
      echo(str( parent_module(0), "(): power cord hole size = ", pwcd ));
    }
  }

  // power strip cover
  module enclosure_cover()
  {
    //
    // local modules
    //

    module cover_round_cut_duplex()
    {
      // for echo row and wall instance
      for (i=[0:rows-1], j=[0 : cols-1])
      translate([zr - i*sr, zc + j*sc, zo])
      union()
      {
        if ( cdms )
        { // device mount screw holes
          mss  = map_get_value(cm_mount, "mss");
          rmsd = map_get_value(cm_mount, "rmsd");

          for (i=[-1, 1])
          translate([0, i*mss/2, 0])
          screw_bore
          (
            d = rmsd,
            l = zh,
            f = 1+25/100,
            a = 0
          );
        }
        else
        { // cover center screw hole
          rcsd = map_get_value(cm_cover, "rcsd");
          rmsh = map_get_value(cm_mount, "rmsh");

          translate([0, 0, rmsh/2])
          mirror([0, 0, 1])
          screw_bore
          (
            d = first(rcsd),
            l = zh + rmsh + eps*4,
            h = [second(rcsd), 0, third(rcsd)],
            t = [rcsd[3]],
            a = 0
          );
        }

        // duplex receptacle thru-holes
        drpo = map_get_value(cm_cover, "drpo");
         rpd = map_get_value(cm_cover, "rpd");
        rpfl = map_get_value(cm_cover, "rpfl");

        extrude_linear_uss(zh, center=true)
        for (i=[-1, 1])
        translate([0, i * drpo/2])
        difference()
        {
          circle(d=rpd);

          for (j=[-1, 1])
          translate([0, j * (rpd/2 + rpfl)/2])
          square([rpd, rpd/2], center=true);
        }
      }
    }

    // add stabilizer pads when using cover center screw
    // (mount screws will be hidden under cover)
    module cover_stabilizers()
    {
      if ( !cdms )
      {
        // for echo row and wall instance
        for (i=[0:rows-1], j=[0 : cols-1])
        translate([zr - i*sr, zc + j*sc, zo])
        union()
        {
          mss  = map_get_value(cm_mount, "mss");
          rmsh = map_get_value(cm_mount, "rmsh");
          rshc = map_get_value(cm_mount, "rshc");

          translate([0, 0, zo])
          extrude_linear_uss(rmsh, center=false)
          union()
          {
            rectangle([4, 1]*rshc, vr=rshc/4, vrm=0, center=true);

            for (i=[-1, 1])
            translate([0, i * (mss+rshc)/2])
            rectangle_c
            (
              size = [4,1]*rshc,
              core = [5/4,1]*rshc,
              co = [0,1/3]*rshc * -i,
              vr = rshc/4,
              vrm = 0,
              center = true
            );
          }
        }
      }
    }

    //
    // local variables
    //

    // wall height must be >= lip height, with min of wth
    ih = max([ wth, second(l()) ]);

    // cover screw posts (add custom instances)
    p = let
        (
          pmode = map_get_value(cm_box, "pmode"),
           piac = map_get_value(cm_box, "piac")
        )
        is_undef(piac) ? undef
      : [pmode, [for (i=piac) i]];

    // lid edge finish
    lf = e( map_get_value(cm_box, "lefc") );

    dlts = map_get_value(cm_box, "dlts");
    roww = map_get_value(cm_box, "roww");
    iscl = map_get_value(cm_box, "iscl");
    lscl = map_get_value(cm_box, "lscl");
    cdms = map_get_value(cm_box, "cdms");

    zr = iw/2 - roww/2 - lscl;
    sr = roww;

    zc = -il/2 - wth + iscl + dlts/2;
    sc = dlts + wth;

    // calculate the total lid extrusion height
    zh = extrude_linear_mss_eht(lf) + eps*8;
    zo = zh/2 - eps*4;

    //
    // instances
    //

    difference()
    {
      // cover enclosure
      union()
      {
        project_box_rectangle
        (
           wth = wth,
           lid = lf,
             h = ih, size = [iw, il],
           vrm = evrm, vr = evr,

           lip = l(2),

          post = p,

          mode = 1,

          verb = verb
        );

        // add cover stabilizers
        cover_stabilizers();
      }

      // duplex receptacle holes
      cover_round_cut_duplex();

      // detail: enclosure rim grove trim
      if ( map_get_value(cm_box, "drimc") )
      extrude_rotate_trl(r=evr, l=[iw-evr*2, il-evr*2])
      circle(d=wth/2);
    }
  }

  // check configuration map
  module check_cm(name, mc, md)
  {
    for ( k = map_get_keys(mc) )
    if( !map_exists(md, k) )
    {
      log_warn
      (
        strl
        ([
          "bad entry in map [", name, "] = [", k, ",", map_get_value(mc, k), "]"
        ])
      );
    }
  }

  //
  // local variables
  //

  wth = map_get_value(cm_box, "wth");

  iw = let
       (
          roww = map_get_value(cm_box, "roww"),
          lscl = map_get_value(cm_box, "lscl"),
          rscl = map_get_value(cm_box, "rscl")
        )
      lscl + roww * rows + rscl;

  il = let
       (
         dlts = map_get_value(cm_box, "dlts"),
         iscl = map_get_value(cm_box, "iscl"),
         oscl = map_get_value(cm_box, "oscl")
       )
       iscl - wth * 3/2 + cols * (dlts + wth) + oscl;

  evrm = map_get_value(cm_box, "evrm");
  evr  = map_get_value(cm_box, "evr");

  //
  // report errors in configuration maps
  //

  if ( verb > 0 )
  {
    check_cm("cm_box", cm_box, power_strip_sg_default_box);
    check_cm("cm_mount", cm_mount, power_strip_sg_default_mount);
    check_cm("cm_cover", cm_cover, power_strip_sg_default_cover);
  }

  //
  // instances
  //

  ps = wth*10;

  if ( binary_bit_is(mode, 0, 1) )
  translate([-(iw/2 + ps), 0, 0])
  enclosure_box();

  if ( binary_bit_is(mode, 1, 1) )
  translate([+(iw/2 + ps), -(il/2 + ps), 0])
  clamp_strap();

  if ( binary_bit_is(mode, 2, 1) )
  translate([+(iw/2 + ps), 0, 0])
  enclosure_cover();
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
    include <models/3d/misc/omdl_logo.scad>;
    include <models/3d/fastener/screws.scad>;
    include <parts/3d/enclosure/clamps.scad>;
    include <parts/3d/enclosure/mounts.scad>;
    include <parts/3d/enclosure/project_box_rectangle.scad>;
    include <parts/3d/enclosure/power_strip.scad>;

    box_conf =
    [
      ["iscl",       15.0],
      ["oscl",       15.0],

      ["pwcd", [8.6, 3.6]],
      ["pwsh",        [6]],
      ["pwco",     [0, 2]],
      ["pwcp",         20],

      ["mtabs",     [[0]]]
    ];

    custom_box = map_merge(box_conf, power_strip_sg_default_box);
    map_check(custom_box);

    power_strip_sg(cm_box=custom_box);

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "bottom front diag";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

/*
BEGIN_SCOPE default_box;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <tools/operation_cs.scad>;
    include <models/3d/misc/omdl_logo.scad>;
    include <models/3d/fastener/screws.scad>;
    include <parts/3d/enclosure/clamps.scad>;
    include <parts/3d/enclosure/project_box_rectangle.scad>;
    include <parts/3d/enclosure/power_strip.scad>;

    map_write( power_strip_sg_default_box );
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_term}.mfs;
    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;

BEGIN_SCOPE default_mount;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <tools/operation_cs.scad>;
    include <models/3d/misc/omdl_logo.scad>;
    include <models/3d/fastener/screws.scad>;
    include <parts/3d/enclosure/clamps.scad>;
    include <parts/3d/enclosure/project_box_rectangle.scad>;
    include <parts/3d/enclosure/power_strip.scad>;

    map_write( power_strip_sg_default_mount );
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_term}.mfs;
    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;

BEGIN_SCOPE default_cover;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <tools/operation_cs.scad>;
    include <models/3d/misc/omdl_logo.scad>;
    include <models/3d/fastener/screws.scad>;
    include <parts/3d/enclosure/clamps.scad>;
    include <parts/3d/enclosure/project_box_rectangle.scad>;
    include <parts/3d/enclosure/power_strip.scad>;

    map_write( power_strip_sg_default_cover );
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
