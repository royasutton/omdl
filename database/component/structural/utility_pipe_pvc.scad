//! [utility_pipe] Polyvinyl chloride pipe; pvc; sch40 sch80 sch120.
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

    \amu_define group_name  (pvc)
    \amu_define group_brief ([utility_pipe] Polyvinyl chloride pipe; pvc; sch40 sch80 sch120.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
  \amu_text parent (${parent}_Utility_Pipe)
*******************************************************************************/

//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_include (include/amu/includes_required.amu)

  \details

    \amu_copy (files="diagrams/pipe_ot.svg" types="html,latex")
    \amu_text
    (
    \image html ${PATH_NAME}/diagrams/pipe_ot.svg "parameters"
    \image latex ${PATH_NAME}/diagrams/pipe_ot.svg "parameters"
    )

    \amu_define output_scad     (false)
    \amu_define output_console  (false)

    \amu_define title           (Polyvinyl chloride pipe)
    \amu_define notes_table     ()

    \amu_include (include/amu/scope_table.amu)

    \note The measurements in the table above are shown with:
          \c length_unit_base="in". These measurements will
          convert when the base units are changed. See \ref units_length
          for more information on setting the base units.

    | References:         |
    |:--------------------|
    | pvc                 |
    | sch40 sch80 sch120  |

*******************************************************************************/

//! <map> pvc data table columns map.
//! \hideinitializer
dtc_structural_utility_pipe_pvc =
[
  ["ns", "nominal size"],
  ["ns_mm", "nominal size"],
  ["od_in", "outside diameter"],
  ["od_mm", "outside diameter"],
  ["t_40", "wall thickness in"],
  ["t_80", "wall thickness in"],
  ["t_120", "wall thickness in"]
];

//! \<table> pvc data table rows.
//! \hideinitializer
dtr_structural_utility_pipe_pvc =
[
  [  "1/8",  "3",l_in( 0.41),l_mm( 10.29),l_in(0.068),l_in(0.095),      undef],
  [  "1/4",  "6",l_in( 0.54),l_mm( 13.72),l_in(0.088),l_in(0.119),      undef],
  [  "3/8", "10",l_in( 0.68),l_mm( 17.15),l_in(0.091),l_in(0.126),      undef],
  [  "1/2", "15",l_in( 0.84),l_mm( 21.34),l_in(0.109),l_in(0.147),l_in(0.170)],
  [  "3/4", "20",l_in( 1.05),l_mm( 26.67),l_in(0.113),l_in(0.154),l_in(0.170)],
  [    "1", "25",l_in( 1.32),l_mm( 33.40),l_in(0.113),l_in(0.179),l_in(0.200)],
  ["1-1/4", "32",l_in( 1.66),l_mm( 42.20),l_in(0.140),l_in(0.191),l_in(0.215)],
  ["1-1/2", "40",l_in( 1.90),l_mm( 48.30),l_in(0.145),l_in(0.200),l_in(0.225)],
  [    "2", "50",l_in( 2.38),l_mm( 60.30),l_in(0.154),l_in(0.218),l_in(0.250)],
  ["2-1/2", "65",l_in( 2.88),l_mm( 73.00),l_in(0.203),l_in(0.276),l_in(0.300)],
  [    "3", "80",l_in( 3.50),l_mm( 89.00),l_in(0.216),l_in(0.300),l_in(0.350)],
  ["3-1/2", "90",l_in( 4.00),l_mm(102.00),l_in(0.226),l_in(0.318),      undef],
  [    "4","100",l_in( 4.50),l_mm(114.00),l_in(0.237),l_in(0.337),l_in(0.437)],
  [    "5","125",l_in( 5.56),l_mm(141.00),l_in(0.258),l_in(0.375),      undef],
  [    "6","150",l_in( 6.63),l_mm(168.00),l_in(0.280),l_in(0.432),l_in(0.562)],
  [    "8","200",l_in( 8.63),l_mm(219.00),l_in(0.322),l_in(0.500),      undef],
  [   "10","250",l_in(10.75),l_mm(273.00),l_in(0.365),l_in(0.593),      undef],
  [   "12","300",l_in(12.75),l_mm(324.00),l_in(0.406),l_in(0.687),      undef],
  [   "14","350",l_in(14.00),l_mm(355.60),l_in(0.437),l_in(0.750),      undef],
  [   "16","400",l_in(16.00),l_mm(406.40),l_in(0.500),l_in(0.843),      undef],
  [   "18","450",l_in(18.00),l_mm(457.20),l_in(0.562),l_in(0.937),      undef],
  [   "20","500",l_in(20.00),l_mm(508.00),l_in(0.593),l_in(1.031),      undef],
  [   "24","600",l_in(24.00),l_mm(610.00),l_in(0.687),l_in(1.218),      undef]
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
    include <database/component/structural/utility_pipe_pvc.scad>;

    // temporary override for table presentation.
    // function l_mm(v) = round_s(length(v,"mm"), 4);

    length_unit_base = "in";

    n  = true;                // number
    hi = true;                // include heading id
    ht = true;                // include heading description

    tr = dtr_structural_utility_pipe_pvc;
    tc = dtc_structural_utility_pipe_pvc;

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
