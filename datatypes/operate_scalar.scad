//! Scalar data type operations.
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

    \amu_define group_name  (Scalars)
    \amu_define group_brief (Scalar data type operations.)
    \amu_define parent_id   (operate)

  \amu_include (include/amu/pgid_path_pid_pstem_pg.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// validation.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/validate_log_th.amu)
  \amu_include (include/amu/validate_log_td.amu)
  \amu_include (include/amu/validate_results.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)

  \details

  \amu_include (include/amu/validate_summary.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//! Return a value when it is defined or a default value when it is not.
/***************************************************************************//**
  \param    v \<value> A value.
  \param    d \<value> A default value.

  \returns  \<value> \p v when it is defined and \p d otherwise.
*******************************************************************************/
function defined_or
(
  v,
  d
) = is_defined(v) ? v : d;

//! Map an index position into a circularly indexed list.
/***************************************************************************//**
  \param    i <integer> Any index, in or out of bounds.
  \param    l <integer> The circular list length.
  \param    f <integer> The starting index number.

  \returns  <integer> A index position in the circular list within the
            range <tt>[f : l+f-1]</tt>.
*******************************************************************************/
function circular_index
(
  i,
  l,
  f = 0
) = f + (((i % l) + l) % l);

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE validate;
  BEGIN_OPENSCAD;
    include <console.scad>;
    include <datatypes/datatypes-base.scad>;
    include <datatypes/table.scad>;
    include <validation.scad>;

    echo( str("openscad version ", version()) );

    // test-values columns
    test_c =
    [
      ["id", "identifier"],
      ["td", "description"],
      ["tv", "test value"]
    ];

    // test-values rows
    test_r =
    [
      ["t01", "The undefined value",        undef],
      ["t02", "The empty list",             empty_lst],
      ["t03", "A range",                    [0:0.5:9]],
      ["t04", "A string",                   "A string"],
      ["t05", "Test list 01",               ["orange","apple","grape","banana"]],
      ["t06", "Test list 02",               ["b","a","n","a","n","a","s"]],
      ["t07", "Test list 03",               [undef]],
      ["t08", "Test list 04",               [[1,2],[2,3]]],
      ["t09", "Test list 05",               ["ab",[1,2],[2,3],[4,5]]],
      ["t10", "Test list 06",               [[1,2,3],[4,5,6],[7,8,9],["a","b","c"]]],
      ["t11", "Vector of integers 0 to 15", [for (i=[0:15]) i]]
    ];

    test_ids = get_table_ridl( test_r );

    // expected columns: ("id" + one column for each test)
    good_c = pmerge([concat("id", test_ids), concat("identifier", test_ids)]);

    // expected rows: ("golden" test results), use 's' to skip test
    skip = -1;  // skip test

    good_r =
    [ // function
      ["defined_or_D",
        "default",                                          // t01
        empty_lst,                                          // t02
        [0:0.5:9],                                          // t03
        "A string",                                         // t04
        ["orange","apple","grape","banana"],                // t05
        ["b","a","n","a","n","a","s"],                      // t06
        [undef],                                            // t07
        [[1,2],[2,3]],                                      // t08
        ["ab",[1,2],[2,3],[4,5]],                           // t09
        [[1,2,3],[4,5,6],[7,8,9],["a","b","c"]],            // t10
        [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]             // t11
      ]
    ];

    // sanity-test tables
    table_check( test_r, test_c, false );
    table_check( good_r, good_c, false );

    // validate helper function and module
    function get_value( vid ) = get_table_v(test_r, test_c, vid, "tv");
    module log_test( m ) { log_type ( "test", m ); }
    module log_notest( f ) { log_test ( str("not tested: '", f, "'") ); }
    module run_test( fname, fresult, vid )
    {
      value_text = get_table_v(test_r, test_c, vid, "td");
      pass_value = get_table_v(good_r, good_c, fname, vid);

      test_pass = validate( cv=fresult, t="equals", ev=pass_value, pf=true );
      test_text = validate( str(fname, "(", get_value(vid), ")=", pass_value), fresult, "equals", pass_value );

      if ( pass_value != skip )
      {
        if ( !test_pass )
          log_test( str(vid, " ", test_text, " (", value_text, ")") );
        else
          log_test( str(vid, " ", test_text) );
      }
      else
        log_test( str(vid, " -skip-: '", fname, "(", value_text, ")'") );
    }

    // Indirect function calls would be very useful here!!!
    for (vid=test_ids) run_test( "defined_or_D", defined_or(get_value(vid),"default"), vid );
    log_notest( "circular_index()" );

    // end-of-tests
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
