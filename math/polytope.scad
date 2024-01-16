//! Polygon and polyhedron mathematical functions.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2017-2023

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
    \amu_define group_brief (Polygon and polyhedron mathematical functions.)

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
// polygon
//----------------------------------------------------------------------------//

//! Compute the perimeter of an n-sided regular polygon in 2D.
/***************************************************************************//**
  \param    n <integer> The number of sides.
  \param    r <decimal> The vertex circumradius of the circumcircle.
  \param    a <decimal> The inradius of the incircle.

  \returns  <decimal> Perimeter length of the n-sided regular polygon.

  \details

    The radius can be specified by either the circumradius \p r or the
    inradius \p a. If both are specified, \p r is used.
*******************************************************************************/
function polygon_regular_perimeter
(
  n,
  r,
  a
) = is_defined(r) ? 2 * n * r * sin(180/n)
  : is_defined(a) ? 2 * n * a * tan(180/n)
  : 0;

//! Compute the area of an n-sided regular polygon in 2D.
/***************************************************************************//**
  \param    n <integer> The number of sides.
  \param    r <decimal> The vertex circumradius of the circumcircle.
  \param    a <decimal> The inradius of the incircle.

  \returns  <decimal> Area of the n-sided regular polygon.

  \details

    The radius can be specified by either the circumradius \p r or the
    inradius \p a. If both are specified, \p r is used.
*******************************************************************************/
function polygon_regular_area
(
  n,
  r,
  a
) = is_defined(r) ? pow(r, 2) * n * sin(360/n) / 2
  : is_defined(a) ? pow(a, 2) * n * tan(180/n)
  : 0;

//! Calculate the perimeter length of a polygon in 2d.
/***************************************************************************//**
  \param    c <coords-2d> A list of 2d cartesian coordinates
            [[x, y], ...].
  \param    p <integer-list-list> An \em optional list of paths that
            define one or more closed shapes where each is a list of
            coordinate indexes.

  \returns  <decimal> The sum of all polygon primary and secondary
            perimeter lengths.

  \details

  \note     When \p p is not given, the listed order of the coordinates
            \p c establishes the path.
*******************************************************************************/
function polygon_perimeter
(
  c,
  p
) =
  let
  (
    pm = defined_or(p, [consts(len(c))]),

    lv =
    [
      for (k = pm) let (n = len(k))
        for (i=[0 : n-1]) let (j = (i == 0) ? n-1 : i-1)
          distance_pp(c[k[j]], c[k[i]])
    ]
  )
  sum(lv);

//! Compute the signed area of a polygon in a Euclidean 2d-space.
/***************************************************************************//**
  \param    c <coords-2d> A list of 2d cartesian coordinates
            [[x, y], ...].
  \param    p <integer-list-list> An \em optional list of paths that
            define one or more closed shapes where each is a list of
            coordinate indexes.
  \param    s <boolean> Return the vertex ordering sign.

  \returns  <decimal> The area of the given polygon.

  \details

    See [Wikipedia] for more information.

  \note     When \p p is not given, the listed order of the coordinates
            \p c establishes the path.
  \warning  This function does not track secondary shapes subtraction as
            implemented by the polygon() function.

    [Wikipedia]: https://en.wikipedia.org/wiki/Shoelace_formula
*******************************************************************************/
function polygon_area
(
  c,
  p,
  s = false
) =
  let
  (
    pm = defined_or(p, [consts(len(c))]),

    av =
    [
      for (k = pm) let (n = len(k))
        for (i=[0 : n-1]) let (j = (i == 0) ? n-1 : i-1)
          (c[k[j]][0] + c[k[i]][0]) * (c[k[i]][1] - c[k[j]][1])
    ],

    sa = sum(av)/2
  )
  (s == false) ? abs(sa) : sa;

