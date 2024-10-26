//! List data type operations.
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

    \amu_define group_name  (List Operations)
    \amu_define group_brief (Operations for list data types.)

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

//! Convert a list of values to a concatenated string.
/***************************************************************************//**
  \param    v \<list> A list of values.

  \returns  (1) <string> Constructed by converting each element of the
                list to a string and concatenating them together.
            (2) Returns \b undef when the list is not defined.

  \details

    \b Example
    \code{.C}
    v1=["a", "b", "c", "d"];
    v2=[1, 2, 3];

    echo( strl(concat(v1, v2)) );
    \endcode

    \b Result
    \code{.C}
    ECHO: "abcd123"
    \endcode
*******************************************************************************/
function strl
(
  v
) = is_undef(v) ? undef
  : !is_iterable(v) ? str(v)
  : is_empty(v) ? empty_str
  : (len(v) == 1) ? str(first(v))
  : str(first(v), strl(tailn(v)));

//! Convert a list of values to a concatenated HTML-formatted string.
/***************************************************************************//**
  \param    v \<list> A list of values.

  \param    b <tag-list-list> A list of tag lists.
              \em Unpaired HTML [tag(s)] to add before the value.
  \param    p <tag-list-list> A list of tag lists.
              \em Paired HTML [tag(s)] to enclose the value.
  \param    a <tag-list-list> A list of tag lists.
              \em Unpaired HTML [tag(s)] to add after the value.

  \param    f <attr-list-list> A list of tag attribute lists for \c fs,
              where  <tt>fs=["color","size","face"]</tt> is the font
              tag to enclose the value. Not all attributes are
              required, but the order is significant.

  \param    d <boolean> Debug. When \b true angle brackets are replaced
              with curly brackets to prevent console decoding.

  \returns  (1) <string> Constructed by converting each element of the
                list to a string with specified HTML markup and
                concatenating.
            (2) Returns \b empty_str when the list is empty or is not
                defined.

  \details

    When there are fewer tag lists in \p b, \p p, \p a, or \p f, than
    there are value elements in \p v, the last specified tag list is
    used for all subsequent value elements.

    For a list of the \em paired and \em unpaired HTML tags supported
    by the console see: [HTML subset].

    \b Example
    \code{.C}
    echo( strl_html(v="bold text", p="b", d=true) );
    echo( strl_html(v=[1,"x",3], f=[["red",6,"helvetica"],undef,["blue",10,"courier"]], d=true) );

    v = ["result", "=", "mc", "2"];
    b = ["hr", undef];
    p = ["i", undef, ["b", "i"], ["b","sup"]];
    a = concat(consts(3, u=true), "hr");
    f = [undef, ["red"], undef, ["blue",4]];

    echo( strl_html(v=v, b=b, p=p, a=a, f=f, d=true) );
    \endcode

    \b Result
    \code{.C}
    ECHO: "{b}bold text{/b}"
    ECHO: "{font color="red" size="6" face="helvetica"}1{/font}x{font color="blue" size="10" face="courier"}3{/font}"
    ECHO: "{hr}{i}result{/i}{font color="red"}={/font}{b}{i}mc{/i}{/b}{b}{sup}{font color="blue" size="4"}2{/font}{/sup}{/b}{hr}"
    \endcode

    [tag(s)]: http://doc.qt.io/qt-5/richtext-html-subset.html
    [HTML subset]: http://doc.qt.io/qt-5/richtext-html-subset.html
*******************************************************************************/
function strl_html
(
  v,          // value
  b,          // before
  p,          // pair
  a,          // after
  f,          // fs
  d = false   // debug
) = is_undef(v) ? empty_str
  : is_empty(v) ? empty_str
  : let
    ( // brackets or debug
      bb = (d == true) ? "{" : "<",
      ba = (d == true) ? "}" : ">",

      // current element is first
      cv = is_list(v) ? firstn(v) : v,
      cb = is_list(b) ?  first(b) : b,
      cp = is_list(p) ?  first(p) : p,
      ca = is_list(a) ?  first(a) : a,
      cf = is_list(f) ?  first(f) : f,

      // close pair lists in reverse order
      rp = is_list(cp) ? reverse(cp) : cp,

      // font attributes
      f0 = exists_e(0,cf) ? str(" color=\"", cf[0], "\"") : empty_str,
      f1 = exists_e(1,cf) ? str(" size=\"",  cf[1], "\"") : empty_str,
      f2 = exists_e(2,cf) ? str(" face=\"",  cf[2], "\"") : empty_str,

      // before and after
      fb = is_undef(cf) ? empty_str : str(bb, "font", f0, f1, f2, ba),
      fa = is_undef(cf) ? empty_str : str(bb, "/font", ba),

      // current string
      cs =
      concat
      (
        [for (i=is_string(cb)?[cb]:cb) str(bb, i, ba)],
        [for (i=is_string(cp)?[cp]:cp) str(bb, i, ba)],
        fb, cv, fa,
        [for (i=is_string(rp)?[rp]:rp) str(bb, "/", i, ba)],
        [for (i=is_string(ca)?[ca]:ca) str(bb, i, ba)]
      ),

      // next elements
      nv = is_list(v) ? tailn(v) : empty_str,
      nb = is_list(b) ? exists_e(1,b) ? tailn(b) : lastn(b) : b,
      np = is_list(p) ? exists_e(1,p) ? tailn(p) : lastn(p) : p,
      na = is_list(a) ? exists_e(1,a) ? tailn(a) : lastn(a) : a,
      nf = is_list(f) ? exists_e(1,f) ? tailn(f) : lastn(f) : f
    )
    strl(concat(cs, strl_html(nv, nb, np, na, nf, d)));

