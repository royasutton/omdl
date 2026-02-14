//! Models for constructing 3d box joints with optional screw and nut fastener.
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

    \amu_define group_name  (Box Screw)
    \amu_define group_brief (Models for generating 3d box joints fastened with screw and nut.)

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

//! Construct a 3d box joint with optional screw and nut fastener.
/***************************************************************************//**

  \param  h       <decimal> box joint height.

  \param  conf    <datastruct> box joint length, depth, pin configuration
                  and screw configuration (see below).

  \param  insts   <datastruct> box joint instance list (see below).

  \param  mode    <integer> global construction mode.

  \param  type    <integer> construction type {0=male additions,
                  1=male removals, 2=female removals}.

  \param  align   <integer-list-3> joint alignment; center, edge-1, and
                  edge-2 for [x, y, z].

  \details

    Use this module to construct 3d box-joints with optional screw and
    locking nut, as illustrated in the example below.

    Set \p type = 0 to construct the male half, and set \p type = 2 to
    for the corresponding female half. To ensure proper alignment and
    fit, both components must be constructed using identical
    configuration parameters.

    When producing interlocking joints with 3D-printed plastics,
    carefully control the joint clearance. Most printed plastics are
    relatively rigid, so insufficient gap allowance can lead to poor
    assembly or excessive friction.

    For CNC routers and laser cutters, the interior and exterior corner
    radii can be adjusted to accommodate tooling limitations. This
    allows flat internal mating surfaces to be maintained while
    compensating for the minimum practical radius imposed by the cutter
    diameter.

    ## Multi-value and structured parameters

    ### conf

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | <decimal>         |  required         | \p l : joint length
      1 | <decimal>         |  l/10             | \p d : joint depth
      2 | <datastruct \| decimal> |  d          | pin default configuration
      3 | <datastruct>      |  undef            | screw bore default configuration

    #### conf[2]: pin

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | <decimal>         |  d                | \p m : male pin width
      1 | <decimal>         |  m * 5/2          | screw section width
      2 | <decimal>         |  m / 25           | pin gap width
      3 | <decimal>         |  m / 20           | pin exterior edge rounding
      4 | <decimal>         |  m / 20           | pin interior edge rounding

    #### conf[3]: screw bore

    ##### Data structure schema: screw bore

    name            | schema
    ---------------:|:----------------------------------------------
    screw bore      | [  d, l, h, n, t, s, f ]

    ##### Data structure fields: screw bore

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | <decimal>         |  d / 6            | \p d : bore diameter
      1 | <decimal>         |  d * 3/2          | \p l : bore length
      2 | <decimal-list-5>  |                   | \p h : fastener head
      3 | <decimal-list-5>  |                   | \p n : fastener nut
      4 | <decimal-list-2>  |                   | \p t : bore tolerance
      5 | <decimal-list-list-3> |               | \p s : nut slot cutout
      6 | <decimal-list-2 \| decimal> |         | \p f : bore scale factor

    The screw bore is defined using the data structure described above.
    This structure includes seven parameters, all of which are
    documented in screw_bore().

    ### insts

    #### Data structure schema: insts

    name            | schema
    ---------------:|:----------------------------------------------
    insts           | [  inst, inst, ..., inst  ]

    #### Data structure fields: inst

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | <decimal>         |  0                | zero reference; [-1, 0, +1]
      1 | <decimal>         |  0                | length offset from reference
      2 | <integer>         |  7                | form (see below).
      3 | <integer>         |                   | mode override (see below).
      4 | <datastruct \| decimal> |             | pin override (see above).
      5 | <datastruct \| decimal> |             | screw override (see above).
      6 | <datastruct \| decimal> |             | nut override (see above).

    #### insts[2]: form

    Integer value is binary encoded.

      b | description
    ---:|:---------------------------------------
      0 | construct left pin at negative side of instance
      1 | construct right pin at positive side of instance
      2 | construct screw and nut section of instance

    ### mode

    Integer value is binary encoded.

      b | description
    ---:|:---------------------------------------
      0 | female removal; interior vs exterior rounding
      1 | female removal; interior corner over cut placement

    \amu_define scope_id      (example)
    \amu_define title         (Box screw joint example)
    \amu_define image_views   (top diag)
    \amu_define image_size    (sxga)

    \amu_include (include/amu/scope_diagrams_3d.amu)
*******************************************************************************/

