//! Iterable data type operations.
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

    \amu_define group_name  (Iterable Operations)
    \amu_define group_brief (Operations for iterable data types.)

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

  \amu_define group_references
  (
    [search]: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Other_Language_Features#search
  )

  \amu_include (include/amu/validate_summary.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//! Return an element of an iterable when it exists or a default value otherwise.
/***************************************************************************//**
  \param    v <iterable> An iterable value.
  \param    i <integer> An element index.
  \param    d \<value> A default value.

  \returns  (1) \<value> <tt>v[i]</tt> when it is defined or \p d
                otherwise.
*******************************************************************************/
function defined_e_or
(
  v,
  i,
  d
) = !is_iterable(v) ? d
  : !is_undef( v[i] ) ? v[i]
  : d;

//! Return the list element or scalar numeric value, if either is defined, otherwise the default value.
/***************************************************************************//**
  \param    v \<value> A value.
  \param    i <integer> An element index.
  \param    d \<value> A default value.

  \returns  (1) <number> <tt>v</tt> when it is a scalar numeric value.
            (2) \<value> <tt>v[i]</tt> when it is defined, or the
                default value \p d otherwise.
*******************************************************************************/
function defined_eon_or
(
  v,
  i,
  d
) = is_num(v) ? v
  : !is_iterable(v) ? d
  : !is_undef( v[i] ) ? v[i]
  : d;

//! Find the occurrences of a match value in an iterable value.
/***************************************************************************//**
  \param    mv \<value> A match value.
  \param    v <iterable> An iterable value.
  \param    c <integer> A match count.
              For <tt>(c>=1)</tt>, return the first \p c matches.
              For <tt>(c<=0)</tt>, return all matches.
  \param    i <integer> The secondary element index to match for when
              the elements of \p v are themselves iterable elements.

  \param    i1 <integer> The element index of \p v where the search begins.
  \param    i2 <integer> The element index of \p v where the search ends.

  \returns  (1) \<list> A list of indexes where elements match \p mv.
            (2) Returns \b empty_lst when no element of \p v matches
                \p mv or when \p v is not iterable.

  \details

    The use-cases for find() and [search]\() are summarized in the
    following tables.

    \b Find:

    | mv / v              | string | list of scalars   | list of iterables   |
    |---------------------|:------:|:-----------------:|:-------------------:|
    | scalar              |        | (a)               | (b) see note 1      |
    | string              | (c)    |                   | (b) see note 1      |
    | list of scalars     |        |                   | (b) see note 1      |
    | list of iterables   |        |                   | (b) see note 1      |

    \b Search:

    | mv / v              | string | list of scalars   | list of iterables   |
    |---------------------|:------:|:-----------------:|:-------------------:|
    | scalar              |        | (a)               | (b)                 |
    | string              | (d)    | invalid           | (e) see note 2      |
    | list of scalars     |        | (f)               | (g)                 |
    | list of iterables   |        |                   | (g)                 |

    \b Key:

    \li (a) Identify each element of \p v that equals \p mv.
    \li (b) Identify each element of \p v where \p mv equals the element at
        the specified column index, \p i, of each iterable value in \p v.
    \li (c) If, and only if, \p mv is a single character, identify each
        character in \p v that equals \p mv.
    \li (d) For each character of \p mv, identify where it exists in \p v.
        \b empty_lst is returned for each character of \p mv absent from \p v.
    \li (e) For each character of \p mv, identify where it exists in \p v
        either as a numeric value or as a character at the specified column
        index, \p i.
        \b empty_lst is returned for each character of \p mv absent from \p v.
    \li (f) For each scalar of \p mv, identify where it exists in \p v.
        \b empty_lst is returned for each scalar of \p mv absent from \p v.
    \li (g) For each element of \p mv, identify where it equals the element
        at the specified column index, \p i, of each iterable value in \p v.
        \b empty_lst is returned for each element of \p mv absent from \p v
        in the specified column index.

  \note     \b 1: When \p i is specified, that element column is compared.
            Otherwise, the entire element is compared. Functions find()
            and [search]\() behave differently in this regard.
  \note     \b 2: Invalid use combination when any element of \p v is a
            string. However, an element that is a list of one or more
            strings is valid. In which case, only the first character of
            each string element is considered.

  \amu_eval (${group_references})
*******************************************************************************/
function find
(
  mv,
  v,
  c = 1,
  i,
  i1 = 0,
  i2
) = !is_iterable(v) ? empty_lst                                   // not iterable
  : (!is_undef(i2) && (i1 > i2)) ? empty_lst                      // at upper index
  : (i1 > len(v)-1) ? empty_lst                                   // at end of list
  : ((is_undef(i) && (v[i1] == mv)) || (v[i1][i] == mv)) ?        // match method
    (
      (c == 1) ? [i1]                                             // one or all
    : concat(i1, find(mv, v, c-1, i, i1+1, i2))                   // add to list
    )
  : find(mv, v, c, i, i1+1, i2);                                  // no match, cont.

//! Count all occurrences of a match value in an iterable value.
/***************************************************************************//**
  \param    mv \<value> A match value.
  \param    v <iterable> An iterable value.
  \param    s <boolean> Element matching search method.
  \param    i <integer> The secondary element index to match for when
              the elements of \p v are themselves iterable elements.

  \returns  (1) <integer> The number of times \p mv occurs in the list.

  \details

    When \p s == \b true, [search]\() is used to match elements. When
    \p s == false, find() is used.

  \amu_eval (${group_references})
*******************************************************************************/
function count
(
  mv,
  v,
  s = true,
  i
) = (s == false) ? len(find(mv, v, 0, i))
  : len(merge_s(search(mv, v, 0, i)));

//! Check for the existence of a match value in an iterable value.
/***************************************************************************//**
  \param    mv \<value> A match value.
  \param    v <iterable> An iterable value.
  \param    s <boolean> Element matching search method.
  \param    i <integer> The secondary element index to match for when
              the elements of \p v are themselves iterable elements.

  \returns  (1) <boolean> \b true when \p mv exists in the list and
                \b false otherwise.

  \details

    When \p s == \b true, [search]\() is used to match elements. When
    \p s == false, find() is used.

  \amu_eval (${group_references})
*******************************************************************************/
function exists
(
  mv,
  v,
  s = true,
  i
) = (s == false) ? (find(mv, v, 1, i) != empty_lst)
  : (strip(search(mv, v, 1, i)) != empty_lst);

//! Test if an element exists at a specified index of an iterable value.
/***************************************************************************//**
  \param    i <integer> An element index.
  \param    v <iterable> An iterable value.

  \returns  (1) <boolean> \b true when the element \p v[i], exists and
                \b false otherwise.
            (2) Returns \b undef when \p i is not an number.

  \note     This functions does not consider the value of the element
            at the index position, but rather if an element exists at
            the index position \p i.
*******************************************************************************/
function exists_e
(
  i,
  v
) = !is_number( i ) ? undef
  : (i < 0) ? false
  : !is_iterable( v ) ? false
  : (len(v) > i);

//! Return the first element of an iterable value.
/***************************************************************************//**
  \param    v <iterable> An iterable value.

  \returns  (1) \<value> The first element of \p v.
            (2) Returns \b undef when \p v is not defined, is not
                iterable, or is empty.

  \details

  \note     Value may also be a range to obtain its \em start value.
*******************************************************************************/
function first( v ) = v[0];

//! Return the second element of an iterable value.
/***************************************************************************//**
  \param    v <iterable> An iterable value.

  \returns  (1) \<value> The second element of \p v.
            (2) Returns \b undef when \p v is not defined, is not
                iterable, or is empty.

  \details

  \note     Value may also be a range to obtain its \em step value.
*******************************************************************************/
function second( v ) = v[1];

//! Return the third element of an iterable value.
/***************************************************************************//**
  \param    v <iterable> An iterable value.

  \returns  (1) \<value> The second element of \p v.
            (2) Returns \b undef when \p v is not defined, is not
                iterable, or is empty.

  \details

  \note     Value may also be a range to obtain its \em end value.
*******************************************************************************/
function third( v ) = v[2];

//! Return the last element of an iterable value.
/***************************************************************************//**
  \param    v <iterable> An iterable value.

  \returns  (1) \<value> The last element of \p v.
            (2) Returns \b undef when \p v is not defined, is not
                iterable, or is empty.
*******************************************************************************/
function last
(
  v
) = !is_iterable(v) ? undef
  : v[len(v)-1];

//! Return the middle element of an iterable value.
/***************************************************************************//**
  \param    v <iterable> An iterable value.

  \returns  (1) \<value> The middle element of \p v.
            (2) Returns \b undef when \p v is not defined, is not
                iterable, or is empty.
*******************************************************************************/
function middle
(
  v
) = !is_iterable(v) ? undef
  : v[len(v)/2];

//! Return a list containing the first two elements of an iterable value.
/***************************************************************************//**
  \param    v <iterable> An iterable value.

  \returns  (1) \<list> A list containing the first two elements of \p v.
            (2) Returns \b undef when \p v is not defined, is not
                iterable, is empty or has less than two elements

  \details

  \note     Value may also be a range.
*******************************************************************************/
function first2
(
  v
) = !is_iterable(v) ? undef
  : (len(v) < 2) ? undef
  : [v[0], v[1]];

//! Return a list containing the first three elements of an iterable value.
/***************************************************************************//**
  \param    v <iterable> An iterable value.

  \returns  (1) \<list> A list containing the first three elements of \p v.
            (2) Returns \b undef when \p v is not defined, is not
                iterable, is empty, or has less than three elements.

  \details

  \note     Value may also be a range.
*******************************************************************************/
function first3
(
  v
) = !is_iterable(v) ? undef
  : (len(v) < 3) ? undef
  : [v[0], v[1], v[2]];

//! Return a list containing the last two elements of an iterable value.
/***************************************************************************//**
  \param    v <iterable> An iterable value.

  \returns  (1) \<list> A list containing the last two elements of \p v.
            (2) Returns \b undef when \p v is not defined, is not
                iterable, is empty, or has less than two elements.
*******************************************************************************/
function last2
(
  v
) = !is_iterable(v) ? undef
  : let( l = len(v) )
    (l < 2) ? undef
  : [v[l-2], v[l-1]];

//! Return a list containing the last three elements of an iterable value.
/***************************************************************************//**
  \param    v <iterable> An iterable value.

  \returns  (1) \<list> A list containing the last three elements of \p v.
            (2) Returns \b undef when \p v is not defined, is not
                iterable, is empty, or has less than three elements.
*******************************************************************************/
function last3
(
  v
) = !is_iterable(v) ? undef
  : let( l = len(v) )
    (l < 3) ? undef
  : [v[l-3], v[l-2], v[l-1]];

//! Return a list containing the first \p n elements of an iterable value.
/***************************************************************************//**
  \param    v <iterable> An iterable value.
  \param    n <integer> The element count.

  \returns  (1) \<list> A list containing the first \p n elements of \p v.
            (2) Returns \b undef when \p v is not defined, is not
              iterable, or is empty.

  \details

    When \p n is greater than the length of the iterable \p v, the list
    will stop at the last element of \p v.
*******************************************************************************/
function firstn
(
  v,
  n = 1
) = !is_iterable(v) ? undef
  : is_empty(v) ? undef
  : n < 1 ? empty_lst
  : let ( s = min(n-1, len(v)-1) )
    [for (i = [0 : s]) v[i]];

//! Return a list containing the last \p n elements of an iterable value.
/***************************************************************************//**
  \param    v <iterable> An iterable value.
  \param    n <integer> The element count.

  \returns  (1) \<list> A list containing the last \p n elements of \p v.
            (2) Returns \b undef when \p v is not defined, is not
                iterable, or is empty.

  \details

    When \p n is greater than the length of the iterable \p v, the list
    will start at the first element of \p v.
*******************************************************************************/
function lastn
(
  v,
  n = 1
) = !is_iterable(v) ? undef
  : is_empty(v) ? undef
  : n < 1 ? empty_lst
  : let ( s = max(0, len(v)-n) )
    [for (i = [s : len(v)-1]) v[i]];

//! Return a list containing all but the last \p n elements of an iterable value.
/***************************************************************************//**
  \param    v <iterable> An iterable value.
  \param    n <integer> The element count.

  \returns  (1) \<list> A list containing all but the last \p n
                elements of \p v.
            (2) Returns \b empty_lst when \p v contains fewer than \p n
                elements.
            (3) Returns \b undef when \p v is not defined, is not
                iterable, or is empty.
*******************************************************************************/
function headn
(
  v,
  n = 1
) = !is_iterable(v) ? undef
  : is_empty(v) ? undef
  : (n >= len(v)) ? empty_lst
  : let ( s = min(len(v)-1, len(v)-1-n) )
    [for (i = [0 : s]) v[i]];

//! Return a list containing all but the first \p n elements of an iterable value.
/***************************************************************************//**
  \param    v <iterable> An iterable value.
  \param    n <integer> The element count.

  \returns  (1) \<list> A list containing all but the first \p n
                elements of \p v.
            (2) Returns \b empty_lst when \p v contains fewer than \p n
                elements.
            (3) Returns \b undef when \p v is not defined, is not
                iterable, or is empty.
*******************************************************************************/
function tailn
(
  v,
  n = 1
) = !is_iterable(v) ? undef
  : is_empty(v) ? undef
  : (n >= len(v)) ? empty_lst
  : [for (i = [max(0, n) : len(v)-1]) v[i]];

//! Reverse the elements of an iterable value.
/***************************************************************************//**
  \param    v <iterable> An iterable value.

  \returns  (1) \<list> A list containing the elements of \p v in
                reversed order.
            (2) Returns \b empty_lst when \p v is empty.
            (3) Returns \b undef when \p v is not defined or is not iterable.
*******************************************************************************/
function reverse
(
  v
) = !is_iterable(v) ? undef
  : is_empty(v) ? empty_lst
  : [for (i = [len(v)-1 : -1 : 0]) v[i]];

//! Shift the elements of an iterable value.
/***************************************************************************//**
  \param    v <iterable> An iterable value.
  \param    n <integer> The element shift count.
  \param    r <boolean> Shift the elements to the right (or left).
  \param    c <boolean> Perform circular shift (or drop).

  \returns  (1) \<list> A list containing the elements of \p v shifted
                by \p n elements.
            (2) Returns \b undef when \p v is not defined or is not iterable.

  \details

    The shift count \p n may be positive or negative.
*******************************************************************************/
function shift
(
  v,
  n = 0,
  r = true,
  c = true
) = !is_iterable(v) ? undef
  : let
    (
      l = len(v),
      s = abs(n),           // absolute magnitude
      m = s % l,            // circular magnitude
      d = (n > 0) ? r : !r  // shift direction
    )
    // non-circular and shift greater than elements
    (c == false && s > l-1) ? empty_lst
    // shift direction
  : (d == true) ?
    // shift right
    [ if (m && c) for (i = [l-m : l-1]) v[i], for (i = [0 : l-1-m]) v[i] ]
    // shift left
  : [ for (i = [m : l-1]) v[i], if (m && c) for (i = [0 : m-1]) v[i] ];

//! Select a range of elements from an iterable value.
/***************************************************************************//**
  \param    v <iterable> An iterable value.
  \param    i <range | list | integer> The index selection.

  \returns  (1) \<list> A list containing the selected elements.
            (2) Returns \b undef when \p v is not defined, is not
                iterable, or when \p i does not map to an element of \p v.
            (3) Returns \b empty_lst when \p v is empty.
*******************************************************************************/
function select_r
(
  v,
  i
) = (!is_iterable(v) || !all_defined(i)) ? undef
  : is_empty(v) ? empty_lst
  : ( !is_number(i) && !is_list(i) && !is_range(i) ) ? undef
  : is_number(i) && !is_between(i, 0, len(v)-1) ? undef
  : is_list(i)  && ((min([for (y=i) y])<0) || (max([for (y=i) y])>(len(v)-1))) ? undef
  : is_range(i) && ((min([for (y=i) y])<0) || (max([for (y=i) y])>(len(v)-1))) ? undef
  : let ( s = is_number(i) ? [i] : i )
    [for (j = [for (k=s) k]) v[j]];

//! Return a list of all n-element sequential-subsets of an iterable value.
/***************************************************************************//**
  \param    v <iterable> An iterable value.
  \param    n <integer> The number of elements for each subset.
  \param    s <integer> The iteration step size.
  \param    w <boolean> Use wrap-at-end circular subset selection.

  \returns  (1) <list-list> A list of all n-element sequential subsets
                of \p v skipping \p s elements of \p v between each
                subset selection.
            (2) Returns \b empty_lst when \p v is empty, is not defined
                or is not iterable.

  \details

    \b Example
    \code{.C}
    v = [1, 2, 3, 4];

    sequence_ns( v, 3, 1, false ); // [ [1,2,3], [2,3,4] ]
    sequence_ns( v, 3, 1, true );  // [ [1,2,3], [2,3,4], [3,4,1], [4,1,2] ]
    \endcode
*******************************************************************************/
function sequence_ns
(
  v,
  n = 1,
  s = 1,
  w = false
) = is_empty(v) ? empty_lst
  : [
      for (i=[0 : s : (len(v)-((w == true) ? 1 : n)) ])
      [
        for (j=[i : (i+n-1)])
          v[j % len(v)]
      ]
    ];

//! Append a value to each element of an iterable value.
/***************************************************************************//**
  \param    nv \<value> A new value to append.
  \param    v <iterable> An iterable value.

  \param    r <boolean> Reduce list element before appending.
  \param    j <boolean> Join each appendage as a separate list.

  \param    l <boolean> Append new value to last element.

  \returns  (1) \<list> A list with \p nv appended to each element of \p v.
            (2) Returns \b undef when \p v is not defined or is not iterable.

  \details

    Appending with \p r == \b true causes each element of \p nv to be
    appended to the elements of each iterable value. When \p r == \b
    false, each element of \p nv is appended to the iterable value
    itself. To append a list of elements together as a list to \p v,
    enclose the elements of \p nv with a second set of brackets.

    \b Example
    \code{.C}
    v1=[["a"], ["b"], ["c"], ["d"]];
    v2=[1, 2, 3];

    echo( append_e( v2, v1 ) );
    echo( append_e( v2, v1, r=false ) );
    echo( append_e( v2, v1, j=false, l=false ) );
    \endcode

    \b Result
    \code{.C}
    ECHO: [["a", 1, 2, 3], ["b", 1, 2, 3], ["c", 1, 2, 3], ["d", 1, 2, 3]]
    ECHO: [[["a"], 1, 2, 3], [["b"], 1, 2, 3], [["c"], 1, 2, 3], [["d"], 1, 2, 3]]
    ECHO: ["a", 1, 2, 3, "b", 1, 2, 3, "c", 1, 2, 3, "d"]
    \endcode

*******************************************************************************/
function append_e
(
  nv,
  v,
  r = true,
  j = true,
  l = true
) = !is_iterable(v) ? undef
    // when 'v' is empty
  : is_empty(v) ? ((j == true) ? [concat(nv)] : concat(nv))
    // 'v' not empty
  : let
    ( // current element 'ce'
      ce = (r == true) ? first(v) : [first(v)]
    )
    // last element of 'v'
    (len(v) == 1) ?
      (
           (j == true  && l == true ) ? [concat(ce, nv)]
         : (j == true  && l == false) ? [ce]
         : (j == false && l == true ) ?  concat(ce, nv)
         :                               ce
      )
  : (j == true) ? concat( [concat(ce, nv)], append_e(nv, tailn(v), r, j, l) )
  :               concat(  concat(ce, nv) , append_e(nv, tailn(v), r, j, l) );

//! Insert a new value into an iterable value.
/***************************************************************************//**
  \param    nv \<value> A new value to insert.
  \param    v <iterable> An iterable value.

  \param    i <integer> The index insert position.

  \param    mv <list | string | value> Matched value candidates.
  \param    mi <integer> The matched selection index.

  \param    s <boolean> Element matching search method.
  \param    si <integer> The search element index when matching.

  \returns  (1) \<list> A list with \p nv inserted into \p v at the
                specified position.
            (2) Returns \b undef when no value of \p mv exists in
                \p v, when <tt>(mi + 1)</tt> exceeds the matched
                element count, when \p i does not map to an element of
                \p v, or when \p v is not defined or is not iterable.

  \details

    When \p s == \b true, [search]\() is used to match elements. When
    \p s == false, find() is used.

    The insert position can be specified by an index, an element match
    value, or list of potential match values. When multiple matches
    exists, \p mi indicates the insert position. When more than one
    insert position criteria is specified, the order of precedence is:
    (1) \p mv then (2) \p i. To insert a list of elements together as a
    list to \p v, enclose the elements of \p nv with a second set of
    brackets.

  \amu_eval (${group_references})
*******************************************************************************/
function insert
(
  nv,
  v,
  i = 0,
  mv,
  mi = 0,
  s = true,
  si
) = !is_iterable(v) ? undef
    // when 'v' is empty and 'i' or 'mv' specified
  : (is_empty(v) && ( (i != 0) || !is_undef(mv)) ) ? undef
    //  when 'v' is empty, simply return 'nv'
  : is_empty(v) ? concat(nv)
  : let
    ( // identify specified insert position 'p' or return undef
      p = is_defined(mv) ?
        // search for 'mv' in 'v' selecting 'mi'
        ( s == false )  ? find(mv, v, 0, si)[mi]
                        : merge_s(search(mv, v, 0, si), false)[mi]
        // using 'i'; element position 'i' must exists in 'v' or is undef
        : !is_between(i, 0, len(v)) ? undef
        : i,
      // generate result list head 'h'
      h = ( !is_undef(p) && (p>0) ) ? [for (j = [0 : p-1]) v[j]] : empty_lst,
      // generate result list tail 't'
      t = ( is_undef(p) || (p>len(v)-1) ) ? empty_lst : [for (j = [p : len(v)-1]) v[j]]
    )
    // result valid iff a valid insert position was specified
    is_undef(p) ? undef : concat(h, nv, t);

//! Delete elements from an iterable value.
/***************************************************************************//**
  \param    v <iterable> An iterable value.

  \param    i <range | list | integer> Deletion Indexes.

  \param    mv <list | string | value> Matched value candidates.
  \param    mc <integer> A match count.
            For <tt>(mc>=1)</tt>, remove the first \p mc matches.
            For <tt>(mc<=0)</tt>, remove all matches.

  \param    s <boolean> Element matching search method.
  \param    si <integer> The element column index when matching.

  \returns  (1) \<list> A list with all specified elements removed.
            (2) Returns \b undef when \p i does not map to an element
                of \p v, when \p v is not defined, or is not iterable.


  \details

    When \p s == \b true, [search]\() is used to match elements. When
    \p s == false, find() is used.

    The elements to delete can be specified by an index position, a
    list of index positions, an index range, an element match value, or
    a list of element match values (when using [search]\()). When \p mv
    is a list of match values, all values of \p mv that exists in \p v
    are candidates for deletion. For each matching candidate, \p mc
    indicates the quantity to remove. When more than one deletion
    criteria is specified, the order of precedence is: (1) \p mv then
    (2) \p i.

  \amu_eval (${group_references})
*******************************************************************************/
function delete
(
  v,
  i,
  mv,
  mc = 1,
  s = true,
  si
) = !is_iterable(v) ? undef
    // nothing to delete
  : is_empty(v) ? empty_lst
    // for 'i' a number, list or range; each indexed position must exists in 'v'
  : is_number(i) && !is_between(i, 0, len(v)-1) ? undef
  : is_list(i)  && ((min([for (y=i) y])<0) || (max([for (y=i) y])>(len(v)-1))) ? undef
  : is_range(i) && ((min([for (y=i) y])<0) || (max([for (y=i) y])>(len(v)-1))) ? undef
  : let
    ( // identify specified deletion position(s) 'p' or return undef
      p = is_defined(mv) ?
        // search for 'mv' in 'v' selecting 'mi'
        ( s == false ) ? find(mv, v, mc, si)
                       : merge_s(search(mv, v, mc, si), false)
        // using 'i'; for single number, format as list
        : is_number(i) ? [i]
        // using 'i';  pass list as specified
        : is_list(i) ? i
        // using 'i';  enumerate range to list
        : is_range(i) ? [for (y=i) y]
        : undef
    )
    [ // output only elements of 'v' that do not exists in 'p'
      for (j = [0 : len(v)-1])
        if (is_empty(find(j, p))) v[j]
    ];

//! Strip all matching values from an iterable value.
/***************************************************************************//**
  \param    v <iterable> An iterable value.
  \param    mv \<value> A match value.

  \returns  (1) \<list> The list 'v' with all elements equal \p mv removed.
            (2) Returns \b undef when \p v is not defined or is not iterable.
*******************************************************************************/
function strip
(
  v,
  mv = empty_lst
) = !is_iterable(v) ? undef
  : is_empty(v) ? empty_lst
  : (first(v) == mv) ? concat(strip(tailn(v), mv))
  : concat(firstn(v), strip(tailn(v), mv));

//! Apply a binary mask to an interable value.
/***************************************************************************//**
  \param    v <iterable> An iterable value.
  \param    m <iterable> A binary mask.
  \param    r <boolean> Right align the mask to \p v value.
  \param    o <integer> A positive or negative mask offset.
  \param    u \<value> The value assigned to elements of the mask that
              does not exists or are undefined in \p v.
  \param    z \<value> The value assigned to masked elements.

  \returns  (1) \<value> A list containing the masked values of \p v.
            (2) Returns \b v as a list when \p m is not defined.
            (3) Returns \p undef when \p m is not iterable or contains
                values other than zero or one.

  \details

    This mask may be specified as a list or string and is composed of
    ones and zeros. One indicates that an element value of \p v is
    passed and a zero indicates that a value of \p v is to be replaced
    with \p z.
*******************************************************************************/
function mask
(
  v,
  m,
  r = false,
  o = 0,
  u = undef,
  z = 0
) = is_undef(m) ? headn(v, 0)
    // if defined, 'm' must be iterable
  : !is_iterable(m) ? undef
    // string mask may only include "01"
  : is_string(m) && !is_empty(delete(m, mv="01", mc=0)) ? undef
    // list mask may only include [0, 1]
  : is_list(m) && !is_empty(delete(m, mv=[0,1], mc=0)) ? undef
  : let
    ( // calculate the mask base offset
      l = is_iterable(v) ? len(v) : 0,
      j = ((r == true) ? l - len(m) : 0) + o
    )
    [
      for (i = [0 : len(m)-1])
        (m[i] == 1 || m[i] == "1") ? defined_e_or(v, i+j, u)
                                   : exists_e(i+j, v) ? z : u
    ];

//! Return a list of the unique elements of an iterable value.
/***************************************************************************//**
  \param    v <iterable> An iterable value.

  \returns  (1) \<list> A list of unique elements with order preserved.
            (2) Returns \b undef when \p v is not defined or is not
                iterable.

  \warning  Any and all list elements of \p v that have the value of \b
            undef are ignored and is not considered to be a unique.
*******************************************************************************/
function unique
(
  v
) = is_undef(v) ? empty_lst
  : !is_iterable(v) ? [v]
    // handled empty list or empty string
  : (len(v) == 0) ? empty_lst
  // last element. filter case where first element of list is [undef]
  : (len(v) == 1) ? (v == [undef]) ? empty_lst : headn(v, 0)
    // set s=false to use find() for single element matching
  : exists(last(v), headn(v), s=false) ? unique(headn(v))
  : concat(unique(headn(v)), lastn(v));


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

    function fmt( id, td, v1, v2, v3 ) = table_validate_fmt(id, td, v1, v2, v3);
    function v1(db, id) = table_validate_get_v1(db, id);
    t = true; f = false; u = undef; s = validation_skip;

    tbl_test_values =
    [
      fmt("t01", "The undefined value",       undef),
      fmt("t02", "The empty list",            empty_lst),
      fmt("t03", "A long range",              [0:0.5:9]),
      fmt("t04", "string = (A string)",       "A string"),
      fmt("t05", "List-4 fruit",              ["orange","apple","grape","banana"]),
      fmt("t06", "List-7 characters",         ["b","a","n","a","n","a","s"]),
      fmt("t07", "List-1 undefined",          [undef]),
      fmt("t08", "List-2 integers-2",         [[1,2],[2,3]]),
      fmt("t09", "List-4 iterable-2",         ["ab",[1,2],[2,3],[4,5]]),
      fmt("t10", "List-4  iterable-3",        [[1,2,3],[4,5,6],[7,8,9],["a","b","c"]]),
      fmt("t11", "List-15 of integers",       [for (i=[0:15]) i])
    ];

    tbl_test_answers =
    [
      ["defined_e_or_DE3",
        "default",                                          // t01
        "default",                                          // t02
        "default",                                          // t03
        "t",                                                // t04
        "banana",                                           // t05
        "a",                                                // t06
        "default",                                          // t07
        "default",                                          // t08
        [4,5],                                              // t09
        ["a","b","c"],                                      // t10
        3                                                   // t11
      ],
      ["find_12",
        empty_lst,                                          // t01
        empty_lst,                                          // t02
        empty_lst,                                          // t03
        empty_lst,                                          // t04
        empty_lst,                                          // t05
        empty_lst,                                          // t06
        empty_lst,                                          // t07
        [0],                                                // t08
        [1],                                                // t09
        empty_lst,                                          // t10
        empty_lst                                           // t11
      ],
      ["count_S1",
        0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1
      ],
      ["exists_S1",
        f, f, f, f, f, f, f, t, t, t, t
      ],
      ["exists_e_5",
        f, f, f, t, f, t, f, f, f, f, t
      ],
      ["first",
        undef,                                              // t01
        undef,                                              // t02
        0,                                                  // t03
        "A",                                                // t04
        "orange",                                           // t05
        "b",                                                // t06
        undef,                                              // t07
        [1,2],                                              // t08
        "ab",                                               // t09
        [1,2,3],                                            // t10
        0                                                   // t11
      ],
      ["second",
        undef,                                              // t01
        undef,                                              // t02
        0.5,                                                // t03
        " ",                                                // t04
        "apple",                                            // t05
        "a",                                                // t06
        undef,                                              // t07
        [2,3],                                              // t08
        [1,2],                                              // t09
        [4,5,6],                                            // t10
        1                                                   // t11
      ],
      ["third",
        undef,                                              // t01
        undef,                                              // t02
        9,                                                  // t03
        "s",                                                // t04
        "grape",                                            // t05
        "n",                                                // t06
        undef,                                              // t07
        undef,                                              // t08
        [2,3],                                              // t09
        [7,8,9],                                            // t10
        2                                                   // t11
      ],
      ["last",
        undef,                                              // t01
        undef,                                              // t02
        undef,                                              // t03
        "g",                                                // t04
        "banana",                                           // t05
        "s",                                                // t06
        undef,                                              // t07
        [2,3],                                              // t08
        [4,5],                                              // t09
        ["a","b","c"],                                      // t10
        15                                                  // t11
      ],
      ["middle",
        undef,                                              // t01
        undef,                                              // t02
        undef,                                              // t03
        "r",                                                // t04
        "grape",                                            // t05
        "a",                                                // t06
        undef,                                              // t07
        [2,3],                                              // t08
        [2,3],                                              // t09
        [7,8,9],                                            // t10
        8                                                   // t11
      ],
      ["first2",
        undef,                                              // t01
        undef,                                              // t02
        undef,                                              // t03
        ["A"," "],                                          // t04
        ["orange","apple"],                                 // t05
        ["b","a"],                                          // t06
        undef,                                              // t07
        [[1,2],[2,3]],                                      // t08
        ["ab", [1,2]],                                      // t09
        [[1,2,3],[4,5,6]],                                  // t10
        [0,1]                                               // t11
      ],
      ["first3",
        undef,                                              // t01
        undef,                                              // t02
        undef,                                              // t03
        ["A"," ","s"],                                      // t04
        ["orange","apple","grape"],                         // t05
        ["b","a","n"],                                      // t06
        undef,                                              // t07
        undef,                                              // t08
        ["ab", [1,2],[2,3]],                                // t09
        [[1,2,3],[4,5,6],[7,8,9]],                          // t10
        [0,1,2]                                             // t11
      ],
      ["last2",
        undef,                                              // t01
        undef,                                              // t02
        undef,                                              // t03
        ["n","g"],                                          // t04
        ["grape","banana"],                                 // t05
        ["a","s"],                                          // t06
        undef,                                              // t07
        [[1,2],[2,3]],                                      // t08
        [[2,3], [4,5]],                                     // t09
        [[7,8,9],["a","b","c"]],                            // t10
        [14,15]                                             // t11
      ],
      ["last3",
        undef,                                              // t01
        undef,                                              // t02
        undef,                                              // t03
        ["i","n","g"],                                      // t04
        ["apple","grape","banana"],                         // t05
        ["n","a","s"],                                      // t06
        undef,                                              // t07
        undef,                                              // t08
        [[1,2],[2,3],[4,5]],                                // t09
        [[4,5,6],[7,8,9],["a","b","c"]],                    // t10
        [13,14,15]                                          // t11
      ],
      ["firstn_1",
        undef,                                              // t01
        undef,                                              // t02
        undef,                                              // t03
        ["A"],                                              // t04
        ["orange"],                                         // t05
        ["b"],                                              // t06
        [undef],                                            // t07
        [[1,2]],                                            // t08
        ["ab"],                                             // t09
        [[1,2,3]],                                          // t10
        [0]                                                 // t11
      ],
      ["lastn_1",
        undef,                                              // t01
        undef,                                              // t02
        undef,                                              // t03
        ["g"],                                              // t04
        ["banana"],                                         // t05
        ["s"],                                              // t06
        [undef],                                            // t07
        [[2,3]],                                            // t08
        [[4,5]],                                            // t09
        [["a","b","c"]],                                    // t10
        [15]                                                // t11
      ],
      ["headn_1",
        undef,                                              // t01
        undef,                                              // t02
        undef,                                              // t03
        ["A"," ","s","t","r","i","n"],                      // t04
        ["orange","apple","grape"],                         // t05
        ["b","a","n","a","n","a"],                          // t06
        empty_lst,                                          // t07
        [[1,2]],                                            // t08
        ["ab",[1,2],[2,3]],                                 // t09
        [[1,2,3],[4,5,6],[7,8,9]],                          // t10
        [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14]                // t11
      ],
      ["tailn_1",
        undef,                                              // t01
        undef,                                              // t02
        undef,                                              // t03
        [" ","s","t","r","i","n","g"],                      // t04
        ["apple","grape","banana"],                         // t05
        ["a","n","a","n","a","s"],                          // t06
        empty_lst,                                          // t07
        [[2,3]],                                            // t08
        [[1,2],[2,3],[4,5]],                                // t09
        [[4,5,6],[7,8,9],["a","b","c"]],                    // t10
        [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]               // t11
      ],
      ["reverse",
        undef,                                              // t01
        empty_lst,                                          // t02
        undef,                                              // t03
        ["g","n","i","r","t","s"," ","A"],                  // t04
        ["banana","grape","apple","orange"],                // t05
        ["s","a","n","a","n","a","b"],                      // t06
        [undef],                                            // t07
        [[2,3],[1,2]],                                      // t08
        [[4,5],[2,3],[1,2],"ab"],                           // t09
        [["a","b","c"],[7,8,9],[4,5,6],[1,2,3]],            // t10
        [15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0]             // t11
      ],
      ["shift_r1",
        undef,                                              // t01
        empty_lst,                                          // t02
        undef,                                              // t03
        ["g","A"," ","s","t","r","i","n"],                  // t04
        ["banana","orange","apple","grape"],                // t05
        ["s","b","a","n","a","n","a"],                      // t06
        [undef],                                            // t07
        [[2,3],[1,2]],                                      // t08
        [[4,5],"ab",[1,2],[2,3]],                           // t09
        [["a","b","c"],[1,2,3],[4,5,6],[7,8,9]],            // t10
        [15,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14]             // t11
      ],
      ["shift_l1",
        undef,                                              // t01
        empty_lst,                                          // t02
        undef,                                              // t03
        [" ","s","t","r","i","n","g","A"],                  // t04
        ["apple","grape","banana","orange"],                // t05
        ["a","n","a","n","a","s","b"],                      // t06
        [undef],                                            // t07
        [[2,3],[1,2]],                                      // t08
        [[1,2],[2,3],[4,5],"ab"],                           // t09
        [[4,5,6],[7,8,9],["a","b","c"],[1,2,3]],            // t10
        [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0]             // t11
      ],
      ["select_r_02",
        undef,                                              // t01
        empty_lst,                                          // t02
        undef,                                              // t03
        ["A"," ","s"],                                      // t04
        ["orange","apple","grape"],                         // t05
        ["b","a","n"],                                      // t06
        undef,                                              // t07
        undef,                                              // t08
        ["ab",[1,2],[2,3]],                                 // t09
        [[1,2,3],[4,5,6],[7,8,9]],                          // t10
        [0,1,2]                                             // t11
      ],
      ["sequence_ns_31",
        empty_lst,                                          // t01
        empty_lst,                                          // t02
        empty_lst,                                          // t03
        [
          ["A"," ","s"],[" ","s","t"],["s","t","r"],
          ["t","r","i"],["r","i","n"],["i","n","g"]
        ],                                                  // t04
        [
          ["orange","apple","grape"],
          ["apple","grape","banana"]
        ],                                                  // t05
        [
          ["b","a","n"],["a","n","a"],["n","a","n"],
          ["a","n","a"],["n","a","s"]
        ],                                                  // t06
        empty_lst,                                          // t07
        empty_lst,                                          // t08
        [["ab",[1,2],[2,3]],[[1,2],[2,3],[4,5]]],           // t09
        [
          [[1,2,3],[4,5,6],[7,8,9]],
          [[4,5,6],[7,8,9],["a","b","c"]]
        ],                                                  // t10
        [
          [0,1,2],[1,2,3],[2,3,4],[3,4,5],[4,5,6],[5,6,7],
          [6,7,8],[7,8,9],[8,9,10],[9,10,11],[10,11,12],
          [11,12,13],[12,13,14],[13,14,15]
        ]                                                   // t11
      ],
      ["append_e_T0",
        undef,                                              // t01
        [[0]],                                              // t02
        undef,                                              // t03
        [
          ["A",0],[" ",0],["s",0],["t",0],
          ["r",0],["i",0],["n",0],["g",0]
        ],                                                  // t04
        [
          ["orange",0],["apple",0],
          ["grape",0],["banana",0]
        ],                                                  // t05
        [
          ["b",0],["a",0],["n",0],["a",0],
          ["n",0],["a",0],["s",0]
        ],                                                  // t06
        [[undef,0]],                                        // t07
        [[1,2,0],[2,3,0]],                                  // t08
        [["ab",0],[1,2,0],[2,3,0],[4,5,0]],                 // t09
        [[1,2,3,0],[4,5,6,0],[7,8,9,0],["a","b","c",0]],    // t10
        [
          [0,0],[1,0],[2,0],[3,0],[4,0],[5,0],
          [6,0],[7,0],[8,0],[9,0],[10,0],[11,0],
          [12,0],[13,0],[14,0],[15,0]
        ]                                                   // t11
      ],
      ["insert_T0",
        undef,                                              // t01
        undef,                                              // t02
        undef,                                              // t03
        undef,                                              // t04
        ["orange",0,"apple","grape","banana"],              // t05
        ["b","a","n","a","n","a",0,"s"],                    // t06
        undef,                                              // t07
        [[1,2],0,[2,3]],                                    // t08
        ["ab",[1,2],0,[2,3],[4,5]],                         // t09
        undef,                                              // t10
        [0,1,2,3,4,0,5,6,7,8,9,10,11,12,13,14,15]           // t11
      ],
      ["delete_T0",
        undef,                                              // t01
        empty_lst,                                          // t02
        undef,                                              // t03
        ["A"," ","s","t","r","i","n","g"],                  // t04
        ["orange","grape","banana"],                        // t05
        ["b","a","n","a","n","a"],                          // t06
        [undef],                                            // t07
        [[1,2]],                                            // t08
        ["ab",[1,2],[4,5]],                                 // t09
        [[1,2,3],[4,5,6],[7,8,9],["a","b","c"]],            // t10
        [0,1,2,3,4,6,7,8,9,10,11,12,13,14,15]               // t11
      ],
      ["strip",
        undef,                                              // t01
        empty_lst,                                          // t02
        undef,                                              // t03
        ["A"," ","s","t","r","i","n","g"],                  // t04
        ["orange","apple","grape","banana"],                // t05
        ["b","a","n","a","n","a","s"],                      // t06
        [undef],                                            // t07
        [[1,2],[2,3]],                                      // t08
        ["ab",[1,2],[2,3],[4,5]],                           // t09
        [[1,2,3],[4,5,6],[7,8,9],["a","b","c"]],            // t10
        [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]             // t11
      ],
      ["mask_01R",
        [undef,undef],                                      // t01
        [undef,undef],                                      // t02
        [undef,undef],                                      // t03
        [0,"g"],                                            // t04
        [0,"banana"],                                       // t05
        [0,"s"],                                            // t06
        [undef,undef],                                      // t07
        [0,[2,3]],                                          // t08
        [0,[4,5]],                                          // t09
        [0,["a","b","c"]],                                  // t10
        [0,15]                                              // t11
      ],
      ["unique",
        empty_lst,                                          // t01
        empty_lst,                                          // t02
        [[0:0.5:9]],                                        // t03
        ["A"," ","s","t","r","i","n","g"],                  // t04
        ["orange","apple","grape","banana"],                // t05
        ["b","a","n","s"],                                  // t06
        empty_lst,                                          // t07
        [[1,2],[2,3]],                                      // t08
        ["ab",[1,2],[2,3],[4,5]],                           // t09
        [[1,2,3],[4,5,6],[7,8,9],["a","b","c"]],            // t10
        [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]             // t11
      ]
    ];

    db = table_validate_init( tbl_test_values, tbl_test_answers );

    table_validate_start( db );
    test_ids = table_validate_get_ids( db );

    for (id=test_ids) table_validate( db, id, "defined_e_or_DE3", 1, defined_e_or( v1(db,id), 3, "default" ) );
    for (id=test_ids) table_validate( db, id, "defined_e_or_DE3", 1, defined_eon_or( v1(db,id), 3, "default" ) );
    for (id=test_ids) table_validate( db, id, "find_12", 1, find( [1,2], v1(db,id) ) );
    for (id=test_ids) table_validate( db, id, "count_S1", 1, count( 1, v1(db,id), true ) );
    for (id=test_ids) table_validate( db, id, "exists_S1", 1, exists( 1, v1(db,id), true ) );
    for (id=test_ids) table_validate( db, id, "exists_e_5", 1, exists_e( 5, v1(db,id )) );
    for (id=test_ids) table_validate( db, id, "first", 1, first( v1(db,id) ) );
    for (id=test_ids) table_validate( db, id, "second", 1, second( v1(db,id) ) );
    for (id=test_ids) table_validate( db, id, "third", 1, third( v1(db,id) ) );
    for (id=test_ids) table_validate( db, id, "last", 1, last( v1(db,id) ) );
    for (id=test_ids) table_validate( db, id, "middle", 1, middle( v1(db,id) ) );
    for (id=test_ids) table_validate( db, id, "first2", 1, first2( v1(db,id) ) );
    for (id=test_ids) table_validate( db, id, "first3", 1, first3( v1(db,id) ) );
    for (id=test_ids) table_validate( db, id, "last2", 1, last2( v1(db,id) ) );
    for (id=test_ids) table_validate( db, id, "last3", 1, last3( v1(db,id) ) );
    for (id=test_ids) table_validate( db, id, "firstn_1", 1, firstn( v1(db,id), n=1 ) );
    for (id=test_ids) table_validate( db, id, "lastn_1", 1, lastn( v1(db,id), n=1 ) );
    for (id=test_ids) table_validate( db, id, "headn_1", 1, headn( v1(db,id), n=1 ) );
    for (id=test_ids) table_validate( db, id, "tailn_1", 1, tailn( v1(db,id), n=1 ) );
    for (id=test_ids) table_validate( db, id, "reverse", 1, reverse( v1(db,id) ) );
    for (id=test_ids) table_validate( db, id, "shift_r1", 1, shift( v1(db,id), n=1, r=true ) );
    for (id=test_ids) table_validate( db, id, "shift_l1", 1, shift( v1(db,id), n=1, r=false ) );
    for (id=test_ids) table_validate( db, id, "select_r_02", 1, select_r( v1(db,id), i=[0:2] ) );
    for (id=test_ids) table_validate( db, id, "sequence_ns_31", 1, sequence_ns( v1(db,id), n=3, s=1 ) );
    for (id=test_ids) table_validate( db, id, "append_e_T0", 1, append_e( 0, v1(db,id) ) );
    for (id=test_ids) table_validate( db, id, "insert_T0", 1, insert( 0, v1(db,id), mv=["x","r","apple","s",[2,3],5] ) );
    for (id=test_ids) table_validate( db, id, "delete_T0", 1, delete( v1(db,id), mv=["x","r","apple","s",[2,3],5] ) );
    for (id=test_ids) table_validate( db, id, "strip", 1, strip( v1(db,id) ) );
    for (id=test_ids) table_validate( db, id, "mask_01R", 1, mask( v1(db,id), [0,1], r=true ) );
    for (id=test_ids) table_validate( db, id, "unique", 1, unique( v1(db,id) ) );

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
