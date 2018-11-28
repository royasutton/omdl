//! Module documentation.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2018

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

    \amu_pathid parent      (++path_parent)
    \amu_pathid group       (++path)

    \amu_define group_name  (Datatypes)
    \amu_define group_brief (Data types and operators.)

      \amu_define group1        (${group}_identify)
      \amu_define group1_name   (Identification)
      \amu_define group1_brief  (Basic data type tests.)

      \amu_define group2        (${group}_operate)
      \amu_define group2_name   (Operations)
      \amu_define group2_brief  (Basic data type operations.)

*******************************************************************************/

//----------------------------------------------------------------------------//
// validation.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \page tv_details
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
  \defgroup \amu_eval(${group} ${group_name})
  \brief    \amu_eval(${group_brief})
  @{

    See \ref dt for nomenclature, assumptions, and conventions used to
    specify values and data types throughout the library.

  \defgroup \amu_eval(${group1} ${group1_name})
  \brief    \amu_eval(${group1_brief})

  \defgroup \amu_eval(${group2} ${group2_name})
  \brief    \amu_eval(${group2_brief})

  @}
*******************************************************************************/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
