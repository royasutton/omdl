//! [metric/screws] Socket cap screws; ISO 4762; DIN 912.
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

    \amu_define group_name  (ISO 4762)
    \amu_define group_brief ([metric/screws] Socket cap screws; ISO 4762; DIN 912.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
  \amu_text parent (${parent}_Metric_Screws)
*******************************************************************************/

//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_include (include/amu/includes_required.amu)

  \details

    \amu_copy (files="diagrams/screw_socket_hex.svg" types="html,latex")
    \amu_text
    (
    \image html ${PATH_NAME}/diagrams/screw_socket_hex.svg "parameters"
    \image latex ${PATH_NAME}/diagrams/screw_socket_hex.svg "parameters"
    )

    \amu_define output_scad     (false)
    \amu_define output_console  (false)

    \amu_define title           (Socket cap screws)
    \amu_define notes_table     ()

    \amu_include (include/amu/scope_table.amu)

    \note The measurements in the table above are shown with:
          \c length_unit_base="mm". These measurements will
          convert when the base units are changed. See \ref units_length
          for more information on setting the base units.

    | References:     |
    |:----------------|
    | ISO 4762        |
    | DIN 912         |
    | [ISO 4762]      |
    | [fasteners.eu]  |

    [ISO 4762]: https://www.iso.org/standard/34460.html
    [fasteners.eu]: https://www.fasteners.eu/standards/ISO/4762/
*******************************************************************************/

//! <map> ISO 4762 data table columns map.
//! \hideinitializer
dtc_fastener_metric_screws_iso_4762 =
[
  ["ns", "nominal size"],
  ["tp", "thread pitch"],
  ["d_max", "body diameter"],
  ["d_min", "body diameter"],
  ["h_max", "head diameter"],
  ["h_min", "head diameter"],
  ["k_max", "head height"],
  ["k_min", "head height"],
  ["c_max", "top chamfer or radius"],
  ["f_max", "fillet transition diameter"],
  ["s_max", "socket size across the flats"],
  ["s_min", "socket size across the flats"],
  ["e_min", "socket size across the corners"],
  ["t_min", "key engagement"],
  ["w_min", "wall thickness"]
];

//! \<table> ISO 4762 data table rows.
//! \hideinitializer
dtr_fastener_metric_screws_iso_4762 =
[
  ["M1.6",l_mm(0.35),l_mm( 1.60),l_mm( 1.46),l_mm( 3.14),l_mm( 2.86),l_mm( 1.60),l_mm( 1.46),l_mm(0.16),l_mm( 2.0),l_mm( 1.545),l_mm( 1.520),l_mm( 1.73),l_mm( 0.7),l_mm( 0.55)],
  [  "M2",l_mm(0.40),l_mm( 2.00),l_mm( 1.86),l_mm( 3.98),l_mm( 3.62),l_mm( 2.00),l_mm( 1.86),l_mm(0.20),l_mm( 2.6),l_mm( 1.545),l_mm( 1.520),l_mm( 1.73),l_mm( 1.0),l_mm( 0.55)],
  ["M2.5",l_mm(0.45),l_mm( 2.50),l_mm( 2.36),l_mm( 4.68),l_mm( 4.32),l_mm( 2.50),l_mm( 2.36),l_mm(0.25),l_mm( 3.1),l_mm( 2.045),l_mm( 2.020),l_mm( 2.30),l_mm( 1.1),l_mm( 0.85)],
  [  "M3",l_mm(0.50),l_mm( 3.00),l_mm( 2.86),l_mm( 5.68),l_mm( 5.32),l_mm( 3.00),l_mm( 2.86),l_mm(0.30),l_mm( 3.6),l_mm( 2.560),l_mm( 2.520),l_mm( 2.87),l_mm( 1.3),l_mm( 1.15)],
  [  "M4",l_mm(0.70),l_mm( 4.00),l_mm( 3.82),l_mm( 7.22),l_mm( 6.78),l_mm( 4.00),l_mm( 3.82),l_mm(0.40),l_mm( 4.7),l_mm( 3.071),l_mm( 3.020),l_mm( 3.44),l_mm( 2.0),l_mm( 1.40)],
  [  "M5",l_mm(0.80),l_mm( 5.00),l_mm( 4.82),l_mm( 8.72),l_mm( 8.28),l_mm( 5.00),l_mm( 4.82),l_mm(0.50),l_mm( 5.7),l_mm( 4.084),l_mm( 4.020),l_mm( 4.58),l_mm( 2.5),l_mm( 1.90)],
  [  "M6",l_mm(1.00),l_mm( 6.00),l_mm( 5.82),l_mm(10.22),l_mm( 9.78),l_mm( 6.00),l_mm( 5.70),l_mm(0.60),l_mm( 6.8),l_mm( 5.084),l_mm( 5.020),l_mm( 5.72),l_mm( 3.0),l_mm( 2.30)],
  [  "M8",l_mm(1.25),l_mm( 8.00),l_mm( 7.78),l_mm(13.27),l_mm(12.73),l_mm( 8.00),l_mm( 7.64),l_mm(0.80),l_mm( 9.2),l_mm( 6.095),l_mm( 6.020),l_mm( 6.86),l_mm( 4.0),l_mm( 3.30)],
  [ "M10",l_mm(1.50),l_mm(10.00),l_mm( 9.78),l_mm(16.27),l_mm(15.73),l_mm(10.00),l_mm( 9.64),l_mm(1.00),l_mm(11.2),l_mm( 8.115),l_mm( 8.025),l_mm( 9.15),l_mm( 5.0),l_mm( 4.00)],
  [ "M12",l_mm(1.75),l_mm(12.00),l_mm(11.73),l_mm(18.27),l_mm(17.73),l_mm(12.00),l_mm(11.57),l_mm(1.20),l_mm(13.7),l_mm(10.115),l_mm(10.025),l_mm(11.43),l_mm( 6.0),l_mm( 4.80)],
  [ "M16",l_mm(2.00),l_mm(16.00),l_mm(15.73),l_mm(24.33),l_mm(23.67),l_mm(16.00),l_mm(15.57),l_mm(1.60),l_mm(17.7),l_mm(14.142),l_mm(14.032),l_mm(16.00),l_mm( 8.0),l_mm( 6.80)],
  [ "M20",l_mm(2.50),l_mm(20.00),l_mm(19.67),l_mm(30.33),l_mm(29.67),l_mm(20.00),l_mm(19.48),l_mm(2.00),l_mm(22.4),l_mm(17.230),l_mm(17.050),l_mm(19.44),l_mm(10.0),l_mm( 8.60)],
  [ "M24",l_mm(3.00),l_mm(24.00),l_mm(23.67),l_mm(36.39),l_mm(35.61),l_mm(24.00),l_mm(23.48),l_mm(2.40),l_mm(26.4),l_mm(19.275),l_mm(19.065),l_mm(21.73),l_mm(12.0),l_mm(10.40)],
  [ "M30",l_mm(3.50),l_mm(30.00),l_mm(29.67),l_mm(45.39),l_mm(44.61),l_mm(30.00),l_mm(29.48),l_mm(3.00),l_mm(33.4),l_mm(22.275),l_mm(22.065),l_mm(25.15),l_mm(15.5),l_mm(13.10)],
  [ "M36",l_mm(4.00),l_mm(36.00),l_mm(35.61),l_mm(54.46),l_mm(53.54),l_mm(36.00),l_mm(35.38),l_mm(3.60),l_mm(39.4),l_mm(27.275),l_mm(27.065),l_mm(30.85),l_mm(19.0),l_mm(15.30)],
  [ "M42",l_mm(4.50),l_mm(42.00),l_mm(41.61),l_mm(63.46),l_mm(62.54),l_mm(42.00),l_mm(41.38),l_mm(4.20),l_mm(45.6),l_mm(32.330),l_mm(32.080),l_mm(36.57),l_mm(24.0),l_mm(16.30)],
  [ "M48",l_mm(5.00),l_mm(48.00),l_mm(47.61),l_mm(72.46),l_mm(71.54),l_mm(48.00),l_mm(47.38),l_mm(4.80),l_mm(52.6),l_mm(36.330),l_mm(36.080),l_mm(41.13),l_mm(28.0),l_mm(17.50)],
  [ "M56",l_mm(5.50),l_mm(56.00),l_mm(55.54),l_mm(84.54),l_mm(83.46),l_mm(56.00),l_mm(55.26),l_mm(5.60),l_mm(63.0),l_mm(41.330),l_mm(41.080),l_mm(46.83),l_mm(34.0),l_mm(19.00)],
  [ "M64",l_mm(6.00),l_mm(64.00),l_mm(63.54),l_mm(96.54),l_mm(95.46),l_mm(64.00),l_mm(63.26),l_mm(6.40),l_mm(71.0),l_mm(46.330),l_mm(46.080),l_mm(52.53),l_mm(38.0),l_mm(22.00)]
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
    include <database/component/fastener/iso_4762.scad>;

    // temporary override for table presentation.
    // function l_mm(v) = round_s(length(v,"mm"), 4);

    length_unit_base = "mm";

    n  = true;                // number
    hi = true;                // include heading id
    ht = true;                // include heading description

    tr = dtr_fastener_metric_screws_iso_4762;
    tc = dtc_fastener_metric_screws_iso_4762;

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
