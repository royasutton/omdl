//! [bearing] Radial ball bearing; radial_ball; rbb.
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

    \amu_define group_name  (radial_ball)
    \amu_define group_brief ([bearing] Radial ball bearing; radial_ball; rbb.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
  \amu_text parent (${parent}_Bearing)
*******************************************************************************/

//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_include (include/amu/includes_required.amu)

  \details

    \amu_copy (files="diagrams/radial_ball.svg" types="html,latex")
    \amu_text
    (
    \image html ${PATH_NAME}/diagrams/radial_ball.svg "parameters"
    \image latex ${PATH_NAME}/diagrams/radial_ball.svg "parameters"
    )

    \amu_define output_scad     (false)
    \amu_define output_console  (false)

    \amu_define title           (Radial ball bearing)
    \amu_define notes_table     ()

    \amu_include (include/amu/scope_table.amu)

    \note The measurements in the table above are shown with:
          \c length_unit_base="mm". These measurements will
          convert when the base units are changed. See \ref units_length
          for more information on setting the base units.

    | References:  |
    |:-------------|
    | radial_ball  |
    | rbb          |
    | [RepRap]     |
    | [Wikipedia]  |

    [RepRap]: https://reprap.org/wiki/Ball_bearing
    [Wikipedia]: https://en.wikipedia.org/wiki/Rolling-element_bearing
*******************************************************************************/

//! <map> radial_ball data table columns map.
//! \hideinitializer
dtc_motion_bearing_radial_ball =
[
  ["n", "model number"],
  ["id", "inscribed circle"],
  ["od", "outer diameter"],
  ["b", "outer width"]
];

//! \<table> radial_ball data table rows.
//! \hideinitializer
dtr_motion_bearing_radial_ball =
[
  [ "601x",l_mm( 1.5),l_mm(   6),l_mm( 3.0)],
  ["601xo",l_mm( 1.5),l_mm(   6),l_mm( 2.5)],
  [  "602",l_mm( 2.0),l_mm(   7),l_mm( 3.5)],
  [ "602o",l_mm( 2.0),l_mm(   7),l_mm( 2.8)],
  [ "602x",l_mm( 2.5),l_mm(   8),l_mm( 4.0)],
  ["602xo",l_mm( 2.5),l_mm(   8),l_mm( 2.8)],
  [  "603",l_mm( 3.0),l_mm(   9),l_mm( 5.0)],
  [ "603o",l_mm( 3.0),l_mm(   9),l_mm( 3.0)],
  [  "604",l_mm( 4.0),l_mm(  12),l_mm( 4.0)],
  [  "605",l_mm( 5.0),l_mm(  14),l_mm( 5.0)],
  [  "606",l_mm( 6.0),l_mm(  17),l_mm( 6.0)],
  [  "607",l_mm( 7.0),l_mm(  19),l_mm( 6.0)],
  [  "608",l_mm( 8.0),l_mm(  22),l_mm( 7.0)],
  [  "609",l_mm( 9.0),l_mm(  24),l_mm( 7.0)],
  [  "625",l_mm( 5.0),l_mm(  16),l_mm( 5.0)],
  [  "626",l_mm( 6.0),l_mm(  19),l_mm( 6.0)],
  [  "627",l_mm( 7.0),l_mm(  22),l_mm( 7.0)],
  [  "628",l_mm( 8.0),l_mm(  24),l_mm( 8.0)],
  [  "629",l_mm( 9.0),l_mm(  26),l_mm( 8.0)],
  [  "688",l_mm( 8.0),l_mm(  16),l_mm( 4.0)],
  [  "697",l_mm( 7.0),l_mm(  17),l_mm( 5.0)],
  [ "6000",l_mm(10.0),l_mm(  26),l_mm( 8.0)],
  [ "6001",l_mm(12.0),l_mm(  28),l_mm( 8.0)],
  [ "6002",l_mm(15.0),l_mm(  32),l_mm( 9.0)],
  [ "6003",l_mm(17.0),l_mm(  35),l_mm(10.0)],
  [ "6004",l_mm(20.0),l_mm(  42),l_mm(12.0)],
  [ "6005",l_mm(25.0),l_mm(  47),l_mm(12.0)],
  [ "6006",l_mm(30.0),l_mm(  55),l_mm(13.0)],
  [ "6007",l_mm(35.0),l_mm(  62),l_mm(14.0)],
  [ "6008",l_mm(40.0),l_mm(  68),l_mm(15.0)],
  [ "6009",l_mm(45.0),l_mm(  75),l_mm(16.0)],
  [ "6010",l_mm(50.0),l_mm(  80),l_mm(16.0)],
  [ "6011",l_mm(55.0),l_mm(  90),l_mm(18.0)],
  [ "6012",l_mm(60.0),l_mm(  95),l_mm(18.0)],
  [ "6013",l_mm(65.0),l_mm( 100),l_mm(18.0)],
  [ "6200",l_mm(10.0),l_mm(  30),l_mm( 9.0)],
  [ "6201",l_mm(12.0),l_mm(  32),l_mm(10.0)],
  [ "6202",l_mm(15.0),l_mm(  35),l_mm(11.0)],
  [ "6203",l_mm(17.0),l_mm(  40),l_mm(12.0)],
  [ "6204",l_mm(20.0),l_mm(  47),l_mm(14.0)],
  [ "6205",l_mm(25.0),l_mm(  52),l_mm(15.0)],
  [ "6206",l_mm(30.0),l_mm(  62),l_mm(16.0)],
  [ "6207",l_mm(35.0),l_mm(  72),l_mm(17.0)],
  [ "6208",l_mm(40.0),l_mm(  80),l_mm(18.0)],
  [ "6209",l_mm(45.0),l_mm(  85),l_mm(19.0)],
  [ "6210",l_mm(50.0),l_mm(  90),l_mm(20.0)],
  [ "6300",l_mm(10.0),l_mm(  35),l_mm(11.0)],
  [ "6301",l_mm(12.0),l_mm(  37),l_mm(12.0)],
  [ "6302",l_mm(15.0),l_mm(  42),l_mm(13.0)],
  [ "6900",l_mm(10.0),l_mm(  22),l_mm( 6.0)]
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
    include <database/component/motion/bearing_radial_ball.scad>;

    // temporary override for table presentation.
    // function l_mm(v) = round_s(length(v,"mm"), 4);

    length_unit_base = "mm";

    n  = true;                // number
    hi = true;                // include heading id
    ht = true;                // include heading description

    tr = dtr_motion_bearing_radial_ball;
    tc = dtc_motion_bearing_radial_ball;

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
