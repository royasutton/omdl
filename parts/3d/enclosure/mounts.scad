//! Screw mounts tabs, mount slots, mount posts, etc.
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

    \amu_define group_name  (Mounts)
    \amu_define group_brief (Screw mounts tabs, mount slots, mount posts, etc.)

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

//! A mount tab with screw hole and support brace.
/***************************************************************************//**
  \param  wth     <decimal> wall thickness.

  \param  screw   <datastruct | decimal> screw bore; structured data or
                  a single decimal to set the bore diameter.

  \param  brace   <decimal-list-2 | decimal> brace percentage; a list
                  [by, bz] or a single decimal to set (by=bz).

  \param  size    <decimal-list-2 | decimal> tab size; a list [sx, sy].

  \param vr       <decimal-list-4 | decimal> rounding radius; a list
                  [v1r, v2r, v3r, v4r] or a single decimal for
                  (v1r=v2r=v3r=v4r).

  \param vrm      <integer> rounding mode {0|1|2|3|4}.

  \details

    Construct a mount tab with a screw hole. The parameters \p wth and
    \p screw are required (the others are optional). When \p brace is
    specified, braces are constructed to support and reinforce the
    connection to the adjacent structure. The brace-to-tab and
    brace-to-wall lengths can be specified independently. When the \p
    size if not supplied, a default size will be used based on the
    specified mount tab features.

    ## Multi-value and structured parameters

    ### screw bore

    #### Data structure fields: screw

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | <decimal>         | required          | \p d: bore diameter
      1 | (see below)       | \b undef          | \p h: screw head
      2 | (see below)       | \b undef          | \p t: tolerance

      See screw_bore() for documentation of the data types for the
      screw bore parameters \p h and \p t.

    \amu_define scope_id      (example_mount_screw_tab)
    \amu_define title         (Screw mount tab example)
    \amu_define image_views   (top right diag)
    \amu_define image_size    (sxga)

    \amu_include (include/amu/scope_diagrams_3d.amu)
*******************************************************************************/
module mount_screw_tab
(
  wth,
  screw,
  brace,
  size,
  vr,
  vrm
)
{
  // screw: diameter, head, and tolerance
  d  = defined_e_or(screw, 0, screw);
  h  = defined_e_or(screw, 1, undef);
  t  = defined_e_or(screw, 2, undef);

  // default size: x and y (adjusted for tolerance and brace thickness)
  dx = d*3 + defined_e_or(t, 0, 0) + (is_undef(brace) ? 0 : wth*2);
  dy = d*3 + defined_e_or(t, 1, 0);

  x  = defined_e_or(size, 0, dx);
  y  = defined_e_or(size, 1, dy);

  // rounding defaults
  r  = defined_or(vr, d/2);

  rm = vrm == 1 ? [[5,5,0,0],   [10,0,9]]
     : vrm == 2 ? [[5,5,10,9],  [10,0,9]]
     : vrm == 3 ? [[1,1,0,0],   [4,0,3]]
     : vrm == 4 ? [[1,1,4,3],   [4,0,3]]
     : [0, 0];

  translate([0, y/2, wth/2])
  union()
  {
    // mount tab
    difference()
    {
      extrude_linear_uss(wth, center=true)
      pg_rectangle([x, y], vr=r, vrm=first(rm), center=true);

      screw_bore(d=d, l=wth+eps*8, h=h, t=t, a=0);
    }

    // mount tab reinforcement triangular brace
    if ( is_defined(brace) )
    {
      by = defined_e_or(brace, 0, brace);
      bz = defined_e_or(brace, 1, by);

      sy = y * by /100;
      sz = y * bz /100;

      for ( i=[-1, 1] )
      rotate([0, 90, 0])
      translate([-wth/2 -sz - eps*2, -y/2, (x/2 - wth/2)*i])
      extrude_linear_uss(wth, center=true)
      pg_triangle_sas([sy, 90, sz], vr=r, vrm=second(rm));
    }
  }
}

