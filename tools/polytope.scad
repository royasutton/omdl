//! Polygon and polyhedron tools.
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

    \amu_define group_name  (Polytope)
    \amu_define group_brief (Polygon and polyhedron tools.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_define includes_required_add
  (
    tools/align.scad
  )
  \amu_include (include/amu/includes_required.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//! Label the vertices, paths, and edges of a polytope.
/***************************************************************************//**
  \param    c <coords-3d | coords-2d> A list of 3d or 2d coordinate points.
  \param    f <<integer-list>-list> A list of faces (or paths) that enclose
            the shape where each face is a list of coordinate indexes.
  \param    e <<integer-list-2>-list> A list of edges where each edge is
            a list of two coordinate indexes.

  \param    vi <index> Vertex index. An index sequence [specification].
  \param    fi <index> Face index. An index sequence [specification].
  \param    ei <index> Edge index. An index sequence [specification].

  \param    sp <boolean> Show polyhedron shape.

  \param    ts <decimal> The text size override.
  \param    th <decimal> The text extrusion height override.

  \param    to <vector-3d | vector-2d> The text offset override.
  \param    tr <decimal-list-1:3 | decimal> The text rotation (in degrees).

  \details

    Label the vertices, paths, and edges of a polytope. Parameter \p f
    is optional for polygons. When it is not given, the listed order of
    the coordinates \p c establishes the polygon path. When \p e is not
    specified, it is computed from \p f using polytope_faces2edges().

    \amu_define scope_id      (example_number)
    \amu_define title         (Numbering example)
    \amu_define image_views   (top front diag)
    \amu_define image_size    (sxga)

    \amu_include (include/amu/scope_diagrams_3d.amu)

  [specification]: \ref dt_index
*******************************************************************************/
module polytope_number
(
  c,
  f,
  e,
  vi = true,
  fi = true,
  ei = true,
  sp = false,
  ts,
  th,
  to,
  tr = 0
)
{
  fm = defined_or(f, [consts(len(c))]);
  el = is_defined(e) ? e : polytope_faces2edges(fm);

  bb = polytope_limits(c=c, f=fm, s=true);
  pd = len(bb);

  fs = defined_or(ts, ceil(max(bb)/50));
  fh = defined_or(th, ceil(min(bb)/100));
  fo = defined_or(to, [0, 0, fs/2]);

  // vertex
  color("green")
  for (i = index_gen(c, vi))
  {
    p = c[i];
    n = polytope_vertex_normal(c, fm, i);

    translate(p)
    orient_ll(r=is_nan(n) ? z_axis3d_uv : n)
    translate(fo) rotate(tr)
    if (pd == 3)
      linear_extrude(fh, center=true)
      text(str(i), size=fs, halign="center", valign="center");
    else
      text(str(i), size=fs, halign="center", valign="center");
  }

  // face
  color("red")
  for (i = index_gen(fm, fi))
  {
    p = polytope_face_mean(c, l=fm[i]);
    n = polytope_face_normal(c, l=fm[i]);

    translate(p)
    orient_ll(r=is_nan(n) ? z_axis3d_uv : n)
    translate(fo) rotate(tr)
    if (pd == 3)
      linear_extrude(fh, center=true)
      text(str(i), size=fs, halign="center", valign="center");
    else
      text(str(i), size=fs, halign="center", valign="center");
  }

  // edge
  color("blue")
  for (i = index_gen(el, ei))
  {
    p = mean([c[first(el[i])], c[second(el[i])]]);
    n = polytope_edge_normal(c, fm, el, i);

    translate(p)
    orient_ll(r=is_nan(n) ? z_axis3d_uv : n)
    translate(fo) rotate(tr)
    if (pd == 3)
      linear_extrude(fh, center=true)
      text(str(i), size=fs, halign="center", valign="center");
    else
      text(str(i), size=fs, halign="center", valign="center");
  }

  // shape
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
  \param    c <coords-3d | coords-2d> A list of 3d or 2d coordinate points.
  \param    f <<integer-list>-list> A list of faces (or paths) that enclose
            the shape where each face is a list of coordinate indexes.
  \param    e <<integer-list-2>-list> A list of edges where each edge is
            a list of two coordinate indexes.

  \param    vi <index> Vertex index. An index sequence [specification].
  \param    fi <index> Face index. An index sequence [specification].
  \param    ei <index> Edge index. An index sequence [specification].

  \param    vc <integer> Vertex child object index.
  \param    fc <integer> Face child object index.
  \param    ec <integer> Edge child object index.

  \details

    Construct a skeletal frame for a given polytope. A 2d child object
    is linearly extruded along specified edges of the polytope to form
    the frame. Additional 3d child objects can be centered on specified
    vertices and/or the mean coordinates of specified faces.

    To disable a child assignment to the vertices, faces, or edges, use
    an index that is less than zero or greater than the number of
    children. Parameter \p f is optional for polygons. When it is not
    given, the listed order of the coordinates \p c establishes the
    polygon path. When \p e is not specified, it is computed from \p f
    using polytope_faces2edges().

    \amu_define scope_id      (example_frame_a)
    \amu_define title         (A. Framing example)
    \amu_define image_views   (top right diag)
    \amu_define image_size    (sxga)

    \amu_include (include/amu/scope_diagrams_3d.amu)

    \amu_define scope_id      (example_frame_b)
    \amu_define title         (B. Framing example)
    \amu_define image_views   (diag)
    \amu_define image_size    (sxga)

    \amu_include (include/amu/scope_diagrams_3d.amu)

  [specification]: \ref dt_index
*******************************************************************************/
module polytope_frame
(
  c,
  f,
  e,
  vi = true,
  fi = true,
  ei = true,
  vc = 1,
  fc = 2,
  ec = 0
)
{
  fm = defined_or(f, [consts(len(c))]);
  el = is_defined(e) ? e : polytope_faces2edges(fm);

  // vertex
  if (is_between(vc, 0, $children-1) && ($children > 0))
  {
    for (i = index_gen(c, vi))
    {
      p = c[i];
      n = polytope_vertex_normal(c, fm, i);

      translate(p)
      orient_ll(r=is_nan(n) ? z_axis3d_uv : n)
      children(vc);
    }
  }

  // face
  if (is_between(fc, 0, $children-1) && ($children > 0))
  {
    for (i = index_gen(fm, fi))
    {
      p = polytope_face_mean(c, l=fm[i]);
      n = polytope_face_normal(c, l=fm[i]);

      translate(p)
      orient_ll(r=is_nan(n) ? z_axis3d_uv : n)
      children(fc);
    }
  }

  // edge
  if (is_between(ec, 0, $children-1) && ($children > 0))
  {
    for (i = index_gen(el, ei))
    {
      p1 = point_to_3d(c[first(el[i])]);        // 3d points required for
      p2 = point_to_3d(c[second(el[i])]);       // polygons.

      translate((p1+p2)/2)
      orient_ll(r=[p1, p2])
      linear_extrude(distance_pp(p1, p2), center=true)
      children(ec);
    }
  }
}

//! The 3d or 2d bounding box shape for a polytope.
/***************************************************************************//**
  \param    c <coords-3d | coords-2d> A list of 3d or 2d coordinate points.
  \param    f <<integer-list>-list> A list of faces (or paths) that enclose
            the shape where each face is a list of coordinate indexes.
  \param    a <decimal-list-1:3 | decimal> The box padding. A list of
            lengths to equally pad the box dimensions.

  \details

    Generates: (1) the 3d box shape that completely encloses the
    defined 3d polyhedron with the box sides oriented parallel to the
    coordinate axes. Or: (2) the 2d box shape that exactly encloses the
    defined 2d polygon with the box sides oriented parallel to the
    coordinate axes. When \p f is not given, the listed order of the
    coordinates \p c establishes the path.

    \amu_define scope_id      (example_bbox)
    \amu_define title         (Bounding box example)
    \amu_define image_views   (top front diag)
    \amu_define image_size    (sxga)

    \amu_include (include/amu/scope_diagrams_3d.amu)

    \sa polytope_limits for warning about secondary shapes.
*******************************************************************************/
module polytope_bounding_box
(
  c,
  f,
  a
)
{
  b = polytope_limits(c=c, f=f, a=a, s=false);
  d = len(b);

  if (d == 3)
    translate([b[0][0], b[1][0], b[2][0]])
    cube([b[0][1]-b[0][0], b[1][1]-b[1][0], b[2][1]-b[2][0]]);
  else
    translate([b[0][0], b[1][0]])
    square([b[0][1]-b[0][0], b[1][1]-b[1][0]]);
}

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE example_number;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <tools/align.scad>;
    include <units/coordinate.scad>;
    include <database/geometry/polyhedra/johnson.scad>;
    include <tools/polytope.scad>;

    tc = dtc_polyhedra_johnson;
    tr = dtr_polyhedra_johnson;
    id = "metagyrate_diminished_rhombicosidodecahedron";

    c = table_get_value(tr, tc, id, "c");
    f = table_get_value(tr, tc, id, "f");
    v = coordinate_scale3d_csc(c, 100);

    polytope_number(v, f, sp=true, $fn = 36);

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "top front diag";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;

BEGIN_SCOPE example_frame_a;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <tools/align.scad>;
    include <units/coordinate.scad>;
    include <database/geometry/polyhedra/cupolas.scad>;
    include <tools/polytope.scad>;

    tc = dtc_polyhedra_cupolas;
    tr = dtr_polyhedra_cupolas;
    id = "pentagonal_cupola";

    c = table_get_value(tr, tc, id, "c");
    f = table_get_value(tr, tc, id, "f");

    v1 = coordinate_scale3d_csc(c, 100);
    v2 = coordinate_scale3d_csc(c, 100, true);

    repeat_grid(2, 225, center=true, $fn=36)
    {
      polytope_frame(v1, f) {circle(r=4); color("grey") sphere(r=6);}
      polytope_frame(v2, f) {circle(r=4); color("grey") sphere(r=6);}
    }

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "top right diag";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;

BEGIN_SCOPE example_frame_b;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <tools/align.scad>;
    include <units/coordinate.scad>;
    include <database/geometry/polyhedra/archimedean.scad>;
    include <tools/polytope.scad>;

    tc = dtc_polyhedra_archimedean;
    tr = dtr_polyhedra_archimedean;
    id = "truncated_cuboctahedron";

    c = table_get_value(tr, tc, id, "c");
    f = table_get_value(tr, tc, id, "f");
    v = coordinate_scale3d_csc(c, 100);

    polytope_frame(v, f, fi="even", $fn = 36)
    {
      circle(r=2);
      color("grey") sphere(r=4);
      color("red") star3d(20);
    }

    polytope_frame(v, f, fi="odd", fc=0, vc=-1, ec=-1)
    color("blue") star3d(20);

    %polyhedron(v, f);

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "diag";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;

BEGIN_SCOPE example_bbox;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <database/geometry/polyhedra/archimedean.scad>;
    include <tools/polytope.scad>;

    tc = dtc_polyhedra_archimedean;
    tr = dtr_polyhedra_archimedean;
    id = "truncated_cuboctahedron";

    c = table_get_value(tr, tc, id, "c");
    f = table_get_value(tr, tc, id, "f");

    polyhedron(c, f);
    %polytope_bounding_box(c,f );

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "top front diag";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;

*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
