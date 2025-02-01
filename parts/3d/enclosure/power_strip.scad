/*

  Single gang electrical device power strip generator

  References:
    * https://en.wikipedia.org/wiki/NEMA_connector

  TODO:
    * update library to adjust pinch bar by percentage

    * cover mount options:
      (1) device mount screws
          * no center holes in cover
          * two device mount holes in cover
      (2) cover center screw
          * lower mount post by screw height
          * add spacer behind cover to raise by post mount screw head height

    * support box mount tabs
    * support box back screw-hole slid mounts

    * support arbitrary exterior box holes
    * support arbitrary cover holes

  Requires:
    include <omdl/omdl-base.scad>;
    include <omdl/tools/operation_cs.scad>;
    include <omdl/models/3d/misc/omdl_logo.scad>;
    include <omdl/models/3d/fastener/screws.scad>;
    include <omdl/parts/3d/enclosure/clamps.scad>;
    include <omdl/parts/3d/enclosure/project_box_rectangle.scad>;

*/

// default box configuration map
power_strip_sg_default_box =
[
  ["wth",      2.0],                // box wall thickness
  ["roww",    50.0],                // receptacle row width
  ["dlts",  108.00],                // device length tab-to-tab space
  ["boxd",    20.5],                // box internal depth

  ["evrm",       2],                // box & cover rounding mode: {0|1|2}
  ["evr",      4.0],                // box & cover rounding radius

  ["lefb",       2],                // box lid edge finish: {0|1|2|3|4}
  ["lefc",       2],                // cover lid edge finish: {0|1|2|3|4}

  ["dlogo",   true],                // detail logo on box rear: {true|false}
  ["drimb",   true],                // detail rim on box rear: {true|false}
  ["drimc",   true],                // detail rim on cover top: {true|false}

  ["fins",                          // post fins: [number, angle, width, length]
    [3, 270, 3, 3/4] ],
  ["ribs",  [0, 1.75] ],            // (1) box ribs configuration
  ["wmode",    426],                // (1) box wall mode
  ["pmode",    138],                // (1) box post mode (b7=1 required)

  ["iscl",    15.0],                // input space: cord, switch, surge, etc
  ["oscl",       0],                // output space: wire-nuts, led, aux board, etc

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
  ["pwsn",  [5.75, 2.5]]            // (2) power cord clamp screw nut spec
];
  /*
      (1): see project_box_rectangle() in omdl for descriptions
      (2): see screw_bore() in omdl for descriptions
   */
map_check(power_strip_sg_default_box, false);

// default mount configuration map
power_strip_sg_default_mount =
[
  ["mss",   length(3+9/32, "in")],  // device mount screw separation
  ["rmsd",  length(   1/8, "in")],  // mount screw hole diameter
  ["rmsh",  length(  3/16, "in")],  // mount screw head height
  ["rmth",  length(  1/16, "in")]   // mount tab height
];
map_check(power_strip_sg_default_mount, false);

// default cover configuration map (fractional measurements)
power_strip_sg_default_cover =
[
  ["drpo",  length(1+1/2, "in")],   // receptacle offset
  ["rpd",   length(1+3/8, "in")],   // receptacle diameter
  ["rpfl",  length(1+5/32, "in")],  // receptacle flat-to-flat height (1/32" added)
  ["rcsd",                          // cover screw hole:
    [3.51, 6.50, 1.5, 1/2]]         // [diameter, head-diameter, head-height, tolerance]
];
map_check(power_strip_sg_default_cover, false);

// default cover configuration map (decimal measurements)
power_strip_sg_default_cover_dm =
[
  ["drpo",  length(1.532, "in")],   // receptacle offset
  ["rpd",   length(1.362, "in")],   // receptacle diameter
  ["rpfl",  length(1.134, "in")],   // receptacle flat-to-flat height
  ["rcsd",                          // cover screw hole:
    [3.51, 6.50, 1.5, 1/2]]         // [diameter, head-diameter, head-height, tolerance]
];
map_check(power_strip_sg_default_cover_dm, false);

