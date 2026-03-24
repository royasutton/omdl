//! Polyhedron shapes, conversions, properties, and tests functions.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2015-2024,2026

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

    \amu_define group_name  (Polyhedrons)
    \amu_define group_brief (Polyhedron mathematical functions; 3-polytope.)

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

    All functions in this group operate on polyhedra defined by a list
    of 3d cartesian coordinates \p c and a list of faces \p f,
    following OpenSCAD's native \c polyhedron() convention:

    - Coordinates are given as \c [[x,y,z], ...].
    - Face vertex indices are ordered \b counter-clockwise when viewed
      from \b outside the solid (right-hand rule outward normal).
    - Functions whose names include the \c _tf_ infix require that all
      faces be \b triangulated (exactly 3 vertex indices per face).
      Non-triangulated meshes must be tessellated before being passed
      to these functions. Passing a face with fewer or more than 3
      indices to a \c _tf_ function produces \c undef in the
      corresponding term and will silently corrupt the result.
*******************************************************************************/

//----------------------------------------------------------------------------//
// members
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
// shape properties
//----------------------------------------------------------------------------//

//! \name Properties
//! @{

//! Compute the surface area of a polyhedron in a Euclidean 3d-space.
/***************************************************************************//**
  \param    c <points-3d> A list of 3d cartesian coordinates
              [[x, y, z], ...].

  \param    f <integer-list-list> A list of faces that enclose the
              polyhedron, where each face is a list of coordinate
              indexes. Faces may be polygons with any number of
              vertices >= 3 and need not be triangulated.

  \returns  <decimal> The total surface area of the polyhedron in square
            units of the coordinate space.

  \details

    The surface area is computed by summing the area of each face
    polygon via \c polygon3d_area(). Faces are not required to be
    triangular, but each face is assumed to be planar.

    \b Example — unit cube (expected area = 6.0):

    \code{.scad}
    c = [[0,0,0],[1,0,0],[1,1,0],[0,1,0],
         [0,0,1],[1,0,1],[1,1,1],[0,1,1]];

    f = [[0,3,2,1],[4,5,6,7],
         [0,1,5,4],[1,2,6,5],[2,3,7,6],[3,0,4,7]];

    echo(polyhedron_area(c, f));  // ECHO: 6
    \endcode
*******************************************************************************/
function polyhedron_area
(
  c,
  f
) = sum([for (fi = f) polygon3d_area(c, [fi])]);

