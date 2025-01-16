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

//! Flat and beveled-head screw bore with hex nut slot cutout.
/***************************************************************************//**
  \param  d   <decimal> bore diameter.

  \param  l   <decimal> bore length.

  \param  h   <decimal-list-3> screw head; a list [hd, fh, bh], the head
              diameter, flat-height, and beveled-height.

  \param  n   <decimal-list-4> screw nut; a list [ns, nh, nr, no], the
              nut size, height. rotation, and offset. The nut
              size is measured flat-to-flat. The offset is measured from
              bottom of length to center of nut.

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
  hd = defined_e_or(h, 0, 0) * f;
  fh = defined_e_or(h, 1, 0);
  bh = defined_e_or(h, 2, 0);

  // hex nut size measured flat-to-flat
  ns = defined_e_or(n, 0, 0) * f / cos(30);
  nh = defined_e_or(n, 1, 0) * f;
  nr = defined_e_or(n, 2, 0);
  no = defined_e_or(n, 3, 0);

  tx = defined_e_or(t, 0, 0);
  ty = defined_e_or(t, 1, 0);

  sx = defined_e_or(s, 0, 0);
  sy = defined_e_or(s, 1, 0);
  sz = defined_e_or(s, 2, 0);

  az = [0, -l/2, -l/2+fh, -l/2+fh+bh, +l/2-nh-no, +l/2-nh/2-no, +l/2-no, l/2];

  translate([0, 0, select_ci(az, a, false)])
  union()
  {
    frtc = [0, 0, +l/2 - fh/2 + eps*4];
    brtc = [0, 0, +l/2 - fh - bh/2 + eps*4];
    nrtc = [0, 0, -l/2 + nh/2 + no - eps*4];

    if ( is_undef(t) && is_undef(s) )
    {
      // screw hole
      cylinder(d=d*f, h=l, center=true);

      // recessed flat-head
      translate(frtc)
      cylinder(d=hd, h=fh, center=true);

      // recessed bevel-head
      translate(brtc)
      cylinder(d1=d*f, d2=hd, h=bh, center=true);

      // hex nut
      translate(nrtc)
      rotate([0, 0, nr])
      cylinder(d=ns, h=nh, center=true, $fn=6);
    }
    else
    { // slower equivalent with support for tolerance and nut slot
      hull() for( v=[-1, 1], w=[-1, 1] )
      translate([tx/2*v, ty/2*w, 0])
      cylinder(d=d*f, h=l, center=true);

      hull() for( v=[-1, 1], w=[-1, 1] )
      translate(frtc + [tx/2*v, ty/2*w, 0])
      cylinder(d=hd, h=fh, center=true);

      hull() for( v=[-1, 1], w=[-1, 1] )
      translate(brtc + [tx/2*v, ty/2*w, 0])
      cylinder(d1=d*f, d2=hd, h=bh, center=true);

      // start slot from 0 for scalar argument
      ix = is_list(sx) ? sx : [0, sx];
      iy = is_list(sy) ? sy : [0, sy];
      iz = is_list(sz) ? sz : [0, sz];

      hull() for( v=[-1, 1], w=[-1, 1], x=ix, y=iy, z=iz )
      translate(nrtc + [tx/2*v + x, ty/2*w + y, z])
      rotate([0, 0, nr])
      cylinder(d=ns, h=nh, center=true, $fn=6);
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

