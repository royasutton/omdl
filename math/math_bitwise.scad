//! Mathematical base-two bitwise binary functions.
/***************************************************************************//**
  \file   math_bitwise.scad
  \author Roy Allen Sutton
  \date   2017

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

  \ingroup math math_bitwise
*******************************************************************************/

include <datatypes.scad>;

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \page tv_math_bitwise Bitwise
    \li \subpage tv_math_bitwise_s
    \li \subpage tv_math_bitwise_r
  \page tv_math_bitwise_s Script
    \dontinclude math_bitwise_validate.scad
    \skip include
    \until end-of-tests
  \page tv_math_bitwise_r Results
    \include math_bitwise_validate.log
*******************************************************************************/
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \addtogroup math
  @{

  \defgroup math_bitwise Bitwise
  \brief    Base-two bitwise binary operations.

  \details

    See Wikipedia binary [numbers](https://en.wikipedia.org/wiki/Binary_number)
    and [operations](https://en.wikipedia.org/wiki/Bitwise_operation)
    for more information.

    See validation \ref tv_math_bitwise_r "results".
  @{
*******************************************************************************/
//----------------------------------------------------------------------------//

//! Test if a base-two bit position of an integer value equals a test bit.
/***************************************************************************//**
  \param    v <integer> An integer value.
  \param    b <integer> A base-two bit position.
  \param    t <bit> The bit test value [0|1].

  \returns  <boolean> \b true when the base-two bit position of the integer
            value equals \p t, otherwise returns \b false.
*******************************************************************************/
function bitwise_is_equal
(
  v,
  b,
  t = 1
) = ((floor(v / pow(2, b)) % 2) == t);

//! Encode an integer value as a base-two list of bits.
/***************************************************************************//**
  \param    v <integer> An integer value.
  \param    w <integer> The minimum bit width.
  \param    bv (an internal recursion loop variable).

  \returns  <bit-list> of bits base-two encoding of the integer value.
            Returns \b undef when \p v or \p w is not an integer.
*******************************************************************************/
function bitwise_i2v
(
  v,
  w = 1,
  bv = 1    // iteration bit value
) = !is_integer(v) ? undef
  : !is_integer(w) ? undef
  : ((v == 0) && (bv >= pow(2, w))) ? empty_lst
  : ((v % 2) > 0) ?
    concat(bitwise_i2v(floor(v/2), w, bv*2), 1)
  : concat(bitwise_i2v(floor(v/2), w, bv*2), 0);

//! Decode a base-two list of bits to an integer value.
/***************************************************************************//**
  \param    v <bit-list> A value encoded as a base-two list of bits.

  \returns  <integer> value encoding of the base-two list of bits.
            Returns \b undef when \p v is not a list of bit values.
*******************************************************************************/
function bitwise_v2i
(
  v
) = is_empty(v) ? 0
  : (first(v) == 1) ? bitwise_v2i(ntail(v)) + pow(2, len(v)-1)
  : (first(v) == 0) ? bitwise_v2i(ntail(v))
  : undef;

//! Encode an integer value as a base-two string of bits.
/***************************************************************************//**
  \param    v <integer> An integer value.
  \param    w <integer> The minimum bit width.

  \returns  <bit-string> of bits base-two encoding of the integer value.
            Returns \b undef when \p v or \p w is not an integer.
*******************************************************************************/
function bitwise_i2s
(
  v,
  w = 1
) = !is_integer(v) ? undef
  : !is_integer(w) ? undef
  : vstr(bitwise_i2v(v, w));

//! Decode a base-two string of bits to an integer value.
/***************************************************************************//**
  \param    v <bit-string> A value encoded as a base-two string of bits.

  \returns  <integer> value encoding of the base-two string of bits.
            Returns \b undef when \p v is not a string of bit values.
*******************************************************************************/
function bitwise_s2i
(
  v
) = is_empty(v) ? 0
  : (first(v) == "1") ? bitwise_s2i(ntail(v)) + pow(2, len(v)-1)
  : (first(v) == "0") ? bitwise_s2i(ntail(v))
  : undef;

//! Decode the integer in a value at a shifted base-two bit mask of width-w.
/***************************************************************************//**
  \param    v <integer> An integer value.
  \param    w <integer> The bit mask width.
  \param    s <integer> The bit mask shift offset.

  \returns  <integer> value of the \p w bits of \p v starting at bit
            position \p s up to bit <tt>(w+s-1)</tt>.
*******************************************************************************/
function bitwise_imi
(
  v,
  w,
  s
) = bitwise_rsh(bitwise_and(v, bitwise_lsh(pow(2,w)-1, s)), s);

//! Base-two bitwise AND operation for integers.
/***************************************************************************//**
  \param    v1 <integer> An integer value.
  \param    v2 <integer> An integer value.
  \param    bv (an internal recursion loop variable).

  \returns  <integer> result of the base-two bitwise AND of \p v1 and \p v2.
            Returns \b undef when \p v1 or \p v2 is not an integer.
*******************************************************************************/
function bitwise_and
(
  v1,
  v2,
  bv = 1
) = !is_integer(v1) ? undef
  : !is_integer(v2) ? undef
  : ((v1 + v2) == 0) ? 0
  : (((v1 % 2) > 0) && ((v2 % 2) > 0)) ?
    bitwise_and(floor(v1/2), floor(v2/2), bv*2) + bv
  : bitwise_and(floor(v1/2), floor(v2/2), bv*2);

//! Base-two bitwise OR operation for integers.
/***************************************************************************//**
  \param    v1 <integer> An integer value.
  \param    v2 <integer> An integer value.
  \param    bv (an internal recursion loop variable).

  \returns  <integer> result of the base-two bitwise OR of \p v1 and \p v2.
            Returns \b undef when \p v1 or \p v2 is not an integer.
*******************************************************************************/
function bitwise_or
(
  v1,
  v2,
  bv = 1
) = !is_integer(v1) ? undef
  : !is_integer(v2) ? undef
  : ((v1 + v2) == 0) ? 0
  : (((v1 % 2) > 0) || ((v2 % 2) > 0)) ?
    bitwise_or(floor(v1/2), floor(v2/2), bv*2) + bv
  : bitwise_or(floor(v1/2), floor(v2/2), bv*2);

//! Base-two bitwise XOR operation for integers.
/***************************************************************************//**
  \param    v1 <integer> An integer value.
  \param    v2 <integer> An integer value.
  \param    bv (an internal recursion loop variable).

  \returns  <integer> result of the base-two bitwise XOR of \p v1 and \p v2.
            Returns \b undef when \p v1 or \p v2 is not an integer.
*******************************************************************************/
function bitwise_xor
(
  v1,
  v2,
  bv = 1
) = !is_integer(v1) ? undef
  : !is_integer(v2) ? undef
  : ((v1 + v2) == 0) ? 0
  : (((v1 % 2) > 0) != ((v2 % 2) > 0)) ?
    bitwise_xor(floor(v1/2), floor(v2/2), bv*2) + bv
  : bitwise_xor(floor(v1/2), floor(v2/2), bv*2);

//! Base-two bitwise NOT operation for an integer.
/***************************************************************************//**
  \param    v <integer> An integer value.
  \param    w <integer> The minimum bit width.
  \param    bv (an internal recursion loop variable).

  \returns  <integer> result of the base-two bitwise NOT of \p v.
            Returns \b undef when \p v is not an integer.
*******************************************************************************/
function bitwise_not
(
  v,
  w = 1,
  bv = 1
) = !is_integer(v) ? undef
  : ((v == 0) && (bv >= pow(2, w))) ? 0
  : ((v % 2) > 0) ?
    bitwise_not(floor(v/2), w, bv*2)
  : bitwise_not(floor(v/2), w, bv*2) + bv;

//! Base-two bitwise left-shift operation for an integer.
/***************************************************************************//**
  \param    v <integer> An integer value.
  \param    s <integer> The number of bits to shift.
  \param    bm (an internal recursion loop variable).
  \param    bv (an internal recursion loop variable).

  \returns  <integer> result of the base-two bitwise left-shift of \p v
            by \p s bits.
            Returns \b undef when \p v or \p s is not an integer.
*******************************************************************************/
function bitwise_lsh
(
  v,
  s = 1,
  bm = 1,
  bv = 1
) = !is_integer(v) ? undef
  : !is_integer(s) ? undef
  : (bm < v) ? bitwise_lsh(v, s, bm*2, bv)    // max bit position
  : (s  > 0) ? bitwise_lsh(v*2, s-1, bm, bv)  // shift value
  : (bv > bm) ? 0
  : ((v % 2) > 0) ?                           // encoded result
    bitwise_lsh(floor(v/2), s, bm, bv*2) + bv
  : bitwise_lsh(floor(v/2), s, bm, bv*2);

//! Base-two bitwise right-shift operation for an integer.
/***************************************************************************//**
  \param    v <integer> An integer value.
  \param    s <integer> The number of bits to shift.

  \returns  <integer> result of the base-two bitwise right-shift of \p v
            by \p s bits.
            Returns \b undef when \p v or \p s is not an integer.
*******************************************************************************/
function bitwise_rsh
(
  v,
  s = 1
) = !is_integer(v) ? undef
  : !is_integer(s) ? undef
  : (s <= 0) ? v
  : bitwise_rsh(floor(v/2), s-1);

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE validate;
  BEGIN_OPENSCAD;
    include <math/math_bitwise.scad>;
    use <datatypes/datatypes_table.scad>;
    use <console.scad>;
    use <validation.scad>;

    show_passing = true;    // show passing tests
    show_skipped = true;    // show skipped tests

    echo( str("OpenSCAD Version ", version()) );

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

    test_ids = table_get_allrow_ids( test_r );

    // expected columns: ("id" + one column for each test)
    good_c = pmerge([concat("id", test_ids), concat("identifier", test_ids)]);

    // expected rows: ("golden" test results), use 'skip' to skip test
    skip = -1;  // skip test

    good_r =
    [ // function
      ["bitwise_is_equal_0", 2,
        false,                          // t01
        false,                          // t02
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
      ["bitwise_is_equal_1", 2,
        false,                          // t01
        false,                          // t02
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
      ["bitwise_i2v", 1,
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
      ["bitwise_i2v_v2i", 1,
        undef,                          // t01
        undef,                          // t02
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
      ["bitwise_i2s", 1,
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
      ["bitwise_i2s_s2i", 1,
        undef,                          // t01
        undef,                          // t02
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
      ["bitwise_imi_32", 1,
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
      ["bitwise_and", 2,
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
      ["bitwise_or", 2,
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
      ["bitwise_xor", 2,
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
      ["bitwise_not", 1,
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
      ["bitwise_lsh", 1,
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
      ["bitwise_rsh", 1,
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
    function get_value( vid ) = table_get(test_r, test_c, vid, "tv");
    function gv( vid, e ) = get_value( vid )[e];
    module run( fname, vid )
    {
      value_text = table_get(test_r, test_c, vid, "td");

      if ( table_get(good_r, good_c, fname, vid) != skip )
        children();
      else if ( show_skipped )
        log_info( str("*skip*: ", vid, " '", fname, "(", value_text, ")'") );
    }
    module test( fname, fresult, vid )
    {
      value_text = table_get(test_r, test_c, vid, "td");
      fname_argc = table_get(good_r, good_c, fname, "fac");
      pass_value = table_get(good_r, good_c, fname, vid);

      test_pass = validate(cv=fresult, t="equals", ev=pass_value, pf=true);
      farg_text = vstr(eappend(", ", rselect(get_value(vid), [0:fname_argc-1]), r=false, j=false, l=false));
      test_text = validate(str(fname, "(", farg_text, ")=", pass_value), fresult, "equals", pass_value);

      if ( pass_value != skip )
      {
        if ( !test_pass )
          log_warn( str(vid, "(", value_text, ") ", test_text) );
        else if ( show_passing )
          log_info( str(vid, " ", test_text) );
      }
      else if ( show_skipped )
        log_info( str(vid, " *skip*: '", fname, "(", value_text, ")'") );
    }

    // Indirect function calls would be very useful here!!!
    run_ids = delete( test_ids, mv=["fac", "crp"] );
    for (vid=run_ids) run("bitwise_is_equal_0",vid) test( "bitwise_is_equal_0", bitwise_is_equal(gv(vid,0),gv(vid,1),0), vid );
    for (vid=run_ids) run("bitwise_is_equal_1",vid) test( "bitwise_is_equal_1", bitwise_is_equal(gv(vid,0),gv(vid,1),1), vid );
    for (vid=run_ids) run("bitwise_i2v",vid) test( "bitwise_i2v", bitwise_i2v(gv(vid,0)), vid );
    for (vid=run_ids) run("bitwise_i2v_v2i",vid) test( "bitwise_i2v_v2i", bitwise_v2i(bitwise_i2v(gv(vid,0))), vid );
    for (vid=run_ids) run("bitwise_i2s",vid) test( "bitwise_i2s", bitwise_i2s(gv(vid,0)), vid );
    for (vid=run_ids) run("bitwise_i2s_s2i",vid) test( "bitwise_i2s_s2i", bitwise_s2i(bitwise_i2s(gv(vid,0))), vid );
    for (vid=run_ids) run("bitwise_imi_32",vid) test( "bitwise_imi_32", bitwise_imi(gv(vid,0),3,2), vid );
    for (vid=run_ids) run("bitwise_and",vid) test( "bitwise_and", bitwise_and(gv(vid,0),gv(vid,1)), vid );
    for (vid=run_ids) run("bitwise_or",vid) test( "bitwise_or", bitwise_or(gv(vid,0),gv(vid,1)), vid );
    for (vid=run_ids) run("bitwise_xor",vid) test( "bitwise_xor", bitwise_xor(gv(vid,0),gv(vid,1)), vid );
    for (vid=run_ids) run("bitwise_not",vid) test( "bitwise_not", bitwise_not(gv(vid,0)), vid );
    for (vid=run_ids) run("bitwise_lsh",vid) test( "bitwise_lsh", bitwise_lsh(gv(vid,0)), vid );
    for (vid=run_ids) run("bitwise_rsh",vid) test( "bitwise_rsh", bitwise_rsh(gv(vid,0)), vid );

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
