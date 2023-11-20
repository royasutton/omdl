//! Iterable data type operations.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2015-2023

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
function edefined_or
(
  v,
  i,
  d
) = !is_iterable(v) ? d
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
  : len(smerge(search(mv, v, 0, i)));

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
            (2) Returns \b undef when \p i is not an integer.

  \note     This functions does not consider the value of the element
            at the index position, but rather if an element exists at
            the index position \p i.
*******************************************************************************/
function eexists
(
  i,
  v
) = !is_integer( i ) ? undef
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
function nfirst
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
function nlast
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
function nhead
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
function ntail
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
  \param    i <range|list|integer> The index selection.

  \returns  (1) \<list> A list containing the selected elements.
            (2) Returns \b undef when \p v is not defined, is not
                iterable, or when \p i does not map to an element of \p v.
            (3) Returns \b empty_lst when \p v is empty.
*******************************************************************************/
function rselect
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

    nssequence( v, 3, 1, false ); // [ [1,2,3], [2,3,4] ]
    nssequence( v, 3, 1, true );  // [ [1,2,3], [2,3,4], [3,4,1], [4,1,2] ]
    \endcode
*******************************************************************************/
function nssequence
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

    echo( eappend( v2, v1 ) );
    echo( eappend( v2, v1, r=false ) );
    echo( eappend( v2, v1, j=false, l=false ) );
    \endcode

    \b Result
    \code{.C}
    ECHO: [["a", 1, 2, 3], ["b", 1, 2, 3], ["c", 1, 2, 3], ["d", 1, 2, 3]]
    ECHO: [[["a"], 1, 2, 3], [["b"], 1, 2, 3], [["c"], 1, 2, 3], [["d"], 1, 2, 3]]
    ECHO: ["a", 1, 2, 3, "b", 1, 2, 3, "c", 1, 2, 3, "d"]
    \endcode

*******************************************************************************/
function eappend
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
  : (j == true) ? concat( [concat(ce, nv)], eappend(nv, ntail(v), r, j, l) )
  :               concat(  concat(ce, nv) , eappend(nv, ntail(v), r, j, l) );

