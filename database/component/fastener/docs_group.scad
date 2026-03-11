//! Module: Mechanical fastener specifications.
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
// subgroups (2 levels).
//----------------------------------------------------------------------------//

/***************************************************************************//**
  /+

    NOTE: each word group identifier should be capitalized.

  +/

  /+ define level2 groups +/

  \amu_define groups_level2
  (
    Bolts
    Screws
    Nuts
    Washers
  )

  /+ remove newlines from identifiers +/

  \amu_replace groups_level2 (text="${groups_level2}" search="\n" replace=", ")

  /+ expand level2 groups +/

  \amu_define new_line
  (
  )

  \amu_define groups_level1 (Imperial)
  \amu_foreach defgroup_imperial
  (
    words=${groups_level2} separator="${new_line}"
    text="\defgroup ${group}_${groups_level1}_\${x} \${x}"
  )

  \amu_define groups_level1 (Metric)
  \amu_foreach defgroup_metric
  (
    words=${groups_level2} separator="${new_line}"
    text="\defgroup ${group}_${groups_level1}_\${x} \${x}"
  )
*******************************************************************************/

/***************************************************************************//**
  /+ instantiate level2 groups +/

  \amu_text
  (
    \defgroup ${group}_Imperial   Imperial
    @{
    ${defgroup_imperial}
    @}

    \defgroup ${group}_Metric     Metric
    @{
    ${defgroup_metric}
    @}
  )
*******************************************************************************/

//----------------------------------------------------------------------------//

/***************************************************************************//**
  \addtogroup \amu_eval(${group})

  \details

    General information on fastener is available at [wikipedia].

  [wikipedia]: https://en.wikipedia.org/wiki/Fastener
*******************************************************************************/

//! @}
//! @}


//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
