//! A standard selection and configuration scheme for common 3D shape construction.
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

    \amu_define group_name  (Select Common 3d)
    \amu_define group_brief (Selection and configuration for common 3D shapes.)

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

//! Select configure and construct one of the available 3d shapes.
/***************************************************************************//**
  \param    type <integer> Shape type index.

  \param    argv <decimal-list | decimal> Shape dependent argument vector.

  \param    center <boolean> Center about origin.

  \param    verb <integer> Output verbosity (0-2).

  \details

    This module provides a standard scheme for selecting and
    configuring the arguments of most 3D shapes available in the
    library, offering a consistent and flexible way to include,
    configure, and modify 3D shapes.

    ### argv

    Each shape is configured using the parameter \p argv. The four
    elements of this parameter are as follows:

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | decimal-list-n \| decimal | 1         | \p size : shape size
      1 | decimal-list-n \| decimal | undef     | \p vr (\p sr) : shape rounding
      2 | integer-list-n \| integer | 0         | \p vrm : shape rounding mode
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
        1 | cylinder              |  h, r1, r2      | [cylinder()]
        2 | cone                  |  size           | cone()
        3 | cuboid                |  size           | cuboid()
        4 | ellipsoid             |  size           | ellipsoid()
        5 | ellipsoid section     |  size, a1, a2   | ellipsoid_s()
        6 | quadratic pyramid     |  size           | pyramid_t()
        7 | triangular pyramid    |  size           | pyramid_q()
        8 | star 3d               |  size, n, half  | star3d()
     100+ | Polyhedrons database  |  size           | (see below)

    \amu_define scope_id      (example)
    \amu_define title         (Selection example)
    \amu_define image_views   (top front diag)
    \amu_define image_size    (sxga)

    \amu_include (include/amu/scope_diagrams_3d.amu)

    #### custom shape types

       t  | shapes                | parameters      | function invocation name
    :----:|:---------------------:|:---------------:|:----------------------------
       50 | custom shape 1        |  size           | \p select_common_3d_shape_50()
       51 | custom shape 2        |  size           | \p select_common_3d_shape_51()
       52 | custom shape 3        |  size           | \p select_common_3d_shape_52()
       53 | custom shape 4        |  size           | \p select_common_3d_shape_53()
       54 | custom shape 5        |  size           | \p select_common_3d_shape_54()

    User-defined custom shape functions can be selected by defining a
    shape function using one of the reserved custom shape function
    names, and then referencing the corresponding shape type listed in
    the table above. The custom function prototype and an example is
    provided below.

    <b>Prototype:</b>

    \code{.C}
    // custom shape module, type 50

    module select_common_3d_shape_50(size, vr, vrm, fn, center)
    {

    };
    \endcode

    \amu_define scope_id      (example_custom)
    \amu_define title         (Custom shape example)
    \amu_define image_views   (top front diag)
    \amu_define image_size    (sxga)

    \amu_include (include/amu/scope_diagrams_3d.amu)

    ## Polyhedrons database inclusion

    \amu_define includes_required_add
    (
      database/geometry/polyhedra/polyhedra_all.scad
      shapes/polyhedron_db.scad
    )
    \amu_include (include/amu/includes_required.amu)

    Polyhedra available through ph_db_polyhedron() may also be included
    in the 3d shape selection options. These shapes are accessible when
    the ph_db_polyhedron() module is included as shown under
    `Requires:' above. As described in its documentation, a polyhedron
    database must also be included. In this example below, the \p
    polyhedra_all database is used; however, a smaller database may be
    configured instead, as described in the ph_db_polyhedron()
    documentation.

    \amu_define scope_id      (example_ph_db)
    \amu_define title         (Polyhedrons database selection example)
    \amu_define image_views   (top front diag)
    \amu_define image_size    (sxga)

    \amu_include (include/amu/scope_diagrams_3d.amu)

  [cylinder()]: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Primitive_Solids#cylinder
*******************************************************************************/
module select_common_3d_shape
(
  type = 0,
  argv,
  center = false,
  verb = 0
)
{
  module construct_shape()
  {
    // polyhedron database available when modules global data table is defined
    pd_db_available   = !( is_undef(ph_db_dtc) || is_undef(ph_db_dtr) );

    // polyhedron database type offset
    pd_db_type_offset = 99;

    // cylinder
    if      ( type == 1 )
      let
      (
        h  = defined_e_or(size, 0, size),
        r1 = defined_e_or(size, 1, h),
        r2 = defined_e_or(size, 2, r1)
      )
      cylinder
      (
             h = h,
            r1 = r1,
            r2 = r2,
        center = center
      );

    // cone
    else if ( type == 2 )
      cone
      (
          size = size,
            vr = vr,
        center = center
      );

    // cuboid
    else if ( type == 3 )
      cuboid
      (
          size = size,
            vr = vr,
           vrm = vrm,
        center = center
      );

    // ellipsoid
    else if ( type == 4 )
      ellipsoid
      (
          size = size,
        center = center
      );

    // ellipsoid_s
    else if ( type == 5 )
      let
      (
        s  = defined_e_or(size, 0, size),
        a1 = defined_e_or(size, 1, 0),
        a2 = defined_e_or(size, 2, 0)
      )
      ellipsoid_s
      (
          size = s,
            a1 = a1,
            a2 = a2,
        center = center
      );

    // pyramid_t
    else if ( type == 6 )
      pyramid_t
      (
          size = size,
        center = center
      );

    // pyramid_q
    else if ( type == 7 )
      pyramid_q
      (
          size = size,
        center = center
      );

    // star3d
    else if ( type == 8 )
      let
      (
        s  = defined_e_or(size, 0, size),
        n  = defined_e_or(size, 1, 5),
        h  = defined_e_or(size, 2, false)
      )
      star3d
      (
          size = s,
             n = n,
          half = h,
        center = center
      );

    //
    // custom shapes
    //
    else if ( type == 50 )
      select_common_3d_shape_50(size=size, vr=vr, vrm=vrm, fn=fn, center=center);
    else if ( type == 51 )
      select_common_3d_shape_51(size=size, vr=vr, vrm=vrm, fn=fn, center=center);
    else if ( type == 52 )
      select_common_3d_shape_52(size=size, vr=vr, vrm=vrm, fn=fn, center=center);
    else if ( type == 53 )
      select_common_3d_shape_53(size=size, vr=vr, vrm=vrm, fn=fn, center=center);
    else if ( type == 54 )
      select_common_3d_shape_54(size=size, vr=vr, vrm=vrm, fn=fn, center=center);

    //
    // database polyhedron
    //
    else if ( type > pd_db_type_offset )
    {
      assert
      (
        pd_db_available,
        "required module not loaded; please include polyhedrons db module."
      );

      id_number = type - pd_db_type_offset;
      id_name   = ph_db_get_id(id_number);

      if (verb > 1)
      {
        db_size = ph_db_get_size();

        echo(strl(["polyhedrons db_size = ", db_size, ", id_offset = ", pd_db_type_offset]));
        echo(strl(["id_number = ", id_number, ", id_name = ", id_name]));
      }

      ph_db_polyhedron
      (
            id = id_name,
          size = size,
         align = (center==true) ? [0, 0, 0] : [1, 1, 1]
      );
    }
  }

  //
  // decode parameters
  //

  size  = defined_eon_or(argv, 0, 1);       // dimensions (type dependent)
  vr    = defined_e_or  (argv, 1, undef);   // rounding
  vrm   = defined_e_or  (argv, 2, 0);       // rounding mode
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
    include <shapes/select_common_3d.scad>;

    r     = 25;
    h     = 25;

    size  = [r, h];
    a1    = 0;
    a2    = 225;

    type  = 5;
    argv  = [[size, a1, a2]];

    select_common_3d_shape(type=type, argv=argv, center=true);

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "top front diag";

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
    include <shapes/select_common_3d.scad>;

    module select_common_3d_shape_50(size, vr, vrm, fn, center)
    {
      cube(size, center=center);
    }

    size  = [50, 40, 30];
    vr    = undef;
    vrm   = undef;
    fn    = undef;

    type  = 50;
    argv  = [size, vr, vrm, fn];

    select_common_3d_shape(type=type, argv=argv, center=true);

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "top front diag";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

/*
BEGIN_SCOPE example_ph_db;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <database/geometry/polyhedra/polyhedra_all.scad>;
    include <shapes/polyhedron_db.scad>;
    include <shapes/select_common_3d.scad>;

    size  = [10, 20, 20];
    type  = 122;
    argv  = [size];

    select_common_3d_shape(type=type, argv=argv, center=true);

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "top front diag";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
