//! A standard selection and configuration scheme for common 2D shape construction.
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

    \amu_define group_name  (Select Common 2d)
    \amu_define group_brief (Selection and configuration for common 2D shapes.)

  \amu_include (include/amu/doxyg_init_pd_gds_ipg.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group and macros.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/doxyg_define_in_parent_open.amu)
  \amu_include (include/amu/includes_required.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//! Select configure and construct one of the available 2d shapes.
/***************************************************************************//**
  \param    type <integer> Shape type index.

  \param    argv <decimal-list | decimal> Shape dependent argument vector.

  \param    center <boolean> Center about origin.

  \param    verb <integer> Output verbosity (0-2).

  \details

    This module provides a standard scheme for selecting and
    configuring the arguments of most 2D shapes available in the
    library, offering a consistent and flexible way to include,
    configure, and modify 2D shapes.

    ### argv

    Each shape is configured using the parameter \p argv. The four
    elements of this parameter are as follows:

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | decimal-list-n \| decimal | 1         | \p size : shape size
      1 | decimal-list-n \| decimal | undef     | \p vr (\p sr) : shape rounding
      2 | integer-list-n \| integer | 1         | \p vrm : shape rounding mode
      3 | integer           |  5                | \p fn : shape rounding facets
      4 | integer           |  0                | shape modifier

    #### argv[4]: shape modifier

       v  | modifier description
    :----:|:------------------------------------
        0 | none

    ### type

    Dimensioning is shape dependent. The required dimensioning
    arguments for each supported shape are shown in the following
    table. All supported shapes and their associated arguments are
    summarized in the following table:

    #### standard shape types

       t  | shapes                | parameters      | shape reference
    :----:|:---------------------:|:---------------:|:----------------------------
        1 | circle                |  r              | [circle()]
        2 | ngon                  |  r, n           | pg_ngon()
        3 | rectangle             |  size           | pg_rectangle()
        4 | rectangle sr          |  size           | pg_rectangle_rs()
        5 | rhombus               |  size           | pg_rhombus()
        6 | elliptical sector     |  r, v1, v2      | pg_elliptical_sector()
        7 | triangle vertices     |  v1, v2, v3     | pg_triangle_ppp()
        8 | triangle sides        |  s1, s2, s3     | pg_triangle_sss()
        9 | star                  |  size, n        | star2d()
       10 | corner round          |  r, m, v1, v2   | pg_corner_round()

    \amu_define scope_id      (example)
    \amu_define title         (Selection example)
    \amu_define image_views   (top)
    \amu_define image_size    (sxga)

    \amu_include (include/amu/scope_diagrams_3d.amu)

    #### custom shape types

       t  | shapes                | parameters      | function invocation name
    :----:|:---------------------:|:---------------:|:----------------------------
       50 | custom shape 1        |  size           | \p select_common_2d_shape_50()
       51 | custom shape 2        |  size           | \p select_common_2d_shape_51()
       52 | custom shape 3        |  size           | \p select_common_2d_shape_52()
       53 | custom shape 4        |  size           | \p select_common_2d_shape_53()
       54 | custom shape 5        |  size           | \p select_common_2d_shape_54()

    User-defined custom shape functions can be selected by defining a
    shape function using one of the reserved custom shape function
    names, and then referencing the corresponding shape type listed in
    the table above. The custom function prototype and an example is
    provided below.

    <b>Prototype:</b>

    \code{.C}
    // custom shape module, type 50

    module select_common_2d_shape_50(size, vr, vrm, fn, center)
    {

    };
    \endcode

    \amu_define scope_id      (example_custom)
    \amu_define title         (Custom shape example)
    \amu_define image_views   (top)
    \amu_define image_size    (sxga)

    \amu_include (include/amu/scope_diagrams_3d.amu)

  [circle()]: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Using_the_2D_Subsystem#circle
*******************************************************************************/
module select_common_2d_shape
(
  type = 0,
  argv,
  center = false,
  verb = 0
)
{
  module construct_shape()
  {
    // circle
    if      ( type == 1 )
      circle
      (
             r = size
      );

    // ngon
    else if ( type == 2 )
      pg_ngon
      (
             r = defined_e_or(size, 0, size),
             n = defined_e_or(size, 1, 5),
            vr = vr,
           vrm = vrm,
           vfn = fn,
        center = center
      );

    // rectangle
    else if ( type == 3 )
      pg_rectangle
      (
          size = size,
            vr = vr,
           vrm = vrm,
           vfn = fn,
        center = center
      );

    // rectangle_rs
    else if ( type == 4 )
      pg_rectangle_rs
      (
          size = size,
            sr = vr,
        center = center
      );

    // rhombus
    else if ( type == 5 )
      pg_rhombus
      (
          size = size,
            vr = vr,
           vrm = vrm,
           vfn = fn,
        center = center
      );

    // elliptical sector
    else if ( type == 6 )
      pg_elliptical_sector
      (
             r = defined_e_or(size, 0, size),
            v1 = defined_e_or(size, 1, x_axis2d_uv),
            v2 = defined_e_or(size, 2, x_axis2d_uv)
      );

    // triangle_ppp
    else if ( type == 7 )
      let
      (
        v1 = defined_e_or(size, 0, size * origin2d),
        v2 = defined_e_or(size, 1, size * y_axis2d_uv),
        v3 = defined_e_or(size, 2, size * x_axis2d_uv)
      )
      pg_triangle_ppp
      (
            c = [v1, v2, v3],
            vr = vr,
           vrm = vrm,
           vfn = fn,
            cm = center ? 1 : 0
      );

    // triangle_sss
    else if ( type == 8 )
      let
      (
        s1 = defined_e_or(size, 0, size),
        s2 = defined_e_or(size, 1, s1),
        s3 = defined_e_or(size, 2, s2)
      )
      pg_triangle_sss
      (
            v = [s1, s2, s3],
            vr = vr,
           vrm = vrm,
           vfn = fn,
            cm = center ? 1 : 0
      );

    // star2d
    else if ( type == 9 )
      star2d
      (
          size = defined_e_or(size, 0, size),
             n = defined_e_or(size, 1, 5),
            vr = vr
      );

    // corner_round
    else if ( type == 10 )
      pg_corner_round
      (
             r = defined_e_or(size, 0, size),
             m = defined_e_or(size, 1, 1),
            v1 = defined_e_or(size, 2, x_axis2d_uv),
            v2 = defined_e_or(size, 3, y_axis2d_uv)
      );

    //
    // custom shapes
    //
    else if ( type == 50 )
      select_common_2d_shape_50(size=size, vr=vr, vrm=vrm, fn=fn, center=center);
    else if ( type == 51 )
      select_common_2d_shape_51(size=size, vr=vr, vrm=vrm, fn=fn, center=center);
    else if ( type == 52 )
      select_common_2d_shape_52(size=size, vr=vr, vrm=vrm, fn=fn, center=center);
    else if ( type == 53 )
      select_common_2d_shape_53(size=size, vr=vr, vrm=vrm, fn=fn, center=center);
    else if ( type == 54 )
      select_common_2d_shape_54(size=size, vr=vr, vrm=vrm, fn=fn, center=center);
  }

  //
  // decode parameters
  //

  size  = defined_eon_or(argv, 0, 1);       // dimensions (type dependent)
  vr    = defined_e_or  (argv, 1, undef);   // rounding
  vrm   = defined_e_or  (argv, 2, 1);       // rounding mode
  fn    = defined_e_or  (argv, 3, 5);       // facets
  sm    = defined_e_or  (argv, 4, 0);       // shape modifier

  construct_shape();

  if (verb > 0)
  {
    log_info(strl(["type=", type, ", argv=", argv, ", center=", center]));

    if (verb > 1)
      echo(size=size, vr=vr, vrm=vrm, fn=fn, sm=sm);
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

    size  = [50, 40, 30];
    vr    = [1, 5, 5];
    vrm   = [1, 1, 5];
    fn    = 9;

    type  = 8;
    argv  = [size, vr, vrm, fn];

    select_common_2d_shape(type=type, argv=argv, center=true);

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
BEGIN_SCOPE example_custom;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <shapes/select_common_2d.scad>;

    module select_common_2d_shape_50(size, vr, vrm, fn, center)
    {
      square(size, center=center);
    }

    size  = [50, 40];
    vr    = undef;
    vrm   = undef;
    fn    = undef;

    type  = 50;
    argv  = [size, vr, vrm, fn];

    select_common_2d_shape(type=type, argv=argv, center=true);

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