//! Create a list of constant or incrementing elements.
/***************************************************************************//**
  \param    l <integer> The list length.
  \param    v \<value> The element value.
  \param    u <boolean> Element values are \b undef.

  \returns  (1) \<list> A list of \p l of constand or incrementing
            sequential elements.
            (2) Returns \b empty_lst when \p l is not a positive number.

  \details

    When \p v is unspecified and \p u is \b false, each element is
    assigned the value of its index position.
*******************************************************************************/
function consts
(
  l,
  v,
  u = false
) = !is_number(l) ? empty_lst
  : (l < 1) ? empty_lst
  : !is_undef(v) ? [for (i=[0:1:l-1]) v]
  : (u == false) ? [for (i=[0:1:l-1]) i]
  : [for (i=[0:1:l-1]) undef];

//! Create a element selection index list for a given list of values.
/***************************************************************************//**
  \param    l \<list> The list.
  \param    s <index> The index sequence \ref dt_index "specification".
  \param    rs <number> A random number sequence seed.

  \returns  (1) <list-l> The specified selection index.
            (2) Returns \b empty_lst when \p l is not a list or for any
                \p v that does not fall into one of the specification
                forms.

  \details

    See \ref dt_index for argument specification and conventions.
*******************************************************************************/
function index_gen
(
  l,
  s = true,
  rs
) = !is_list(l) ? empty_lst
  : (s == true) ? consts(len(l))
  : (s == false) ? empty_lst
  : (s == "all") ? consts(len(l))
  : (s == "none") ? empty_lst
  : (s == "even") ? [for (i = [0:2:len(l)-1]) i]
  : (s == "odd") ? [for (i = [1:2:len(l)-1]) i]
  : (s == "rands") ?
    let
    (
      r = defined_or(rs, first(rands(0, 100, 1))),
      i = rands(0, 2, len(l), r)
    )
    [for (j = [0:len(i)-1]) if (i[j] > 1) j]
    // any other string
  : is_string(s) ? empty_lst
  : is_number(s) ? [s]
  : is_range(s) ? [for (i=s) i]
  : all_numbers(s) ? s
  : empty_lst;

//! Pad a value to a constant number of elements.
/***************************************************************************//**
  \param    v \<value> The value.
  \param    w <integer> The total element count.
  \param    p \<value> The pad value.
  \param    rj <boolean> Use right or left justification.

  \returns  (1) \<list> The value as a list of elements padded to the
                left or right to \p w total elements.
            (2) When the value has greater than \p w elements, the it is
                returned without padding.

  \details

    The elements of the input value \p v and pad value \p p are
    considered to be characters. When either is not a list of
    characters or a string, it is converted to one prior to the
    padding. When \p v is a multi-dimensional, the first-dimension is
    considered the element count.

    \b Example
    \code{.C}
    echo (strl(pad_e([1,2,3,4], 8)));
    echo (strl(pad_e(192, 8)));
    echo (strl(pad_e("010111", 8)));
    \endcode
*******************************************************************************/
function pad_e
(
  v,
  w,
  p = 0,
  rj = true
) = is_undef(v) ? undef
  : !is_number(w) ? undef
  : let
    ( // convert to string when not iterable
      iv = is_iterable(v) ? v : str(v),
      ip = is_iterable(p) ? p : str(p),
      // get element size for the value and padding
      lv = len(iv),
      lp = len(ip),
      // calculate the full and partial padding counts
      cf = floor((w-lv)/lp),
      cp = w - lv - lp * cf,
      // construct the value, full and partial padding lists
      vl = (lv > 0) ? [for (i=[1:lv]) iv[ (i-1) ]]
                    : empty_lst,
      fp = (cf > 0) ? [for (i=[1:cf], j=[1:lp]) ip[ (j-1) ]]
                    : empty_lst,
      pp = (cp > 0) ? [for (i=[1:cp]) ip[(rj == false) ? (i-1) : (lp-cp+i-1) ]]
                    : empty_lst
    )
    (rj == false) ? concat(vl, fp, pp) : concat(pp, fp, vl);

