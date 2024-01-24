//! Mechanical fastener specifications.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2018-2023

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

    \amu_define group_name  (Fastener)
    \amu_define group_brief (Mechanical fastener specifications.)

  \amu_include (include/amu/pgid_pparent_path_n.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// subgroups.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  /+

    NOTE: each word of a class name or subgroup should be capitalized.

  +/

  /+ define fastener class subgroups +/

  \amu_define class_subgroups
  (
    Bolts
    Screws
    Nuts
    Washers
  )

  /+ remove newline from each identifiers +/

  \amu_replace class_subgroups (text="${class_subgroups}" search="\n" replace=", ")

  /+ expand subgroups and classes +/

  \amu_define new_line
  (
  )

  \amu_define class (Imperial)
  \amu_foreach defgroup_subgroups_imperial
  (
    words=${class_subgroups} separator="${new_line}"
    text="\defgroup ${group}_${class}_\${x} \${x}"
  )

  \amu_define class (Metric)
  \amu_foreach defgroup_subgroups_metric
  (
    words=${class_subgroups} separator="${new_line}"
    text="\defgroup ${group}_${class}_\${x} \${x}"
  )
*******************************************************************************/

/***************************************************************************//**
  /+ instantiate classes and subgroups +/

  \amu_if (true)
  {
    \defgroup ${group}_Imperial   Imperial
    @{
    ${defgroup_subgroups_imperial}
    @}

    \defgroup ${group}_Metric     Metric
    @{
    ${defgroup_subgroups_metric}
    @}
  }
  endif
*******************************************************************************/

//! @}
//! @}


//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
