//! [metric/washers] Standard flat washer, wider outer diameter; ISO 7093; DIN 9021.
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

    \amu_define group_name  (ISO 7093)
    \amu_define group_brief ([metric/washers] Standard flat washer, wider outer diameter; ISO 7093; DIN 9021.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
  \amu_text parent (${parent}_Metric_Washers)
*******************************************************************************/

//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_include (include/amu/includes_required.amu)

  \details

    \amu_copy (files="diagrams/washer_flat.svg" types="html,latex")
    \amu_text
    (
    \image html ${PATH_NAME}/diagrams/washer_flat.svg "parameters"
    \image latex ${PATH_NAME}/diagrams/washer_flat.svg "parameters"
    )

    \amu_define output_scad     (false)
    \amu_define output_console  (false)

    \amu_define title           (Standard flat washer, wider outer diameter)
    \amu_define notes_table     ()

    \amu_include (include/amu/scope_table.amu)

    \note The measurements in the table above are shown with:
          \c length_unit_base="mm". These measurements will
          convert when the base units are changed. See \ref units_length
          for more information on setting the base units.

    | References:     |
    |:----------------|
    | ISO 7093        |
    | DIN 9021        |
    | [fasteners.eu]  |

    [fasteners.eu]: https://www.fasteners.eu/standards/ISO/7093/
*******************************************************************************/

//! <map> ISO 7093 data table columns map.
//! \hideinitializer
dtc_fastener_metric_washers_iso_7093 =
[
  ["ns", "nominal size"],
  ["id_max", "internal diameter"],
  ["id_min", "internal diameter"],
  ["od_max", "outside diameter"],
  ["od_min", "outside diameter"],
  ["t_max", "thickness"],
  ["t_min", "thickness"]
];

//! \<table> ISO 7093 data table rows.
//! \hideinitializer
dtr_fastener_metric_washers_iso_7093 =
[
  [  "3",l_mm( 3.38),l_mm( 3.2),l_mm(   9),l_mm(  8.64),l_mm(0.9),l_mm(0.7)],
  ["3.5",l_mm( 3.88),l_mm( 3.7),l_mm(  11),l_mm( 10.57),l_mm(0.9),l_mm(0.7)],
  [  "4",l_mm( 4.48),l_mm( 4.3),l_mm(  12),l_mm( 11.57),l_mm(1.1),l_mm(0.9)],
  [  "5",l_mm( 5.48),l_mm( 5.3),l_mm(  15),l_mm( 14.57),l_mm(1.4),l_mm(1.0)],
  [  "6",l_mm( 6.62),l_mm( 6.4),l_mm(  18),l_mm( 17.57),l_mm(1.8),l_mm(1.4)],
  [  "8",l_mm( 8.62),l_mm( 8.4),l_mm(  24),l_mm( 23.48),l_mm(2.2),l_mm(1.8)],
  [ "10",l_mm(10.77),l_mm(10.5),l_mm(  30),l_mm( 29.48),l_mm(2.7),l_mm(2.3)],
  [ "12",l_mm(13.27),l_mm(13.0),l_mm(  37),l_mm( 36.38),l_mm(3.3),l_mm(2.7)],
  [ "14",l_mm(15.27),l_mm(15.0),l_mm(  44),l_mm( 43.38),l_mm(3.3),l_mm(2.7)],
  [ "16",l_mm(17.27),l_mm(17.0),l_mm(  50),l_mm( 49.38),l_mm(3.3),l_mm(2.7)],
  [ "20",l_mm(22.52),l_mm(22.0),l_mm(  60),l_mm( 58.10),l_mm(4.6),l_mm(3.4)],
  [ "24",l_mm(26.84),l_mm(26.0),l_mm(  72),l_mm( 70.10),l_mm(6.0),l_mm(4.0)],
  [ "30",l_mm(34.00),l_mm(33.0),l_mm(  92),l_mm( 89.80),l_mm(7.0),l_mm(5.0)],
  [ "36",l_mm(40.00),l_mm(39.0),l_mm( 110),l_mm(107.80),l_mm(9.2),l_mm(6.8)]
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
    include <database/component/fastener/iso_7093.scad>;

    // temporary override for table presentation.
    // function l_mm(v) = round_s(length(v,"mm"), 4);

    length_unit_base = "mm";

    n  = true;                // number
    hi = true;                // include heading id
    ht = true;                // include heading description

    tr = dtr_fastener_metric_washers_iso_7093;
    tc = dtc_fastener_metric_washers_iso_7093;

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
