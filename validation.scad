//! Function validation methods.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2015-2018

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

    \amu_pathid parent  (++path)
    \amu_pathid group   (++path ++stem)

  \ingroup \amu_eval(${parent} ${group})
*******************************************************************************/

include <datatypes/datatypes-base.scad>;

//----------------------------------------------------------------------------//
// group.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \defgroup \amu_eval(${group}) Validation
  \brief    Function validation methods.

  \details

    \b Example

      \dontinclude \amu_scope(index=1).scad
      \skip include
      \until tvae2, 4) );

    \b Result \include \amu_scope(index=1).log
*******************************************************************************/

//----------------------------------------------------------------------------//

//! Compare a computed test value with an known good result.
/***************************************************************************//**
  \param    d <string> A description.
  \param    cv \<value> A computed value to validate.
  \param    t <string|boolean> The validation type.
  \param    ev \<value> The expected good value.

  \param    p <number> A numerical precision for approximate comparisons.

  \param    pf <boolean> Report result as pass or fail boolean value.

  \returns  <string|boolean> Validation result indicating if the test
            passed or failed.

  \details

     validation types     | pass if (else fail)
    :--------------------:|:----------------------------:
     "almost"             | \p cv almost equals \p ev
     "equals"             | \p cv equals \p ev
     "not"                | \p cv not equal to \p ev
     "true" \| \b true    | \p cv is \b true
     "false" \| \b false  | \p cv is \b false

  \note     When performing an \b "almost" equal validation, the
            comparison precision is controlled by \p p. This specifies
            the number of digits of precision for each numerical
            comparison. A passing result indicates that \p cv equals
            \p ev to the number of decimal digits specified by \p p. The
            comparison is performed by the function almost_equal().
*******************************************************************************/
function validate
(
  d,
  cv,
  t,
  ev,
  p = 4,
  pf = false
)
  = (t == "equals") ?
    (
      (cv == ev)
      ? (pf?true  : str("passed: '", d, "'"))
      : (pf?false : str
                    (
                      "failed: '", d, "'; got '", cv,
                      "', expected to equal '", ev, "'."
                    )
        )
    )
  : (t == "not") ?
    (
      (cv != ev)
      ? (pf?true  : str("passed: '", d, "'"))
      : (pf?false : str
                    (
                      "failed: '", d, "'; got '", cv,
                      "', expected to not equal '", ev, "'."
                    )
        )
    )
  : ( (t == true)  || (t == "true")  ) ? validate(d, cv, "equals", true, p, pf)
  : ( (t == false) || (t == "false") ) ? validate(d, cv, "equals", false, p, pf)
  :  (t == "almost") ?
    (
      almost_equal(cv, ev, p)
      ? (pf?true  : str("passed: '", d, "'"))
      : (pf?false : str
                    (
                      "failed: '", d, "'; got '", cv,
                      "', expected to almost equal '", ev, "'.",
                      " to ", p, " digits"
                    )
        )
    )
  : (pf?false : str("failed: '", d, "';  unknown test '", t, "'."));

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE example;
  BEGIN_OPENSCAD;
    include <console.scad>;
    include <validation.scad>;

    //
    // function to validate
    //
    function f1( x ) = (x == undef) ? 1 : 2;

    farg = undef;     // function test argument
    erv1 = 1;         // correct expected function result
    erv2 = 3;         // incorrect expected function result

    //
    // pass test example
    //
    pass_result = validate("test-a f1(farg)", f1(farg), "equals", erv1);

    if ( !validate(cv=f1(farg), t="equals", ev=erv1, pf=true) )
      log_warn( pass_result );
    else
      log_info( pass_result );

    //
    // fail test example
    //
    fail_result = validate("test-b f1(farg)", f1(farg), "equals", erv2);

    if ( !validate(cv=f1(farg), t="equals", ev=erv2, pf=true) )
      log_warn( fail_result );
    else
      log_info( fail_result );

    //
    // almost equal test example
    //
    tvae1 = [[90.001], [[45.009], true]];
    tvae2 = [[90.002], [[45.010], true]];

    log_info( validate("test-c", tvae1, "almost", tvae2, 3) );
    log_warn( validate("test-d", tvae1, "almost", tvae2, 4) );
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {config_base,config_csg}.mfs;
    include --path "${INCLUDE_PATH}" script_std.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
