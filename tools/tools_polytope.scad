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

include <math/math_polytope.scad>;
include <tools/tools_align.scad>;

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \addtogroup tools
  @{

  \defgroup tools_polytope Polytope
  \brief    Polygon and polyhedron tools.
  @{
*******************************************************************************/
//----------------------------------------------------------------------------//

//! The 2d bounding box shape for a polygon definition.
/***************************************************************************//**
  \param    c <coords-2d> A list of 2d cartesian coordinates
            [[x, y], ...].
  \param    p <integer-list-list> An \em optional list of paths that
            define one or more closed shapes where each is a list of
            coordinate indexes.
  \param    a <decimal-list-2> The box padding.
            A list of lengths to equally pad the box dimensions.

  \details

    The 2d box shape that exactly encloses the defined 2d polygon with
    the box sides oriented parallel to the coordinate axes.

  \note     When \p p is not given, the listed order of the coordinates
            \p c establishes the path.

    \sa polytope_bboxlimits for warning about secondary shapes.
*******************************************************************************/
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

//! Label the vertices, paths, and edges of a polygon.
/***************************************************************************//**
  \param    c <coords-2d> A list of 2d cartesian coordinates
            [[x, y], ...].
  \param    p <integer-list-list> An \em optional list of paths that
            define one or more closed shapes where each is a list of
            coordinate indexes.

  \param    lc <boolean> Label vertex coordinates.
  \param    lp <boolean> Label paths.
  \param    le <boolean> Label edges.

  \param    sp <boolean> Show polygon shape.
  \param    pc <boolean> Place path labels at path centroid.

  \param    ts <decimal> The text size (to override the default).
  \param    to <vector-3d> The text offset vector [x, y, z].
  \param    tr <decimal> The text rotation.

  \details

  \note     When \p p is not given, the listed order of the coordinates
            \p c establishes the path.
*******************************************************************************/
module polygon_number
(
  c,
  p,
  lc = true,
  lp = true,
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

  nc = (lc == true) ?
       consts(len(c))
     : is_number(lc) ? [lc]
     : is_range(lc) ? [for (i=lc) i]
     : all_numbers(lc) ? lc
     : undef;

  np = (lp == true) ?
       consts(len(pm))
     : is_number(lp) ? [lp]
     : is_range(lp) ? [for (i=lp) i]
     : all_numbers(lp) ? lp
     : undef;

  ne = (le == true) ?
       consts(len(c))
     : is_number(le) ? [le]
     : is_range(le) ? [for (i=le) i]
     : all_numbers(le) ? le
     : undef;

  el = not_defined(ne) ? undef : polytope_faces2edges(pm);

  // vertices
  if (is_defined(nc))
  color("green")
  for (i = nc)
  {
    t = c[i];

    translate(t) translate(fo) rotate(tr)
    text(str(i), size=fs, halign="center", valign="center");
  }

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

//! The 3d bounding box shape for a polyhedron definition.
/***************************************************************************//**
  \param    c <coords-3d> A list of 3d cartesian coordinates
            [[x, y, z], ...].
  \param    f <integer-list-list> A list of faces that enclose
            the shape where each face is a list of coordinate indexes.
  \param    a <decimal-list-3> The box padding.
            A list of lengths to equally pad the box dimensions.

  \details

    The 3d box shape that completely encloses the defined 3d polyhedron
    with the box sides oriented parallel to the coordinate axes.

    \sa polytope_bboxlimits.
*******************************************************************************/
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
