//! [metric/nuts] Hexagon flange nut, style 1; ISO 4161.
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

    \amu_define group_name  (ISO 4161)
    \amu_define group_brief ([metric/nuts] Hexagon flange nut, style 1; ISO 4161.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
  \amu_text parent (${parent}_Metric_Nuts)
*******************************************************************************/

//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_include (include/amu/includes_required.amu)

  \details

    \amu_copy (files="diagrams/nut_hex_flange.svg" types="html,latex")
    \amu_text
    (
    \image html ${PATH_NAME}/diagrams/nut_hex_flange.svg "parameters"
    \image latex ${PATH_NAME}/diagrams/nut_hex_flange.svg "parameters"
    )

    \amu_define output_scad     (false)
    \amu_define output_console  (false)

    \amu_define title           (Hexagon flange nut, style 1)
    \amu_define notes_table     ()

    \amu_include (include/amu/scope_table.amu)

    \note The measurements in the table above are shown with:
          \c length_unit_base="mm". These measurements will
          convert when the base units are changed. See \ref units_length
          for more information on setting the base units.

    | References:     |
    |:----------------|
    | ISO 4161        |
    | [ISO 4161]      |
    | [fasterner.eu]  |

    [ISO 4161]: https://www.iso.org/standard/61523.html
    [fasterner.eu]: https://www.fasteners.eu/standards/ISO/4161
*******************************************************************************/

//! <map> ISO 4161 data table columns map.
//! \hideinitializer
dtc_fastener_metric_nuts_iso_4161 =
[
  ["ns", "nominal size"],
  ["tp", "thread pitch"],
  ["f_max", "width across flats"],
  ["f_min", "width across flats"],
  ["g_min", "width across corners"],
  ["h_hax", "thickness"],
  ["h_min", "thickness"],
  ["b_max", "flange diameter"]
];

//! \<table> ISO 4161 data table rows.
//! \hideinitializer
dtr_fastener_metric_nuts_iso_4161 =
[
  [ "M5",l_mm(0.80),l_mm( 8.00),l_mm( 7.78),l_mm( 8.79),l_mm(  5),l_mm( 4.7),l_mm(11.8)],
  [ "M6",l_mm(1.00),l_mm(10.00),l_mm( 9.78),l_mm(11.05),l_mm(  6),l_mm( 5.7),l_mm(14.2)],
  [ "M8",l_mm(1.25),l_mm(13.00),l_mm(12.73),l_mm(14.38),l_mm(  8),l_mm( 7.6),l_mm(17.9)],
  ["M10",l_mm(1.50),l_mm(15.00),l_mm(14.73),l_mm(16.64),l_mm( 10),l_mm( 9.6),l_mm(21.8)],
  ["M12",l_mm(1.75),l_mm(18.00),l_mm(17.73),l_mm(20.03),l_mm( 12),l_mm(11.6),l_mm(26.0)],
  ["M16",l_mm(2.00),l_mm(24.00),l_mm(23.67),l_mm(26.75),l_mm( 16),l_mm(15.3),l_mm(34.5)],
  ["M20",l_mm(2.50),l_mm(30.00),l_mm(29.16),l_mm(32.95),l_mm( 20),l_mm(18.9),l_mm(42.8)]
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
    include <database/component/fastener/iso_4161.scad>;

    // temporary override for table presentation.
    // function l_mm(v) = round_s(length(v,"mm"), 4);

    length_unit_base = "mm";

    n  = true;                // number
    hi = true;                // include heading id
    ht = true;                // include heading description

    tr = dtr_fastener_metric_nuts_iso_4161;
    tc = dtc_fastener_metric_nuts_iso_4161;

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