//! Round a list of numbers to a fixed number of decimal point digits.
/***************************************************************************//**
  \param    v \<list> A list of values.
  \param    d <integer> The maximum number of decimals.

  \returns  (1) \<list> The list with all numeric values truncated to
                \p d decimal digits and rounded-up if the following
                digit is 5 or greater.
            (2) Returns \b undef when \p v is a non-numeric value.
*******************************************************************************/
function round_d
(
  v,
  d = 6
) = is_number(v) ?
    let(n = pow(10, d))
      round(v * n) / n
  : is_list(v) ? [for (i=v) round_d(i, d)]
  : undef;

//! Round a list of numbers to a fixed number of significant figures.
/***************************************************************************//**
  \param    v \<list> A list of values.
  \param    d <integer> The maximum number of significant figures.

  \returns  (1) \<list> The list with all numeric values rounded-up
                to \p d significant figures.
            (2) Returns \b undef when \p v is a non-numeric value.

  \details

    See [Wikipedia] for more information.

  [Wikipedia]: https://en.wikipedia.org/wiki/Significant_figures
*******************************************************************************/
function round_s
(
  v,
  d = 6
) = (v == 0) ? 0
  : is_number(v) ?
    let(n = floor(log(abs(v))) + 1 - d)
      round(v * pow(10, -n)) * pow(10, n)
  : is_list(v) ? [for (i=v) round_s(i, d)]
  : undef;

//! Limit a list of numbers between an upper and lower bounds.
/***************************************************************************//**
  \param    v \<list> A list of values.
  \param    l <number> The minimum value.
  \param    u <number> The maximum value.

  \returns  (1) \<list> The list with all numeric values limited to the
                range <tt>[l : u]</tt>.
            (2) Returns \b undef when \p v is a non-numeric value or
                when \p l or \p u is undefined.
*******************************************************************************/
function limit
(
  v,
  l,
  u
) = any_undefined([l, u]) ? undef
  : is_number(v) ? min(max(v,l),u)
  : is_list(v) ? [for (i=v) limit(i,l,u)]
  : undef;

//! Compute the sum of a list of numbers.
/***************************************************************************//**
  \param    v <number-list | range> A list of numerical values or a range.
  \param    i1 <integer> The list element index at which to begin
              summation (first when not specified).
  \param    i2 <integer> The list element index at which to end
              summation (last when not specified).

  \returns  (1) <number | number-list> The sum or list of sums over the
                index range.
            (2) Returns \b undef when list is empty, non-numeric, when
                 an index is specified and does not exists in the list
                 \p v, or when \p i1 > \p i2.
*******************************************************************************/
function sum
(
  v,
  i1,
  i2
) = is_range(v) ? sum([for (i=v) i], i1, i2)
  : is_number(v) ? v
  : !is_list(v) ? undef
  : is_empty(v) ? undef
  : is_defined(i1) && !is_between(i1, 0, len(v)-1) ? undef
  : is_defined(i2) && !is_between(i2, 0, len(v)-1) ? undef
  : all_defined([i1, i2]) && (i1 > i2) ? undef
  : let
    (
      s = defined_or(i1, 0),
      e = defined_or(i2, len(v)-1)
    )
    (s == e) ? v[s]
  : v[e] + sum(v, s, e-1);

//! Compute the mean/average of a list of numbers.
/***************************************************************************//**
  \param    v <number-list | range> A list of numerical values or a range.

  \returns  (1) <number | number-list> The sum divided by the number of
                elements.
            (2) Returns \b undef when list is empty or is non-numeric.

  \details

    See [Wikipedia] for more information.

    [Wikipedia]: https://en.wikipedia.org/wiki/Mean
*******************************************************************************/
function mean
(
  v
) = is_range(v) ? mean([for (i=v) i])
  : is_number(v) ? v
  : !is_list(v) ? undef
  : is_empty(v) ? undef
  : sum(v) / len(v);

