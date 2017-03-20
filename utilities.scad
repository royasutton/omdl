//! Miscellaneous utilities.
/***************************************************************************//**
  \file   utilities.scad
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

  \ingroup utilities
*******************************************************************************/

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \ingroup utilities
  @{
*******************************************************************************/
//----------------------------------------------------------------------------//

//! Format the function call stack as a string.
/***************************************************************************//**
  \param    b <integer> The stack index bottom offset.
            Include function names above this offset.
  \param    t <integer> The stack index top offset.
            Include function names below this offset.

  \returns  <string> A colon-separated list of functions names for the
            current function call stack.

  \note     Returns \b undef when \p b is greater than the current number
            of function instances (ie: <tt>bo > $parent_modules-1</tt>).
  \note     Returns the string \c "root()" when the function call stack
            is empty (ie: at the root of the script).
*******************************************************************************/
function stack
(
  b = 0,
  t = 0
) = let
  (
    bo = abs(b),
    to = abs(t),
    i = $parent_modules - 1 - bo
  )
  ($parent_modules == undef) ? "root()"
  : (bo > $parent_modules-1) ? undef
  : (i  < to) ? "root()"
  : (i == to) ? str( parent_module( i ), "()" )
  : str( parent_module( i ), "(): ", stack( bo + 1, to ) );

//! @}

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
