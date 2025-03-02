//! [bearing] Linear motion bearing; linear_lmxuu; lm.
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

    \amu_define group_name  (linear_lmxuu)
    \amu_define group_brief ([bearing] Linear motion bearing; linear_lmxuu; lm.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
  \amu_text parent (${parent}_Bearing)
*******************************************************************************/

//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_include (include/amu/includes_required.amu)

  \details

    \amu_copy (files="diagrams/linear_lmxuu.svg" types="html,latex")
    \amu_text
    (
    \image html ${PATH_NAME}/diagrams/linear_lmxuu.svg "parameters"
    \image latex ${PATH_NAME}/diagrams/linear_lmxuu.svg "parameters"
    )

    \amu_define output_scad     (false)
    \amu_define output_console  (false)

    \amu_define title           (Linear motion bearing)
    \amu_define notes_table     ()

    \amu_include (include/amu/scope_table.amu)

    \note The measurements in the table above are shown with:
          \c length_unit_base="mm". These measurements will
          convert when the base units are changed. See \ref units_length
          for more information on setting the base units.

    | References:   |
    |:--------------|
    | linear_lmxuu  |
    | lm            |
    | [RepRap]      |
    | [Wikipedia]   |

    [RepRap]: https://reprap.org/wiki/Linear_bearing
    [Wikipedia]: https://en.wikipedia.org/wiki/Linear-motion_bearing
*******************************************************************************/

//! <map> linear_lmxuu data table columns map.
//! \hideinitializer
dtc_motion_bearing_linear_lmxuu =
[
  ["n", "model number"],
  ["dr", "inscribed circle"],
  ["d", "outer diameter"],
  ["l", "length"],
  ["b", "outside snap ring grove"],
  ["w", "ring grove width"],
  ["d1", "ring grove diameter"]
];

//! \<table> linear_lmxuu data table rows.
//! \hideinitializer
dtr_motion_bearing_linear_lmxuu =
[
  [  "lm3uu",l_mm(   3),l_mm(   7),l_mm(  10),l_mm(  7.3),l_mm(0.90),l_mm(  6.7)],
  [  "lm4uu",l_mm(   4),l_mm(   8),l_mm(  12),l_mm(  8.8),l_mm(0.90),l_mm(  7.6)],
  [  "lm5uu",l_mm(   5),l_mm(  10),l_mm(  15),l_mm( 10.2),l_mm(1.10),l_mm(  9.6)],
  [  "lm6uu",l_mm(   6),l_mm(  12),l_mm(  19),l_mm( 13.5),l_mm(1.10),l_mm( 11.5)],
  [ "lm8suu",l_mm(   8),l_mm(  15),l_mm(  17),l_mm( 11.5),l_mm(1.10),l_mm( 14.3)],
  [  "lm8uu",l_mm(   8),l_mm(  15),l_mm(  24),l_mm( 17.5),l_mm(1.10),l_mm( 14.3)],
  [ "lm10uu",l_mm(  10),l_mm(  19),l_mm(  29),l_mm( 22.0),l_mm(1.30),l_mm( 18.0)],
  [ "lm12uu",l_mm(  12),l_mm(  21),l_mm(  30),l_mm( 23.0),l_mm(1.30),l_mm( 20.0)],
  [ "lm13uu",l_mm(  13),l_mm(  23),l_mm(  32),l_mm( 23.0),l_mm(1.30),l_mm( 22.0)],
  [ "lm16uu",l_mm(  16),l_mm(  28),l_mm(  37),l_mm( 26.5),l_mm(1.60),l_mm( 27.0)],
  [ "lm20uu",l_mm(  20),l_mm(  32),l_mm(  42),l_mm( 30.5),l_mm(1.60),l_mm( 30.5)],
  [ "lm25uu",l_mm(  25),l_mm(  40),l_mm(  59),l_mm( 41.0),l_mm(1.85),l_mm( 38.0)],
  [ "lm30uu",l_mm(  30),l_mm(  45),l_mm(  64),l_mm( 44.5),l_mm(1.85),l_mm( 43.0)],
  [ "lm35uu",l_mm(  35),l_mm(  52),l_mm(  70),l_mm( 49.5),l_mm(2.10),l_mm( 49.0)],
  [ "lm40uu",l_mm(  40),l_mm(  60),l_mm(  80),l_mm( 60.5),l_mm(2.10),l_mm( 57.0)],
  [ "lm50uu",l_mm(  50),l_mm(  80),l_mm( 100),l_mm( 74.0),l_mm(2.60),l_mm( 76.5)],
  [ "lm60uu",l_mm(  60),l_mm(  90),l_mm( 110),l_mm( 85.0),l_mm(3.15),l_mm( 86.5)],
  [ "lm80uu",l_mm(  80),l_mm( 120),l_mm( 140),l_mm(105.5),l_mm(4.15),l_mm(116.0)],
  ["lm100uu",l_mm( 100),l_mm( 150),l_mm( 175),l_mm(125.5),l_mm(4.15),l_mm(145.0)],
  ["lm120uu",l_mm( 120),l_mm( 180),l_mm( 200),l_mm(158.5),l_mm(4.15),l_mm(175.0)],
  ["lm150uu",l_mm( 150),l_mm( 210),l_mm( 240),l_mm(170.6),l_mm(5.15),l_mm(204.0)]
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
    include <database/component/motion/bearing_linear_lmxuu.scad>;

    // temporary override for table presentation.
    // function l_mm(v) = round_s(length(v,"mm"), 4);

    length_unit_base = "mm";

    n  = true;                // number
    hi = true;                // include heading id
    ht = true;                // include heading description

    tr = dtr_motion_bearing_linear_lmxuu;
    tc = dtc_motion_bearing_linear_lmxuu;

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
