//! Group: Data type identification and operations.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2018-2023

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

    \amu_define group_name  (Types)
    \amu_define group_brief (Data type identification and operations.)

  \amu_include (include/amu/doxyg_init_ppd_gp.amu)
*******************************************************************************/

// auto-tests (append to test results page)
/***************************************************************************//**
  \page tv_tree
    \li \subpage tv_\amu_eval(${group})

  \page tv_\amu_eval(${group} ${group_name})
*******************************************************************************/

// group documentation and conventions
/***************************************************************************//**
  \amu_include (include/amu/doxyg_define_open.amu)

  /+

   ###########################################################
   #### amu-comment this out until transition is complete ####
   ###########################################################

  \anchor parameter_naming_conventions
  \par Parameter Naming Conventions

    The following naming conventions apply to all function and module
    parameters across every group in this library. One name always
    denotes one role; the same name is never reused for a different
    purpose in a different group unless explicitly noted as group-local
    below.

    \par Universal parameters

    These names carry the same meaning in every group.

    - \p v           : the primary input value or iterable. Always the first
                       parameter unless the function is explicitly keyed on a
                       different primary (e.g. map functions key on \p m).
    - \p cv          : a comparison or reference value tested against \p v.
    - \p d           : a default or fallback value returned when the primary
                       input is undefined or a lookup fails.
    - \p i           : an element index (integer). Used exclusively for
                       positional access into an iterable; never repurposed
                       as an insert value or counter.
    - \p n           : an element count or length. Replaces the former uses
                       of \p c, \p l, and \p w in this role.
    - \p mv          : a match value; the element being searched for.
    - \p mn          : a match count; the maximum number of occurrences to
                       return. A value of \b 0 (or any value <= 0) means
                       return all occurrences.
    - \p iv          : an insert value. Used when a function inserts an
                       element into an iterable; kept distinct from \p i
                       (index) and \p mv (match value).
    - \p i1 / \p i2  : the start and end index of a search window,
                       respectively.
    - \p dp          : decimal places; the number of significant fractional
                       digits used in a numeric comparison or rounding
                       operation.

    \par Bounds parameters

    - \p v_min  : the lower bound of a numeric range (inclusive). Replaces
                  the former \p l and \p u (when used as lower) in scalar
                  and list operations.
    - \p v_max  : the upper bound of a numeric range (inclusive). Replaces
                  the former \p u when used as upper bound.

    \par Internal recursion parameters

    Parameters whose names begin with an underscore are internal
    recursion variables. They must \b never be initialized by the
    caller; doing so produces undefined results. All such parameters
    are tagged \em internal in their \p \\param entry.

    - \p _acc  : a running accumulator (replaces \p bv, \p e, bare \p c
                 used as counters).
    - \p _bv   : the current bit-value accumulator in binary operations
                 (replaces the public \p bv).
    - \p _bm   : the current bit-mask accumulator in binary operations
                 (replaces the public \p bm).
    - \p _i    : an internal index counter (replaces bare \p c used as a
                 traversal counter in all_lists(), all_strings(),
                 all_numbers(), and all_len()).

    \par Boolean flag parameters

    Boolean flags always carry a descriptive name that makes their
    purpose readable at the call site without consulting documentation.

    - \p use_search      : selects the element-matching method: \b true uses
                           search(), \b false uses find(). Replaces
                           \p s in functions where \p s was used solely as a
                           method selector.
    - \p ri_is_value     : indicates whether a row identifier argument is a
                           literal value rather than an index string. Replaces
                           \p vri in table operations.
    - \p ci_is_value     : indicates whether a column identifier argument is a
                           literal value rather than an index string. Replaces
                           \p vci in table operations.
    - \p ignore          : suppress assertion on missing keys in map
                           operations. Kept as-is; already descriptive.

    \par Group-local parameters

    The following names have a single well-defined role within their
    group. They are \b not repurposed outside that group.

    - \p b               : a bit position (binary group only).
    - \p w               : a bit width (binary group only).
    - \p s               : a shift amount (binary group only).
    - \p p               : a point coordinate, as \b list-2d or \b list-3d
                           (euclidean group only). The two-point form uses
                           \p p1 and \p p2.
    - \p l               : a directed line, represented as
                           \b [p_initial, p_terminal] (euclidean group only).
                           Not used as list-length or lower-bound anywhere.
    - \p n               : a plane normal vector (euclidean group only).
                           Context distinguishes this from the universal \p n
                           (count); the euclidean group has no count
                           parameters.
    - \p o               : an origin point for spatial transformations
                           (euclidean group only).
    - \p a / \p av       : a rotation angle or rotation-axis vector
                           (euclidean group only).
    - \p x / \p y        : Cartesian coordinates for interpolation
                           (euclidean group only).
    - \p m               : a map, i.e. a list of \b [key, value] pairs (map
                           group only). \p m2 denotes a second map in
                           two-map operations.
    - \p k               : a map key of any valid value type (map group only).
    - \p u               : an update map whose entries are merged into \p m
                           (map group only).
    - \p r               : the row data matrix of a table (table group only).
    - \p c               : the column-identifier matrix of a table (table
                           group only). Not used as match-count outside this
                           group.
    - \p ri / \p ci      : a row or column identifier string used to look up
                           a table entry (table group only).
    - \p si              : the sub-element index used as the sort key in
                           sort_q2() (list group only).
    - \p col             : the column selector index passed to select_e()
                           and related functions (list group only).

  +/

  @}
*******************************************************************************/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
