//! [metric/nuts] Hexagon nylon insert stop nuts, regular pattern; DIN 985; ISO 10511.
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

    \amu_define group_name  (DIN 985)
    \amu_define group_brief ([metric/nuts] Hexagon nylon insert stop nuts, regular pattern; DIN 985; ISO 10511.)

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

    \amu_define title           (Hexagon nylon insert stop nuts, regular pattern)
    \amu_define notes_table     ()

    \amu_include (include/amu/scope_table.amu)

    \note The measurements in the table above are shown with:
          \c length_unit_base="mm". These measurements will
          convert when the base units are changed. See \ref units_length
          for more information on setting the base units.

    | References:     |
    |:----------------|
    | DIN 985         |
    | ISO 10511       |
    | [fasterner.eu]  |

    [fasterner.eu]: https://www.fasteners.eu/standards/DIN/985/
*******************************************************************************/

//! <map> DIN 985 data table columns map.
//! \hideinitializer
dtc_fastener_metric_nuts_din_985 =
[
  ["ns", "nominal size"],
  ["f_max", "width across flats"],
  ["f_min", "width across flats"],
  ["g_min", "width across corners"],
  ["h_hax", "thickness"],
  ["h_min", "thickness"],
  ["i_min", "wrenching height"]
];

//! \<table> DIN 985 data table rows.
//! \hideinitializer
dtr_fastener_metric_nuts_din_985 =
[
  [ "M3",l_mm( 5.50),l_mm( 5.32),l_mm( 6.01),l_mm( 4.0),l_mm( 3.70),l_mm( 2.4)],
  [ "M4",l_mm( 7.00),l_mm( 6.78),l_mm( 7.66),l_mm( 5.0),l_mm( 4.70),l_mm( 2.9)],
  [ "M5",l_mm( 8.00),l_mm( 7.78),l_mm( 8.79),l_mm( 5.0),l_mm( 4.70),l_mm( 3.2)],
  [ "M6",l_mm(10.00),l_mm( 9.78),l_mm(11.05),l_mm( 6.0),l_mm( 5.70),l_mm( 4.0)],
  [ "M7",l_mm(11.00),l_mm(10.73),l_mm(12.12),l_mm( 7.5),l_mm( 7.14),l_mm( 4.7)],
  [ "M8",l_mm(13.00),l_mm(12.73),l_mm(14.38),l_mm( 8.0),l_mm( 7.64),l_mm( 5.5)],
  ["M10",l_mm(17.00),l_mm(16.73),l_mm(18.90),l_mm(10.0),l_mm( 9.64),l_mm( 6.5)],
  ["M12",l_mm(19.00),l_mm(18.67),l_mm(21.10),l_mm(12.0),l_mm(11.57),l_mm( 8.0)],
  ["M14",l_mm(22.00),l_mm(21.67),l_mm(24.49),l_mm(14.0),l_mm(13.30),l_mm( 9.5)],
  ["M16",l_mm(24.00),l_mm(23.67),l_mm(26.75),l_mm(16.0),l_mm(15.30),l_mm(10.5)],
  ["M18",l_mm(27.00),l_mm(26.16),l_mm(29.56),l_mm(18.0),l_mm(17.66),l_mm(13.0)],
  ["M20",l_mm(30.00),l_mm(29.16),l_mm(32.95),l_mm(20.0),l_mm(18.70),l_mm(14.0)]
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
    include <database/component/fastener/din_985.scad>;

    // temporary override for table presentation.
    // function l_mm(v) = round_s(length(v,"mm"), 4);

    length_unit_base = "mm";

    n  = true;                // number
    hi = true;                // include heading id
    ht = true;                // include heading description

    tr = dtr_fastener_metric_nuts_din_985;
    tc = dtc_fastener_metric_nuts_din_985;

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