//! Select specified element from list or return a default.
/***************************************************************************//**
  \param    v \<list> A list of values.
  \param    i <integer> Element selection index.
  \param    l <bool> Last element is default. When \b false, the first
              element is the default.

  \returns  (1) \<value> The value \p v[i] or the default element of
                \p v when element \p i does not exists.

  \details

    \b Example
    \code{.C}
    ov = [ "value1", "value2", "default" ];

    select_ci( ov )      // "default"
    select_ci( ov, 4 )   // "default"
    select_ci( ov, 0 )   // "value1"
    \endcode
*******************************************************************************/
function select_ci
(
  v,
  i,
  l = true
) = defined_e_or(v, i, (l == true) ? last(v) : first(v));

//! Select a specified mapped value from list of key-value pairs or return a default.
/***************************************************************************//**
  \param    v <map> A matrix of N key-value pairs [[key, value], ...].
  \param    mv \<value> A selection key value.
  \param    l <bool> Last element is default. When \b false, the first
              element is the default.

  \returns  (1) \<value> The value from the map \p v that matches the
                selection key \p mv.
            (2) Returns the default value when \p mv does not match any
                of the map keys \p v.

  \details

    \b Example
    \code{.C}
    ov = [ [0,"value0"], ["a","value1"], ["b","value2"], ["c","default"] ];

    select_cm( ov )      // "default"
    select_cm( ov, "x" ) // "default"
    select_cm( ov, 0 )   // "value0"
    select_cm( ov, "b" ) // "value2"
    \endcode
*******************************************************************************/
function select_cm
(
  v,
  mv,
  l = true
) = // use find() to avoid element is not found warnings
    // search first element for first match
    let ( i = first(find(mv, v, 1, 0)) )
    is_undef(i) ? (l == true) ? second(last(v)) : second(first(v))
  : second(v[i]);

//! Select each element at an index position of a list of iterable values.
/***************************************************************************//**
  \param    v \<list> A list of iterable values.
  \param    i <integer> Select the element index position.
  \param    f <boolean> Select the first element.
  \param    l <boolean> Select the last element.

  \returns  (1) \<list> A list of the selected element from each
                iterable value of \p v.
            (2) Returns \b undef when \p v is not iterable or when no
                index selection is specified.
            (3) Returns \b empty_lst when \p v is empty.

  \details

    When more than one selection criteria is specified, the order of
    precedence is: \p i, \p f, \p l.
*******************************************************************************/
function select_e
(
  v,
  i,
  f,
  l
) = !is_iterable(v) ? undef
  : is_empty(v) ? empty_lst
  : is_defined(i) ? concat( [first(v)[i]], select_e(tailn(v), i, f, l) )
  : (f == true) ? concat( [first(first(v))], select_e(tailn(v), i, f, l) )
  : (l == true) ? concat( [last(first(v))], select_e(tailn(v), i, f, l) )
  : undef;

//! Select n elements from each iterable value of a list.
/***************************************************************************//**
  \param    v \<list> A list of iterable values.
  \param    f <boolean> Select the first element.
  \param    l <boolean> Select the last element.
  \param    i <integer> Select a numeric element index position.
  \param    n <integer> The element count.

  \returns  (1) \<list> A list of the list of \p n selected sequential
                elements from each iterable value of \p v.
            (2) Returns \b undef when \p v is not iterable or when no
                index selection is specified.
            (3) Returns \b empty_lst when \p v is empty.

  \details

    When selecting the \p n elements, only the available elements will
    be returned when \p n is greater than the number of elements
    available. When more than one selection criteria is specified, the
    order of precedence is: \p i, \p f, \p l.
*******************************************************************************/
function select_en
(
  v,
  i,
  f,
  l,
  n = 1
) = !is_iterable(v) ? undef
  : is_empty(v) ? empty_lst
  : is_defined(i) ?
      concat
      (
        [firstn(select_r(v[0], [i:len(v[0])-1]), n)],
        select_en(tailn(v), i, f, l, n)
      )
  : (f == true) ? concat( [firstn(first(v), n)], select_en(tailn(v), i, f, l, n) )
  : (l == true) ? concat( [lastn(first(v), n)], select_en(tailn(v), i, f, l, n) )
  : undef;

//! Serially merge the elements of a list.
/***************************************************************************//**
  \param    v \<list> A list of iterable values.
  \param    r <boolean> Recursively merge elements that are iterable.

  \returns  (1) \<list> A list containing the serial-wise element
                conjunction of each element in \p v.
            (2) Returns \b undef when \p v is not iterable.

  \details

    \b Example
    \code{.C}
    l = [[1,2,3],[[[[0]]]], [4,5,6],[[[7,8,[9]]]]];

    echo( merge_s( l, true ) );
    \endcode

    \b Result
    \code{.C}
    ECHO: [1, 2, 3, 4, 5, 6, 7, 8, 9]
    \endcode
*******************************************************************************/
function merge_s
(
  v,
  r = false
) = !is_iterable(v) ? undef
  : is_empty(v) ? empty_lst
  : ( (r == true) && is_list(first(v)) ) ?
      concat(merge_s(first(v), r), merge_s(tailn(v), r))
  : concat(first(v), merge_s(tailn(v), r));

