//! List data type operations.
/***************************************************************************//**
  \file   datatypes_operate_list.scad
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

  \note Include this library file using the \b include statement.

  \ingroup datatypes datatypes_operate datatypes_operate_list
*******************************************************************************/

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \page tv_datatypes_operate_list Lists
    \li \subpage tv_datatypes_operate_list_s
    \li \subpage tv_datatypes_operate_list_r

  \page tv_datatypes_operate_list_s Script
    \dontinclude datatypes_operate_list_validate.scad
    \skip include
    \until end-of-tests
  \page tv_datatypes_operate_list_r Results
    \include datatypes_operate_list_validate.log
*******************************************************************************/
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \addtogroup datatypes_operate
  @{

  \defgroup datatypes_operate_list Lists
  \brief    List data type operations.
  @{
*******************************************************************************/
//----------------------------------------------------------------------------//

//! Convert a list of values to a concatenated string.
/***************************************************************************//**
  \param    v \<list> A list of values.

  \returns  <string> Constructed by converting each element of the list
            to a string and concatenating together.
            Returns \b undef when the list is not defined.

  \details

    \b Example
    \code{.C}
    v1=["a", "b", "c", "d"];
    v2=[1, 2, 3];

    echo( lstr(concat(v1, v2)) );
    \endcode

    \b Result
    \code{.C}
    ECHO: "abcd123"
    \endcode
*******************************************************************************/
function lstr
(
  v
) = not_defined(v) ? undef
  : !is_iterable(v) ? str(v)
  : is_empty(v) ? empty_str
  : (len(v) == 1) ? str(first(v))
  : str(first(v), lstr(ntail(v)));

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
            where  <tt>fs=["color","size","face"]</tt> is the font tag
            to enclose the value. Not all attributes are required, but
            the order is significant.

  \param    d <boolean> Debug. When \b true angle brackets are replaced
            with curly brackets to prevent console decoding.

  \returns  <string> Constructed by converting each element of the list
            to a string with specified HTML markup and concatenating.
            Returns \b undef when the list is not defined.

  \details
    When there are fewer tag lists in \p b, \p p, \p a, or \p f,
    than there are value elements in \p v, the last specified tag list
    is used for all subsequent value elements.

    For a list of the \em paired and \em unpaired HTML tags supported by
    the console see: [HTML subset].

    \b Example
    \code{.C}
    echo( lstr_html(v="bold text", p="b", d=true) );
    echo( lstr_html(v=[1,"x",3], f=[["red",6,"helvetica"],undef,["blue",10,"courier"]], d=true) );

    v = ["result", "=", "mc", "2"];
    b = ["hr", undef];
    p = ["i", undef, ["b", "i"], ["b","sup"]];
    a = concat(consts(3, u=true), "hr");
    f = [undef, ["red"], undef, ["blue",4]];

    echo( lstr_html(v=v, b=b, p=p, a=a, f=f, d=true) );
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
function lstr_html
(
  v,
  b,
  p,
  a,
  f,
  d = false
) = is_empty(v) ? empty_str
  : let
    (
      bb = (d == true) ? "{" : "<",
      ba = (d == true) ? "}" : ">",

      cv = is_list(v) ? nfirst(v) : v,
      cb = is_list(b) ?  first(b) : b,
      cp = is_list(p) ?  first(p) : p,
      ca = is_list(a) ?  first(a) : a,
      cf = is_list(f) ?  first(f) : f,

      rp = is_list(cp) ? reverse(cp) : cp,

      f0 = (len(cf) > 0) ? str(" color=\"", cf[0], "\"") : empty_str,
      f1 = (len(cf) > 1) ? str(" size=\"",  cf[1], "\"") : empty_str,
      f2 = (len(cf) > 2) ? str(" face=\"",  cf[2], "\"") : empty_str,

      fb = not_defined(cf) ? empty_str : str(bb, "font", f0, f1, f2, ba),
      fa = not_defined(cf) ? empty_str : str(bb, "/font", ba),

      cs =
      concat
      (
        [for (i=cb) str(bb, i, ba)],
        [for (i=cp) str(bb, i, ba)],
        fb, cv, fa,
        [for (i=rp) str(bb, "/", i, ba)],
        [for (i=ca) str(bb, i, ba)]
      ),

      nv = is_list(v) ? ntail(v) : empty_str,
      nb = is_list(b) ? (len(b) > 1) ? ntail(b) : nlast(b) : b,
      np = is_list(p) ? (len(p) > 1) ? ntail(p) : nlast(p) : p,
      na = is_list(a) ? (len(a) > 1) ? ntail(a) : nlast(a) : a,
      nf = is_list(f) ? (len(f) > 1) ? ntail(f) : nlast(f) : f
    )
    lstr(concat(cs, lstr_html(nv, nb, np, na, nf, d)));

//! Create a list of constant elements.
/***************************************************************************//**
  \param    l <integer> The list length.
  \param    v \<value> The element value.
  \param    u <boolean> Element values are \b undef.

  \returns  \<list> A list of \p l copies of the element.
            Returns \b empty_lst when \p l is not a number or if
            <tt>(l < 1)</tt>.

  \details

  \note     When \p v is not specified and \p u is \b false, each element
            is assigned the value of its index position.
*******************************************************************************/
function consts
(
  l,
  v,
  u = false
) = (l<1) ? empty_lst
  : !is_number(l) ? empty_lst
  : is_defined(v) ? [for (i=[0:1:l-1]) v]
  : (u == false) ? [for (i=[0:1:l-1]) i]
  : [for (i=[0:1:l-1]) undef];

//! Round all numerical values of a list to a fixed number of decimal point digits.
/***************************************************************************//**
  \param    v \<list> A list of values.
  \param    d <integer> The (maximum) number of decimals.

  \returns  \<list> The list with all numeric values truncated to
            \p d decimal digits and rounded-up if the following digit
            is 5 or greater. Non-numeric values are unchanged.
*******************************************************************************/
function dround
(
  v,
  d = 6
) = is_number(v) ? round(v * pow(10, d)) / pow(10, d)
  : is_list(v) ? [for (i=v) dround(i, d)]
  : v;

//! Round all numerical values of a list to a fixed number of significant figures.
/***************************************************************************//**
  \param    v \<list> A list of values.
  \param    d <integer> The (maximum) number of significant figures.

  \returns  \<list> The list with all numeric values rounded-up
            to \p d significant figures. Non-numeric values are unchanged.

  \details

    See [Wikipedia] for more information.

  [Wikipedia]: https://en.wikipedia.org/wiki/Significant_figures
*******************************************************************************/
function sround
(
  v,
  d = 6
) = (v == 0) ? 0
  : is_number(v) ?
    let(n = floor(log(abs(v))) + 1 - d)
    round(v * pow(10, -n)) * pow(10, n)
  : is_list(v) ? [for (i=v) sround(i, d)]
  : v;

//! Limit a number between upper and lower bounds.
/***************************************************************************//**
  \param    v <decimal> A numeric value.
  \param    l <decimal> The minimum value.
  \param    u <decimal> The maximum value.

  \returns  <decimal> \p v when it is within <tt>[l : u]</tt>.
            Returns \p l when <tt>(v<l)</tt> and \p u when <tt>(v>u)</tt>.
*******************************************************************************/
function limit
(
  v,
  l,
  u
) = is_empty(v) ? empty_lst
  : is_number(v) ? min(max(v,l),u)
  : is_list(v) ? [for (i=v) limit(i,l,u)]
  : v;

//! Compute the sum of a list of numbers.
/***************************************************************************//**
  \param    v <number-list|range> A list of numerical values or a range.
  \param    i1 <integer> The element index at which to begin summation
            (first when not specified).
  \param    i2 <integer> The element index at which to end summation
            (last when not specified).

  \returns  <number|number-list> The sum over the index range.
            Returns 0 when \p the list is empty.
            Returns \b undef when list non-numerical.
*******************************************************************************/
function sum
(
  v,
  i1,
  i2
) = not_defined(v) ? undef
  : is_empty(v) ? 0
  : is_number(v) ? v
  : is_range(v) ? sum([for (i=v) i], i1, i2)
  : !is_iterable(v) ? undef
  : let
    (
      s = is_defined(i1) ? limit(i1, 0, len(v)-1) : 0,
      i = is_defined(i2) ? limit(i2, s, len(v)-1) : len(v)-1
    )
    (i == s) ? v[i]
  : v[i] + sum(v, s, i-1);

//! Compute the mean/average of a list of numbers.
/***************************************************************************//**
  \param    v <number-list|range> A list of numerical values or a range.

  \returns  <number|number-list> The sum divided by the number of elements.
            Returns 0 when the list is empty.
            Returns \b undef when list non-numerical.

  \details

    See [Wikipedia] for more information.

    [Wikipedia]: https://en.wikipedia.org/wiki/Mean
*******************************************************************************/
function mean
(
  v
) = not_defined(v) ? undef
  : is_empty(v) ? 0
  : is_number(v) ? v
  : is_range(v) ? mean([for (i=v) i])
  : !is_iterable(v) ? undef
  : sum(v) / len(v);

//! Case-like select a value from a list of ordered value options.
/***************************************************************************//**
  \param    v \<list> A list of values.
  \param    i <integer> Element selection index.

  \returns  \<value> The value of the list element at the specified index.
            Returns the default value when \p i does not map to an element.

  \details

    Behaves like a case statement for selecting values from a list of
    <em>ordered options</em>. The default value is: <tt>last(v)<tt>.

    \b Example
    \code{.C}
    ov = [ "value1", "value2", "default" ];

    ciselect( ov );     // "default"
    ciselect( ov, 4 );  // "default"
    ciselect( ov, 0 );  // "value1"
    \endcode
*******************************************************************************/
function ciselect
(
  v,
  i
) = not_defined(i) ? last(v)
  : !is_integer(i) ? last(v)
  : (i < 0) ? last(v)
  : (i > len(v)-1) ? last(v)
  : v[i];

//! Case-like select a value from a list of mapped key-value options.
/***************************************************************************//**
  \param    v <matrix-2xN> A matrix of N key-value mapped pairs
            [[key, value], ...].
  \param    mv \<value> Element selection key match value.

  \returns  \<value> The value from the map that matches the key \p mv.
            Returns the default value when \p mv does not match any of
            the element identifiers of \p v or when \p mv is undefined.

  \details

    Behaves like a case statement for selecting values from a list of
    <em>mapped options</em>. The default value is: <tt>second(last(v))<tt>.

    \b Example
    \code{.C}
    ov = [ [0,"value0"], ["a","value1"], ["b","value2"], ["c","default"] ];

    cmvselect( ov );      // "default"
    cmvselect( ov, "x" ); // "default"
    cmvselect( ov, 0 );   // "value0"
    cmvselect( ov, "b" ); // "value2"
    \endcode
*******************************************************************************/
function cmvselect
(
  v,
  mv
) = not_defined(mv) ? second(last(v))
  : let
    (
      i = first(search([mv], v, 1, 0))
    )
    is_empty(i) ? second(last(v))
  : second(v[i]);

//! Select a specified element from each iterable value of a list.
/***************************************************************************//**
  \param    v \<list> A list of iterable values.
  \param    f <boolean> Select the first element.
  \param    l <boolean> Select the last element.
  \param    i <integer> Select a numeric element index position.

  \returns  \<list> A list containing the selected element of each
            iterable value of \p v.
            Returns \b empty_lst when \p v is empty.
            Returns \b undef when \p v is not defined or is not iterable.

  \details

  \note     When more than one selection criteria is specified, the
            order of precedence is: \p i, \p l, \p f.
*******************************************************************************/
function eselect
(
  v,
  f = true,
  l = false,
  i
) = not_defined(v) ? undef
  : !is_iterable(v) ? undef
  : is_empty(v) ? empty_lst
  : is_defined(i) ? concat( [first(v)[i]], eselect(ntail(v), f, l, i) )
  : (l == true) ? concat( [last(first(v))], eselect(ntail(v), f, l, i) )
  : (f == true) ? concat( [first(first(v))], eselect(ntail(v), f, l, i) )
  : undef;

//! Serial-merge lists of iterable values.
/***************************************************************************//**
  \param    v \<list> A list of iterable values.
  \param    r <boolean> Recursively merge elements that are iterable.

  \returns  <list> A list containing the serial-wise element concatenation
            of each element in \p v.
            Returns \b empty_lst when \p v is empty.
            Returns \b undef when \p v is not defined.

  \details

  \note     A single string, although iterable, is treated as a merged unit.
*******************************************************************************/
function smerge
(
  v,
  r = false
) = not_defined(v) ? undef
  : !is_iterable(v) ? [v]
  : is_empty(v) ? empty_lst
  : is_string(v) ? [v]
  : ((r == true) && is_iterable(first(v))) ?
    concat(smerge(first(v), r), smerge(ntail(v), r))
  : concat(first(v), smerge(ntail(v), r));

//! Parallel-merge lists of iterable values.
/***************************************************************************//**
  \param    v \<list> A list of iterable values.
  \param    j <boolean> Join each merge as a separate list.

  \returns  <list> A list containing the parallel-wise element concatenation
            of each iterable value in \p v.
            Returns \b empty_lst when any element value in \p v is empty.
            Returns \b undef when \p v is not defined or when any element
            value in \p v is not iterable.

  \details

    \b Example
    \code{.C}
    v1=["a", "b", "c", "d"];
    v2=[1, 2, 3];

    echo( pmerge( [v1, v2], true ) );
    echo( pmerge( [v1, v2], false ) );
    \endcode

    \b Result
    \code{.C}
    ECHO: [["a", 1], ["b", 2], ["c", 3]]
    ECHO: ["a", 1, "b", 2, "c", 3]
    \endcode

  \note     The resulting list length will be limited by the iterable
            value with the shortest length.
  \note     A single string, although iterable, is treated as a merged unit.
*******************************************************************************/
function pmerge
(
  v,
  j = true
) = not_defined(v) ? undef
  : !is_iterable(v) ? undef
  : is_empty(v) ? empty_lst
  : is_string(v) ? [v]
  : let
    (
      l = [for (i = v) len(i)]          // element lengths
    )
    any_undefined(l) ? undef            // any element not iterable?
  : (min(l) == 0) ? empty_lst             // any element empty?
  : let
    (
      h = [for (i = v) first(i)],
      t = [for (i = v) ntail(i)]
    )
    (j == true) ? concat([h], pmerge(t, j))
  : concat(h, pmerge(t, j));

//! Sort the numeric or string elements of a list using quick sort.
/***************************************************************************//**
  \param    v \<number-list|string-list> A list of values.
  \param    i <integer> The sort column index for iterable elements.
  \param    r <boolean> Reverse the sort order.

  \returns  \<list> A list with elements sorted in ascending order.
            Returns \b undef when \p v is not defined or is not a list.

  \details

  \warning This implementation relies on the comparison operators
           '<' and '>' which expect the operands to be either two scalar
           numbers or two strings. Therefore, this function will not
           correctly sort lists elements that are not numbers or
           strings. Elements with unknown order are placed at the end
           of the list.

    See [Wikipedia] for more information.

  [Wikipedia]: https://en.wikipedia.org/wiki/Quicksort
*******************************************************************************/
function qsort
(
  v,
  i,
  r = false
) = not_defined(v) ? undef
  : !is_list(v) ? undef
  : is_empty(v) ? empty_lst
  : let
    (
      mp = v[floor(len(v)/2)],
      me = not_defined(i) ? mp : mp[i],

      lt = [for (j = v) let(k = not_defined(i) ? j : j[i]) if (k  < me) j],
      eq = [for (j = v) let(k = not_defined(i) ? j : j[i]) if (k == me) j],
      gt = [for (j = v) let(k = not_defined(i) ? j : j[i]) if (k  > me) j],

      ou =
      [
        for (j = v) let(k = not_defined(i) ? j : j[i])
          if ( !((k < me) || (k == me) || (k > me)) ) j
      ],

      sp = (r == true) ?
           concat(qsort(gt, i, r), eq, qsort(lt, i, r), ou)
         : concat(qsort(lt, i, r), eq, qsort(gt, i, r), ou)
    )
    sp;

//! Hierarchically sort an arbitrary data list using quick sort.
/***************************************************************************//**
  \param    v <datalist> A list of values.
  \param    i <integer> The sort column index for iterable elements.
  \param    d <integer> The recursive sort depth.
  \param    r <boolean> Reverse the sort order.
  \param    s <boolean> Order ranges by their numerical sum.

  \returns  \<list> With all elements sorted in ascending order.
            Returns \b undef when \p v is not defined or is not a list.

  \details

    Elements are ordered using compare(). See its documentation for a
    description of the parameter \p s. To recursively sort all
    elements, set \p d greater than, or equal to, the maximum level of
    hierarchy in \p v.

    See [Wikipedia] for more information.

  [Wikipedia]: https://en.wikipedia.org/wiki/Quicksort
*******************************************************************************/
function qsort2
(
  v,
  i,
  d = 0,
  r = false,
  s = true
) = not_defined(v) ? undef
  : !is_list(v) ? undef
  : is_empty(v) ? empty_lst
  : let
    (
      mp = v[floor(len(v)/2)],
      me = not_defined(i) ? mp : mp[i],

      lt =
      [
        for (j = v)
        let(k = not_defined(i) ? j : j[i])
          if (compare(me, k, s) == -1)
            ((d > 0) && is_list(k)) ? qsort2(k, i, d-1, r, s) : j
      ],
      eq =
      [
        for (j = v)
        let(k = not_defined(i) ? j : j[i])
          if (compare(me, k, s) ==  0)
            ((d > 0) && is_list(k)) ? qsort2(k, i, d-1, r, s) : j
      ],
      gt =
      [
        for (j = v)
        let(k = not_defined(i) ? j : j[i])
          if (compare(me, k, s) == +1)
            ((d > 0) && is_list(k)) ? qsort2(k, i, d-1, r, s) : j
      ],
      sp = (r == true) ?
           concat(qsort2(gt, i, d, r, s), eq, qsort2(lt, i, d, r, s))
         : concat(qsort2(lt, i, d, r, s), eq, qsort2(gt, i, d, r, s))
    )
    (d > 0) ? qsort2(sp, i, d-1, r, s) : sp;

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE validate;
  BEGIN_OPENSCAD;
    include <datatypes.scad>;
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

    test_ids = table_get_allrow_ids( test_r );

    // expected columns: ("id" + one column for each test)
    good_c = pmerge([concat("id", test_ids), concat("identifier", test_ids)]);

    // expected rows: ("golden" test results), use 's' to skip test
    skip = -1;  // skip test

    good_r =
    [ // function
      ["lstr",
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
      ["lstr_html_B",
        "<b>undef</b>",                                     // t01
        empty_str,                                          // t02
        "<b>[0 : 0.5 : 9]</b>",                             // t03
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
      ["limit_12",
        undef,                                              // t01
        empty_lst,                                          // t02
        [0:0.5:9],                                          // t03
        "A string",                                         // t04
        ["orange","apple","grape","banana"],                // t05
        ["b","a","n","a","n","a","s"],                      // t06
        [undef],                                            // t07
        [[1,2],[2,2]],                                      // t08
        ["ab",[1,2],[2,2],[2,2]],                           // t09
        [[1,2,2],[2,2,2],[2,2,2],["a","b","c"]],            // t10
        [1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2]                   // t11
      ],
      ["sum",
        undef,                                              // t01
        0,                                                  // t02
        85.5,                                               // t03
        undef,                                              // t04
        undef,                                              // t05
        undef,                                              // t06
        undef,                                              // t07
        [3,5],                                              // t08
        undef,                                              // t09
        [undef,undef,undef],                                // t10
        120                                                 // t11
      ],
      ["mean",
        undef,                                              // t01
        0,                                                  // t02
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
      ["eselect_F",
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
      ["eselect_L",
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
      ["eselect_1",
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
      ["smerge",
        undef,                                              // t01
        empty_lst,                                          // t02
        [[0:0.5:9]],                                        // t03
        ["A string"],                                       // t04
        ["orange","apple","grape","banana"],                // t05
        ["b","a","n","a","n","a","s"],                      // t06
        [undef],                                            // t07
        [1,2,2,3],                                          // t08
        ["ab",1,2,2,3,4,5],                                 // t09
        [1,2,3,4,5,6,7,8,9,"a","b","c"],                    // t10
        [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]             // t11
      ],
      ["pmerge",
        undef,                                              // t01
        empty_lst,                                          // t02
        undef,                                              // t03
        ["A string"],                                       // t04
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
      ["qsort",
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
      ["qsort_1R",
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
      ["qsort2_1R",
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
      ["qsort2_HR",
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

    // sanity-test tables
    table_check( test_r, test_c, false );
    table_check( good_r, good_c, false );

    // validate helper function and module
    function get_value( vid ) = table_get(test_r, test_c, vid, "tv");
    module run_test( fname, fresult, vid )
    {
      value_text = table_get(test_r, test_c, vid, "td");
      pass_value = table_get(good_r, good_c, fname, vid);

      test_pass = validate( cv=fresult, t="equals", ev=pass_value, pf=true );
      test_text = validate( str(fname, "(", get_value(vid), ")=", pass_value), fresult, "equals", pass_value );

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
    for (vid=test_ids) run_test( "lstr", lstr(get_value(vid)), vid );
    for (vid=test_ids) run_test( "lstr_html_B", lstr_html(get_value(vid),p="b"), vid );
    for (vid=test_ids) run_test( "consts", consts(get_value(vid)), vid );
    log_info( "not testing: dround()" );
    log_info( "not testing: sround()" );
    for (vid=test_ids) run_test( "limit_12", limit(get_value(vid),1,2), vid );
    for (vid=test_ids) run_test( "sum", sum(get_value(vid)), vid );
    for (vid=test_ids) run_test( "mean", mean(get_value(vid)), vid );
    log_info( "not testing: ciselect()" );
    log_info( "not testing: cmvselect()" );
    for (vid=test_ids) run_test( "eselect_F", eselect(get_value(vid),f=true), vid );
    for (vid=test_ids) run_test( "eselect_L", eselect(get_value(vid),l=true), vid );
    for (vid=test_ids) run_test( "eselect_1", eselect(get_value(vid),i=1), vid );
    for (vid=test_ids) run_test( "smerge", smerge(get_value(vid)), vid );
    for (vid=test_ids) run_test( "pmerge", pmerge(get_value(vid)), vid );
    for (vid=test_ids) run_test( "qsort", qsort(get_value(vid)), vid );
    for (vid=test_ids) run_test( "qsort_1R", qsort(get_value(vid), i=1, r=true), vid );
    for (vid=test_ids) run_test( "qsort2_1R", qsort2(get_value(vid), i=1, r=true), vid );
    for (vid=test_ids) run_test( "qsort2_HR", qsort2(get_value(vid), d=5, r=true), vid );

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
