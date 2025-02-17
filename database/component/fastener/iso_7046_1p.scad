//! [metric/screws] Phillips flat head machine screws; ISO 7046-1p; DIN 965.
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

    \amu_define group_name  (ISO 7046-1p)
    \amu_define group_brief ([metric/screws] Phillips flat head machine screws; ISO 7046-1p; DIN 965.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
  \amu_text parent (${parent}_Metric_Screws)
*******************************************************************************/

//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_include (include/amu/includes_required.amu)

  \details

    \amu_copy (files="diagrams/screw_machine_flat_phillips.svg" types="html,latex")
    \amu_text
    (
    \image html ${PATH_NAME}/diagrams/screw_machine_flat_phillips.svg "parameters"
    \image latex ${PATH_NAME}/diagrams/screw_machine_flat_phillips.svg "parameters"
    )

    \amu_define output_scad     (false)
    \amu_define output_console  (false)

    \amu_define title           (Phillips flat head machine screws)
    \amu_define notes_table     ()

    \amu_include (include/amu/scope_table.amu)

    \note The measurements in the table above are shown with:
          \c length_unit_base="mm". These measurements will
          convert when the base units are changed. See \ref units_length
          for more information on setting the base units.

    | References:     |
    |:----------------|
    | ISO 7046-1p     |
    | DIN 965         |
    | [ISO 7046-1]    |
    | [fasteners.eu]  |

    [ISO 7046-1]: https://www.iso.org/standard/57373.html
    [fasteners.eu]: https://www.fasteners.eu/standards/ISO/7046/
*******************************************************************************/

//! <map> ISO 7046-1p data table columns map.
//! \hideinitializer
dtc_fastener_metric_screws_iso_7046_1p =
[
  ["ns", "nominal size"],
  ["tp", "thread pitch"],
  ["a_max", "head diameter"],
  ["a_min", "head diameter"],
  ["h_max", "head height"],
  ["m_ref", "recess diameter"],
  ["g_max", "recess penetration"],
  ["g_min", "recess penetration"],
  ["u_max", "thread runout"],
  ["t", "phillips driver size"]
];

//! \<table> ISO 7046-1p data table rows.
//! \hideinitializer
dtr_fastener_metric_screws_iso_7046_1p =
[
  ["M1.6",l_mm(0.35),l_mm( 3.00),l_mm( 2.70),l_mm(1.00),l_mm( 1.6),l_mm(0.9),l_mm(0.6),l_mm(0.7),undef],
  [  "M2",l_mm(0.40),l_mm( 3.80),l_mm( 3.50),l_mm(1.20),l_mm( 1.9),l_mm(1.2),l_mm(0.9),l_mm(0.8),undef],
  ["M2.5",l_mm(0.45),l_mm( 4.70),l_mm( 4.40),l_mm(1.50),l_mm( 2.9),l_mm(1.8),l_mm(1.4),l_mm(0.9),    1],
  [  "M3",l_mm(0.50),l_mm( 5.50),l_mm( 5.20),l_mm(1.65),l_mm( 3.2),l_mm(2.1),l_mm(1.7),l_mm(1.0),    1],
  [  "M4",l_mm(0.70),l_mm( 8.40),l_mm( 8.04),l_mm(2.70),l_mm( 4.6),l_mm(2.6),l_mm(2.1),l_mm(1.4),    2],
  [  "M5",l_mm(0.80),l_mm( 9.30),l_mm( 8.94),l_mm(2.70),l_mm( 5.2),l_mm(3.2),l_mm(2.7),l_mm(1.6),    2],
  [  "M6",l_mm(1.00),l_mm(11.30),l_mm(10.87),l_mm(3.30),l_mm( 6.8),l_mm(3.5),l_mm(3.0),l_mm(2.0),    3],
  [  "M8",l_mm(1.25),l_mm(15.80),l_mm(15.37),l_mm(4.65),l_mm( 8.9),l_mm(4.6),l_mm(4.0),l_mm(2.5),    4],
  [ "M10",l_mm(1.50),l_mm(18.30),l_mm(17.78),l_mm(5.00),l_mm(10.0),l_mm(5.7),l_mm(5.1),l_mm(3.0),    4]
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
    include <database/component/fastener/iso_7046_1p.scad>;

    // temporary override for table presentation.
    // function l_mm(v) = round_s(length(v,"mm"), 4);

    length_unit_base = "mm";

    n  = true;                // number
    hi = true;                // include heading id
    ht = true;                // include heading description

    tr = dtr_fastener_metric_screws_iso_7046_1p;
    tc = dtc_fastener_metric_screws_iso_7046_1p;

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
