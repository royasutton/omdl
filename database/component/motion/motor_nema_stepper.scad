//! [motor] Nema stepper motor; nema_stepper; stepper motor.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2025

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

    \amu_define group_name  (nema_stepper)
    \amu_define group_brief ([motor] Nema stepper motor; nema_stepper; stepper motor.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
  \amu_text parent (${parent}_Motor)
*******************************************************************************/

//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_include (include/amu/includes_required.amu)

  \details

    \amu_copy (files="diagrams/nema_stepper.svg" types="html,latex")
    \amu_text
    (
    \image html ${PATH_NAME}/diagrams/nema_stepper.svg "parameters"
    \image latex ${PATH_NAME}/diagrams/nema_stepper.svg "parameters"
    )

    <center>Smaller motor bolt holes have metric threas.</center>

    \amu_define output_scad     (false)
    \amu_define output_console  (false)

    \amu_define title           (Nema stepper motor)
    \amu_define notes_table     (<center>Approximate and typical values differ across manufacturers and models.</center>)

    \amu_include (include/amu/scope_table.amu)

    \note The measurements in the table above are shown with:
          \c length_unit_base="mm". These measurements will
          convert when the base units are changed. See \ref units_length
          for more information on setting the base units.

    | References:    |
    |:---------------|
    | nema_stepper   |
    | stepper motor  |
    | [Wikipedia]    |
    | [RepRap]       |

    [Wikipedia]: https://en.wikipedia.org/wiki/Stepper_motor
    [RepRap]: https://reprap.org/wiki/NEMA_17_Stepper_motor
*******************************************************************************/

//! <map> nema_stepper data table columns map.
//! \hideinitializer
dtc_motion_motor_nema_stepper =
[
  ["id", "identifier"],
  ["s", "Frame size (approximate)"],
  ["m", "Bolt hole distance"],
  ["t", "Bolt hole thread"],
  ["h", "Bolt hole diameter"],
  ["d", "Motor shaft diameter (typical)"],
  ["p", "Pilot diameter"],
  ["e", "Piolet depth (typical)"]
];

//! \<table> nema_stepper data table rows.
//! \hideinitializer
dtr_motion_motor_nema_stepper =
[
  [ "nema_8",l_mm( 20.0),l_mm(16.0),   "m2",      undef,l_mm( 4.00),l_mm(16.00),l_mm(1.6)],
  ["nema_11",l_mm( 28.2),l_mm(23.0), "m2.5",      undef,l_mm( 5.00),l_mm(22.00),l_mm(1.6)],
  ["nema_14",l_mm( 35.2),l_mm(26.0),   "m3",      undef,l_mm( 5.00),l_mm(22.00),l_mm(2.0)],
  ["nema_17",l_mm( 42.3),l_mm(31.0),   "m3",      undef,l_mm( 5.00),l_mm(22.00),l_mm(2.0)],
  ["nema_23",l_mm( 56.4),l_mm(47.1),  undef,l_mm(  5.5),l_mm( 6.35),l_mm(38.10),l_mm(1.6)],
  ["nema_34",l_mm( 86.0),l_mm(69.6),  undef,l_mm(  5.5),l_mm(14.00),l_mm(73.00),l_mm(1.6)],
  ["nema_42",l_mm(110.0),l_mm(89.0),  undef,l_mm(  8.5),l_mm(19.00),l_mm(55.52),l_mm(3.0)]
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
    include <database/component/motion/motor_nema_stepper.scad>;

    // temporary override for table presentation.
    // function l_mm(v) = round_s(length(v,"mm"), 4);

    length_unit_base = "mm";

    n  = true;                // number
    hi = true;                // include heading id
    ht = true;                // include heading description

    tr = dtr_motion_motor_nema_stepper;
    tc = dtc_motion_motor_nema_stepper;

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
