//! [utility_pipe] Rigid steel conduit; rsc; heavy wall.
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

    \amu_define group_name  (rsc)
    \amu_define group_brief ([utility_pipe] Rigid steel conduit; rsc; heavy wall.)

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

    \amu_define title           (Rigid steel conduit)
    \amu_define notes_table     ()

    \amu_include (include/amu/scope_table.amu)

    \note The measurements in the table above are shown with:
          \c length_unit_base="in". These measurements will
          convert when the base units are changed. See \ref units_length
          for more information on setting the base units.

    | References:  |
    |:-------------|
    | rsc          |
    | heavy wall   |

*******************************************************************************/

//! <map> rsc data table columns map.
//! \hideinitializer
dtc_structural_utility_pipe_rsc =
[
  ["ns", "nominal size"],
  ["ns_mm", "nominal size"],
  ["od_in", "outside diameter"],
  ["od_mm", "outside diameter"],
  ["id_in", "internal diameter"],
  ["id_mm", "internal diameter"]
];

//! \<table> rsc data table rows.
//! \hideinitializer
dtr_structural_utility_pipe_rsc =
[
  [  "3/8", "10",l_in(0.675),l_mm( 17.1),l_in(0.493),l_mm( 12.5)],
  [  "1/2", "15",l_in(0.840),l_mm( 21.3),l_in(0.632),l_mm( 16.0)],
  [  "3/4", "20",l_in(1.050),l_mm( 26.7),l_in(0.836),l_mm( 21.3)],
  [    "1", "25",l_in(1.315),l_mm( 33.4),l_in(1.063),l_mm( 27.0)],
  ["1-1/4", "32",l_in(1.660),l_mm( 42.2),l_in(1.394),l_mm( 35.4)],
  ["1-1/2", "40",l_in(1.900),l_mm( 48.3),l_in(1.624),l_mm( 41.3)],
  [    "2", "50",l_in(2.375),l_mm( 60.3),l_in(2.083),l_mm( 52.9)],
  ["2-1/2", "60",l_in(2.875),l_mm( 73.0),l_in(2.489),l_mm( 63.2)],
  [    "3", "80",l_in(3.500),l_mm( 88.9),l_in(3.090),l_mm( 78.5)],
  ["3-1/2", "90",l_in(4.000),l_mm(101.6),l_in(3.570),l_mm( 90.7)],
  [    "4","100",l_in(1.500),l_mm(114.3),l_in(4.050),l_mm(102.9)],
  [    "5","125",l_in(5.563),l_mm(141.3),l_in(5.073),l_mm(128.9)],
  [    "6","150",l_in(6.625),l_mm(168.3),l_in(6.093),l_mm(154.8)]
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
    include <database/component/structural/utility_pipe_rsc.scad>;

    // temporary override for table presentation.
    // function l_mm(v) = round_s(length(v,"mm"), 4);

    length_unit_base = "in";

    n  = true;                // number
    hi = true;                // include heading id
    ht = true;                // include heading description

    tr = dtr_structural_utility_pipe_rsc;
    tc = dtc_structural_utility_pipe_rsc;

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
