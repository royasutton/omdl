//! [metric/bolts] Hexagon head bolt b; ISO 4014b; DIN 931.
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

    \amu_define group_name  (ISO 4014b)
    \amu_define group_brief ([metric/bolts] Hexagon head bolt b; ISO 4014b; DIN 931.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
  \amu_text parent (${parent}_Metric_Bolts)
*******************************************************************************/

//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_include (include/amu/includes_required.amu)

  \details

    \amu_copy (files="diagrams/bolt_hex.svg" types="html,latex")
    \amu_text
    (
    \image html ${PATH_NAME}/diagrams/bolt_hex.svg "parameters"
    \image latex ${PATH_NAME}/diagrams/bolt_hex.svg "parameters"
    )

    \amu_define output_scad     (false)
    \amu_define output_console  (false)

    \amu_define title           (Hexagon head bolt b)
    \amu_define notes_table     (r_1 for [L>125mm & L<200mm]; r_2 for [L>200mm])

    \amu_include (include/amu/scope_table.amu)

    \note The measurements in the table above are shown with:
          \c length_unit_base="mm". These measurements will
          convert when the base units are changed. See \ref units_length
          for more information on setting the base units.

    | References:     |
    |:----------------|
    | ISO 4014b       |
    | DIN 931         |
    | [ISO 4014]      |
    | [fasteners.eu]  |

    [ISO 4014]: https://www.iso.org/standard/56447.html
    [fasteners.eu]: https://www.fasteners.eu/standards/ISO/4014/
*******************************************************************************/

//! <map> ISO 4014b data table columns map.
//! \hideinitializer
dtc_fastener_metric_bolts_iso_4014b =
[
  ["ns", "nominal size"],
  ["tp", "thread pitch"],
  ["r_1", "thread length"],
  ["r_2", "thread length"],
  ["w_max", "washer face thickness"],
  ["w_min", "washer face thickness"],
  ["t_max", "fillet transition diameter"],
  ["u_max", "under head fillet"],
  ["e_min", "washer face diameter"],
  ["h_max", "head height"],
  ["h_min", "head height"],
  ["f_max", "width across flats"],
  ["f_min", "width across flats"],
  ["g_min", "width across corners"],
  ["k_min", "wrenching height"]
];

//! \<table> ISO 4014b data table rows.
//! \hideinitializer
dtr_fastener_metric_bolts_iso_4014b =
[
  ["M16",l_mm(2.0),l_mm(   44),      undef,l_mm(0.8),l_mm(0.2),l_mm(17.7),l_mm(  3),l_mm(22.00),l_mm(10.29),l_mm( 9.71),l_mm( 24),l_mm(23.16),l_mm( 26.17),l_mm( 6.80)],
  ["M20",l_mm(2.5),l_mm(   52),      undef,l_mm(0.8),l_mm(0.2),l_mm(22.4),l_mm(  4),l_mm(27.70),l_mm(12.85),l_mm(12.15),l_mm( 30),l_mm(29.16),l_mm( 32.95),l_mm( 8.51)],
  ["M24",l_mm(3.0),l_mm(   60),l_mm(   73),l_mm(0.8),l_mm(0.2),l_mm(26.4),l_mm(  4),l_mm(33.25),l_mm(15.35),l_mm(14.65),l_mm( 36),l_mm(35.00),l_mm( 39.55),l_mm(10.26)],
  ["M30",l_mm(3.5),l_mm(   72),l_mm(   85),l_mm(0.8),l_mm(0.2),l_mm(33.4),l_mm(  6),l_mm(42.75),l_mm(19.12),l_mm(18.28),l_mm( 46),l_mm(45.00),l_mm( 50.85),l_mm(12.80)],
  ["M36",l_mm(4.0),l_mm(   84),l_mm(   97),l_mm(0.8),l_mm(0.2),l_mm(39.4),l_mm(  6),l_mm(51.11),l_mm(22.92),l_mm(22.08),l_mm( 55),l_mm(53.80),l_mm( 60.79),l_mm(15.46)],
  ["M42",l_mm(4.5),l_mm(   96),l_mm(  109),l_mm(1.0),l_mm(0.3),l_mm(45.6),l_mm(  8),l_mm(59.95),l_mm(26.42),l_mm(25.58),l_mm( 65),l_mm(63.10),l_mm( 71.30),l_mm(17.91)],
  ["M48",l_mm(5.0),l_mm(  108),l_mm(  121),l_mm(1.0),l_mm(0.3),l_mm(52.6),l_mm( 10),l_mm(69.45),l_mm(30.42),l_mm(29.58),l_mm( 75),l_mm(73.10),l_mm( 82.60),l_mm(20.71)],
  ["M56",l_mm(5.5),      undef,l_mm(  137),l_mm(1.0),l_mm(0.3),l_mm(63.0),l_mm( 12),l_mm(78.66),l_mm(35.50),l_mm(34.50),l_mm( 85),l_mm(82.80),l_mm( 93.56),l_mm(24.15)],
  ["M64",l_mm(6.0),      undef,l_mm(  153),l_mm(1.0),l_mm(0.3),l_mm(71.0),l_mm( 13),l_mm(88.16),l_mm(40.50),l_mm(39.50),l_mm( 95),l_mm(92.80),l_mm(104.86),l_mm(27.65)]
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
    include <database/component/fastener/iso_4014b.scad>;

    // temporary override for table presentation.
    // function l_mm(v) = round_s(length(v,"mm"), 4);

    length_unit_base = "mm";

    n  = true;                // number
    hi = true;                // include heading id
    ht = true;                // include heading description

    tr = dtr_fastener_metric_bolts_iso_4014b;
    tc = dtc_fastener_metric_bolts_iso_4014b;

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
