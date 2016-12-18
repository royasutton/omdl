//! Miscellaneous utilities.
/***************************************************************************//**
  \file   utilities.scad
  \author Roy Allen Sutton
  \date   2015-2016

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

  \ingroup utilities
*******************************************************************************/

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \ingroup utilities
  @{
*******************************************************************************/
//----------------------------------------------------------------------------//

//! Format the current instantiation stack as a string.
/***************************************************************************//**
  \param    b <decimal> The instantiation stack beginning level.
  \param    e <decimal> The instantiation stack ending level.
*******************************************************************************/
function stack
(
  b = $parent_modules -1,
  e = 0
) = (b == undef) ? "<top-level>"
  : (b > e) ? str( parent_module( b ), "(): ", stack( b-1, e ) )
  : str( parent_module( b ), "()" );

//! @}

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
