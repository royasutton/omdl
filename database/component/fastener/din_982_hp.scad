//! [metric/nuts] Hexagon nylon insert stop nuts, heavy pattern; DIN 982 hp; ISO 7040.
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

    \amu_define group_name  (DIN 982 hp)
    \amu_define group_brief ([metric/nuts] Hexagon nylon insert stop nuts, heavy pattern; DIN 982 hp; ISO 7040.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
  \amu_text parent (${parent}_Metric_Nuts)
*******************************************************************************/

//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_include (include/amu/includes_required.amu)

  \details

    \amu_copy (files="diagrams/nut_hex_nylon_insert_stop.svg" types="html,latex")
    \amu_text
    (
    \image html ${PATH_NAME}/diagrams/nut_hex_nylon_insert_stop.svg "parameters"
    \image latex ${PATH_NAME}/diagrams/nut_hex_nylon_insert_stop.svg "parameters"
    )

    \amu_define output_scad     (false)
    \amu_define output_console  (false)

    \amu_define title           (Hexagon nylon insert stop nuts, heavy pattern)
    \amu_define notes_table     ()

    \amu_include (include/amu/scope_table.amu)

    \note The measurements in the table above are shown with:
          \c length_unit_base="mm". These measurements will
          convert when the base units are changed. See \ref units_length
          for more information on setting the base units.

    | References:     |
    |:----------------|
    | DIN 982 hp      |
    | ISO 7040        |
    | [fasterner.eu]  |
    | [ISO 7040]      |

    [fasterner.eu]: https://www.fasteners.eu/standards/DIN/982/
    [ISO 7040]: https://www.iso.org/standard/61363.html
*******************************************************************************/

//! <map> DIN 982 hp data table columns map.
//! \hideinitializer
dtc_fastener_metric_nuts_din_982_hp =
[
  ["ns", "nominal size"],
  ["tp", "thread pitch"],
  ["f_max", "width across flats"],
  ["f_min", "width across flats"],
  ["g_min", "width across corners"],
  ["h_hax", "thickness"],
  ["h_min", "thickness"],
  ["i_min", "wrenching height"]
];

//! \<table> DIN 982 hp data table rows.
//! \hideinitializer
dtr_fastener_metric_nuts_din_982_hp =
[
  [ "M5",l_mm(0.80),l_mm( 8.00),l_mm( 7.78),l_mm( 8.79),l_mm( 7.20),l_mm( 6.62),l_mm( 3.52)],
  [ "M6",l_mm(1.00),l_mm(10.00),l_mm( 9.78),l_mm(11.05),l_mm( 8.50),l_mm( 7.92),l_mm( 3.92)],
  [ "M8",l_mm(1.25),l_mm(13.00),l_mm(12.73),l_mm(14.38),l_mm(10.20),l_mm( 9.50),l_mm( 5.15)],
  ["M10",l_mm(1.50),l_mm(16.00),l_mm(15.73),l_mm(17.77),l_mm(12.80),l_mm(12.10),l_mm( 6.43)],
  ["M12",l_mm(1.75),l_mm(18.00),l_mm(17.73),l_mm(20.03),l_mm(16.10),l_mm(15.40),l_mm( 8.30)],
  ["M16",l_mm(2.00),l_mm(24.00),l_mm(23.67),l_mm(26.75),l_mm(20.70),l_mm(19.40),l_mm(11.28)],
  ["M20",l_mm(2.50),l_mm(30.00),l_mm(29.16),l_mm(32.95),l_mm(25.10),l_mm(23.00),l_mm(13.52)],
  ["M24",l_mm(3.00),l_mm(36.00),l_mm(35.00),l_mm(39.55),l_mm(29.50),l_mm(27.40),l_mm(16.16)],
  ["M30",l_mm(3.50),l_mm(46.00),l_mm(45.00),l_mm(50.85),l_mm(35.60),l_mm(33.10),l_mm(19.44)],
  ["M36",l_mm(4.00),l_mm(55.00),l_mm(53.80),l_mm(60.79),l_mm(42.60),l_mm(40.10),l_mm(23.52)]
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
    include <database/component/fastener/din_982_hp.scad>;

    // temporary override for table presentation.
    // function l_mm(v) = round_s(length(v,"mm"), 4);

    length_unit_base = "mm";

    n  = true;                // number
    hi = true;                // include heading id
    ht = true;                // include heading description

    tr = dtr_fastener_metric_nuts_din_982_hp;
    tc = dtc_fastener_metric_nuts_din_982_hp;

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
