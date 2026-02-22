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

    \amu_define group_name  (Select 3d Shape)
    \amu_define group_brief (Selection and configuration for common 3D shapes.)

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

//! Select configure and construct one of the available 3d shapes.
/***************************************************************************//**
  \param    type <integer> Shape type index.

  \param    argv <decimal-list | decimal> Shape dependent argument vector.

  \param    center <boolean> Center about origin.

  \param    verb <integer> Output verbosity (0-2).

  \details

    This module provides a standard scheme for selecting and
    configuring the arguments of most 2D shapes available in the
    library, offering a consistent and flexible way to include and
    configure 2D shapes.

    ### argv

    Each shape is configured using the parameter \p argv. The four
    elements of this parameter are as follows:

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | decimal-list-n \| decimal | 1         | \p size : shape size
      1 | decimal-list-n \| decimal | undef     | \p vr (\p sr) : shape rounding
      2 | integer-list-n \| integer | 0         | \p vrm : shape rounding mode
      3 | integer           |  5                | \p fn : shape rounding facets

    ### type

    Dimensioning is shape dependent. The required dimensioning
    arguments for each supported shape are shown in the following
    table. All supported shapes and their associated arguments are
    summarized in the following table:

       t  | shapes                | size parameters | shape reference
    :----:|:---------------------:|:---------------:|:----------------------------------
        1 | cone                  |  size           | cone()
        2 | cuboid                |  size           | cuboid()
        3 | ellipsoid             |  size           | ellipsoid()
        4 | ellipsoid section     |  size, a1, a2   | ellipsoid_s()
        5 | quadratic pyramid     |  size           | pyramid_t()
        6 | triangular pyramid    |  size           | pyramid_q()
        7 | star 3d               |  size, n, half  | star3d()
     100+ | Polyhedrons database  |  size           | (see below)

    \amu_define scope_id      (example)
    \amu_define title         (Selection example)
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
    \amu_define title         (Selection example)
    \amu_define image_views   (top front diag)
    \amu_define image_size    (sxga)

    \amu_include (include/amu/scope_diagrams_3d.amu)
*******************************************************************************/
module select_common_3d_shape
(
  type = 0,
  argv,
  center = false,
  verb = 0
)
{
  // polyhedron database available when modules global data table is defined
  pd_db_available   = !( is_undef(ph_db_dtc) || is_undef(ph_db_dtr) );

  // polyhedron database type offset
  pd_db_type_offset = 99;

  //
  // common parameters
  //

  size  = defined_eon_or(argv, 0, 1);       // dimensions (type dependent)
  vr    = defined_e_or  (argv, 1, undef);   // rounding
  vrm   = defined_e_or  (argv, 2, 0);       // rounding mode
  fn    = defined_e_or  (argv, 3, 5);       // facets

  if (verb > 0)
  {
    log_info(strl(["type=", type, ", argv=", argv, ", center=", center]));

    if (verb > 1)
      echo(size=size, vr=vr, vrm=vrm, fn=fn);
  }

  //
  // shape construction
  //

  // cone
      if ( type == 1 )
    cone
    (
        size = size,
          vr = vr,
      center = center
    );

  // cuboid
  else if ( type == 2 )
    cuboid
    (
        size = size,
          vr = vr,
         vrm = vrm,
      center = center
    );

  // ellipsoid
  else if ( type == 3 )
    ellipsoid
    (
        size = size,
      center = center
    );

  // ellipsoid_s
  else if ( type == 4 )
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
  else if ( type == 5 )
    pyramid_t
    (
        size = size,
      center = center
    );

  // pyramid_q
  else if ( type == 6 )
    pyramid_q
    (
        size = size,
      center = center
    );

  // star3d
  else if ( type == 7 )
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

  // database polyhedron
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

    type  = 4;
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
