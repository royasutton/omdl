//! Polytope shapes, conversions, properties, and tests functions.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2017-2024,2026

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

    \amu_define group_name  (Polytopes)
    \amu_define group_brief (Polytope mathematical functions.)

  \amu_include (include/amu/doxyg_init_pd_gds_ipg.amu)
*******************************************************************************/

// auto-tests (add to test results page)
/***************************************************************************//**
  \amu_include (include/amu/validate_log.amu)
  \amu_include (include/amu/validate_results.amu)
*******************************************************************************/

// group(s) begin (test summary and includes-required)
/***************************************************************************//**
  \amu_include (include/amu/doxyg_define_in_parent_open.amu)
  \amu_include (include/amu/validate_summary.amu)
  \amu_include (include/amu/includes_required.amu)
*******************************************************************************/

// member-wide reference definitions
/***************************************************************************//**
  \amu_define group_references
  (
  )
*******************************************************************************/

// member-wide documentation and conventions
/***************************************************************************//**
  \addtogroup \amu_eval(${group})
  \details
  \anchor \amu_eval(${group})_conventions
  \par Conventions

    - Coordinates are given as \c [[x, y, z], ...] in 3d or \c [[x, y], ...]
      in 2d. Each face in \p f is an ordered list of coordinate indexes
      into \p c.
    - For polygons \p f is optional; when omitted the listed order of \p c
      forms the single implicit path.
    - Face vertex indexes are ordered \b clockwise when viewed from
      \b outside the solid (right-hand rule outward normal). The \p cw
      parameter defaults to \b true (clockwise); set it to \b false to
      negate the returned normal for counter-clockwise faces.
    - Normals are derived from the \b first three vertices of a face only.
      A collinear first triple produces a zero normal vector silently.
      Normal vectors are \b not normalised to unit length unless stated.
    - To identify a face, \p l (explicit index list) takes precedence over
      \p i (index into \p f). Passing both is permitted; \p l wins silently.
      Returns \b undef when a required identification is absent.
    - Edges are represented as \c [[i0, i1], ...] sorted smallest-index-first.
      The optional \p e parameter is computed on-demand when omitted; callers
      iterating over edges \b must pre-compute and pass \p e explicitly.
    - Functions whose names include the \c _ft_ infix use \b fan triangulation,
      which is correct for \b convex faces only. Fan triangulation preserves
      vertex winding; use an ear-clipping triangulator for concave faces.
    - Lengths and bounding-box values are in the units of \p c. Angles are
      in degrees.
*******************************************************************************/

//----------------------------------------------------------------------------//
// members
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
// General
//----------------------------------------------------------------------------//

//! \name General
//! @{

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