//! Compute the area of a polygon in a Euclidean 3d-space.
/***************************************************************************//**
  \param    c <coords-3d> A list of 3d cartesian coordinates
            [[x, y, z], ...].
  \param    p <integer-list-list> An \em optional list of paths that
            define one or more closed shapes where each is a list of
            coordinate indexes.
  \param    n <vector-3d> An \em optional normal vector, [x, y, z],
            to the polygon plane. When not given, a normal vector is
            constructed from the first three points of the primary path.

  \returns  <decimal> The area of the given polygon.

  \details

    Function patterned after [Dan Sunday, 2012].

  \note     When \p p is not given, the listed order of the coordinates
            \p c establishes the path.
  \warning  This function does not track secondary shapes subtraction as
            implemented by the polygon() function.

    [Dan Sunday, 2012]: http://geomalgorithms.com/a01-_area.html
*******************************************************************************/
function polygon3d_area
(
  c,
  p,
  n
) =
  let
  (
    pm = defined_or(p, [consts(len(c))]),
    nv = defined_or(n, cross_ll([c[pm[0][0]], c[pm[0][1]]], [c[pm[0][0]], c[pm[0][2]]])),

    ac = [abs(nv[0]), abs(nv[1]), abs(nv[2])],
    am = max(ac),
    ai = (am == ac[2]) ? 2 : (am == ac[1]) ? 1 : 0,

    pv = [
          for (k = pm) let (m = len(k))
            for (i=[1 : m])
              c[k[i%m]][(ai+1)%3] * (c[k[(i+1)%m]][(ai+2)%3] - c[k[(i-1)%m]][(ai+2)%3])
         ],

    sf = (distance_pp(nv)/(2*nv[ai]))
  )
  (sum(pv) * sf);

//! Compute the center of mass of a polygon in a Euclidean 2d-space.
/***************************************************************************//**
  \param    c <coords-2d> A list of 2d cartesian coordinates
            [[x, y], ...].
  \param    p <integer-list-list> An \em optional list of paths that
            define one or more closed shapes where each is a list of
            coordinate indexes.

  \returns  <point-2d> The center of mass of the given polygon.

  \details

    See [Wikipedia] for more information.

  \note     When \p p is not given, the listed order of the coordinates
            \p c establishes the path.
  \warning  This function does not track secondary shapes subtraction as
            implemented by the polygon() function.

    [Wikipedia]: https://en.wikipedia.org/wiki/Centroid#Centroid_of_polygon
*******************************************************************************/
function polygon_centroid
(
  c,
  p
) =
  let
  (
    pm = defined_or(p, [consts(len(c))]),

    cv =
    [
      for (k = pm) let (n = len(k))
        for (i=[0 : n-1])
        let
        (
          j  = (i == 0) ? n-1 : i-1,

          xc = c[k[j]][0],
          yc = c[k[j]][1],

          xn = c[k[i]][0],
          yn = c[k[i]][1],

          cd = (xc*yn - xn*yc)
        )
          [(xc + xn) * cd, (yc + yn) * cd]
    ],

    sc = sum(cv),
    sa = polygon_area(c, pm, true)
  )
  sc/(6*sa);

//! Test the vertex ordering of a polygon in a Euclidean 2d-space.
/***************************************************************************//**
  \param    c <coords-2d> A list of 2d cartesian coordinates
            [[x, y], ...].
  \param    p <integer-list-list> An \em optional list of paths that
            define one or more closed shapes where each is a list of
            coordinate indexes.

  \returns  <boolean> \b true if the vertex are ordered \em clockwise,
            \b false if the vertex are \em counterclockwise ordered, and
            \b undef if the ordering can not be determined.

  \details

  \note     When \p p is not given, the listed order of the coordinates
            \p c establishes the path.
*******************************************************************************/
function polygon_is_clockwise
(
  c,
  p
) =
  let
  (
    sa = polygon_area(c, p, true)
  )
    (sa < 0) ? true
  : (sa > 0) ? false
  : undef;

//! Test the convexity of a polygon in a Euclidean 2d-space.
/***************************************************************************//**
  \param    c <coords-2d> A list of 2d cartesian coordinates
            [[x, y], ...].
  \param    p <integer-list-list> An \em optional list of paths that
            define one or more closed shapes where each is a list of
            coordinate indexes.

  \returns  <boolean> \b true if the polygon is \em convex, \b false
            otherwise.

  \details

  \note     When \p p is not given, the listed order of the coordinates
            \p c establishes the path.
*******************************************************************************/
function polygon_is_convex
(
  c,
  p
) = is_undef(c) ? undef
  : len(c) < 3 ? undef
  : !all_len(c, 2) ? undef
  : let
    (
      pm = defined_or(p, [consts(len(c))]),

      sv =
      [
        for (k = pm) let (n = len(k))
          for (i=[0 : n-1])
            sign(cross_ll([c[k[i]], c[k[(i+1)%n]]], [c[k[(i+1)%n]], c[k[(i+2)%n]]]))
      ],

      us = unique(sv)
    )
    (len(us) == 1);

