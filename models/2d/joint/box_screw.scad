//! Models for generating 2d box joints fastened with screw and nut.
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
    \amu_define group_brief (Models for generating 2d box joints fastened with screw and nut.)

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

//! Create 2d edge profiles for screw and nut box joint construction.
/***************************************************************************//**

  \param  conf    <datastruct> box joint length, depth, pin configuration
                  and screw configuration (see below).

  \param  insts   <datastruct> box joint instance list (see below).

  \param  mode    <integer> global construction mode.

  \param  type    <integer> construction type {0=male additions,
                  1=male removals, 2=female removals}.

  \param  trim    <boolean> limit construction to within the total
                  joint width.

  \param  align   <integer-list-2> joint alignment; edge-1, center, and
                  edge-2 for both [x, y].

  \details

    Use this module to generate a 2d profile for constructing box-joint
    pairs with a central screw and locking nut, as illustrated in the
    example below.

    Set \p type = 0 to create the male finger profile, and set \p type
    = 2 to generate the corresponding female slot profile. To ensure
    proper alignment and fit, both components must be created using
    identical configuration parameters.

    When producing interlocking joints with 3D-printed plastics,
    carefully control the joint clearance. Most printed plastics are
    relatively rigid, so insufficient gap allowance can lead to poor
    assembly or excessive friction.

    For CNC routers and laser cutters, the interior and exterior corner
    radii can be adjusted to accommodate tooling limitations. This
    allows flat internal mating surfaces to be maintained while
    compensating for the minimum practical radius imposed by the cutter
    diameter (commonly called dogbone corner relief).

    ## Multi-value and structured parameters

    ### conf

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | decimal           |  required         | \p l : joint length
      1 | decimal           |  l/10             | \p d : joint depth
      2 | decimal-list-5 \| decimal   |  d      | pin default configuration
      3 | decimal-list-2 \| decimal   |  d/6    | screw default configuration
      4 | decimal-list-4 \| decimal   |  d/3    | nut default configuration

    #### conf[2]: pin

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | decimal           |  d                | \p m : male pin width
      1 | decimal           |  m * 5/2          | screw section width
      2 | decimal           |  m / 25           | pin gap width
      3 | decimal           |  m / 20           | pin exterior edge rounding
      4 | decimal           |  m / 20           | pin interior edge rounding

    #### conf[3]: screw

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | decimal           |  d/6              | \p sd : screw diameter
      1 | decimal           |  d                | \p sl : screw length

    #### conf[4]: nut

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | decimal           |  d/3              | nut size; flat-to-flat
      1 | decimal           |  sd               | nut height
      2 | decimal           |  sl / 10          | nut end offset
      3 | decimal           |  m / 20           | nut interior edge rounding

    ### insts

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | decimal           |  0                | zero reference; [-1, 0, +1]
      1 | decimal           |  0                | length offset from reference
      2 | integer           |  7                | form (see below).
      3 | integer           |                   | mode override (see below).
      4 | decimal-list-5 \| decimal |           | pin override (see above).
      5 | decimal-list-2 \| decimal |           | screw override (see above).
      6 | decimal-list-4 \| decimal |           | nut override (see above).

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
      2 | male removal; screw bore vs skip screw bore
      3 | male removal; screw nut vs skip screw nut
      4 | male removal; add screw bore drill punch mark

    \amu_define scope_id      (example)
    \amu_define title         (Box screw joint profile example)
    \amu_define image_views   (top)
    \amu_define image_size    (sxga)

    \amu_include (include/amu/scope_diagrams_3d.amu)
*******************************************************************************/

