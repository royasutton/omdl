//! Button cell batteries data table
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2023

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

    \amu_define group_name  (Button cell)
    \amu_define group_brief (Button cell batteries data table.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_include (include/amu/includes_required.amu)

  \details

    \amu_define data_name     (Button cell batteries)
    \amu_define image_views   (top right diag)
    \amu_define image_size    (sxga)
    \amu_define diagram_notes (See Wikipedia battery [sizes] for information.)
    \amu_define data_notes    (Identifier names are based on [IEC] standards.)

    \amu_include (include/amu/table_diagram_data_db.amu)

  [sizes]: https://en.wikipedia.org/wiki/List_of_battery_sizes
  [IEC]: https://en.wikipedia.org/wiki/International_Electrotechnical_Commission
*******************************************************************************/

//----------------------------------------------------------------------------//

//! <map> Button cell batteries data table columns map.
//! \hideinitializer
dtc_battery_button =
[
  ["id", "battery identifier"],
  ["d", "battery diameter"],
  ["h", "battery height"]
];

//! \<table> Button cell batteries data table (all values in millimeters).
//! \hideinitializer
dtr_battery_button =
[
  ["CR927", 9.5, 2.7],
  ["CR1025", 10, 2.5],
  ["CR1130", 11.5, 3.0],
  ["CR1216", 12.5, 1.6],
  ["CR1220", 12.5, 2.0],
  ["CR1225", 12.5, 2.5],
  ["CR1616", 16, 1.6],
  ["CR1620", 16, 2.0],
  ["CR1632", 16, 3.2],
  ["CR2012", 20, 1.2],
  ["CR2016", 20, 1.6],
  ["CR2020", 20, 2],
  ["CR2025", 20, 2.5],
  ["CR2032", 20, 3.2],
  ["CR2040", 20, 4.0],
  ["CR2050", 20, 5.0],
  ["CR2320", 23, 2],
  ["CR2325", 23, 2.5],
  ["CR2330", 23, 3.0],
  ["BR2335", 23, 3.5],
  ["CR2354", 23, 5.4],
  ["CR2412", 24.5, 1.2],
  ["CR2430", 24.5, 3.0],
  ["CR2450", 24.5, 5.0],
  ["CR2477", 24.5, 7.7],
  ["CR3032", 30.0, 3.2],
  ["CR11108", 11.6, 10.8]
];

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE db;
BEGIN_SCOPE diagram;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;

    include <units/length.scad>;
    include <units/angle.scad>;
    include <tools/align.scad>;
    include <tools/operation_cs.scad>;
    include <tools/drafting/draft-base.scad>;

    include <database/component/battery/cylindrical.scad>;

    $fn=36;

    d = 50; dt = d*9/10;
    h = 15; ht = h*1/10;

    cylinder(d=d, h=h-ht);
    color("lightgray")
    translate([0,0,h-ht])
    cylinder(d=dt, h=ht);

    __mfs__top = false;
    __mfs__right = false;

    if ( __mfs__top )
      color("black")
      draft_dim_line(p1=[-d/2,0], p2=[+d/2,0], d=d*6/10, e=d*4/10, es=2, t="d");

    if ( __mfs__right )
      color("black")
      translate([0, d/2, h/2]) rotate([0,90])
      draft_dim_line(p1=[-h/2,0], p2=[+h/2,0], d=d*3/10, e=h*4/10, es=2, t="h");
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "top right diag";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter";

    include --path "${INCLUDE_PATH}" scr_std_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;

BEGIN_SCOPE table;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <database/component/battery/button.scad>;

    tr = dtr_battery_button;
    tc = dtc_battery_button;

    n  = true;
    hi = true;
    ht = true;

    table_write( tr, tc, number=n, heading_id=hi, heading_text=ht );
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_term}.mfs;
    include --path "${INCLUDE_PATH}" scr_std_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
