//! Screws and screw bores.
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

    \amu_define group_name  (Screws)
    \amu_define group_brief (Screws and screw bores.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group and macros.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_include (include/amu/includes_required.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//! Flat and beveled-head screw bore with nut, nut slot, and bore tolerance.
/***************************************************************************//**
  \param  d   <decimal> bore diameter.

  \param  l   <decimal> bore length.

  \param  h   <decimal-list-5> screw head; a list [hs, hf, hb, hg, hr],
              the head size, flat-height, bevel-height, side geometry
              (flat side count), and rotation. The head size is
              measured flat-to-flat when \p hg is specified.

  \param  n   <decimal-list-5> screw nut; a list [ns, nh, no, ng, nr],
              the nut size, height, offset, side geometry (flat side
              count), and rotation. The nut size is measured
              flat-to-flat. The offset is measured from bottom of
              length to center of nut.

  \param  t   <decimal-list-2> bore tolerance; a list [tx, ty], the
              tolerance along the x and/or y axis.

  \param  s   <decimal-list-list-3> nut slot; a list of lists [sx, sy, sz],
              the list of slot sizes along the x, y, and/or z axis.
              Each of sx, sy, or sz can be a decimal list, such as
              [lower, upper], or a single decimal value, to cover [0,
              value].

  \param  f   <decimal> bore scale factor.

  \param  a   <integer> z-alignment index; one of eight preset alignments.

  \details

    Construct a bore for a screw hole, screw head, and/or screw nut.
    Both the screw head and screw nut are optional. A tolerance can be
    specified along the bore x and y axis. A nut slot cutout can be
    specified along the x, y, or z axis. The following example uses
    both tolerance and a nut slot along the y axis. For convenience,
    exact fastener dimensions can be specified along with the an
    appropriately selected scale factor \p f to slightly increase the
    bore for acceptable fastener fit.

    \amu_define scope_id      (example)
    \amu_define title         (Screw bore example)
    \amu_define image_views   (top front diag)
    \amu_define image_size    (sxga)

    \amu_include (include/amu/scope_diagrams_3d.amu)
*******************************************************************************/

module screw_bore
(
  d = 1,
  l = 1,

  h,
  n,

  t,
  s,

  f = 1,
  a = 0
)
{
  function cdc(s, n, m=0) = (m == 0) ? s * f : s * f / cos(180/n);

  // screw bore
  bd = cdc(d);

  // screw head
  hs = defined_e_or(h, 0, 0);
  hf = defined_e_or(h, 1, 0);
  hb = defined_e_or(h, 2, 0);
  hg = defined_e_or(h, 3, $fn);
  hr = defined_e_or(h, 4, 0);

  hd = is_undef(h[3]) ? cdc(hs) : cdc(hs, hg, 1);

  // nut
  ns = defined_e_or(n, 0, 0);
  nh = defined_e_or(n, 1, 0) * f;
  no = defined_e_or(n, 2, 0);
  ng = defined_e_or(n, 3, 6);
  nr = defined_e_or(n, 4, 0);

  nd = cdc(ns, ng, 1);

  // tolerance
  tx = defined_e_or(t, 0, 0);
  ty = defined_e_or(t, 1, 0);

  // slot
  sx = defined_e_or(s, 0, 0);
  sy = defined_e_or(s, 1, 0);
  sz = defined_e_or(s, 2, 0);

  az = [0, -l/2, -l/2+hf, -l/2+hf+hb, +l/2-nh-no, +l/2-nh/2-no, +l/2-no, l/2];

  translate([0, 0, select_ci(az, a, false)])
  union()
  {
    frtc = [0, 0, +l/2 - hf/2 + eps*4];
    brtc = [0, 0, +l/2 - hf - hb/2 + eps*4];
    nrtc = [0, 0, -l/2 + nh/2 + no - eps*4];

    if ( is_undef(t) && is_undef(s) )
    {
      // screw hole
      cylinder(d=bd, h=l, center=true);

      // head flat height
      translate(frtc)
      rotate([0, 0, hr])
      cylinder(d=hd, h=hf, center=true, $fn=hg);

      // head bevel height
      translate(brtc)
      rotate([0, 0, hr])
      cylinder(d1=bd, d2=cdc(hs), h=hb, center=true);

      // nut
      translate(nrtc)
      rotate([0, 0, nr])
      cylinder(d=nd, h=nh, center=true, $fn=ng);
    }
    else
    { // slower equivalent with support for tolerance and nut slot
      hull() for( v=[-1, 1], w=[-1, 1] )
      translate([tx/2*v, ty/2*w, 0])
      cylinder(d=bd, h=l, center=true);

      hull() for( v=[-1, 1], w=[-1, 1] )
      translate(frtc + [tx/2*v, ty/2*w, 0])
      rotate([0, 0, hr])
      cylinder(d=hd, h=hf, center=true, $fn=hg);

      hull() for( v=[-1, 1], w=[-1, 1] )
      translate(brtc + [tx/2*v, ty/2*w, 0])
      rotate([0, 0, hr])
      cylinder(d1=bd, d2=cdc(hs), h=hb, center=true);

      // start slot from origin
      ix = is_list(sx) ? sx : [0, sx];
      iy = is_list(sy) ? sy : [0, sy];
      iz = is_list(sz) ? sz : [0, sz];

      hull() for( v=[-1, 1], w=[-1, 1], x=ix, y=iy, z=iz )
      translate(nrtc + [tx/2*v + x, ty/2*w + y, z])
      rotate([0, 0, nr])
      cylinder(d=nd, h=nh, center=true, $fn=ng);
    }
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
    include <models/3d/fastener/screws.scad>;

    $fn = 36;

    // screw bore with tolerance and nut-slot from front to back
    %difference()
    {
      cube([10, 15, 18], center=true);
      screw_bore(2.75, 18+eps*8, h=[6,1,3], n=[6,2,30,3], t=[0,5], s=[0,[-6,6],0], f=1.15);
    }

    // show actual minimal space required
    screw_bore(2.75, 18, h=[6,1,3], n=[6,2,30,3]);

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "top front diag";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//