module joint3d_box_screw
(
  h = 1,
  conf,
  insts,
  mode = 0,
  type = 0,
  align
)
{
  // construct 2d box joint at origin
  module box_screw( iform=7, imode=mode, ipin=pin, ibore=ibore )
  {
    /*
        iform

        B0: left pin (negative side)
        B1: right pin (positive side)
        B2: center screw
    */

    // decode ipin
    t1 = defined_fle_or([ipin, pin], 0, ipin);        // male pin width
    t2 = defined_fle_or([ipin, pin], 1, t1*5/2);      // screw section width
    tg = defined_fle_or([ipin, pin], 2, t1/25);       // pin gap width
    er = defined_fle_or([ipin, pin], 3, t1/20);       // pin exterior edge rounding
    ir = defined_fle_or([ipin, pin], 4, t1/20);       // pin interior edge rounding

    // decode ibore; screw bore parameters
    //  see screw_bore() for details
    sd = defined_fle_or([ibore, bore], 0, depth/6);
    sl = defined_fle_or([ibore, bore], 1, depth*3/2);
    sh = defined_fle_or([ibore, bore], 2, undef);
    sn = defined_fle_or([ibore, bore], 3, undef);
    st = defined_fle_or([ibore, bore], 4, undef);
    ss = defined_fle_or([ibore, bore], 5, undef);
    sf = defined_fle_or([ibore, bore], 6, undef);

    // decode imode
    m0 = binary_bit_is(imode, 0, 0);                  // female removal; interior vs exterior rounding
    m1 = binary_bit_is(imode, 1, 0);                  // female removal; interior corner over cut placement

    fvrm = m0 ? [0,0,4,3] : [0,0,0,0];                // rounding mode selections

    sg = (type == 2) ?  1 : -1;                       // gap adjustment
    s1 = t1 + sg * tg/2;                              // pin sized for gap

    // add enabled pins only
    pins =
    [
      if( binary_bit_is(iform, 0, 1) ) -1,
      if( binary_bit_is(iform, 1, 1) ) +1
    ];

    // pin; female removal or male additions
    if (type == 0 || type == 2)
    for ( i = pins )
    extrude_linear_uss(h=h, center=true)
    translate ([(t1 + t2)/2*i, depth/2])
      pg_rectangle([s1, depth], vr=er, vrm=(type == 2) ? fvrm : [1,1,0,0], center=true);

    // interior corner minimum cut radius; removal modes only
    if ( ir > 0 && (type == 1 || type == 2) )
    for
    (
      i = pins,

      mcr_o =
        (type == 2) ?
          m0 ?
            [ // type=0, m0=1, m1=[0,1]; female with rounding at edge
              for (j = [-1,1])
                m1 ? [ j*(s1-ir)/2, depth ]
                   : [ j*s1/2, depth-ir/2 ]
            ]
          : [ // type=0, m0=0, m1=[0,1]; female with rounding in field
              for (j = [-1,1], k = [-1,1])
                m1 ? [ j*(s1-ir)/2, depth/2 + k*depth/2 ]
                   : [ j*s1/2, depth/2 + k*(depth-ir)/2 ]
            ]
      :   [ // type=1,2; male
            for (j = [-1,1])
              [ j*(s1+ir)/2, 0 ]
          ]
    )
    translate ([(t1 + t2)/2*i, 0] + mcr_o)
    cylinder(d=ir, h=h, center=true);

    // screw bore
    if ( binary_bit_is(iform, 2, 1) )
    {
      // screw bore; female removal
      if (type == 2)
      translate ([0, depth/2, h/2])
      screw_bore(d=sd, l=sl, h=sh, n=sn, t=st, s=ss, f=sf, a=1);

      // screw bore; male removal
      if (type == 1)
      translate([0, depth, 0])
      rotate([270, 0, 0])
      screw_bore(d=sd, l=sl, h=sh, n=sn, t=st, s=ss, f=sf, a=1);
    }
  }

  // decode configuration
  length  = defined_e_or(conf, 0, conf);
  depth   = defined_e_or(conf, 1, length/10);
  pin     = defined_e_or(conf, 2, depth);
  bore    = defined_e_or(conf, 3, undef);

  // align construction
  translate
  (
    [
      select_ci( [ 0, +length/2, -length/2 ], defined_e_or(align, 0, 0), false ),
      select_ci( [ 0, -depth/2, -depth ], defined_e_or(align, 1, 0), false ),
      select_ci( [ 0, +h/2, -h/2 ], defined_e_or(align, 2, 0), false )
    ]
  )
  for ( i = insts )
  {
    zero    = defined_e_or(i, 0, 0);
    offset  = defined_e_or(i, 1, 0);
    iform   = defined_e_or(i, 2, 7);

    imode   = defined_e_or(i, 3, mode);
    ipin    = defined_e_or(i, 4, pin);
    ibore   = defined_e_or(i, 5, bore);

    translate([ length/2 * zero + offset, 0 ])
    box_screw( iform=iform, imode=imode, ipin=ipin, ibore=ibore );
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
    include <models/3d/joint/box_screw.scad>;

    $fn = 36;

    h = 3;
    w = [50, 3];

    mode = 1 + 2;

    pin = [5, 5, 1/4, 1/3, 1/3];

    bore =
    [
      1,
      5,
      [2, 1/2, 1/2],
      [2, 3/4, 0],
      undef,
      [0, [-2, +2]],
      [1 + 10/100, 1]
    ];

    conf = [ w.x, w.y, pin, bore ];

    insts =
    [
      [-1, +3,   2+4],
      [+0, +0, 1+2+4, 1+4+16, [3]],
      [+1, -3,   1+4],
    ];

    translate([0, -w.y])
    rotate([90, 0, 0])
    {
      joint3d_box_screw(h=h, conf=conf, insts=insts, mode=mode, type=0);
      difference()
      {
        translate([0, -w.y*3/4]) cube([w.x, w.y * 3/2, h], center=true);
        joint3d_box_screw(h=h, conf=conf, insts=insts, mode=mode, type=1);
      }
    }

    translate([0, w.y])
    difference()
    {
      translate([0, w.y/2]) cube([w.x, w.y*3/2, h], center=true);
      joint3d_box_screw(h=h+eps*8, conf=conf, insts=insts, mode=mode, type=2);
    }

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "top diag";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//

