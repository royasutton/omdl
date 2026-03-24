//! Map data structure and operations.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2015-2026

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

    \amu_define group_name  (Maps)
    \amu_define group_brief (Map data type and operations.)

  \amu_include (include/amu/doxyg_init_pd_gds_ipg.amu)
*******************************************************************************/

// auto-tests (add to test results page)
/***************************************************************************//**
  \amu_include (include/amu/validate_log.amu)
  \amu_include (include/amu/validate_results.amu)
*******************************************************************************/

// group(s) begin (test summary and includes-required)
/***************************************************************************//**
  \amu_include (include/amu/doxyg_define_in_parent_open.amu)
  \amu_include (include/amu/validate_summary.amu)
  \amu_include (include/amu/includes_required.amu)
*******************************************************************************/

// member-wide reference definitions
/***************************************************************************//**
  \amu_define group_references
  (
  )
*******************************************************************************/

// member-wide documentation and conventions
/***************************************************************************//**
  \addtogroup \amu_eval(${group})
  \details
  \anchor \amu_eval(${group})_conventions
  \par Conventions

  - A map is a \b list of \b [key, value] pairs. Keys must be \b strings.
  - The map variable is always named \p m; a second map is \p m2.
  - \c map_merge(m1, m2): when both maps contain the same key, the value
    from \p m1 takes precedence. Order of keys in the result is unspecified.
  - \c map_update(m, u): keys in \p u that are also in \p m update the
    existing value; keys in \p u absent from \p m are appended.
    Values in \p m absent from \p u are preserved unchanged.
  - The special variable \c $map_strict controls whether map_get_value()
    asserts on a missing key (strict=true) or returns \b undef silently
    (strict=false, the default).
  - map_errors() returns an empty list when the map is valid; a non-empty
    list indicates the detected error class(es).

  \b Example

  \amu_define title (Map use)
  \amu_define scope_id (example_use)
  \amu_include (include/amu/scope.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// members
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
// global configuration variables
//----------------------------------------------------------------------------//

//! \name Variables
//! @{

//! <boolean> Enforce strict checking for map value references.
$map_strict = false;

//! @}

//----------------------------------------------------------------------------//
// functions and modules
//----------------------------------------------------------------------------//

//! \name Functions
//! @{

//! Return the index of a map key.
/***************************************************************************//**
  \param    m <map> A list of N key-value map pairs.
  \param    k \<value> A map key.

  \returns  <integer> The index of the map entry if it exists.
            Returns \b undef if \p key does not exist.
*******************************************************************************/
function map_get_index
(
  m,
  k
) = let(i = first(search([k], m, 1, 0 )))
    (i == empty_lst) ? undef : i;

//! Test if a key exists.
/***************************************************************************//**
  \param    m <map> A list of N key-value map pairs.
  \param    k \<value> A map key.

  \returns  <boolean> \b true when the key exists and \b false otherwise.
*******************************************************************************/
function map_exists
(
  m,
  k
) = is_defined(map_get_index(m, k));

//! Get the map value associated with a key.
/***************************************************************************//**
  \param    m <map> A list of N key-value map pairs.
  \param    k \<value> A map key.

  \returns  \<value> The value associated with \p key.
            Returns \b undef if \p key does not exist and
            \b $map_strict is \b false. Raises an assertion if
            \p key does not exist and \b $map_strict is \b true.
*******************************************************************************/
function map_get_value
(
  m,
  k
) = let( key_check = ! $map_strict || map_exists(m, k) )
    assert( key_check, strl(["map key missing [", k, "]."]) )
    second(m[map_get_index(m, k)]);

//! Get a list of all map keys.
/***************************************************************************//**
  \param    m <map> A list of N key-value map pairs.

  \returns  <list-N> A list of keys for all N map entries.
*******************************************************************************/
function map_get_keys
(
  m
) = select_e(m, f=true);

//! Get a list of all map values.
/***************************************************************************//**
  \param    m <map> A list of N key-value map pairs.

  \returns  <list-N> A list of values for all N map entries.
*******************************************************************************/
function map_get_values
(
  m
) = select_e(m, l=true);

