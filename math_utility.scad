//! Miscellaneous mathematical utility functions.
/***************************************************************************//**
  \file   math_utility.scad
  \author Roy Allen Sutton
  \date   2017

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

  \ingroup math math_utility
*******************************************************************************/

include <math_bitwise.scad>;

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \addtogroup math
  @{

  \defgroup math_utility Miscellaneous Utilities
  \brief    Miscellaneous mathematical utility functions.
  @{
*******************************************************************************/
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
// general / miscellaneous
//----------------------------------------------------------------------------//

//! Round a number to a specified number of digits after the decimal point.
/***************************************************************************//**
  \param    v <number> A numeric value.
  \param    d <integer> The maximum number of decimals.

  \returns  <decimal> \p v with a most \p d decimal digits truncated and
            rounded-up if the following digit is 5 or greater.
            Returns \b undef when \p v is not defined or is not a number.
*******************************************************************************/
function dround
(
  v,
  d = 6
) = round(v * pow(10, d)) / pow(10, d);

//! Round a number to a specified number of significant figures.
/***************************************************************************//**
  \param    v <number> A numeric value.
  \param    d <integer> The number of significant figures.

  \returns  <number> \p v rounded-up to \p d significant figures.
            Returns \b undef when \p v is not defined or is not a number.

  \details

    See [Wikipedia](https://en.wikipedia.org/wiki/Significant_figures)
    for more information.
*******************************************************************************/
function sround
(
  v,
  d = 6
) = (v == 0) ? 0
  : let(n = floor(log(abs(v))) + 1 - d)
    round(v * pow(10, -n)) * pow(10, n);

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
) = min(max(v,l),u);

//----------------------------------------------------------------------------//
// statistical / informational
//----------------------------------------------------------------------------//

//! Generate a histogram for the elements of an iterable value.
/***************************************************************************//**
  \param    v \<value> An iterable value.
  \param    m <integer> The output mode (a 8-bit encoded integer).

  \param    cs <vector> A vector of strings [s1, s2, s3, fs]
            (for custom field formatting).

  \returns  <vector|string> with the occurrence frequency of all the elements
            of \p v.

  \details

    The custom formatting strings are inserted in the output as
    follows: <tt>'s1, value, s2, frequency, s3, fs'</tt>. See vstr_html()
    for description of html formatting tags \p cb, \p cp, \p ca, \p cf.

    Output mode:

    | bit | Description             |  0        |  1          |
    |:---:|:------------------------|:----------|:------------|
    |  0  | output mode             | numerical | string      |
    | 1-3 | string mode format      | see table | see table   |
    |  4  | sort data elements      | yes       | no          |
    |  5  | sort function selection | qsort2    | qsort       |
    |  6  | sort order              | ascending | descending  |
    |  7  | field separator mode    | skip last | all         |

    String format:

    |     | B3  | B2  | B1  | Description       |
    |:---:|:---:|:---:|:---:|:------------------|
    |  0  |  0  |  0  |  0  | vector of strings |
    |  1  |  0  |  0  |  1  | text format 1     |
    |  4  |  1  |  0  |  0  | html format 1     |
    |  7  |  1  |  1  |  1  | custom            |

*******************************************************************************/
function hist
(
  v,
  m = 0,
  cs,
  cb,
  cp,
  ca,
  cf,
  d = false
) = let
    (
      fm = bitwise_is_equal(m, 7, 1) ? true : false,
      so = bitwise_is_equal(m, 6, 1) ? true : false,
      sv = bitwise_is_equal(m, 4, 1) ? v
         : bitwise_is_equal(m, 5, 1) ? qsort(v, r=so) : qsort2(v, r=so),

      hv = [for (i=unique(sv)) [i, len(find(i, sv, 0))]]
    )
    bitwise_is_equal(m, 0, 0) ? hv
  : let
    (
      sm = bitwise_imi(m, 3, 1)
    )
    (sm == 0) ? [for (i=hv) str(first(i), "x", second(i))]
  : let
    (
      s1 = (sm==1) ? empty_str
         : (sm==4) ? empty_str
         :           (len(cs) > 0 ? cs[0] : empty_str),
      s2 = (sm==1) ? "<"
         : (sm==4) ? "x"
         :           (len(cs) > 1 ? cs[1] : empty_str),
      s3 = (sm==1) ? ">"
         : (sm==4) ? empty_str
         :           (len(cs) > 2 ? cs[2] : empty_str),
      fs = (sm==1) ? " "
         : (sm==4) ? ", "
         :           (len(cs) > 3 ? cs[3] : empty_str),
      fb = (sm==1) ? undef
         : (sm==4) ? undef
         :           cb,
      fp = (sm==1) ? undef
         : (sm==4) ? [undef, undef, ["i", "sup"], ["b", "sup"], undef]
         :           cp,
      fa = (sm==1) ? undef
         : (sm==4) ? [undef, undef, undef, undef, undef, "br"]
         :           ca,
      ff = (sm==1) ? undef
         : (sm==4) ? undef
         :           cf
    )
    vstr
    ([
      for (i=[0:len(hv)-1])
        vstr_html
        (
          [s1, first(hv[i]), s2, second(hv[i]), s3, if ((i<(len(hv)-1)) || fm) fs],
          b=fb, p=fp, a=fa, f=ff, d=d
        ),
    ]);

//! @}
//! @}

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