//! A screw mount slot with optional cover envelope.
/***************************************************************************//**
  \param  wth     <decimal> wall thickness.

  \param  screw   <datastruct> screw bore (see below).

  \param  cover   <decimal-length-3 | decimal> cover envelope; a list
                  [co, ct, cb], the cover over and around the top and
                  base, or a single decimal to set (co=ct=cb).

  \param  size    <decimal> slot length.

  \param  align   <integer-list-3 | integer> mount alignment; a list
                  [ax, ay, az] or a single integer to set ax.

  \param mode     <integer> mode {0=cover, 1=slot (negative), 2=cover
                  with slot removed}.

  \param  f       <decimal-list-2 | decimal> scale factor; a list
                  [fd, fh], the bore diameter and bore height scale
                  factors, or a single decimal to specify \p fd only.
                  The default values for both \p fd and \p fh is 1.

  \details

    Construct a screw mount slot with an opening that allows for the
    insertion and interlocking of a screw head. The mount is secured to
    the screw by sliding the screw head into the mount slot. The mount
    can be used with and without a cover. The parameter \p size is
    optional and when not specified, its value is 3 * d (the screw neck
    diameter).

    ## Multi-value and structured parameters

    ### screw bore

    #### Data structure fields: screw

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | <decimal>         | required          | \p d : neck diameter
      1 | <datastruct>      | [d*2, d/2]        | \p h : screw head

      See screw_bore() for documentation of the data types for the
      screw parameters \p d and \p h.

    \amu_define scope_id      (example_mount_screw_slot)
    \amu_define title         (Screw mount slot example)
    \amu_define image_views   (front top diag)
    \amu_define image_size    (sxga)

    \amu_include (include/amu/scope_diagrams_3d.amu)
*******************************************************************************/
module mount_screw_slot
(
  wth,
  screw,
  cover,
  size,
  align,
  mode,
  f
)
{
  // slot cover
  module cover()
  {
    // shape overlap adjustment
    coa = eps*4;

    hull()
    for ( x=[-1, 1] )
    {
      translate([sl/2*x, 0, sd + cto - coa])
      cylinder(d=hd + ctt*2 - coa, h=eps);

      translate([sl/2*x, 0, coa])
      cylinder(d=hd + ctb*2 - coa, h=eps);
    }
  }

  // slot
  module slot()
  {
    translate([0, 0, -eps*4])
    union()
    {
      // neck slot
      screw_bore(d, l=sd, h=h, t=[sl], f=f, a=9);

      // screw insert hole
      translate([sl/2, 0, 0])
      cylinder(d=hd, h=sd);
    }
  }

  // diameter and height scale factors
  fd = defined_eon_or(f, 0, 1);
  fh = defined_e_or(f, 1, 1);

  // screw: diameter, head
  d = defined_e_or(screw, 0, screw);
  h = defined_e_or(screw, 1, [d*2, d/2]);

  // local scaled version of screw diameter
  ld = d * fd;

  // screw head: diameter, flat height, bevel height
  hd = defined_e_or(h, 0, 0) * fd;
  hf = defined_e_or(h, 1, 0) * fh;
  hb = defined_e_or(h, 2, 0) * fh;

  // slot cover: default, over, top, bottom
  cto = defined_eon_or(cover, 0, 0);
  ctt = defined_e_or(cover, 1, cto);
  ctb = defined_e_or(cover, 2, ctt);

  // slot size: depth, length
  sd = wth + hf;
  sl = defined_or(size, d * 3);

  alignments =
  [
    [0, -sl-hd-ctt*2, -sl-hd-ctb*2, -sl-hd, -sl, sl, sl+ld, sl+hd, sl+hd+ctb*2, sl+hd+ctt*2]/2,
    [0, -hd-ctt*2, -hd-ctb*2, -hd, -ld, ld, hd, hd+ctb*2, hd+ctt*2]/2,
    [0, -wth/2, -wth+hb, -wth, -sd, -sd-cto]
  ];

  // when 'align' is scalar assign to 'align_x'
  align_x = select_ci ( alignments.x, defined_eon_or(align, 0, 0), false );
  align_y = select_ci ( alignments.y, defined_e_or(align, 1, 0), false );
  align_z = select_ci ( alignments.z, defined_e_or(align, 2, 0), false );

  translate([align_x, align_y, align_z])
  {
    if (mode == 0)
    cover();

    else if (mode == 1)
    slot();

    else if (mode == 2)
    difference()
    {
      cover();
      slot();
    }
  }
}

