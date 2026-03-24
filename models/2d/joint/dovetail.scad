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

  \amu_include (include/amu/doxyg_init_pd_gds_ipg.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group and macros.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/doxyg_define_in_parent_open.amu)
  \amu_define includes_required_add
  (
    transforms/base_cs.scad
  )
  \amu_include (include/amu/includes_required.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//! Create 2D edge profiles for dovetail joint construction.
/***************************************************************************//**
  \param  t       <decimal-list-6 | decimal> tail configuration; a list
                  [m, s, f, g, er, ir] or a single decimal to set m
                  (see below).

  \param  d       <decimal> joint depth (tail length).

  \param  w       <decimal> joint total width.

  \param  o       <decimal> tail initial width offset.

  \param  type    <integer> construction type {0=male additions,
                  1=male removals, 2=female removals}.

  \param  trim    <boolean> limit construction to within the total
                  joint width.

  \param  center  <boolean> center tails over total joint width.

  \param  align   <integer-list-2> joint alignment; edge-1, center, and
                  edge-2 for both [x, y].

  \details

    Use this module to generate a 2D profile for constructing dovetail
    joints. Set \p type = 0 to create the male dovetail fingers, and
    set \p type = 2 to create the corresponding female slots. Ensure
    that the same profile parameters are used for both components to
    achieve proper alignment and fit.

    When creating dovetail joints using 3D-printed plastics, it’s
    important to carefully manage the joint gap due to the rigidity of
    most plastics. It’s a good idea to test with small sample joints
    before proceeding with larger parts. Additionally, applying gentle
    heat to the joint during assembly using a hot air gun (or hair
    dryer) can help soften the male and female components slightly,
    improving the fit and ease of assembly.

    ## Multi-value and structured parameters

    ### tail

    #### Data structure fields: t (tail configuration)

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | decimal           |  required         | \p m : male tail width
      1 | decimal           |  m                | \p s : female slot width
      2 | decimal           |  m/5              | \p f : tail fin width expansion
      3 | decimal           |  m/25             | \p g : joint gap (male and female)
      4 | decimal           |  m/20             | \p er : external edge rounding
      5 | decimal           |  m/20             | \p ir : internal edge rounding (minimum cut radius)

    The parameter \p ir can be used to define an internal corner edge
    overcut, which helps accommodate the minimum cut radius required
    for subtractive manufacturing. This overcut is based on the minimum
    diameter of the cut tool. By clearing the rounded section, it
    ensures proper clearance for mating joint members during assembly.

    \amu_define scope_id      (example)
    \amu_define title         (Dovetail profile example)
    \amu_define image_views   (top)
    \amu_define image_size    (sxga)

    \amu_include (include/amu/scope_diagrams_3d.amu)
*******************************************************************************/

module joint2d_dovetail
(
  t = 1,
  d = 1,

  w = 10,
  o = 0,

  type = 0,

  trim = false,
  center = false,

  align
)
{
  t1 = defined_e_or(t, 0, t);         // male (tail) width
  t2 = defined_e_or(t, 1, t1);        // female width
  te = defined_e_or(t, 2, t1/5);      // "engagement" width
  tg = defined_e_or(t, 3, t1/25);     // finger gap width
  er = defined_e_or(t, 4, t1/20);     // finger exterior edge rounding
  ir = defined_e_or(t, 5, t1/20);     // finger interior edge rounding

  tc = ceil(w / (t1 + t2));           // finger count

  mr = (type == 2) ?  0 : er;         // male exterior rounding
  fr = (type == 2) ? er :  0;         // female exterior rounding
  sg = (type == 2) ?  1 : -1;         // gap adjustment

  s1 = t1 + sg * tg/2;                // finger sized for gap

  // joint initial offset
  io = o - sg * tg/4 + (center ? w/2 - (t1*tc + t2*(tc-1))/2 : 0);

  // align construction
  translate
  (
    [
      select_ci( [ 0, -w/2, -w ], defined_e_or(align, 0, 0), false ),
      select_ci( [ 0, -d/2, -d ], defined_e_or(align, 1, 0), false ),
    ]
  )
  {
    // male and female joint construction; male additions or female removals
    if (type == 0 || type == 2)
    intersection_cs(trim, trim ? undef : 1)
    {
      // child-0: joint trim area = length x depth
      square([w, d]);

      // child-1: dovetails; male additions or female removals
      for ( i = [0 : tc-1] )
      translate ([io + (t1 + t2)*i, 0])
      {
        // male and female finger construction
        if (te > 0)
        { // finger tail with engagement
          pg_te = let
                  (
                    sss = triangle_sas2sss( [d, 90, te/2] ),
                    ppp = triangle2d_sss2ppp( sss ),

                    vrm = [0,0,1]
                  )
                  polygon_round_eve_all_p(ppp, vr=mr, vrm=vrm);

          // straight section round out at base (female removal)
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
          pg_rectangle([s1, d], vr=er, vrm=(type == 2) ? [0,0,4,3] : [1,1,0,0]);
        }
      }
    }

    // interior corner minimum cut radius; removal modes only
    if ( ir > 0 && (type == 1 || type == 2))
    for
    (
      i = [0 : tc-1],

      mcr_o =
      let ( pe = max(te, 0) )
      [
        [   - pe/2, 0] + ((type == 2) ? [+ir/2, d] : [+(pe-ir)/2, 0]),
        [s1 + pe/2, 0] + ((type == 2) ? [-ir/2, d] : [-(pe-ir)/2, 0])
      ]
    )
    translate([io + (t1 + t2)*i, 0] + mcr_o)
    circle(d=ir);
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
    include <transforms/base_cs.scad>;
    include <models/2d/joint/dovetail.scad>;

    w = 20;
    t = [2, 3.25, 1, 1/20, 1/8, 1/4];
    d = 2.75;
    c = true;

    // male section (lower)
    joint2d_dovetail (w=w, t=t, d=d, type=0, center=c );
    difference() { translate([0, -d/2]) square([w, d/2]); joint2d_dovetail (w=w, t=t, d=d, type=1, center=c ); }

    // female section (upper)
    translate([0, d*1.25])
    difference() { square([w, d+d/2]); joint2d_dovetail (w=w, t=t, d=d, type=2, center=c ); }

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

