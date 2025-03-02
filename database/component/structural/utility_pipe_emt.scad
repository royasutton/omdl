//! [utility_pipe] Electrical metalic conduit; emt; thin wall.
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

    \amu_define group_name  (emt)
    \amu_define group_brief ([utility_pipe] Electrical metalic conduit; emt; thin wall.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
  \amu_text parent (${parent}_Utility_Pipe)
*******************************************************************************/

//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_include (include/amu/includes_required.amu)

  \details

    \amu_copy (files="diagrams/pipe_oi.svg" types="html,latex")
    \amu_text
    (
    \image html ${PATH_NAME}/diagrams/pipe_oi.svg "parameters"
    \image latex ${PATH_NAME}/diagrams/pipe_oi.svg "parameters"
    )

    \amu_define output_scad     (false)
    \amu_define output_console  (false)

    \amu_define title           (Electrical metalic conduit)
    \amu_define notes_table     ()

    \amu_include (include/amu/scope_table.amu)

    \note The measurements in the table above are shown with:
          \c length_unit_base="in". These measurements will
          convert when the base units are changed. See \ref units_length
          for more information on setting the base units.

    | References:  |
    |:-------------|
    | emt          |
    | thin wall    |

*******************************************************************************/

//! <map> emt data table columns map.
//! \hideinitializer
dtc_structural_utility_pipe_emt =
[
  ["ns", "nominal size"],
  ["ns_mm", "nominal size"],
  ["od_in", "outside diameter"],
  ["od_mm", "outside diameter"],
  ["id_in", "internal diameter"],
  ["id_mm", "internal diameter"]
];

//! \<table> emt data table rows.
//! \hideinitializer
dtr_structural_utility_pipe_emt =
[
  [  "3/8", "10",l_in(0.577),l_mm( 14.7),l_in(0.493),l_mm( 12.5)],
  [  "1/2", "16",l_in(0.706),l_mm( 17.9),l_in(0.622),l_mm( 15.8)],
  [  "3/4", "21",l_in(0.992),l_mm( 23.4),l_in(0.824),l_mm( 20.9)],
  [    "1", "27",l_in(1.163),l_mm( 29.5),l_in(1.049),l_mm( 26.6)],
  ["1-1/4", "35",l_in(1.510),l_mm( 38.4),l_in(1.380),l_mm( 35.1)],
  ["1-1/2", "41",l_in(1.740),l_mm( 44.2),l_in(1.610),l_mm( 40.9)],
  [    "2", "53",l_in(2.197),l_mm( 55.8),l_in(2.067),l_mm( 52.5)],
  ["2-1/2", "63",l_in(2.875),l_mm( 73.0),l_in(2.731),l_mm( 69.4)],
  [    "3", "78",l_in(3.500),l_mm( 88.9),l_in(3.356),l_mm( 85.2)],
  ["3-1/2", "91",l_in(4.000),l_mm(101.6),l_in(3.834),l_mm( 97.4)],
  [    "4","103",l_in(4.500),l_mm(114.3),l_in(4.334),l_mm(110.1)]
];

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE table;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <database/component/structural/utility_pipe_emt.scad>;

    // temporary override for table presentation.
    // function l_mm(v) = round_s(length(v,"mm"), 4);

    length_unit_base = "in";

    n  = true;                // number
    hi = true;                // include heading id
    ht = true;                // include heading description

    tr = dtr_structural_utility_pipe_emt;
    tc = dtc_structural_utility_pipe_emt;

    table_write( tr, tc, number=n, heading_id=hi, heading_text=ht );

    // end_include
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
