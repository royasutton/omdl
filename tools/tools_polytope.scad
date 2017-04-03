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

//! Label the vertices, paths, and edges of a polytope.
/***************************************************************************//**
  \param    c <coords-3d|coords-2d> A list of 3d or 2d coordinate points.
  \param    f <integer-list-list> A list of faces (or paths) that enclose
            the shape where each face is a list of coordinate indexes.
  \param    e <integer-list-2-list> A list of edges where each edge is
            a list of two coordinate indexes.

  \param    lv <boolean> Label vertex.
  \param    lf <boolean> Label faces.
  \param    le <boolean> Label edges.

  \param    sp <boolean> Show polyhedron shape.

  \param    ts <decimal> The text size override.
  \param    th <decimal> The text extrusion height override.

  \param    to <vector-3d|vector-2d> The text offset override.
  \param    tr <decimal-list-1:3|decimal> The text rotation (in degrees).

  \details

  \note     Parameter \p f is optional for polygons. When it is not
            given, the listed order of the coordinates \p c establishes
            the polygon path.
  \note     When \p e is not specified, it is computed from \p f using
            polytope_faces2edges().
*******************************************************************************/
module polytope_number
(
  c,
  f,
  e,
  lv = true,
  lf = true,
  le = true,
  sp = false,
  ts,
  th,
  to,
  tr = 0
)
{
  fm = defined_or(f, [consts(len(c))]);
  el = is_defined(e) ? e : polytope_faces2edges(fm);

  bb = polytope_limits (c, fm, d=[0:2], s=true);
  pd = all_defined(bb) ? 3 : 2;

  fs = defined_or(ts, ceil(max(bb)/50));
  fh = defined_or(th, ceil(min(bb)/100));
  fo = defined_or(to, [0, 0, fs/2]);

  // vertices
  color("green")
  for (i = get_index(c, lv))
  {
    p = c[i];
    n = polytope_vertex_n(c, fm, i);

    translate(p)
    orient_ll(rl=n)
    translate(fo) rotate(tr)
    if (pd == 3)
      linear_extrude(fh, center=true)
      text(str(i), size=fs, halign="center", valign="center");
    else
      text(str(i), size=fs, halign="center", valign="center");
  }

  // faces
  color("red")
  for (i = get_index(fm, lf))
  {
    p = polytope_face_m(c, l=fm[i]);
    n = polytope_face_n(c, l=fm[i]);

    translate(p)
    orient_ll(rl=n)
    translate(fo) rotate(tr)
    if (pd == 3)
      linear_extrude(fh, center=true)
      text(str(i), size=fs, halign="center", valign="center");
    else
      text(str(i), size=fs, halign="center", valign="center");
  }

  // edges
  color("blue")
  for (i = get_index(el, le))
  {
    p = mean([c[first(el[i])], c[second(el[i])]]);
    n = polytope_edge_n(c, fm, el, i);

    translate(p)
    orient_ll(rl=n)
    translate(fo) rotate(tr)
    if (pd == 3)
      linear_extrude(fh, center=true)
      text(str(i), size=fs, halign="center", valign="center");
    else
      text(str(i), size=fs, halign="center", valign="center");
  }

  // show shape
  if (sp == true)
  {
    if (pd == 3)
      polyhedron(c, fm);

    if (pd == 2)
      polygon(c, fm);
  }
}

//! Assemble a polytope skeletal frame using child objects.
/***************************************************************************//**
  \param    c <coords-3d|coords-2d> A list of 3d or 2d coordinate points.
  \param    f <integer-list-list> A list of faces (or paths) that enclose
            the shape where each face is a list of coordinate indexes.
  \param    e <integer-list-2-list> A list of edges where each edge is
            a list of two coordinate indexes.

  \param    vc <boolean> Vertex children enabled.
  \param    fc <boolean> Face children enabled.
  \param    ec <boolean> Edge children enabled.

  \details

    This function accepts one to three child objects. The first is
    mandatory and must be a 2d object. This 2d object is linearly
    extruded along all edges. The remaining objects are optional and
    are 3d objects. The second child is translated to the center of
    each vertex and the third is translated to the mean coordinate of
    each face.

    \b Example

    \code{.c}
    include <tools/tools_polytope.scad>;
    s = second(xy_plane_os) * 25;
    p = linear_extrude_pp2pf(s, h=50);

    polytope_frame(first(p), second(p))
    {
      circle(r=2);
      color("grey") sphere(r=4);
      color("blue") cube(4);
    }
    \endcode

  \note     Parameter \p f is optional for polygons. When it is not
            given, the listed order of the coordinates \p c establishes
            the polygon path.
  \note     When \p e is not specified, it is computed from \p f using
            polytope_faces2edges().
*******************************************************************************/
module polytope_frame
(
  c,
  f,
  e,
  vc = true,
  fc = true,
  ec = true
)
{
  fm = defined_or(f, [consts(len(c))]);
  el = is_defined(e) ? e : polytope_faces2edges(fm);

  // edge
  if ((ec == true) && ($children > 0))
  {
    for (i = get_index(el))
    {
      p1 = dimension_2to3_v(c[first(el[i])]);   // 3d points required for
      p2 = dimension_2to3_v(c[second(el[i])]);  // polygons.

      translate((p1+p2)/2)
      orient_ll(rl=[p1, p2])
      linear_extrude(distance_pp(p1, p2), center=true)
      children(0);
    }
  }

  // vertex
  if ((vc == true) && ($children > 1))
  {
    for (i = get_index(c))
    {
      p = c[i];
      n = polytope_vertex_n(c, fm, i);

      translate(p)
      orient_ll(rl=n)
      children(1);
    }
  }

  // face
  if ((fc == true) && ($children > 2))
  {
    for (i = get_index(fm))
    {
      p = polytope_face_m(c, l=fm[i]);
      n = polytope_face_n(c, l=fm[i]);

      translate(p)
      orient_ll(rl=n)
      children(2);
    }
  }
}

//! The 2d bounding box shape for a polygon.
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

    \sa polytope_limits for warning about secondary shapes.
*******************************************************************************/
module polygon_bbox
(
  c,
  p,
  a
)
{
  b = polytope_limits(c=c, f=p, a=a, d=[0:1], s=false);

  translate([b[0][0], b[1][0]])
  square([b[0][1]-b[0][0], b[1][1]-b[1][0]]);
}

//! The 3d bounding box shape for a polyhedron.
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

    \sa polytope_limits.
*******************************************************************************/
module polyhedron_bbox
(
  c,
  f,
  a
)
{
  b = polytope_limits(c=c, f=f, a=a, d=[0:2], s=false);

  translate([b[0][0], b[1][0], b[2][0]])
  cube([b[0][1]-b[0][0], b[1][1]-b[1][0], b[2][1]-b[2][0]]);
}

//! @}
//! @}

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
