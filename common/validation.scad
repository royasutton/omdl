//! Methods for validating the results of functions.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2015-2024

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
  \amu_include (include/amu/includes_required.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// common
//----------------------------------------------------------------------------//

//! Value signature assignment for log-value results table to skip a test.
validation_skip = [number_min, number_max, number_inf];

//! Compare a computed test value with an known good result.
/***************************************************************************//**
  \param    d <string> A description.
  \param    cv \<value> A computed value to validate.
  \param    t <string | boolean> The validation type.
  \param    ev \<value> The expected good value.

  \param    p <number> A numerical precision for approximate comparisons.

  \param    pf <boolean> Report result as pass or fail boolean value.

  \returns  <string | boolean> Validation result indicating if the test
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
            comparison is performed by the function almost_eq().

    \amu_define title (Validate function)
    \amu_define scope_id (example_validate)
    \amu_include (include/amu/scope.amu)
*******************************************************************************/
function validate
(
  d,
  cv,
  t,
  ev,
  p = 4,
  pf = false
) = ( (t == "eq") || (t == "equals") ) ?
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
      almost_eq(cv, ev, p)
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

//! Output text \p t to the test log.
/***************************************************************************//**
  \param    t <string> A message to output to log.
*******************************************************************************/
module validate_log( t ) { log_type ( "omdl_test", t ); }

//! Output that function named \p fn has been skipped to the test log.
/***************************************************************************//**
  \param    fn <string> The name of the skipped function.
*******************************************************************************/
module validate_skip( fn ) { validate_log ( str("ignore: '", fn, "'") ); }

//----------------------------------------------------------------------------//
// validation tables
//----------------------------------------------------------------------------//

//! Create data structure for related table validation functions.
/***************************************************************************//**
  \param    tr \<table> The test data table rows.
  \param    gr \<table> The expected result data table rows.

  \returns  <datastruct> A structure used with the related table
            validation functions.
*******************************************************************************/
function table_validate_init
(
  tr,
  gr
) = let
    (
      ids = table_get_row_ids( tr )
    )
    [
      tr,                                                             // db[0] test row
      [["id","identifier"],["td","description"],["vl","value-list"]], // db[1] test data columns
      gr,                                                             // db[2] good result row
      merge_p([concat("id",ids),concat("identifier",ids)])            // db[3] good result columns
    ];

//! Encode an entry for test table.
/***************************************************************************//**
  \param    id <string> The test identifier.
  \param    td <string> The test description.
  \param    v1 <value> The test argument value 1.
  \param    v2 <value> The test argument value 1.
  \param    v3 <value> The test argument value 1.

  \returns  <datastruct> An test table entry.
*******************************************************************************/
function table_validate_fmt
(
  id,
  td,
  v1,
  v2,
  v3
) = !is_undef(v2) && !is_undef(v3) ?  [id, td, [v1, v2, v3]]
  : !is_undef(v2) ?                   [id, td, [v1, v2]]
  :                                   [id, td, [v1]];

//! Return a list of test identifiers in \p db.
/***************************************************************************//**
  \param    db <datastruct> An initialized validation table data structure.

  \returns  <list> A list of test identifiers.
*******************************************************************************/
function table_validate_get_ids( db ) = table_get_row_ids( db[0] );

//! Return the expected value.
/***************************************************************************//**
  \param    db <datastruct> An initialized validation table data structure.
  \param    fn <string> The function name.
  \param    id <string> The test identifier.

  \returns  <value> The expect value.
*******************************************************************************/
function table_validate_get_ev( db, fn, id ) = table_get_value(db[2], db[3], fn, id);

//! Return the test description.
/***************************************************************************//**
  \param    db <datastruct> An initialized validation table data structure.
  \param    id <string> The test identifier.

  \returns  <value> The test description.
*******************************************************************************/
function table_validate_get_td( db, id ) = table_get_value(db[0], db[1], id, "td");

//! Return the test argument value 1.
/***************************************************************************//**
  \param    db <datastruct> An initialized validation table data structure.
  \param    id <string> The test identifier.

  \returns  <value> The test argument value 1.
*******************************************************************************/
function table_validate_get_v1( db, id ) = first(table_get_value(db[0], db[1], id, "vl"));

//! Return the test argument value 2.
/***************************************************************************//**
  \param    db <datastruct> An initialized validation table data structure.
  \param    id <string> The test identifier.

  \returns  <value> The test argument value 2.
*******************************************************************************/
function table_validate_get_v2( db, id ) = second(table_get_value(db[0], db[1], id, "vl"));

//! Return the test argument value 3.
/***************************************************************************//**
  \param    db <datastruct> An initialized validation table data structure.
  \param    id <string> The test identifier.

  \returns  <value> The test argument value 3.
*******************************************************************************/
function table_validate_get_v3( db, id ) = third(table_get_value(db[0], db[1], id, "vl"));

//! Test data structure \p db and output the start of test to the test log.
/***************************************************************************//**
  \param    db <datastruct> An initialized validation table data structure.
  \param    verbose <boolean> Be more verbose.
*******************************************************************************/
module table_validate_start( db, verbose=false )
{
  if ( verbose )
    validate_log( "checking data structure" );

  // check test table
  table_check( db[0], db[1], verbose );

  // check expected result table
  table_check( db[2], db[3], verbose );

  validate_log( str("openscad version ", version()) );
}

//! Validate and log a test function return value against its expected value.
/***************************************************************************//**
  \param    db <datastruct> An initialized validation table data structure.
  \param    id <string> The test identifier.
  \param    fn <string> The function name.
  \param    argc <integer> The number of arguments to retrieve from \p db.
  \param    fr <value> The value returned from the tested function.
  \param    t <string | boolean> The validation type.
  \param    p <number> A numerical precision for approximate comparisons.

  \details

    See function validate() for more information on possible values for
    parameters \p t and \p p.

    \amu_define title (Table-based validation)
    \amu_define scope_id (example_table)
    \amu_include (include/amu/scope.amu)
*******************************************************************************/
module table_validate
(
  db,
  id,
  fn,
  argc,
  fr,
  t="equals",
  p=6
)
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

//----------------------------------------------------------------------------//
// validation maps
//----------------------------------------------------------------------------//

//! Create data structure for related map validation functions.
/***************************************************************************//**
  \param    m <map> The test data map.
  \param    fn <string> The function name.

  \returns  <datastruct> A structure used with the related map
            validation functions.
*******************************************************************************/
function map_validate_init
(
  m,
  fn
) =
  [
    m,    // db[0] test map
    fn    // db[1] function name
  ];

//! Encode an entry for test map.
/***************************************************************************//**
  \param    id <string> The test identifier.
  \param    td <string> The test description.
  \param    ev <value> The test expect value.
  \param    v1 <value> The test argument value 1.
  \param    v2 <value> The test argument value 1.
  \param    v3 <value> The test argument value 1.

  \returns  <datastruct> An test map entry.
*******************************************************************************/
function map_validate_fmt
(
  id,
  td,
  ev,
  v1,
  v2,
  v3
) = !is_undef(v2) && !is_undef(v3) ?  [id, [td, ev, [v1, v2, v3]]]
  : !is_undef(v2) ?                   [id, [td, ev, [v1, v2]]]
  :                                   [id, [td, ev, [v1]]];

//! Return a list of test identifiers in \p db.
/***************************************************************************//**
  \param    db <datastruct> An initialized validation map data structure.

  \returns  <list> A list of test identifiers.
*******************************************************************************/
function map_validate_get_ids( db ) = map_get_keys(db[0]);


//! Return the test function name.
/***************************************************************************//**
  \param    db <datastruct> An initialized validation map data structure.

  \returns  <string> The test function name.
*******************************************************************************/
function map_validate_get_fn( db ) = db[1];

//! Return the test description.
/***************************************************************************//**
  \param    db <datastruct> An initialized validation map data structure.
  \param    id <string> The test identifier.

  \returns  <string> The test description for a given test \p id.
*******************************************************************************/
function map_validate_get_td( db, id ) = map_get_value(db[0], id)[0];

//! Return the expected value.
/***************************************************************************//**
  \param    db <datastruct> An initialized validation map data structure.
  \param    id <string> The test identifier.

  \returns  <value> The expect value.
*******************************************************************************/
function map_validate_get_ev( db, id ) = map_get_value(db[0], id)[1];

//! Return the test argument value 1.
/***************************************************************************//**
  \param    db <datastruct> An initialized validation map data structure.
  \param    id <string> The test identifier.

  \returns  <value> The argument value 1.
*******************************************************************************/
function map_validate_get_v1( db, id ) = first(map_get_value(db[0], id)[2]);

//! Return the test argument value 2.
/***************************************************************************//**
  \param    db <datastruct> An initialized validation map data structure.
  \param    id <string> The test identifier.

  \returns  <value> The argument value 2.
*******************************************************************************/
function map_validate_get_v2( db, id ) = second(map_get_value(db[0], id)[2]);

//! Return the test argument value 3.
/***************************************************************************//**
  \param    db <datastruct> An initialized validation map data structure.
  \param    id <string> The test identifier.

  \returns  <value> The argument value 3.
*******************************************************************************/
function map_validate_get_v3( db, id ) = third(map_get_value(db[0], id)[2]);

//! Test data structure \p db and output the start of test to the test log.
/***************************************************************************//**
  \param    db <datastruct> An initialized validation map data structure.
  \param    verbose <boolean> Be more verbose.
*******************************************************************************/
module map_validate_start( db, verbose=false )
{
  if ( verbose )
    validate_log( "checking data structure" );

  // check map
  map_check( db[0], verbose );

  validate_log( str("openscad version ", version()) );
  validate_log( str(map_validate_get_fn(db), "()") );
}

//! Validate and log a test function return value against its expected value.
/***************************************************************************//**
  \param    db <datastruct> An initialized validation map data structure.
  \param    id <string> The test identifier.
  \param    argc <integer> The number of arguments to retrieve from \p db.
  \param    fr <value> The value returned from the tested function.
  \param    t <string | boolean> The validation type.
  \param    p <number> A numerical precision for approximate comparisons.

  \details

    See function validate() for more information on possible values for
    parameters \p t and \p p.

    \amu_define title (Map-based validation)
    \amu_define scope_id (example_map)
    \amu_include (include/amu/scope.amu)
*******************************************************************************/
module map_validate
(
  db,
  id,
  argc,
  fr,
  t="equals",
  p=6
)
{
  fn = map_validate_get_fn(db);

  td = map_validate_get_td(db, id);
  ev = map_validate_get_ev(db, id);

  if ( ev != validation_skip )
  {
    vd = (argc == 3) ? str(fn, "(", map_validate_get_v1(db, id),
                               ",", map_validate_get_v2(db, id),
                               ",", map_validate_get_v3(db, id), ")=", ev)
       : (argc == 2) ? str(fn, "(", map_validate_get_v1(db, id),
                               ",", map_validate_get_v2(db, id), ")=", ev)
       : (argc == 1) ? str(fn, "(", map_validate_get_v1(db, id), ")=", ev)
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

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE example_validate;
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

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_term}.mfs;
    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;

BEGIN_SCOPE example_table;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <common/validation.scad>;

    function fmt( id, td, v1, v2, v3 ) = table_validate_fmt(id, td, v1, v2, v3);
    function v1(db, id) = table_validate_get_v1(db, id);
    t = true; f = false; u = undef; s = validation_skip;

    // table: test values
    tbl_test_values =
    [
      fmt("t01", "The undefined value",        undef),
      fmt("t02", "A small decimal (epsilon)",  eps),
      fmt("t03", "The max number",             number_max),
      fmt("t04", "The invalid number nan",     0 / 0),
      fmt("t05", "The boolean true",           true),
      fmt("t06", "A string",                   "This is a longer string"),
      fmt("t07", "The empty string",           empty_str),
      fmt("t08", "The empty list",             empty_lst),
      fmt("t09", "A list of lists",            [[1,2,3], [4,5,6], [7,8,9]]),
      fmt("t10", "A range",                    [0:0.5:9])
    ];

    // table: expected results: use 's' to skip
    tbl_test_answers =
    [ // function       01 02 03 04 05 06 07 08 09 101
      ["is_bool",       f, f, f, f, f, f, f, f, f, t],
      ["is_string",     f, f, f, f, f, f, f, f, f, f],
      ["is_list",       f, f, f, f, f, f, f, f, f, f]
    ];

    db = table_validate_init( tbl_test_values, tbl_test_answers );

    table_validate_start( db );
    test_ids = table_validate_get_ids( db );

    for (id=test_ids) table_validate( db, id,   "is_bool", 1,   is_bool( v1(db, id) ) );
    for (id=test_ids) table_validate( db, id, "is_string", 1, is_string( v1(db, id) ) );
    for (id=test_ids) table_validate( db, id,   "is_list", 1,   is_list( v1(db, id) ) );

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_term}.mfs;
    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;

BEGIN_SCOPE example_map;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <common/validation.scad>;

    function fmt( id, td, ev, v1, v2, v3 ) = map_validate_fmt(id, td, ev, v1, v2, v3);
    function v1( db, id ) = map_validate_get_v1(db, id);
    function v2( db, id ) = map_validate_get_v2(db, id);

    map_test_defined_or =
    [
      fmt("t01", "Undefined", 1, undef, 1),
      fmt("t02", "A small value", eps, eps, 2),
      fmt("t03", "Infinity", number_inf, number_inf, 3),
      fmt("t04", "Max number", number_max, number_max, 4),
      fmt("t05", "Undefined list", [undef], [undef], 5),
      fmt("t06", "Short range", [0:9], [0:9], 6),
      fmt("t07", "Empty string", empty_str, empty_str, 7),
      fmt("t08", "Empty list", empty_lst, empty_lst, 8)
    ];

    db = map_validate_init( map_test_defined_or, "defined_or" );
    map_validate_start( db );

    for ( id = map_validate_get_ids( db ) )
      map_validate( db, id, 2, defined_or ( v1(db, id), v2(db, id) ) );

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_term}.mfs;
    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