//! Compute the winding number of a polygon about a point in a Euclidean 2d-space.
/***************************************************************************//**
  \param    c <coords-2d> A list of 2d cartesian coordinates
            [[x, y], ...].
  \param    p <integer-list-list> An \em optional list of paths that
            define one or more closed shapes where each is a list of
            coordinate indexes.
  \param    t <point-2d> A test point coordinate [x, y].

  \returns  <integer> The winding number.

  \details

    Computes the [winding number], the total number of counterclockwise
    turns that the polygon paths makes around the test point in a
    Euclidean 2d-space. Will be 0 \em iff the point is outside of the
    polygon. Function patterned after [Dan Sunday, 2012].

  \copyright

    Copyright 2000 softSurfer, 2012 Dan Sunday
    This code may be freely used and modified for any purpose
    providing that this copyright notice is included with it.
    iSurfer.org makes no warranty for this code, and cannot be held
    liable for any real or imagined damage resulting from its use.
    Users of this code must verify correctness for their application.

    [Dan Sunday, 2012]: http://geomalgorithms.com/a03-_inclusion.html
    [winding number]: https://en.wikipedia.org/wiki/Winding_number

  \note     When \p p is not given, the listed order of the coordinates
            \p c establishes the path.
  \warning  Where there are secondary paths, the vertex ordering of each
             must be the same as the primary path.
*******************************************************************************/
function polygon_winding
(
  c,
  p,
  t
) =
  let
  (
    pm = defined_or(p, [consts(len(c))]),

    wv =
    [
      for (k = pm) let (n = len(k))
        for (i=[0 : n-1])
        let
        (
          j = (i == 0) ? n-1 : i-1,

          t = (
                (c[k[j]][1] <= t[1]) && (c[k[i]][1] >  t[1])
                && (is_left_ppp(c[k[j]], c[k[i]], t) > 0)
              ) ? +1
            : (
                (c[k[j]][1] >  t[1]) && (c[k[i]][1] <= t[1])
                && (is_left_ppp(c[k[j]], c[k[i]], t) < 0)
              ) ? -1
            : 0
        )
          t
    ]
  )
  sum(wv);

//! Test if a point is inside a polygon in a Euclidean 2d-space using winding number.
/***************************************************************************//**
  \param    c <coords-2d> A list of 2d cartesian coordinates
            [[x, y], ...].
  \param    p <integer-list-list> An \em optional list of paths that
            define one or more closed shapes where each is a list of
            coordinate indexes.
  \param    t <point-2d> A test point coordinate [x, y].

  \returns  <boolean> \b true when the point is \em inside the polygon and
            \b false otherwise.

  \details

  \note     When \p p is not given, the listed order of the coordinates
            \p c establishes the path.

    \sa polygon_winding for warning about secondary shapes.
*******************************************************************************/
function polygon_wn_is_p_inside
(
  c,
  p,
  t
) = (polygon_winding(c=c, p=p, t=t) != 0);

//! Test if a point is inside a polygon in a Euclidean 2d-space using angle summation.
/***************************************************************************//**
  \param    c <coords-2d> A list of 2d cartesian coordinates
            [[x, y], ...].
  \param    p <integer-list-list> An \em optional list of paths that
            define one or more closed shapes where each is a list of
            coordinate indexes.
  \param    t <point-2d> A test point coordinate [x, y].

  \returns  <boolean> \b true when the point is \em inside the polygon and
            \b false otherwise.

  \details

    See [Wikipedia] for more information.

  \note     When \p p is not given, the listed order of the coordinates
            \p c establishes the path.
  \warning  This function does not track secondary shapes subtraction as
            implemented by the polygon() function.

    [Wikipedia]: https://en.wikipedia.org/wiki/Point_in_polygon
*******************************************************************************/
function polygon_as_is_p_inside
(
  c,
  p,
  t
) =
  let
  (
    pm = defined_or(p, [consts(len(c))]),

    av =
    [
      for (k = pm) let (n = len(k))
        for (i=[0 : n-1])
        let
        (
          j = (i == 0) ? n-1 : i-1
        )
          angle_ll([t, c[k[i]]], [t, c[k[j]]])
    ],

    sa = abs(sum(av))
  )
  (sa > 180);

