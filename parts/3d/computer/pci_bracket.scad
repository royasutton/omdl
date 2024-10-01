//! A PCI slot cover and adapter card bracket generator.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2018-2024

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

    \amu_define group_name  (PCI bracket)
    \amu_define group_brief (PCI slot cover bracket generator.)

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

//! PCI slot cover and adapter card bracket generator.
/***************************************************************************//**
  \param  form  <integer> bracket form factor
          (0=standard, 1=low profile).

  \param  fins  <integer> fin placements
          (0=none, 1=side one, 2=side two, 3=both sides).

  \param  vents <data-list-2> vent specification.

  \param  ribs  <data-list-4> rib specification.

  \param  tabs  <list-list-n> tab specification.

  \param  align <integer-list-3> part alignment.

  \details

    This module generates customized PCI brackets that can be used to
    create simple PCI slot covers and PCI adapter card brackets in both
    full and half-height formats. All parameters are optional. Default
    values are used for all unspecified parameters. Default values are
    also used for unspecified elements positions for parameter that
    accepts a list of values.

    Multi-value parameters
    ----------------------

    \b vents

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | <integer>         | 0                 | vent hole count
      1 | <decimal>         | 3.0               | vent hole radius

    \b ribs

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | <integer>         | 3                 | location (0=top, 1=none, 2=bottom, 3=both)
      1 | <integer>         | 1                 | shape (0=cylinder, 1=ellipse)
      2 | <integer>         | 10                | number of divisions
      3 | <decimal-list-n>  | [3, 7]            | division positions list [p1, p2, ..., pn]

    \b tabs

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | <decimal-list-3>  |                   | tab-0: [offset-y, offset-x, hole-diameter]
     ...| ...               |                   | ...
      n | <decimal-list-3>  |                   | tab-n: [offset-y, offset-x, hole-diameter]

    \b align

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | <integer>         | 0                 | align-x
      1 | <integer>         | 0                 | align-y
      2 | <integer>         | 0                 | align-z

    The possible x, y, and z alignment locations and configuration
    values are described in the following table:

    | parameter |  value    | value description
    |:---------:|:---------:|:--------------------------------------------------------
    | align-x   | 0         | bracket outside
    |           | 1         | bracket center
    |           | 2         | bracket inside
    |           | 3         | bracket tab screw center-x
    |           | 4         | back of tab
    |           | 5         | pci connector alignment slot
    | align-y   | 0         | bracket edge away from circuit board
    |           | 1         | bracket tab edge away from circuit board
    |           | 2         | circuit board bottom edge
    |           | 3         | bracket tab screw center-y
    |           | 4         | bracket edge near circuit board
    |           | 5         | connectors window edge away from circuit board
    |           | 6         | connectors window center
    |           | 7         | connectors window edge near circuit board
    | align-z   | 0         | bracket bottom
    |           | 1         | top of pci connector
    |           | 2         | bottom of board / board stop
    |           | 3         | bottom of bracket tab
    |           | 4         | top of bracket tab
    |           | 5         | connectors window bottom
    |           | 6         | connectors window center
    |           | 7         | connectors window top

    \amu_define title         (PCI bracket example)
    \amu_define image_views   (left right back diag)
    \amu_define image_size    (sxga)
    \amu_define image_columns (4)

    \amu_include (include/amu/scope_diagrams_3d.amu)
*******************************************************************************/
module pci_bracket
(
  form = 0,
  fins = 1,
  vents,
  ribs,
  tabs,
  align
)
{
  bff = defined_or(form, 0);

  mth  =   0.86;                              // 20 GA

  sv01 = select_ci( [112.75, 71.46], bff);
  sv02 = select_ci( [  2.54, -2.14], bff);    // bff1: 20.73 - 18.59
  sv03 = select_ci( [ 21.59, 20.73], bff);    // bff1: 17.15 + 3.58
  sv04 = select_ci( [ 11.43, 11.84], bff);
  sv05 = 18.42;
  sv06 = select_ci( [  5.08,  6.35], bff);
  sv07 = 4.42;
  sv08 = select_ci( [ 89.90, 54.53], bff);
  sv09 = select_ci( [ 10.16,  9.04], bff);
  sv10 = select_ci( [  4.56,  0.00], bff);
  sv11 = 4.11;
  sv12 = select_ci( [120.02, 79.20], bff);

  sv13 = 59.05;
  sv14 = select_ci( [100.36, 63.58], bff);
  sv15 = select_ci( [111.15, 68.90], bff);
  sv16 = select_ci( [106.65, 64.40], bff);
  sv17 = select_ci( [ 12.06, 12.07], bff);

  sv18 = select_ci( [  2.54, -3.58], bff);

  sv19 =  5.07;
  sv20 =  5.00;

  // configuration and defaults
  brm = defined_e_or(ribs, 0, 3);
  brs = defined_e_or(ribs, 1, 1);
  brd = sv05/defined_e_or(ribs, 2, 10);
  brc = defined_e_or(ribs, 3, [3,7]);

  bfc = defined_or(fins, 0);

  vhc = defined_e_or(vents, 0, 0);
  vhr = defined_e_or(vents, 1, 3);
  vhs = vhr*4;

  mtt = 2.00 * mth;
  tbf = 1.25;

  // alignment offsets
  bax = select_ci(
      [
        0,
        -mth/2,
        -mth,
        sv06,
        sv04,
        -sv13,
        0
      ]
      , defined_e_or(align, 0, 0) );

  bay = select_ci(
      [
        0,
        select_ci([-sv02, -sv18], bff),
        -sv05+mtt,
        select_ci([-sv05, 0], bff),
        select_ci([-sv03, -sv05], bff),
        -sv05/2+sv17/2,
        -sv05/2,
        -sv05/2-sv17/2,
        0
      ]
      , defined_e_or(align, 1, 0) );

  baz = select_ci(
      [
        sv12-sv01,
        -sv01+sv14+sv15-sv16,
        -sv01+sv14,
        -sv01,
        -sv01-mth,
        -sv01+sv08+sv09,
        -sv01+sv08/2+sv09,
        -sv01+sv09,
        0
      ]
      , defined_e_or(align, 2, 0) );

  //
  // bracket
  //

  translate([bax,bay,baz])
  rotate([90,0,90])
  difference()
  {
    // connector opening
    col = sv08;
    coo = sv01-col-sv09;

    union()
    {
      // top tab
      translate([0,sv01,eps])
      rotate([270,0,0])
      difference()
      {
        vrf = select_ci( [[0,0,1.5,1.5], [1.5,0,1.5,1.5]], bff);
        translate([sv18,0,0])
        extrude_linear_mss(h=mth)
        rectangle(size=[sv03-abs(sv02), sv04], vr=vrf, center=false);

        if ( bff == 0 )
        {
          translate([sv05,sv06,-mth/2])
          union()
          {
            cylinder(d=sv07, h=mth*2);
            translate([0,-sv07/2,0])
            cube([sv07,sv07,mth*2]);
          }
        }
        else
        {
          translate([0,sv06,-mth/2])
          union()
          {
            cylinder(d=sv07, h=mth*2);
            translate([-sv07,-sv07/2,0])
            cube([sv07,sv07,mth*2]);
          }
        }
      }

      // tab to bracket offset
      toh  = sv10;
      translate([sv02,sv01-toh+mth,0])
      extrude_linear_mss(h=mth)
      rectangle(size=[sv03-abs(sv02), toh], vr=[0,toh/1.75,0,0], vrm=2, center=false);

      // tab fillet
      tbfl = select_ci( [sv03-sv02, sv03+sv02+sv18], bff);
      tbfo = select_ci( [sv02, 0], bff);
      translate([tbfo,sv01-tbf,0])
      mirror([0,1,1])
      rotate([0,90,0])
      extrude_linear_mss(h=tbfl)
      polygon([[tbf,tbf], [tbf,0], [0,0]]);

      // bracket
      vrf  = select_ci( [[4.00,4.00,0,2.5], [4.00,4.00,1.5,0]], bff);
      vrmf = select_ci( [15, 3], bff);
      extrude_linear_mss(h=mth)
      rectangle(size=[sv05, sv01-toh+mth+eps*4], vr=vrf, vrm=vrmf, center=false);

      // bottom tab with bend
      btx  = sv05-sv11*2;
      bty1 = sv12-sv01-sv20;
      bty2 = sv20;

      translate([sv11,-bty1-eps*2,0])
      extrude_linear_mss(h=mth)
      rectangle(size=[btx, bty1 + eps*4], center=false);

      translate([sv11,-bty1-bty2-mth*sin(sv19),-bty2*sin(sv19)])
      rotate([sv19, 0, 0])
      union()
      {
        extrude_linear_mss(h=mth)
        rectangle(size=[btx, bty2], vr=[1.5,1.5,0,0], vrm=0, center=false);
        translate([0,bty2,mth/2]) rotate([0,90,0]) cylinder(d=mth, h=btx);
      }

      // ribs
      for (x=brc)
      {
        translate([x*brd, coo, mth/2])
        rotate([270,0,0])
        difference()
        {
          if (brs == 0)
          {
            union()
            {
              cylinder(d=brd, h=col-brd);
              sphere(d=brd);
              translate([0,0,col-brd])
              sphere(d=brd);
            }
          }
          else
          {
            union()
            {
              extrude_linear_mss(h=col-brd)
              ellipse(size=[1,1/2]*brd);
              rotate([0,90,0])
              ellipsoid([1,2]*brd);
              translate([0,0,col-brd])
              rotate([0,90,0])
              ellipsoid([1,2]*brd);
            }
          }


          translate([-brd*2,-brd*brm,-brd]/2)
          cube([brd*2,brd,col+brd]*(1+eps));
        }
      }

      // board mount tabs
      for (n = tabs)
      {
        ty = defined_e_or(n, 0, n);    // y-offset vector[0] or scalar
        tx = defined_e_or(n, 1, 9.40); // x-offset or standard
        hd = defined_e_or(n, 2, 4);    // hole diameter or standard

        tt = mtt;
        tl = tx+hd;
        tw = hd*2;

        translate([sv05, sv01-tw/2-ty, -eps])
        rotate([0,-90,0])
        difference()
        {
          union()
          {
            extrude_linear_mss(h=tt)
            rectangle(size=[tl, tw], vr=[0,hd/2,hd/2,0], center=false);
            translate([tbf+mth,0,tt])
            rotate([270,180,0])
            mirror([0,0,0])
            extrude_linear_mss(h=tw)
            polygon([[tbf,tbf], [tbf,0], [0,0]]);
          }
          translate([tx, tw/2, -tt/2])
          cylinder(d=hd, h=tt*2);
        }
      }

      // edge fins
      for (x = [[0,0], [1,sv05-mth]])
      {
        if ( binary_bit_is(fins, first(x), 1) )
        translate([second(x),coo-mth,mth*3-eps])
        rotate([0,90,0])
        extrude_linear_mss(h=mth)
        rectangle(size=[mth*2, sv08], vr=[1,0,0,1]*mth*1.5, center=false);
      }
    }

    // vent holes
    vho = coo + col/2 - (vhc-1)*vhs/2;
    if (vhc > 0)
    {
      for (y=[1:vhc])
      {
        translate([sv05/2, vho + (y-1)*vhs, -mth/2-mth])
        extrude_linear_mss(h=mth*4)
        ngon(n=6, r=vhr, vr=vhr/2);
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
    include <parts/3d/computer/pci_bracket.scad>;

    pci_bracket
    (
       form = 1,
       fins = 3,
      vents = [4],
       ribs = [3,1,8, [2,3,4,5,6]],
       tabs = [55, [20,undef,5.5]],
      align = [1,6,6],
        $fn = 36
    );

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "left right back diag";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//