//! Get the the first value associated with an existing key in one of two maps.
/***************************************************************************//**
  \param    m1 <map> A list of N key-value map pairs.
  \param    m2 <map> A list of N key-value map pairs.
  \param    k \<value> A map key.
  \param    d \<value> A default return value.

  \returns  \<value> The first value associated with \p key that exists
            in maps \p m1 or \p m2, otherwise return \p d when it does
            not exist in either.
*******************************************************************************/
function map_get_firstof2_or
(
  m1,
  m2,
  k,
  d
) = map_exists(m1, k) ? map_get_value(m1, k)
  : map_exists(m2, k) ? map_get_value(m2, k)
  : d;

//! Get the number of map entries.
/***************************************************************************//**
  \param    m <map> A list of N key-value map pairs.

  \returns  <integer> The number of map entries.
*******************************************************************************/
function map_get_size
(
  m
) = len(m);

//! Merge the unique key-value pairs of a second map with those of a first.
/***************************************************************************//**
  \param    m1 <map> A list of N key-value map pairs.
  \param    m2 <map> A list of N key-value map pairs.

  \returns  \<value> The key value-pairs of \p m1 together with the
            unique key value-pairs of \p m2 that are absent in \p m1.
*******************************************************************************/
function map_merge
(
  m1,
  m2
) = [
      // output all key-value pairs of 'm1'
      for (k = map_get_keys(m1) )
          [k, map_get_value(m1, k)],

      // output all key-value pairs of 'm2' not present in 'm1'
      for (k = map_get_keys(m2) )
        if ( !map_exists(m1, k) )
          [k, map_get_value(m2, k)]
    ];

//! Update existing key-value pairs of a map.
/***************************************************************************//**
  \param    m <map> A list of N key-value map pairs.
  \param    u <map> The update list of N key-value map pairs.
  \param    ignore <boolean> Ignore the entries of \p u missing from \p m.

  \returns  \<value> The key value-pairs of \p m together with the
            updates from \p u that are present in \p m.
*******************************************************************************/
function map_update
(
  m,
  u,
  ignore = false
) = let
    (
      mk = map_get_keys(m),
      uk = map_get_keys(u),

      ak = [for (k = uk) if (!map_exists(m, k)) k],

      missing_keys = is_empty( ak ) || ignore
    )
    assert
    (
      missing_keys,
      strl(["Update includes keys missing in map = ", ak])
    )
    [
      for (k = map_get_keys(m) )
        if ( map_exists(u, k) )
          [k, map_get_value(u, k)]
        else
          [k, map_get_value(m, k)]
    ];

//! Compare the keys and/or values of two maps to test for equality.
/***************************************************************************//**
  \param    m1 <map> A list of N key-value map pairs.
  \param    m2 <map> A list of N key-value map pairs.
  \param    keys <boolean> Comparison includes the map keys.
  \param    values <boolean> Comparison includes the map values.
  \param    sort <boolean> Sort prior to the comparison.

  \returns  <boolean> \b true when equal and \b false otherwise.
*******************************************************************************/
function map_equal(m1, m2, keys=true, values=false, sort=true) =
  let
  (
    k = ! keys ? true
      : let
        (
          k1  = map_get_keys(m1),
          k2  = map_get_keys(m2),

          kc1 = sort ? sort_q2(k1) : k1,
          kc2 = sort ? sort_q2(k2) : k2
        )
        (kc1 == kc2),

    v = ! values ? true
      : let
        (
          v1  = map_get_values(m1),
          v2  = map_get_values(m2),

          vc1 = sort ? sort_q2(v1) : v1,
          vc2 = sort ? sort_q2(v2) : v2
        )
        (vc1 == vc2)
  )
  ( k && v );

//! Create a map from two selected columns of a data table.
/***************************************************************************//**
  \param    t <table> A 2d data matrix.
  \param    keys <integer> The table column for the map keys.
  \param    values <integer> The table column for the map values.

  \returns  <map> A list of N key-value map pairs.
*******************************************************************************/
function map_from_table(t, keys=0, values=1) =
  let
  (
    k = select_e (t, keys),
    v = select_e (t, values)
  )
  merge_p([k, v], j=true);

