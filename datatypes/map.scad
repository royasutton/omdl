//! Map data structure and operations.
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

    \amu_define group_name  (Maps)
    \amu_define group_brief (Map data type and operations.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_include (include/amu/includes_required.amu)

  \details

    \amu_define title (Map use)
    \amu_define scope_id (example_use)
    \amu_include (include/amu/scope.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//! Return the index of a map key.
/***************************************************************************//**
  \param    m <map> A list of N key-value map pairs.
  \param    k <string> A map key.

  \returns  <integer> The index of the map entry if it exists.
            Returns \b undef if \p key is not a string or does not exists.
*******************************************************************************/
function map_get_index
(
  m,
  k
) = !is_string(k) ? undef
  : let(i = first(search([k], m, 1, 0 )))
    (i == empty_lst) ? undef : i;

//! Test if a key exists.
/***************************************************************************//**
  \param    m <map> A list of N key-value map pairs.
  \param    k <string> A map key.

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
  \param    k <string> A map key.

  \returns  \<value> The value associated  with \p key.
            Returns \b undef if \p key does not exists.
*******************************************************************************/
function map_get_value
(
  m,
  k
) = second(m[map_get_index(m, k)]);

//! Get a list of all map keys.
/***************************************************************************//**
  \param    m <map> A list of N key-value map pairs.

  \returns  <string-list-N> A list of key strings for all N map entries.
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
  \param    k <string> A map key.
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

//! Perform basic format checks on a map and return errors.
/***************************************************************************//**
  \param    m <map> A list of N key-value map pairs.

  \returns  <list-N> A list of map format errors.

  \details

    Check that: (1) each entry has key-value 2-tuple, (2) each key is a
    string, and (3) key identifiers are unique. When there are no
    errors, the \b empty_lst is returned.
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

    // (2) each key must be a string.
    ec2 =
    [
      for ( i = [0:map_get_size(m)-1] )
      let ( entry = m[i], key = first(entry) )
        if (  is_string(key) == false )
          str
          (
            "map index ", i,
            ", entry=", entry,
            ", key=[", key,"] is not a string."
          )
    ],

    // (3) no repeat key identifiers.
    ec3 =
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
  concat(ec1, ec2, ec3);

//! Perform basic format checks on a map and output errors to console.
/***************************************************************************//**
  \param    m <map> A list of N key-value map pairs.

  \param    verbose <boolean> Be verbose during check.

  \details

    Check that: (1) each entry has key-value 2-tuple, (2) each key is a
    string, and (3) key identifiers are unique.
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

    // (2) each key must be a string.
    assert
    (
      is_string(key),
      str
      (
        "map index ", i,
        ", entry=", entry,
        ", key=[", key,"] is not a string."
      )
    );

    // (3) no repeat key identifiers.
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
  \param    p <integer> Number of places for zero-padded numbering.
*******************************************************************************/
module map_dump
(
  m,
  sort = false,
  number = true,
  p = 3
)
{
  if ( map_get_size(m) > 0 )
  {
    keys = map_get_keys(m);
    maxl = max( [for (i = keys) len(i)] ) + 1;

    for (key = (sort == true) ? sort_q(keys) : keys)
    {
      idx = map_get_index(m, key);

      log_echo
      (
        str
        (
          number ? chr(consts(p-len(str(idx)), 48)) : empty_str,
          number ? str(idx, ": ") : empty_str,
          chr(consts(maxl-len(key), 32)), "'", key, "' = ",
          "'", map_get_value(m, key), "'"
        )
      );
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
    // heading
    log_echo
    (
      str
      (
        number ? str(thn,fs) : empty_str,
        "key", fs,
        "value"
      )
    );

    // data
    keys = map_get_keys(m);
    maxl = max( [for (i = keys) len(i)] ) + 1;

    for (key = (sort == true) ? sort_q(keys) : keys)
    {
      idx = map_get_index(m, key);

      if
      (
        is_undef( ks ) ||
        is_number( first( search( [key], ks, 1, 0 ) ) )
      )
      log_echo
      (
        str
        (
          (number == true) ?
            str(strl_html([idx], p=[index_tags]),fs)
          : empty_str,
          strl_html(key, p=[key_tags]), fs,
          strl_html([map_get_value(m, key)], p=[value_tags]), fs
        )
      );
    }
  }
}

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

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
