//! Data type identification and operations.
/***************************************************************************//**
  \file   datatypes.scad
  \author Roy Allen Sutton
  \date   2015-2017

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

  \note Include this library file using the \b include statement.

  \ingroup datatypes datatypes_identify datatypes_operate
*******************************************************************************/

include <constants.scad>;

include <datatypes/datatypes_identify_scalar.scad>;
include <datatypes/datatypes_identify_iterable.scad>;
include <datatypes/datatypes_identify_list.scad>;

include <datatypes/datatypes_operate_scalar.scad>;
include <datatypes/datatypes_operate_iterable.scad>;
include <datatypes/datatypes_operate_list.scad>;

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \page tv_datatypes Datatypes
    \li \subpage tv_datatypes_identify
    \li \subpage tv_datatypes_operate
*******************************************************************************/

/***************************************************************************//**
  \page tv_datatypes_identify Identification
    \li \subpage tv_datatypes_identify_scalar
    \li \subpage tv_datatypes_identify_iterable
    \li \subpage tv_datatypes_identify_list
*******************************************************************************/

/***************************************************************************//**
  \page tv_datatypes_operate Operations
    \li \subpage tv_datatypes_operate_scalar
    \li \subpage tv_datatypes_operate_iterable
    \li \subpage tv_datatypes_operate_list
*******************************************************************************/
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \addtogroup datatypes
  @{

  \defgroup datatypes_identify Identification
  \brief    Compile-time data type identification and tests.

  \defgroup datatypes_operate Operations
  \brief    Data type operation.

  @}
*******************************************************************************/
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