//! Insert a new value into an iterable value.
/***************************************************************************//**
  \param    nv \<value> A new value to insert.
  \param    v <iterable> An iterable value.

  \param    i <integer> The index insert position.

  \param    mv <list|string|value> Matched value candidates.
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
                        : smerge(search(mv, v, 0, si), false)[mi]
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

  \param    i <range|list|integer> Deletion Indexes.

  \param    mv <list|string|value> Matched value candidates.
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
                       : smerge(search(mv, v, mc, si), false)
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
  : (first(v) == mv) ? concat(strip(ntail(v), mv))
  : concat(nfirst(v), strip(ntail(v), mv));

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
) = is_undef(m) ? nhead(v, 0)
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
        (m[i] == 1 || m[i] == "1") ? edefined_or(v, i+j, u)
                                   : eexists(i+j, v) ? z : u
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
  : (len(v) == 1) ? (v == [undef]) ? empty_lst : nhead(v, 0)
    // set s=false to use find() for single element matching
  : exists(last(v), nhead(v), s=false) ? unique(nhead(v))
  : concat(unique(nhead(v)), nlast(v));


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

    test_ids = table_get_row_ids( test_r );

    // expected columns: ("id" + one column for each test)
    good_c = pmerge([concat("id", test_ids), concat("identifier", test_ids)]);

    // expected rows: ("golden" test results), use 's' to skip test
    skip = -1;  // skip test

    good_r =
    [ // function
      ["edefined_or_DE3",
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
        0,                                                  // t01
        0,                                                  // t02
        0,                                                  // t03
        0,                                                  // t04
        0,                                                  // t05
        0,                                                  // t06
        0,                                                  // t07
        1,                                                  // t08
        1,                                                  // t09
        1,                                                  // t10
        1                                                   // t11
      ],
      ["exists_S1",
        false,                                              // t01
        false,                                              // t02
        false,                                              // t03
        false,                                              // t04
        false,                                              // t05
        false,                                              // t06
        false,                                              // t07
        true,                                               // t08
        true,                                               // t09
        true,                                               // t10
        true                                                // t11
      ],
      ["eexists_5",
        false,                                              // t01
        false,                                              // t02
        false,                                              // t03
        true,                                               // t04
        false,                                              // t05
        true,                                               // t06
        false,                                              // t07
        false,                                              // t08
        false,                                              // t09
        false,                                              // t10
        true                                                // t11
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
      ["nfirst_1",
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
      ["nlast_1",
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
      ["nhead_1",
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
      ["ntail_1",
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
      ["rselect_02",
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
      ["nssequence_31",
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
      ["eappend_T0",
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

    // sanity-test tables
    table_check( test_r, test_c, false );
    table_check( good_r, good_c, false );

    // validate helper function and module
    function get_value( vid ) = table_get_value(test_r, test_c, vid, "tv");
    module log_test( m ) { log_type ( "test", m ); }
    module log_skip( f ) { log_test ( str("ignore: '", f, "'") ); }
    module run_test( fname, fresult, vid )
    {
      value_text = table_get_value(test_r, test_c, vid, "td");
      pass_value = table_get_value(good_r, good_c, fname, vid);

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
    for (vid=test_ids) run_test( "edefined_or_DE3", edefined_or(get_value(vid),3,"default"), vid );
    for (vid=test_ids) run_test( "find_12", find([1,2],get_value(vid)), vid );
    for (vid=test_ids) run_test( "count_S1", count(1,get_value(vid),true), vid );
    for (vid=test_ids) run_test( "exists_S1", exists(1,get_value(vid),true), vid );
    for (vid=test_ids) run_test( "eexists_5", eexists(5,get_value(vid)), vid );
    for (vid=test_ids) run_test( "first", first(get_value(vid)), vid );
    for (vid=test_ids) run_test( "second", second(get_value(vid)), vid );
    for (vid=test_ids) run_test( "third", third(get_value(vid)), vid );
    for (vid=test_ids) run_test( "last", last(get_value(vid)), vid );
    log_skip( "middle()" );
    log_skip( "first2()" );
    log_skip( "first3()" );
    log_skip( "last2()" );
    log_skip( "last3()" );
    for (vid=test_ids) run_test( "nfirst_1", nfirst(get_value(vid),n=1), vid );
    for (vid=test_ids) run_test( "nlast_1", nlast(get_value(vid),n=1), vid );
    for (vid=test_ids) run_test( "nhead_1", nhead(get_value(vid),n=1), vid );
    for (vid=test_ids) run_test( "ntail_1", ntail(get_value(vid),n=1), vid );
    for (vid=test_ids) run_test( "reverse", reverse(get_value(vid)), vid );
    for (vid=test_ids) run_test( "shift_r1", shift(get_value(vid),n=1,r=true), vid );
    for (vid=test_ids) run_test( "shift_l1", shift(get_value(vid),n=1,r=false), vid );
    for (vid=test_ids) run_test( "rselect_02", rselect(get_value(vid),i=[0:2]), vid );
    for (vid=test_ids) run_test( "nssequence_31", nssequence(get_value(vid),n=3,s=1), vid );
    for (vid=test_ids) run_test( "eappend_T0", eappend(0,get_value(vid)), vid );
    for (vid=test_ids) run_test( "insert_T0", insert(0,get_value(vid),mv=["x","r","apple","s",[2,3],5]), vid );
    for (vid=test_ids) run_test( "delete_T0", delete(get_value(vid),mv=["x","r","apple","s",[2,3],5]), vid );
    for (vid=test_ids) run_test( "strip", strip(get_value(vid)), vid );
    for (vid=test_ids) run_test( "mask_01R", mask(get_value(vid),[0,1],r=true), vid );
    for (vid=test_ids) run_test( "unique", unique(get_value(vid)), vid );

    // end-of-tests
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {config_base,config_term}.mfs;
    include --path "${INCLUDE_PATH}" script_std.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