//----------------------------------------------------------------------------//
// polyhedron
//----------------------------------------------------------------------------//

//! Compute the surface area of a polyhedron in a Euclidean 3d-space.
/***************************************************************************//**
  \param    c <coords-3d> A list of 3d cartesian coordinates
            [[x, y, z], ...].
  \param    f <integer-list-list> A list of faces that enclose
            the shape where each face is a list of coordinate indexes.

  \returns  <decimal> The surface area of the given polyhedron.
*******************************************************************************/
function polyhedron_area
(
  c,
  f
) = sum([for (fi = f) polygon3d_area(c, [fi])]);

//! Compute the volume of a triangulated polyhedron in a Euclidean 3d-space.
/***************************************************************************//**
  \param    c <coords-3d> A list of 3d cartesian coordinates
            [[x, y, z], ...].
  \param    f <integer-list-3-list> A list of triangular faces that
            enclose the polyhedron where each face is a list of three
            coordinate indexes.

  \returns  <decimal> The volume of the given polyhedron.

  \details

    See [Wikipedia] for more information on volumes determined using
    the [divergence theorem].

  \note     All faces are assumed to be a union of triangles oriented
            clockwise from the outside inwards.

  [Wikipedia]: https://en.wikipedia.org/wiki/Polyhedron#Volume
  [divergence theorem]: https://en.wikipedia.org/wiki/Divergence_theorem
*******************************************************************************/
function polyhedron_tf_volume
(
  c,
  f
) =
  let
  (
    vv =
    [
      for (fi = f)
      (len(fi) != 3) ? undef
      : let
        (
          a = c[fi[1]],
          b = c[fi[0]],
          c = c[fi[2]]
        )
        a * cross_ll([a, b], [a, c])
    ],

    sv = sum(vv)
  )
  sv/6;

//! Compute the center of mass of a triangulated polyhedron in a Euclidean 3d-space.
/***************************************************************************//**
  \param    c <coords-3d> A list of 3d cartesian coordinates
            [[x, y, z], ...].
  \param    f <integer-list-3-list> A list of triangular faces that
            enclose the polyhedron where each face is a list of three
            coordinate indexes.

  \returns  <point-3d> The center of mass of the given polyhedron.

  \details

    See [Wikipedia] for more information on centroid determined via
    the [divergence theorem] and midpoint quadrature.

  \note     All faces are assumed to be a union of triangles oriented
            clockwise from the outside inwards.

  [Wikipedia]: https://en.wikipedia.org/wiki/Centroid
  [divergence theorem]: https://en.wikipedia.org/wiki/Divergence_theorem
*******************************************************************************/
function polyhedron_tf_centroid
(
  c,
  f
) =
  let
  (
    wv =
    [
      for (fi = f)
      let
      (
        a = c[fi[1]],
        b = c[fi[0]],
        c = c[fi[2]],

        r = a * cross_ll([a, b], [a, c])
      )
        (a+b+c) * r
    ],

    ws = sum(wv),
    tv = polyhedron_tf_volume(c, f)
  )
  ws/(24*tv);

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