//! Create a table from a list of maps with common keys.
/***************************************************************************//**
  \param    ml <map-list> A list of one or more maps.
  \param    sort <boolean> Sort the output by key.

  \returns  \<table> The table row data matrix (C-columns x R-Rows),
            where \p C is the number of maps and \p R is the number of
            map keys.
*******************************************************************************/
function map_to_table
(
  ml,
  sort = false
) = let
    (
      // first map
      m0 = first( ml ),

      // first map keys
      k0 = map_get_keys( m0 ),

      // vector of map sizes
      sv = [for (m = ml) map_get_size(m)],

      // vector of map key differences
      kv = [for (m = ml) not_common(k0, map_get_keys(m))]
    )
    assert
    ( // all map sizes must be equal
      all_equal( cv = map_get_size(m0), v = sv ),
      strl([ "All maps must be of equal size; sv=[", sv, "]." ])
    )
    assert
    ( // all map must have same keys (all keys must be in common)
      all_equal( cv = empty_lst, v = kv ),
      strl([ "All maps must have same keys; kv=[", kv, "]." ])
    )
    [ // for each key
      for (k = sort ? sort_q2( k0 ) : k0)
      [ // output the key value of each map
        k, for (m = ml) map_get_value(m, k)
      ]
    ];

//! Perform basic format checks on a map and return errors.
/***************************************************************************//**
  \param    m <map> A list of N key-value map pairs.

  \returns  <list-N> A list of map format errors.

  \details

    Check that: (1) each entry has key-value 2-tuple and (2) key
    identifiers are unique. When there are no errors, the \b empty_lst
    is returned.
*******************************************************************************/
function map_errors
(
  m
) =
  let
  (
    // (1) each entry has key-value 2-tuple.
    ec1 =
    [
      for ( i = [0:map_get_size(m)-1] )
      let ( entry = m[i], key = first(entry) )
        if ( 2 != len(entry) )
          str
          (
            "map index ", i,
            ", entry=", entry,
            ", has incorrect count=[", len(entry),"]"
          )
    ],

    // (2) no repeat key identifiers.
    ec2 =
    [
      for ( i = [0:map_get_size(m)-1] )
      let ( entry = m[i], key = first(entry) )
        if ( len(first(search([key], m, 0, 0))) > 1 )
          str
          (
            "map index ", i,
            ", key=[", key,"] not unique."
          )
    ]
  )
  concat(ec1, ec2);

//! Perform basic format checks on a map and output errors to console.
/***************************************************************************//**
  \param    m <map> A list of N key-value map pairs.

  \param    verbose <boolean> Be verbose during check.

  \details

    Check that: (1) each entry has key-value 2-tuple and (2) key
    identifiers are unique.
*******************************************************************************/
module map_check
(
  m,
  verbose = false
)
{
  if (verbose) log_info("begin map check");

  if (verbose) log_info ("checking map format and keys.");

  if ( map_get_size(m) > 0 )
  for ( i = [0:map_get_size(m)-1] )
  {
    entry = m[i];
    key = first(entry);

    // (1) each entry has key-value 2-tuple.
    assert
    (
      len(entry) == 2,
      str
      (
        "map index ", i,
        ", entry=", entry,
        ", has incorrect count=[", len(entry),"]"
      )
    );

    // (2) no repeat key identifiers.
    if ( len(first(search([key], m, 0, 0))) > 1 )
      log_warn
      (
        str
        (
          "map index ", i,
          ", key=[", key,"] not unique."
        )
      );
  }

  if (verbose)
  {
    log_info
    (
      str
      (
        "map size: ",
        map_get_size(m), " entries."
      )
    );

    log_info("end map check");
  }
}

//! Dump each map entry to the console.
/***************************************************************************//**
  \param    m <map> A list of N key-value map pairs.
  \param    sort <boolean> Sort the output by key.
  \param    number <boolean> Output index number.
  \param    align <boolean> pad keys for right alignment.
  \param    p <integer> Number of places for zero-padded numbering.
*******************************************************************************/
module map_dump
(
  m,
  sort = false,
  number = true,
  align = true,
  p = 3
)
{
  if ( map_get_size(m) > 0 )
  {
    keys  = map_get_keys(m);

    // calculate max key field length when aligning
    maxl  = align ?
            max ( [ for (i = keys) is_string(i) ? len(i) : len( strl([i]) ) ] )
          : 0;

    for (k = (sort == true) ? sort_q(keys) : keys)
    {
      // numbering with prefixed zero-padding
      num = let
            (
              i = map_get_index(m, k),
              z = chr( consts(p - len(str(i)), 48) )
            )
            number ?
            str(z, i, ": ")
          : empty_str;

      // right align key with space padding
      pad = let
            (
              s = is_string(k) ? len(k) : len( strl([k]) )
            )
            align ?
            chr( consts(maxl - s, 32) )
          : empty_str;

      val = map_get_value(m, k);

      log_echo ( str( num, pad, "'", k, "' = ", "'", val, "'" ) );
    }
  }

  if ( number )
    log_echo(str("map size: ", map_get_size(m), " entries."));
}

