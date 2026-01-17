//! Models for generating dovetailed joints in 2d.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2026

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

    \amu_define group_name  (Dovetails)
    \amu_define group_brief (Models for generating dovetailed joints in 2d.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group and macros.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_define includes_required_add
  (
    tools/operation_cs.scad
  )
  \amu_include (include/amu/includes_required.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//! Create 2D edge profiles for dovetail joint construction.
/***************************************************************************//**
  \param  t       <decimal-list-2 | decimal> tail configuration; a list
                  [m, s, f, g, r] or a single decimal to set m
                  (see below).

  \param  d       <decimal> joint depth (tail length).

  \param  w       <decimal> joint total width.

  \param  o       <decimal> tail initial width offset.

  \param  trim    <boolean> limit construction to within the total
                  joint width.

  \param  center  <boolean> center tails over total joint width.

  \param  align   <integer-list-2> joint alignment; edge-1, center, and
                  edge-2 for both [x, y].

  \param  mode    <integer> construction mode {0=removals, 1=additions}.

  \details

    Construct a 2d profile for the construction of dovetail joints. The
    dovetail male digits are constructed with \p move = 1, and the
    female slots are constructed with \p mode = 0.

    ## Multi-value and structured parameters

    ### clamp

    #### Data structure fields: clamp

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | <decimal>         |  required         | \p m : male tail width
      1 | <decimal>         |  m                | \p s : female slot width
      2 | <decimal>         |  m/5              | \p f : tail fin width expansion
      3 | <decimal>         |  m/25             | \p g : tail male/female gap
      4 | <decimal>         |  f/4              | \p r : tail external edge rounding

    \amu_define scope_id      (example)
    \amu_define title         (Dovetail profiles example)
    \amu_define image_views   (top)
    \amu_define image_size    (sxga)

    \amu_include (include/amu/scope_diagrams_3d.amu)
*******************************************************************************/

module dovetail2d
(
  t = 1,
  d = 1,

  w = 10,
  o = 0,

  trim = true,
  center = false,

  align,
  mode = 1,
)
{
  t1 = defined_e_or(t, 0, t);         // male (tail) width
  t2 = defined_e_or(t, 1, t1);        // female width
  te = defined_e_or(t, 2, t1/5);      // "engagement" width
  tg = defined_e_or(t, 3, t1/25);     // finger gap width
  vr = defined_e_or(t, 4, te/4);      // finger exterior edge rounding

  tc = ceil(w / (t1 + t2));           // finger count

  mr = (mode == 1) ? vr : 0;          // male rounding
  fr = (mode == 0) ? vr : 0;          // female rounding
  sg = (mode == 0) ? -tg/2 : +tg/2;   // gap adjustment

  s1 = t1 - sg;                       // finger sized for gap

  // joint initial offset
  io = o + sg/2 + (center ? w/2 - (t1*tc + t2*(tc-1))/2 : 0);

  // align construction
  translate
  (
    [
      select_ci( [ 0, -w/2, -w ], defined_e_or(align, 0, 0), false ),
      select_ci( [ 0, -d/2, -d ], defined_e_or(align, 1, 0), false ),
    ]
  )
  intersection_cs(trim, trim ? undef : 1)
  {
    // child-0: joint area = length x depth
    square([w, d]);

    // child-1: dovetails
    for ( i = [0 : tc-1] )
    translate ([io + (t1 + t2)*i, 0])
    {
      // male finger construction
      if (te > 0)
      { // finder tail with engagement
        pg_te = let
                (
                  sss = triangle_sas2sss( [d, 90, te/2] ),
                  ppp = triangle2d_sss2ppp( sss ),

                  vrm = [0,0,1]
                )
                polygon_round_eve_all_p(ppp, vr=mr, vrm=vrm);

        // straight section rounder out at base (female mode)
        pg_rectangle([s1, d], vr=fr, vrm=[0,0,4,3]);

        translate([-te/2,d])
        rotate([180,0])
        polygon(pg_te);

        translate([s1 + te/2, d])
        rotate([180,180])
        polygon(pg_te);
      }
      else
      { // straight finger / pin
        pg_rectangle([s1, d], vr=mr, vrm=[1,1,0,0]);
      }
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
    include <tools/operation_cs.scad>;
    include <models/2d/joints/dovetail.scad>;

    w = 20;
    t = [2, 3.25, 1/4, 1/20, 1/4];
    d = 2.75;
    c = true;

    // male section (lower)
    dovetail2d (w=w, t=t, d=d, mode=1, center=c );
    translate([0, -d/2]) square([w,d/2]);

    // female section (upper)
    translate([0, d*1.25])
    {
      difference() { square([w,d]); dovetail2d (w=w, t=t, d=d, mode=0, center=c ); }
      translate([0, d]) square([w,d/2]);
    }

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "top";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//

