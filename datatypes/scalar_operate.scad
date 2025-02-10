//! Scalar data type operations.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2015-2025

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

    \amu_define group_name  (Scalar Operations)
    \amu_define group_brief (Operations for scalar data types.)

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
*******************************************************************************/

//----------------------------------------------------------------------------//

//! Return given value, if defined, or a secondary value, if primary is not defined.
/***************************************************************************//**
  \param    v \<value> A primary value.
  \param    d \<value> A secondary value.

  \returns  \<value> \p v when it is defined and \p d otherwise.

  The value \p d is returned only when \p v is equal to \b undef.
*******************************************************************************/
function defined_or
(
  v,
  d
) = is_undef(v) ? d : v;

//! Return given value, if it is Boolean, else return a secondary value, if not.
/***************************************************************************//**
  \param    v \<value> A primary value.
  \param    d \<value> A secondary value.

  \returns  \<value> \p v when it is Boolean and \p d otherwise.
*******************************************************************************/
function boolean_or
(
  v,
  d
) = is_bool(v) ? v : d;

//! Return given value, if it is a number, else return a secondary value, if not.
/***************************************************************************//**
  \param    v \<value> A primary value.
  \param    d \<value> A secondary value.

  \returns  \<value> \p v when it is a number and \p d otherwise.
*******************************************************************************/
function number_or
(
  v,
  d
) = is_num(v) ? v : d;

//! Return given value, if it is a string, else return a secondary value, if not.
/***************************************************************************//**
  \param    v \<value> A primary value.
  \param    d \<value> A secondary value.

  \returns  \<value> \p v when it is a string and \p d otherwise.
*******************************************************************************/
function string_or
(
  v,
  d
) = is_string(v) ? v : d;

//! Return given value, if it is a list, else return a secondary value, if not.
/***************************************************************************//**
  \param    v \<value> A primary value.
  \param    d \<value> A secondary value.

  \returns  \<value> \p v when it is a list and \p d otherwise.
*******************************************************************************/
function list_or
(
  v,
  d
) = is_list(v) ? v : d;

//! Return a circular index position.
/***************************************************************************//**
  \param    i <integer> A integer position.
  \param    l <integer> The range length.
  \param    f <integer> The starting index position.

  \returns  <integer> The index position mapped into a circular list
            within the range <tt>[f : l+f-1]</tt>.
*******************************************************************************/
function index_c
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

    // skip test for:
    // * boolean_or()
    // * number_or()
    // * string_or()
    // * list_or()

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