//! Get a line from an edge or any two vetices of a polytope.
/***************************************************************************//**
  \param    c <points-3d | points-2d> A list of 3d or 2d coordinate points.

  \param    f <integer-list-list> A list of faces (or paths) that enclose
            the shape where each face is a list of coordinate indexes.
  \param    e <integer-list-2-list> A list of edges where each edge is
            a list of two coordinate indexes.

  \param    i <integer> A line specified as an edge index.
  \param    l <integer-list-2> A line specified as a list of coordinate
            index pairs.

  \param    r <boolean> Reverse the start and end points of the line
            specified as an edge index \p i.

  \returns  <line-3d | line-2d> The line as a pair of coordinates.

  \details

    Two mutually exclusive methods identify the line:
    - When \p l is defined it takes precedence over \p i. The line is
      constructed directly from the two coordinate indexes in \p l and
      neither \p f nor \p e is consulted. \p r has no effect in this path.
    - When only \p i is given the edge list is used to look up the two
      endpoint indexes. \p r reverses the returned point order: when
      \b false (default) the line runs from \c el[i][0] to \c el[i][1];
      when \b true it runs from \c el[i][1] to \c el[i][0].

    Returns \b undef when neither \p l nor \p i is provided.

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
  ? [c[first(sl)], c[second(sl)]]
  : [c[second(sl)], c[first(sl)]];

//! Determine the bounding limits of a polytope.
/***************************************************************************//**
  \param    c <points-3d | points-2d> A list of 3d or 2d cartesian
            coordinates [[x, y (, z)], ...].
  \param    f <integer-list-list> A list of faces (or paths) that enclose
            the shape where each face is a list of coordinate indexes.
  \param    a <decimal-list-1:3 | decimal> The box padding.
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

//! Generate a bounding box polytope for another polytope in 3d or 2d.
/***************************************************************************//**
  \param    c <points-3d | points-2d> A list of 3d or 2d cartesian
            coordinates [[x, y (, z)], ...].
  \param    f <integer-list-list> A list of faces (or paths) that enclose
            the shape where each face is a list of coordinate indexes.
  \param    a <decimal-list-1:3 | decimal> The box padding.
            A list of lengths to equally pad the box dimensions.

  \returns  <datastruct> A structure: (1) <tt>[points, faces]</tt>,
            where \c points are <points-3d> and \c faces are a
            <integer-list-list>, that define the bounding box of the
            given polyhedron. Or: (2) <tt>[points, path]</tt>, where
            \c points are <points-2d> and \c path is a
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
      d  = len(b)
    )
    (d == 3) ?
      [ [for (x=b[0], y=b[1], z=b[2]) [x, y, z]],
        [[0,2,3,1], [4,0,1,5], [6,4,5,7], [2,6,7,3], [0,4,6,2], [3,7,5,1]] ]
    : [ [for (x=b[0], y=b[1]) [x, y]],
        [[0,1,3,2]] ];

//! Triangulate the faces of a convex polytope using fan triangulation.
/***************************************************************************//**
  \param    f <integer-list-list> A list of faces (or paths) that enclose
            the shape where each face is a list of coordinate indexes.

  \returns  <integer-list-3-list> A list of triangular faces that enclose
            the polytope, where each face is a list of exactly three
            coordinate indexes.

  \details

    Each n-vertex face produces n-2 triangles by fanning from its first
    vertex: triangle k is \c [fi[0], fi[k], fi[k+1]] for k in [1, n-2].
    Vertex winding is preserved: all output triangles inherit the winding
    direction of their source face, so outward normals remain consistent
    with the input. The total number of output triangles equals the sum
    of (vertex_count - 2) over all input faces.

    See [Wikipedia] for more information on [fan triangulation].

    [Wikipedia]: https://en.wikipedia.org/wiki/Polygon_triangulation
    [fan triangulation]: https://en.wikipedia.org/wiki/Fan_triangulation

  \warning  Fan triangulation is only correct for convex faces. Concave
            faces will produce overlapping or inverted triangles. For
            concave polytopes use an ear-clipping triangulator instead.
*******************************************************************************/
function polytope_ft_triangulate
(
  f
) =
  [
    for (fi = f)
      for (ci = [1 : len(fi)-2]) [fi[0], fi[ci], fi[ci+1]]
  ];

//! @}

//----------------------------------------------------------------------------//
// Adjacents
//----------------------------------------------------------------------------//

//! \name Adjacents
//! @{

