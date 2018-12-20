//! Map data type operations.
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

    \amu_define group_name  (Maps)
    \amu_define group_brief (Map data type and operations.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
*******************************************************************************/

include <../console.scad>;
include <datatypes-base.scad>;

//----------------------------------------------------------------------------//
// group.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)

  \details

    \b Example

      \dontinclude \amu_scope(index=1).scad
      \skip include
      \until map_dump(map);

    \b Result \include \amu_scope(index=1).log

*******************************************************************************/

//----------------------------------------------------------------------------//

//! Return the index of a map key.
/***************************************************************************//**
  \param    m <matrix-2xN> A list of N key-value map pairs.
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
    (i != empty_lst) ? i
  : undef;

//! Test if a key exists.
/***************************************************************************//**
  \param    m <matrix-2xN> A list of N key-value map pairs.
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
  \param    m <matrix-2xN> A list of N key-value map pairs.
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
  \param    m <matrix-2xN> A list of N key-value map pairs.

  \returns  <string-list-N> A list of key strings for all N map entries.
*******************************************************************************/
function map_get_keys
(
  m
) = eselect(m, f=true);

//! Get a list of all map values.
/***************************************************************************//**
  \param    m <matrix-2xN> A list of N key-value map pairs.

  \returns  <list-N> A list of values for all N map entries.
*******************************************************************************/
function map_get_values
(
  m
) = eselect(m, l=true);

//! Get the number of map entries.
/***************************************************************************//**
  \param    m <matrix-2xN> A list of N key-value map pairs.

  \returns  <integer> The number of map entries.
*******************************************************************************/
function map_get_size
(
  m
) = len(m);

//! Perform some basic validation/checks on a map.
/***************************************************************************//**
  \param    m <matrix-2xN> A list of N key-value map pairs.

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

    // each entry has key-value 2-tuple.
    if ( 2 != len(entry) )
    {
      log_error
      (
        str (
          "map index ", i,
          ", entry=", entry,
          ", has incorrect count=[", len(entry),"]"
        )
      );
    }

    // each key must be a string.
    if ( is_string(key) == false )
    {
      log_error
      (
        str (
          "map index ", i,
          ", entry=", entry,
          ", key=[", key,"] is not a string."
        )
      );
    }

    // no repeat key identifiers
    if ( len(first(search([key], m, 0, 0))) > 1 )
      log_warn
      (
        str(
          "map index ", i,
          ", key=[", key,"] not unique."
        )
      );
  }

  if (verbose)
  {
    log_info
    (
      str (
        "map size: ",
        map_get_size(m), " entries."
      )
    );

    log_info("end map check");
  }
}

//! Dump each map entry to the console.
/***************************************************************************//**
  \param    m <matrix-2xN> A list of N key-value map pairs.
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

    for (key = sort ? qsort(keys) : keys)
    {
      idx = map_get_index(m, key);

      log_echo
      (
        str (
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

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE example;
  BEGIN_OPENSCAD;
    include <datatypes/map.scad>;

    map =
    [
      ["part1",       ["screw10", [10, 11, 13]]],
      ["part2",       ["screw12", [20, 21, 30]]],
      ["part3",       ["screw10", [10, 10, -12]]],
      ["config",      ["top", "front", "rear"]],
      ["version",     [21, 5, 0]],
      ["runid",       10]
    ];

    map_check(map, true);

    echo( str("is part0 = ", map_exists(map, "part0")) );
    echo( str("is part1 = ", map_exists(map, "part1")) );

    p1 = map_get_value(map, "part1");
    echo( c=second(p1) );

    keys = map_get_keys(map);
    parts = delete(keys, mv=["config", "version", "runid"]);

    for ( p = parts )
      echo
      (
        n=p,
        p=first(map_get_value(map, p)),
        l=second(map_get_value(map, p))
      );

    map_dump(map);
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
