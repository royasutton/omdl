//! [metric/screws] Button head socket cap screws; ISO 7380; DIN EN ISO 7380-1.
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

    \amu_define group_name  (ISO 7380)
    \amu_define group_brief ([metric/screws] Button head socket cap screws; ISO 7380; DIN EN ISO 7380-1.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
  \amu_text parent (${parent}_Metric_Screws)
*******************************************************************************/

//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_include (include/amu/includes_required.amu)

  \details

    \amu_copy (files="diagrams/screw_socket_hex_button.svg" types="html,latex")
    \amu_text
    (
    \image html ${PATH_NAME}/diagrams/screw_socket_hex_button.svg "parameters"
    \image latex ${PATH_NAME}/diagrams/screw_socket_hex_button.svg "parameters"
    )

    \amu_define output_scad     (false)
    \amu_define output_console  (false)

    \amu_define title           (Button head socket cap screws)
    \amu_define notes_table     ()

    \amu_include (include/amu/scope_table.amu)

    \note The measurements in the table above are shown with:
          \c length_unit_base="mm". These measurements will
          convert when the base units are changed. See \ref units_length
          for more information on setting the base units.

    | References:        |
    |:-------------------|
    | ISO 7380           |
    | DIN EN ISO 7380-1  |
    | [fasteners.eu]     |

    [fasteners.eu]: https://www.fasteners.eu/standards/ISO/7380
*******************************************************************************/

//! <map> ISO 7380 data table columns map.
//! \hideinitializer
dtc_fastener_metric_screws_iso_7380 =
[
  ["ns", "nominal size"],
  ["tp", "thread pitch"],
  ["a_max", "head diameter"],
  ["a_min", "head diameter"],
  ["h_max", "head height"],
  ["h_min", "head height"],
  ["c_min", "socket size across the corners"],
  ["j_max", "socket size across the flats"],
  ["j_min", "socket size across the flats"],
  ["t_min", "key engagement"],
  ["w_min", "wall thickness"],
  ["s_max", "unthreaded section under the head"],
  ["s_min", "unthreaded section under the head"],
  ["f_max", "fillet transition diameter"]
];

//! \<table> ISO 7380 data table rows.
//! \hideinitializer
dtr_fastener_metric_screws_iso_7380 =
[
  [ "M3",l_mm(0.50),l_mm( 5.70),l_mm( 5.40),l_mm(1.65),l_mm(1.40),l_mm( 2.30),l_mm( 2.045),l_mm( 2.020),l_mm(1.04),l_mm(0.20),l_mm(1.00),l_mm(0.50),l_mm( 3.6)],
  [ "M4",l_mm(0.70),l_mm( 7.60),l_mm( 7.24),l_mm(2.20),l_mm(1.95),l_mm( 2.87),l_mm( 2.560),l_mm( 2.520),l_mm(1.30),l_mm(0.30),l_mm(1.40),l_mm(0.70),l_mm( 4.7)],
  [ "M5",l_mm(0.80),l_mm( 9.50),l_mm( 9.14),l_mm(2.75),l_mm(2.50),l_mm( 3.44),l_mm( 3.071),l_mm( 3.020),l_mm(1.56),l_mm(0.38),l_mm(1.60),l_mm(0.80),l_mm( 5.7)],
  [ "M6",l_mm(1.00),l_mm(10.50),l_mm(10.07),l_mm(3.30),l_mm(3.00),l_mm( 4.58),l_mm( 4.084),l_mm( 4.020),l_mm(2.08),l_mm(0.74),l_mm(2.00),l_mm(1.00),l_mm( 6.8)],
  [ "M8",l_mm(1.25),l_mm(14.00),l_mm(13.57),l_mm(4.40),l_mm(4.10),l_mm( 5.72),l_mm( 5.084),l_mm( 5.020),l_mm(2.60),l_mm(1.05),l_mm(2.50),l_mm(1.25),l_mm( 9.2)],
  ["M10",l_mm(1.50),l_mm(17.50),l_mm(17.07),l_mm(5.50),l_mm(5.20),l_mm( 6.86),l_mm( 6.095),l_mm( 6.020),l_mm(3.12),l_mm(1.45),l_mm(3.00),l_mm(1.50),l_mm(11.2)],
  ["M12",l_mm(1.75),l_mm(21.00),l_mm(20.48),l_mm(6.60),l_mm(6.24),l_mm( 9.15),l_mm( 8.115),l_mm( 8.025),l_mm(4.16),l_mm(1.63),l_mm(3.50),l_mm(1.75),l_mm(14.2)],
  ["M16",l_mm(2.00),l_mm(28.00),l_mm(27.48),l_mm(8.80),l_mm(8.44),l_mm(11.43),l_mm(10.115),l_mm(10.025),l_mm(5.20),l_mm(2.25),l_mm(4.00),l_mm(2.00),l_mm(18.2)]
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
    include <database/component/fastener/iso_7380.scad>;

    // temporary override for table presentation.
    // function l_mm(v) = round_s(length(v,"mm"), 4);

    length_unit_base = "mm";

    n  = true;                // number
    hi = true;                // include heading id
    ht = true;                // include heading description

    tr = dtr_fastener_metric_screws_iso_7380;
    tc = dtc_fastener_metric_screws_iso_7380;

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