//! List the adjacent vertices for a given polytope vertex.
/***************************************************************************//**
  \param    f <integer-list-list> A list of faces (or paths) that enclose
            the shape where each face is a list of coordinate indexes.

  \param    i <integer> A vertex index.

  \returns  <integer-list> The list of adjacent vertex indexes for the
            given vertex index.

  \details

    The adjacent vertices are those neighboring vertices that are
    directly connected to the given vertex by a common edge. The
    returned list contains coordinate indexes, not coordinates; pass
    them into \p c to obtain the actual points. The result is
    deduplicated so each adjacent vertex index appears exactly once,
    even when it is shared by multiple faces.
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

//! @}

//----------------------------------------------------------------------------//
// Normals
//----------------------------------------------------------------------------//

//! \name Normals
//! @{

//! Get a normal vector for a polytope vertex.
/***************************************************************************//**
  \param    c <points-3d | points-2d> A list of 3d or 2d coordinate points.
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
  \param    c <points-3d | points-2d> A list of 3d or 2d coordinate points.
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
  \param    c <points-3d | points-2d> A list of 3d or 2d coordinate points.
  \param    f <integer-list-list> A list of faces (or paths) that enclose
            the shape where each face is a list of coordinate indexes.

  \param    i <integer> The face specified as an face index.
  \param    l <integer-list> The face-plane specified as a list of three
            or more coordinate indexes that are a part of the face.

  \param    cw <boolean> Face vertex ordering. When \b true the face
            vertices are assumed to be wound \b clockwise when viewed
            from outside the solid, and the returned normal points
            outward (away from the interior). When \b false the vertices
            are assumed counter-clockwise and the normal is negated.

  \returns  <vector-3d> The normal vector of a polytope face.

  \details

    The face can be identified using either parameter \p i or \p l.
    When using \p l, the parameter \p f is not required.

    The normal is computed from the first three vertices of the resolved
    face only. For triangulated faces this is exact. For higher-arity
    faces (quads, n-gons) the first three vertices must not be collinear;
    if they are, the returned vector will be a zero vector. Callers
    working with untriangulated meshes should ensure the face is planar
    and that its first three vertices form a non-degenerate triangle.

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
      pc = [for (vi = [0:2]) let (p = c[ci[vi]]) (len(p) == 3) ? p : [p[0], p[1], 0]]
    )
    cross(pc[0]-pc[1], pc[2]-pc[1]) * ((cw == true) ? 1 : -1);

//! @}

//----------------------------------------------------------------------------//
// Faces
//----------------------------------------------------------------------------//

//! \name Faces
//! @{

/***************************************************************************//**
  \par Face Identification Convention
    Several functions in this group accept two mutually exclusive parameters
    for identifying a face:
    - \p i <integer> selects the face by its index into \p f.
    - \p l <integer-list> provides the face directly as an explicit list of
      coordinate indexes (e.g. a single face from \p f, or a custom subset).

    When \p l is defined it takes precedence over \p i and \p f is not
    consulted. When only \p i is given, \p f must be provided (except for
    polygons, where the implicit single-path default applies). Passing both
    \p l and \p i is permitted; \p l wins silently.
*******************************************************************************/

//! Get the mean coordinate of all vertices of a polytope face.
/***************************************************************************//**
  \param    c <points-3d | points-2d> A list of 3d or 2d coordinate points.
  \param    f <integer-list-list> A list of faces (or paths) that enclose
            the shape where each face is a list of coordinate indexes.

  \param    i <integer> The face specified as an face index.
  \param    l <integer-list> The face specified as a list of all the
            coordinate indexes that define it.

  \returns  <points-3d> The mean coordinate of a polytope face.

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
      pc = [for (ci_idx = ci) c[ci_idx]]
    )
    mean(pc);

//! Get the mean coordinate and normal vector of a polytope face.
/***************************************************************************//**
  \copydetails polytope_face_plane()

  \note     This function is an alias for polytope_face_plane(). It is
            retained for compatibility with existing call sites. Prefer
            polytope_face_plane() in new code.
*******************************************************************************/
function polytope_face_mean_normal
(
  c,
  f,
  i,
  l,
  cw = true
) = polytope_face_plane(c, f, i, l, cw);

