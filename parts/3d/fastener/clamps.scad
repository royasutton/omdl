//! Clamps, bushings, and grips for wires and hoses.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2025-2026

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

    \amu_define group_name  (Clamps)
    \amu_define group_brief (Clamps, bushings, and grips for wires and hoses.)

  \amu_include (include/amu/doxyg_init_pd_gds_ipg.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group and macros.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/doxyg_define_in_parent_open.amu)
  \amu_define includes_required_add
  (
    models/3d/fastener/screws.scad
  )
  \amu_include (include/amu/includes_required.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//! A clamp, bushing, and/or grip for wire, hose, and/or pipe wall penetrations.
/***************************************************************************//**
  \param  size    <decimal-list-2 | decimal> wire size; a list [w, h]
                  or a single decimal to set the wire diameter.

  \param  clamp   <datastruct | integer> screw clamp; structured data
                  or a single integer to set the clamp wall side {0|1}.

  \param  cone    <datastruct | integer> bushing cone; structured data
                  or a single integer to set the cone wall side {0|1}.

  \param  grip    <datastruct | integer> zip tie grip; structured data
                  or a single integer to set the grip wall side {0|1}.

  \param  wth     <decimal> wall thickness.

  \param  gap     <decimal> wire gap percentage.

  \param  mode    <integer> operation mode {0=hole, 1=part-a, 2=part-b,
                  3=parts-a and b}.

  \details

    Construct a clamp, cone bushing, and/or a grip as a stand alone
    part or as a wall penetration hole finish that can secure or
    provide strain relief for passing wires, pipes, hoses, etc. The
    penetration can be circular or rectangular dependent on the size
    specification.

    ## Multi-value and structured parameters

    ### clamp

    #### Data structure fields: clamp

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | integer-list-2 \| integer   | required    | wall side
      1 | decimal                     | h           | base height
      2 | datastruct \| decimal       | (see below) | screw bore
      3 | decimal                     | d*3         | clamp depth
      4 | decimal-list-2 \| decimal   | 15          | pinch bar size

    ##### clamp[0]: wall side

    The clamp can be placed on either side of the wall by assigning \b
    0 or \b 1. To place a clamp on both sides of the wall, assign the
    value list <b>[0, 1]</b>.

    ##### clamp[2]: screw bore

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | decimal           | max(size)/4       | \p d : bore diameter
      1 | decimal           | h                 | \p l : bore length
      2 | (see below)       | [d*2, d/3, d/3]   | \p h : screw head
      3 | (see below)       | \b undef          | \p n : screw nut
      4 | (see below)       | \b undef          | \p s : nut slot cutout

    See screw_bore() for documentation of the data types for the screw
    bore parameters \p h, \p n, and \p s.

    ##### clamp[4]: pinch bar size

    The pinch bar size, [h, w], is specified as a percentage of the
    penetration size height and the clamp depth. When a single decimal
    is specified, the height and width percentage are the same.

    ### cone

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | integer-list-2 \| integer | required  | wall side
      1 | decimal           | max(size)/2       | cone base width
      2 | decimal           | max(size)/3       | cone height
      3 | decimal           | 255               | extrude mode

    The extrusion mode controls which sections of the cone are rendered.
    For more information see the mode parameter for extrude_rotate_trl().

    ##### cone[0]: wall side

    The cone can be placed on either side of the wall by assigning \b 0
    or \b 1. To place a cone on both sides of the wall, assign the
    value list <b>[0, 1]</b>.

    ### grip

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | integer-list-2 \| integer | required  | wall side
      1 | decimal           | max(size)/2       | zip tie width
      2 | decimal           | max(size)/6       | zip tie height
      3 | decimal           | max(size)*3/7     | grip base width
      4 | decimal           | max(size)*3/2     | grip height
      5 | integer           | 4                 | cut count
      6 | decimal           | 4/5               | cut height fraction
      7 | decimal           | min(size)/5       | cut width
      8 | decimal           | 0                 | cut rotational offset

    ##### grip[0]: wall side

    The grip can be placed on either side of the wall by assigning \b 0
    or \b 1. To place a grip on both sides of the wall, assign the
    value list <b>[0, 1]</b>.

    \amu_define scope_id      (example_clamp)
    \amu_define title         (Clamp example)
    \amu_define image_views   (top back diag)
    \amu_define image_size    (sxga)

    \amu_include (include/amu/scope_diagrams_3d.amu)

    \amu_define scope_id      (example_cone)
    \amu_define title         (Cone example)
    \amu_define image_views   (top back diag)
    \amu_define image_size    (sxga)

    \amu_include (include/amu/scope_diagrams_3d.amu)

    \amu_define scope_id      (example_grip)
    \amu_define title         (Grip example)
    \amu_define image_views   (top back diag)
    \amu_define image_size    (sxga)

    \amu_include (include/amu/scope_diagrams_3d.amu)
*******************************************************************************/
module clamp_cg
(
  size = 1,

  clamp,
  cone,
  grip,

  wth = 0,
  gap = 10,

  mode
)
{
  //
  // hole
  //

  sw = defined_e_or(size, 0, size);
  sh = defined_e_or(size, 1, sw);

  ww = sw * (1 + gap/100);
  wh = sh * (1 + gap/100);

  wmax = max([ww, wh]);
  wmin = min([ww, wh]);

  // type; 0=circle, 1=rectangle
  wt = is_list(size) && (len(size) > 1) ? 1 : 0;

  wr = (wt == 0) ? ww/2 : wmin/4;
  wl = (wt == 0) ? undef : [ww-wr*2, wh-wr*2];

  //
  // removals
  //

  if (mode == 0)
  {
    // hole passage
    hull()
    extrude_rotate_trl(l=wl, r=wr)
    square([eps, wth+eps*8], center=true);
  }

  else

  //
  // additions
  //

  {
    // clamp
    if ( is_defined(clamp) )
    {
      s   = defined_e_or(clamp, 0, clamp);      // wall side

      bh  = defined_e_or(clamp, 1, wh);         // base height
      sb  = defined_e_or(clamp, 2, wmax/4);     // (1) screw bore

      // (1) screw bore: d, l, h, n, s
      //  * see screw_bore()
      sbd = defined_e_or(sb, 0, sb);
      sbl = defined_e_or(sb, 1, bh);
      sbh = defined_e_or(sb, 2, [sbd*2, sbd/3, sbd/3]);
      sbn = defined_e_or(sb, 3, undef);
      sbs = defined_e_or(sb, 4, undef);

      cd  = defined_e_or(clamp, 3, sbd*3);      // clamp depth
      pb  = defined_e_or(clamp, 4, 15);         // (2) pinch bar

      // (2) pinch bar: percentage of wire height and clamp depth [height, width]
      php = defined_e_or(pb, 0, pb);
      pwp = defined_e_or(pb, 1, php);

      pbh = php * wh / 100;                     // pinch bar height
      pbw = pwp * cd / 100;                     // pinch bar width

      wsw = ww/2 * (1+5/10);                    // saddle width
      ssw = cd;                                 // screw bore shoulder width

      // clamp base
      h_bp =
      [
        [0, -bh],
        [wsw + ssw, -bh],
        [wsw + ssw, -wh/2],
        [wsw, -wh/2],
        [wsw, 0],
      ];

      h_bvr  = [1, 1/2, 0, 1] * wmin/4;
      h_bvrm = [1,   1, 0, 1];

      bp = concat( [for (i=h_bp) i], [for (i=reverse(h_bp)) [-i.x, i.y]] );
      bvr = concat( [for (i=h_bvr) i], [for (i=reverse(h_bvr)) i] );
      bvrm = concat( [for (i=h_bvrm) i], [for (i=reverse(h_bvrm)) i] );

      bpr = polygon_round_eve_all_p(bp, bvr, bvrm);

      // clamp strap
      h_sp =
      [
        [0, -wh/2],
        [wsw + ssw, -wh/2],
        [wsw + ssw, wh/2],
        [wsw, wh/2],
        [wsw, wh],
      ];

      h_svr  = [1, 1/2, 1/2, 1] * wmin/4;
      h_svrm = [5, 1, 1, 1];

      sp = concat( [for (i=h_sp) i], [for (i=reverse(h_sp)) [-i.x, i.y]] );
      svr = concat( [for (i=h_svr) i], [for (i=reverse(h_svr)) i] );
      svrm = concat( [for (i=h_svrm) i], [for (i=reverse(h_svrm)) i] );

      spr = polygon_round_eve_all_p(sp, svr, svrm);

      for (s = is_list(s) ? s : [s])
      rotate([0, s * 180, 0])
      translate([0, 0, cd/2 + wth/2])
      union()
      {
        difference()
        {
          union()
          {
            // clamp strap
            if ( binary_bit_is(mode, 1, 1) )
            difference()
            {
              extrude_linear_mss( h=cd, center=true )
              polygon(spr);

              translate([0, wh*(gap/100), 0])
              scale([1+(gap/200), 1, 1+eps*4])
              extrude_linear_mss( h=cd, center=true )
              polygon(bpr);
            }

            // clamp base
            if ( binary_bit_is(mode, 0, 1) )
            extrude_linear_mss( h=cd, center=true )
            polygon(bpr);
          }

          // remove hole
          clamp_cg(size=size, wth=cd+eps*8, mode=0);

          // bore screws
          for (x = [-1, 1] )
          translate([x * (wsw + ssw/2), wh/2, 0])
          rotate([270, 0, 0])
          screw_bore(d=sbd, l=sbl +wh/2 + eps*8, h=sbh, n=sbn, s=sbs, a=1);
        }

        // add strap pinch bars
        if ( binary_bit_is(mode, 1, 1) )
        for (i = [-1, 1] )
        translate([0, +wh/2, i * (cd/2-pbw)])
        rotate([0, 90, 0])
        extrude_linear_mss( h=ww, center=true )
        rhombus( [pbw, pbh*2], center=true);

        // add base pinch bar
        if ( binary_bit_is(mode, 0, 1) )
        translate([0, -wh/2, 0])
        rotate([0, 90, 0])
        extrude_linear_mss( h=ww, center=true )
        rhombus( [pbw, pbh*2], center=true);
      }
    }

    // cone
    if ( is_defined(cone) )
    {
      s = defined_e_or(cone, 0, cone);
      w = defined_e_or(cone, 1, wmax/2);
      h = defined_e_or(cone, 2, wmax/3);
      m = defined_e_or(cone, 3, 255);

      p =
      [
        origin2d,
        [w, 0],
        [w/3, h],
        [0, h]
      ];

      vr  = [3, 1, 1, 0] * min([w, h])/4;
      vrm = [3, 1, 1, 0];

      pr = polygon_round_eve_all_p(p, vr, vrm);

      for (s = is_list(s) ? s : [s])
      rotate([0, s * 180, 0])
      translate([0, 0, wth/2])
      extrude_rotate_trl(l=wl, r=wr, m=m)
      polygon(pr);
    }

    // grip
    if ( is_defined(grip) )
    {
      s  = defined_e_or(grip, 0, grip);

      zw = defined_e_or(grip, 1, wmax/2);
      zh = defined_e_or(grip, 2, wmax/6);

      w  = defined_e_or(grip, 3, wmax*3/7);
      h  = defined_e_or(grip, 4, wmax*3/2);

      cn = defined_e_or(grip, 5, 4);
      cf = defined_e_or(grip, 6, 4/5);
      ct = defined_e_or(grip, 7, wmin/5);
      co = defined_e_or(grip, 8, 0);

      p =
      let
      (
        o = h-h/5,          // offset from top
        q = zh              // zip-tie grove slant
      )
      [
        origin2d,
        [w, 0],
        [w, o-zw-q],
        [w-zh, o-zw],
        [w-zh, o],
        [w, o+q],
        [w, h],
        [0, h],

        [0, o],             // tooth
        [-zh/4, o-zw/2],
        [0, o-zw]
      ];

      vr  = [3, 1, 0, 0, 1, 1, 1, 0] * min([w, h])/4;
      vrm = [3, 1, 0, 0, 1, 1, 1, 0];

      pr = polygon_round_eve_all_p(p, vr, vrm);

      for (s = is_list(s) ? s : [s])
      rotate([0, s * 180, 0])
      difference()
      {
        translate([0, 0, wth/2])
        extrude_rotate_trl(l=wl, r=wr)
        polygon(pr);

        cw = wmax/2 + w*2;
        ch = h*cf;

        repeat_radial(cn, ao=co)
        translate([cw/2, 0, wth/2 + h - ch/2])
        cube([cw, ct, ch + eps*4], center=true);
      }
    }
  }
}

//! A one piece zip tie clamp to secure wires or provide strain relief.
/***************************************************************************//**
  \param  size    <decimal-list-2 | decimal> wire size; a list [w, h]
                  or a single decimal for (w=h).

  \param  ztie    <decimal-list-2 | decimal> zip tie size; a list [zw, zh]
                  or a single decimal to set zw with (zh=zw/2).

  \param  clamp   <datastruct> clamp size; a list [cw, ch, cd, [pbs]],
                  the clamp width, height, depth, and pinch bar
                  specification (pbs).

  \param  tunnel  <datastruct> zip tie tunnel configuration; (see below).

  \param  vr      <datastruct> rounding radii for clamp, wire seat and
                  zip tie tunnel; (see below).

  \param  vrm     <datastruct> rounding mode for clamp, wire seat and
                  zip tie tunnel; (see below).

  \param  align   <integer-list-3> part alignment; [w, h, d].

  \param  mode    <integer> construction mode {0=removals, 1=additions}.

  \details

    Construct a one piece clamp that uses one or more zip ties to
    secure a wires hose, pipe, etc. The pinch bars and number of zip
    tie tunnels can be configured as described below. When the size of
    the clamp is not specified, default values will be assigned based
    on the wire size. Via the \p mode parameter, the tunnels can be
    constructed alone for object difference when integrating with other
    design components.

    When \p size is a single decimal, the wire seat is a half-circle,
    centered at the top edge of the clamp. When \p size is a
    decimal-list-2, the seat is a rectangle with the upper top edge
    aligned with the top edge of the clamp. The wire seat rounding
    parameters are used only for the latter case.

    ## Multi-value and structured parameters

    ### clamp

    #### Data structure fields: clamp

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | decimal                     |  w *2   | clamp width
      1 | decimal                     |  h *2   | clamp height
      2 | decimal                     | zw *2   | clamp depth
      3 | decimal-list-3 \| decimal   | zw /3   | pinch bar [pw, ph, po]

    ##### clamp[3]: pinch bar

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | decimal           | required          | bar width
      1 | decimal           | pw /3             | bar height
      2 | decimal           | zw *3/2           | bar center offset

    ### tunnel

    #### Data structure fields: tunnel

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | decimal                     | 1       | corner radius
      1 | decimal-list-n \| decimal   | 0       | list of center offsets
      2 | integer                     | 0       | tunnel mode
      3 | decimal-list-2              | [0, 0]  | radial adjustment [w, h]
      4 | decimal-list-2              | [0, 0]  | center offset [w, h]

    ###### tunnel[2]: tunnel mode

    Integer value is binary encoded.

      b | description
    ---:|:---------------------------------------
    0-1 | w-size select {0:inner, 1:middle, 2:outer}
    2-3 | h-size select {0:inner, 1:middle, 2:outer}
      4 | project tunnel to bottom of clamp for zip tie access

    ### vr

    #### Data structure fields: vr

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | decimal-list-4 \| decimal  | required | clamp rounding radii
      1 | decimal-list-4 \| decimal  | 0        | seat rounding radii
      2 | decimal-list-4 \| decimal  | 0        | tunnel rounding radii

    ### vrm

    #### Data structure fields: vrm

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | decimal-list-4 \| decimal | [1, 1, 4, 3] | clamp rounding radii
      1 | decimal-list-4 \| decimal | [4, 3, 1, 1] | seat rounding radii
      2 | decimal-list-4 \| decimal | 1            | tunnel rounding radii

    \amu_define scope_id      (example_clamp_zt_1p)
    \amu_define title         (Zip tie clamp example)
    \amu_define image_views   (top bottom right back diag)
    \amu_define image_size    (sxga)

    \amu_include (include/amu/scope_diagrams_3d.amu)
*******************************************************************************/
module clamp_zt_1p
(
  size = 1,
  ztie = 1,

  clamp,
  tunnel,

  vr,
  vrm,

  align,

  mode = 1
)
{
  //
  // remove section at bottom for access to tunnel
  //
  module open_tunnel_access()
  {
    children(0);

    if ( binary_bit_is(tm, 4, 1) )
    difference()
    {
      children(1);

      translate([0, +eps*2, 0])
      hull()
      children(0);
    }
  }

  // wire size
  od  = !is_list(size);                       // size one dimensional
  wx  = defined_e_or(size, 0, size);
  wy  = defined_e_or(size, 1, od ? wx/2 : wx);

  // zip tie
  zx  = defined_e_or(ztie, 0, ztie);
  zy  = defined_e_or(ztie, 1, zx/2);

  // clamp size
  sx  = defined_e_or(clamp, 0, wx*2);
  sy  = defined_e_or(clamp, 1, wy*2);
  sz  = defined_e_or(clamp, 2, zx*2);

  // wire pinch bar
  pb  = defined_e_or(clamp, 3, zx/3);

  // tunnel: [cr, inst, mode, wh-adjust, wh-offset]
  cr  = defined_e_or(tunnel, 0, 1);           // corner radius
  zi  = defined_e_or(tunnel, 1, 0);           // list of offset instances
  tm  = defined_e_or(tunnel, 2, 0);           // 5-bit integer tunnel mode
  ta  = defined_e_or(tunnel, 3, [0, 0]);      // tunnel wh-radial adjustment
  to  = defined_e_or(tunnel, 4, [0, 0]);      // tunnel wh-offset

  // rounding: [clamp, wire seat, zip tunnel]
  vr0 = defined_e_or(vr, 0, vr);
  vr1 = defined_e_or(vr, 1, 0);
  vr2 = defined_e_or(vr, 2, 0);

  // rounding modes: [clamp, wire seat, zip tunnel]
  vrm0  = defined_e_or(vrm, 0, [1, 1, 4, 3]);
  vrm1  = defined_e_or(vrm, 1, [4, 3, 1, 1]);
  vrm2  = defined_e_or(vrm, 2, 1);


  //
  // decode pinch bar configuration
  //

  pw  = defined_e_or(pb, 0, pb);
  ph  = defined_e_or(pb, 1, pw/3);
  po  = defined_e_or(pb, 2, zx*3/2);


  //
  // decode zip tie tunnel modes
  //

  // B0-1: x-size select
  ztx = select_ci( [ wx, (sx+wx/2)/2, sx ], binary_iw2i(tm, 0, 2), false );

  // B2-3: y-size select
  zty = select_ci ( [ sy, (sy+wy/2)/2, wy ], binary_iw2i(tm, 2, 2), false );

  // B2-3: y-offset select
  zto = select_ci ( [ 0, (sy-wy/2)/4, (sy-wy)/2 ], binary_iw2i(tm, 2, 2), false );

  // B4: project tunnel to bottom of clamp
  ztp = binary_bit_is(tm, 4, 1);


  // align construction
  translate
  (
    [
      select_ci( [ 0, +sx/2, 0, -sx/2 ], defined_e_or(align, 0, 0), false ),
      select_ci( [ 0, +sy/2, 0, -sy/2 ], defined_e_or(align, 1, 0), false ),
      select_ci( [ 0, +sz/2, 0, -sz/2 ], defined_e_or(align, 2, 0), false )
    ]
  )
  {
    //
    // construct clamp
    //

    // clamp with wire seat and tunnel removed
    difference()
    {
      // clamp body
      if ( binary_bit_is(mode, 0, 1) )
      extrude_linear_uss(sz, center=true)
      pg_rectangle
      (
        size = [sx, sy],
        vr = vr0,
        vrm = vrm0,
        center = true
      );

      // remove wire passage
      if ( binary_bit_is(mode, 0, 1) )
      extrude_linear_uss(sz + eps*4, center=true)
      if ( od )
      {
        translate([0, sy/2 + eps*2, 0])
        circle(d = wx);
      }
      else
      {
        translate([0, (sy-wy)/2 + eps*2, 0])
        pg_rectangle
        (
          size = [wx, wy],
          vr = vr1,
          vrm = vrm1,
          center = true
        );
      }

      // remove zip tie tunnel passage
      for (zio = zi)
      translate([0, zto, zio] + concat(to, 0))
      open_tunnel_access()
      {
        // child-0: tunnel
        extrude_rotate_trl
        (
          r = cr,
          l = [ztx, zty] - 2*[cr, cr] + [zy, zy] + ta
        )
        pg_rectangle
        (
          size = [zy, zx],
          vr = vr2,
          vrm = vrm2,
          center = true
        );

        // child-1: area under tunnel
        translate([0, -sy/2 + zty/4 - second(to)/2, 0])
        rotate([90, 0, 0])
        extrude_linear_uss(sy - zty/2 + second(to) + eps*4, center=true)
        pg_rectangle
        (
          size = [ztx + zy*2 + first(ta), zx],
          vr = vr2,
          vrm = 1,
          center = true
        );
      }
    }

    // add base pinch bar sets for tunnel instance (when > 0)
    if ( binary_bit_is(mode, 0, 1) && ( pw > 0 ) )
    for (zio = zi, i = [-1, 1])
    translate([0, sy/2 - wy, zio + i * po/2])
    rotate([0, 90, 0])
    extrude_linear_mss( h=wx, center=true )
    difference()
    {
      rhombus( [pw, ph*2], center=true);
      translate([0, -ph/2])
      square([pw, ph], center=true);
    }
  }
}

//! @}
//! @}


//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE example_clamp;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <models/3d/fastener/screws.scad>;
    include <parts/3d/fastener/clamps.scad>;

    $fn = 36;

    d = 7.00;

    head = undef;
    nut  = [3.5, 1.5, 0, 4, 45, 1.25];
    slot = [undef, -3];
    bore = [3, undef, head, nut, slot];

    clamp_cg(size=d, clamp=[0, undef, bore], mode=3);

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "top back diag";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;

BEGIN_SCOPE example_cone;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <models/3d/fastener/screws.scad>;
    include <parts/3d/fastener/clamps.scad>;

    $fn = 36;

    w = 2;
    d = 7.00;
    difference()
    {
      translate(-[d*2,d*2,w/2]) cube([d*4,d*4,w]);
      clamp_cg(size=d, wth=w, mode=0);
    }
    clamp_cg(size=d, cone=[[0, 1]], mode=1);

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "top back diag";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;

BEGIN_SCOPE example_grip;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <models/3d/fastener/screws.scad>;
    include <parts/3d/fastener/clamps.scad>;

    $fn = 36;

    w = 2;
    d = [7.00, 3.50];
    e = max(d);
    difference()
    {
      translate(-[e*2,e*2,w/2]) cube([e*4,e*4,w]);
      clamp_cg(size=d, wth=w, mode=0);
    }
    clamp_cg(size=d, grip=0, mode=1);

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "top back diag";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

/*
BEGIN_SCOPE example_clamp_zt_1p;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <parts/3d/fastener/clamps.scad>;

    d = [10, 4];
    z = 4;
    c = [20, 10, 30];
    t = [1, [-10, 0, +10], 5 + 16, [4, -2]];
    v = [4, 1, 1];

    rotate([90,0,0]) {
      clamp_zt_1p (size=d, ztie=z, clamp=c, tunnel=t, vr=v);
      color("white")
      clamp_zt_1p (size=d, ztie=z, clamp=c, tunnel=t, vr=v, mode=0);
    }

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "top bottom right back diag";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//