//! Compute the signed volume of a triangulated polyhedron in a Euclidean 3d-space.
/***************************************************************************//**
  \param    c <points-3d> A list of 3d cartesian coordinates
              [[x, y, z], ...].

  \param    f <integer-list-3-list> A list of triangular faces that
              enclose the polyhedron, where each face is a list of
              exactly three coordinate indexes. Non-triangular faces
              must be tessellated before calling this function; any
              face with a vertex count other than 3 is skipped
              (contributing 0 to the sum) and a warning is implicitly
              indicated by an \c undef guard — see note below.

  \returns  <decimal> The volume of the given polyhedron in cubic units
            of the coordinate space. The sign of the result is positive
            when face normals point outward (counter-clockwise winding
            per OpenSCAD convention) and negative otherwise.

  \details

    Volume is computed using the [divergence theorem] applied to a
    signed tetrahedral decomposition. For each triangular face with
    vertices \f$ \mathbf{p}_0, \mathbf{p}_1, \mathbf{p}_2 \f$, the
    signed tetrahedral volume relative to the origin is:

    \f[
      V_i = \frac{1}{6}\, \mathbf{p}_0 \cdot (\mathbf{p}_1 \times \mathbf{p}_2)
    \f]

    The total volume is the sum over all faces:

    \f[
      V = \sum_i V_i
    \f]

    This formula is exact for any closed, consistently wound
    triangulated mesh regardless of whether the mesh encloses the
    origin.

    See [Wikipedia: Polyhedron – Volume][Wikipedia] for background.

  \note   All faces must be triangles (exactly 3 vertex indices) wound
          counter-clockwise when viewed from outside (OpenSCAD's native
          \c polyhedron() convention). Faces that do not satisfy
          \c len(fi)==3 are excluded from the summation via a filtered
          list comprehension, preventing silent \c undef corruption.

  \note   The result is a signed volume. Take \c abs() of the return
          value if the sign of winding is uncertain.

  [Wikipedia]: https://en.wikipedia.org/wiki/Polyhedron#Volume
  [divergence theorem]: https://en.wikipedia.org/wiki/Divergence_theorem

    \b Example — unit cube triangulated (expected volume = 1.0):

    \code{.scad}
    c = [[0,0,0],[1,0,0],[1,1,0],[0,1,0],
         [0,0,1],[1,0,1],[1,1,1],[0,1,1]];

    f = [[0,1,2],[0,2,3],[4,6,5],[4,7,6],
         [0,5,1],[0,4,5],[1,6,2],[1,5,6],
         [2,7,3],[2,6,7],[3,4,0],[3,7,4]];

    echo(polyhedron_tf_volume(c, f));  // ECHO: 1
    \endcode
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
      if (len(fi) == 3)
      let
      (
        p0 = c[fi[0]],
        p1 = c[fi[1]],
        p2 = c[fi[2]]
      )
      p0 * cross(p1, p2)
    ],

    sv = sum(vv)
  )
  sv / 6;

//! Compute the center of mass of a triangulated polyhedron in a Euclidean 3d-space.
/***************************************************************************//**
  \param    c <points-3d> A list of 3d cartesian coordinates
              [[x, y, z], ...].

  \param    f <integer-list-3-list> A list of triangular faces that
              enclose the polyhedron, where each face is a list of
              exactly three coordinate indexes. Non-triangular faces
              must be tessellated before calling this function.

  \returns  <point-3d> The center of mass (centroid) of the solid
            polyhedron in the same coordinate space as \p c.

  \details

    The centroid is computed via the [divergence theorem] using first-
    order midpoint quadrature. For each triangular face with vertices
    \f$ \mathbf{p}_0, \mathbf{p}_1, \mathbf{p}_2 \f$ and signed weight

    \f[
      w_i = \mathbf{p}_0 \cdot (\mathbf{p}_1 \times \mathbf{p}_2)
    \f]

    the centroid contribution is:

    \f[
      \mathbf{g}_i = (\mathbf{p}_0 + \mathbf{p}_1 + \mathbf{p}_2)\, w_i
    \f]

    and the overall centroid is:

    \f[
      \mathbf{G} = \frac{\displaystyle\sum_i \mathbf{g}_i}{24\,V}
    \f]

    where \f$ V \f$ is the signed volume returned by \c
    polyhedron_tf_volume(). Volume and the weighted centroid sum are
    computed in a \b single pass over the face list to avoid redundant
    iteration.

    \b Approximation notice: midpoint quadrature is exact only when the
    integrand is linear over each face. For a flat triangulated mesh
    this is exact; for curved or high-curvature approximations the
    error is \f$ O(h^2) \f$ where \f$ h \f$ is the maximum edge length.

    See [Wikipedia: Centroid][Wikipedia] for background.

  \note   All faces must be triangles (exactly 3 vertex indices) wound
          counter-clockwise when viewed from outside (OpenSCAD's native
          \c polyhedron() convention), consistent with
          \c polyhedron_tf_volume(). Faces that do not satisfy
          \c len(fi)==3 are excluded from the summation.

  [Wikipedia]: https://en.wikipedia.org/wiki/Centroid
  [divergence theorem]: https://en.wikipedia.org/wiki/Divergence_theorem

    \b Example — unit cube triangulated (expected centroid = [0.5, 0.5, 0.5]):

    \code{.scad}
    c = [[0,0,0],[1,0,0],[1,1,0],[0,1,0],
         [0,0,1],[1,0,1],[1,1,1],[0,1,1]];

    f = [[0,1,2],[0,2,3],[4,6,5],[4,7,6],
         [0,5,1],[0,4,5],[1,6,2],[1,5,6],
         [2,7,3],[2,6,7],[3,4,0],[3,7,4]];

    echo(polyhedron_tf_centroid(c, f));  // ECHO: [0.5, 0.5, 0.5]
    \endcode
*******************************************************************************/
function polyhedron_tf_centroid
(
  c,
  f
) =
  let
  (
    // Single pass: accumulate both the signed volume terms and the
    // weighted centroid terms simultaneously to avoid iterating the
    // face list twice.
    terms =
    [
      for (fi = f)
      if (len(fi) == 3)
      let
      (
        p0 = c[fi[0]],
        p1 = c[fi[1]],
        p2 = c[fi[2]],

        // Signed tetrahedral scalar: p0 · (p1 × p2)
        w  = p0 * cross(p1, p2)
      )
      // Each entry carries [volume_term, weighted_centroid_term]
      [w, (p0 + p1 + p2) * w]
    ],

    sv = sum([for (t = terms) t[0]]),   // sum of volume terms
    sg = sum([for (t = terms) t[1]]),   // sum of weighted centroid terms

    volume = sv / 6
  )
  sg / (24 * volume);

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
    for (i=[1:3]) echo( "not tested:" );

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
