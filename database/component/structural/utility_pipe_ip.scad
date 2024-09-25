//! [utility_pipe] Iron pipe; ip; steel.
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

    \amu_define group_name  (ip)
    \amu_define group_brief ([utility_pipe] Iron pipe; ip; steel.)

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

    \amu_define title           (Iron pipe)
    \amu_define notes_table     ()

    \amu_include (include/amu/scope_table.amu)

    \note The measurements in the table above are shown with:
          \c length_unit_base="in". These measurements will
          convert when the base units are changed. See \ref units_length
          for more information on setting the base units.

    | References:  |
    |:-------------|
    | ip           |
    | steel        |

*******************************************************************************/

//! <map> ip structural data table columns map.
//! \hideinitializer
dtc_structural_utility_pipe_ip =
[
  ["ns", "nominal size"],
  ["ns_mm", "nominal size"],
  ["od_in", "outside diameter"],
  ["od_mm", "outside diameter"],
  ["t_40", "wall thickness schedule 40"],
  ["t_80", "wall thickness schedule 40"],
  ["t_160", "wall thickness schedule 40"],
  ["t_xx", "wall thickness schedule 40"]
];

//! \<table> ip structural data table rows.
//! \hideinitializer
dtr_structural_utility_pipe_ip =
[
  [  "1/2", "15",l_in( 0.840),l_mm( 21.0),l_in(0.109),l_in(0.147),l_in(0.187),l_in(0.294)],
  [  "3/4", "20",l_in( 1.050),l_mm( 27.0),l_in(0.113),l_in(0.154),l_in(0.218),l_in(0.308)],
  [    "1", "25",l_in( 1.315),l_mm( 33.0),l_in(0.133),l_in(0.179),l_in(0.250),l_in(0.358)],
  ["1-1/4", "32",l_in( 1.660),l_mm( 42.0),l_in(0.140),l_in(0.191),l_in(0.250),l_in(0.382)],
  ["1-1/2", "40",l_in( 1.900),l_mm( 48.3),l_in(0.145),l_in(0.200),l_in(0.281),l_in(0.400)],
  [    "2", "50",l_in( 2.375),l_mm( 60.3),l_in(0.154),l_in(0.218),l_in(0.343),l_in(0.436)],
  ["2-1/2", "65",l_in( 2.875),l_mm( 73.0),l_in(0.203),l_in(0.276),l_in(0.375),l_in(0.552)],
  [    "3", "80",l_in( 3.500),l_mm( 89.0),l_in(0.216),l_in(0.300),l_in(0.438),l_in(0.600)],
  ["3-1/2", "90",l_in( 4.000),l_mm(102.0),l_in(0.216),l_in(0.300),      undef,      undef],
  [    "4","100",l_in( 4.500),l_mm(114.0),l_in(0.237),l_in(0.337),l_in(0.531),l_in(0.674)],
  [    "5","125",l_in( 5.563),l_mm(141.0),l_in(0.258),l_in(0.375),l_in(0.625),l_in(0.750)],
  [    "6","150",l_in( 6.625),l_mm(168.0),l_in(0.280),l_in(0.432),l_in(0.718),l_in(0.864)],
  [    "8","200",l_in( 8.625),l_mm(219.0),l_in(0.322),l_in(0.500),l_in(0.875),l_in(0.906)],
  [   "10","250",l_in(10.750),l_mm(273.0),l_in(0.365),l_in(0.593),l_in(1.125),      undef],
  [   "12","300",l_in(12.750),l_mm(324.0),l_in(0.406),l_in(0.687),l_in(1.312),      undef],
  [   "14","350",l_in(14.000),l_mm(356.0),l_in(0.438),l_in(0.750),l_in(1.406),      undef],
  [   "16","400",l_in(16.000),l_mm(406.0),l_in(0.500),l_in(0.843),l_in(1.596),      undef],
  [   "18","450",l_in(18.000),l_mm(457.0),l_in(0.562),l_in(0.937),l_in(1.781),      undef],
  [   "20","500",l_in(20.000),l_mm(508.0),l_in(0.593),l_in(0.937),l_in(1.968),      undef],
  [   "24","600",l_in(24.000),l_mm(610.0),l_in(0.687),l_in(1.218),l_in(2.343),      undef]
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
    include <database/component/structural/utility_pipe_ip.scad>;

    // temporary override for table presentation.
    // function l_mm(v) = round_s(length(v,"mm"), 4);

    length_unit_base = "in";

    n  = true;                // number
    hi = true;                // include heading id
    ht = true;                // include heading description

    tr = dtr_structural_utility_pipe_ip;
    tc = dtc_structural_utility_pipe_ip;

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
