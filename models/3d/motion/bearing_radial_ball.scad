//! Rotary motion radial ball bearing model.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2024

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

    \amu_define group_name  (Radial Ball)
    \amu_define group_brief (Rotary motion radial ball bearing model.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group and macros.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_define includes_required_add
  (
    database/component/motion/bearing_radial_ball.scad
  )
  \amu_include (include/amu/includes_required.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//! Radial ball bearing model.
/***************************************************************************//**
  \param  n     <string> the bearing model name (see: [database table]).
  \param  a     <integer> model z-alignment; {0:bottom, 1:middle, 2:top}.
  \param  s     <boolean> render shell only.
  \param  c     <boolean> render with color.

  \details

    The available model names can be found in the [database table].

    \amu_define title         (Bearing example)
    \amu_define image_views   (top right diag)
    \amu_define image_size    (sxga)

    \amu_include (include/amu/scope_diagrams_3d.amu)

   [database table]: \ref database_component_motion_bearing_radial_ball
*******************************************************************************/
module radial_ball
(
  n,
  a = 1,
  s = false,
  c = true
)
{
  t = [dtr_motion_bearing_radial_ball, dtc_motion_bearing_radial_ball];

  assert
  (
    ctable_exists(t, n),
    str("model '", n, "' is undefined in table.")
  );

  id = ctable_get(t, n, "id");
  od = ctable_get(t, n, "od");
  b  = ctable_get(t, n, "b");

  // feature decorations
  idr = id * 1.30;  // bore rim
  odr = od * 0.92;  // outer rim
  odc = od * 0.85;  // outer clip rim
  ifw =  b * 0.95;  // bearing cover width
  ifc =  b * 0.88;  // bearing cover clip width 1
  ifd =  b * 0.80;  // bearing cover clip width 2

  translate( select_ci( [ [0,0,+b/2], origin3d, [0,0,-b/2]], a, false ) )
  if (s == true)
  {
    color("silver")
    cylinder(d=od, h=b, center=true);
  }
  else
  {
    difference()
    {
      union()
      {
        color(c?"silver":undef)                             // outer diameter
        difference()
        {
          cylinder(d=od, h=b, center=true);
          cylinder(d=odr, h=b+eps*2, center=true);
        }

        color(c?"gray":undef)                               // clip rim
        cylinder(d=odr, h=ifd, center=true);

        color(c?"dimgray":undef)                            // cover
        cylinder(d=odc, h=ifw, center=true);

        color(c?"silver":undef)                             // bore rim
        cylinder(d=idr, h=b, center=true);

        color(c?"darkgray":undef)                           // cover clips
        difference ()
        {
          cylinder(d=odr, h=ifc, center=true);
          cylinder(d=odc, h=ifc+eps*4, center=true);
          for (i = [0:6])
          rotate([0, 0, 30*i])
          cube([odr, (od-odr)/3, ifc+eps*4], center=true);
        }
      }

      cylinder(d=id, h=b+eps*2, center=true);               // inner bore
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
    include <database/component/motion/bearing_radial_ball.scad>;
    include <models/3d/motion/bearing_radial_ball.scad>;

    radial_ball("608");

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "top right diag";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
