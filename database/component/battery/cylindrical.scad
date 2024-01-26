//! Cylindrical batteries data table
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

    \amu_define group_name  (Cylindrical)
    \amu_define group_brief (Cylindrical batteries data table.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_include (include/amu/includes_required.amu)

  \details

    \amu_define title           (Cylindrical batteries)
    \amu_define image_views     (top right diag)
    \amu_define image_size      (sxga)
    \amu_define notes_diagrams  (See Wikipedia battery [sizes] for information.)
    \amu_define notes_table     (Measurements in millimeters.)

    \amu_include (include/amu/scope_diagrams_3d_table.amu)

  [sizes]: https://en.wikipedia.org/wiki/List_of_battery_sizes
*******************************************************************************/

//----------------------------------------------------------------------------//

//! <map> Cylindrical batteries data table columns map.
//! \hideinitializer
dtc_battery_cylindrical =
[
  ["id", "battery identifier"],
  ["d", "battery diameter"],
  ["h", "battery height"]
];

//! \<table> Cylindrical batteries data table rows.
//! \hideinitializer
dtr_battery_cylindrical =
[
  ["aaaa",    l_mm( 8.3), l_mm( 42.5)],
  ["aaa",     l_mm(10.5), l_mm( 44.5)],
  ["aa",      l_mm(14.5), l_mm( 50.5)],
  ["h-aa",    l_mm(14.5), l_mm( 25.0)],
  ["a",       l_mm(17  ), l_mm( 50  )],
  ["b",       l_mm(21.5), l_mm( 60  )],
  ["c",       l_mm(26.2), l_mm( 50  )],
  ["s-c",     l_mm(22.2), l_mm( 42.9)],
  ["d",       l_mm(34.2), l_mm( 61.5)],
  ["f",       l_mm(33  ), l_mm( 91  )],
  ["n",       l_mm(12  ), l_mm( 30.2)],
  ["a21",     l_mm(10.3), l_mm( 16  )],
  ["a23",     l_mm(10.5), l_mm( 28.5)],
  ["a27",     l_mm( 8  ), l_mm( 28.2)],
  ["ba5800",  l_mm(35.5), l_mm(128.5)],
  ["duplex",  l_mm(21.8), l_mm( 74.6)],
  ["4sr44",   l_mm(13  ), l_mm( 25.2)],

  // lithium-ion
  ["10180",   l_mm(10  ), l_mm( 18  )],
  ["10280",   l_mm(10  ), l_mm( 28  )],
  ["10440",   l_mm(10  ), l_mm( 44  )],
  ["14650",   l_mm(14  ), l_mm( 65  )],
  ["16650",   l_mm(16  ), l_mm( 65  )],
  ["18650",   l_mm(18  ), l_mm( 65  )],
  ["21700",   l_mm(21  ), l_mm( 70  )],
  ["26500",   l_mm(26  ), l_mm( 50  )],
  ["32600",   l_mm(32  ), l_mm( 60  )]
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

    d =  50; dt = d*3/10;
    h = 100; ht = h*1/20;

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
    include <database/component/battery/cylindrical.scad>;

    tr = dtr_battery_cylindrical;
    tc = dtc_battery_cylindrical;

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
