//! [metric/screws] Slotted flat head machine screws; ISO 7046-1s; DIN 965.
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

    \amu_define group_name  (ISO 7046-1s)
    \amu_define group_brief ([metric/screws] Slotted flat head machine screws; ISO 7046-1s; DIN 965.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
  \amu_text parent (${parent}_Metric_Screws)
*******************************************************************************/

//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_include (include/amu/includes_required.amu)

  \details

    \amu_copy (files="diagrams/screw_machine_flat_slot.svg" types="html,latex")
    \amu_text
    (
    \image html ${PATH_NAME}/diagrams/screw_machine_flat_slot.svg "parameters"
    \image latex ${PATH_NAME}/diagrams/screw_machine_flat_slot.svg "parameters"
    )

    \amu_define output_scad     (false)
    \amu_define output_console  (false)

    \amu_define title           (Slotted flat head machine screws)
    \amu_define notes_table     ()

    \amu_include (include/amu/scope_table.amu)

    \note The measurements in the table above are shown with:
          \c length_unit_base="mm". These measurements will
          convert when the base units are changed. See \ref units_length
          for more information on setting the base units.

    | References:     |
    |:----------------|
    | ISO 7046-1s     |
    | DIN 965         |
    | [ISO 7046-1]    |
    | [fasteners.eu]  |

    [ISO 7046-1]: https://www.iso.org/standard/57373.html
    [fasteners.eu]: https://www.fasteners.eu/standards/ISO/7046/
*******************************************************************************/

//! <map> ISO 7046-1s data table columns map.
//! \hideinitializer
dtc_fastener_metric_screws_iso_7046_1s =
[
  ["ns", "nominal size"],
  ["tp", "thread pitch"],
  ["a_max", "head diameter"],
  ["a_min", "head diameter"],
  ["h_max", "head height"],
  ["j_max", "width of slot"],
  ["j_min", "width of slot"],
  ["t_max", "depth of slot"],
  ["t_min", "depth of slot"],
  ["u_max", "thread runout"]
];

//! \<table> ISO 7046-1s data table rows.
//! \hideinitializer
dtr_fastener_metric_screws_iso_7046_1s =
[
  ["M1.6",l_mm(0.35),l_mm( 3.00),l_mm( 2.70),l_mm(1.00),l_mm(0.60),l_mm(0.46),l_mm(0.50),l_mm(0.32),l_mm(0.7)],
  [  "M2",l_mm(0.40),l_mm( 3.80),l_mm( 3.50),l_mm(1.20),l_mm(0.70),l_mm(0.56),l_mm(0.60),l_mm(0.40),l_mm(0.8)],
  ["M2.5",l_mm(0.45),l_mm( 4.70),l_mm( 4.40),l_mm(1.50),l_mm(0.80),l_mm(0.66),l_mm(0.75),l_mm(0.50),l_mm(0.9)],
  [  "M3",l_mm(0.50),l_mm( 5.50),l_mm( 5.20),l_mm(1.65),l_mm(1.00),l_mm(0.86),l_mm(0.85),l_mm(0.60),l_mm(1.0)],
  [  "M4",l_mm(0.70),l_mm( 8.40),l_mm( 8.04),l_mm(2.70),l_mm(1.51),l_mm(1.26),l_mm(1.30),l_mm(1.00),l_mm(1.4)],
  [  "M5",l_mm(0.80),l_mm( 9.30),l_mm( 8.94),l_mm(2.70),l_mm(1.51),l_mm(1.26),l_mm(1.40),l_mm(1.10),l_mm(1.6)],
  [  "M6",l_mm(1.00),l_mm(11.30),l_mm(10.87),l_mm(3.30),l_mm(1.91),l_mm(1.66),l_mm(1.60),l_mm(1.20),l_mm(2.0)],
  [  "M8",l_mm(1.25),l_mm(15.80),l_mm(15.37),l_mm(4.65),l_mm(2.31),l_mm(2.06),l_mm(2.30),l_mm(1.80),l_mm(2.5)],
  [ "M10",l_mm(1.50),l_mm(18.30),l_mm(17.78),l_mm(5.00),l_mm(2.81),l_mm(2.56),l_mm(2.60),l_mm(2.00),l_mm(3.0)]
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
    include <database/component/fastener/iso_7046_1s.scad>;

    // temporary override for table presentation.
    // function l_mm(v) = round_s(length(v,"mm"), 4);

    length_unit_base = "mm";

    n  = true;                // number
    hi = true;                // include heading id
    ht = true;                // include heading description

    tr = dtr_fastener_metric_screws_iso_7046_1s;
    tc = dtc_fastener_metric_screws_iso_7046_1s;

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