//! Parallel-merge the iterable elements of a list.
/***************************************************************************//**
  \param    v \<list> A list of iterable values.
  \param    j <boolean> Join each merge as a separate list.

  \returns  (1) \<list> A list containing the parallel-wise element
                conjunction of each iterable value in \p v.
            (2) Returns \b undef when \p v is not iterable.

  \details

    The element \c i of each iterable value in \p v are visited and
    joined to form a new list for every iterable value of \p v. The
    resulting list length will be limited by the iterable value of \p v
    with the shortest length.

    \b Example
    \code{.C}
    v1=["a", "b", "c", "d"];
    v2=[1, 2, 3];

    echo( merge_p( [v1, v2], true ) );
    echo( merge_p( [v1, v2], false ) );
    \endcode

    \b Result
    \code{.C}
    ECHO: [["a", 1], ["b", 2], ["c", 3]]
    ECHO: ["a", 1, "b", 2, "c", 3]
    \endcode
*******************************************************************************/
function merge_p
(
  v,
  j = true
) = !is_iterable(v) ? undef
  : is_empty(v) ? empty_lst
    // each value of 'v' must also be iterable
  : !all_iterables(v) ? undef
    // no value of 'v' may be an empty
  : any_equal(v, empty_lst) ? empty_lst
  : let
    (
      h = [for (i = v) first(i)],
      t = [for (i = v) tailn(i)]
    )
    (j == true) ? concat([h], merge_p(t, j))
  : concat(h, merge_p(t, j));

//! Sort the elements of an iterable value using quick sort.
/***************************************************************************//**
  \param    v <iterable> A iterable values.
  \param    i <integer> The sort element index for iterable values of \p v.
  \param    r <boolean> Reverse the sort order.

  \returns  (1) \<list> A list with elements sorted in ascending order.
            (2) Returns \b undef when \p v is not iterable.

  \details

    This implementation relies on the comparison operators '<', '>',
    and '==' which expect the operands to be either two scalar numbers
    or two strings. Therefore, this function will not correctly sort
    lists elements if differing data types. Elements with unknown order
    are placed at the end of the list. When sorting lists of
    non-iterable values or strings, the \p i must not be specified.

    See [Wikipedia] for more information.

  [Wikipedia]: https://en.wikipedia.org/wiki/Quicksort
*******************************************************************************/
function sort_q
(
  v,
  i,
  r = false
) = !is_iterable(v) ? undef
  : is_empty(v) ? empty_lst
  : let
    (
      mp = v[floor(len(v)/2)],            // mid-point index
      me = is_undef(i) ? mp : mp[i],      // mid-point element

      // place each element of 'v' into bin
      lt = [for (j = v) let(k = is_undef(i) ? j : j[i]) if (k  < me) j],
      eq = [for (j = v) let(k = is_undef(i) ? j : j[i]) if (k == me) j],
      gt = [for (j = v) let(k = is_undef(i) ? j : j[i]) if (k  > me) j],

      // un-orderable elements of 'v'
      uo = [
             for (j = v) let(k = is_undef(i) ? j : j[i])
               if ( !( (k < me) || (k == me) || (k > me) ) ) j
           ],

      sp = (r == true) ? concat(sort_q(gt, i, r), eq, sort_q(lt, i, r), uo)
                       : concat(sort_q(lt, i, r), eq, sort_q(gt, i, r), uo)
    )
    sp;

