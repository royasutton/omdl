//! Polytope shapes, conversions, properties, and tests functions.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2017-2024

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

    \amu_define group_name  (Polytope Math)
    \amu_define group_brief (Polytope mathematical functions.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_include (include/amu/includes_required.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
// polytope
//----------------------------------------------------------------------------//

//! List the edge coordinate index pairs of a polytope.
/***************************************************************************//**
  \param    f <integer-list-list> A list of faces (or paths) that enclose
            the shape where each face is a list of coordinate indexes.

  \returns  <integer-list-2-list> A list of edges where each edge is
            a list of two coordinate indexes that form the shape.

  \details

  \note     Although the edge list is not sorted, each pair is sorted
            with the smallest index first.
*******************************************************************************/
function polytope_faces2edges
(
  f
) =
  let
  (
    el =
    [
      for (ip = [for (fi = f) for (ai = sequence_ns(fi, n=2, s=1, w=true)) ai])
        [min(ip), max(ip)]
    ]
  )
  unique(el);

//! Determine the bounding limits of a polytope.
/***************************************************************************//**
  \param    c <coords-3d|coords-2d> A list of 3d or 2d cartesian
            coordinates [[x, y (, z)], ...].
  \param    f <integer-list-list> A list of faces (or paths) that enclose
            the shape where each face is a list of coordinate indexes.
  \param    a <decimal-list-1:3|decimal> The box padding.
            A list of lengths to equally pad the box dimensions.
  \param    d <range|list|integer> The dimensions to consider. A range
            of dimensions, a list of dimensions, or a single dimension.
  \param    s <boolean> Return box size rather than coordinate limits.

  \returns  <datastruct> The bounding-box limits (see: table).

  \details

  The returned datastruct will be one of the following forms:

  |     |  s    |     x     |     y     |     z     |  datastruct form      |
  |:---:|:-----:|:---------:|:---------:|:---------:|:---------------------:|
  | 2d  | false | [min,max] | [min,max] | -         | decimal-list-2-list-2 |
  | 2d  | true  |  max-min  |  max-min  | -         | decimal-list-list-2   |
  | 3d  | false | [min,max] | [min,max] | [min,max] | decimal-list-2-list-3 |
  | 3d  | true  |  max-min  |  max-min  |  max-min  | decimal-list-list-3   |

  \note     When \p f is not specified, all coordinates are used to
            determine the geometric limits, which, simplifies the
            calculation. Parameter \p f is needed when a subset of the
            coordinates should be considered.
  \note     When \p d is not specified, a check will be performed to
            see if all coordinates of \p c are 3, 2, or 1 dimensional
            and, if so, all axes for the determined dimension will be
            used for \p d.
  \warning  This function does not track secondary shapes subtraction as
            implemented by the polygon() function.
*******************************************************************************/
function polytope_limits
(
  c,
  f,
  a,
  d,
  s = true
) =
  [
    let
    (
      ax = is_undef(d)
         ? (
              all_len(c, 3) ? [0,1,2]
            : all_len(c, 2) ? [0,1]
            : all_len(c, 1) ? [0]
            : undef
           )
         : is_range(d) ? [for (di=d) di]
         : is_list(d) ? d
         : is_integer(d) ? [d]
         : undef,

      ad = (is_defined(a) && is_scalar(a)) ? a : 0,
      ap = [for (j = ax) defined_e_or(a, j, ad)],

      pm = is_defined(f)
        ? [for (j = ax) [for (m = f) for (i=[0 : len(m)-1]) c[m[i]][j]]]
        : [for (j = ax) [for (i = c) i[j]]],

      b = [for (j = ax) [min(pm[j]), max(pm[j])] + [-ap[j]/2, +ap[j]/2]]
    )
    for (j = ax)
      (s == true) ? b[j][1] - b[j][0] : [b[j][0], b[j][1]]
  ];

//! Get a line from an edge or any two vetices of a polytope.
/***************************************************************************//**
  \param    c <coords-3d|coords-2d> A list of 3d or 2d coordinate points.

  \param    f <integer-list-list> A list of faces (or paths) that enclose
            the shape where each face is a list of coordinate indexes.
  \param    e <integer-list-2-list> A list of edges where each edge is
            a list of two coordinate indexes.

  \param    i <integer> A line specified as an edge index.
  \param    l <integer-list-2> A line specified as a list of coordinate
            index pairs.

  \param    r <boolean> Reverse the start and end points of the line
            specified as an edge index \p i.

  \returns  <line-3d|line-2d> The line as a pair of coordinates.

  \details

  \note     Parameter \p f is optional for polygons. When it is not
            given, the listed order of the coordinates \p c establishes
            the polygon path.
  \note     When \p e is not specified, it is computed from \p f using
            polytope_faces2edges() iff the line is identified by \p i.
*******************************************************************************/
function polytope_line
(
  c,
  f,
  e,
  i,
  l,
  r = false
) = is_defined(l) ? [c[first(l)], c[second(l)]]
  : is_undef(i) ? undef
  : let
    (
      fm = defined_or(f, [consts(len(c))]),
      el = defined_or(e, polytope_faces2edges(fm)),
      sl = el[i]
    )
    (r == false)
  ? [c[second(sl)], c[first(sl)]]
  : [c[first(sl)], c[second(sl)]];

//! List the adjacent vertices for a given polytope vertex.
/***************************************************************************//**
  \param    f <integer-list-list> A list of faces (or paths) that enclose
            the shape where each face is a list of coordinate indexes.

  \param    i <integer> A vertex index.

  \returns  <integer-list> The list of adjacent vertex indexes for the
            given vertex index.

  \details

    The adjacent vertices are those neighboring vertices that are
    directly connected to the given vertex by a common edge.

  \note     Parameter \p f is optional for polygons. When it is not
            given, the listed order of the coordinates \p c establishes
            the polygon path.
*******************************************************************************/
function polytope_vertex_adjacent_vertices
(
  f,
  i
) =
  let
  (
    vn =
    [
      for (fi = f) let (fn = len(fi))
        for (j = [0:fn-1])
          if (i == fi[j])
            for (k = [-1, 1])
              fi[index_c(j + k, fn)]
    ]
  )
  unique(vn);

//! List the adjacent face indexes for a polytope vertex.
/***************************************************************************//**
  \param    f <integer-list-list> A list of faces (or paths) that enclose
            the shape where each face is a list of coordinate indexes.
  \param    i <integer> The vertex index.

  \returns  <integer-list> The list of face indexes adjacent to the
            given polytope vertex.
*******************************************************************************/
function polytope_vertex_adjacent_faces
(
  f,
  i
) = [for (fi = [0:len(f)-1]) if (exists(i, f[fi])) fi];

//! List the adjacent face indexes for a polytope edge.
/***************************************************************************//**
  \param    f <integer-list-list> A list of faces (or paths) that enclose
            the shape where each face is a list of coordinate indexes.
  \param    e <integer-list-2-list> A list of edges where each edge is
            a list of two coordinate indexes.
  \param    i <integer> The edge index.

  \returns  <integer-list> The list of face indexes adjacent to the
            given polytope edge.

  \details

  \note     When \p e is not specified, it is computed from \p f using
            polytope_faces2edges().
*******************************************************************************/
function polytope_edge_adjacent_faces
(
  f,
  e,
  i
) = let (el = is_defined(e) ? e : polytope_faces2edges(f))
    [
      for (fi = [0:len(f)-1])
        if (exists(first(el[i]), f[fi]) && exists(second(el[i]), f[fi]))
          fi
    ];

//! Get a normal vector for a polytope vertex.
/***************************************************************************//**
  \param    c <coords-3d|coords-2d> A list of 3d or 2d coordinate points.
  \param    f <integer-list-list> A list of faces (or paths) that enclose
            the shape where each face is a list of coordinate indexes.
  \param    i <integer> The vertex index.

  \returns  <vector-3d> A normal vector for the polytope vertex.

  \details

    The normal is computed as the mean of the adjacent faces.

  \note     Parameter \p f is optional for polygons. When it is not
            given, the listed order of the coordinates \p c establishes
            the polygon path.
*******************************************************************************/
function polytope_vertex_normal
(
  c,
  f,
  i
) = let
    (
      fm = defined_or(f, [consts(len(c))])
    )
    mean([for (j=polytope_vertex_adjacent_faces(fm, i)) unit_l(polytope_face_normal(c, l=fm[j]))]);

//! Get a normal vector for a polytope edge.
/***************************************************************************//**
  \param    c <coords-3d|coords-2d> A list of 3d or 2d coordinate points.
  \param    f <integer-list-list> A list of faces (or paths) that enclose
            the shape where each face is a list of coordinate indexes.
  \param    e <integer-list-2-list> A list of edges where each edge is
            a list of two coordinate indexes.
  \param    i <integer> The edge index.

  \returns  <vector-3d> A normal vector for the polytope edge.

  \details

    The normal is computed as the mean of the adjacent faces.

  \note     Parameter \p f is optional for polygons. When it is not
            given, the listed order of the coordinates \p c establishes
            the polygon path.
  \note     When \p e is not specified, it is computed from \p f using
            polytope_faces2edges().
*******************************************************************************/
function polytope_edge_normal
(
  c,
  f,
  e,
  i
) = let
    (
      fm = defined_or(f, [consts(len(c))]),
      el = is_defined(e) ? e : polytope_faces2edges(fm)
    )
    mean([for (j=polytope_edge_adjacent_faces(fm, el, i)) unit_l(polytope_face_normal(c, l=fm[j]))]);

//! Get the normal vector of a polytope face.
/***************************************************************************//**
  \param    c <coords-3d|coords-2d> A list of 3d or 2d coordinate points.
  \param    f <integer-list-list> A list of faces (or paths) that enclose
            the shape where each face is a list of coordinate indexes.

  \param    i <integer> The face specified as an face index.
  \param    l <integer-list> The face-plane specified as a list of three
            or more coordinate indexes that are a part of the face.

  \param    cw <boolean> Face vertex ordering.

  \returns  <vector-3d> The normal vector of a polytope face.

  \details

    The face can be identified using either parameter \p i or \p l.
    When using \p l, the parameter \p f is not required.

  \note     Parameter \p f is optional for polygons. When it is not
            given, the listed order of the coordinates \p c establishes
            the polygon path.
*******************************************************************************/
function polytope_face_normal
(
  c,
  f,
  i,
  l,
  cw = true
) = let
    (
      ci = is_defined(l) ? l : defined_or(f, [consts(len(c))])[i],
      pc = [for (i = [0:2]) let (p = c[ci[i]]) (len(p) == 3) ? p : [p[0], p[1], 0]]
    )
    cross(pc[0]-pc[1], pc[2]-pc[1]) * ((cw == true) ? 1 : -1);

//! Get the mean coordinate of all vertices of a polytope face.
/***************************************************************************//**
  \param    c <coords-3d|coords-2d> A list of 3d or 2d coordinate points.
  \param    f <integer-list-list> A list of faces (or paths) that enclose
            the shape where each face is a list of coordinate indexes.

  \param    i <integer> The face specified as an face index.
  \param    l <integer-list> The face specified as a list of all the
            coordinate indexes that define it.

  \returns  <coords-3d> The mean coordinate of a polytope face.

  \details

    The face can be identified using either parameter \p i or \p l.
    When using \p l, the parameter \p f is not required.

  \note     Parameter \p f is optional for polygons. When it is not
            given, the listed order of the coordinates \p c establishes
            the polygon path.
*******************************************************************************/
function polytope_face_mean
(
  c,
  f,
  i,
  l
) = let
    (
      ci = is_defined(l) ? l : defined_or(f, [consts(len(c))])[i],
      pc = [for (i = ci) c[i]]
    )
    mean(pc);

//! Get the mean coordinate and normal vector of a polytope face.
/***************************************************************************//**
  \param    c <coords-3d|coords-2d> A list of 3d or 2d coordinate points.
  \param    f <integer-list-list> A list of faces (or paths) that enclose
            the shape where each face is a list of coordinate indexes.

  \param    i <integer> The face specified as an face index.
  \param    l <integer-list> The face specified as a list of all the
            coordinate indexes that define it.

  \param    cw <boolean> Face vertex ordering.

  \returns  <plane> <tt>[mp, nv]</tt>, where \c mp is \c coords-3d, the
            mean coordinate, and \c nv is \c vector-3d, the normal
            vector, of the polytope face-plane.

  \details

    The face can be identified using either parameter \p i or \p l.
    When using \p l, the parameter \p f is not required.

  \note     Parameter \p f is optional for polygons. When it is not
            given, the listed order of the coordinates \p c establishes
            the polygon path.
*******************************************************************************/
function polytope_face_mean_normal
(
  c,
  f,
  i,
  l,
  cw = true
) = [polytope_face_mean(c, f, i, l), polytope_face_normal(c, f, i, l, cw)];

//! Get a plane for a polytope face.
/***************************************************************************//**
  \copydetails polytope_face_mean_normal()
*******************************************************************************/
function polytope_plane
(
  c,
  f,
  i,
  l,
  cw=true
) = polytope_face_mean_normal(c, f, i, l, cw);

//! List the vertex counts for all polytope faces.
/***************************************************************************//**
  \param    f <integer-list-list> A list of faces (or paths) that enclose
            the shape where each face is a list of coordinate indexes.

  \returns  <integer-list> A list with a vertex count of every face.
*******************************************************************************/
function polytope_face_vertex_counts
(
  f
) = [for (fi=f) len(fi)];

//! List the angles between all adjacent faces of a polyhedron.
/***************************************************************************//**
  \param    c <coords-3d> A list of 3d cartesian coordinates
            [[x, y, z], ...].
  \param    f <integer-list-list> A list of faces that enclose
            the shape where each face is a list of coordinate indexes.

  \returns  <decimal-list> A list of the polyhedron adjacent face angles.

  \details

    See [Wikipedia] for more information on dihedral angles.

    [Wikipedia]: https://en.wikipedia.org/wiki/Dihedral_angle
*******************************************************************************/
function polytope_face_angles
(
  c,
  f
) =
  [
    for (i=[0 : len(f)-1])
    let
    (
      n1 = cross_ll([c[f[i][0]], c[f[i][1]]], [c[f[i][0]], c[f[i][2]]]),
      af = [for (v=f[i]) for (j=[0 : len(f)-1]) if (j != i && exists(v, f[j])) j]
    )
      for (u=unique(af))
      let
      (
        n2 = cross_ll([c[f[u][0]], c[f[u][1]]], [c[f[u][0]], c[f[u][2]]])
      )
        angle_ll(n1, n2)
  ];

//! List the edge lengths of a polytope.
/***************************************************************************//**
  \param    c <coords-3d|coords-2d> A list of 3d or 2d cartesian
            coordinates [[x, y (, z)], ...].
  \param    e <integer-list-2-list> A list of edges where each edge is
            a list of two coordinate indexes.

  \returns  <decimal-list> A list of the polytope edge lengths.
*******************************************************************************/
function polytope_edge_lengths
(
  c,
  e
) = [for (ei=e) distance_pp(c[ei[0]], c[ei[1]])];

//! List the adjacent edge angles for each polytope vertex.
/***************************************************************************//**
  \param    c <coords-3d|coords-2d> A list of 3d or 2d cartesian
            coordinates [[x, y (, z)], ...].
  \param    f <integer-list-list> A list of faces (or paths) that enclose
            the shape where each face is a list of coordinate indexes.

  \returns  <decimal-list> A list of the polytope adjacent edge angles.
*******************************************************************************/
function polytope_edge_angles
(
  c,
  f
) =
  [
    for (k=[for (j=f) for (i=sequence_ns(j, n=3, s=1, w=true)) i])
      angle_ll([c[k[0]], c[k[1]]], [c[k[1]], c[k[2]]])
  ];

//! Test if the faces of a polytope are all regular.
/***************************************************************************//**
  \param    c <coords-3d|coords-2d> A list of 3d or 2d cartesian
            coordinates [[x, y (, z)], ...].
  \param    f <integer-list-list> A list of faces (or paths) that enclose
            the shape where each face is a list of coordinate indexes.
  \param    e <integer-list-2-list> A list of edges where each edge is
            a list of two coordinate indexes.
  \param    d <integer> The number of significant figures used when
            comparing lengths and angles.

  \returns  <boolean> \b true when there is both a single edge length
            and a single edge angle and \b false otherwise.

  \details

  \note     When \p e is not specified, it is computed from \p f using
            polytope_faces2edges().
*******************************************************************************/
function polytope_faces_are_regular
(
  c,
  f,
  e,
  d = 6
) =
  let
  (
    ce = is_defined(e) ? e : polytope_faces2edges(f),

    ul = unique(round_s(polytope_edge_lengths(c, ce), d)),
    ua = unique(round_s(polytope_edge_angles(c, f), d))
  )
  ((len(ul) == 1) && (len(ua) == 1));

//! Triangulate the faces of a convex polytope using fan triangulation.
/***************************************************************************//**
  \param    f <integer-list-list> A list of faces (or paths) that enclose
            the shape where each face is a list of coordinate indexes.

  \returns  <integer-list-3-list> A list of triangular faces that enclose
            the polytope where each face is a list of three coordinate
            indexes with vertex ordering is maintained.

  \details

    See [Wikipedia] for more information on [fan triangulation].

    [Wikipedia]: https://en.wikipedia.org/wiki/Polygon_triangulation
    [fan triangulation]: https://en.wikipedia.org/wiki/Fan_triangulation

  \warning  This method does not support concave polytopes.
*******************************************************************************/
function polytope_ft_triangulate
(
  f
) =
  [
    for (fi = f)
      for (ci = [1 : len(fi)-2]) [fi[0], fi[ci], fi[ci+1]]
  ];

//----------------------------------------------------------------------------//
// shape generation and transformation
//----------------------------------------------------------------------------//

//! Generate a bounding box polytope for another polytope in 3d or 2d.
/***************************************************************************//**
  \param    c <coords-3d|coords-2d> A list of 3d or 2d cartesian
            coordinates [[x, y (, z)], ...].
  \param    f <integer-list-list> A list of faces (or paths) that enclose
            the shape where each face is a list of coordinate indexes.
  \param    a <decimal-list-1:3|decimal> The box padding.
            A list of lengths to equally pad the box dimensions.

  \returns  <datastruct> A structure: (1) <tt>[points, faces]</tt>,
            where \c points are <coords-3d> and \c faces are a
            <integer-list-list>, that define the bounding box of the
            given polyhedron. Or: (2) <tt>[points, path]</tt>, where
            \c points are <coords-2d> and \c path is a
            <integer-list-list>, that define the bounding box of the
            given polygon.

  \details

    Polyhedron faces will be ordered \em clockwise when looking from
    outside the shape inwards. Polygon path will be ordered clockwise
    when looking from the top (positive z) downwards.

  \note     When \p f is not specified, all coordinates are used to
            determine the geometric limits, which, simplifies the
            calculation. Parameter \p f is needed when a subset of the
            coordinates should be considered.

    \sa polytope_limits for warning about secondary shapes.
*******************************************************************************/
function polytope_bounding_box_pf
(
  c,
  f,
  a
) = let
    (
      b = polytope_limits(c=c, f=f, a=a, s=false),
      d  = len([for (i=b) if (i != [undef, undef]) i])
    )
    (d == 3) ?
      [ [for (x=b[0], y=b[1], z=b[2]) [x, y, z]],
        [[0,2,3,1], [4,0,1,5], [6,4,5,7], [2,6,7,3], [0,4,6,2], [3,7,5,1]] ]
    : [ [for (x=b[0], y=b[1]) [x, y]],
        [[0,1,3,2]] ];

//! @}
//! @}

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
