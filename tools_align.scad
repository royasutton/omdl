//! Shape alignment tools.
/***************************************************************************//**
  \file   tools_align.scad
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

  \ingroup tools tools_align
*******************************************************************************/

include <math.scad>;

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \addtogroup tools
  @{

  \defgroup tools_align Alignment
  \brief    Shape alignment tools.
  @{
*******************************************************************************/
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
//
//----------------------------------------------------------------------------//
module align_axis2v
(
  v,
  t = 0,
  r = 0,
  a = 2
)
{
  vt = is_iterable(v[0]) ? (len(v)>1) ? v[1] : v[0] : v;
  vi = is_iterable(v[0]) ? (len(v)>1) ? v[0] : consts(len(v[0]), 0)
     : is_iterable(v) ? consts(len(v), 0) : 0;

  pa = acos((vt[2]-vi[2]) / distance_pp(vt, vi));
  aa = atan2(vt[1]-vi[1], vt[0]-vi[0]);

  tv  = (t == 0) ? origin3d
      : (t == 1) ? vi
      : (t == 2) ? (vt+vi)/2
      : (t == 3) ? vt
      : (t == 4) ? vt+vi
      : origin3d;

  rv = (a == 0) ? [[ 0, -90, r], [0, pa, aa]]
     : (a == 1) ? [[90,   0, r], [0, pa, aa]]
     : (a == 2) ? [[ 0,   0, r], [0, pa, aa]]
     : [origin3d, origin3d];

  translate(tv)
  rotate(rv[1])
  rotate(rv[0])
  children();
}

//! @}
//! @}

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