//! A multi-directional screw mount slot with optional cover envelope.
/***************************************************************************//**
  \param  wth     <decimal> wall thickness.

  \param  screw   <datastruct> screw bore (see below).

  \param  cover   <decimal-length-3 | decimal> cover envelope; a list
                  [co, ct, cb], the cover over and around the top and
                  base, or a single decimal to set (co=ct=cb).

  \param  size    <decimal> slot length.

  \param  align   <integer-list-3 | integer> mount alignment; a list
                  [ax, ay, az] or a single integer to set ax.

  \param mode     <integer> mode {0=cover, 1=slot (negative), 2=cover
                  with slot removed}.

  \param  f       <decimal-list-2 | decimal> scale factor; a list
                  [fd, fh], the bore diameter and bore height scale
                  factors, or a single decimal to specify \p fd only.
                  The default values for both \p fd and \p fh is 1.

  \param  slots   <datastruct | integer> slot count and separation angle.

  \details

    Construct a screw mount slot with an opening that allows for the
    insertion and interlocking of a screw head. The mount is secured to
    the screw by sliding the screw head into the mount slot. The mount
    can be used with and without a cover. The parameter \p size is
    optional and when not specified, its value is 3 * d (the screw neck
    diameter).

    This is a version of mount_screw_slot() that supports multiple
    slots equally divided around a circle.

    ## Multi-value and structured parameters

    ### screw bore

    #### Data structure fields: screw

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | <decimal>         | required          | \p d : neck diameter
      1 | <datastruct>      | [d*2, d/2]        | \p h : screw head

      See screw_bore() for documentation of the data types for the
      screw parameters \p d and \p h.

    ### Slot count and separation angle

    #### Data structure fields: slots

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | <integer>         | required          | \p sc : slot count
      1 | <decimal>         | 360/sc            | \p sa : slot separation angle

    \amu_define scope_id      (example_mount_screw_slot_md)
    \amu_define title         (Multi-directional screw mount slot example)
    \amu_define image_views   (front top diag)
    \amu_define image_size    (sxga)

    \amu_include (include/amu/scope_diagrams_3d.amu)
*******************************************************************************/
module mount_screw_slot_md
(
  wth,
  screw,
  cover,
  size,
  align,
  mode,
  f,
  slots = 1
)
{
  module multi_mss(m=0)
  {
    if (sc > 0)
    for ( i=[0:sc-1] )
    rotate([0, 0, sa*i])
    mount_screw_slot
    (
      wth=wth,
      screw=screw,
      cover=cover,
      size=size,
      align=[4, 0, align_z],
      mode=m,
      f=f
    );
  }

  module cover() { multi_mss(0); }
  module slot()  { multi_mss(1); }

  align_z = defined_eon_or(align, 2, 0);

  sc = defined_eon_or(slots, 0, 0);
  sa = defined_e_or(slots, 1, 360/sc);

  if (mode == 0)
  cover();

  if (mode == 1)
  slot();

  if (mode == 2)
  difference()
  {
    cover();
    slot();
  }
}

