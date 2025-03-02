//! Screws, bolts and fastener bores.
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

    \amu_define group_name  (Screws and Bolts)
    \amu_define group_brief (Screws, bolts and fastener bores.)

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

//! Flat and beveled-head fastener bore with nut, nut slot, and bore tolerance.
/***************************************************************************//**
  \param  d   <decimal> bore diameter.

  \param  l   <decimal> bore length.

  \param  h   <decimal-list-5> fastener head; a list [hs, hf, hb, hg,
              hr], the head size, flat-height, bevel-height, side
              geometry (flat side count), and rotation. The head size
              is measured flat-to-flat when \p hg is specified.

  \param  n   <decimal-list-5> fastener nut; a list [ns, nf, nb, ng, nr,
              no], the nut size, flat-height, bevel-height, side
              geometry (flat side count), rotation, and bottom offset.
              The nut size is measured flat-to-flat.

  \param  t   <decimal-list-2> bore tolerance; a list [tx, ty], the
              tolerance along the x and/or y axis.

  \param  s   <decimal-list-list-3> nut slot cutout; a list of lists
              [sx, sy, sz], the list of slot sizes along the x, y,
              and/or z axis. Each of sx, sy, or sz can be a decimal
              list, such as [lower, upper], or a single decimal value,
              to cover [0, value].

  \param  f   <decimal-list-2 | decimal> bore scale factor; a list [fd,
              fh], the bore diameter and bore height scale factors, or
              a single decimal to specify \p fd only. The default
              values for both are 1 (\p fh scales only the fastener
              head and nut heights).

  \param  a   <integer> z-alignment index; one of eight presets.

  \details

    Construct a bore for a fastener hole, fastener head, and/or
    fastener nut. Both the head and nut are optional. A tolerance can
    be specified along the bore x and y axis. A nut slot cutout can be
    specified along the x, y, or z axis. The following example uses
    both tolerance and a nut slot along the y axis. For convenience,
    exact fastener dimensions can be specified along with the an
    appropriately selected scale factor \p f to slightly increase the
    bore for acceptable fastener fit.

    \amu_define scope_id      (example_bore)
    \amu_define title         (Fastener bore examples)
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

  f,
  a
)
{
  function cdc(s, n, m=0) = (m == 0) ? s * fd : s * fd / cos(180/n);

  // diameter and height scale factors
  fd = defined_eon_or(f, 0, 1);
  fh = defined_e_or(f, 1, 1);

  // fastener bore
  bd = cdc(d);

  // fastener head
  hs = defined_e_or(h, 0, 0);
  hf = defined_e_or(h, 1, 0) * fh;
  hb = defined_e_or(h, 2, 0) * fh;
  hg = defined_e_or(h, 3, $fn);
  hr = defined_e_or(h, 4, 0);

  hd = is_undef(h[3]) ? cdc(hs) : cdc(hs, hg, 1);

  // nut
  ns = defined_e_or(n, 0, 0);
  nf = defined_e_or(n, 1, 0) * fh;
  nb = defined_e_or(n, 2, 0) * fh;
  ng = defined_e_or(n, 3, 6);
  nr = defined_e_or(n, 4, 0);
  no = defined_e_or(n, 5, 0);

  nd = cdc(ns, ng, 1);

  // tolerance
  tx = defined_e_or(t, 0, 0);
  ty = defined_e_or(t, 1, 0);

  // slot
  sx = defined_e_or(s, 0, 0);
  sy = defined_e_or(s, 1, 0);
  sz = defined_e_or(s, 2, 0);

  az =
  [
    0, -l/2, -l/2+hf/2, -l/2+hf, -l/2+hf+hb,
    +l/2-nb-nf-no, +l/2-nf-no, +l/2-nf/2-no, +l/2-no, +l/2
  ];

  //
  // construct
  //

  translate([0, 0, select_ci(az, a, false)])
  union()
  {
    hfo = [0, 0, +l/2 - hf/2 + eps*2];
    hbo = [0, 0, +l/2 - hf - hb/2 + eps*4];
    nbo = [0, 0, -l/2 + nf + nb/2 + no - eps*4];
    nfo = [0, 0, -l/2 + nf/2 + no - eps*2];

    if ( is_undef(t) && is_undef(s) )
    {
      // fastener hole
      cylinder(d=bd, h=l, center=true);

      // head flat height
      translate(hfo)
      rotate([0, 0, hr])
      cylinder(d=hd, h=hf, center=true, $fn=hg);

      // head bevel height
      translate(hbo)
      cylinder(d1=bd, d2=cdc(hs), h=hb, center=true);

      // nut bevel height
      translate(nbo)
      cylinder(d2=bd, d1=cdc(ns), h=nb, center=true);

      // nut flat height
      translate(nfo)
      rotate([0, 0, nr])
      cylinder(d=nd, h=nf, center=true, $fn=ng);
    }
    else
    { // slower equivalent with support for tolerance and nut slot
      hull() for( v=[-1, 1], w=[-1, 1] )
      translate([tx/2*v, ty/2*w, 0])
      cylinder(d=bd, h=l, center=true);

      hull() for( v=[-1, 1], w=[-1, 1] )
      translate(hfo + [tx/2*v, ty/2*w, 0])
      rotate([0, 0, hr])
      cylinder(d=hd, h=hf, center=true, $fn=hg);

      hull() for( v=[-1, 1], w=[-1, 1] )
      translate(hbo + [tx/2*v, ty/2*w, 0])
      cylinder(d1=bd, d2=cdc(hs), h=hb, center=true);

      // start slot from origin
      ix = is_list(sx) ? sx : [0, sx];
      iy = is_list(sy) ? sy : [0, sy];
      iz = is_list(sz) ? sz : [0, sz];

      hull() for( v=[-1, 1], w=[-1, 1], x=ix, y=iy, z=iz )
      translate(nbo + [tx/2*v + x, ty/2*w + y, z])
      cylinder(d2=bd, d1=cdc(ns), h=nb, center=true);

      hull() for( v=[-1, 1], w=[-1, 1], x=ix, y=iy, z=iz )
      translate(nfo + [tx/2*v + x, ty/2*w + y, z])
      rotate([0, 0, nr])
      cylinder(d=nd, h=nf, center=true, $fn=ng);
    }
  }
}

//! Gapped fastener bore with engagement cylinders for self-forming threads.
/***************************************************************************//**
  \param  d   <decimal> fastener diameter.

  \param  l   <decimal> bore length.

  \param  t   <datastruct> thread engagement (see below).

  \param  a   <integer> z-alignment index; one of five presets.

  \details

    Construct a fastener bore with a gap for chip expansion and radial
    cylinders that engage with the inserted fastener threads to
    self-form counter-threads along the cylinder lengths. The bore is
    enlarged by a configurable gap which facilitates thread formation
    with reduced stress accumulation to the bore internal dimensions.

    \note When 3D printing a bore horizontally, it is best practice to
          use 3 cylinders and orient one cylinder at the 6 o-clock
          position. This prevents the formation of cliffs which would
          otherwise require print support. Vertically printed bores can
          use increase cylinder count for increase holding strength at
          the cost of greater bore thread formation stress.

    ## Multi-value and structured parameters

    ### thread engagement

    #### Data structure fields: t

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | <decimal>         | 5                 | radial engagement percentage
      1 | <decimal>         | 5                 | radial gap percentage
      2 | <decimal>         | 0                 | rotational offset
      3 | <decimal>         | 0                 | radial offset
      4 | <integer>         | 3                 | cylinder count
      5 | <decimal-list-2 \| decimal> | [8/10, 10] | cylinder upper taper: [f, h%]
      6 | <decimal-list-2 \| decimal> | [   0, 10] | cylinder lower taper: [f, h%]

    #### Data structure fields: t[5-6]: cylinder upper and lower taper

      The diameter of the thread engagement cylinders can be configured
      to gradually change along the bore height from either the bottom,
      top, or both. The first element sets the cylinder diameter-scale
      factor and the second sets the length over which the scaling is
      performed. For \p f > 1, the cylinder diameter will increase in
      size, and for \p f < 1, the cylinder diameter will decrease in
      size.

    \amu_define scope_id      (example_bore_tsf)
    \amu_define title         (Screw bore example)
    \amu_define image_views   (top front diag)
    \amu_define image_size    (sxga)

    \amu_include (include/amu/scope_diagrams_3d.amu)
*******************************************************************************/
module screw_bore_tsf
(
  d = 1,
  l = 1,
  t,
  a
)
{
  e   = defined_e_or(t, 0, 5) * d/50;   // radial engagement percentage (r=d/2)
  g   = defined_e_or(t, 1, 5) * d/50;   // radial gap percentage
  r   = defined_e_or(t, 2, 0);          // rotational offset
  o   = defined_e_or(t, 3, 0);          // radial offset
  c   = defined_e_or(t, 4, 3);          // cylinder count
  n   = defined_e_or(t, 5, undef);      // upper taper
  m   = defined_e_or(t, 6, undef);      // lower taper

  // top taper: cylinder diameter-scale and scale-length percentage
  td  = defined_eon_or(n, 0, 8/10);
  tl  = defined_e_or  (n, 1, 10) * l/100;

  // bottom taper: cylinder diameter-scale and scale-length percentage
  bd  = defined_eon_or(m, 0, 0);
  bl  = defined_e_or  (m, 1, 10) * l/100;

  // bore diameter
  b   = d + g;

  // self-forming thread engagement cylinder diameter
  s   = e + g;

  // taper extrusion configuration
  nl  = let
        (
          tt = (td != 0 && tl > 0),
          tb = (bd != 0 && bl > 0),

          ml = (l - (tb ? bl : 0) - (tt ? tl : 0))
        )
        [
          if (tb) [bl, [bd, 1]],
          if (ml > 0) ml,
          if (tt) [tl, [1, td]]
        ];

  az  = [ 0, -l/2, -l/2+tl, +l/2-bl, +l/2 ];

  //
  // construct
  //

  translate([0, 0, select_ci(az, a, false)])
  difference()
  {
    // bore cylinder
    extrude_linear_mss(l, center=true)
    circle( d=b );

    // self-forming thread engagement cylinders
    for (i = [0:c-1])
    {
      rotate([0, 0, 360/c * i + r])
      translate([b/2 + o, 0, 0])
      extrude_linear_mss(nl, center=true)
      circle( d=s );
    }
  }
}

//! @}
//! @}


//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE example_bore;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <models/3d/fastener/screws.scad>;

    $fn = 36;

    // fastener bore with tolerance and nut-slot from front to back
    %difference()
    {
      cube([10, 15, 18], center=true);
      screw_bore(2.75, 18+eps*8, h=[6,1,3], n=[6,2,0,6,30,3], t=[0,5], s=[0,[-6,6],0], f=1.15);
    }

    // show actual minimal space required
    screw_bore(2.75, 18, h=[6,1,3], n=[6,2,0,6,30,3]);

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

BEGIN_SCOPE example_bore_tsf;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <models/3d/fastener/screws.scad>;

    $fn = 36;

    translate([+15, 0, 0])
    difference()
    {
      cube([15, 15, 20], center=true);
      screw_bore_tsf( d=10, l=20+eps*4);
    }

    %translate([-15, 0, 0])
    difference()
    {
      %cube([15, 15, 20], center=true);
      #%screw_bore_tsf( d=10, l=20+eps*8);
    }
    translate([-15, 0, 0])
    cylinder(d=10, h=30, center=true);

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

