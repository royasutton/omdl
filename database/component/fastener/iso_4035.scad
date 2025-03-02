//! [metric/nuts] Hexagon jam nut; ISO 4035; DIN 439 B, CSN 021403, UNI 5589, EU 24035.
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

    \amu_define group_name  (ISO 4035)
    \amu_define group_brief ([metric/nuts] Hexagon jam nut; ISO 4035; DIN 439 B, CSN 021403, UNI 5589, EU 24035.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
  \amu_text parent (${parent}_Metric_Nuts)
*******************************************************************************/

//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_include (include/amu/includes_required.amu)

  \details

    \amu_copy (files="diagrams/nut_hex_jam.svg" types="html,latex")
    \amu_text
    (
    \image html ${PATH_NAME}/diagrams/nut_hex_jam.svg "parameters"
    \image latex ${PATH_NAME}/diagrams/nut_hex_jam.svg "parameters"
    )

    \amu_define output_scad     (false)
    \amu_define output_console  (false)

    \amu_define title           (Hexagon jam nut)
    \amu_define notes_table     ()

    \amu_include (include/amu/scope_table.amu)

    \note The measurements in the table above are shown with:
          \c length_unit_base="mm". These measurements will
          convert when the base units are changed. See \ref units_length
          for more information on setting the base units.

    | References:                                |
    |:-------------------------------------------|
    | ISO 4035                                   |
    | DIN 439 B, CSN 021403, UNI 5589, EU 24035  |
    | [ISO 4035]                                 |
    | [fasterner.eu]                             |

    [ISO 4035]: https://www.iso.org/standard/61671.html
    [fasterner.eu]: https://www.fasteners.eu/standards/ISO/4035/
*******************************************************************************/

//! <map> ISO 4035 data table columns map.
//! \hideinitializer
dtc_fastener_metric_nuts_iso_4035 =
[
  ["ns", "nominal size"],
  ["tp", "thread pitch"],
  ["f_max", "width across flats"],
  ["f_min", "width across flats"],
  ["g_min", "width across corners"],
  ["h_hax", "thickness"],
  ["h_min", "thickness"]
];

//! \<table> ISO 4035 data table rows.
//! \hideinitializer
dtr_fastener_metric_nuts_iso_4035 =
[
  ["M1.6",l_mm(0.35),l_mm( 3.2),l_mm( 3.02),l_mm( 3.41),l_mm( 1.00),l_mm( 0.75)],
  [  "M2",l_mm(0.40),l_mm( 4.0),l_mm( 3.82),l_mm( 4.32),l_mm( 1.20),l_mm( 0.95)],
  ["M2.5",l_mm(0.45),l_mm( 5.0),l_mm( 4.82),l_mm( 5.45),l_mm( 1.60),l_mm( 1.35)],
  [  "M3",l_mm(0.50),l_mm( 5.5),l_mm( 5.32),l_mm( 6.01),l_mm( 1.80),l_mm( 1.55)],
  [  "M4",l_mm(0.70),l_mm( 7.0),l_mm( 6.78),l_mm( 7.66),l_mm( 2.20),l_mm( 1.95)],
  [  "M5",l_mm(0.80),l_mm( 8.0),l_mm( 7.78),l_mm( 8.79),l_mm( 2.70),l_mm( 2.45)],
  [  "M6",l_mm(1.00),l_mm(10.0),l_mm( 9.78),l_mm(11.05),l_mm( 3.20),l_mm( 2.90)],
  [  "M8",l_mm(1.25),l_mm(13.0),l_mm(12.73),l_mm(14.38),l_mm( 4.00),l_mm( 3.70)],
  [ "M10",l_mm(1.50),l_mm(16.0),l_mm(15.73),l_mm(17.77),l_mm( 5.00),l_mm( 4.70)],
  [ "M12",l_mm(1.75),l_mm(18.0),l_mm(17.73),l_mm(20.03),l_mm( 6.00),l_mm( 5.70)],
  [ "M14",l_mm(2.00),l_mm(21.0),l_mm(20.67),l_mm(23.35),l_mm( 7.00),l_mm( 6.42)],
  [ "M16",l_mm(2.00),l_mm(24.0),l_mm(23.67),l_mm(26.75),l_mm( 8.00),l_mm( 7.42)],
  [ "M20",l_mm(2.50),l_mm(30.0),l_mm(29.16),l_mm(32.95),l_mm(10.00),l_mm( 9.10)],
  [ "M24",l_mm(3.00),l_mm(36.0),l_mm(35.00),l_mm(39.55),l_mm(12.00),l_mm(10.90)],
  [ "M30",l_mm(3.50),l_mm(46.0),l_mm(45.00),l_mm(50.85),l_mm(15.00),l_mm(13.90)],
  [ "M36",l_mm(4.00),l_mm(55.0),l_mm(53.80),l_mm(60.79),l_mm(18.00),l_mm(16.90)],
  [ "M42",l_mm(4.50),l_mm(65.0),l_mm(63.10),l_mm(71.30),l_mm(21.00),l_mm(19.70)],
  [ "M48",l_mm(5.00),l_mm(75.0),l_mm(73.10),l_mm(82.60),l_mm(24.00),l_mm(22.70)]
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
    include <database/component/fastener/iso_4035.scad>;

    // temporary override for table presentation.
    // function l_mm(v) = round_s(length(v,"mm"), 4);

    length_unit_base = "mm";

    n  = true;                // number
    hi = true;                // include heading id
    ht = true;                // include heading description

    tr = dtr_fastener_metric_nuts_iso_4035;
    tc = dtc_fastener_metric_nuts_iso_4035;

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