//! A screw mount post with screw bore and optional fins.
/***************************************************************************//**

  \param  post      <datastruct> post (see below).
  \param  screw     <datastruct> screw bore (see below).
  \param  bore_sft  <datastruct> self-forming threads screw bore (see below).
  \param  fins      <datastruct> fins (see below).
  \param  cut       <datastruct> cut (see below).

  \details

    Construct a screw mount post with screw bore, fins, and diagonal
    cut at base. The post and fins have preset rounding configurations,
    but also support manual rounding specifications. The post screw
    bore is removed using either screw_bore(), or screw_bore_tsf(), or
    both. All relevant screw bore features are made available,
    including nut-slot cut-outs as shown in the examples below. The
    post can be configured with a diagonally cut base to facilitate 3D
    printing posts without base support, such as those attached
    elevated on walls.

    \note Both \p screw and \p bore_sft may be used together when it is
          desired to create a recessed screw head and a bore with self
          forming threads. The \p screw bore diameter will need to be
          sufficiently reduced so as to not remove the self-forming
          thread engagement cylinders.

    ## Multi-value and structured parameters

    ### post

    #### Data structure fields: post

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | <decimal-list-2 \| decimal>           | required  | \p pd: post diameter(s)
      1 | <decimal>                             | required  | \p ph: post height
      2 | <integer-list-4 \| integer \| string> | 0         | rounding mode
      3 | <decimal-list-4 \| decimal>           | min(pd)/8 | rounding radius

      The post base and top can have different diameters by assigning a
      list [pdb, pdt]. This is useful for 3D printing unsupported wall
      attached posts. When \p pd is assigned a decimal the base and top
      diameters will be equal. The rounding mode can be assigned one of
      the preset configuration strings: {"p1", ..., "p13"} or assigned
      a custom value. Both the rounding mode and rounding radius can be
      assigned a list, to control each edge individually, or a single
      value when all edges shall be the same.

      \note When assigning the rounding mode and rounding radius
            individually, the inner-upper and inner-lower edges of the
            rectangular revolution, that forms the post, should be
            assigned zero in most circumstances as follows, for
            example: [0, 1, 4, 0].

    ### screw bore

    #### Data structure fields: screw

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | <decimal>         | required          | \p d: bore diameter
      1 | <decimal>         | pd                | \p l: bore length
      2 | <datastruct>      | undef             | \p h: screw head
      3 | <datastruct>      | undef             | \p n: screw nut
      4 | <datastruct>      | undef             | \p s: nut slot cutout
      5 | <datastruct>      | undef             | \p f: bore scale factor

      See screw_bore() for documentation of the data types for the
      screw parameters.

    ### self-forming threads screw bore

    #### Data structure fields: bore_sft

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | <decimal>         | required          | \p d: bore diameter
      1 | <decimal>         | pd                | \p l: bore length
      2 | <datastruct>      | undef             | \p t: thread engagement

      See screw_bore_tsf() for documentation of the data types for the
      self-forming threads screw bore parameters.

    ### fins

    #### Data structure fields: fins

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | <integer>         | required          | fin count
      1 | <integer>         | 0                 | fin type: {0=triangular, 1=rectangular}
      2 | <decimal-list-3 \| decimal>           | [ph*5/8, pd/4, pd/8] | size scale factors: [h, l, w]
      3 | <integer-list-n \| integer \| string> | 0                    | rounding mode
      4 | <decimal-list-n \| decimal>           | (see below)          | rounding radius
      5 | <decimal>                             | 360                  | distribution angle

      The rounding mode can be assigned one of the preset configuration
      strings: {"p1", ..., "p6"} or assigned custom values. Both the
      rounding mode and rounding radius can be assigned a list, to
      control each edge individually, or a single value when all edges
      shall be the same.

      \note The edge list size is dependent on the fin type; n=3 for
            triangular, and n=4 for rectangular.

    ### cut

    #### Data structure fields: cut

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | <decimal>         | 0                 | cut x-angle
      1 | <decimal>         | 0                 | cut post base offset
      2 | <decimal>         | 0                 | cut z-rotation
      3 | <decimal>         | 4                 | cube removal scale

      The \p cut parameter can be used to cut the base of the post at
      an angle. As previously discussed, this is useful for 3D-printing
      wall-attached posts that does not have lower support.

    \amu_define scope_id      (example_mount_screw_post)
    \amu_define title         (Screw mount post example)
    \amu_define image_views   (front top diag)
    \amu_define image_size    (sxga)

    \amu_include (include/amu/scope_diagrams_3d.amu)
*******************************************************************************/
module mount_screw_post
(
  post,
  screw,
  bore_sft,
  fins,
  cut
)
{
  // round post fins
  module round_post_fins(rd, rh)
  {
    // move distance for fin to always contact approximated polygon cylinder
    function fin_embed(r, w) =
      let
      (
        n = get_fn(r),
        d = polygon_regular_perimeter(n, r) / n
      )
      r - sqrt( pow(r,2) - pow(w/2, 2) - pow(d/2, 2) );

    c       = defined_eon_or(fins, 0, 0);       // count

    if ( c  > 0 )
    {
      t     = defined_e_or(fins, 1, 0);         // type
      sf    = defined_e_or(fins, 2, undef);     // size scale factors: [h, l, t]

      h     = defined_eon_or(sf, 0, 5/8) * rh;
      l     = defined_e_or  (sf, 1, 1/4) * rd;
      w     = defined_e_or  (sf, 2, 1/8) * rd;

      d_vr  = ( t == 0 ) ? min(h, l)/2 : min(l, w)/2;

      vrm   = defined_e_or(fins, 3, 0);         // rounding mode
      vr    = defined_e_or(fins, 4, d_vr);      // vertex rounding
      da    = defined_e_or(fins, 5, 360);       // distribution angle

      // triangular
      if ( t == 0 )
      {
        p_vrm =
          let
          (
            p = !is_string(vrm) ? vrm
              : (vrm == "p1") ? [10, 0, 9]
              : (vrm == "p2") ? [4, 0, 3]
              : (vrm == "p3") ? [6, 0, 7]
              : (vrm == "p4") ? [7, 0, 7]
              : (vrm == "p5") ? [0, 0, 1]
              : (vrm == "p6") ? [0, 0, 5]
              : 0
          )
          p;

        for (i = [0:c-1])
        {
          rotate([90, 0, da/c * i + 180])
          translate([ -rd/2 - l + fin_embed(rd/2, w), 0, 0])
          extrude_linear_mss(w, center=true)
          pg_triangle_sas([h, 90, l], vr=vr, vrm=p_vrm);
        }
      }
      else

      // rectangular
      if ( t == 1 )
      {
        p_vrm =
          let
          (
            p = !is_string(vrm) ? vrm
              : (vrm == "p1") ? [0, 10, 9, 0]
              : (vrm == "p2") ? [0, 4, 3, 0]
              : (vrm == "p3") ? [0, 8, 7, 0]
              : (vrm == "p4") ? [0, 5, 5, 0]
              : (vrm == "p5") ? [0, 1, 1, 0]
              : (vrm == "p6") ? [0, 9, 10, 0]
              : 0
          )
          p;

        for (i = [0:c-1])
        {
          rotate([0, 0, da/c * i])
          translate([rd/2 + l/2 - fin_embed(rd/2, w), 0, 0])
          extrude_linear_mss(h)
          pg_rectangle( [l, w], vr=vr, vrm=p_vrm, center=true);
        }
      }
    }
  }

  pd  = defined_e_or(post, 0, 0);
  ph  = defined_e_or(post, 1, 0);
  vrm = defined_e_or(post, 2, 0);

  pd_min = min( pd );
  pd_max = max( pd );

  vr  = defined_e_or(post, 3, pd_min/8);

  p_vrm =
    let
    (
      p = !is_string(vrm) ? vrm
        : (vrm == "p1" ) ? [0, 5, 10, 0]
        : (vrm == "p2" ) ? [0, 0, 10, 0]
        : (vrm == "p3" ) ? [0, 5, 0, 0]
        : (vrm == "p4" ) ? [0, 1, 0, 0]
        : (vrm == "p5" ) ? [0, 9, 0, 0]
        : (vrm == "p6" ) ? [0, 7, 0, 0]
        : (vrm == "p7" ) ? [0, 1, 4, 0]
        : (vrm == "p8" ) ? [0, 1, 8, 0]
        : (vrm == "p9" ) ? [0, 5, 5, 0]
        : (vrm == "p10") ? [0, 9, 10, 0]
        : (vrm == "p11") ? [0, 1, 1, 0]
        : (vrm == "p12") ? [0, 3, 4, 0]
        : (vrm == "p13") ? [0, 7, 8, 0]
        : 0
    )
    p;

  //
  // construct
  //

  difference()
  {
    union()
    {
      // round post
      rotate_extrude()
      pg_trapezoid(b=pd/2, h=ph, vr=vr, vrm=p_vrm);

      // fins
      if ( is_defined(fins) )
      round_post_fins(pd_min, ph);
    }

    // screw bore
    if ( is_defined(screw) )
    {
      d = defined_eon_or(screw, 0, 0);
      l = defined_e_or(screw, 1, ph);
      h = defined_e_or(screw, 2, undef);
      n = defined_e_or(screw, 3, undef);
      s = defined_e_or(screw, 4, undef);
      f = defined_e_or(screw, 5, undef);

      translate([0, 0, ph+eps*2])
      screw_bore(d=d, l=l, h=h, n=n, s=s, f=f, a=1);
    }

    // self-forming threads screw bore
    if ( is_defined(bore_sft) )
    {
      d = defined_eon_or(bore_sft, 0, 0);
      l = defined_e_or(bore_sft, 1, ph);
      t = defined_e_or(bore_sft, 2, undef);

      translate([0, 0, ph+eps*2])
      screw_bore_tsf(d=d, l=l, t=t, a=1);
    }

    // post cut
    if ( is_defined(cut) )
    {
      a = defined_e_or(cut, 0, 0);  // cut x-angle
      o = defined_e_or(cut, 1, 0);  // cut base offset
      r = defined_e_or(cut, 2, 0);  // cut z-rotation
      s = defined_e_or(cut, 3, 4);  // removal scale

      c = [pd_max, pd_max, ph] * s;

      translate([0, 0, o])
      rotate([a, 0, r-90])
      translate([0, 0, -third(c)/2])
      cube(c, center=true);
    }
  }
}

