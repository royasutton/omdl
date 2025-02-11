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

    ### screw

    #### Data structure fields: screw

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | <decimal>         | required          | \p d : bore diameter
      1 | (see below)       | \b undef          | \p h : screw head
      2 | (see below)       | \b undef          | \p t : tolerance

    See screw_bore() for documentation of the data types for the screw
    bore parameters \p h and \p t.

    \amu_define scope_id      (example_mount_tab)
    \amu_define title         (Screw mount tab example)
    \amu_define image_views   (top right diag)
    \amu_define image_size    (sxga)

    \amu_include (include/amu/scope_diagrams_3d.amu)
*******************************************************************************/
module screw_mount_tab
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
  \param  l       <decimal> length.

  \param  wth     <decimal> wall thickness.

  \param  screw   <datastruct> screw (see below).

  \param  depth   <decimal> depth.

  \param  cover   <decimal-length-3 | decimal> cover envelope; a list
                  [co, ct, cb], the cover over and around the top and
                  base, or a single decimal to set (co=ct=cb).

  \param  align   <integer-list-3 | integer> mount alignment; a list
                  [ax, ay, az] or a single integer to set ax.

  \param mode     <integer> mode {0=cover shell only | 1=slot negative
                  only | 2=cover with slot removed}.

  \param  f       <decimal-list-2 | decimal> scale factor; a list
                  [fd, fh], the bore diameter and bore height scale
                  factors, or a single decimal to specify \p fd only.
                  The default value for \p fh = 1.

  \details

    Construct a screw mount slot with an opening that allows for the
    insertion and interlocking of a screw head. The mount is secured to
    the screw by sliding the screw head into the mount slot. The mount
    can be used with and without a cover.

    ## Multi-value and structured parameters

    ### screw

    #### Data structure fields: screw

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | <decimal>         | required          | \p d : neck diameter
      1 | (see below)       | \b undef          | \p h : screw head

    See screw_bore() for documentation of the data types for the screw
    bore parameters \p h and \p t.

    \amu_define scope_id      (example_mount_slot)
    \amu_define title         (Screw mount slot example)
    \amu_define image_views   (front top diag)
    \amu_define image_size    (sxga)

    \amu_include (include/amu/scope_diagrams_3d.amu)
*******************************************************************************/
module screw_mount_slot
(
  l,
  wth,
  screw,
  depth,
  cover,
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
      translate([l/2*x, 0, sd + cto - coa])
      cylinder(d=hs + ctt*2 - coa, h=eps);

      translate([l/2*x, 0, coa])
      cylinder(d=hs + ctb*2 - coa, h=eps);
    }
  }

  // slot
  module slot()
  {
    translate([0, 0, -eps*4])
    union()
    {
      // neck slot
      screw_bore(d, l=sd, h=h, t=[l], f=f, a=9);

      // screw insert hole
      translate([l/2, 0, 0])
      cylinder(d=hs, h=sd);
    }
  }

  // diameter and height scale factors
  fd = defined_eon_or(f, 0, 1);
  fh = defined_e_or(f, 1, 1);

  // screw: diameter, head
  d = defined_e_or(screw, 0, screw);
  h = defined_e_or(screw, 1, undef);

  // screw head diameter
  hs = defined_e_or(h, 0, d) * fd;

  // slot depth
  sd = defined_or(depth, wth*2) * fh;

  // slot cover: default, over, top, bottom
  cto = defined_eon_or(cover, 0, 0);
  ctt = defined_e_or(cover, 1, cto);
  ctb = defined_e_or(cover, 2, ctt);

  alignments =
  [
    [0, -l-hs-ctt*2, -l-hs-ctb*2, -l-hs, -l, l, l+d, l+hs, l+hs+ctb*2, l+hs+ctt*2]/2,
    [0, -hs-ctt*2, -hs-ctb*2, -hs, -d, d, hs, hs+ctb*2, hs+ctt*2]/2,
    [0, -wth/2, -wth, -sd, -sd-cto]
  ];

  // when 'align' is scalar assign to 'align_x'
  align_x = select_ci ( alignments.x, defined_eon_or(align, 0, 0), false );
  align_y = select_ci ( alignments.y, defined_e_or(align, 1, 0), false );
  align_z = select_ci ( alignments.z, defined_e_or(align, 2, 0), false );

  translate([align_x, align_y, align_z])
  {
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
}

//! @}
//! @}


//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE example_mount_tab;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <models/3d/fastener/screws.scad>;
    include <parts/3d/enclosure/mounts.scad>;

    $fn = 36;

    d = 4;
    h = [7, 1, 1/2];
    t = [0, 10];

    mirror([0,1,0])
    screw_mount_tab(wth=3, screw=[d, h, t], brace=[50, 25], vrm=4);

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

BEGIN_SCOPE example_mount_slot;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <models/3d/fastener/screws.scad>;
    include <parts/3d/enclosure/mounts.scad>;

    $fn = 36;

    rotate([0, 90, 90])
    {
      s = [4, [8, 2, 1]];
      w = 2;
      l = 10;
      c = [1, 3, 1];

      translate([0, -15, 0])
      screw_mount_slot(screw=s, wth=w, l=l, cover=c, mode=1);

      screw_mount_slot(screw=s, wth=w, l=l, cover=c, mode=2);

      translate([0, +15, 0])
      difference() {
        %screw_mount_slot(screw=s, wth=w, l=l, cover=c, mode=0);
        screw_mount_slot(screw=s, wth=w, l=l, cover=c, mode=1);
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
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//

