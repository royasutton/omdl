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

  \amu_include (include/amu/doxyg_init_pd_gds_ipg.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group and macros.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/doxyg_define_in_parent_open.amu)
  \amu_define includes_required_add
  (
    shapes/select_common_2d.scad
    transforms/base_cs.scad
    transforms/layout.scad
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

  \param  side_holes    <datastruct> box side hole instances (see below).

  \param  side_add      <point-2d-list-4-list> coordinate points to
                        merge into the box xz and yz sides.

  \param  vr            <decimal-list-6-list-n | decimal> box rounding;
                        where `n = 4` for rectangular sides. (see below).

  \param  vrm           <integer-list-6-list-n | integer> box rounding
                        mode where `n = 4` for rectangular sides. (see
                        below).

  \param  side_spacing  <decimal> separation between box sides.

  \param  layout        <integer> layout selection {0 | 1 | 2}.

  \param  mode          <integer> construction mode (see below).

  \param  part          <integer> side output selection (see below).

  \param  verb          <integer> output console verbosity.

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

    ### side_holes

    #### Data structure schema:

    name            | schema
    ---------------:|:----------------------------------------------
    side_holes      | [instances]
    instances       | [instance, instance, ..., instance]

    #### Data structure fields: instance

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | integer-list \| integer | required    | box side index or index list (see below)
      1 | datastruct \| integer   | 1           | 2d shape selections (see: select_common_2d_shape())
      2 | datastruct              | [0]         | shape layout (see: layout_grid_rp()

    The box side are assigned the following indices:

      v | side        | description
    ---:|:-----------:|:--------------------
      0 |  back       | side xz negative
      1 |  front      | side xz positive
      2 |  left       | side yz negative
      3 |  right      | side yz positive
      4 |  bottom     | side xy negative
      5 |  top        | side xy positive

    ### side_add

    When the box is open (no top side) individual box sides can be
    customized by merging an additional list of coordinate points into
    the side geometry. Each side may be customized independently using
    the scheme in the following table:

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | point-2d-list     |                   | \p ap_xz_1 : side xz-1
      1 | point-2d-list     |                   | \p ap_yz_1 : side yz-1
      2 | point-2d-list     |  \p ap_xz_1       | \p ap_xz_2 : side xz-2
      3 | point-2d-list     |  \p ap_yz_1       | \p ap_yz_2 : side yz-2

    The parameter \p p is ignored for closed boxes.

    ### vr and vrm

    The box sides can be rounded together or independently using the
    parameters \p vr and \p vrm as show in the table below:

      e | data type         | default value       | parameter description
    ---:|:-----------------:|:-------------------:|:------------------------------------
      0 | decimal-list-n \| decimal | required    | \p vr_xy_1 : side xy-1 rounding
      1 | decimal-list-n \| decimal | \p vr_xy_1  | \p vr_xz_1 : side xz-1 rounding
      2 | decimal-list-n \| decimal | \p vr_xz_1  | \p vr_yz_1 : side yz-1 rounding
      3 | decimal-list-n \| decimal | \p vr_xy_1  | \p vr_xy_2 : side xy-2 rounding
      4 | decimal-list-n \| decimal | \p vr_xz_1  | \p vr_xz_2 : side xz-2 rounding
      5 | decimal-list-n \| decimal | \p vr_yz_1  | \p vr_yz_2 : side yz-2 rounding

    The vertices of each side can be rounded independently by assigning
    values using a four-element list, or they can all be assigned the
    same value by setting the side rounding to a single value.

    The rounding mode follows the same scheme described above. For more
    information on rounding options, see polygon_round_eve_all_p().

    For rectangular sides `n = 4`. However, when customized side points
    are specified using the \p side_add option, the corresponding
    rounding lists size `n` must be extended to match the number of
    added points for each customized side, if individual vertex
    treatment is desired.

    ### mode

    Integer value is binary encoded.

      b | description
    ---:|:---------------------------------------
      0 | size is specified for box interior
      1 | add top side to close box
      2 | trim each joint to within its width
      3 | extrude 2d layout for 3d printing

    ### part

    Construction of each side of the box is controlled using the
    binary-encoded integer parameter \p part. Each side corresponds to
    a specific bit position according to the side index described
    above. To enable or disable a side, adjust the \p part value by
    setting or clearing the binary value associated with that side’s
    index.

    For example, to output only the bottom of the front and the bottom
    of the box, set: `part = (pow(2, 1) + pow(2, 5));`

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

    -# Support side-wall joint edge inset(s).
    -# Support addition of horizontal and vertical interior walls.
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

  side_holes,
  side_add,

  vr,
  vrm,

  side_spacing,
  layout = 0,

  mode = 0,
  part = 63,
  verb = 0
)
{
  //
  // construct a side
  //
  module construct_side( idx, size, insts, p, vr, vrm )
  {
    //
    // construct a side joint
    //
    module construct_joint( size, length, count, offset, axis, sides, type )
    {
      side_offset   = type == 2 ? -1 : +1;

      joint_length  = first(pin_conf) * 2 + second(pin_conf) + offset;
      joint_count   = min(count, max(1, floor(length / joint_length)));

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
        conf = [ length, mth, pin_conf, screw_conf, nut_conf ],
        insts = [ for ( i = [0 : joint_count - 1] ) [0, joint_length * i, joint_form ] ],
        mode = joint_mode,
        type = type,
        trim = trim,
        align = [0, 1]
      );
    }

    //
    // construct a side hole instance
    //
    module construct_hole_inst( inst )
    {
      shape       = defined_e_or (inst, 1, 1);
      layout      = defined_e_or (inst, 2, [0]);

      shape_type  = is_list(shape) ? first(shape) : shape;
      shape_argv  = is_list(shape) ? tailn(shape, 1) : undef;

      layout_grid_rp(t=layout, b=size, center=true, verb=verb-1)
      select_common_2d_shape( type=shape_type, argv=shape_argv, center=true, verb=verb-1 );

      if (verb > 1)
      {
        log_info(strl(["holes for side index = ", idx, ", conf = ", inst]));
        log_echo(strl(["hole conf = ", inst]));

        if (verb > 2)
          echo(shape_type=shape_type, shape_argv=shape_argv, layout=layout);
      }
    }

    // assemble side with joint
    difference()
    {
      // joint instance additions
      for (i = insts)
      {
        length  = i[0];
        count   = i[1];
        offset  = i[2];
        axis    = i[3];
        sides   = i[4];
        type    = i[5];

        // rectangular side shape
        polygon
        (
          let
          (
            x = size.x/2, y = size.y/2,

            c = is_undef( p ) ?
                // centered rectangular
                [[x, -y], [x, y], [-x, y], [-x, -y]]
                // centered rectangular with points 'p' at top
              : concat([[x, -y], [x, y]], p ,[[-x, y], [-x, -y]]),

            // round if defined
            p = is_undef( vr ) ? c : polygon_round_eve_all_p(c=c, vr=vr, vrm=vrm)
          )
          p
        );

        // male pins additions
        if ( type == 0 )
        construct_joint
        (
          size=size, length=length, count=count,
          offset=offset, axis=axis, sides=sides,
          type=0
        );
      }

      // joint instance removals
      for (i = insts)
      {
        length  = i[0];
        count   = i[1];
        offset  = i[2];
        axis    = i[3];
        sides   = i[4];
        type    = i[5];

        size_ro = size + [eps, eps] * 8;

        // male pins removals
        if ( type == 0 )
        construct_joint
        (
          size=size_ro, length=length, count=count,
          offset=offset, axis=axis, sides=sides,
          type=1
        );

        // female pins removals
        if ( type == 2 )
        construct_joint
        (
          size=size_ro, length=length, count=count,
          offset=offset, axis=axis, sides=sides,
          type=2
        );
      }

      // side hole instance removals
      for (i = side_holes)
      {
        // get enabled side (or side list) for instance
        e = defined_eon_or(i, 0, undef);

        if ( !is_empty( search(idx, is_list(e) ? e : [e]) ) )
          construct_hole_inst( i );
      }
    }
  }

  //
  // layout in 2d
  //
  module layout_2d( gap, select )
  {
    if (verb > 0)
      log_info(strl(["2d layout number ", select]));

    side_offset_x = (select == 0) ?
                    (side_xy.x + side_yz.x)/2 + gap - mth
                  : (side_xy.x + side_yz.y)/2 + gap;

    side_offset_y = (side_xy.y + side_xz.y)/2 + gap;

    for (side = close ? [0, 2] : [0])
    let
    (
      i   = side > 0 ? 5 : 4,

      r   = side > 0 ? 0 : 180,
      t   = [0, side_offset_y * side],

      p   = undef,
      vr  = side > 0 ? vr_xy_1  : vr_xy_2,
      vrm = side > 0 ? vrm_xy_1 : vrm_xy_2
    )
    if (binary_bit_is(part, i, 1))
    translate(t) rotate(r)
    construct_side( idx=i, size=side_xy, insts=insts_xy, p=p, vr=vr, vrm=vrm );

    for (side = [-1, 1])
    let
    (
      i   = side > 0 ? 1 : 0,

      r   = side > 0 ? 0 : 180,
      t   = [0, side_offset_y * side],

      p   = side > 0 ? ap_xz_1  : ap_xz_2,
      vr  = side > 0 ? vr_xz_1  : vr_xz_2,
      vrm = side > 0 ? vrm_xz_1 : vrm_xz_2
    )
    if (binary_bit_is(part, i, 1))
    translate(t) rotate(r)
    construct_side( idx=i, size=side_xz, insts=insts_xz, p=p, vr=vr, vrm=vrm );

    for (side = [-1, 1])
    let
    (
      i   = side > 0 ? 3 : 2,

      r   = (select == 0) ?
            side > 0 ? 0 : 180
          : side > 0 ? 270 : 90,

      t   = (select == 0) ?
            [side_offset_x * side, side_offset_y * side]
          : [side_offset_x * side, 0],

      p   = side > 0 ? ap_yz_1  : ap_yz_2,
      vr  = side > 0 ? vr_yz_1  : vr_yz_2,
      vrm = side > 0 ? vrm_yz_1 : vrm_yz_2
    )
    if (binary_bit_is(part, i, 1))
    translate(t) rotate(r)
    construct_side( idx=i, size=side_yz, insts=insts_yz, p=p, vr=vr, vrm=vrm );
  }

  //
  // layout in 3d
  //
  module layout_3d( gap )
  {
    if (verb > 0)
      log_info(strl(["3d layout"]));

    color("blue")
    for (side = close ? [-1, 1] : [-1])
    let
    (
      i   = side > 0 ? 5 : 4,

      r   = 0,
      t   = [0, 0, (box_z/2 - mth/2 + gap) * side + (close ? 0 : -mth/2)],

      p   = undef,
      vr  = side > 0 ? vr_xy_1  : vr_xy_2,
      vrm = side > 0 ? vrm_xy_1 : vrm_xy_2
    )
    if (binary_bit_is(part, i, 1))
    translate(t) rotate(r)
    extrude_linear_uss(mth, center=true)
    construct_side( idx=i, size=side_xy, insts=insts_xy, p=p, vr=vr, vrm=vrm );

    color("green")
    for (side = [-1, 1])
    let
    (
      i   = side > 0 ? 1 : 0,

      r   = side > 0 ? [90, 0, 0] : [90, 0, 180],
      t   = [0, (box_y/2 + gap) * side, 0],

      p   = side > 0 ? ap_xz_1  : ap_xz_2,
      vr  = side > 0 ? vr_xz_1  : vr_xz_2,
      vrm = side > 0 ? vrm_xz_1 : vrm_xz_2
    )
    if (binary_bit_is(part, i, 1))
    translate(t) rotate(r)
    extrude_linear_uss(mth)
    construct_side( idx=i, size=side_xz, insts=insts_xz, p=p, vr=vr, vrm=vrm );

    color("gray")
    for (side = [-1, 1])
    let
    (
      i   = side > 0 ? 3 : 2,

      r   = side > 0 ? [90, 0, 90] : [90, 0, 270],
      t   = [(box_x/2 - mth + gap) * side, 0, 0],

      p   = side > 0 ? ap_yz_1  : ap_yz_2,
      vr  = side > 0 ? vr_yz_1  : vr_yz_2,
      vrm = side > 0 ? vrm_yz_1 : vrm_yz_2
    )
    if (binary_bit_is(part, i, 1))
    translate(t) rotate(r)
    extrude_linear_uss(mth)
    construct_side( idx=i, size=side_yz, insts=insts_yz, p=p, vr=vr, vrm=vrm );
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

  // side customization for open boxes only
  ap_xz_1       = close ? undef : defined_e_or  (side_add, 0, undef);
  ap_yz_1       = close ? undef : defined_e_or  (side_add, 1, undef);

  ap_xz_2       = close ? undef : defined_e_or  (side_add, 2, ap_xz_1);
  ap_yz_2       = close ? undef : defined_e_or  (side_add, 3, ap_yz_1);

  // side rounding
  vr_xy_1       = defined_eon_or(vr, 0, 0);
  vr_xz_1       = defined_e_or  (vr, 1, vr_xy_1);
  vr_yz_1       = defined_e_or  (vr, 2, vr_xz_1);

  vr_xy_2       = defined_e_or  (vr, 3, vr_xy_1);
  vr_xz_2       = defined_e_or  (vr, 4, vr_xz_1);
  vr_yz_2       = defined_e_or  (vr, 5, vr_yz_1);

  // side rounding modes
  vrm_xy_1      = defined_eon_or(vrm, 0, 1);
  vrm_xz_1      = defined_e_or  (vrm, 1, vrm_xy_1);
  vrm_yz_1      = defined_e_or  (vrm, 2, vrm_xz_1);

  vrm_xy_2      = defined_e_or  (vrm, 3, vrm_xy_1);
  vrm_xz_2      = defined_e_or  (vrm, 4, vrm_xz_1);
  vrm_yz_2      = defined_e_or  (vrm, 5, vrm_yz_1);

  //
  // Calculate sizes and configuration
  //

  // box size
  box_x         = inside ? box_p_x + mth*2 : box_p_x;
  box_y         = inside ? box_p_y + mth*2 : box_p_y;
  box_z         = inside ? box_p_z + mth*2 : box_p_z;

  // box side dimensions
  side_xy       = [ box_x,         box_y ];
  side_xz       = [ box_x - mth*2, box_z - (close ? mth*2 : mth) ];
  side_yz       = [ box_y,         box_z - (close ? mth*2 : mth) ];

  // joint lengths
  joint_x       = min(side_xy.x, side_xz.x);
  joint_y       = min(side_xy.y, side_yz.y);
  joint_z       = min(side_xz.y, side_yz.y);

  //
  // joint instances
  //

  insts_xy  =
  [
    [joint_y, max_sets_y, pin_offset_y, 0, [-1, +1], 2],
    [joint_x, max_sets_x, pin_offset_x, 1, [-1, +1], 2]
  ];

  insts_xz  =
  [
    [joint_z, max_sets_z, pin_offset_z, 0, [-1, +1], 0],
    [joint_x, max_sets_x, pin_offset_x, 1, close ? [-1, +1] : [-1], 0]
  ];

  insts_yz  =
  [
    [joint_z, max_sets_z, pin_offset_z, 0, [-1, +1], 2],
    [joint_y, max_sets_y, pin_offset_y, 1, close ? [-1, +1] : [-1], 0]
  ];

  //
  // construct box layout
  //

  if (verb > 0)
  {
    log_info(strl(["box exterior size = ", [box_x, box_y, box_z]]));

    log_info(strl(["side_xy = ", side_xy]));
    log_info(strl(["side_xz = ", side_xz]));
    log_info(strl(["side_yz = ", side_yz]));
  }

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
    include <shapes/select_common_2d.scad>;
    include <transforms/base_cs.scad>;
    include <transforms/layout.scad>;
    include <models/2d/joint/box_screw.scad>;
    include <parts/2d/enclosure/box_finger_joint.scad>;

    box2d_finger_joint
    (
      mth   = 2,
      size  = [80, 40, 30],

      joint_pin     = [4, 6, 1/2, 1/2, 1/2],
      joint_screw   = [3/2, 5],
      joint_nut     = [3, 3/2],
      joint_spacing = 20,
      joints_max    = [3, 1, 1],

      side_add =
      [
        // lower mid-section
        [[0, 5]],

        // raise sides for handles
        [[+10, 20], [-10, 20]]
      ],

      side_holes =
      [
        // stars
        [ [0,1], [9, 2], [0, 0, 0, 0, 0, 0, 8, 8] ],

        // slots
        [ [2,3], [3, [2, 10], 1, 5], [0, 0, 0, 0, 0, 0, 8, 4] ],

        // handles
        [ [2,3], [6, [[10, 5], -x_axis2d_uv, +x_axis2d_uv]], [0, 0, 0, 0, 0, [0,12]] ],

        // bottom
        [ 4, [2, [1, 6]], [0, 0, 0, 0, 0, 0, [9,4], [8,8]] ]
      ],

      vr      = 2,
      layout  = 1
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
    include <shapes/select_common_2d.scad>;
    include <transforms/base_cs.scad>;
    include <transforms/layout.scad>;
    include <models/2d/joint/box_screw.scad>;
    include <parts/2d/enclosure/box_finger_joint.scad>;

    box2d_finger_joint
    (
      mth   = 2,
      size  = [80, 40, 30],

      joint_pin     = [4, 6, 1/2, 1/2, 1/2],
      joint_screw   = [3/2, 5],
      joint_nut     = [3, 3/2],
      joint_spacing = 20,
      joints_max    = [3, 1, 1],

      side_add =
      [
        // lower mid-section
        [[0, 5]],

        // raise sides for handles
        [[+10, 20], [-10, 20]]
      ],

      side_holes =
      [
        // stars
        [ [0,1], [9, 2], [0, 0, 0, 0, 0, 0, 8, 8] ],

        // slots
        [ [2,3], [3, [2, 10], 1, 5], [0, 0, 0, 0, 0, 0, 8, 4] ],

        // handles
        [ [2,3], [6, [[10, 5], -x_axis2d_uv, +x_axis2d_uv]], [0, 0, 0, 0, 0, [0,12]] ],

        // bottom
        [ 4, [2, [1, 6]], [0, 0, 0, 0, 0, 0, [9,4], [8,8]] ]
      ],

      vr      = 2,
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

