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

    \amu_define title           (Button cell batteries)
    \amu_define image_views     (top right diag)
    \amu_define image_size      (sxga)
    \amu_define notes_diagrams  (See Wikipedia battery [sizes] for information.)
    \amu_define notes_table     (Identifier names are based on [IEC] standards.
                                 Measurements in millimeters.)

    \amu_include (include/amu/scope_diagrams_3d_table.amu)

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

//! \<table> Button cell batteries data table rows.
//! \hideinitializer
dtr_battery_button =
[
  ["CR927",   l_mm( 9.5), l_mm( 2.7)],
  ["CR1025",  l_mm(10  ), l_mm( 2.5)],
  ["CR1130",  l_mm(11.5), l_mm( 3.0)],
  ["CR1216",  l_mm(12.5), l_mm( 1.6)],
  ["CR1220",  l_mm(12.5), l_mm( 2.0)],
  ["CR1225",  l_mm(12.5), l_mm( 2.5)],
  ["CR1616",  l_mm(16  ), l_mm( 1.6)],
  ["CR1620",  l_mm(16  ), l_mm( 2.0)],
  ["CR1632",  l_mm(16  ), l_mm( 3.2)],
  ["CR2012",  l_mm(20  ), l_mm( 1.2)],
  ["CR2016",  l_mm(20  ), l_mm( 1.6)],
  ["CR2020",  l_mm(20  ), l_mm( 2  )],
  ["CR2025",  l_mm(20  ), l_mm( 2.5)],
  ["CR2032",  l_mm(20  ), l_mm( 3.2)],
  ["CR2040",  l_mm(20  ), l_mm( 4.0)],
  ["CR2050",  l_mm(20  ), l_mm( 5.0)],
  ["CR2320",  l_mm(23  ), l_mm( 2  )],
  ["CR2325",  l_mm(23  ), l_mm( 2.5)],
  ["CR2330",  l_mm(23  ), l_mm( 3.0)],
  ["BR2335",  l_mm(23  ), l_mm( 3.5)],
  ["CR2354",  l_mm(23  ), l_mm( 5.4)],
  ["CR2412",  l_mm(24.5), l_mm( 1.2)],
  ["CR2430",  l_mm(24.5), l_mm( 3.0)],
  ["CR2450",  l_mm(24.5), l_mm( 5.0)],
  ["CR2477",  l_mm(24.5), l_mm( 7.7)],
  ["CR3032",  l_mm(30.0), l_mm( 3.2)],
  ["CR11108", l_mm(11.6), l_mm(10.8)]
];

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE diagram;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
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

    if ( !is_undef(__mfs__top) )
      color("black")
      draft_dim_line(p1=[-d/2,0], p2=[+d/2,0], d=d*6/10, e=d*4/10, es=2, t="d");

    if ( !is_undef(__mfs__right) )
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

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
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
    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
