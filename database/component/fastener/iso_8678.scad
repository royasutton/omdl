//! [metric/bolts] Carriage bolts, short neck; ISO 8678; DIN 603.
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

    \amu_define group_name  (ISO 8678)
    \amu_define group_brief ([metric/bolts] Carriage bolts, short neck; ISO 8678; DIN 603.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
  \amu_text parent (${parent}_Metric_Bolts)
*******************************************************************************/

//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_include (include/amu/includes_required.amu)

  \details

    \amu_copy (files="diagrams/bolt_carriage_short_neck.svg" types="html,latex")
    \amu_text
    (
    \image html ${PATH_NAME}/diagrams/bolt_carriage_short_neck.svg "parameters"
    \image latex ${PATH_NAME}/diagrams/bolt_carriage_short_neck.svg "parameters"
    )

    \amu_define output_scad     (false)
    \amu_define output_console  (false)

    \amu_define title           (Carriage bolts, short neck)
    \amu_define notes_table     (l1_ref for [L<=125]; l2_ref for[L>125 & L<=200])

    \amu_include (include/amu/scope_table.amu)

    \note The measurements in the table above are shown with:
          \c length_unit_base="mm". These measurements will
          convert when the base units are changed. See \ref units_length
          for more information on setting the base units.

    | References:      |
    |:-----------------|
    | ISO 8678         |
    | DIN 603          |
    | [ISO 8678:1988]  |

    [ISO 8678:1988]: https://www.iso.org/standard/16078.html
*******************************************************************************/

//! <map> ISO 8678 data table columns map.
//! \hideinitializer
dtc_fastener_metric_bolts_iso_8678 =
[
  ["ns", "nominal size"],
  ["tp", "thread pitch"],
  ["o_max", "square width across flats"],
  ["o_min", "square width across flats"],
  ["c_min", "square width across corners"],
  ["p_max", "square depth"],
  ["p_min", "square depth"],
  ["a_max", "head diameter"],
  ["b_min", "bearing surface diameter under head"],
  ["h_max", "head height"],
  ["h_min", "head height"],
  ["l1_ref", "thread length"],
  ["l2_ref", "thread length"]
];

//! \<table> ISO 8678 data table rows.
//! \hideinitializer
dtr_fastener_metric_bolts_iso_8678 =
[
  [ "M6",l_mm(1.00),l_mm( 6.48),l_mm( 5.88),l_mm( 7.64),l_mm( 3),l_mm(2.4),l_mm(14.2),l_mm(12.2),l_mm( 3.6),l_mm(  3),l_mm( 18),      undef],
  [ "M8",l_mm(1.25),l_mm( 8.58),l_mm( 7.85),l_mm(10.20),l_mm( 3),l_mm(2.4),l_mm(18.0),l_mm(15.8),l_mm( 4.8),l_mm(  4),l_mm( 22),l_mm(   28)],
  ["M10",l_mm(1.50),l_mm(10.58),l_mm( 9.85),l_mm(12.80),l_mm( 4),l_mm(3.2),l_mm(22.3),l_mm(19.6),l_mm( 5.8),l_mm(  5),l_mm( 26),l_mm(   32)],
  ["M12",l_mm(1.75),l_mm(12.70),l_mm(11.82),l_mm(15.37),l_mm( 4),l_mm(3.2),l_mm(26.6),l_mm(23.8),l_mm( 6.8),l_mm(  6),l_mm( 30),l_mm(   36)],
  ["M16",l_mm(2.00),l_mm(16.70),l_mm(15.82),l_mm(20.57),l_mm( 5),l_mm(4.2),l_mm(35.0),l_mm(31.9),l_mm( 8.9),l_mm(  8),l_mm( 38),l_mm(   44)],
  ["M20",l_mm(2.50),l_mm(20.84),l_mm(19.79),l_mm(25.73),l_mm( 5),l_mm(4.2),l_mm(43.0),l_mm(39.9),l_mm(10.9),l_mm( 10),l_mm( 46),l_mm(   52)]
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
    include <database/component/fastener/iso_8678.scad>;

    // temporary override for table presentation.
    // function l_mm(v) = round_s(length(v,"mm"), 4);

    length_unit_base = "mm";

    n  = true;                // number
    hi = true;                // include heading id
    ht = true;                // include heading description

    tr = dtr_fastener_metric_bolts_iso_8678;
    tc = dtc_fastener_metric_bolts_iso_8678;

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
