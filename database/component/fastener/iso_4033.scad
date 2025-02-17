//! [metric/nuts] Hexagon nuts style 2; ISO 4033; DIN EN ISO.
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

    \amu_define group_name  (ISO 4033)
    \amu_define group_brief ([metric/nuts] Hexagon nuts style 2; ISO 4033; DIN EN ISO.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
  \amu_text parent (${parent}_Metric_Nuts)
*******************************************************************************/

//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_include (include/amu/includes_required.amu)

  \details

    \amu_copy (files="diagrams/nut_hex.svg" types="html,latex")
    \amu_text
    (
    \image html ${PATH_NAME}/diagrams/nut_hex.svg "parameters"
    \image latex ${PATH_NAME}/diagrams/nut_hex.svg "parameters"
    )

    \amu_define output_scad     (false)
    \amu_define output_console  (false)

    \amu_define title           (Hexagon nuts style 2)
    \amu_define notes_table     ()

    \amu_include (include/amu/scope_table.amu)

    \note The measurements in the table above are shown with:
          \c length_unit_base="mm". These measurements will
          convert when the base units are changed. See \ref units_length
          for more information on setting the base units.

    | References:  |
    |:-------------|
    | ISO 4033     |
    | DIN EN ISO   |
    | [ISO 4033]   |

    [ISO 4033]: https://www.iso.org/standard/75017.html
*******************************************************************************/

//! <map> ISO 4033 data table columns map.
//! \hideinitializer
dtc_fastener_metric_nuts_iso_4033 =
[
  ["ns", "nominal size"],
  ["tp", "thread pitch"],
  ["f_max", "width across flats"],
  ["f_min", "width across flats"],
  ["g_min", "width across corners"],
  ["h_hax", "thickness"],
  ["h_min", "thickness"]
];

//! \<table> ISO 4033 data table rows.
//! \hideinitializer
dtr_fastener_metric_nuts_iso_4033 =
[
  [ "M5",l_mm(0.80),l_mm(  8),l_mm( 7.78),l_mm( 8.79),l_mm( 5.1),l_mm( 4.80)],
  [ "M6",l_mm(1.00),l_mm( 10),l_mm( 9.78),l_mm(11.05),l_mm( 5.7),l_mm( 5.40)],
  [ "M8",l_mm(1.25),l_mm( 13),l_mm(12.73),l_mm(14.38),l_mm( 7.5),l_mm( 7.14)],
  ["M10",l_mm(1.50),l_mm( 16),l_mm(15.73),l_mm(17.77),l_mm( 9.3),l_mm( 8.94)],
  ["M12",l_mm(1.75),l_mm( 18),l_mm(17.73),l_mm(20.03),l_mm(12.0),l_mm(11.57)],
  ["M14",l_mm(2.00),l_mm( 21),l_mm(20.67),l_mm(23.35),l_mm(14.1),l_mm(13.40)],
  ["M16",l_mm(2.00),l_mm( 24),l_mm(23.67),l_mm(26.75),l_mm(16.4),l_mm(15.70)],
  ["M20",l_mm(2.50),l_mm( 30),l_mm(29.16),l_mm(32.95),l_mm(20.3),l_mm(19.00)],
  ["M24",l_mm(3.00),l_mm( 36),l_mm(35.00),l_mm(39.55),l_mm(23.9),l_mm(22.60)],
  ["M30",l_mm(3.50),l_mm( 46),l_mm(45.00),l_mm(50.85),l_mm(28.6),l_mm(27.30)],
  ["M36",l_mm(4.00),l_mm( 55),l_mm(53.80),l_mm(60.79),l_mm(34.7),l_mm(33.10)]
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
    include <database/component/fastener/iso_4033.scad>;

    // temporary override for table presentation.
    // function l_mm(v) = round_s(length(v,"mm"), 4);

    length_unit_base = "mm";

    n  = true;                // number
    hi = true;                // include heading id
    ht = true;                // include heading description

    tr = dtr_fastener_metric_nuts_iso_4033;
    tc = dtc_fastener_metric_nuts_iso_4033;

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