//! Get a plane defined by the mean coordinate and normal vector of a polytope face.
/***************************************************************************//**
  \param    c <points-3d | points-2d> A list of 3d or 2d coordinate points.
  \param    f <integer-list-list> A list of faces (or paths) that enclose
            the shape where each face is a list of coordinate indexes.

  \param    i <integer> The face specified as a face index.
  \param    l <integer-list> The face specified as a list of all the
            coordinate indexes that define it.

  \param    cw <boolean> Face vertex ordering. Passed directly to
            polytope_face_normal(); see that function for the full
            description. Default \b true (clockwise, outward normals).

  \returns  <plane> <tt>[mp, nv]</tt>, where \c mp is a \c point-3d
            giving the mean of all face vertices, and \c nv is a
            \c vector-3d giving the face normal. Together they fully
            define the face-plane and can be passed directly to any
            function that expects a \c plane argument.

  \details

    Combines polytope_face_mean() and polytope_face_normal() into a
    single call. The face can be identified using either \p i or \p l;
    see the \ref Faces "Face Identification Convention" for the
    precedence rule.

  \note     Parameter \p f is optional for polygons. When it is not
            given, the listed order of the coordinates \p c establishes
            the polygon path.
*******************************************************************************/
function polytope_face_plane
(
  c,
  f,
  i,
  l,
  cw = true
) = [polytope_face_mean(c, f, i, l), polytope_face_normal(c, f, i, l, cw)];

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
  \param    c <points-3d> A list of 3d cartesian coordinates
            [[x, y, z], ...].
  \param    f <integer-list-list> A list of faces that enclose
            the shape where each face is a list of coordinate indexes.
  \param    cw <boolean> Face vertex ordering. Passed directly to
            polytope_face_normal(); see that function for the full
            description. Default \b true (clockwise, outward normals).

  \returns  <decimal-list> A list of angles (in degrees) between the
            normal vectors of every pair of adjacent faces. Each entry
            is the angle between the outward normals of two faces that
            share at least one vertex, which equals the supplement of
            the interior dihedral angle (i.e. 180° minus the interior
            dihedral angle for a convex edge).

  \details

    For each face \p i, all faces that share at least one vertex are
    found and the angle between their respective normal vectors is
    computed via angle_ll(). Both normals are obtained by delegating
    to polytope_face_normal() with the same \p cw convention, so the
    result is consistent regardless of mesh winding.

    The normal of each face is derived from its first three vertices
    only; see polytope_face_normal() for the implications of this for
    non-triangulated or degenerate faces.

    See [Wikipedia] for more information on dihedral angles.

    [Wikipedia]: https://en.wikipedia.org/wiki/Dihedral_angle

  \warning  Each adjacent face pair appears twice in the output list
            (once from face i's perspective and once from face u's),
            so the list length equals twice the number of adjacent
            face pairs.
*******************************************************************************/
function polytope_face_angles
(
  c,
  f,
  cw = true
) =
  [
    for (i=[0 : len(f)-1])
    let
    (
      n1 = polytope_face_normal(c, f, i, cw=cw),
      af = [for (v=f[i]) for (j=[0 : len(f)-1]) if (j != i && exists(v, f[j])) j]
    )
      for (u=unique(af))
      let
      (
        n2 = polytope_face_normal(c, f, u, cw=cw)
      )
        angle_ll(n1, n2)
  ];

//! @}

//----------------------------------------------------------------------------//
// Edges
//----------------------------------------------------------------------------//

//! \name Edges
//! @{

//! List the edge lengths of a polytope.
/***************************************************************************//**
  \param    c <points-3d | points-2d> A list of 3d or 2d cartesian
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
  \param    c <points-3d | points-2d> A list of 3d or 2d cartesian
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

//! @}

//----------------------------------------------------------------------------//
// Tests
//----------------------------------------------------------------------------//

//! \name Tests
//! @{

//! Test if the faces of a polytope are all regular.
/***************************************************************************//**
  \param    c <points-3d | points-2d> A list of 3d or 2d cartesian
            coordinates [[x, y (, z)], ...].
  \param    f <integer-list-list> A list of faces (or paths) that enclose
            the shape where each face is a list of coordinate indexes.
  \param    e <integer-list-2-list> A list of edges where each edge is
            a list of two coordinate indexes.
  \param    d <integer> The number of significant figures to retain when
            rounding lengths and angles before comparing them for
            uniqueness. Increase \p d to tighten the comparison tolerance;
            decrease it to allow more floating-point variation. Default 6.

  \returns  <boolean> \b true when all edge lengths are equal and all
            adjacent edge angles are equal (to \p d significant figures),
            \b false otherwise.

  \details

    All edge lengths are collected via polytope_edge_lengths() and all
    adjacent edge angles via polytope_edge_angles(). Each list is rounded
    to \p d significant figures with round_s() and then deduplicated with
    unique(). The polytope is considered regular iff both deduplicated
    lists contain exactly one distinct value.

    Note that this tests geometric regularity of the edges and vertex
    angles, not full face regularity. For a polyhedron with non-planar
    or non-congruent faces, the test may return \b true even though the
    faces are not regular polygons.

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

//! @}

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

    echo( str("openscad version ", version()) );
    for (i=[1:19]) echo( "not tested:" );

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