//! Sort the elements of an iterable value using quick sort and compare
/***************************************************************************//**
  \param    v <iterable> A iterable values.
  \param    i <integer> The sort element index for iterable values of \p v.
  \param    d <integer> The recursive sort depth.
  \param    r <boolean> Reverse the sort order.
  \param    s <boolean> Order ranges by their enumerated sum.

  \returns  (1) \<list> A list with elements sorted in ascending order.
            (2) Returns \b undef when \p v is not iterable.

  \details

    Elements are ordered using the compare() function. See its
    documentation for a more information. To recursively sort all
    elements, set \p d to a value greater than, or equal to, the
    maximum level of hierarchy in \p v. During hierarchial sorts, empty
    list-levels are reduced.

    See [Wikipedia] for more information.

  [Wikipedia]: https://en.wikipedia.org/wiki/Quicksort
*******************************************************************************/
function sort_q2
(
  v,
  i,
  d = 0,
  r = false,
  s = true
) = !is_iterable(v) ? undef
  : is_empty(v) ? empty_lst
  : let
    (
      mp = v[floor(len(v)/2)],
      me = is_undef(i) ? mp : mp[i],

      lt =
      [
        for (j = v)
        let(k = is_undef(i) ? j : j[i])
          if (compare(me, k, s) == -1)
            ((d > 0) && is_list(k)) ? sort_q2(k, i, d-1, r, s) : j
      ],
      eq =
      [
        for (j = v)
        let(k = is_undef(i) ? j : j[i])
          if (compare(me, k, s) ==  0)
            ((d > 0) && is_list(k)) ? sort_q2(k, i, d-1, r, s) : j
      ],
      gt =
      [
        for (j = v)
        let(k = is_undef(i) ? j : j[i])
          if (compare(me, k, s) == +1)
            ((d > 0) && is_list(k)) ? sort_q2(k, i, d-1, r, s) : j
      ],
      sp = (r == true) ?
           concat(sort_q2(gt, i, d, r, s), eq, sort_q2(lt, i, d, r, s))
         : concat(sort_q2(lt, i, d, r, s), eq, sort_q2(gt, i, d, r, s))
    )
    (d > 0) ? sort_q2(sp, i, d-1, r, s) : sp;

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
    t = true; f = false; u = undef; skip = validation_skip;

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
    [ // function
      ["strl",
        undef,                                              // t01
        empty_str,                                          // t02
        "[0 : 0.5 : 9]",                                    // t03
        "A string",                                         // t04
        "orangeapplegrapebanana",                           // t05
        "bananas",                                          // t06
        "undef",                                            // t07
        "[1, 2][2, 3]",                                     // t08
        "ab[1, 2][2, 3][4, 5]",                             // t09
        "[1, 2, 3][4, 5, 6][7, 8, 9][\"a\", \"b\", \"c\"]", // t10
        "0123456789101112131415"                            // t11
      ],
      ["strl_html_B",
        empty_str,                                          // t01
        empty_str,                                          // t02
        empty_str,                                          // t03
        "<b>A string</b>",                                  // t04
        "<b>orange</b><b>apple</b><b>grape</b><b>banana</b>",
        "<b>b</b><b>a</b><b>n</b><b>a</b><b>n</b><b>a</b><b>s</b>",
        "<b>undef</b>",                                     // t07
        "<b>[1, 2]</b><b>[2, 3]</b>",                       // t08
        "<b>ab</b><b>[1, 2]</b><b>[2, 3]</b><b>[4, 5]</b>", // t09
        "<b>[1, 2, 3]</b><b>[4, 5, 6]</b><b>[7, 8, 9]</b><b>[\"a\", \"b\", \"c\"]</b>",
        "<b>0</b><b>1</b><b>2</b><b>3</b><b>4</b><b>5</b><b>6</b><b>7</b><b>8</b><b>9</b><b>10</b><b>11</b><b>12</b><b>13</b><b>14</b><b>15</b>"
      ],
      ["consts",
        empty_lst,                                          // t01
        empty_lst,                                          // t02
        empty_lst,                                          // t03
        empty_lst,                                          // t04
        empty_lst,                                          // t05
        empty_lst,                                          // t06
        empty_lst,                                          // t07
        empty_lst,                                          // t08
        empty_lst,                                          // t09
        empty_lst,                                          // t10
        empty_lst                                           // t11
      ],
      ["index_gen",
        empty_lst,                                          // t01
        empty_lst,                                          // t02
        empty_lst,                                          // t03
        empty_lst,                                          // t04
        [0,1,2,3],                                          // t05
        [0,1,2,3,4,5,6],                                    // t06
        [0],                                                // t07
        [0,1],                                              // t08
        [0,1,2,3],                                          // t09
        [0,1,2,3],                                          // t10
        [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]             // t11
      ],
      ["pad_e_9",
        undef,                                              // t01
        ["0","0","0","0","0","0","0","0","0"],              // t02
        ["[","0"," ",":"," ","0",".","5"," ",":"," ","9","]"],
        ["0","A"," ","s","t","r","i","n","g"],              // t04
        ["0","0","0","0","0","orange","apple","grape","banana"],
        ["0","0","b","a","n","a","n","a","s"],              // t06
        ["0","0","0","0","0","0","0","0",undef],            // t07
        ["0","0","0","0","0","0","0",[1,2],[2,3]],          // t08
        ["0","0","0","0","0","ab",[1,2],[2,3],[4,5]],       // t09
        ["0","0","0","0","0",[1,2,3],[4,5,6],[7,8,9],["a","b","c"]],
        [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]             // t11
      ],
      ["sum",
        skip,                                               // t11
        skip,                                               // t11
        skip,                                               // t11
        skip,                                               // t11
        skip,                                               // t05
        skip,                                               // t11
        skip,                                               // t11
        skip,                                               // t11
        skip,                                               // t09
        skip,                                               // t11
        120                                                 // t11
      ],
      ["mean",
        undef,                                              // t01
        undef,                                              // t02
        4.5,                                                // t03
        undef,                                              // t04
        undef,                                              // t05
        undef,                                              // t06
        undef,                                              // t07
        [1.5,2.5],                                          // t08
        undef,                                              // t09
        [undef,undef,undef],                                // t10
        7.5                                                 // t11
      ],
      ["select_e_F",
        undef,                                              // t01
        empty_lst,                                          // t02
        undef,                                              // t03
        ["A"," ","s","t","r","i","n","g"],                  // t04
        ["o","a","g","b"],                                  // t05
        ["b","a","n","a","n","a","s"],                      // t06
        [undef],                                            // t07
        [1,2],                                              // t08
        ["a",1,2,4],                                        // t09
        [1,4,7,"a"],                                        // t10
        skip                                                // t11
      ],
      ["select_e_L",
        undef,                                              // t01
        empty_lst,                                          // t02
        undef,                                              // t03
        ["A"," ","s","t","r","i","n","g"],                  // t04
        ["e","e","e","a"],                                  // t05
        ["b","a","n","a","n","a","s"],                      // t06
        [undef],                                            // t07
        [2,3],                                              // t08
        ["b",2,3,5],                                        // t09
        [3,6,9,"c"],                                        // t10
        skip                                                // t11
      ],
      ["select_e_1",
        undef,                                              // t01
        empty_lst,                                          // t02
        undef,                                              // t03
        skip,                                               // t04
        ["r","p","r","a"],                                  // t05
        skip,                                               // t06
        [undef],                                            // t07
        [2,3],                                              // t08
        ["b",2,3,5],                                        // t09
        [2,5,8,"b"],                                        // t10
        skip                                                // t11
      ],
      ["select_en_F2",
        undef,                                              // t01
        empty_lst,                                          // t02
        undef,                                              // t03
        [["A"],[" "],["s"],["t"],["r"],["i"],["n"],["g"]],  // t04
        [["o","r"],["a","p"],["g","r"],["b","a"]],          // t05
        [["b"],["a"],["n"],["a"],["n"],["a"],["s"]],        // t06
        [undef],                                            // t07
        [[1,2],[2,3]],                                      // t08
        [["a","b"],[1,2],[2,3],[4,5]],                      // t09
        [[1,2],[4,5],[7,8],["a","b"]],                      // t10
        skip                                                // t11
      ],
      ["select_en_L3",
        undef,                                              // t01
        empty_lst,                                          // t02
        undef,                                              // t03
        [["A"],[" "],["s"],["t"],["r"],["i"],["n"],["g"]],  // t04
        [
          ["n","g","e"],["p","l","e"],
          ["a","p","e"],["a","n","a"]
        ],                                                  // t05
        [["b"],["a"],["n"],["a"],["n"],["a"],["s"]],        // t06
        [undef],                                            // t07
        [[1,2],[2,3]],                                      // t08
        [["a","b"],[1,2],[2,3],[4,5]],                      // t09
        [[1,2,3],[4,5,6],[7,8,9],["a","b","c"]],            // t10
        skip                                                // t11
      ],
      ["select_en_12",
        undef,                                              // t01
        empty_lst,                                          // t02
        undef,                                              // t03
        skip,                                               // t04 (DEPRECATED WARNING)
        [["r","a"],["p","p"],["r","a"],["a","n"]],          // t05
        skip,                                               // t06
        [undef],                                            // t07
        [[2],[3]],                                          // t08
        [["b"],[2],[3],[5]],                                // t09
        [[2,3],[5,6],[8,9],["b","c"]],                      // t10
        skip                                                // t11
      ],
      ["merge_s",
        undef,                                              // t01
        empty_lst,                                          // t02
        undef,                                              // t03
        ["A"," ","s","t","r","i","n","g"],                  // t04
        ["orange","apple","grape","banana"],                // t05
        ["b","a","n","a","n","a","s"],                      // t06
        [undef],                                            // t07
        [1,2,2,3],                                          // t08
        ["ab",1,2,2,3,4,5],                                 // t09
        [1,2,3,4,5,6,7,8,9,"a","b","c"],                    // t10
        [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]             // t11
      ],
      ["merge_p",
        undef,                                              // t01
        empty_lst,                                          // t02
        undef,                                              // t03
        [["A"," ","s","t","r","i","n","g"]],                // t04
        [
          ["o","a","g","b"],["r","p","r","a"],
          ["a","p","a","n"],["n","l","p","a"],
          ["g","e","e","n"]
        ],                                                  // t05
        [["b","a","n","a","n","a","s"]],                    // t06
        undef,                                              // t07
        [[1,2],[2,3]],                                      // t08
        [["a",1,2,4],["b",2,3,5]],                          // t09
        [[1,4,7,"a"],[2,5,8,"b"],[3,6,9,"c"]],              // t10
        undef                                               // t11
      ],
      ["sort_q",
        undef,                                              // t01
        empty_lst,                                          // t02
        undef,                                              // t03
        undef,                                              // t04
        ["apple","banana","grape","orange"],                // t05
        ["a","a","a","b","n","n","s"],                      // t06
        [undef],                                            // t07
        skip,                                               // t08
        skip,                                               // t09
        skip,                                               // t10
        [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]             // t11
      ],
      ["sort_q_1R",
        undef,                                              // t01
        empty_lst,                                          // t02
        undef,                                              // t03
        undef,                                              // t04
        ["orange","grape","apple","banana"],                // t05
        skip,                                               // t06
        skip,                                               // t07
        [[2,3],[1,2]],                                      // t08
        [[4,5],[2,3],[1,2],"ab"],                           // t09
        [[7,8,9],[4,5,6],[1,2,3],["a","b","c"]],            // t10
        skip                                                // t11
      ],
      ["sort_q2_1R",
        undef,                                              // t01
        empty_lst,                                          // t02
        undef,                                              // t03
        undef,                                              // t04
        ["orange","grape","apple","banana"],                // t05
        skip,                                               // t06
        skip,                                               // t07
        [[2,3],[1,2]],                                      // t08
        ["ab",[4,5],[2,3],[1,2]],                           // t09
        [["a","b","c"],[7,8,9],[4,5,6],[1,2,3]],            // t10
        skip                                                // t11
      ],
      ["sort_q2_HR",
        undef,                                              // t01
        empty_lst,                                          // t02
        undef,                                              // t03
        undef,                                              // t04
        ["orange","grape","banana","apple"],                // t05
        ["s","n","n","b","a","a","a"],                      // t06
        [undef],                                            // t07
        [[3,2],[2,1]],                                      // t08
        [[5,4],[3,2],[2,1],"ab"],                           // t09
        [["c","b","a"],[9,8,7],[6,5,4],[3,2,1]],            // t10
        [15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0]             // t11
      ]
    ];


    db = table_validate_init( tbl_test_values, tbl_test_answers );

    table_validate_start( db );
    test_ids = table_validate_get_ids( db );

    for (id=test_ids) table_validate( db, id, "strl", 1, strl( v1(db,id)) );
    for (id=test_ids) table_validate( db, id, "strl_html_B", 1, strl_html( v1(db,id),p="b") );
    for (id=test_ids) table_validate( db, id, "consts", 1, consts( v1(db,id)) );
    for (id=test_ids) table_validate( db, id, "index_gen", 1, index_gen( v1(db,id)) );
    for (id=test_ids) table_validate( db, id, "pad_e_9", 1, pad_e( v1(db,id), w=9) );
    validate_skip( "round_d()" );
    validate_skip( "round_s()" );
    validate_skip( "limit()" );
    validate_skip( "sum()" );
    validate_skip( "mean()" );
    validate_skip( "select_ci()" );
    validate_skip( "select_cm()" );
    for (id=test_ids) table_validate( db, id, "select_e_F", 1, select_e( v1(db,id),f=true) );
    for (id=test_ids) table_validate( db, id, "select_e_L", 1, select_e( v1(db,id),l=true) );
    for (id=test_ids) table_validate( db, id, "select_e_1", 1, select_e( v1(db,id),i=1) );
    for (id=test_ids) table_validate( db, id, "select_en_F2", 1, select_en( v1(db,id),f=true,n=2) );
    validate_skip( "select_en()" );
    for (id=test_ids) table_validate( db, id, "merge_s", 1, merge_s( v1(db,id)) );
    for (id=test_ids) table_validate( db, id, "merge_p", 1, merge_p( v1(db,id)) );
    validate_skip( "sort_q()" );
    validate_skip( "sort_q2()" );

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
