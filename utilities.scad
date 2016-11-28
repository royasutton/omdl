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
  \param    idx_b <decimal> The instantiation stack beginning level.
  \param    idx_e <decimal> The instantiation stack ending level.
*******************************************************************************/
function stack
(
  idx_b = $parent_modules -1,
  idx_e = 0
) = idx_b == undef ? "<top-level>"
  : idx_b >  idx_e ? str( parent_module( idx_b ), "(): ", stack( idx_b - 1, idx_e ) )
  :                  str( parent_module( idx_b ), "()" );

//! @}

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
