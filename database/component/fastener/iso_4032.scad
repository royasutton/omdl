//! [metric/nuts] Hexagon nuts style 1; ISO 4032; DIN EN ISO.
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

    \amu_define group_name  (ISO 4032)
    \amu_define group_brief ([metric/nuts] Hexagon nuts style 1; ISO 4032; DIN EN ISO.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
  \amu_if parent (true) {${parent}_Metric_Nuts} endif
*******************************************************************************/

//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_include (include/amu/includes_required.amu)

  \details

    \amu_define output_scad     (false)
    \amu_define output_console  (false)

    \amu_define title           (Hexagon nuts style 1)
    \amu_define notes_table     ()

    \amu_include (include/amu/scope_table.amu)

    \note The measurements in the table above are shown with:
          \c length_unit_base="mm". These measurements will
          convert when the base units are changed. See \ref units_length
          for more information on setting the base units.

    | References:  |
    |:-------------|
    | ISO 4032     |
    | DIN EN ISO   |
    | [ISO 4032]   |

    [ISO 4032]: https://www.iso.org/standard/75016.html
*******************************************************************************/

//! <map> ISO 4032 fastener data table columns map.
//! \hideinitializer
dtc_fastener_metric_nuts_iso_4032 =
[
  ["id", "identifier"],
  ["tp", "thread pitch"],
  ["f_max", "width across flats"],
  ["f_min", "width across flats"],
  ["g_min", "width across corners"],
  ["h_hax", "thickness"],
  ["h_min", "thickness"]
];

//! \<table> ISO 4032 fastener data table rows.
//! \hideinitializer
dtr_fastener_metric_nuts_iso_4032 =
[
  ["M1.6",0.35/l_mm(1),l_mm( 3.20),l_mm( 3.02),l_mm(  3.41),l_mm( 1.30),l_mm( 1.05)],
  [  "M2",0.40/l_mm(1),l_mm( 4.00),l_mm( 3.82),l_mm(  4.32),l_mm( 1.60),l_mm( 1.35)],
  ["M2.5",0.45/l_mm(1),l_mm( 5.00),l_mm( 4.82),l_mm(  5.45),l_mm( 2.00),l_mm( 1.75)],
  [  "M3",0.50/l_mm(1),l_mm( 5.50),l_mm( 5.32),l_mm(  6.01),l_mm( 2.40),l_mm( 2.15)],
  [  "M4",0.70/l_mm(1),l_mm( 7.00),l_mm( 6.78),l_mm(  7.66),l_mm( 3.20),l_mm( 2.90)],
  [  "M5",0.80/l_mm(1),l_mm( 8.00),l_mm( 7.78),l_mm(  8.79),l_mm( 4.70),l_mm( 4.40)],
  [  "M6",1.00/l_mm(1),l_mm(10.00),l_mm( 9.78),l_mm( 11.05),l_mm( 5.20),l_mm( 4.90)],
  [  "M8",1.25/l_mm(1),l_mm(13.00),l_mm(12.73),l_mm( 14.38),l_mm( 6.80),l_mm( 6.44)],
  [ "M10",1.50/l_mm(1),l_mm(16.00),l_mm(15.73),l_mm( 17.77),l_mm( 8.40),l_mm( 8.04)],
  [ "M12",1.75/l_mm(1),l_mm(18.00),l_mm(17.73),l_mm( 20.03),l_mm(10.80),l_mm(10.37)],
  [ "M14",2.00/l_mm(1),l_mm(21.00),l_mm(20.67),l_mm( 23.35),l_mm(12.80),l_mm(12.10)],
  [ "M16",2.00/l_mm(1),l_mm(24.00),l_mm(23.67),l_mm( 26.75),l_mm(14.80),l_mm(14.10)],
  [ "M20",2.50/l_mm(1),l_mm(30.00),l_mm(29.16),l_mm( 32.95),l_mm(18.00),l_mm(16.90)],
  [ "M24",3.00/l_mm(1),l_mm(36.00),l_mm(35.00),l_mm( 39.55),l_mm(21.50),l_mm(20.20)],
  [ "M30",3.50/l_mm(1),l_mm(46.00),l_mm(45.00),l_mm( 50.85),l_mm(25.60),l_mm(24.30)],
  [ "M36",4.00/l_mm(1),l_mm(55.00),l_mm(53.80),l_mm( 60.79),l_mm(31.00),l_mm(29.40)],
  [ "M42",4.50/l_mm(1),l_mm(65.00),l_mm(63.10),l_mm( 71.30),l_mm(34.00),l_mm(32.40)],
  [ "M48",5.00/l_mm(1),l_mm(75.00),l_mm(73.10),l_mm( 82.60),l_mm(38.00),l_mm(36.40)],
  [ "M56",5.50/l_mm(1),l_mm(85.00),l_mm(82.80),l_mm( 93.56),l_mm(45.00),l_mm(43.40)],
  [ "M64",6.00/l_mm(1),l_mm(95.00),l_mm(92.80),l_mm(104.86),l_mm(51.00),l_mm(49.10)]
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
    include <database/component/fastener/iso_4032.scad>;

    // temporary override for table presentation.
    // function l_mm(v) = round_s(length(v,"mm"), 4);

    length_unit_base = "mm";

    n  = true;                // number
    hi = true;                // include heading id
    ht = true;                // include heading description

    tr = dtr_fastener_metric_nuts_iso_4032;
    tc = dtc_fastener_metric_nuts_iso_4032;

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
