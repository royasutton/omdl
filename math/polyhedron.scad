//! Polyhedron shapes, conversions, properties, and tests functions..
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2015-2024

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
// shape properties
//----------------------------------------------------------------------------//

//! \name Properties
//! @{

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

//! @}

//! @}
//! @}

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
