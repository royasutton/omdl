//! [metric/washers] Standard flat washer, wider inner diameter; ISO 7091; DIN 126.
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

    \amu_define group_name  (ISO 7091)
    \amu_define group_brief ([metric/washers] Standard flat washer, wider inner diameter; ISO 7091; DIN 126.)

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

    \amu_define title           (Standard flat washer, wider inner diameter)
    \amu_define notes_table     ()

    \amu_include (include/amu/scope_table.amu)

    \note The measurements in the table above are shown with:
          \c length_unit_base="mm". These measurements will
          convert when the base units are changed. See \ref units_length
          for more information on setting the base units.

    | References:     |
    |:----------------|
    | ISO 7091        |
    | DIN 126         |
    | [fasteners.eu]  |

    [fasteners.eu]: https://www.fasteners.eu/standards/ISO/7091/
*******************************************************************************/

//! <map> ISO 7091 data table columns map.
//! \hideinitializer
dtc_fastener_metric_washers_iso_7091 =
[
  ["ns", "nominal size"],
  ["id_max", "internal diameter"],
  ["id_min", "internal diameter"],
  ["od_max", "outside diameter"],
  ["od_min", "outside diameter"],
  ["t_max", "thickness"],
  ["t_min", "thickness"]
];

//! \<table> ISO 7091 data table rows.
//! \hideinitializer
dtr_fastener_metric_washers_iso_7091 =
[
  [ "5",l_mm( 5.80),l_mm( 5.5),l_mm( 10),l_mm( 9.1),l_mm(1.2),l_mm(0.8)],
  [ "6",l_mm( 6.96),l_mm( 6.6),l_mm( 12),l_mm(10.9),l_mm(1.9),l_mm(1.3)],
  [ "8",l_mm( 9.36),l_mm( 9.0),l_mm( 16),l_mm(14.9),l_mm(1.9),l_mm(1.3)],
  ["10",l_mm(11.43),l_mm(11.0),l_mm( 20),l_mm(18.7),l_mm(2.3),l_mm(1.7)],
  ["12",l_mm(13.93),l_mm(13.5),l_mm( 24),l_mm(22.7),l_mm(2.8),l_mm(2.2)],
  ["14",l_mm(15.93),l_mm(15.5),l_mm( 28),l_mm(26.7),l_mm(2.8),l_mm(2.2)],
  ["16",l_mm(17.93),l_mm(17.5),l_mm( 30),l_mm(28.7),l_mm(3.6),l_mm(2.4)],
  ["20",l_mm(22.52),l_mm(22.0),l_mm( 37),l_mm(35.4),l_mm(3.6),l_mm(2.4)],
  ["24",l_mm(26.52),l_mm(26.0),l_mm( 44),l_mm(42.4),l_mm(4.6),l_mm(3.4)],
  ["30",l_mm(33.62),l_mm(33.0),l_mm( 56),l_mm(54.1),l_mm(4.6),l_mm(3.4)],
  ["36",l_mm(40.00),l_mm(39.0),l_mm( 66),l_mm(64.1),l_mm(6.0),l_mm(4.0)]
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
    include <database/component/fastener/iso_7091.scad>;

    // temporary override for table presentation.
    // function l_mm(v) = round_s(length(v,"mm"), 4);

    length_unit_base = "mm";

    n  = true;                // number
    hi = true;                // include heading id
    ht = true;                // include heading description

    tr = dtr_fastener_metric_washers_iso_7091;
    tc = dtc_fastener_metric_washers_iso_7091;

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
