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

  \amu_scope scope (index=1)
  \amu_file th (file="${scope}.log" first=1 last=1 ++rmecho ++rmnl ++read)
  \amu_file td (file="${scope}.log" first=2        ++rmecho ++rmnl ++read)
  \amu_word tc (tokenizer="^" words="${th}" ++count)

  \details

    <b>Battery sizes table</b>:
    \amu_table (columns=${tc} column_headings=${th} cell_texts=${td})

    See Wikipedia battery [sizes] for information.

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

//! <table> Cylindrical batteries data table (all values in millimeters).
//! \hideinitializer
dtr_battery_cylindrical =
[
  ["aaaa", 8.3, 42.5],
  ["aaa", 10.5, 44.5],
  ["aa", 14.5, 50.5],
  ["h-aa", 14.5, 25.0],
  ["a", 17, 50],
  ["b", 21.5, 60],
  ["c", 26.2, 50],
  ["s-c", 22.2, 42.9],
  ["d", 34.2, 61.5],
  ["f", 33, 91],
  ["n", 12, 30.2],
  ["a21", 10.3, 16],
  ["a23", 10.5, 28.5],
  ["a27", 8, 28.2],
  ["ba5800", 35.5, 128.5],
  ["duplex", 21.8, 74.6],
  ["4sr44", 13, 25.2],

  // lithium-ion
  ["10180", 10, 18],
  ["10280", 10, 28],
  ["10440", 10, 44],
  ["14650", 14, 65],
  ["16650", 16, 65],
  ["18650", 18, 65],
  ["21700", 21, 70],
  ["26500", 26, 50],
  ["32600", 32, 60]
];

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE db;
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
    include --path "${INCLUDE_PATH}" scr_std_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