//! Convert a polygon in 2D to a polyhedron by adding a height dimension.
/***************************************************************************//**
  \param    c <coords-2d> A list of 2d cartesian coordinates
            [[x, y], ...].
  \param    p <integer-list-list> An \em optional list of paths that
            define one or more closed shapes where each is a list of
            coordinate indexes.
  \param    h <decimal> The polyhedron height.
  \param    centroid <boolean> Center polygon centroid at z-axis.
  \param    center <boolean> Center polyhedron height about xy-plane.

  \returns  <datastruct> A structure <tt>[points, faces]</tt>, where
            \c points are <coords-3d> and \c faces are a
            <integer-list-list>, that define the bounding box of the
            given polyhedron.

  \details

  \note     When \p p is not given, the listed order of the coordinates
            \p c establishes the path.
*******************************************************************************/
function polygon_linear_extrude_pf
(
  c,
  p,
  h = 1,
  centroid = false,
  center = false
) =
  let
  (
    pm = defined_or(p, [consts(len(c))]),
    pn = len([for (pi = pm) for (ci = pi) 1]),

    po = (centroid == true) ? polygon_centroid(c, p) : origin2d,
    zr = (center == true) ? [-h/2, h/2] : [0, h],

    cw = polygon_is_clockwise (c, p),

    pp = [for (zi = zr) for (pi = pm) for (ci = pi) concat(c[ci] - po, zi)],
    pf =
    [
      [for (pi = pm) for (ci = pi) ci],
      [for (pi = pm) for (cn = [len(pi)-1 : -1 : 0]) pi[cn] + pn],
      for (pi = pm) for (ci = pi)
        (cw == true)
        ? [ci, ci+pn, (ci+1)%pn+pn, (ci+1)%pn]
        : [ci, (ci+1)%pn, (ci+1)%pn+pn, ci+pn]
    ]
  )
  [pp, pf];