//! @}
//! @}


//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE example_mount_screw_tab;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <models/3d/fastener/screws.scad>;
    include <parts/3d/enclosure/mounts.scad>;

    $fn = 36;

    d = 4;
    h = [7, 1, 1/2];
    t = [0, 10];

    mirror([0,1,0])
    mount_screw_tab(wth=3, screw=[d, h, t], brace=[50, 25], vrm=4);

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "top right diag";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;

BEGIN_SCOPE example_mount_screw_slot;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <models/3d/fastener/screws.scad>;
    include <parts/3d/enclosure/mounts.scad>;

    $fn = 36;

    rotate([0, 90, 90])
    {
      w = 2;
      s = [4, [8, 2, 1]];
      c = [1, 3, 1];

      translate([0, -15, 0])
      mount_screw_slot(wth=w, screw=s, cover=c, mode=1);

      mount_screw_slot(wth=w, screw=s, cover=c, mode=2);

      translate([0, +15, 0])
      difference() {
        %mount_screw_slot(wth=w, screw=s, cover=c, mode=0);
        mount_screw_slot(wth=w, screw=s, cover=c, mode=1);
      }
    }

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "front top diag";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;

BEGIN_SCOPE example_mount_screw_slot_md;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <models/3d/fastener/screws.scad>;
    include <parts/3d/enclosure/mounts.scad>;

    $fn = 36;

    w = 2;
    s = [4, [8, 2, 1]];
    c = [1, 3, 1];

    rotate([-90, 0, 0])
    mount_screw_slot_md(wth=w, screw=s, cover=c, mode=2, slots=[3, 90]);

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "front top diag";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;

BEGIN_SCOPE example_mount_screw_post;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <models/3d/fastener/screws.scad>;
    include <parts/3d/enclosure/mounts.scad>;

    $fn = 36;

    u = undef;

    translate([-20, 0, 0])
    mount_screw_post(post=[[10, 5], 4], bore_sft=3, fins=[6, 1, 1]);

    s = [3, 21, [5, 1, 1, 4], [5, 2, 0, 6, 0, 5], [0, -10]];
    translate([0, 0, 0])
    mount_screw_post(post=[10, 20, "p10"], screw=s, fins=[2, 1, 1, "p1"]);

    translate([+20, 0, 0])
    mount_screw_post(post=[10, 25, "p1"], screw=[3, 10, [5, 1, 1]], fins=[4, 0, u, "p1"]);

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "front top diag";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//

