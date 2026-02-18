//! A finger joint (box joint) box generator for CNC cut-based fabrication.
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

    \amu_define group_name  (Finger Joint Box Generator)
    \amu_define group_brief (Finger joint (box joint) box generator.)

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
    models/2d/joint/box_screw.scad
  )
  \amu_include (include/amu/includes_required.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//! Generate a 2D box design using screw-based finger joint (box-joint).
/***************************************************************************//**
  \param  mth           <decimal> material thickness.

  \param  size          <decimal-list-3 | decimal> box size; a list
                        [x, y, z] or a single decimal for (x=y=z).

  \param  joint_pin     <decimal-list-5 | decimal> joint pin
                        configuration.

  \param  joint_screw   <decimal-list-2 | decimal> joint screw
                        configuration.

  \param  joint_nut     <decimal-list-4 | decimal> joint nut
                        configuration.

  \param  joint_form    <integer> joint form.

  \param  joint_mode    <integer> joint mode.

  \param  joint_spacing <decimal-list-3 | decimal> minimum separation
                        between joint pins; a list [x, y, z] or a
                        single decimal for (x=y=z).

  \param  joints_max    <integer-list-3 | integer> maximum pin sets for
                        sides [x, y, z] or a single integer for (x=y=z).

  \param  vr            <decimal-list-3-list-4 | decimal> box rounding
                        (see below).

  \param  vrm           <integer-list-3-list-4 | integer> box rounding
                        mode (see below).

  \param  side_spacing  <decimal> separation between box sides.

  \param  layout        <integer> layout selection {0 | 1 | 2}.

  \param  mode          <integer> construction mode (see below).

  \details

    Creates a 2D box layout with straight finger joints and optional
    screw fasteners. The resulting geometry can be rendered to SVG or
    DXF for CNC cutting, or extruded to a specified material thickness
    for fabrication using a 3D printer.

    ### joint_*

    The joints are constructed using the module joint2d_box_screw().
    For clarity, all related parameters in this context are prefixed
    with \p joint_. The joint module supports configurable interior and
    exterior corner rounding to compensate for cutting tool diameter, a
    technique commonly referred to as dogbone corner relief. Refer to
    the joint2d_box_screw() module documentation for detailed
    information on the expected data types and configuration scheme.

    ### vr and vrm

    The box sides can be rounded together or independently using the
    parameters \p vr and \p vrm as show in the table below:

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | decimal-list-4 \| decimal | required  | \p vr_xy : side xy rounding
      1 | decimal-list-4 \| decimal | vr_xy     | \p vr_xz : side xz rounding
      2 | decimal-list-4 \| decimal | vr_xz     | \p vr_yz : side yz rounding

    The vertices of each side can be rounded independently by assigning
    values using a four-element list, or they can all be assigned the
    same value by setting the side rounding to a single value.

    The rounding mode follows the same scheme described above. For more
    information on rounding options, see polygon_round_eve_all_p().

    ### mode

    Integer value is binary encoded.

      b | description
    ---:|:---------------------------------------
      0 | size is specified for box interior
      1 | add top side to close box
      2 | trim each joint to within its width
      3 | extrude 2d layout for 3d printing

    \amu_define scope_id      (example)
    \amu_define title         (2d box example)
    \amu_define image_views   (top)
    \amu_define image_size    (sxga)

    \amu_include (include/amu/scope_diagrams_3d.amu)

    \amu_define scope_id      (example_assemled)
    \amu_define title         (Assembled box example)
    \amu_define image_views   (top front right diag)
    \amu_define image_size    (sxga)
    \amu_define image_columns (4)
    \amu_define output_scad   (false)

    \amu_include (include/amu/scope_diagrams_3d.amu)

  \todo

    (1) Support side-wall joint edge inset(s).
    (2) Support individual wall output in 2d layouts.
    (3) Support addition of horizontal and vertical interior walls.
    (4) Support  addition of upper design areas for non-closed boxes
        (ie: for handle holes).
    (5) Support  hole instance specifications.
*******************************************************************************/
module box2d_finger_joint
(
  mth = 1,
  size,

  joint_pin,
  joint_screw,
  joint_nut,
  joint_form = 7,
  joint_mode = 0,
  joint_spacing,
  joints_max,

  vr,
  vrm,

  side_spacing,
  layout = 0,

  mode = 0
)
{
  //
  // construct a side
  //
  module construct_side( size, insts, vr, vrm )
  {
    //
    // construct a side joint
    //
    module construct_joint( size, count, offset, axis, sides, type )
    {
      side_length   = axis == 1 ? size.x : size.y;
      side_offset   = type == 2 ? -1 : +1;

      joint_length  = first(pin_conf) * 2 + second(pin_conf) + offset;
      joint_count   = min(count, max(1, floor(side_length / joint_length)));

      if (joint_count > 0)
      for (s = sides)
      translate
      (
        axis == 0 ?
          [ s * (size.x/2 + mth/2 * side_offset), 0 ]
        : [ 0, s * (size.y/2 + mth/2 * side_offset) ]
      )
      rotate(axis == 0 ? -90 : 0)
      translate([joint_length/2 - (joint_length * joint_count)/2, 0])
      mirror(s < 0 ? [0, 1] : [0, 0])
      mirror(type == 2 ? [0, 1] : [0, 0])
      joint2d_box_screw
      (
        conf = [ side_length, mth, pin_conf, screw_conf, nut_conf ],
        insts = [ for ( i = [0 : joint_count - 1] ) [0, joint_length * i, joint_form ] ],
        mode = joint_mode,
        type = type,
        trim = trim,
        align = [0, 1]
      );
    }

    // assemble side with joint
    difference()
    {
      // instance additions
      for (i = insts)
      {
        count   = i[0];
        offset  = i[1];
        axis    = i[2];
        sides   = i[3];
        type    = i[4];

        polygon
        (
          let
          (
            x = size.x/2, y = size.y/2,

            // centered square
            c = [[x, -y], [x, y], [-x, y], [-x, -y]],

            // round if defined
            p = is_undef( vr ) ? c : polygon_round_eve_all_p(c=c, vr=vr, vrm=vrm)
          )
          p
        );

        if ( type == 0 )
        construct_joint( size=size, count=count, offset=offset, axis=axis, sides=sides, type=0 );
      }

      // instance removals
      for (i = insts)
      {
        count   = i[0];
        offset  = i[1];
        axis    = i[2];
        sides   = i[3];
        type    = i[4];

        size_ro = size + [eps, eps] * 8;

        if ( type == 0 )
        construct_joint( size=size_ro, count=count, offset=offset, axis=axis, sides=sides, type=1 );

        if ( type == 2 )
        construct_joint( size=size_ro, count=count, offset=offset, axis=axis, sides=sides, type=2 );
      }
    }
  }

  //
  // layout in 2d
  //
  module layout_2d( gap, select )
  {
    side_offset_x = (select == 0) ?
                    (side_xy.x + side_yz.x)/2 + gap - mth
                  : (side_xy.x + side_yz.y)/2 + gap;

    side_offset_y = (side_xy.y + side_xz.y)/2 + gap;

    for (side = close ? [0, 2] : [0])
    let
    (
      r = side > 0 ? 0 : 180,

      t = [0, side_offset_y * side]
    )
    translate(t) rotate(r)
    construct_side( size=side_xy, insts=insts_xy, vr=vr_xy, vrm=vrm_xy );

    for (side = [-1, 1])
    let
    (
      r = side > 0 ? 0 : 180,

      t = [0, side_offset_y * side]
    )
    translate(t) rotate(r)
    construct_side( size=side_xz, insts=insts_xz, vr=vr_xz, vrm=vrm_xz );

    for (side = [-1, 1])
    let
    (
      r = (select == 0) ?
          side > 0 ? 0 : 180
        : side > 0 ? 270 : 90,

      t = (select == 0) ?
          [side_offset_x * side, side_offset_y * side]
        : [side_offset_x * side, 0]
    )
    translate(t) rotate(r)
    construct_side( size=side_yz, insts=insts_yz, vr=vr_yz, vrm=vrm_yz );
  }

  //
  // layout in 3d
  //
  module layout_3d( gap )
  {
    color("blue")
    for (s = close ? [-1, 1] : [-1])
    translate([0, 0, (box_z/2 - mth/2 + gap) * s + (close ? 0 : -mth/2)])
    extrude_linear_uss(mth, center=true)
    construct_side( size=side_xy, insts=insts_xy, vr=vr_xy, vrm=vrm_xy );

    color("green")
    for (s = [-1, 1])
    translate([0, (box_y/2 + gap) * s, 0])
    rotate(s > 0 ? [90, 0, 0] : [90, 0, 180])
    extrude_linear_uss(mth)
    construct_side( size=side_xz, insts=insts_xz, vr=vr_xz, vrm=vrm_xz );

    color("gray")
    for (s = [-1, 1])
    translate([ (box_x/2 - mth + gap) * s, 0, 0])
    rotate(s > 0 ? [90, 0, 90] : [90, 0, 270])
    extrude_linear_uss(mth)
    construct_side( size=side_yz, insts=insts_yz, vr=vr_yz, vrm=vrm_yz );
  }

  //
  // decode and assign defaults to undefined parameters
  //

  // decode mode configurations
  inside        = binary_bit_is(mode, 0, 1);
  close         = binary_bit_is(mode, 1, 1);
  trim          = binary_bit_is(mode, 2, 1);
  extrude       = binary_bit_is(mode, 3, 1);

  box_p_x       = defined_eon_or(size, 0, mth*10);
  box_p_y       = defined_e_or  (size, 1, box_p_x);
  box_p_z       = defined_e_or  (size, 2, box_p_y);

  pin_conf      = defined_or(joint_pin, [mth, mth * 5/2]);

  pin_offset_x  = defined_eon_or(joint_spacing, 0, second(pin_conf));
  pin_offset_y  = defined_e_or  (joint_spacing, 1, pin_offset_x);
  pin_offset_z  = defined_e_or  (joint_spacing, 2, pin_offset_y);

  max_sets_x    = defined_eon_or(joints_max, 0, number_max);
  max_sets_y    = defined_e_or  (joints_max, 1, max_sets_x);
  max_sets_z    = defined_e_or  (joints_max, 2, max_sets_y);

  screw_conf    = defined_or(joint_screw, mth/3);
  nut_conf      = defined_or(joint_nut, mth*2/3);

  side_offset   = defined_or(side_spacing, mth);

  vr_xy         = defined_eon_or(vr, 0, 0);
  vr_xz         = defined_e_or  (vr, 1, vr_xy);
  vr_yz         = defined_e_or  (vr, 2, vr_xz);

  vrm_xy        = defined_eon_or(vrm, 0, 1);
  vrm_xz        = defined_e_or  (vrm, 1, vrm_xy);
  vrm_yz        = defined_e_or  (vrm, 2, vrm_xz);

  //
  // side and joint instances
  //

  box_x         = inside ? box_p_x + mth*2 : box_p_x;
  box_y         = inside ? box_p_y + mth*2 : box_p_y;
  box_z         = inside ? box_p_z + mth*2 : box_p_z;

  side_xy       = [ box_x,         box_y ];
  side_xz       = [ box_x - mth*2, box_z - (close ? mth*2 : mth) ];
  side_yz       = [ box_y,         box_z - (close ? mth*2 : mth) ];

  insts_xy  =
  [
    [max_sets_y, pin_offset_y, 0, [-1, +1], 2],
    [max_sets_x, pin_offset_x, 1, [-1, +1], 2]
  ];

  insts_xz  =
  [
    [max_sets_z, pin_offset_z, 0, [-1, +1], 0],
    [max_sets_x, pin_offset_x, 1, close ? [-1, +1] : [-1], 0]
  ];

  insts_yz  =
  [
    [max_sets_z, pin_offset_z, 0, [-1, +1], 2],
    [max_sets_y, pin_offset_y, 1, close ? [-1, +1] : [-1], 0]
  ];

  //
  // construct box layout
  //

  if ( layout > 1)
  {
    layout_3d( gap=side_offset );
  }
  else
  {
    if ( extrude )
    {
      extrude_linear_uss( mth, center=false )
      layout_2d( gap=side_offset, select=layout );
    }
    else
    {
      layout_2d( gap=side_offset, select=layout );
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
    include <models/2d/joint/box_screw.scad>;
    include <parts/2d/enclosure/box_finger_joint.scad>;

    box2d_finger_joint
    (
      mth   = 2,
      size  = [60, 30, 20],

      joint_pin     = [4, 6, 1/2, 1/2, 1/2],
      joint_screw   = [3/2, 5],
      joint_nut     = [3, 3/2],
      joint_spacing = 12,
      joints_max    = [3, 1, 1],

      vr            = 2
    );

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

/*
BEGIN_SCOPE example_assemled;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <tools/operation_cs.scad>;
    include <models/2d/joint/box_screw.scad>;
    include <parts/2d/enclosure/box_finger_joint.scad>;

    box2d_finger_joint
    (
      mth   = 2,
      size  = [60, 30, 20],

      joint_pin     = [4, 6, 1/2, 1/2, 1/2],
      joint_screw   = [3/2, 5],
      joint_nut     = [3, 3/2],
      joint_spacing = 12,
      joints_max    = [3, 1, 1],

      vr            = 2,

      mode    = 2,
      layout  = 2
    );

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "top front right diag";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//

