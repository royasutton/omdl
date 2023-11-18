//! Methods for validating the results of functions.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2015-2023

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

    \amu_define group_name  (Validation Functions)
    \amu_define group_brief (Run-time test and validation functions.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)

  \details

    \b Example

      \dontinclude \amu_scope(index=1).scad
      \skip include
      \until tvae2, 4) );

    \b Result \include \amu_scope(index=1).log
*******************************************************************************/

//----------------------------------------------------------------------------//

//! <value> Value assignment for expected results table to skip a test.
validation_skip = number_inf;

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

     validation types             | pass if (else fail)
    :----------------------------:|:----------------------------:
     "ae" \| "almost"             | \p cv almost equals \p ev
     "eq" \| "equals"             | \p cv equals \p ev
     "ne" \|    "not"             | \p cv not equal to \p ev
      "t" \|   "true" \| \b true  | \p cv is \b true
      "f" \|  "false" \| \b false | \p cv is \b false

  \note     When performing an \b "almost" equal validation, the
            comparison precision is controlled by \p p. This specifies
            the number of digits of precision for each numerical
            comparison. A passing result indicates that \p cv equals
            \p ev to the number of decimal digits specified by \p p. The
            comparison is performed by the function almost_equal_av().
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
  = ( (t == "eq") || (t == "equals") ) ?
    (
      (cv == ev)
      ? (pf?true  : str("PASSED: '", d, "'"))
      : (pf?false : str
                    (
                      "FAILED: '", d, "'; got '", cv,
                      "', expected to equal '", ev, "'."
                    )
        )
    )
  : ( (t == "ne") || (t == "not") ) ?
    (
      (cv != ev)
      ? (pf?true  : str("PASSED: '", d, "'"))
      : (pf?false : str
                    (
                      "FAILED: '", d, "'; got '", cv,
                      "', expected to not equal '", ev, "'."
                    )
        )
    )
  : ( (t == true) || (t == "true") || (t == "t") ) ? validate(d, cv, "equals", true, p, pf)
  : ( (t == false) || (t == "false") || (t == "f") ) ? validate(d, cv, "equals", false, p, pf)
  : ( (t == "ae") || (t == "almost") ) ?
    (
      almost_equal_av(cv, ev, p)
      ? (pf?true  : str("PASSED: '", d, "'"))
      : (pf?false : str
                    (
                      "FAILED: '", d, "'; got '", cv,
                      "', expected to almost equal '", ev, "'.",
                      " to ", p, " digits"
                    )
        )
    )
  : (pf?false : str("FAILED: '", d, "';  unknown test '", t, "'."));

// log
module validate_log( t ) { log_type ( "omdl_test", t ); }
module validate_skip( fn ) { validate_log ( str("ignore: '", fn, "'") ); }

//
// tables
//

function table_validate_init ( tr, gr ) =
  let(ids = table_get_row_ids( tr ))
  [
    tr,                                                               // test row
    [["id","identifier"],["td","description"],["vl","value-list"] ],  // test data columns
    gr,                                                               // good result row
    pmerge([concat("id",ids),concat("identifier",ids)])               // good result columns
  ];

function table_validate_get_ids( db ) = table_get_row_ids( db[0] );

function table_validate_get_ev( db, fn, id ) = table_get_value(db[2], db[3], fn, id);

function table_validate_get_td( db, id ) = table_get_value(db[0], db[1], id, "td");
function table_validate_get_v1( db, id ) = first(table_get_value(db[0], db[1], id, "vl"));
function table_validate_get_v2( db, id ) = second(table_get_value(db[0], db[1], id, "vl"));
function table_validate_get_v3( db, id ) = third(table_get_value(db[0], db[1], id, "vl"));

module table_validate_start( db, verbose=false )
{
  validate_log( str("openscad version ", version()) );

  table_check( db[0], db[1], verbose );   // check test table
  table_check( db[2], db[3], verbose );   // check expected result table
}

module table_validate( db, id, fn, argc, fr, t="equals", p=6 )
{
  td = table_validate_get_td(db, id);
  ev = table_validate_get_ev(db, fn, id);

