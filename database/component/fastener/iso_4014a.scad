//! [metric/bolts] Hexagon head bolt a; ISO 4014a; DIN 931.
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

    \amu_define group_name  (ISO 4014a)
    \amu_define group_brief ([metric/bolts] Hexagon head bolt a; ISO 4014a; DIN 931.)

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

    \amu_define title           (Hexagon head bolt a)
    \amu_define notes_table     (r_1 for [L<125mm]; r_2 for [L>125mm & L<200mm])

    \amu_include (include/amu/scope_table.amu)

    \note The measurements in the table above are shown with:
          \c length_unit_base="mm". These measurements will
          convert when the base units are changed. See \ref units_length
          for more information on setting the base units.

    | References:     |
    |:----------------|
    | ISO 4014a       |
    | DIN 931         |
    | [ISO 4014]      |
    | [fasteners.eu]  |

    [ISO 4014]: https://www.iso.org/standard/56447.html
    [fasteners.eu]: https://www.fasteners.eu/standards/ISO/4014/
*******************************************************************************/

//! <map> ISO 4014a data table columns map.
//! \hideinitializer
dtc_fastener_metric_bolts_iso_4014a =
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

//! \<table> ISO 4014a data table rows.
//! \hideinitializer
dtr_fastener_metric_bolts_iso_4014a =
[
  ["M1.6",l_mm(0.35),l_mm(  9),      undef,l_mm(0.25),l_mm(0.10),l_mm( 2.0),l_mm(0.6),l_mm( 2.27),l_mm( 1.225),l_mm( 0.975),l_mm( 3.2),l_mm( 3.02),l_mm( 3.41),l_mm( 0.68)],
  [  "M2",l_mm(0.40),l_mm( 10),      undef,l_mm(0.25),l_mm(0.10),l_mm( 2.6),l_mm(0.8),l_mm( 3.07),l_mm( 1.525),l_mm( 1.275),l_mm( 4.0),l_mm( 3.82),l_mm( 4.32),l_mm( 0.89)],
  ["M2.5",l_mm(0.45),l_mm( 11),      undef,l_mm(0.25),l_mm(0.10),l_mm( 3.1),l_mm(1.0),l_mm( 4.07),l_mm( 1.825),l_mm( 1.575),l_mm( 5.0),l_mm( 4.82),l_mm( 5.45),l_mm( 1.10)],
  [  "M3",l_mm(0.50),l_mm( 12),      undef,l_mm(0.40),l_mm(0.15),l_mm( 3.6),l_mm(1.0),l_mm( 4.57),l_mm( 2.125),l_mm( 1.875),l_mm( 5.5),l_mm( 5.32),l_mm( 6.01),l_mm( 1.31)],
  [  "M4",l_mm(0.70),l_mm( 14),      undef,l_mm(0.40),l_mm(0.15),l_mm( 4.7),l_mm(1.2),l_mm( 5.88),l_mm( 2.925),l_mm( 2.675),l_mm( 7.0),l_mm( 6.78),l_mm( 7.66),l_mm( 1.87)],
  [  "M5",l_mm(0.80),l_mm( 16),      undef,l_mm(0.50),l_mm(0.15),l_mm( 5.7),l_mm(1.2),l_mm( 6.88),l_mm( 3.650),l_mm( 3.350),l_mm( 8.0),l_mm( 7.78),l_mm( 8.79),l_mm( 2.35)],
  [  "M6",l_mm(1.00),l_mm( 18),      undef,l_mm(0.50),l_mm(0.15),l_mm( 6.8),l_mm(1.4),l_mm( 8.88),l_mm( 4.150),l_mm( 3.850),l_mm(10.0),l_mm( 9.78),l_mm(11.05),l_mm( 2.70)],
  [  "M8",l_mm(1.25),l_mm( 22),      undef,l_mm(0.60),l_mm(0.15),l_mm( 9.2),l_mm(2.0),l_mm(11.63),l_mm( 5.450),l_mm( 5.150),l_mm(13.0),l_mm(12.73),l_mm(14.38),l_mm( 3.61)],
  [ "M10",l_mm(1.50),l_mm( 26),      undef,l_mm(0.60),l_mm(0.15),l_mm(11.2),l_mm(2.0),l_mm(14.63),l_mm( 6.580),l_mm( 6.220),l_mm(16.0),l_mm(15.73),l_mm(17.77),l_mm( 4.35)],
  [ "M12",l_mm(1.75),l_mm( 30),      undef,l_mm(0.60),l_mm(0.15),l_mm(13.7),l_mm(3.0),l_mm(16.63),l_mm( 7.680),l_mm( 7.320),l_mm(18.0),l_mm(17.73),l_mm(20.03),l_mm( 5.12)],
  [ "M14",l_mm(2.00),l_mm( 34),l_mm(   40),l_mm(0.60),l_mm(0.15),l_mm(15.7),l_mm(3.0),l_mm(19.37),l_mm( 8.980),l_mm( 8.620),l_mm(21.0),l_mm(20.67),l_mm(23.36),l_mm( 6.03)],
  [ "M16",l_mm(2.00),l_mm( 38),l_mm(   44),l_mm(0.80),l_mm(0.20),l_mm(17.7),l_mm(3.0),l_mm(22.49),l_mm(10.180),l_mm( 9.820),l_mm(24.0),l_mm(23.67),l_mm(26.75),l_mm( 6.87)],
  [ "M20",l_mm(2.50),l_mm( 46),l_mm(   52),l_mm(0.80),l_mm(0.20),l_mm(22.4),l_mm(4.0),l_mm(28.19),l_mm(12.715),l_mm(12.285),l_mm(30.0),l_mm(29.67),l_mm(33.53),l_mm( 8.60)],
  [ "M24",l_mm(3.00),l_mm( 54),l_mm(   60),l_mm(0.80),l_mm(0.20),l_mm(26.4),l_mm(4.0),l_mm(33.61),l_mm(15.215),l_mm(14.785),l_mm(36.0),l_mm(35.38),l_mm(39.98),l_mm(10.35)]
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
    include <database/component/fastener/iso_4014a.scad>;

    // temporary override for table presentation.
    // function l_mm(v) = round_s(length(v,"mm"), 4);

    length_unit_base = "mm";

    n  = true;                // number
    hi = true;                // include heading id
    ht = true;                // include heading description

    tr = dtr_fastener_metric_bolts_iso_4014a;
    tc = dtc_fastener_metric_bolts_iso_4014a;

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
