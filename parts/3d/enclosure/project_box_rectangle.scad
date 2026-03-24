//! A rectangular box maker for project boxes, enclosures and housings.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2024,2026

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

    \amu_define group_name  (Rectangular Project Box)
    \amu_define group_brief (Rectangular prism project box generator.)

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
    shapes/select_common_3d.scad
    transforms/base_cs.scad
    transforms/layout.scad
  )
  \amu_include (include/amu/includes_required.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//! A rectangular box maker for project boxes, enclosures and housings.
/***************************************************************************//**
  \param  wth   <decimal> wall thickness.

  \param  h     <datastruct | decimal> box extrusion height;
                structured data or a single decimal to set the box
                height.

  \param  size  <decimal-list-2 | decimal> box base size; a list [x, y]
                or a single decimal for (x=y).

  \param  vr    <decimal-list-4 | decimal> wall corner rounding radius;
                a list [v1r, v2r, v3r, v4r] or a single decimal for
                (v1r=v2r=v3r=v4r).

  \param  vrm   <integer-list-4 | integer> wall corner rounding mode =
                {0:none, 1:bevel, 2:round}; a list [v1rm, v2rm, v3rm,
                v4rm] or a single decimal for (v1rm=v2rm=v3rm=v4rm).

  \param  inset <decimal-list-2 | decimal> wall-to-lid negative offset;
                a list [x, y] or a single decimal for (x=y).

  \param  lid   <datastruct | decimal> lid extrusion height;
                structured data or a single decimal to set the lid
                height.

  \param  lip   <datastruct | integer> wall lip; structured data or a
                single integer to set the lip mode.

  \param  rib   <datastruct | integer> wall ribs; structured data or a
                single integer to set the rib mode.

  \param  wall  <datastruct> interior walls; structured data.

  \param  post  <datastruct> posts; structured data.

  \param  hole  <datastruct> holes; structured data.

  \param  shape <datastruct> shapes; structured data.

  \param  align <integer-list-3> box alignment; a list [x, y, z].

  \param  mode  <integer> module mode of operation.

  \param  verb  <integer> console output verbosity
                {0=quiet, 1=info, 2=details}.

  \details

    Construct a rectangular enclosure for electronic and or other
    project boxes of the like. This module is designed to construct no
    more than one attached exterior cover and four exterior walls for
    each invocation. Therefore, a minimum of two invocations are
    required to construct a complete enclosure with six sides (top,
    walls, and bottom). Only the parameters \p wth and \p size are
    required; all others are optional.

    In a simple case, a box would consist of a (1) cover with attached
    walls and (2) a separate opposite cover, without walls, to close
    the box. This would require exactly two invocations. More than two
    invocations can be used to construct boxes with multiple
    mid-sections and/or removable covers on one or both sides as shown
    in the following example.

    \amu_define scope_id      (example_multiple)
    \amu_define title         (Muilti-section project box example)
    \amu_define image_views   (front diag)
    \amu_define image_size    (sxga)

    \amu_include (include/amu/scope_diagrams_3d.amu)

    Notice that the middle sections omit the \p lid parameter to skip
    cover construction in this example.

    ## Parameter defaults

    Default values are calculated for all parameters. In some cases,
    the defaults are calculated based on prior user supplied values.
    For example, post diameters are calculated based on the supplied
    screw size for a post instance. Whenever a configuration consists
    of a list of values, there is no requirement to supply values for
    all elements of the list. Generally speaking, the list may be
    terminated at the parameter of interest. The caveat is for
    parameters of interest that comes after those which are not of
    interest. In this case, the prior values may be assigned a suitable
    value or may be assigned the value \b undef to use the calculated
    default as demonstrated below.

    \code
         full_config = [ 12.42, [1,2], [2,1], 0, [1,2], 31, [1,2,3], 0 ];
      partial_config = [ undef, undef, undef, 2, undef, 31 ];
    \endcode

    ## Rounding and extrusions

    The edge rounding during shape construction is performed using the
    function polygon_round_eve_all_p(). Refer to its documentation for
    more information on the rounding modes and their descriptions.

    All height extrusions for walls, ribs, posts, etc, are performed by
    the function extrude_linear_mss(). This facilitates flexible
    scaling along the extrusion height as described in that functions
    documentation. The <em>box bottom section example</em> at the end
    of this page shows how this scaling can be used to create features,
    such as corner rounding and face protrusion, along the lid and box
    height.

    ## Multi-value and structured parameters

    ### h, lid

    The height of the exterior walls and the box lid are the result of
    extrusions produced using the function extrude_linear_mss(). The
    height can be specified as a single decimal value or may be
    specified as list of scaled sections along the height. For a
    description on specifying scaled extrusions see the documentation
    for this extrusion function.

    ### lip

    By way of the parameter \p lip, the box walls can have an overhang
    that interfaces with adjacent wall or lid sections. The adjacent
    section should be constructed with an opposite lip orientation
    using the mode configuration. The \p lip is considered to be a
    feature of the exterior enclosure walls and therefore a specified
    \p lip height should always be less than or equal to the total wall
    height \p h.

    #### Data structure schema:

    name            | schema
    ---------------:|:----------------------------------------------
    lip             | [ mode, height, width, taper, snap, removals ]

    #### Data structure fields: lip

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | integer           | required          | mode
      1 | decimal           | wth               | height
      2 | decimal           | 35                | base width (percentage of wall thickness)
      3 | decimal           | 10                | top taper width (percentage of wall thickness)
      4 | datastruct \| integer | 0             | snap configuration
      5 | datastruct        |  undef            | removals instances

    ##### lip[0]: mode

    Integer value is binary encoded.

      b | description
    ---:|:---------------------------------------
      0 | inside lip at upper edge of wall
      1 | outer lip at upper edge of wall
      2 | inside lip at lower edge of wall
      3 | outer lip at lower edge of wall
      4 | center pin at upper wall
      5 | inside lip at upper edge of wall
      6 | center pin at lower wall
      7 | inside lip at lower edge of wall

    ##### lip[4]: snap

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | integer           | required          | snap segments of total steps
      1 | integer           | 5                 | total segment steps
      2 | decimal           | 1.0               | max scale (1 = 1x taper width)
      3 | decimal-list      | [0, 3.5/5, 4.5/5, 1, 4.5/5, 3.5/5, 0] | scale multiplier steps

    ##### lip[5]: removals

    ##### Data structure schema:

    name            | schema
    ---------------:|:----------------------------------------------
    removals        | [ removal, removal, ..., removal ]
    removal         | [ mode, axis, offset ]

    ##### Data structure fields: removal instance

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | integer           | required          | mode: lip section application
      1 | integer-list-2    | [0, 0]            | axis [x, y]; {0=unchanged, 1=remove}
      2 | integer-list-2    | [0, 0]            | offset [x, y]; {-1, 0, +1}

    Any lip sections specified by the \p mode variable can have their
    walls selectively removed, enabling features like sliding lid
    assembly, for example. This removal specification allows anywhere
    from zero to all four sections to be removed, with each lip mode
    being independent. Removals are defined by one or more removal
    instances. If a mode is repeated in the instance list, the last
    occurrence is used.

    \amu_define scope_id      (example_lip)
    \amu_define title         (slide-in snap-lip example)
    \amu_define image_views   (front back diag)
    \amu_define image_size    (sxga)

    \amu_include (include/amu/scope_diagrams_3d.amu)

    The above shows an example of a lip with a basic snap-in edge
    configuration, with sections removed from the upper and lower
    halves of the box. This allows the box to be assembled by sliding
    the halves together. If the sections were not removed, the two
    halves could instead be snapped together and held in place by the
    configured snap edges on the lip.

    Depending on the flexibility of the construction material, the
    engagement and gap sizes of the mating halves may need to be
    adjusted. Specifically, this includes considering the base width,
    taper width, and maximum snap scaling.

    ### rib

    The exterior box walls and lid rigidity can be reinforced using a
    this options to configure and construct a grid of rib-like
    structures which are embed on the interior surface of the walls and
    lid.

    #### Data structure schema:

    name            | schema
    ---------------:|:----------------------------------------------
    rib             | [ mode, extrusions, coverage, counts ]
    extrusions      | [ base, x-extrusion, y-extrusion ]

    #### Data structure fields: rib

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | integer           | required          | mode
      1 | datastruct        | (see below)       | base and height extrusions
      2 | decimal-list-3:1 \| decimal | 10            | [x, y, h] coverage percentage
      3 | integer-list-3:1 \| integer | (calculated)  | [x, y, h] count override

    ##### rib[0]: mode

    Integer value is binary encoded.

      b | description
    ---:|:---------------------------------------
      0 | no ribs on the lid
      1 | no ribs on the x-positive wall
      2 | no ribs on the y-positive wall
      3 | no ribs on the x-negative wall
      4 | no ribs on the y-negative wall
    5-6 | lip coverage count (2-bit encoded integer)
      7 | offset all ribs to bottom of lower lip

    ##### rib[1]: base and height extrusion

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | decimal           | wth               | rib base width
      1 | decimal-list-2    |[[wth, rib_edx]]   | x-axis oriented rib height extrusion
      2 | decimal-list-2    |[[wth, rib_edy]]   | y-axis oriented rib height extrusion

    The constants \c rib_edx and \c rib_edy are defaults that
    approximates a half-ellipse rib-like shape. To specify alternative
    custom extrusions, see the documentation for the extrusion function
    extrude_linear_mss().

    ### wall

    The parameter \p wall may be used to define one or more interior
    walls to be constructed. There are two types which correspond to
    walls parallel to the x-axis (type 0) or y-axis (type 1). Each wall
    instance may be moved, scaled, or rotated.

    #### Data structure schema:

    name            | schema
    ---------------:|:----------------------------------------------
    wall            | [ configuration, instances ]
    configuration   | [ mode, defaults ]
    defaults        | [ w, h, vr, vrm ]
    instances       | [ instance, instance, ..., instance ]
    instance        | [ type, move, scale, rotate, size, h, vr, vrm ]

    #### Data structure fields: wall

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | datastruct        | required          | configuration
      1 | datastruct-list   | required          | instance list

    ##### wall[0]: configuration

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | integer           | required          | mode
      1 | datastruct        | (see below)       | defaults

    ###### wall[0]: configuration[0]: mode

    Integer value is binary encoded.

      b | description
    ---:|:---------------------------------------
    0-1 | wall end rounding {0:none, 1:bevel, 2:fillet, 3:round-out}
    2-4 | wall top rounding (1)
    5-7 | wall base rounding (1)
    8-9 | wall on lips {0:none, 1:one, 2:both}
     10 | offset all walls to bottom of lower lip

    (1) The bits 2-4 and bits 5-7, configure the rounding mode for the
    wall top and wall base, respectively. The 3-bits integer values are
    indexed to the rounding options as summarized in the following
    table:

    Integer value is binary encoded.

      v | wall top rounding | wall base rounding
    ---:|:-----------------:|:-----------------:
      0 | none              | none
      1 | bevel-in          | bevel-in
      2 | round-in          | round-in
      3 | fillet-in         | fillet-in
      4 | bevel-out         | bevel-out
      5 | fillet-out        | fillet-out
      6 | round-out         | round-out

    ###### wall[0]: configuration[1]: defaults

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | decimal           | wth               | width
      1 | datastruct        | cfg_he            | extrusion
      2 | decimal-list-4 \| decimal | wth       | rounding radius
      3 | integer-list-4 \| integer | cfg_vrm   | rounding mode

    The constants \c cfg_he and \c cfg_vrm define defaults that may
    be used to round the top, base, and edges of a wall.

    ##### wall[1]: instance

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | integer                     | required   | type {0: x-axis, 1:y-axis}
      1 | decimal-list-3:2 \| decimal | [0, 0, 0]  | move
      2 | decimal-list-3:2 \| decimal | [1, 1, 1]  | scale
      3 | decimal-list-3:1 \| decimal | [0, 0, 0]  | rotate
      4 | decimal-list-2              | tdef_s     | size
      5 | decimal-list-2              | tdef_he    | extrusion
      6 | decimal-list-4   \| decimal | tdef_vr    | rounding radius
      7 | integer-list-4   \| integer | tdef_vrm   | rounding mode

    The constants \c tdef_s, \c tdef_he, \c tdef_vr, and \c tdef_vrm
    are default values that depend on the wall type being constructed.
    For example, `tdef_s = [max_x, wth]` for wall type \c 0 and `tdef_s
    = [wth, max_y]` for wall type \c 1. These default may be overridden
    to provide custom wall sizes, wall rounding and/or height
    extrusions for each wall instance.

    ### post

    This parameter may be used to define one or more screw posts for
    securing covers, circuit boards, mounts, and the like. There are
    two types of predefined posts; normal posts and recessed access
    posts. Recessed posts have a widened access tunnel where screws can
    be inserted through and below the surface where the post is
    attached. All posts (and holes) may be rounded at the bottom, to
    widen the contact with the the adjacent surface, or at the top, to
    enhance contact or smooth its edges. Each post instance consists of
    two holes, a post with optional fins, and can be aligned, moved,
    and rotated. The optional post fins can be either triangular or
    rectangular in shape.

    #### Data structure schema:

    name            | schema
    ---------------:|:----------------------------------------------
    post            | [ configuration, instances ]
    configuration   | [ mode, defaults ]
    defaults        | [ hole0, hole1, post1, hole2, post2, fins0, fins1, calculation ]
    hole, post (1)  | [ d, h, ho, da, ha, vr, vrm ]
    fins (2)        | [ c, sweep-angle, w, d-scale, h-scale, vr, vrm ]
    calculation     | [ hole1-mul, hole1-add, post1-mul, post1-add, hole2-mul, hole2-add, post2-mul, post2-add ]
    instances       | [ instance, instance, ..., instance ]
    instance        | [ type, align. move, rotate, hole0, hole1, post, fins ]

    (1) All numbered and unnumbered holes and posts utilize this form.
    (2) All fins defaults and instances are of this form.

    #### Data structure fields: post

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | datastruct        | required          | configuration
      1 | datastruct-list   | required          | instance list

    ##### post[0]: configuration

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | integer           | required          | mode
      1 | datastruct        | (see below)       | defaults

    ###### post[0]: configuration[0]: mode

    Integer value is binary encoded.

      b | description
    ---:|:---------------------------------------
    0-1 | post rounding {0:none, 1:bevel, 2:filet}
    2-3 | fin rounding {0:none, 1:bevel, 2:filet}
      4 | post base rounded same as top {0:opposite, 1:same}
      5 | set auxiliary screw hole on opposite side of lid
      6 | re-calculate defaults with each instance (1)
      7 | post type that extends into lip height {0:recessed, 1:normal}
      8 | lip height extension count {0:one, 1:both}
      9 | offset all posts to bottom of lower lip


    (1) The post and secondary hole diameter defaults are calculated as
    shown under calculation described below. This mode bit controls
    when the calculation is performed; either when defaults are
    configured (b=0), or when a post instance is created (b=1).

    ###### post[0]: configuration[1]: defaults

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | datastruct        | (see below)       | hole0; the screw hole
      1 | datastruct        | (see below)       | hole1; post 1 aux hole
      2 | datastruct        | (see below)       | post1; normal-post
      3 | datastruct        | (see below)       | hole2; post 2 access hole
      4 | datastruct        | (see below)       | post2; recessed-post
      5 | datastruct        | (see below)       | fins0: triangular-fins
      6 | datastruct        | (see below)       | fins1: rectangular-fins
      7 | datastruct        | (see below)       | calculation

    ###### post[0]: configuration[1]: defaults[0]: hole0

    The default values and instance configuration for post, hole0,
    hole1, post1, hole2, and post2 follow the schema described in the
    table below, with the only difference being the default values.
    These defaults are calculated according to the method outlined in
    the "Defaults Calculation" section. Specifically, the default
    heights for the posts and screw holes are determined based on the
    post height and other configured requirements.

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | decimal           | 3.25              | diameter
      1 | decimal           | (maximum)         | height
      2 | decimal           | 0                 | height offset
      3 | decimal           | 0                 | (1) \em late diameter adjust
      4 | decimal           | 0                 | (1) \em late height adjust
      5 | decimal-list-4 \| decimal| 0          | rounding radius
      6 | integer-list-4 \| integer| 0          | rounding mode
      7 | decimal           | 0                 | (2) removal height
      8 | decimal           | 0                 | (2) removal height offset
      9 | decimal-list-2 \| decimal | [0, 0]    | (2) removal top cut angles [t, r]
      10| decimal-list-2 \| decimal | [0, 0]    | (2) removal bottom cut angles [t, r]

    (1) Elements 3–4 are used for \em late adjustments to post and hole
    diameters and heights. By \em late, it is meant that these elements
    allow dimensional changes to be made without affecting dependent
    value calculations. This is useful for creating screw-hole
    clearances or increasing diameters to accommodate brass threaded
    inserts, for example. Another application is post height adjustment
    to provide clearance for circuit board mounting.

    (2) Elements 7–10 may be used to remove sections of the post
    structure. This feature allows support for posts that do not extend
    the full height of the enclosure. The ends of the removed sections
    may be cut at an angle to provide a gradual phase-in during 3D
    printing, eliminating the need for additional support structures.

    ###### post[0]: configuration[1]: defaults[5]: fins0: triangular-fins

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | integer           | 4                 | count
      1 | decimal           | 360               | distribution angle
      2 | decimal           | wth               | width
      3 | decimal           | 1/5               | post diameter fraction
      4 | decimal           | 5/8               | post height fraction
      5 | decimal-list-3 \| decimal | def_f0_vr  | rounding radius
      6 | integer-list-3 \| integer | def_f0_vrm | rounding mode

    The constants \em def_f0_vr and \em def_f0_vrm define defaults for
    fin rounding and may be overridden if needed. See the source code
    for more details.

    ###### post[0]: configuration[1]: defaults[6]: fins1: rectangular-fins

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | integer           | 4                 | count
      1 | decimal           | 360               | distribution angle
      2 | decimal           | wth               | width
      3 | decimal           | 1/2               | post diameter fraction
      4 | decimal           | 1                 | post height fraction
      5 | decimal-list-4 \| decimal | def_f1_vr  | rounding radius
      6 | integer-list-4 \| integer | def_f1_vrm | rounding mode

    The constants \em def_f1_vr and \em def_f1_vrm define defaults for
    fin rounding and may be overridden if needed. See the source code
    for more details.

    ###### post[0]: configuration[1]: defaults[7]: calculation

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | decimal           | 0                 | hole1 multiplier
      1 | decimal           | 0                 | hole1 addition
      2 | decimal           | 3.0               | post1 multiplier
      3 | decimal           | wth/2             | post1 addition
      4 | decimal           | 2.0               | hole2 multiplier
      5 | decimal           | wth/2             | hole2 addition
      6 | decimal           | 4.0               | post2 multiplier
      7 | decimal           | wth/2             | post2 addition

    For hole1, hole2, post1, and post2, the diameters are calculated
    based on the following model:

    \code
      diameter = hole0 + wth * multiplier + addition
    \endcode

    where \c hole0 is the screw-hole diameter and \c wth is the
    configured wall thickness parameter value. This allow for a simple
    way to generate posts and holes that are dependent on the screw
    hole diameter. The multiplier and fixed additions for each hole and
    post may be configured to replace the values shown in the above
    table.

    ##### post[1]: instance

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | integer           | required          | type
      1 | decimal-list-3:1  | [0, 0, 0]         | zero
      2 | decimal-list-3:2  | [0, 0, 0]         | move
      3 | decimal-list-3:1 \| decimal | [0, 0, 0] | rotate
      4 | datastruct        | (see note)        | (1) hole0; screw hole
      5 | datastruct        | (see note)        | (1) hole1; aux hole
      6 | datastruct        | (see note)        | (1) post
      7 | datastruct        | (see note)        | (1) fins

    (1) The elements of the datastruct for hole0, hole1, post, and fins
    instances are described in the post configuration defaults section,
    which covers posts, holes, and fins.

    \note The default values for the holes, post, and fins are
    determined by their type. When not explicitly specified for an
    instance, these values are automatically derived from the
    configured default settings, as outlined above.

    ###### post[1]: instance[0]: type

    Integer value is binary encoded.

      b | description
    ---:|:---------------------------------------
      0 | post type  {0:normal, 1:recessed}
      1 | fin type {0:triangular, 1:rectangular}

    ###### post[1]: instance[1]: zero

    The x and y zero can be assigned decimal values in the interval
    (-1, +1), to set the post zero alignment position along the
    enclosure x and y dimensions. The z zero can be assigned a decimal
    value in the interval (-1, 0), to set the post zero alignment
    position along the enclosure lid height.

    ### hole

    #### Data structure schema:

    This parameter can be used to create holes in the enclosure using
    common or user-defined 2D shapes. Typical applications include
    openings for vent holes, LEDs, switches, and fans. For more
    information on defining and using custom shapes, see
    select_common_2d_shape(). Hole placement is performed using
    layout_grid_rp(); refer to its documentation for details on usage
    and configuration options. The layout bounding box is the center of
    the enclosure walls.

    name            | schema
    ---------------:|:----------------------------------------------
    hole            | [instances]
    instances       | [instance, instance, ..., instance ]

    #### Data structure fields: instance

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | datastruct \| integer | 1             | 2d shape selections (see: select_common_2d_shape())
      1 | decimal               | 0             | shape extrusion height (see note below)
      2 | datastruct            | [0]           | shape layout (see: layout_grid_rp()

    When the shape extrusion height is \p 0, the height is
    automatically derived from the maximum enclosure dimension. When
    set to \p −1, \p −2, or \p −3, the height is derived from the
    width, length, or height dimension, respectively. Any other
    positive value explicitly sets the extrusion height.

    ### shape

    This parameter can be used to add features to the enclosure design
    using common or user-defined 3D shapes. Typical applications
    include standoffs, feet, handles, and cosmetic detailing. For more
    information on defining and using custom shapes, see
    select_common_3d_shape(). Shape placement is performed using
    layout_grid_rp(); refer to its documentation for details on usage
    and configuration options. The layout bounding box is the center of
    the enclosure walls.

    #### Data structure schema:

    name            | schema
    ---------------:|:----------------------------------------------
    shape           | [instances]
    instances       | [instance, instance, ..., instance ]

    #### Data structure fields: instance

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | datastruct \| integer | 1             | 3d shape selections (see: select_common_3d_shape())
      1 | datastruct            | [0]           | shape layout (see: layout_grid_rp()

    ### align

    The x, y, and z axis of the box can be aligned independently using
    this parameter.

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | integer           | 0                 | x-axis alignment
      1 | integer           | 0                 | y-axis alignment
      2 | integer           | 0                 | z-axis alignment

    #### align[0-1]: x or y axis alignment

      v | description
    ---:|:---------------------------------------
      0 | center of enclosure
      1 | positive exterior edge of lid
      2 | positive exterior edge of wall
      3 | positive interior edge of wall
      4 | negative interior edge of wall
      5 | negative exterior edge of wall
      6 | negative exterior edge of lid

    #### align[2]: z-axis alignment

      v | description
    ---:|:---------------------------------------
      0 | bottom edge of lid
      1 | bottom edge of wall
      2 | middle of enclosure
      3 | middle of wall
      4 | top edge of wall
      5 | top edge of lip

    ### mode

    Integer value is binary encoded.

      b | description
    ---:|:---------------------------------------
      0 | size is specified for enclosure interior
      1 | remove features outside of enclosure envelope
      2 | scale interior with exterior wall during extrusion
      3 | do not limit wall rounding modes to bevel and rounded (1)
      4 | do not construct exterior walls
      5 | do not construct exterior wall lips
      6 | do not construct lid
      7 | do not construct ribs
      8 | do not construct interior walls
      9 | do not construct posts
     10 | do not construct holes
     11 | do not construct shapes

    (1) When rounding mode limiting is disabled, the rounding mode
    value, \p vrm, is no longer mapped to \em bevel or \em rounded and
    any mode of the function polygon_round_eve_all_p() may be used to
    round the box exterior walls and lid.

    Bits 4-9 can be used to disable the construction of select parts.
    This may be used during design iteration to help understand
    internal alignment and clearance. For example, turning off the
    construction of exterior walls allows to see how a PCB fits inside
    an assembled enclosure.

    \amu_define scope_id      (example_bottom)
    \amu_define title         (Project box bottom section example)
    \amu_define image_views   (top front right diag)
    \amu_define image_size    (sxga)
    \amu_define image_columns (4)

    \amu_include (include/amu/scope_diagrams_3d.amu)
*******************************************************************************/
module project_box_rectangle
(
  wth,
  h,
  size,

  vr,
  vrm,

  inset,

  lid,
  lip,
  rib,
  wall,
  post,
  hole,
  shape,

  align,
  mode = 0,
  verb = 0
)
{
  //
  //
  // helper modules and functions
  //
  //

  // hole construction
  module construct_holes()
  {
    insts = defined_or(hole, empty_lst);

    // use center of enclosure walls
    bsize = [szint_x, szint_y, szint_z] + [wth, wth, wth];

    for (inst = insts)
    {
      shape   = defined_e_or (inst, 0, 1);
      h_p     = defined_e_or (inst, 1, 0);
      layout  = defined_e_or (inst, 2, [0]);

      s_type  = is_list(shape) ? first(shape) : shape;
      s_argv  = is_list(shape) ? tailn(shape, 1) : undef;

      /*

        auto-extrusion calculation: add wall thickness

           0 = max(w,l,h)
          -1 = w, -2 = l, -3 = h
          >0 = supplied value

      */

      h       = (h_p < 0)  ? bsize[abs(h_p+1)] + wth + eps*8
              : (h_p == 0) ? max(bsize) + wth + eps*8
              : h_p;

      // move layout to enclosure center
      translate([0, 0, bsize.z/2])
      layout_grid_rp(t=layout, b=bsize, center=true, verb=verb-1)
      extrude_linear_uss(h, center=true)
      select_common_2d_shape(type=s_type, argv=s_argv, center=true, verb=verb-1);

      if (verb > 1)
      {
        echo(shape=shape, type=s_type, argv=s_argv);
        echo(height=h);
        echo(layout=layout);
      }
    }

    if (verb > 0)
    {
      echo(strl(["hole: instances = ", insts]));
    }
  }

  // shape construction
  module construct_shapes()
  {
    insts = defined_or(shape, empty_lst);

    // use center of enclosure walls
    bsize = [szint_x, szint_y, szint_z] + [wth, wth, wth];

    for (inst = insts)
    {
      shape   = defined_e_or (inst, 0, 1);
      layout  = defined_e_or (inst, 1, [0]);

      s_type  = is_list(shape) ? first(shape) : shape;
      s_argv  = is_list(shape) ? tailn(shape, 1) : undef;

      // move layout to enclosure center
      translate([0, 0, bsize.z/2])
      layout_grid_rp(t=layout, b=bsize, center=true, verb=verb-1)
      select_common_3d_shape(type=s_type, argv=s_argv, center=true, verb=verb-1);

      if (verb > 1)
      {
        echo(shape=shape, type=s_type, argv=s_argv);
        echo(layout=layout);
      }
    }

    if (verb > 0)
    {
      echo(strl(["shape: instances = ", insts]));
    }
  }

  // exterior walls
  module construct_exterior_walls( envelop=false )
  {
    // re-scale total extrusion height of 'h' equally to 'wall_h'
    // and extrude scaled version 'hs' to maintain proper wall height
    hs  = !is_list(h) ?
          wall_h
        : let( sf=wall_h/h_h )
          [ for (e=h) !is_list(e) ? e * sf : [ first(e) * sf, second(e) ] ];

    if ( mode_scale_io == true )
    { // scale inner and outer wall together
      extrude_linear_mss(hs)
      difference_cs( envelop == false )
      {
        pg_rectangle(wall_xy + 0*[wth, wth], vr=vr, vrm=vrm_ci, center=true);
        pg_rectangle(wall_xy - 2*[wth, wth], vr=vr, vrm=vrm_ci, center=true);
      }
    }
    else
    { // scale outer wall only
      difference_cs( envelop == false )
      {
        extrude_linear_mss(hs)
        pg_rectangle(wall_xy + 0*[wth, wth], vr=vr, vrm=vrm_ci, center=true);

        translate([0, 0, -10*eps/2])
        extrude_linear_mss(wall_h + 10*eps)
        pg_rectangle(wall_xy - 2*[wth, wth], vr=vr, vrm=vrm_ci, center=true);
      }
    }

    if (verb > 0)
    {
      // generate list of all scale factors in extrusion [x, y]
      sf_x  = !is_list(h) ?
              1
            : let( sf = [ for (e=h) !is_list(e) ? 1 : [ for (f=second(e)) !is_list(f) ? f : first(f) ] ] )
              merge_s( sf );

      sf_y   = !is_list(h) ?
              1
            : let( sf = [ for (e=h) !is_list(e) ? 1 : [ for (f=second(e)) !is_list(f) ? f : second(f) ] ] )
              merge_s( sf );

      echo(strl(["wall: extrusion scale factors [x-min, x-max] = ", [min(sf_x), max(sf_x)]]));
      echo(strl(["wall: extrusion scale factors [y-min,y- max] = ", [min(sf_y), max(sf_y)]]));
      echo(strl(["wall: height (ignoring ribs) = ", wall_h]));
      echo(strl(["wall: total interior height (ignoring ribs) = ", wall_h + lip_h]));
    }
  }

  // wall lips
  module construct_lips( envelop=false )
  {
    // 'lip_h', bit '1', is set globally (ensure coherency with bits of 'lip')
    // wall lip: mode, height, base pct, taper pct, alignment
    lip_m         = defined_e_or(lip, 0, lip);
    lip_bw        = defined_e_or(lip, 2, 35);
    lip_tw        = defined_e_or(lip, 3, 10);
    lip_sc        = defined_e_or(lip, 4, 0);
    lip_sr        = defined_e_or(lip, 5, 0);

    // lip snap configuration
    lip_sc_s      = defined_eon_or(lip_sc, 0, 0);
    lip_sc_d      = defined_e_or  (lip_sc, 1, 5);
    lip_sc_m      = defined_e_or  (lip_sc, 2, 1);
    lip_sc_f      = defined_e_or  (lip_sc, 3, [0, 3.5/5, 4.5/5, 1, 4.5/5, 3.5/5, 0]);

    // generate 'mss' linerar scaled extrusion profile
    function el_mss_profile
    (
      h,  // total height
      t,  // location {0=bottom | 1=top}
      i   // inversion {+1 | -1}
    ) =
    let
    (
      m = lip_sc_m,   // max amplitude
      d = lip_sc_d,   // total segment divisions
      s = lip_sc_s,   // lip snap divisions
      f = lip_sc_f,   // snap scale multiplier steps

      // wall taper scale factors (referenced to taper width)
      fx  = (2 * wth * lip_tw / 100) / wall_xy.x,
      fy  = (2 * wth * lip_tw / 100) / wall_xy.y,

      h1  = h * (d-s)/d,
      h2  = h * s /d,

      s1  = [1, [1 - i*fx, 1 - i*fy]],
      s2  = [for (j=f) [1 - i*fx*(1-j*m), 1 - i*fy*(1-j*m)]]
    )
    t ?
      [ [h1, s1], if (s ) [h2, s2] ]
    : [ if (s) [h2, reverse(s2)], [h1, reverse(s1)] ];

    translate( [0, 0, wall_h/2] )
    for
    (
      dt =
      let
      (
        // straight extrusion height for additions and removals
        lip_ha  = lip_h,
        lip_hr  = lip_h + eps*10,

        // extrusion profile; inner and outer lip at top and bottom.
        ep_it = el_mss_profile( lip_ha, 1, +1 ),
        ep_ot = el_mss_profile( lip_hr, 0, +1 ),
        ep_ib = el_mss_profile( lip_ha, 0, +1 ),
        ep_ob = el_mss_profile( lip_hr, 1, +1 ),

        // extrusion profile; 'pin' and 'clip' at top and bottom.
        ep_pt = el_mss_profile( lip_hr, 1, -1 ),
        ep_ct = el_mss_profile( lip_ha, 0, -1 ),
        ep_pb = el_mss_profile( lip_hr, 0, -1 ),
        ep_cb = el_mss_profile( lip_ha, 1, -1 ),

        // lip wall sizes; for outer and inner combinations
        ws_oo   = wall_xy,
        ws_oi   = wall_xy - 2*[wth, wth] * lip_bw/100,
        ws_io   = wall_xy - 2*[wth, wth] * (1-lip_bw/100),
        ws_ii   = wall_xy - 2*[wth, wth]
      )
      [ // m, io, tb,     ae,     re,    as,    rs
          [0,  1, +1,  ep_it, lip_hr, ws_io, ws_ii],  // inner lip at top
          [1,  0, +1, lip_ha,  ep_ot, ws_oo, ws_oi],  // outer lip at top
          [2,  1, -1,  ep_ib, lip_hr, ws_io, ws_ii],  // inner lip at bottom
          [3,  0, -1, lip_ha,  ep_ob, ws_oo, ws_oi],  // outer lip at bottom

          [4,  1, +1,  ep_it,  ep_pt, ws_oi, ws_io],  // center pin at top
          [5,  0, +1,  ep_ct, lip_hr, ws_io, ws_ii],  // inner lip at top (clip section)
          [6,  1, -1,  ep_ib,  ep_pb, ws_oi, ws_io],  // center pin at bottom
          [7,  0, -1,  ep_cb, lip_hr, ws_io, ws_ii]   // inner lip at bottom (clip section)
      ]
    )
    {
      m     = dt[0];  //  m  : configuration mode

      if ( binary_bit_is(lip_m, m, 1) )
      {
        io  = dt[1];  // io  : inside / outside
        tb  = dt[2];  // tb  : top / bottom
        ap  = dt[3];  // ap  : add extrusion profile
        rp  = dt[4];  // rp  : remove extrusion profile
        as  = dt[5];  // as  : add size
        rs  = dt[6];  // rs  : remove size

        //
        // section removal: format = [ [m, ee, ep], ... ]
        //

        sr  = lip_sr[ last(search(m, lip_sr, 0, 0)) ];

        ee  = defined_ei_or(sr, 1, [0, 0], 2);            // enable {0, 1}
        eo  = defined_ei_or(sr, 2, [0, 0], 2);            // offset {-1, 0, +1}

        es  = [wall_xy.x * ee.x, wall_xy.y * ee.y] / 2;   // size
        et  = [es.x * eo.x, es.y * eo.y] / 2;             // translation

        translate([0, 0, (wall_h + lip_h - eps)/2 * tb])
        difference_cs( envelop == false )
        {
          extrude_linear_mss(ap, center=true)
          pg_rectangle(as, vr=vr, vrm=vrm_ci, center=true);

          extrude_linear_mss(rp, center=true)
          translate(et)
          pg_rectangle(rs + es, vr=vr, vrm=vrm_ci, center=true);
        }
      }
    }

    if (verb > 0)
    {
      echo(strl(["lip: mode = ", lip_m]));
      echo(strl(["lip: height = ", lip_h]));
      echo(strl(["lip: base width percentage = ", lip_bw]));
      echo(strl(["lip: top reduction percentage = ", lip_tw]));
      echo(strl(["lip: snap = ", lip_sc]));
      echo(strl(["lip: section removal = ", lip_sr]));
    }
  }

  // lid extrusion
  module construct_lid()
  {
    mirror([0, 0, 1])
    translate([0, 0, -eps])
    extrude_linear_mss(lid)
    pg_rectangle([encl_x, encl_y] + 0*[wth, wth], vr=vr, vrm=vrm_ci, center=true);

    if (verb > 0)
    {
      echo(strl(["lid: extrusion = ", lid]));
      echo(strl(["lid: height = ", lid_h]));
    }
  }

  // ribs
  module construct_ribs()
  {
    // mode
    rib_m   = defined_e_or(rib, 0, rib);

    // B5-6: wall limits (mode dependent)
    max_x   = first( wall_xy) - 2*(wth - eps);
    max_y   = second(wall_xy) - 2*(wth - eps);

    // 'max_h' may include 0 to 2 'lip_h' (ie: one at top and bottom)
    max_h   = wall_h + min(2, binary_iw2i(rib_m, 5, 2)) * lip_h;

    // B7: configurable global offset (to align with lower lip)
    rib_lo  = binary_bit_is(rib_m, 7, 1) ? [0, 0, -lip_h] : zero3d;

    // rib width and extrusion configuration (semicircle)
    rib_edx = [for (x=[0:1/get_fn(1)/2:1]) [2*sqrt(1-pow(x,2)), 1]];

    rib_edy = [for (e=rib_edx) reverse(e)];

    rib_sd  = defined_e_or(rib, 1, [ wth, [[wth, rib_edx]], [[wth, rib_edy]] ] );

    rib_w   = defined_e_or(rib_sd, 0, rib_sd);
    rib_hx  = defined_e_or(rib_sd, 1, [[rib_w, rib_edx]]);
    rib_hy  = defined_e_or(rib_sd, 2, [[rib_w, rib_edy]]);

    // rib coverage percentages
    rcp_d   = defined_e_or(rib, 2, 10);

    rcp_x   = defined_e_or(rcp_d, 0, rcp_d);
    rcp_y   = defined_e_or(rcp_d, 1, rcp_x);
    rcp_z   = defined_e_or(rcp_d, 2, rcp_y);

    // calculated rib counts based on coverage percentage
    crc_x   = max([0, floor(max_x/rib_w * rcp_x / 100)]);
    crc_y   = max([0, floor(max_y/rib_w * rcp_y / 100)]);
    crc_z   = max([0, floor(max_h/rib_w * rcp_z / 100)]);

    // rib count assignment
    cnt_d   = defined_e_or(rib, 3, [crc_x, crc_y, crc_z]);

    cnt_x   = defined_e_or(cnt_d, 0, cnt_d);
    cnt_y   = defined_e_or(cnt_d, 1, cnt_x);
    cnt_z   = defined_e_or(cnt_d, 2, cnt_y);

    //
    //
    // construct ribs
    //
    //

    translate(rib_lo)
    for
    (
      i =
      [ // [ B0-4: mode-bit, size:[x, y], count:[x, y], xform:[r, t] ]
        [ 0, [max_x, max_y], [cnt_x, cnt_y], [[0, 0, 0], [0, 0, 0]] ],
        [ 1, [max_y, max_h], [cnt_y, cnt_z], [[90, 0, -90], [max_x/2, 0, max_h/2]] ],
        [ 2, [max_x, max_h], [cnt_x, cnt_z], [[90, 0, 0], [0, max_y/2, max_h/2]] ],
        [ 3, [max_y, max_h], [cnt_y, cnt_z], [[90, 0, 90], [-max_x/2, 0, max_h/2]] ],
        [ 4, [max_x, max_h], [cnt_x, cnt_z], [[-90, 0, 0], [0, -max_y/2, max_h/2]] ],
      ]
    )
    {
      if ( binary_bit_is(rib_m, first(i), 0) == true )
      {
        si = second(i);   // size [x, y]
        ni = third(i);    // number [x, y]
        xi = i[3];        // transform [r, t]

        sx = first(si);
        sy = second(si);

        nx = first(ni);
        ny = second(ni);

        translate(second(xi))
        rotate(first(xi))
        union()
        {
          // ribs-x
          if (nx > 0)
          for (i = [0: nx-1])
          translate([(sx/nx*(1-nx)/2) + (sx/nx * i), 0, 0])
          extrude_linear_mss(rib_hx)
          square([rib_w, sy], center=true);

          // ribs-y
          if (ny > 0)
          for (i = [0: ny-1])
          translate([0, (sy/ny*(1-ny)/2) + (sy/ny * i), 0])
          extrude_linear_mss(rib_hy)
          square([sx, rib_w], center=true);
        }
      }
    }

    if (verb > 0)
    {
      // calculate rib heights
      rib_hxd = sum( [for (e=rib_hx) is_list(e) ? first(e) : e] );
      rib_hyd = sum( [for (e=rib_hy) is_list(e) ? first(e) : e] );

      // only when there are ribs on the lid (mode-bit '0' is for the lid)
      // can not be greater than max xy height less negative lower offset
      rib_rwh = wall_h + lip_h
              - max( 0, max([rib_hxd, rib_hyd]) + third(rib_lo) )
              * ( (binary_bit_is(rib_m, 0, 0) == true) ? 1 : 0 );

      echo(strl(["rib: mode = ", rib_m]));
      echo(strl(["rib: width = ", rib_w]));
      echo(strl(["rib: extrusion x = ", rib_hx]));
      echo(strl(["rib: height x = ", rib_hxd]));
      echo(strl(["rib: extrusion y = ", rib_hy]));
      echo(strl(["rib: height y = ", rib_hyd]));
      echo(strl(["rib: coverage [x, y, z] = ", [rcp_x, rcp_y, rcp_z]]));
      echo(strl(["rib: count [x, y, z] = ", [cnt_x, cnt_y, cnt_z]]));

      echo(strl(["rib: global offset = ", rib_lo]));
      echo(strl(["rib: remaining wall height = ", rib_rwh]));
    }
  }

  // interior walls
  module construct_interior_walls()
  {
    // wall
    config  = defined_e_or(wall, 0, wall);
    inst_l  = defined_e_or(wall, 1, empty_lst);

    // configuration
    wall_m  = defined_e_or(config, 0, config);
    defs_l  = defined_e_or(config, 1, empty_lst);

    // set a few values early for dependent defaults
    def_dw  = defined_e_or(defs_l, 0, wth);

    // wall limits (mx, my, mz)
    max_x   = first( wall_xy) - 2*(wth - eps);
    max_y   = second(wall_xy) - 2*(wth - eps);

    // B8-9: 'max_h' may include 0 to 2 'lip_h' (ie: one at top and bottom)
    max_h   = wall_h + min(2, binary_iw2i(wall_m, 8, 2)) * lip_h;

    // B10: global lower-lip offset
    wall_lo = binary_bit_is(wall_m, 10, 1) ? [0, 0, -lip_h] : zero3d;

    // B0-1: default wall end rounding
    cfg_vrm = let( i = binary_iw2i(wall_m, 0, 2) )
                (i == 1) ? [ 9, 10, 9, 10]                  // bevel
              : (i == 2) ? [ 3,  4, 3,  4]                  // fillet
              : (i == 3) ? [ 7,  8, 7,  8]                  // round-out
              :  0;                                         // none

    // configurations for top wall extrusion rounding factors for horizontal
    // wall using approximated semicircles with $fn segments for rounding
    // (must reverse for bottom and reorder x/y for vertical wall).
    cfg_wt_rm =
    [
      0,                                                        // none
      [[1,1],[1,1/2]],                                          // bevel-in
      [for (x=[0:1/get_fn(1)/2:1]) [1,sqrt(1+eps-pow(x,2))]],   // round-in
      [for (x=[1:-1/get_fn(1)/2:1/2]) [1,1-sqrt(1-pow(x,2))]],  // fillet-in
      [[1,1],[1,1+1/2]],                                        // bevel-out
      [for (x=[0:1/get_fn(1)/2:1]) [1,sqrt(1+eps+pow(x,2))]],   // fillet-out
      [for (x=[1:-1/get_fn(1)/2:1/2]) [1,1+sqrt(1-pow(x,2))]],  // round-out
    ];

    // B2-4: wall top rounding
    wt_rm_i = binary_iw2i(wall_m, 2, 3);
    s_wt_rm = select_ci( cfg_wt_rm, wt_rm_i, true );
    cfg_rt  = [def_dw/2, s_wt_rm];

    // B5-7: wall base rounding
    wb_rm_i = binary_iw2i(wall_m, 5, 3);
    s_wb_rm = select_ci( cfg_wt_rm, wb_rm_i, true );
    cfg_rb  = [def_dw/2, reverse(s_wb_rm)];

    // default height extrusion configuration
    cfg_he =
      (wt_rm_i  > 0 && wb_rm_i == 0) ? [max_h - def_dw/2, cfg_rt]       // top only
    : (wt_rm_i == 0 && wb_rm_i  > 0) ? [cfg_rb, max_h - def_dw/2]       // base only
    : (wt_rm_i  > 0 && wb_rm_i  > 0) ? [cfg_rb, max_h - def_dw, cfg_rt] // both
    :  max_h;                                                           // neither

    // configured configuration defaults
    def_he  = defined_e_or(defs_l, 1, cfg_he);
    def_vr  = defined_e_or(defs_l, 2, def_dw);
    def_vrm = defined_e_or(defs_l, 3, cfg_vrm);

    //
    //
    // construct walls
    //
    //

    // process wall instance list
    translate(wall_lo)
    for (inst=inst_l)
    {
      inst_t    = defined_e_or(inst, 0, inst);        // type

      inst_m    = defined_e_or(inst, 1, zero3d);      // *move
      inst_f    = defined_e_or(inst, 2, [1, 1, 1]);   // scale
      inst_r    = defined_e_or(inst, 3, zero3d);      // rotate

      inst_s    = defined_e_or(inst, 4, undef);       // *size
      inst_he   = defined_e_or(inst, 5, undef);       // *he
      inst_vr   = defined_e_or(inst, 6, undef);       // *vr
      inst_vrm  = defined_e_or(inst, 7, undef);       // *vrm

      //
      // default value updates based on wall type: (0=horizontal, 1=vertical)
      //

      // move vector
      type_m    = is_list(inst_m) ?
                  inst_m
                : (inst_t == 0) ?
                    [0, inst_m]
                  : [inst_m, 0];

      // max length horizontal or vertical base shape
      tdef_s    = (inst_t == 0) ?
                  [max_x, def_dw]
                : [def_dw, max_y];

      // wall base extrusion (adjusted for vertical walls)
      tdef_he   = !is_list(def_he) ?
                  def_he                    // use specified scalar value
                : (inst_t == 0) ?
                    def_he                  // horizontal: use list as defined
                  : [ for (he=def_he)       // vertical: reverse [x, y] scale factors
                        !is_list(he) ?
                          he
                        : [ first(he), [ for (s=second(he)) reverse(s) ] ]
                    ];

      // wall-end rounding radii (adjusted for vertical walls)
      tdef_vr   = !is_list(def_vr) ?
                  def_vr
                : (inst_t == 0) ?
                    def_vr
                  : shift_cd(def_vr, n=-1, r=false, d=false);

      // wall-end rounding modes (adjusted for vertical walls)
      tdef_vrm  = !is_list(def_vrm) ?
                  def_vrm
                : (inst_t == 0) ?
                    def_vrm
                  : shift_cd(def_vrm, n=+1, r=false, d=false);

      //
      // assign defaults when not specified with wall instance
      //

      s   = defined_or(inst_s, tdef_s);
      he  = defined_or(inst_he, tdef_he);
      vr  = defined_or(inst_vr, tdef_vr);
      vrm = defined_or(inst_vrm, tdef_vrm);

      //
      // construct wall instance
      //

      translate(type_m)
      scale(inst_f)
      rotate(inst_r)
      extrude_linear_mss(he)
      pg_rectangle(s, vr=vr, vrm=vrm, center=true);

      if (verb > 1)
        echo(strl(["wall-inst: [type, move, scale, rotation, size, he, vr, vrm] = ",
                  [inst_t, inst_m, inst_f, inst_r, s, he, vr, vrm]]));
    }

    if (verb > 0)
    {
      // handle special case: a single horizontal or vertical wall
      wall_cnt = is_list(inst_l) ? len(inst_l) : 1;

      echo(strl(["wall: configuration = ", config]));
      echo(strl(["wall: mode = ", wall_m]));

      echo(strl(["wall: max [x, y, h] = ", [max_x, max_y, max_h]]));

      echo(strl(["wall: default width = ", def_dw]));
      echo(strl(["wall: default extrusion = ", def_he]));
      echo(strl(["wall: default edge rounding = ", def_vr]));
      echo(strl(["wall: default edge rounding mode = ", def_vrm]));

      echo(strl(["wall: count = ", wall_cnt]));

      echo(strl(["wall: global offset = ", wall_lo]));
    }
  }

  // posts and post holes
  module construct_posts( add=false, remove=false )
  {
    // post
    config  = defined_e_or(post, 0, post);
    inst_l  = defined_e_or(post, 1, empty_lst);

    // configuration
    post_m  = defined_e_or(config, 0, config);
    defs_l  = defined_e_or(config, 1, empty_lst);

    // B4: post base rounded same as post top
    cfg_rbst        = binary_bit_is(post_m, 4, 1);

    // rounding constant configurations
    cfg_p_vr_sf     = (cfg_rbst == true) ? [0, 1/2, 1/2, 0] : [0, 1/2, 3/2, 0];
    cfg_p_vrm_filet = (cfg_rbst == true) ? [0, 1, 1, 0] : [0, 1, 4, 0];
    cfg_p_vrm_bevel = (cfg_rbst == true) ? [0, 5, 5, 0] : [0, 5, 10, 0];

    cfg_f0_vr_sf     = [2, 0, 1];
    cfg_f0_vrm_filet = [4, 0, 3];
    cfg_f0_vrm_bevel = [10, 0, 9];

    cfg_f1_vr_sf     = [0, 1, 1, 0];
    cfg_f1_vrm_filet = [0, 4, 3, 0];
    cfg_f1_vrm_bevel = [0, 10, 9, 0];

    // mode dependent configuration
    // B0-1: post rounding mode
    cfg_p_vrm       = let( i = binary_iw2i(post_m, 0, 2) )
                      (i == 1) ? cfg_p_vrm_bevel
                    : (i == 2) ? cfg_p_vrm_filet
                    : 0;

    // B2-3: fin rounding mode
    cfg_f0_vrm      = let( i = binary_iw2i(post_m, 2, 2) )
                      (i == 1) ? cfg_f0_vrm_bevel
                    : (i == 2) ? cfg_f0_vrm_filet
                    : 0;

    cfg_f1_vrm      = let( i = binary_iw2i(post_m, 2, 2) )
                      (i == 1) ? cfg_f1_vrm_bevel
                    : (i == 2) ? cfg_f1_vrm_filet
                    : 0;

    // B5: auxiliary screw hole height (through lid)
    cfg_h1_h        = binary_bit_is(post_m, 5, 1) ? lid_h : 0;

    // B6: re-calculate defaults with each instance.
    cfg_hp_idr      = binary_bit_is(post_m, 6, 1);

    // B8: total lip_h extension height (0: one, 1: both)
    lip_h_t         = ((binary_bit_is(post_m, 8, 1) ? 1 : 0) + 1) * lip_h;

    // B7: post1 and post2 heights (only one extends by lip height)
    cfg_p1_h        = (binary_bit_is(post_m, 7, 1) ? lip_h_t : 0) + wall_h;
    cfg_p2_h        = (binary_bit_is(post_m, 7, 0) ? lip_h_t : 0) + wall_h;

    // B9: global lower-lip offset
    post_lo = binary_bit_is(post_m, 9, 1) ? [0, 0, -lip_h] : zero3d;

    max_x   = first( wall_xy) - 2*(wth - eps);
    max_y   = second(wall_xy) - 2*(wth - eps);
    max_h   = wall_h + lip_h_t;

    //
    // configured configuration defaults
    //

    def_h0      = defined_e_or(defs_l, 0, empty_lst);
    def_h1      = defined_e_or(defs_l, 1, empty_lst);
    def_p1      = defined_e_or(defs_l, 2, empty_lst);
    def_h2      = defined_e_or(defs_l, 3, empty_lst);
    def_p2      = defined_e_or(defs_l, 4, empty_lst);
    def_f0      = defined_e_or(defs_l, 5, empty_lst);
    def_f1      = defined_e_or(defs_l, 6, empty_lst);
    def_dc      = defined_e_or(defs_l, 7, empty_lst);

    // hole0: normal & recessed screw common hole
    def_h0_d    = defined_e_or(def_h0, 0, 3.25);
    def_h0_h    = defined_e_or(def_h0, 1, max_h);
    def_h0_ho   = defined_e_or(def_h0, 2, 0);
    def_h0_da   = defined_e_or(def_h0, 3, 0);
    def_h0_ha   = defined_e_or(def_h0, 4, 0);
    def_h0_vr   = defined_e_or(def_h0, 5, 0);
    def_h0_vrm  = defined_e_or(def_h0, 6, 0);

    def_h0_rh   = defined_e_or(def_h0, 7, 0);
    def_h0_ro   = defined_e_or(def_h0, 8, 0);
    def_h0_rta  = defined_e_or(def_h0, 9, [0, 0]);
    def_h0_rba  = defined_e_or(def_h0,10, [0, 0]);

    //
    // default diameter calculations based on hole0
    //
    def_h1_d_c  = def_h0_d
                + defined_e_or(def_dc, 0, 0.0) * wth
                + defined_e_or(def_dc, 1, 0);

    def_p1_d_c  = def_h0_d
                + defined_e_or(def_dc, 2, 3.0) * wth
                + defined_e_or(def_dc, 3, wth/2);

    def_h2_d_c  = def_h0_d
                + defined_e_or(def_dc, 4, 2.0) * wth
                + defined_e_or(def_dc, 5, wth/2);

    def_p2_d_c  = def_h0_d
                + defined_e_or(def_dc, 6, 4.0) * wth
                + defined_e_or(def_dc, 7, wth/2);

    // hole1: normal thru lid hole
    def_h1_d    = defined_e_or(def_h1, 0, def_h1_d_c);
    def_h1_h    = defined_e_or(def_h1, 1, cfg_h1_h);
    def_h1_ho   = defined_e_or(def_h1, 2, -cfg_h1_h);
    def_h1_da   = defined_e_or(def_h1, 3, 0);
    def_h1_ha   = defined_e_or(def_h1, 4, 0);
    def_h1_vr   = defined_e_or(def_h1, 5, 0);
    def_h1_vrm  = defined_e_or(def_h1, 6, 0);

    def_h1_rh   = defined_e_or(def_h1, 7, 0);
    def_h1_ro   = defined_e_or(def_h1, 8, 0);
    def_h1_rta  = defined_e_or(def_h1, 9, [0, 0]);
    def_h1_rba  = defined_e_or(def_h1,10, [0, 0]);

    // post1: normal mount post
    def_p1_d    = defined_e_or(def_p1, 0, def_p1_d_c);
    def_p1_h    = defined_e_or(def_p1, 1, cfg_p1_h);
    def_p1_ho   = defined_e_or(def_p1, 2, 0);
    def_p1_da   = defined_e_or(def_p1, 3, 0);
    def_p1_ha   = defined_e_or(def_p1, 4, 0);
    def_p1_vr   = defined_e_or(def_p1, 5, cfg_p_vr_sf * wth);
    def_p1_vrm  = defined_e_or(def_p1, 6, cfg_p_vrm);

    def_p1_rh   = defined_e_or(def_p1, 7, 0);
    def_p1_ro   = defined_e_or(def_p1, 8, 0);
    def_p1_rta  = defined_e_or(def_p1, 9, [0, 0]);
    def_p1_rba  = defined_e_or(def_p1,10, [0, 0]);

    // hole2: recessed access hole thru lid
    def_h2_d    = defined_e_or(def_h2, 0, def_h2_d_c);
    def_h2_h    = defined_e_or(def_h2, 1, cfg_p2_h);
    def_h2_ho   = defined_e_or(def_h2, 2, -lid_h);
    def_h2_da   = defined_e_or(def_h2, 3, 0);
    def_h2_ha   = defined_e_or(def_h2, 4, 0);
    def_h2_vr   = defined_e_or(def_h2, 5, cfg_p_vr_sf * wth/2);
    def_h2_vrm  = defined_e_or(def_h2, 6, cfg_p_vrm);

    def_h2_rh   = defined_e_or(def_h2, 7, 0);
    def_h2_ro   = defined_e_or(def_h2, 8, 0);
    def_h2_rta  = defined_e_or(def_h2, 9, [0, 0]);
    def_h2_rba  = defined_e_or(def_h2,10, [0, 0]);

    // post2: recessed access post
    def_p2_d    = defined_e_or(def_p2, 0, def_p2_d_c);
    def_p2_h    = defined_e_or(def_p2, 1, cfg_p2_h);
    def_p2_ho   = defined_e_or(def_p2, 2, 0);
    def_p2_da   = defined_e_or(def_p2, 3, 0);
    def_p2_ha   = defined_e_or(def_p2, 4, 0);
    def_p2_vr   = defined_e_or(def_p2, 5, cfg_p_vr_sf * wth);
    def_p2_vrm  = defined_e_or(def_p2, 6, cfg_p_vrm);

    def_p2_rh   = defined_e_or(def_p2, 7, 0);
    def_p2_ro   = defined_e_or(def_p2, 8, 0);
    def_p2_rta  = defined_e_or(def_p2, 9, [0, 0]);
    def_p2_rba  = defined_e_or(def_p2,10, [0, 0]);

    // fins0: triangular fins
    def_f0_c    = defined_e_or(def_f0, 0, 4);
    def_f0_da   = defined_e_or(def_f0, 1, 360);
    def_f0_w    = defined_e_or(def_f0, 2, wth);
    def_f0_d_sf = defined_e_or(def_f0, 3, 1/5);
    def_f0_h_sf = defined_e_or(def_f0, 4, 5/8);
    def_f0_vr   = defined_e_or(def_f0, 5, cfg_f0_vr_sf * wth);
    def_f0_vrm  = defined_e_or(def_f0, 6, cfg_f0_vrm);

    // fins1: rectangular fins
    def_f1_c    = defined_e_or(def_f1, 0, 4);
    def_f1_da   = defined_e_or(def_f1, 1, 360);
    def_f1_w    = defined_e_or(def_f1, 2, wth);
    def_f1_d_sf = defined_e_or(def_f1, 3, 1/2);
    def_f1_h_sf = defined_e_or(def_f1, 4, 1);
    def_f1_vr   = defined_e_or(def_f1, 5, cfg_f1_vr_sf * wth);
    def_f1_vrm  = defined_e_or(def_f1, 6, cfg_f1_vrm);

    //
    //
    // construct posts
    //
    //

    // remove cylinder section
    module remove_cylinder ( d, r, eps_h=0, eps_d=0 )
    {
      h     = r[0];
      ho    = r[1];
      ta    = r[2];
      ba    = r[3];

      // top cut tilt and rotation
      tt  = defined_eon_or(ta, 0, 0);
      tr  = defined_e_or  (ta, 1, 0);

      // bottom cut tilt and rotation
      bt  = defined_eon_or(ba, 0, 0);
      br  = defined_e_or  (ba, 1, 0);

      if (verb > 2)
        echo(strl(["post-inst-cylinder-remove: [d, r, eps_h, eps_d] = ", [d, r, eps_h, eps_d]]));

      translate([0, 0, ho - eps_h/2])
      difference()
      {
        // cut blade [x, y, z]
        x = h; y = h; z = d;

        // cylinder removal section
        cylinder(d=d + eps_d, h=h + eps_h);

        // cut at top of cylinder
        rotate(tr)
        translate([0, -d/2, 0])
        translate([0, 0, h])
        rotate([tt, 0, 0])
        translate([-x/2, 0, 0])
        cube([x, y, z], center=false);

        // cut at bottom of cylinder
        rotate(br)
        translate([0, -d/2, 0])
        rotate([bt, 0, 0])
        translate([-x/2, 0, -z])
        cube([x, y, z], center=false);
      }
    }

    // construct fins around a cylinder
    module construct_fins(d, h, t, f)
    {
      c = defined_e_or(f, 0, 0);

      // move distance for fin to always contact polygon cylinder
      function fin_embed(r, w) =
        let
        (
          n = get_fn(r),
          d = polygon_regular_perimeter(n, r) / n
        )
        r - sqrt( pow(r,2) - pow(w/2, 2) - pow(d/2, 2) );

      if ( c > 0 )
      {
        da  = f[1];
        w   = f[2];
        df  = f[3];
        hf  = f[4];
        vr  = f[5];
        vrm = f[6];

        b   = d * df;
        l   = h * hf;

        if (verb > 2)
          echo(strl(["post-inst-cylinder-fins: [d, h, t, f] = ", [d, h, t, f]]));

        f_in = fin_embed(d/2, w);

        // triangular fins
        if ( t == 0 )
        {
          for (i = [0:c-1])
          {
            rotate([90, 0, da/c * i + 180])
            translate([-d/2 - b + f_in, 0, 0])
            extrude_linear_mss(w, center=true)
            pg_triangle_sas([l, 90, b], vr=vr, vrm=vrm);
          }
        }

        // rectangular fins
        if ( t == 1 )
        {
          for (i = [0:c-1])
          {
            rotate([0, 0, da/c * i])
            translate([b/2 + d/2 - f_in, 0, 0])
            extrude_linear_mss(l)
            pg_rectangle( [b, w], vr=vr, vrm=vrm, center=true);
          }
        }

      }
    }

    // construct a cylinder with optional fins
    module construct_cylinder ( en, c, r, ft, f, eps_h=0 )
    {
      if (en == true)
      {
        d     = c[0];
        h     = c[1];
        ho    = c[2];
        da    = c[3];
        ha    = c[4];
        vr    = c[5];
        vrm   = c[6];

        if (verb > 2)
          echo(strl(["post-inst-cylinder: [c, eps_h] = ", [c, eps_h]]));

        difference()
        {
          // construct post and fins
          translate([0, 0, ho - eps_h/2])
          {
            // late diameter and height adjustments
            d_adj = d + da;
            h_adj = h + ha;

            rotate_extrude()
            pg_rectangle([d_adj/2, h_adj + eps_h], vr=vr, vrm=vrm);

            construct_fins(d_adj, h_adj, ft, f);
          }

          // removal post section
          eps_h_a = (    add == true ) ? +eps*8 : 0;
          eps_h_r = ( remove == true ) ? -eps*8 : 0;

          remove_cylinder(d, r, eps_h=eps_h_a + eps_h_r, eps_d=d);
        }
      }
    }

    // pre-processing message
    if (verb > 0)
    {
      post_cfm  = ( add == true  && remove == false ) ? "add"
                : ( add == false && remove == true  ) ? "remove"
                : ( add == true  && remove == true  ) ? "add & remove"
                : "do nothing";

      echo(strl(["post: construction phase = ", post_cfm]));
    }

    //
    // process 'post' instance list
    //
    translate(post_lo)
    for (inst=inst_l)
    {
      inst_t    = defined_e_or(inst, 0, inst);        // type

      inst_a    = defined_e_or(inst, 1, zero3d);      // align [x, y, z]
      inst_m    = defined_e_or(inst, 2, zero3d);      // move [x, y, z]
      inst_r    = defined_e_or(inst, 3, zero3d);      // rotate [x, y, z]

      inst_h0   = defined_e_or(inst, 4, undef);       // hole0
      inst_h1   = defined_e_or(inst, 5, undef);       // hole1
      inst_p    = defined_e_or(inst, 6, undef);       // post

      inst_f    = defined_e_or(inst, 7, undef);       // fins

      // alignment
      inst_ax   = defined_e_or(inst_a, 0, 0);
      inst_ay   = defined_e_or(inst_a, 1, 0);
      inst_az   = defined_e_or(inst_a, 2, 0);

      inst_zx   = limit(inst_ax, -1, 1) * (max_x + wth)/2;
      inst_zy   = limit(inst_ay, -1, 1) * (max_y + wth)/2;
      inst_zz   = limit(inst_az, -1, 0) * lid_h;

      //
      // default value updates based on types
      //

      // B0: post-type
      inst_pt     = binary_iw2i(inst_t, 0, 1);

      // hole0:

      // hole1:
      tdef_h1_d_c = (inst_pt == 0) ? def_h1_d_c : def_h2_d_c;
      tdef_h1_d   = (inst_pt == 0) ? def_h1_d : def_h2_d;
      tdef_h1_h   = (inst_pt == 0) ? def_h1_h : def_h2_h;
      tdef_h1_ho  = (inst_pt == 0) ? def_h1_ho : def_h2_ho;
      tdef_h1_da  = (inst_pt == 0) ? def_h1_da : def_h2_da;
      tdef_h1_ha  = (inst_pt == 0) ? def_h1_ha : def_h2_ha;
      tdef_h1_vr  = (inst_pt == 0) ? def_h1_vr : def_h2_vr;
      tdef_h1_vrm = (inst_pt == 0) ? def_h1_vrm : def_h2_vrm;

      tdef_h1_rh  = (inst_pt == 0) ? def_h1_rh : def_h2_rh;
      tdef_h1_ro  = (inst_pt == 0) ? def_h1_ro : def_h2_ro;
      tdef_h1_rta = (inst_pt == 0) ? def_h1_rta : def_h2_rta;
      tdef_h1_rba = (inst_pt == 0) ? def_h1_rba : def_h2_rba;

      // post:
      tdef_p_d_c  = (inst_pt == 0) ? def_p1_d_c : def_p2_d_c;
      tdef_p_d    = (inst_pt == 0) ? def_p1_d : def_p2_d;
      tdef_p_h    = (inst_pt == 0) ? def_p1_h : def_p2_h;
      tdef_p_ho   = (inst_pt == 0) ? def_p1_ho : def_p2_ho;
      tdef_p_da   = (inst_pt == 0) ? def_p1_da : def_p2_da;
      tdef_p_ha   = (inst_pt == 0) ? def_p1_ha : def_p2_ha;
      tdef_p_vr   = (inst_pt == 0) ? def_p1_vr : def_p2_vr;
      tdef_p_vrm  = (inst_pt == 0) ? def_p1_vrm : def_p2_vrm;

      tdef_p_rh   = (inst_pt == 0) ? def_p1_rh : def_p2_rh;
      tdef_p_ro   = (inst_pt == 0) ? def_p1_ro : def_p2_ro;
      tdef_p_rta  = (inst_pt == 0) ? def_p1_rta : def_p2_rta;
      tdef_p_rba  = (inst_pt == 0) ? def_p1_rba : def_p2_rba;

      // B1: fins-type
      inst_ft     = binary_iw2i(inst_t, 1, 1);

      // fins:
      tdef_f_c    = (inst_ft == 0) ? def_f0_c : def_f1_c;
      tdef_f_da   = (inst_ft == 0) ? def_f0_da : def_f1_da;
      tdef_f_w    = (inst_ft == 0) ? def_f0_w : def_f1_w;
      tdef_f_d_sf = (inst_ft == 0) ? def_f0_d_sf : def_f1_d_sf;
      tdef_f_h_sf = (inst_ft == 0) ? def_f0_h_sf : def_f1_h_sf;
      tdef_f_vr   = (inst_ft == 0) ? def_f0_vr : def_f1_vr;
      tdef_f_vrm  = (inst_ft == 0) ? def_f0_vrm : def_f1_vrm;

      //
      // assign defaults when not specified with post instance
      //

      // hole0: common screw hole (for all post types)
      h0_en   = (remove == true);

      h0_d    = defined_e_or(inst_h0, 0, def_h0_d);
      h0_h    = defined_e_or(inst_h0, 1, def_h0_h);
      h0_ho   = defined_e_or(inst_h0, 2, def_h0_ho);
      h0_da   = defined_e_or(inst_h0, 3, def_h0_da);
      h0_ha   = defined_e_or(inst_h0, 4, def_h0_ha);
      h0_vr   = defined_e_or(inst_h0, 5, def_h0_vr);
      h0_vrm  = defined_e_or(inst_h0, 6, def_h0_vrm);

      h0      = [h0_d, h0_h, h0_ho, h0_da, h0_ha, h0_vr, h0_vrm];

      h0_rh   = defined_e_or(inst_h0, 7, def_h0_rh);
      h0_ro   = defined_e_or(inst_h0, 8, def_h0_ro);
      h0_rta  = defined_e_or(inst_h0, 9, def_h0_rta);
      h0_rba  = defined_e_or(inst_h0,10, def_h0_rba);

      h0r     = [h0_rh, h0_ro, h0_rta, h0_rba];

      //
      // assign hole and post defaults based on selected mode 'cfg_hp_idr'
      //
      tdef_h1_ims = (cfg_hp_idr == true) ? h0_d + tdef_h1_d_c : tdef_h1_d;
      tdef_p_ims  = (cfg_hp_idr == true) ? h0_d + tdef_p_d_c : tdef_p_d;

      // hole1: aux screw hole or thru lid access hole
      h1_en   = (remove == true);

      h1_d    = defined_e_or(inst_h1, 0, tdef_h1_ims);
      h1_h    = defined_e_or(inst_h1, 1, tdef_h1_h);
      h1_ho   = defined_e_or(inst_h1, 2, tdef_h1_ho);
      h1_da   = defined_e_or(inst_h1, 3, tdef_h1_da);
      h1_ha   = defined_e_or(inst_h1, 4, tdef_h1_ha);
      h1_vr   = defined_e_or(inst_h1, 5, tdef_h1_vr);
      h1_vrm  = defined_e_or(inst_h1, 6, tdef_h1_vrm);

      h1      = [h1_d, h1_h, h1_ho, h1_da, h1_ha, h1_vr, h1_vrm];

      h1_rh   = defined_e_or(inst_h1, 7, tdef_h1_rh);
      h1_ro   = defined_e_or(inst_h1, 8, tdef_h1_ro);
      h1_rta  = defined_e_or(inst_h1, 9, tdef_h1_rta);
      h1_rba  = defined_e_or(inst_h1,10, tdef_h1_rba);

      h1r     = [h1_rh, h1_ro, h1_rta, h1_rba];

      // post: post and fins
      p_en    = (add == true);

      p_d     = defined_e_or(inst_p, 0, tdef_p_ims);
      p_h     = defined_e_or(inst_p, 1, tdef_p_h);
      p_ho    = defined_e_or(inst_p, 2, tdef_p_ho);
      p_da    = defined_e_or(inst_p, 3, tdef_p_da);
      p_ha    = defined_e_or(inst_p, 4, tdef_p_ha);
      p_vr    = defined_e_or(inst_p, 5, tdef_p_vr);
      p_vrm   = defined_e_or(inst_p, 6, tdef_p_vrm);

      p       = [p_d, p_h, p_ho, p_da, p_ha, p_vr, p_vrm];

      p_rh    = defined_e_or(inst_p, 7, tdef_p_rh);
      p_ro    = defined_e_or(inst_p, 8, tdef_p_ro);
      p_rta   = defined_e_or(inst_p, 9, tdef_p_rta);
      p_rba   = defined_e_or(inst_p,10, tdef_p_rba);

      pr      = [p_rh, p_ro, p_rta, p_rba];

      // post-fins
      f_c     = defined_e_or(inst_f, 0, tdef_f_c);
      f_da    = defined_e_or(inst_f, 1, tdef_f_da);
      f_w     = defined_e_or(inst_f, 2, tdef_f_w);
      f_d_sf  = defined_e_or(inst_f, 3, tdef_f_d_sf);
      f_h_sf  = defined_e_or(inst_f, 4, tdef_f_h_sf);
      f_vr    = defined_e_or(inst_f, 5, tdef_f_vr);
      f_vrm   = defined_e_or(inst_f, 6, tdef_f_vrm);

      f       = [f_c, f_da, f_w, f_d_sf, f_h_sf, f_vr, f_vrm];

      //
      // construct post instance
      //

      translate(inst_m)                       // do separately to allow for 2d
      translate([inst_zx, inst_zy, inst_zz])  //  moves in 'inst_m' of form [x, y]
      rotate(inst_r)
      union()
      {
        construct_cylinder(p_en, p, pr, inst_ft, f);

        construct_cylinder(h0_en, h0, h0r, eps_h=eps*8);
        construct_cylinder(h1_en, h1, h1r, eps_h=eps*8);
      }

      if (verb > 1)
        echo(strl(["post-inst: [type, align, move, rotation, hole0, hole1, post, fins] = ",
                  [inst_t, inst_a, inst_m, inst_r, inst_h0, inst_h1, inst_p, inst_f]]));
    }

    // post-processing message
    if (verb > 0)
    {
      // handle special case: a single post
      post_cnt  = is_list(inst_l) ? len(inst_l) : 1;

      echo(strl(["post: configuration = ", config]));
      echo(strl(["post: mode = ", post_m]));

      echo(strl(["post: count = ", post_cnt]));
    }
  }

  // limit child to wall interior volume
  module envelop_assembly( envelop=false )
  {
    if ( envelop == true )
    {
      intersection()
      {
        union()
        {
          construct_exterior_walls( true );
          construct_lips( true );
        }

        children();
      }
    }
    else
    {
      children();
    }
  }

  // assembly feature additions
  module assembly_add()
  {
    if ( wall_h > 0 && binary_bit_is(mode, 4, 0) )
    {
      construct_exterior_walls();
    }

    if ( is_defined( lip ) && binary_bit_is(mode, 5, 0) )
    {
      construct_lips();
    }

    if ( lid_h > 0 && binary_bit_is(mode, 6, 0) )
    {
      construct_lid();
    }

    //
    // better to apply envelop_assembly() to union of all?
    //

    if ( is_defined( rib ) && binary_bit_is(mode, 7, 0) )
    {
      envelop_assembly( mode_int_mask == true )
      construct_ribs();
    }

    if ( is_defined( wall ) && binary_bit_is(mode, 8, 0) )
    {
      envelop_assembly( mode_int_mask == true )
      construct_interior_walls();
    }

    if ( is_defined( post ) && binary_bit_is(mode, 9, 0) )
    {
      envelop_assembly( mode_int_mask == true )
      construct_posts( add=true );
    }

    if ( is_defined( shape ) && binary_bit_is(mode, 11, 0) )
    {
      // should not be enclosure envelope limited
      construct_shapes();
    }
  }

  // assembly feature removals
  module assembly_remove()
  {
    if ( is_defined( post ) && binary_bit_is(mode, 9, 0) )
    {
      construct_posts( remove=true );
    }

    if ( is_defined( hole ) && binary_bit_is(mode, 10, 0) )
    {
      construct_holes();
    }
  }

  //
  //
  // global parameter calculation
  //
  //

  // decode mode configurations
  mode_size_in  = binary_bit_is(mode, 0, 1);
  mode_int_mask = binary_bit_is(mode, 1, 1);
  mode_scale_io = binary_bit_is(mode, 2, 1);
  mode_lmt_vrm  = binary_bit_is(mode, 3, 0);

  // specified wall extrusion height
  // calculate total extrusion 'h_h' height of all sections
  h_h           = extrude_linear_mss_eht( h );

  // specified base size
  size_x        = defined_e_or(size, 0, size);
  size_y        = defined_e_or(size, 1, size_x);

  // limit rounding mode to those options that make sense; set={0, 5, 1}
  // limit each element when 'vrm' is a list
  vrm_ci        = (mode_lmt_vrm == false) ? vrm
                : is_list(vrm) ?
                  [for (e=vrm) select_ci(v=[0, 5, 1], i=e, l=false)]
                : select_ci(v=[0, 5, 1], i=vrm, l=false);

  // wall lip default height (set to zero when there is no lip)
  // 'lip_h', bit '1', is set globally (ensure coherency with bits of 'lip')
  lip_hd        = is_defined(lip) ? wth : 0;
  lip_h         = defined_e_or(lip, 1, lip_hd);

  // lid extrusion height (calculate total height of all sections)
  lid_h         = extrude_linear_mss_eht( lid );

  // wall height
  wall_h        = (mode_size_in == true) ? h_h - lip_h : h_h - lip_h - lid_h;

  // wall x and y insets (usually negative, but allow positive)
  wall_od       = ( is_defined(inset) && is_scalar(inset) ) ? inset : 0;
  wall_ox       = defined_e_or(inset, 0, wall_od) * -1;
  wall_oy       = defined_e_or(inset, 1, wall_od) * -1;

  // exterior envelope of enclosure [encl_x, encl_y, encl_z]
  encl_x        = (mode_size_in == true) ? size_x + 2*wth - wall_ox : size_x;
  encl_y        = (mode_size_in == true) ? size_y + 2*wth - wall_oy : size_y;
  encl_z        = (mode_size_in == true) ? wall_h + lip_h + lid_h : h_h;

  // exterior size of wall x and y
  wall_xy       = [encl_x + wall_ox, encl_y + wall_oy];

  // interior size of enclosure
  szint_x = first (wall_xy) - 2*wth;
  szint_y = second(wall_xy) - 2*wth;
  szint_z = wall_h + lip_h;

  if (verb > 0)
  {
    echo(strl(["box: construction begin"]));

    echo(strl(["box: exterior dimensions [x, y, z] = ", [encl_x, encl_y, encl_z]]));
    echo(strl(["box: interior dimensions [x, y, z] = ", [szint_x, szint_y, szint_z]]));
  }

  //
  //
  //  box and feature construction
  //
  //

  alignments =
  [
    [0, -encl_x, -szint_x -wth*2, -szint_x, +szint_x, +szint_x +wth*2, +encl_x ]/2,
    [0, -encl_y, -szint_y -wth*2, -szint_y, +szint_y, +szint_y +wth*2, +encl_y ]/2,
    [lid_h, 0, lid_h -encl_z/2, -wall_h/2, -wall_h, -wall_h -lip_h]
  ];

  align_x = select_ci ( alignments.x, defined_e_or(align, 0, 0), false );
  align_y = select_ci ( alignments.y, defined_e_or(align, 1, 0), false );
  align_z = select_ci ( alignments.z, defined_e_or(align, 2, 0), false );

  translate([align_x, align_y, align_z])
  difference()
  {
    assembly_add();
    assembly_remove();
  }

  if (verb > 0)
  {
    echo(strl(["box: alignment [x, y, z] = ", [align_x, align_y, align_z]]));

    echo(strl(["box: construction end"]));
  }
}

//! Get the bounding box dimensions for a specified project box.
/***************************************************************************//**
  \param  bbox   <integer> bounding box selections {0=exterior, 1=interior}.

  \details

    This function returns the bounding box dimensions for the specified
    project box. The parameter values must correspond to those of the
    box in question. Detailed descriptions of the undocumented
    parameters can be found in project_box_rectangle().
*******************************************************************************/
function project_box_rectangle_size
(
  wth,
  h,
  size,

  inset,

  lid,
  lip,

  mode = 0,

  bbox = 0
) =
  let
  (
    //
    // maintain coherence with
    //  global parameter calculation in project_box_rectangle()
    //

    mode_size_in  = binary_bit_is(mode, 0, 1),

    h_h           = extrude_linear_mss_eht( h ),

    size_x        = defined_e_or(size, 0, size),
    size_y        = defined_e_or(size, 1, size_x),

    lip_hd        = is_defined(lip) ? wth : 0,
    lip_h         = defined_e_or(lip, 1, lip_hd),

    lid_h         = extrude_linear_mss_eht( lid ),

    wall_h        = (mode_size_in == true) ? h_h - lip_h : h_h - lip_h - lid_h,

    wall_od       = ( is_defined(inset) && is_scalar(inset) ) ? inset : 0,
    wall_ox       = defined_e_or(inset, 0, wall_od) * -1,
    wall_oy       = defined_e_or(inset, 1, wall_od) * -1,

    encl_x        = (mode_size_in == true) ? size_x + 2*wth - wall_ox : size_x,
    encl_y        = (mode_size_in == true) ? size_y + 2*wth - wall_oy : size_y,
    encl_z        = (mode_size_in == true) ? wall_h + lip_h + lid_h : h_h,

    wall_xy       = [encl_x + wall_ox, encl_y + wall_oy],

    szint_x = first (wall_xy) - 2*wth,
    szint_y = second(wall_xy) - 2*wth,
    szint_z = wall_h + lip_h
  )
  bbox ? [szint_x, szint_y, szint_z] : [encl_x, encl_y, encl_z];


//! @}
//! @}


//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE example_multiple;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <shapes/select_common_2d.scad>;
    include <shapes/select_common_3d.scad>;
    include <transforms/base_cs.scad>;
    include <transforms/layout.scad>;
    include <parts/3d/enclosure/project_box_rectangle.scad>;

    wth = 2; h = 8; sx = 75; sy = 50; vr = 5; vrm = 2;

    translate([0,0,0])                              // bottom
    project_box_rectangle( wth=wth, h=h, size=[sx,sy], vr=vr, vrm=vrm, lip=1, lid=wth );

    for (z = [1,3]) translate([0,0, (h+4)*z])       // mid-sections
    project_box_rectangle( wth=wth, h=h, size=[sx,sy], vr=vr, vrm=vrm, lip=9 );

    translate([0,0,(h+4)*4 + h]) mirror([0,0,1])    // top
    project_box_rectangle( wth=wth, h=h, size=[sx,sy], vr=vr, vrm=vrm, lip=2, lid=wth );

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "front diag";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

/*
BEGIN_SCOPE example_bottom;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <shapes/select_common_2d.scad>;
    include <shapes/select_common_3d.scad>;
    include <transforms/base_cs.scad>;
    include <transforms/layout.scad>;
    include <parts/3d/enclosure/project_box_rectangle.scad>;

    $fn = 18;

    wth = 1;

    lid_rounding = [for (s=[0:1/32:1/8]) 1-pow(s,2)/2];
    lid_profile  = [[wth/3, reverse(lid_rounding)], wth/3, [wth/3, lid_rounding]];

    // set default post support fin count to '0' and assign 'undef'
    //   to other parameters to  use their default values.
    function post(x, o) =
      [
        [0, [undef, undef, undef, undef, undef, [0]]],
        [
          [x, [-1,-1], [+1,+1]*o],
          [x, [-1,+1], [+1,-1]*o],
          [x, [+1,-1], [-1,+1]*o],
          [x, [+1,+1], [-1,-1]*o],
        ]
      ];

    project_box_rectangle
    (
      wth = wth,
      size = [100, 60],
      h = [[1, [1.05,1]], 7, [5, [1,.99,1]], 6, [6, [1,1.05,1]]],
      vr = 2,
      vrm = 1,

      inset = 5,

      lip = 1,
      lid = lid_profile,
      rib = 0,
      wall = [13, [[1, -11.5], [1, +11.5] ]],
      post = post(0, wth*3.25),

      mode = 1
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

/*
BEGIN_SCOPE example_lip;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <shapes/select_common_2d.scad>;
    include <shapes/select_common_3d.scad>;
    include <transforms/base_cs.scad>;
    include <transforms/layout.scad>;
    include <parts/3d/enclosure/project_box_rectangle.scad>;

    wth  = 2;
    size = [20, 40];
    lid  = wth;
    rib  = [0, wth/2];

    vr   = 5;
    vrm  = 2;

    lip1 = [1, undef, 49.0, 10, [3,5,2], [ [0, [0,1], [0,-1]] ] ];
    lip2 = [2, undef, 49.0, 10, [3,5,2], [ [1, [0,1], [0,+1]] ] ];

    translate([-size.x*2/3, 0, 0])
    project_box_rectangle ( wth=wth, size=size, h=6, lid=lid, rib=rib, vr=vr, vrm=vrm, lip = lip1 );

    translate([+size.x*2/3, 0, 0])
    project_box_rectangle ( wth=wth, size=size, h=5, lid=lid, rib=rib, vr=vr, vrm=vrm, lip = lip2 );

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "top front right back diag";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//