//
// Single gang electrical device power strip generator.
//
module power_strip_sg
(
  cols = 1,
  rows = 1,

  mode = 7,
  verb = 0,

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
      rmsh    // lip height
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

    // tab mounts
    module mount_tabs()
    {
      // output tab x-y spacing
      // output screw bore size
    }

    // screw hole slot mounts
    module mount_screw_slot()
    {
      // output tab x-y spacing
      // output screw bore size
    }

    // base internal wall wire holes
    module internal_wire_passage()
    {
      dlts = map_get_value(cm_box, "dlts");
      roww = map_get_value(cm_box, "roww");
      iscl = map_get_value(cm_box, "iscl");
      oscl = map_get_value(cm_box, "oscl");
      iwpd = map_get_value(cm_box, "iwpd");
      iwps = map_get_value(cm_box, "iwps");

      // offset from wall by "wth"
      zr = (iw/2 - iwpd/2 - wth) * iwps;
      sr = roww;

      nc = (oscl>0) ? cols : cols-1;
      zc = -il/2 - wth + iscl;
      sc = dlts + wth;

      // offset from bottom by 'wth"
      zh = wth*2 + iwpd/2;

      // for echo row and wall instance
      for (i=[0:rows-1], j=[0 : nc])
      translate([zr - i*sr * iwps, zc + j*sc, zh])
      rotate([90, 0, 0])
      cylinder(d=iwpd, h = wth+eps*8, center=true);
    }

    //
    // local variables
    //

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
           iwdo = map_get_value(cm_box, "iwdo"),

          nc = (oscl>0) ? cols : cols-1,
          zc = -il/2 - wth + iscl,
          sc = dlts + wth
        )
      ( ! iwdo ) ? undef
      : [ // wall configuration:mode
          wmode,

          // wall instances
          [ for (j=[0 : nc]) [0, zc + j*sc] ]
        ];

    // base screw posts
    p = let
        (
           dlts = map_get_value(cm_box, "dlts"),
           roww = map_get_value(cm_box, "roww"),
           iscl = map_get_value(cm_box, "iscl"),
           fins = map_get_value(cm_box, "fins"),
          pmode = map_get_value(cm_box, "pmode"),

            mss = map_get_value(cm_mount, "mss"),
           rmsd = map_get_value(cm_mount, "rmsd"),
           rmth = map_get_value(cm_mount, "rmth"),

          u = undef,

          zr = -iw/2 + roww/2,
          sr = roww,

          zc = iscl + (dlts - mss)/2,
          sc = dlts + wth,
          dc = mss,

          h0 = [rmsd],
          p1 = [u, u, -rmth],
           f = fins
        )
      [ // post configuration:mode
        pmode,

        // post instances
        [
          for (i=[0:rows-1], j=[0:cols-1])
            [2, [u, 0], [zr + i*sr, zc + j*sc,      0], 180, h0, u, p1, f ],
          for (i=[0:rows-1], j=[0:cols-1])
            [2, [u, 0], [zr + i*sr, zc + j*sc + dc, 0], 000, h0, u, p1, f ]
        ]
      ];

    // lid edge finish
    lf = e( map_get_value(cm_box, "lefb") );

    //
    // instances
    //

    difference()
    {
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

      // internal wall wire passage holes
      internal_wire_passage();

      // power cord hole (wth*4 to remove obstructing ribs)
      translate([pwxo, -il/2-wth/2, pwzo]) rotate([90, 0, 0])
      clamp_cg(size=pwcd, wth=wth*4, mode=0);

      // screw hole slot mounts
      mount_screw_slot();

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

    // add tab mounts
    mount_tabs();
  }

  // power strip cover
  module enclosure_cover()
  {
    //
    // local modules
    //

    module cover_round_cut_duplex()
    {
      dlts = map_get_value(cm_box, "dlts");
      roww = map_get_value(cm_box, "roww");
      iscl = map_get_value(cm_box, "iscl");

      drpo = map_get_value(cm_cover, "drpo");
       rpd = map_get_value(cm_cover, "rpd");
      rpfl = map_get_value(cm_cover, "rpfl");
      rcsd = map_get_value(cm_cover, "rcsd");

      zr = iw/2 - roww/2;
      sr = roww;

      zc = -il/2 - wth + iscl + dlts/2;
      sc = dlts + wth;

      zh = 0;

      // for echo row and wall instance
      for (i=[0:rows-1], j=[0 : cols-1])
      translate([zr - i*sr, zc + j*sc, zh])
      union()
      {
        // cover screw
        mirror([0, 0, 1])
        screw_bore
        (
          d = first(rcsd),
          l = wth + eps*4,
          h = [second(rcsd), 0, third(rcsd)],
          t = [rcsd[3]],
          a = 1
        );

        // duplex receptacle thru-holes
        for (i=[-1, 1])
        translate([0, i * drpo/2, wth/2])
        difference()
        {
          cylinder(d=rpd, h=wth+eps*4, center=true);

          for (j=[-1, 1])
          translate([0, j * (rpd/2 + rpfl)/2, 0])
          cube([rpd, rpd/2, wth+eps*8], center=true);
        }
      }
    }

    //
    // local variables
    //

    // wall height must be >= lip height, with min of wth
    ih = max([ wth, second(l()) ]);

    // lid edge finish
    lf = e( map_get_value(cm_box, "lefc") );

    //
    // instances
    //

    difference()
    {
      project_box_rectangle
      (
         wth = wth,
         lid = lf,
           h = ih, size = [iw, il],
         vrm = evrm, vr = evr,

         lip = l(2),

        mode = 1,

        verb = verb
      );

      // duplex receptacle holes
      cover_round_cut_duplex();

      // detail: enclosure rim grove trim
      if ( map_get_value(cm_box, "drimc") )
      extrude_rotate_trl(r=evr, l=[iw-evr*2, il-evr*2])
      circle(d=wth/2);
    }
  }

  //
  // local variables
  //

  wth = map_get_value(cm_box, "wth");

  iw = let
       (
          roww = map_get_value(cm_box, "roww")
        )
      roww * rows;

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
  // instances
  //

  ps = wth*2;

  if ( binary_bit_is(mode, 0, 1) )
  translate([-(iw/2 + ps), 0, 0])
  enclosure_box();

  if ( binary_bit_is(mode, 1, 1) )
  translate([+(iw/2 + ps), -(il/2 + ps*4), 0])
  clamp_strap();

  if ( binary_bit_is(mode, 2, 1) )
  translate([+(iw/2 + ps), 0, 0])
  enclosure_cover();
}

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
