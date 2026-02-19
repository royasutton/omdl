//! A standard selection and configuration scheme for 2D shape construction.
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

    \amu_define group_name  (Shape 2d Select)
    \amu_define group_brief (Selection and configuration for 2D shape construction.)

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

//! Select configure and construct one of the available 2d shapes.
/***************************************************************************//**
  \param    type <integer> Shape type.

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
      0 | decimal-list-n \| decimal | 1         | \p d : shape dimensions
      1 | decimal-list-n \| decimal | undef     | \p vr (\p sr) : shape rounding
      2 | integer-list-n \| integer | 1         | \p vrm : shape rounding mode
      3 | integer           |  3                | \p fn : shape rounding facets

    ### type

    Dimensioning is shape dependent. The required dimensioning
    arguments for each supported shape are shown in the following
    table. All supported shapes and their associated arguments are
    summarized in the following table:

      t | shapes            | (d) dimensions    | shape reference
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | circle            |  r                | [circle()]
      1 | ngon              |  r, n             | pg_ngon()
      2 | rectangle         |  size             | pg_rectangle()
      3 | rectangle sr      |  size             | pg_rectangle_rs()
      4 | rhombus           |  size             | pg_rhombus()
      5 | elliptical sector |  r, v1, v2        | pg_elliptical_sector()
      6 | triangle vertices |  v1, v2, v3       | pg_triangle_ppp()
      7 | triangle sides    |  s1, s2, s3       | pg_triangle_sss()
      8 | star              |  size, n          | star2d()
      9 | corner round      |  r, m, v1, v2     | pg_corner_round()

    \amu_define scope_id      (example)
    \amu_define title         (Selection example)
    \amu_define image_views   (top)
    \amu_define image_size    (sxga)

    \amu_include (include/amu/scope_diagrams_3d.amu)

  [circle()]: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Using_the_2D_Subsystem#circle
*******************************************************************************/
module shape2d_select
(
  type = 0,
  argv,
  center = false,
  verb = 0
)
{
  //
  // common parameters
  //

  d   = defined_eon_or(argv, 0, 1);       // dimensions (type dependent)
  vr  = defined_e_or  (argv, 1, undef);   // rounding
  vrm = defined_e_or  (argv, 2, 1);       // rounding mode
  fn  = defined_e_or  (argv, 3, 3);       // facets

  if (verb > 0)
  {
    log_info(strl(["type=", type, ", argv=", argv, ", center=", center]));

    if (verb > 1)
      echo(d=d, vr=vr, vrm=vrm, fn=fn);
  }

  //
  // shape construction
  //

  // circle
  if      ( type == 0 )
    circle
    (
           r = d
    );

  // ngon
  else if ( type == 1 )
    pg_ngon
    (
           r = defined_e_or(d, 0, d),
           n = defined_e_or(d, 1, 3),
          vr = vr,
         vrm = vrm,
         vfn = fn,
      center = center
    );

  // rectangle
  else if ( type == 2 )
    pg_rectangle
    (
        size = d,
          vr = vr,
         vrm = vrm,
         vfn = fn,
      center = center
    );

  // rectangle_rs
  else if ( type == 3 )
    pg_rectangle_rs
    (
        size = d,
          sr = vr,
      center = center
    );

  // rhombus
  else if ( type == 4 )
    pg_rhombus
    (
        size = d,
          vr = vr,
         vrm = vrm,
         vfn = fn,
      center = center
    );

  // elliptical sector
  else if ( type == 5 )
    pg_elliptical_sector
    (
           r = defined_e_or(d, 0, d),
          v1 = defined_e_or(d, 1, x_axis2d_uv),
          v2 = defined_e_or(d, 2, x_axis2d_uv)
    );

  // triangle_ppp
  else if ( type == 6 )
    let
    (
      v1 = defined_e_or(d, 0, d * origin2d),
      v2 = defined_e_or(d, 1, d * y_axis2d_uv),
      v3 = defined_e_or(d, 2, d * x_axis2d_uv)
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
  else if ( type == 7 )
    let
    (
      s1 = defined_e_or(d, 0, d),
      s2 = defined_e_or(d, 1, s1),
      s3 = defined_e_or(d, 2, s2)
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
  else if ( type == 8 )
    star2d
    (
        size = defined_e_or(d, 0, d),
           n = defined_e_or(d, 1, 5),
          vr = vr
    );

  // corner_round
  else if ( type == 9 )
    pg_corner_round
    (
           r = defined_e_or(d, 0, d),
           m = defined_e_or(d, 1, 1),
          v1 = defined_e_or(d, 2, x_axis2d_uv),
          v2 = defined_e_or(d, 3, y_axis2d_uv)
    );
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
    include <shapes/shape2d_select.scad>;

    s1 = 50;
    s2 = 40;
    s3 = 30;

    d   = [s1, s2, s3];
    vr  = [1, 5, 5];
    vrm = [1, 1, 5];
    fn  = 9;

    type = 7;
    argv = [d, vr, vrm, fn];

    shape2d_select(type=type, argv=argv, center=true);

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