//! Write formatted map entries to the console.
/***************************************************************************//**
  \param    m <map> A list of N key-value map pairs.
  \param    ks <string-list> A list of selected keys.
  \param    sort <boolean> Sort the output by key.
  \param    number <boolean> Output index number.
  \param    fs <string> A field separator.
  \param    thn <string> Column heading for numbered row output.
  \param    index_tags <string-list> List of html formatting tags.
  \param    key_tags <string-list> List of html formatting tags.
  \param    value_tags <string-list> List of html formatting tags.

  \details

    Output map keys and values the console. To output only select keys,
    assign the desired key identifiers to \p ks. For example to output
    only 'key1' and 'key2', assign <tt>ks = ["key1", "key2"]</tt>. The
    output can then be processed to produce documentation tables as
    shown in the example below.

    \amu_define title (Map write)
    \amu_define scope_id (example_table)
    \amu_include (include/amu/scope_table.amu)
*******************************************************************************/
module map_write
(
  m,
  ks,
  sort = false,
  number = false,
  fs = "^",
  thn = "idx",
  index_tags = empty_lst,
  key_tags = ["b"],
  value_tags = empty_lst
)
{
  if ( map_get_size(m) > 0 )
  {
    num = number ? str(thn, fs) : empty_str;

    // map heading
    log_echo ( str ( num, "key", fs, "value" ) );

    // map data
    keys = map_get_keys(m);

    for (k = (sort == true) ? sort_q(keys) : keys)
    {
      if
      (
        is_undef( ks ) ||
        is_number( first( search( [k], ks, 1, 0 ) ) )
      )
      {
        num = let
              (
                i = map_get_index(m, k)
              )
              number ?
              str( strl_html([i], p=[index_tags]), fs )
            : empty_str;

        key = strl_html([k], p=[key_tags]);

        val = strl_html([map_get_value(m, k)], p=[value_tags]);

        log_echo ( str ( num, key, fs, val, fs ) );
      }
    }
  }
}

//! @}

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
    for (i=[1:13]) echo( "not tested:" );

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_term}.mfs;
    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

/*
BEGIN_SCOPE example_use;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;

    map =
    [
      ["part1",       ["screw10", [10, 11, 13]]],
      ["part2",       ["screw12", [20, 21, 30]]],
      ["part3",       ["screw10", [10, 10, -12]]],
      ["config",      ["top", "front", "rear"]],
      ["version",     [21, 5, 0]],
      ["runid",       10]
    ];

    echo( "### map_check ###" );
    map_check(map, true);

    echo( "### map_exists ###" );
    echo( str("is part0 = ", map_exists(map, "part0")) );
    echo( str("is part1 = ", map_exists(map, "part1")) );

    echo( "### map_get_value ###" );
    p1 = map_get_value(map, "part1");
    echo( c=second(p1) );

    keys = map_get_keys(map);
    parts = delete(keys, mv=["config", "version", "runid"]);

    echo( "### map_delete ###" );
    for ( p = parts )
      echo
      (
        n=p,
        p=first(map_get_value(map, p)),
        l=second(map_get_value(map, p))
      );

    echo( "### map_dump ###" );
    map_dump(map);

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_term}.mfs;
    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

/*
BEGIN_SCOPE example_table;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;

    map =
    [
      ["part1",       ["screw10", [10, 11, 13]]],
      ["part2",       ["screw12", [20, 21, 30]]],
      ["part3",       ["screw10", [10, 10, -12]]],
      ["config",      ["top", "front", "rear"]],
      ["version",     [21, 5, 0]],
      ["runid",       10]
    ];

    map_write(map, index_tags=["center","i"]);

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
