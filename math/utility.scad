//! Miscellaneous mathematical utilities.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2017-2018

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

    \amu_pathid parent      (++path)
    \amu_pathid group       (++path ++stem)

    \amu_define group_name  (Utilities)
    \amu_define group_brief (Miscellaneous mathematical utilities.)

  \ingroup \amu_eval(${parent} ${group})
*******************************************************************************/

include <bitwise.scad>;

//----------------------------------------------------------------------------//
// group.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \addtogroup \amu_eval(${parent})
  @{

  \defgroup \amu_eval(${group} ${group_name})
  \brief    \amu_eval(${group_brief})
  @{
*******************************************************************************/

//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
// statistical / informational
//----------------------------------------------------------------------------//

//! Generate a histogram for the elements of a list of values.
/***************************************************************************//**
  \param    v <data> A list of values.
  \param    m <integer> The output mode (a 5-bit encoded integer).

  \param    cs <string-list-4> A list of strings [s1, s2, s3, fs]
            (for custom field formatting).

  \returns  <list|string> with the occurrence frequency of the elements
            of \p v.

  \details

    The custom formatting strings are inserted in the output stream as
    follows:

    \verbatim
    s1, value, s2, value-frequency, s3, fs
    \endverbatim

    See lstr_html() for description of the html formatting parameters
    \p cb, \p cp, \p ca, \p cf, and \p d.

    Output mode selection:

    | bit | Description             |  0          |  1          |
    |:---:|:------------------------|:------------|:------------|
    |  0  | output mode             | numerical   | string      |
    | 1-3 | string mode format      | see table   | see table   |
    |  4  | field separator mode    | not at end  | all         |

    String output modes:

    |     | B3  | B2  | B1  | B0  | Description       |
    |:---:|:---:|:---:|:---:|:---:|:------------------|
    |  1  |  0  |  0  |  0  |  1  | list of strings   |
    |  3  |  0  |  0  |  1  |  1  | text format 1     |
    |  9  |  1  |  0  |  0  |  1  | html format 1     |
    | 15  |  1  |  1  |  1  |  1  | custom formating  |

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
      hv = [for (i=unique(v)) [i, len(find(i, v, 0))]]
    )
    bitwise_is_equal(m, 0, 0) ? hv
  : let
    (
      sm = bitwise_imi(m, 3, 1),
      fm = bitwise_is_equal(m, 4, 1) ? true : false
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
         : (sm==4) ? [undef, undef, undef, undef, undef, ["br"]]
         :           ca,
      ff = (sm==1) ? undef
         : (sm==4) ? undef
         :           cf
    )
    lstr
    ([
      for (i=[0:len(hv)-1])
        lstr_html
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
