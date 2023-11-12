//! Data Types Module documentation.
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

  \amu_include (include/amu/pgid_pparent_path_n.amu)

    \amu_define group_name  (Data Types)
    \amu_define group_brief (Data type identification, operators, and structures.)

      \amu_define group1        (${group}_identify)
      \amu_define group1_name   (Type Identification)
      \amu_define group1_brief  (Base data type identification.)

      \amu_define group2        (${group}_operate)
      \amu_define group2_name   (Type Operators)
      \amu_define group2_brief  (Base data type operators.)

      \amu_define group3        (${group}_structure)
      \amu_define group3_name   (Structures)
      \amu_define group3_brief  (Data structures and operators.)

*******************************************************************************/

//----------------------------------------------------------------------------//
// validation.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \page tv_tree
    \li \subpage tv_\amu_eval(${group})

  \page tv_\amu_eval(${group} ${group_name})
    \li \subpage tv_\amu_eval(${group1})

    \li \subpage tv_\amu_eval(${group2})

  \page tv_\amu_eval(${group1} ${group1_name})

  \page tv_\amu_eval(${group2} ${group2_name})
*******************************************************************************/

//----------------------------------------------------------------------------//
// group.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_start.amu)

    See \ref dt for nomenclature, assumptions, and conventions used to
    specify values and data types throughout the library.

  \defgroup \amu_eval(${group1} ${group1_name})
  \brief    \amu_eval(${group1_brief})

  \defgroup \amu_eval(${group2} ${group2_name})
  \brief    \amu_eval(${group2_brief})

  \defgroup \amu_eval(${group3} ${group3_name})
  \brief    \amu_eval(${group3_brief})

  @}
*******************************************************************************/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
