//! [metric/screws] Flat head socket cap screws; ANSI B18.3.5M; ASME.
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

    \amu_define group_name  (ANSI B18.3.5M)
    \amu_define group_brief ([metric/screws] Flat head socket cap screws; ANSI B18.3.5M; ASME.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
  \amu_text parent (${parent}_Metric_Screws)
*******************************************************************************/

//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_include (include/amu/includes_required.amu)

  \details

    \amu_copy (files="diagrams/screw_socket_hex_flat.svg" types="html,latex")
    \amu_text
    (
    \image html ${PATH_NAME}/diagrams/screw_socket_hex_flat.svg "parameters"
    \image latex ${PATH_NAME}/diagrams/screw_socket_hex_flat.svg "parameters"
    )

    \amu_define output_scad     (false)
    \amu_define output_console  (false)

    \amu_define title           (Flat head socket cap screws)
    \amu_define notes_table     ()

    \amu_include (include/amu/scope_table.amu)

    \note The measurements in the table above are shown with:
          \c length_unit_base="mm". These measurements will
          convert when the base units are changed. See \ref units_length
          for more information on setting the base units.

    | References:                |
    |:---------------------------|
    | ANSI B18.3.5M              |
    | ASME                       |
    | [ANSI/ASME B18.3.5M-1986]  |

    [ANSI/ASME B18.3.5M-1986]: https://webstore.ansi.org/standards/asme/ansiasmeb185m1986r2002
*******************************************************************************/

//! <map> ANSI B18.3.5M data table columns map.
//! \hideinitializer
dtc_fastener_metric_screws_ansi_b18_3_5m =
[
  ["ns", "nominal size"],
  ["tp", "thread pitch"],
  ["b_max", "body diameter"],
  ["b_min", "body diameter"],
  ["a_max", "head diameter"],
  ["a_min", "head diameter"],
  ["h_ref", "head height"],
  ["h_tol", "head height"],
  ["j_nom", "hex socket size"],
  ["t_min", "key engagement"],
  ["w_min", "wall thickness"],
  ["d_max", "drill allowance"]
];

//! \<table> ANSI B18.3.5M data table rows.
//! \hideinitializer
dtr_fastener_metric_screws_ansi_b18_3_5m =
[
  [ "M3",l_mm(0.50),l_mm( 3.00),l_mm(2.86),l_mm( 6.72),l_mm( 5.35),l_mm(1.86),l_mm(0.30),l_mm(2.0),l_mm(1.1),l_mm(0.25),l_mm(0.3)],
  [ "M4",l_mm(0.70),l_mm( 4.00),l_mm(3.82),l_mm( 8.96),l_mm( 7.80),l_mm(2.48),l_mm(0.30),l_mm(2.5),l_mm(1.5),l_mm(0.45),l_mm(0.4)],
  [ "M5",l_mm(0.80),l_mm( 5.00),l_mm(4.82),l_mm(11.20),l_mm( 9.75),l_mm(3.10),l_mm(0.35),l_mm(3.0),l_mm(1.9),l_mm(0.66),l_mm(0.5)],
  [ "M6",l_mm(1.00),l_mm( 6.00),l_mm(5.82),l_mm(13.44),l_mm(11.70),l_mm(3.72),l_mm(0.35),l_mm(4.0),l_mm(2.2),l_mm(0.70),l_mm(0.6)],
  [ "M8",l_mm(1.25),l_mm( 8.00),l_mm(7.78),l_mm(17.92),l_mm(15.60),l_mm(4.96),l_mm(0.40),l_mm(5.0),l_mm(3.0),l_mm(1.16),l_mm(0.8)],
  ["M10",l_mm(1.50),l_mm(10.00),l_mm(9.78),l_mm(22.40),l_mm(19.50),l_mm(6.20),l_mm(0.50),l_mm(6.0),l_mm(3.6),l_mm(1.62),l_mm(0.9)]
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
    include <database/component/fastener/ansi_b18_3_5m.scad>;

    // temporary override for table presentation.
    // function l_mm(v) = round_s(length(v,"mm"), 4);

    length_unit_base = "mm";

    n  = true;                // number
    hi = true;                // include heading id
    ht = true;                // include heading description

    tr = dtr_fastener_metric_screws_ansi_b18_3_5m;
    tc = dtc_fastener_metric_screws_ansi_b18_3_5m;

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
