//! Base-2 binary numbers tests and operations.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2017-2023

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

    \amu_define group_name  (Binary Numbers)
    \amu_define group_brief (Base-2 binary numbers tests and operations.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
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
  \amu_include (include/amu/includes_required.amu)

  \details

  \amu_include (include/amu/validate_summary.amu)

    See Wikipedia binary [numbers] and [operations] for more
    information.

  [numbers]: https://en.wikipedia.org/wiki/Binary_number
  [operations]: https://en.wikipedia.org/wiki/Bitwise_operation
*******************************************************************************/

//----------------------------------------------------------------------------//

//! Test if a binary bit position of an integer value equals a test bit.
/***************************************************************************//**
  \param    v <integer> An integer value.
  \param    b <integer> A binary bit position.
  \param    t <bit> The bit test value [0|1].

  \returns  (1) <boolean> \b true when the binary bit position in \p v
                specified by \p b equals \p t, otherwise returns
                \b false.
            (2) Returns \b undef if \p v or \p b is not an integer.
*******************************************************************************/
function binary_bit_is
(
  v,
  b,
  t = 1
) = !is_integer(v) ? undef
  : !is_integer(b) ? undef
  : ((floor(v / pow(2, b)) % 2) == t);

//! Encode an integer value as a binary list of bits.
/***************************************************************************//**
  \param    v <integer> An integer value.
  \param    w <integer> The minimum bit width.
  \param    bv (an internal recursion loop variable).

  \returns  (1) <bit-list> of bits binary encoding of the integer value.
            (2) Returns \b undef when \p v or \p w is not an integer.

  \details

    The bit-list will be the minimum required to represent the value. If
    \p w is greater than the minimum required bits, then the value will
    be padded with '0'.
*******************************************************************************/
function binary_i2v
(
  v,
  w = 1,
  // iteration bit value
  bv = 1
) = !is_integer(v) ? undef
  : !is_integer(w) ? undef
  : ((v == 0) && (bv >= pow(2, w))) ? empty_lst
  : ((v % 2) > 0) ? concat(binary_i2v(floor(v/2), w, bv*2), 1)
                  : concat(binary_i2v(floor(v/2), w, bv*2), 0);

//! Decode a binary list of bits to an integer value.
/***************************************************************************//**
  \param    v <bit-list> A value encoded as a binary list of bits.

  \returns  (1) <integer> value encoding of the binary list of bits.
            (2) Returns \b undef when \p v is not a list of bit values.
*******************************************************************************/
function binary_v2i
(
  v
) = is_empty(v) ? 0
    // all must be '0' or '1'
  : !all_oneof(v, [0, 1]) ? undef
  : (first(v) == 1) ? binary_v2i(tailn(v)) + pow(2, len(v)-1)
  : (first(v) == 0) ? binary_v2i(tailn(v))
  : undef;

//! Encode an integer value as a binary string of bits.
/***************************************************************************//**
  \param    v <integer> An integer value.
  \param    w <integer> The minimum bit width.

  \returns  (1) <bit-string> of bits binary encoding of the integer value.
            (2) Returns \b undef when \p v or \p w is not an integer.
*******************************************************************************/
function binary_i2s
(
  v,
  w = 1
) = !is_integer(v) ? undef
  : !is_integer(w) ? undef
  : strl(binary_i2v(v, w));

//! Decode a binary string of bits to an integer value.
/***************************************************************************//**
  \param    v <bit-string> A value encoded as a binary string of bits.

  \returns  (1) <integer> value encoding of the binary string of bits.
            (2) Returns \b undef when \p v is not a string of bit values.
*******************************************************************************/
function binary_s2i
(
  v
) = is_empty(v) ? 0
    // all must be '0' or '1'
  : !all_oneof(v, "01") ? undef
  : (first(v) == "1") ? binary_s2i(strl(tailn(v))) + pow(2, len(v)-1)
  : (first(v) == "0") ? binary_s2i(strl(tailn(v)))
  : undef;

//! Decode the binary bits of a bit window to an integer value.
/***************************************************************************//**
  \param    v <integer> An integer value.
  \param    s <integer> The bit window start offset.
  \param    w <integer> The bit window width.

  \returns  (1) <integer> value of the \p w bits of \p v starting at bit
                position \p s up to bit <tt>(w+s-1)</tt>.
            (2) Returns \b undef when \p v, \p w, or \p s is not an
                integer.
*******************************************************************************/
function binary_iw2i
(
  v,
  s,
  w
) = !is_integer(v) ? undef
  : !is_integer(w) ? undef
  : !is_integer(s) ? undef
  : binary_ishr(binary_and(v, binary_ishl(pow(2,w)-1, s)), s);

//! Base-2 binary AND operation for integers.
/***************************************************************************//**
  \param    v1 <integer> An integer value.
  \param    v2 <integer> An integer value.
  \param    bv (an internal recursion loop variable).

  \returns  (1) <integer> the binary AND of \p v1 and \p v2.
            (2) Returns \b undef when \p v1 or \p v2 is not an integer.
*******************************************************************************/
function binary_and
(
  v1,
  v2,
  bv = 1
) = !is_integer(v1) ? undef
  : !is_integer(v2) ? undef
  : ((v1 + v2) == 0) ? 0
  : (((v1 % 2) > 0) && ((v2 % 2) > 0)) ?
    binary_and(floor(v1/2), floor(v2/2), bv*2) + bv
  : binary_and(floor(v1/2), floor(v2/2), bv*2);

//! Base-2 binary OR operation for integers.
/***************************************************************************//**
  \param    v1 <integer> An integer value.
  \param    v2 <integer> An integer value.
  \param    bv (an internal recursion loop variable).

  \returns  (1) <integer> the binary OR of \p v1 and \p v2.
            (2) Returns \b undef when \p v1 or \p v2 is not an integer.
*******************************************************************************/
function binary_or
(
  v1,
  v2,
  bv = 1
) = !is_integer(v1) ? undef
  : !is_integer(v2) ? undef
  : ((v1 + v2) == 0) ? 0
  : (((v1 % 2) > 0) || ((v2 % 2) > 0)) ?
    binary_or(floor(v1/2), floor(v2/2), bv*2) + bv
  : binary_or(floor(v1/2), floor(v2/2), bv*2);

//! Base-2 binary XOR operation for integers.
/***************************************************************************//**
  \param    v1 <integer> An integer value.
  \param    v2 <integer> An integer value.
  \param    bv (an internal recursion loop variable).

  \returns  (1) <integer> the binary XOR of \p v1 and \p v2.
            (2) Returns \b undef when \p v1 or \p v2 is not an integer.
*******************************************************************************/
function binary_xor
(
  v1,
  v2,
  bv = 1
) = !is_integer(v1) ? undef
  : !is_integer(v2) ? undef
  : ((v1 + v2) == 0) ? 0
  : (((v1 % 2) > 0) != ((v2 % 2) > 0)) ?
    binary_xor(floor(v1/2), floor(v2/2), bv*2) + bv
  : binary_xor(floor(v1/2), floor(v2/2), bv*2);

//! Base-2 binary NOT operation for an integer.
/***************************************************************************//**
  \param    v <integer> An integer value.
  \param    w <integer> The minimum bit width.
  \param    bv (an internal recursion loop variable).

  \returns  (1) <integer> the binary NOT of \p v.
            (2) Returns \b undef when \p v or \p w is not an integer.
*******************************************************************************/
function binary_not
(
  v,
  w = 1,
  bv = 1
) = !is_integer(v) ? undef
  : !is_integer(w) ? undef
  : ((v == 0) && (bv >= pow(2, w))) ? 0
  : ((v % 2) > 0) ?
    binary_not(floor(v/2), w, bv*2)
  : binary_not(floor(v/2), w, bv*2) + bv;

//! Base-2 binary left-shift operation for an integer.
/***************************************************************************//**
  \param    v <integer> An integer value.
  \param    s <integer> The number of bits to shift.
  \param    bm (an internal recursion loop variable).
  \param    bv (an internal recursion loop variable).

  \returns  (1) <integer> the binary left-shift of \p v
                by \p s bits.
            (2) Returns \b undef when \p v or \p s is not an integer.
*******************************************************************************/
function binary_ishl
(
  v,
  s = 1,
  bm = 1,
  bv = 1
) = !is_integer(v) ? undef
  : !is_integer(s) ? undef
    // max bit position
  : (bm < v) ? binary_ishl(v, s, bm*2, bv)
    // shift value
  : (s  > 0) ? binary_ishl(v*2, s-1, bm, bv)
  : (bv > bm) ? 0
    // encoded result
  : ((v % 2) > 0) ? binary_ishl(floor(v/2), s, bm, bv*2) + bv
                  : binary_ishl(floor(v/2), s, bm, bv*2);

//! Base-2 binary right-shift operation for an integer.
/***************************************************************************//**
  \param    v <integer> An integer value.
  \param    s <integer> The number of bits to shift.

  \returns  (1) <integer> the binary right-shift of \p v
                by \p s bits.
            (2) Returns \b undef when \p v or \p s is not an integer.
*******************************************************************************/
function binary_ishr
(
  v,
  s = 1
) = !is_integer(v) ? undef
  : !is_integer(s) ? undef
  : (s <= 0) ? v
  : binary_ishr(floor(v/2), s-1);

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE validate;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <common/validation.scad>;

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
      ["fac", "Function argument count",    undef],
      ["t01", "All undefined",              [undef,undef]],
      ["t02", "All empty lists",            [empty_lst,empty_lst]],
      ["t03", "test value 1",               [254, 0]],
      ["t04", "test value 2",               [254, 1]],
      ["t05", "test value 3",               [255, 0]],
      ["t06", "test value 4",               [0, 255]],
      ["t07", "test value 5",               [126, 63]],
      ["t08", "test value 6",               [25, 10]],
      ["t09", "test value 7",               [1024, 512]],
      ["t10", "test value 8",               [4253, 315]],
      ["t11", "test value 9",               [835, 769]],
      ["t12", "test value 10",              [856, 625]]
    ];

    test_ids = table_get_row_ids( test_r );

    // expected columns: ("id" + one column for each test)
    good_c = merge_p([concat("id", test_ids), concat("identifier", test_ids)]);

    // expected rows: ("golden" test results), use 'skip' to skip test
    skip = -1;  // skip test

    good_r =
    [ // function
      ["binary_bit_is_0", 2,
        undef,                          // t01
        undef,                          // t02
        true,                           // t03
        false,                          // t04
        false,                          // t05
        true,                           // t06
        true,                           // t07
        true,                           // t08
        true,                           // t09
        true,                           // t10
        true,                           // t11
        true                            // t12
      ],
      ["binary_bit_is_1", 2,
        undef,                          // t01
        undef,                          // t02
        false,                          // t03
        true,                           // t04
        true,                           // t05
        false,                          // t06
        false,                          // t07
        false,                          // t08
        false,                          // t09
        false,                          // t10
        false,                          // t11
        false                           // t12
      ],
      ["binary_i2v", 1,
        undef,                          // t01
        undef,                          // t02
        [1,1,1,1,1,1,1,0],              // t03
        [1,1,1,1,1,1,1,0],              // t04
        [1,1,1,1,1,1,1,1],              // t05
        [0],                            // t06
        [1,1,1,1,1,1,0],                // t07
        [1,1,0,0,1],                    // t08
        [1,0,0,0,0,0,0,0,0,0,0],        // t09
        [1,0,0,0,0,1,0,0,1,1,1,0,1],    // t10
        [1,1,0,1,0,0,0,0,1,1],          // t11
        [1,1,0,1,0,1,1,0,0,0]           // t12
      ],
      ["binary_i2v_v2i", 1,
        0,                              // t01
        0,                              // t02
        254,                            // t03
        254,                            // t04
        255,                            // t05
        0,                              // t06
        126,                            // t07
        25,                             // t08
        1024,                           // t09
        4253,                           // t10
        835,                            // t11
        856                             // t12
      ],
      ["binary_i2s", 1,
        undef,                          // t01
        undef,                          // t02
        "11111110",                     // t03
        "11111110",                     // t04
        "11111111",                     // t05
        "0",                            // t06
        "1111110",                      // t07
        "11001",                        // t08
        "10000000000",                  // t09
        "1000010011101",                // t10
        "1101000011",                   // t11
        "1101011000"                    // t12
      ],
      ["binary_i2s_s2i", 1,
        0,                              // t01
        0,                              // t02
        254,                            // t03
        254,                            // t04
        255,                            // t05
        0,                              // t06
        126,                            // t07
        25,                             // t08
        1024,                           // t09
        4253,                           // t10
        835,                            // t11
        856                             // t12
      ],
      ["binary_iw2i_32", 1,
        undef,                          // t01
        undef,                          // t02
        7,                              // t03
        7,                              // t04
        7,                              // t05
        0,                              // t06
        7,                              // t07
        6,                              // t08
        0,                              // t09
        7,                              // t10
        0,                              // t11
        6                               // t12
      ],
      ["binary_and", 2,
        undef,                          // t01
        undef,                          // t02
        0,                              // t03
        0,                              // t04
        0,                              // t05
        0,                              // t06
        62,                             // t07
        8,                              // t08
        0,                              // t09
        25,                             // t10
        769,                            // t11
        592                             // t12
      ],
      ["binary_or", 2,
        undef,                          // t01
        undef,                          // t02
        254,                            // t03
        255,                            // t04
        255,                            // t05
        255,                            // t06
        127,                            // t07
        27,                             // t08
        1536,                           // t09
        4543,                           // t10
        835,                            // t11
        889                             // t12
      ],
      ["binary_xor", 2,
        undef,                          // t01
        undef,                          // t02
        254,                            // t03
        255,                            // t04
        255,                            // t05
        255,                            // t06
        65,                             // t07
        19,                             // t08
        1536,                           // t09
        4518,                           // t10
        66,                             // t11
        297                             // t12
      ],
      ["binary_not", 1,
        undef,                          // t01
        undef,                          // t02
        1,                              // t03
        1,                              // t04
        0,                              // t05
        1,                              // t06
        1,                              // t07
        6,                              // t08
        1023,                           // t09
        3938,                           // t10
        188,                            // t11
        167                             // t12
      ],
      ["binary_ishl", 1,
        undef,                          // t01
        undef,                          // t02
        508,                            // t03
        508,                            // t04
        510,                            // t05
        0,                              // t06
        252,                            // t07
        50,                             // t08
        2048,                           // t09
        8506,                           // t10
        1670,                           // t11
        1712                            // t12
      ],
      ["binary_ishr", 1,
        undef,                          // t01
        undef,                          // t02
        127,                            // t03
        127,                            // t04
        127,                            // t05
        0,                              // t06
        63,                             // t07
        12,                             // t08
        512,                            // t09
        2126,                           // t10
        417,                            // t11
        428                             // t12
      ]
    ];

    // sanity-test tables
    table_check( test_r, test_c, false );
    table_check( good_r, good_c, false );

    // validate helper function and module
    function get_value( vid ) = table_get_value(test_r, test_c, vid, "tv");
    function gv( vid, e ) = get_value( vid )[e];
    module log_test( m ) { log_type ( "test", m ); }
    module log_skip( f ) { log_test ( str("ignore: '", f, "'") ); }
    module run( fname, vid )
    {
      value_text = table_get_value(test_r, test_c, vid, "td");

      if ( table_get_value(good_r, good_c, fname, vid) != skip )
        children();
      else
        log_test( str(vid, " -skip-: '", fname, "(", value_text, ")'") );
    }
    module test( fname, fresult, vid )
    {
      value_text = table_get_value(test_r, test_c, vid, "td");
      fname_argc = table_get_value(good_r, good_c, fname, "fac");
      pass_value = table_get_value(good_r, good_c, fname, vid);

      test_pass = validate(cv=fresult, t="equals", ev=pass_value, pf=true);
      farg_text = strl(append_e(", ", select_r(get_value(vid), [0:fname_argc-1]), r=false, j=false, l=false));
      test_text = validate(str(fname, "(", farg_text, ")=", pass_value), fresult, "equals", pass_value);

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
    run_ids = delete( test_ids, mv=["fac", "crp"] );
    for (vid=run_ids) run("binary_bit_is_0",vid) test( "binary_bit_is_0", binary_bit_is(gv(vid,0),gv(vid,1),0), vid );
    for (vid=run_ids) run("binary_bit_is_1",vid) test( "binary_bit_is_1", binary_bit_is(gv(vid,0),gv(vid,1),1), vid );
    for (vid=run_ids) run("binary_i2v",vid) test( "binary_i2v", binary_i2v(gv(vid,0)), vid );
    for (vid=run_ids) run("binary_i2v_v2i",vid) test( "binary_i2v_v2i", binary_v2i(binary_i2v(gv(vid,0))), vid );
    for (vid=run_ids) run("binary_i2s",vid) test( "binary_i2s", binary_i2s(gv(vid,0)), vid );
    for (vid=run_ids) run("binary_i2s_s2i",vid) test( "binary_i2s_s2i", binary_s2i(binary_i2s(gv(vid,0))), vid );
    for (vid=run_ids) run("binary_iw2i_32",vid) test( "binary_iw2i_32", binary_iw2i(gv(vid,0),2,3), vid );
    for (vid=run_ids) run("binary_and",vid) test( "binary_and", binary_and(gv(vid,0),gv(vid,1)), vid );
    for (vid=run_ids) run("binary_or",vid) test( "binary_or", binary_or(gv(vid,0),gv(vid,1)), vid );
    for (vid=run_ids) run("binary_xor",vid) test( "binary_xor", binary_xor(gv(vid,0),gv(vid,1)), vid );
    for (vid=run_ids) run("binary_not",vid) test( "binary_not", binary_not(gv(vid,0)), vid );
    for (vid=run_ids) run("binary_ishl",vid) test( "binary_ishl", binary_ishl(gv(vid,0)), vid );
    for (vid=run_ids) run("binary_ishr",vid) test( "binary_ishr", binary_ishr(gv(vid,0)), vid );

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
