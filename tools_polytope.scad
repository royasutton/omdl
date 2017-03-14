//! Polygon and polyhedron tools.
/***************************************************************************//**
  \file   tools_polytope.scad
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

  \ingroup tools tools_polytope
*******************************************************************************/

include <math_polytope.scad>;
include <tools_align.scad>;

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \addtogroup tools
  @{

  \defgroup tools_polytope Polytope
  \brief    Polygon and polyhedron tools.
  @{
*******************************************************************************/
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
//
//----------------------------------------------------------------------------//
module polygon_bbox
(
  c,
  p,
  a
)
{
  b = polytope_bboxlimits(c=c, f=p, a=a, d=[0:1], s=false);

  translate([b[0][0], b[1][0]])
  square([b[0][1]-b[0][0], b[1][1]-b[1][0]]);
}

//----------------------------------------------------------------------------//
//
//----------------------------------------------------------------------------//
module polygon_number
(
  c,
  p,
  lp = true,
  lc = true,
  le = true,
  sp = false,
  pc = false,
  ts,
  to,
  tr = 0
)
{
  pm = defined_or(p, [consts(len(c))]);

  fs = defined_or(ts, mean(polytope_bboxlimits (c, pm, d=[0:1], s=true))/50);
  fo = defined_or(to, [0, 0, fs/2]);

  np = (lp == true) ?
       consts(len(pm))
     : is_number(lp) ? [lp]
     : is_range(lp) ? [for (i=lp) i]
     : all_numbers(lp) ? lp
     : undef;

  nc = (lc == true) ?
       consts(len(c))
     : is_number(lc) ? [lc]
     : is_range(lc) ? [for (i=lc) i]
     : all_numbers(lc) ? lc
     : undef;

  ne = (le == true) ?
       consts(len(c))
     : is_number(le) ? [le]
     : is_range(le) ? [for (i=le) i]
     : all_numbers(le) ? le
     : undef;

  el = not_defined(ne) ? undef : polytope_faces2edges(pm);

  // paths
  if (is_defined(np))
  color("red")
  for (i = np)
  {
    t = (pc == true) ?
        polygon2d_centroid(c, [pm[i]])
      : mean([for (j=pm[i]) c[j]]);

    translate(t) translate(fo) rotate(tr)
    text(str(i), size=fs, halign="center", valign="center");
  }

  // vertices
  if (is_defined(nc))
  color("green")
  for (i = nc)
  {
    t = c[i];

    translate(t) translate(fo) rotate(tr)
    text(str(i), size=fs, halign="center", valign="center");
  }

  // edges
  if (is_defined(ne))
  color("blue")
  for (i = ne)
  {
    t = mean([c[first(el[i])], c[second(el[i])]]);

    translate(t) translate(fo) rotate(tr)
    text(str(i), size=fs, halign="center", valign="center");
  }

  // polygon
  if (sp == true)
    polygon(c, p);
}

//----------------------------------------------------------------------------//
//
//----------------------------------------------------------------------------//
module polyhedron_bbox
(
  c,
  f,
  a
)
{
  b = polytope_bboxlimits(c=c, f=f, a=a, d=[0:2], s=false);

  translate([b[0][0], b[1][0], b[2][0]])
  cube([b[0][1]-b[0][0], b[1][1]-b[1][0], b[2][1]-b[2][0]]);
}

//! @}
//! @}

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
