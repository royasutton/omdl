//! Module: Mechanical bearing specifications.
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

    \amu_define group_name  (Bearing)
    \amu_define group_brief (Mechanical bearing specifications.)

  \amu_include (include/amu/pgid_pparent_path_n.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// subgroups (1 level).
//----------------------------------------------------------------------------//

/***************************************************************************//**
  /+

    NOTE: each word group identifier should be capitalized.

  +/

  /+ define level1 groups +/

  \amu_define groups_level1
  (
    Linear
    Radial
  )

  /+ remove newlines from identifiers +/

  \amu_replace groups_level1 (text="${groups_level1}" search="\n" replace=", ")

  /+ expand level1 groups +/

  \amu_define new_line
  (
  )

  \amu_foreach defgroup_level1
  (
    words=${groups_level1} separator="${new_line}"
    text="\defgroup ${group}_\${x} \${x}"
  )
*******************************************************************************/

/***************************************************************************//**
  /+ instantiate level1 groups +/

  \amu_text
  (
  ${defgroup_level1}
  )
*******************************************************************************/

//----------------------------------------------------------------------------//

/***************************************************************************//**
  \addtogroup \amu_eval(${group})

  \details

    General information on mechanical bearings is available at [wikipedia].

  [wikipedia]: https://en.wikipedia.org/wiki/Bearing_(mechanical)
*******************************************************************************/

//! @}
//! @}


//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
