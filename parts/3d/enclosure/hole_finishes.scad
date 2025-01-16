//! Hole finishes for walls, project boxes, and enclosures.
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

    \amu_define group_name  (Hole finishes)
    \amu_define group_brief (Hole finishes for walls, project boxes, and enclosures..)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group and macros.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_define includes_required_add
  (
    models/3d/fastener/screws.scad
  )
  \amu_include (include/amu/includes_required.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//! A rectangular box maker for project boxes, enclosures and housings.
/***************************************************************************//**
  \param  size
  \param  cone
  \param  grip
  \param  clamp
  \param  wth     <decimal> wall thickness.
  \param  gap
  \param  mode

  \details

*******************************************************************************/
module wire_clamp_cg
(
  size,     // size:              [w, h] | d

  cone,     // wall cone:    [s, w, h]; s={0,1,[0,1]}
  grip,     // zip tie cord grip: [s, zw, zh, w, h, cn, cf, ct, co]
  clamp,    // clamp:             [s,

  wth = 0,  // wall thickness
  gap = 10, // size gap percentage

  mode      // {0: hole, 1: add part-1, 2: add part-2 }
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

      sb  = defined_e_or(clamp, 1, wmax/4);     // (1) screw bore
      cd  = defined_e_or(clamp, 2, wmax*2/3);   // clamp depth
      bh  = defined_e_or(clamp, 3, wh);         // base height
      pb  = defined_e_or(clamp, 4, wh/10);      // (2) pinch bar

      // (1) screw bore: d, l, h, n, t, s, f
      //  * see screw_bore()
      sbd = defined_e_or(sb, 0, sb);
      sbl = defined_e_or(sb, 1, bh);
      sbh = defined_e_or(sb, 2, [sbd*2, sbd/3, sbd/3]);

      // (2) pinch bar: [height, width]
      pbh = defined_e_or(pb, 0, pb);
      pbw = defined_e_or(pb, 1, pbh);

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
          wire_clamp_cg(wth=cd+eps*8, mode=0, size=size);

          // bore screws
          for (x = [-1, 1] )
          translate([x * (wsw + ssw/2), wh/2, 0])
          rotate([270, 0, 0])
          screw_bore(d=sbd, l=sbl +wh/2 + eps*8, h=sbh, a=1);
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
      extrude_rotate_trl(l=wl, r=wr)
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

        repeat_radial(cn, o=co)
        translate([cw/2, 0, wth/2 + h - ch/2])
        cube([cw, ct, ch + eps*4], center=true);
      }
    }
  }
}

//! @}
//! @}


//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//

