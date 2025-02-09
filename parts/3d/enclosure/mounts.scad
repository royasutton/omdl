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
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//

