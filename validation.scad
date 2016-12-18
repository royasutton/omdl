//! Result validation functions.
/***************************************************************************//**
  \file   validation.scad
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

//! Compare a computed value with an expected result.
/***************************************************************************//**
  \param    d <string> A validation description.
  \param    cv <value> A computed value to validate.
  \param    t <string|boolean> The validation type.
  \param    ev <value> The expected result value.

  \param    pf <boolean> Result reported as pass or fail boolean value.

  \returns  <string|boolean> Validation comparison result indicating
            if the test passed or failed.

  \details

     validation types   | pass if (else fail)
    :------------------:|:----------------------------:
     "eq"               | cv equal ev
     "neq"              | cv not equal to ev
     "true" \| true     | cv is true
     "false" \| false   | cv is false

*******************************************************************************/
function validate
(
  d,
  cv,
  t,
  ev,
  pf = false
)
  = (t == "eq") ?
    (
      (cv == ev)
      ? (pf?true  : str("passed: '", d, "'."))
      : (pf?false : str("FAILED: '", d, "'.  Got '", cv, "'. Expected to equal '", ev, "'."))
    )
  : (t == "neq") ?
    (
      (cv != ev)
      ? (pf?true  : str("passed: '", d, "'."))
      : (pf?false : str("FAILED: '", d, "'.  Got '", cv, "'. Expected to not equal '", ev, "'."))
    )
  : ( (t == true)  || (t == "true")  ) ? validate(d, cv, "eq", true, pf)
  : ( (t == false) || (t == "false") ) ? validate(d, cv, "eq", false, pf)
  : (pf?false : str("FAILED: '", d, "'.  Unknown test '", t, "'."));

//! @}

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