  if ( ev != validation_skip )
  {
    vd = (argc == 3) ? str(fn, "(", table_validate_get_v1(db, id),
                               ",", table_validate_get_v2(db, id),
                               ",", table_validate_get_v3(db, id), ")=", ev)
       : (argc == 2) ? str(fn, "(", table_validate_get_v1(db, id),
                               ",", table_validate_get_v2(db, id), ")=", ev)
       : (argc == 1) ? str(fn, "(", table_validate_get_v1(db, id), ")=", ev)
       :               str(fn, "(*)=", ev);

    lm = validate( d=vd, cv=fr, t=t, p=p, ev=ev );

    if ( !validate( cv=fr, t=t, p=p, ev=ev, pf=true ) )
      validate_log( str(id, " ", lm, " ---> \"", td, "\"") );
    else
      validate_log( str(id, " ", lm) );
  }
  else
    validate_log( str(id, " -skip-: '", fn, "(", td, ")'") );
}

//
// maps
//

// test map structure
// [ "proto", ["function-name", argc]],
// [ "id",    ["description", passing-value, argv1, argv2, argv3] ]
function map_validate_get_name( m ) = first(map_get_value(m, "proto"));
function map_validate_get_argc( m ) = second(map_get_value(m, "proto"));

function map_validate_get_td( m, id ) = (map_get_value(m, id))[0];
function map_validate_get_ev( m, id ) = (map_get_value(m, id))[1];
function map_validate_get_v1( m, id ) = (map_get_value(m, id))[2];
function map_validate_get_v2( m, id ) = (map_get_value(m, id))[3];
function map_validate_get_v3( m, id ) = (map_get_value(m, id))[4];

module map_validate_start( m, verbose=false )
{
  validate_log( str("openscad version ", version()) );

  map_check( m, verbose );

  validate_log( str(map_validate_get_name(m), "(argc = ", map_validate_get_argc(m), ")") );
}

module map_validate( m, id, fr, t="equals", p=6 )
{
  if ( id != "proto" )
  {
    fn = map_validate_get_name(m);
    argc = map_validate_get_argc(m);

    td = map_validate_get_td(m, id);
    ev = map_validate_get_ev(m, id);
    v1 = map_validate_get_v1(m, id);
    v2 = map_validate_get_v2(m, id);

    vd = (argc == 3) ? str(fn, "(", map_validate_get_v1(m, id),
                               ",", map_validate_get_v2(m, id),
                               ",", map_validate_get_v3(m, id), ")=", ev)
       : (argc == 2) ? str(fn, "(", map_validate_get_v1(m, id),
                               ",", map_validate_get_v2(m, id), ")=", ev)
       : (argc == 1) ? str(fn, "(", map_validate_get_v1(m, id), ")=", ev)
       :               str(fn, "(*)=", ev);

    lm = validate( d=vd, cv=fr, t=t, p=p, ev=ev );

    if ( !validate( cv=fr, t=t, p=p, ev=ev, pf=true ) )
      validate_log( str(id, " ", lm, " ---> \"", td, "\"") );
    else
      validate_log( str(id, " ", lm) );
  }
}

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE example;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <common/validation.scad>;

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
    log_type( "EXAMPLE 1", "pass test example" );

    pass_result = validate("test-a f1(farg)", f1(farg), "equals", erv1);

    if ( !validate(cv=f1(farg), t="equals", ev=erv1, pf=true) )
      log_warn( pass_result );
    else
      log_info( pass_result );

    //
    // fail test example
    //
    log_type( "EXAMPLE 2", "fail test example" );

    fail_result = validate("test-b f1(farg)", f1(farg), "equals", erv2);

    if ( !validate(cv=f1(farg), t="equals", ev=erv2, pf=true) )
      log_warn( fail_result );
    else
      log_info( fail_result );

    //
    // almost equal test example
    //
    log_type( "EXAMPLE 3", "almost equal test example" );

    tvae1 = [[90.001], [[45.009], true]];
    tvae2 = [[90.002], [[45.010], true]];

    log_type( "EXAMPLE 3", "almost equal to 3 digits" );
    log_info( validate("test-c", tvae1, "almost", tvae2, 3) );

    log_type( "EXAMPLE 3", "almost equal to 4 digits" );
    log_info( validate("test-d", tvae1, "almost", tvae2, 4) );
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {config_base,config_term}.mfs;
    include --path "${INCLUDE_PATH}" script_std.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
