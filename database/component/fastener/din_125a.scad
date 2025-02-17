//! [metric/washers] Flat washers; DIN 125A; ISO 7089.
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

    \amu_define group_name  (DIN 125A)
    \amu_define group_brief ([metric/washers] Flat washers; DIN 125A; ISO 7089.)

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

    \amu_define title           (Flat washers)
    \amu_define notes_table     (The A in 125A denotes that this washer is not chamfered.)

    \amu_include (include/amu/scope_table.amu)

    \note The measurements in the table above are shown with:
          \c length_unit_base="mm". These measurements will
          convert when the base units are changed. See \ref units_length
          for more information on setting the base units.

    | References:     |
    |:----------------|
    | DIN 125A        |
    | ISO 7089        |
    | [fasteners.eu]  |

    [fasteners.eu]: https://www.fasteners.eu/standards/DIN/125-A
*******************************************************************************/

//! <map> DIN 125A data table columns map.
//! \hideinitializer
dtc_fastener_metric_washers_din_125a =
[
  ["ns", "nominal size"],
  ["id_max", "internal diameter"],
  ["id_min", "internal diameter"],
  ["od_max", "outside diameter"],
  ["od_min", "outside diameter"],
  ["t_max", "thickness"],
  ["t_min", "thickness"]
];

//! \<table> DIN 125A data table rows.
//! \hideinitializer
dtr_fastener_metric_washers_din_125a =
[
  [  "3",l_mm( 3.38),l_mm( 3.2),l_mm(  7),l_mm( 6.64),l_mm(0.55),l_mm(0.45)],
  ["3.5",l_mm( 3.88),l_mm( 3.7),l_mm(  8),l_mm( 7.64),l_mm(0.55),l_mm(0.45)],
  [  "4",l_mm( 4.48),l_mm( 4.3),l_mm(  9),l_mm( 8.64),l_mm(0.90),l_mm(0.70)],
  [  "5",l_mm( 5.48),l_mm( 5.3),l_mm( 10),l_mm( 9.64),l_mm(1.10),l_mm(0.90)],
  [  "6",l_mm( 6.62),l_mm( 6.4),l_mm( 12),l_mm(11.57),l_mm(1.80),l_mm(1.40)],
  [  "8",l_mm( 8.62),l_mm( 8.4),l_mm( 16),l_mm(15.57),l_mm(1.80),l_mm(1.40)],
  [ "10",l_mm(10.77),l_mm(10.5),l_mm( 20),l_mm(19.48),l_mm(2.20),l_mm(1.80)],
  [ "12",l_mm(13.27),l_mm(13.0),l_mm( 24),l_mm(23.48),l_mm(2.70),l_mm(2.30)],
  [ "16",l_mm(17.27),l_mm(17.0),l_mm( 30),l_mm(29.48),l_mm(3.30),l_mm(2.70)],
  [ "20",l_mm(21.33),l_mm(21.0),l_mm( 37),l_mm(36.38),l_mm(3.30),l_mm(2.70)]
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
    include <database/component/fastener/din_125a.scad>;

    // temporary override for table presentation.
    // function l_mm(v) = round_s(length(v,"mm"), 4);

    length_unit_base = "mm";

    n  = true;                // number
    hi = true;                // include heading id
    ht = true;                // include heading description

    tr = dtr_fastener_metric_washers_din_125a;
    tc = dtc_fastener_metric_washers_din_125a;

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
