//! Mapped key-value pair data access.
/***************************************************************************//**
  \file   map.scad
  \author Roy Allen Sutton
  \date   2015-2017

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

    Manage a collection of key-value pairs where keys are unique.

  \ingroup datatype datatype_map
*******************************************************************************/

use <console.scad>;
include <primitives.scad>;

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \addtogroup datatype
  @{

  \defgroup datatype_map Map
  \brief    Key-value mapped pair data encoding and access.

  \details

    \b Example

      \dontinclude map_example.scad
      \skip use
      \until map_dump(map);

    \b Result \include map_example.log

  @{
*******************************************************************************/
//----------------------------------------------------------------------------//

//! Return the index for the storage location of a map key-value pair.
/***************************************************************************//**
  \param    map <2d-vector> A two dimensional vector (2-tuple x n-tuple)
            containing an associative map with n elements.
  \param    key <string> A map entry identifier.

  \returns  <integer> The index of the value associated \p key in the map.
            Returns \b undef if \p key is not a string or does not exists.
*******************************************************************************/
function map_get_idx
(
  map,
  key
) = !is_string(key) ? undef
  : let
    (
      i = first(search([key], map, 1, 0 ))
    )
    (i == empty_v) ? undef
  : i;

//! Test if a key exists in a map.
/***************************************************************************//**
  \param    map <2d-vector> A two dimensional vector (2-tuple x n-tuple)
            containing an associative map with n elements.
  \param    key <string> A map entry identifier.

  \returns  <boolean> \b true when the key exists and \b false otherwise.
*******************************************************************************/
function map_exists
(
  map,
  key
) = (map_get_idx(map, key) != undef);

//! Get the value associated with a map key.
/***************************************************************************//**
  \param    map <2d-vector> A two dimensional vector (2-tuple x n-tuple)
            containing an associative map with n elements.
  \param    key <string> A map entry identifier.

  \returns  <value> The map value associated  with \p key.
            Returns \b undef if \p key does not exists.
*******************************************************************************/
function map_get
(
  map,
  key
) = second(map[map_get_idx(map, key)]);

//! Get a vector of the map entry identifier keys.
/***************************************************************************//**
  \param    map <2d-vector> A two dimensional vector (2-tuple x n-tuple)
            containing an associative map with n elements.

  \returns  <vector> A vector of keys that exist in the associative map.

  \details

  \note     Uses function \ref eselect to select the first column of the
            vector defining the map.
*******************************************************************************/
function map_get_keys
(
  map
) = eselect(map, f=true);

//! Get a vector of the map entry values.
/***************************************************************************//**
  \param    map <2d-vector> A two dimensional vector (2-tuple x n-tuple)
            containing an associative map with n elements.

  \returns  <vector> A vector of values stored in the associative map.

  \details

  \note     Uses function \ref eselect to select the last column of the
            vector defining the map.
*******************************************************************************/
function map_get_values
(
  map
) = eselect(map, l=true);

//! Get the number of key-value pairs stored in a map.
/***************************************************************************//**
  \param    map <2d-vector> A two dimensional vector (2-tuple x n-tuple)
            containing an associative map with n elements.

  \returns  <integer> The number of key-value pairs stored in the map.
*******************************************************************************/
function map_size
(
  map
) = len(map);

//! Perform some basic validation/checks on a map.
/***************************************************************************//**
  \param    map <2d-vector> A two dimensional vector (2-tuple x n-tuple)
            containing an associative map with n elements.

  \param    verbose <boolean> Be verbose during check.

  \details

    Check that: (1) each entry has key-value 2-tuple, (2) each key is a
    string, and (3) key identifiers are unique.
*******************************************************************************/
module map_check
(
  map,
  verbose = false
)
{
  if (verbose) log_info("begin map check");

  if (verbose) log_info ("checking map format and keys.");

  if ( map_size(map) > 0 )
  for ( i = [0:map_size(map)-1] )
  {
    entry = map[i];
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
    if ( len(first(search([key], map, 0, 0))) > 1 )
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
        map_size(map), " entries."
      )
    );

    log_info("end map check");
  }
}

//! Dump each map key-value pair to the console.
/***************************************************************************//**
  \param    map <2d-vector> A two dimensional vector (2-tuple x n-tuple)
            containing an associative map with n elements.

  \param    sort <boolean> Sort the output by key.
  \param    number <boolean> Output index number.
  \param    p <integer> Number of places for zero-padded numbering.
*******************************************************************************/
module map_dump
(
  map,
  sort = true,
  number = true,
  p = 3
)
{
  if ( map_size(map) > 0 )
  {
    keys = map_get_keys(map);
    maxl = max( [for (i = keys) len(i)] ) + 1;

    for (key = sort ? qsort(keys) : keys)
    {
      idx = map_get_idx(map, key);

      log_echo
      (
        str (
          number ? chr(consts(p-len(str(idx)), 48)) : empty_str,
          number ? str(idx, ": ") : empty_str,
          chr(consts(maxl-len(key), 32)), "'", key, "' = ",
          "'", map_get(map, key), "'"
        )
      );
    }
  }

  if ( number )
    log_echo(str("map size: ", map_size(map), " entries."));
}

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE example;
  BEGIN_OPENSCAD;
    use <map.scad>;

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

    p1 = map_get(map, "part1");
    echo( c=second(p1) );

    keys=map_get_keys(map);
    parts = delete(keys, mv=["config", "version", "runid"]);

    for ( p = parts )
      echo
      (
        n=p,
        p=first(map_get(map, p)),
        l=second(map_get(map, p))
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