//! Round the vertices of a polygon in 2d space.
/***************************************************************************//**
  \param    c <coords-2d> A list of \em n 2d cartesian coordinates
            [[x1, y1], [x2, y2], ..., [xn, yn]].
  \param    vr <decimal-list-n|decimal> The vertices rounding radius.
            A list [v1r, v2r, v3r, ... vnr] of \em n decimals or a
            single decimal for (v1r=v2r=v3r= ... =vnr). Unspecified
            vertices are not rounded.
  \param    vrm <integer-list-n|integer> The vertices rounding mode.
            A list [v1rm, v2rm, v3rm, ... vnrm] of \em n integers or a
            single integer for (v1rm=v2rm=v3rm= ... =vnrm). Unspecified
            vertices are not rounded.
  \param    vfn <integer-list-n> The vertices arc fragment number.
            A list [v1fn, v2fn, v3fn, ... vnfn] of \em n integers or a
            single integer for (v1fn=v2fn=v3fn= ... =vnfn).
  \param    w <boolean> Wrap-at-end during 3-point coordinate selection.
  \param    cw <boolean> Polygon vertex ordering.

  \returns  <coords-2d> A new list of coordinates points [[x, y], ...]
            that define the polygon with rounded vertices.

  \details

    Assumes polygon is defined in 2D space on the x-y plane. There
    should be no repeating adjacent vertices along the polygon path
    (ie: no adjacent vertex with identical coordinates). Any vertex
    determined to be collinear with its adjacent previous and next
    vertex is returned unmodified.

    Each vertex may be individually rounded using one of the following
    modes:

     mode | name                |        description
     :---:|:-------------------:|:--------------------------------------
       0  | none                | return vertex unchanged
       1  | round               | previous to next edge round
       2  | e-hollow / i-circle | previous to next edge inverse round
       3  | n-fillet            | next edge pass return fillet
       4  | p-fillet            | previous edge pass return fillet
       5  | chamfer             | previous to next edge bevel
       6  | e-circle / i-hollow | previous to next edge inverse round
       7  | n-round             | next edge pass return round
       8  | p-round             | previous edge pass return round
       9  | n-chamfer           | next edge pass return bevel
      10  | p-chamfer           | previous edge pass return bevel

    Vertex arc fragments can be specified using \p vfn. When any \p
    vnfn is \b undef, the special variables \p $fa, \p $fs, and \p $fn
    control facet generation. Each vertex is processed using 3-point
    (the previous and following vertex). The resulting triangle \ref
    triangle2d_incenter "incircles" and \ref triangle2d_excenter
    "excircles" are used to create the round and fillet \ref
    polygon_arc_p "arc" segments. All arcs and chamfers use constant
    radius.

    \b Example:
    \code{.C}
    c = [[1,1], [1,10], [10,12], [18,2]];
    r = [1,1,5,8];
    m = [2,3,4,3];
    n = [3, 8, undef, undef];

    p = polygon_vertices_round3_p(c=c, vr=r, vrm=m, vfn=n);

    polygon( p );
    \endcode
*******************************************************************************/
function polygon_vertices_round3_p
(
  c,
  vr = 0,
  vrm = 1,
  vfn,
  w = true,
  cw = true
) =
  let
  (
    // constant vertex rounding radius, mode, and facets
    crr = is_scalar(vr) ? vr : 0,
    crm = is_scalar(vrm) ? vrm : 0,
    cfn = is_scalar(vfn) ? vfn : undef,

    // function assumes cw order, reverse if required
    cp  = (cw == true) ? c : reverse(c),

    // adjacent vertices sequence [ [v[n-1], v[n], v[n+1]] ... ]
    avl = sequence_ns(cp, 3, w=w),

    // polygon coordinate point list
    ppl =
    [
      for ( i = [0 : len(avl)-1] )
      let
      (
        av  = avl[i],                     // vertices [vp, vc, vn]

        vp  = first(av),                  // vertex coordinate v[n-1]
        vc  = second(av),                 // vertex coordinate v[n]
        vn  = third(av),                  // vertex coordinate v[n+1]

        il  = is_left_ppp(vp, vn, vc),    // identify position of vc

        rr  = defined_e_or(vr, i, crr),   // vertex rounding radius
        rm  = (rr == 0) ? 0               // vertex rounding mode
            : (il == 0) ? 0               // vp,vc,vn collinear, set rm=0
            : defined_e_or(vrm, i, crm),
        fn  = defined_e_or(vfn, i, cfn),  // vertex rounding arc fragments

        // reverse arc sweep on interior corners
        // not relevant for rm={0|5|9|10}
        ras = (il < 0),

        // tangent circle radius
        tcr = (rm == 0) ? 0
            : (rm == 1 || rm == 2) ?
              triangle2d_inradius(av)
            : (rm == 3) ?
              triangle2d_exradius(av, 1)
            : (rm == 4) ?
              triangle2d_exradius(av, 3)
            : 0,

        // tangent circle center coordinate
        tcc = (rm == 0) ? origin2d
            : (rm == 1 || rm == 2) ?
              (vc-rr/(rr-tcr) * triangle2d_incenter(av)) * (tcr-rr)/tcr
            : (rm == 3) ?
              (vc-rr/(rr-tcr) * triangle2d_excenter(av, 1)) * (tcr-rr)/tcr
            : (rm == 4) ?
              (vc-rr/(rr-tcr) * triangle2d_excenter(av, 3)) * (tcr-rr)/tcr
            : origin2d,

        // distance from vertex to inflection points
        vim = (rm == 0) ? 0
            : (rm <= 4) ?
              sqrt( pow(distance_pp(vc, tcc),2) - pow(rr,2) )
            : rr,

        // inflection coordinates
        tc1 = (rm == 0 || rm > 10) ? origin2d
            : (rm == 3 || rm == 7 || rm == 9) ?
              vc + vim * unit_l([vp, vc])
            : vc + vim * unit_l([vc, vp]),

        tc2 = (rm == 0 || rm > 10) ? origin2d
            : (rm == 4 || rm == 8 || rm == 10) ?
              vc + vim * unit_l([vn, vc])
            : vc + vim * unit_l([vc, vn]),

        // vertex rounding coordinate point list
        vpl = (rm == 0 || rm > 10) ? [vc]
            : (rm == 1) ?
              polygon_arc_p(r=rr, c=tcc, v1=[tcc, tc1], v2=[tcc, tc2], fn=fn, cw=!ras)
            : (rm == 2 || rm == 3 || rm == 4) ?
              polygon_arc_p(r=rr, c=tcc, v1=[tcc, tc1], v2=[tcc, tc2], fn=fn, cw=ras)
            : (rm == 6 || rm == 7 || rm == 8) ?
              polygon_arc_p(r=rr, c=vc, v1=[vc, tc1], v2=[vc, tc2], fn=fn, cw=!ras)
            : [tc1, tc2]
      )
      vpl
    ],

    // polygon points
    pp = merge_s( ppl )
  )
  (cw == true) ? pp : reverse(pp);

//! @}
//! @}

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
