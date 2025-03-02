//! Linear motion bearing model.
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

    \amu_define group_name  (Linear lmxuu)
    \amu_define group_brief (Linear motion bearing model.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group and macros.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_define includes_required_add
  (
    database/component/motion/bearing_linear_lmxuu.scad
  )
  \amu_include (include/amu/includes_required.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//! Linear motion bearing model.
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

   [database table]: \ref database_component_motion_bearing_linear_lmxuu
*******************************************************************************/
module linear_lmxuu
(
  n,
  a = 1,
  s = false,
  c = true
)
{
  t = [dtr_motion_bearing_linear_lmxuu, dtc_motion_bearing_linear_lmxuu];

  assert
  (
    ctable_exists(t, n),
    str("model '", n, "' is undefined in table.")
  );

  dr =  ctable_get(t, n, "dr");
  d  =  ctable_get(t, n, "d");
  l  =  ctable_get(t, n, "l");
  b  =  ctable_get(t, n, "b");
  w  =  ctable_get(t, n, "w");
  d1 =  ctable_get(t, n, "d1");

  dp = 94/100 * d;  // diameter of interior sleeve
  lp = 96/100 * l;  // length of interior sleeve


  translate( select_ci( [ [0,0,+l/2], origin3d, [0,0,-l/2]], a, false ) )
  if (s == true)
  {
    color("silver")
    cylinder(d=d, h=l, center=true);
  }
  else
  {
    color(c?"silver":undef)
    difference()
    {
      cylinder(d=d, h=l, center=true);                      // bearing shell
      cylinder(d=dp, h=l+eps*4, center=true);

      for (i = [-1, +1] )                                   // mounting bands
      translate([0, 0, b/2 * i])
      difference()
      {
        cylinder(d=d+eps, h=w, center=true);
        cylinder(d=d1, h=w, center=true);
      }
    }

    color(c?"black":undef)                                  // body
    difference()
    {
      cylinder(d=dp, h=lp, center=true);
      cylinder(d=dr, h=lp+eps*4, center=true);
    }

    color(c?"darkgray":undef)                               // sleeve
    difference()
    {
      cylinder(d=(dr+d-dp), h=l-eps*4, center=true);
      cylinder(d=dr, h=l, center=true);
    }

    color(c?"dimgray":undef)                                // band color
    for (i = [-1, +1] )
    translate([0, 0, b/2 * i])
    difference()
    {
      cylinder(d=d1+eps, h=w, center=true);
      cylinder(d=d1, h=w+eps*4, center=true);
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
    include <database/component/motion/bearing_linear_lmxuu.scad>;
    include <models/3d/motion/bearing_linear_lmxuu.scad>;

    linear_lmxuu("lm8uu");

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