module joint2d_box_screw
(
  conf,
  insts,

  mode = 0,
  type = 0,

  trim = false,

  align
)
{
  // construct 2d box joint at origin
  module box_screw( iform=7, imode=mode, ipin=pin, iscrew=screw, inut=nut )
  {
    /*
        iform

        B0: left pin (negative side)
        B1: right pin (positive side)
        B2: center screw
    */

    // decode imode
    m0 = binary_bit_is(imode, 0, 0);                  // female removal; interior vs exterior rounding
    m1 = binary_bit_is(imode, 1, 0);                  // female removal; interior corner over cut placement
    m2 = binary_bit_is(imode, 2, 0);                  // male removal; screw bore vs skip screw bore
    m3 = binary_bit_is(imode, 3, 0);                  // male removal; screw nut vs skip screw nut
    m4 = binary_bit_is(imode, 4, 1);                  // male removal; add screw bore drill punch mark

    // decode ipin
    t1 = defined_fle_or([ipin, pin], 0, ipin);        // male pin width
    t2 = defined_fle_or([ipin, pin], 1, t1*5/2);      // screw section width
    tg = defined_fle_or([ipin, pin], 2, t1/25);       // pin gap width
    er = defined_fle_or([ipin, pin], 3, t1/20);       // pin exterior edge rounding
    ir = defined_fle_or([ipin, pin], 4, t1/20);       // pin interior edge rounding

    // decode iscrew
    sd = defined_fle_or([iscrew, screw], 0, iscrew);  // screw diameter
    sl = defined_fle_or([iscrew, screw], 1, depth);   // screw length

    // decode inut
    ns = defined_fle_or([inut, nut], 0, inut);        // nut size; flat-to-flat
    nh = defined_fle_or([inut, nut], 1, sd);          // nut height
    no = defined_fle_or([inut, nut], 2, sl/10);       // nut end offset
    nr = defined_fle_or([inut, nut], 3, t1/20);       // nut interior edge rounding

    fvrm = m0 ? [0,0,4,3] : [0,0,0,0];                // rounding mode selections

    sg = (type == 2) ?  1 : -1;                       // gap adjustment
    s1 = t1 + sg * tg/2;                              // pin sized for gap

    // add enabled pins only
    pins =
    [
      if( binary_bit_is(iform, 0, 1) ) -1,
      if( binary_bit_is(iform, 1, 1) ) +1
    ];

    // male and female joint construction; male additions or female removals
    if (type == 0 || type == 2)
    intersection_cs(trim, trim ? undef : 1)
    {
      // child-0: joint trim area = length x depth
      translate ([0, depth/2])
      square([length, depth], center=true);

      // child-1: pin; male additions or female removals
      for ( i = pins )
      translate ([(t1 + t2)/2*i, depth/2])
        pg_rectangle([s1, depth], vr=er, vrm=(type == 2) ? fvrm : [1,1,0,0], center=true);
    }

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
    circle(d=ir);

    // screw
    if ( binary_bit_is(iform, 2, 1) )
    {
      // screw hole; female removal
      if (type == 2)
      translate ([0, depth/2])
      circle(d=sd);

      // screw and nut slot; male removal
      if (type == 1)
      {
        // screw
        if ( m2 )
        translate([0, -sl/2])
        square([sd, sl], center=true);

        // nut
        if ( m3 )
        translate([0, -sl + nh/2 + no])
        {
          square([ns, nh], center=true);

          // over-cut compensation for cutter radius
          if (nr > 0)
          for ( x=[-1,1], y=[-1,1] )
          translate([ns/2*x, (nh -nr)/2*y])
          circle(d=nr);
        }

        // drill punch
        if ( m4 )
        rotate(45)
        square([sd, sd]/2, center=true);
      }
    }
  }

  // decode configuration
  length  = defined_e_or(conf, 0, conf);
  depth   = defined_e_or(conf, 1, length/10);
  pin     = defined_e_or(conf, 2, depth);
  screw   = defined_e_or(conf, 3, depth/6);
  nut     = defined_e_or(conf, 4, depth/3);

  // align construction
  translate
  (
    [
      select_ci( [ 0, -length/2, +length/2 ], defined_e_or(align, 0, 0), false ),
      select_ci( [ 0, -depth/2, -depth ], defined_e_or(align, 1, 0), false ),
    ]
  )
  for ( i = insts )
  {
    zero    = defined_e_or(i, 0, 0);
    offset  = defined_e_or(i, 1, 0);
    iform   = defined_e_or(i, 2, 7);

    imode   = defined_e_or(i, 3, mode);
    ipin    = defined_e_or(i, 4, pin);
    iscrew  = defined_e_or(i, 5, screw);
    inut    = defined_e_or(i, 6, nut);

    translate([ length/2 * zero + offset, 0 ])
    box_screw( iform=iform, imode=imode, ipin=ipin, iscrew=iscrew, inut=inut );
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
    include <models/2d/joint/box_screw.scad>;

    w = [50, 3];

    conf =
    [
      w.x,
      w.y,
      [3, 6, 1/8, 1/3, 1/3],
      [1/2, w.y, 1, 1/2]
    ];

    insts =
    [
      [-1, +3,   2+4],
      [+0, +0, 1+2+4, 1+4+16],
      [+1, -3, 1  +4],
    ];

    mode = 1 + 2;

    translate([0,-w.y])
    {
      joint2d_box_screw(conf=conf, insts=insts, mode=mode, type=0);
      difference()
      {
        translate([0, -w.y*3/4]) square([w.x, w.y * 3/2], center=true);
        joint2d_box_screw(conf=conf, insts=insts, mode=mode, type=1);
      }
    }

    translate([0,w.y/2])
    difference()
    {
      translate([0, w.y/2]) square([w.x, w.y*3/2], center=true);
      joint2d_box_screw(conf=conf, insts=insts, mode=mode, type=2);
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

