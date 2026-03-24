//! Linear algebra mathematical functions.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2015-2023, 2026

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

    \amu_define group_name  (Linear Algebra)
    \amu_define group_brief (Euclidean linear algebra functions.)

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

    The following conventions apply to all functions in this group.
    - The first parameter is always \p c (a list of nd coordinate
      points). All functions return a list of the same length and
      dimensionality as \p c.
    - Dimensionality \p d is auto-detected from the first element of
      \p c using \c len(first(c)). Passing an empty list always returns
      an empty list. Mixing point dimensions within \p c is undefined
      behaviour.
    - The origin parameter \p o is optional in all spatial functions
      that have a fixed point (mirror, rotate, scale, shear, resize).
      When \b undef (default), \p o is set to \p origin2d or \p origin3d
      based on \p d. Exception: in the 3D Euler rotation branch of
      rotate_p(), \p o is silently ignored — see rotate_p() for details.
      When \p center is \b true, \p o is also ignored — see below.
    - The optional \p center parameter (default \b false) is available on
      all spatial functions that have a fixed point (rotate_p(),
      transform_p(), shear_p(), scale_p(), resize_p()). When \b true,
      the transformed result is passed through \c center_p() so that the
      output bounding box is centered about the coordinate origin. Centering
      is always the last step in the pipeline, applied after all other
      transformations including translation. When \p center is \b true,
      \p o is ignored.
    - When a transformation parameter (\p v, \p a, \p m, \p s, \p av)
      is \b undef, that transformation is a no-op and \p c is returned
      unchanged. This allows safe use in composed pipelines without
      conditional wrappers at the call site.
    - The parameter name \p m is overloaded by role across the group:
      a 4x4 homogeneous matrix in multmatrix_p(); a mirror-plane or
      mirror-line normal vector in mirror_p() and transform_p(); and a
      shear-factor list in shear_p() (where the parameter has been
      renamed \p s). The type is stated explicitly in each function's
      \p m or \p s parameter entry.
    - The parameter name \p v is overloaded by role across the group:
      a per-dimension translation list or scalar in translate_p(); a
      per-dimension scale list or scalar in scale_p(); and a
      per-dimension target-extent list or scalar in resize_p(). In
      rotate_p() and transform_p() the rotation axis vector uses the
      distinct name \p av to avoid ambiguity.
    - All angles are in \b degrees, following OpenSCAD convention.
    - No input validation is performed unless an explicit \c assert is
      present. Wrong-dimension inputs, non-numeric values, or zero
      vectors produce \b undef, \b nan, or \b inf without warning.
*******************************************************************************/

//----------------------------------------------------------------------------//
// members
//----------------------------------------------------------------------------//

//! Multiply all coordinates by a 4x4 transformation matrix in 3D.
/***************************************************************************//**
  \param    c <points-3d> A list of 3d coordinate points.

  \param    m <matrix-4x4> A 4x4 transformation matrix. Only the first
              three rows are used; the fourth row of the standard
              homogeneous matrix `[0, 0, 0, 1]` is implicit and need
              not be supplied, so a 3x4 matrix is sufficient.

  \returns  <points-3d> A list of 3d coordinate points multiplied by
            the transformation matrix.

  \details

    Applies a homogeneous transformation matrix \p m to a list of 3D
    coordinate points. Each input point `[x, y, z]` is treated as a
    homogeneous vector `[x, y, z, 1]` (i.e. `w = 1` is implicit — no
    perspective divide is performed). The output is the 3-component
    result of multiplying the upper 3×4 block of \p m by each
    homogeneous input vector:

    ```
    | m[0][0]  m[0][1]  m[0][2]  m[0][3] |   | x |   | x' |
    | m[1][0]  m[1][1]  m[1][2]  m[1][3] | × | y | = | y' |
    | m[2][0]  m[2][1]  m[2][2]  m[2][3] |   | z |   | z' |
                                              | 1 |
    ```

    The fourth row of \p m (normally `[0, 0, 0, 1]` for affine
    transforms) is never read, so a 3×4 matrix is sufficient.
    Combined rotation and translation can be encoded as:
    - Columns 0–2: the 3×3 rotation/scale/shear sub-matrix.
    - Column 3: the translation vector `[tx, ty, tz]`.

    See [Wikipedia] and [multmatrix] for more information.

    \note Unlike the other spatial functions in this group, multmatrix_p()
          takes no \p o origin parameter. Any origin offset for the
          transformation is encoded directly in the fourth column of \p m
          (i.e. `m[0][3]`, `m[1][3]`, `m[2][3]`), as is standard for
          homogeneous transformation matrices.

  [Wikipedia]: https://en.wikipedia.org/wiki/Transformation_matrix
  [multmatrix]: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Transformations#multmatrix
*******************************************************************************/
function multmatrix_p
(
  c,
  m
) = let
    (
      m11=m[0][0], m12=m[0][1], m13=m[0][2], m14=m[0][3],
      m21=m[1][0], m22=m[1][1], m23=m[1][2], m24=m[1][3],
      m31=m[2][0], m32=m[2][1], m33=m[2][2], m34=m[2][3]
    )
    [
      for (ci=c)
        let
        (
          x = ci[0], y = ci[1], z = ci[2]
        )
        [m11*x+m12*y+m13*z+m14, m21*x+m22*y+m23*z+m24, m31*x+m32*y+m33*z+m34]
    ];

//! Translate all coordinates dimensions.
/***************************************************************************//**
  \param    c <points-nd> A list of nd coordinate points.

  \param    v <decimal-list-n | decimal> A list of translations for
              each dimension, or a single decimal to translate
              uniformly across all dimensions.

  \returns  <points-nd> A list of translated coordinate points.

  \details

    When \p v is a scalar, the same translation is applied to every
    dimension. When \p v is a list shorter than the point dimensionality,
    missing elements default to zero. When \p v is \b undef the point
    list is returned unchanged.

    \note Unlike the other spatial functions in this group, translate_p()
          takes no \p o origin parameter. Translation has no fixed point —
          every point moves by the same vector \p v regardless of position,
          so an origin offset would have no effect.

    See [Wikipedia] for more information and [transformation matrix].

  [Wikipedia]: https://en.wikipedia.org/wiki/Translation_(geometry)
  [transformation matrix]: https://en.wikipedia.org/wiki/Transformation_matrix
*******************************************************************************/
function translate_p
(
  c,
  v
) = is_undef(v) ? c
  : (len(c) == 0) ? c
  : let
    (
      d = len(first(c)),
      u = is_scalar(v) ? v : 0,

      w = [for (i=[0 : d-1]) defined_e_or(v, i, u)]
    )
    [for (ci=c) [for (di=[0 : d-1]) ci[di] + w[di]]];

//! Mirror all coordinates about a plane or line defined by a normal vector.
/***************************************************************************//**
  \param    c <points-3d | points-2d> A list of 3d or 2d coordinate
            points.

  \param    m <vector-3d | vector-2d> The normal vector of the mirror
              plane or line. A 2D vector `[nx, ny]` defines the normal
              to the mirror line; a 3D vector `[nx, ny, nz]` defines
              the normal to the mirror plane. Follows the same
              convention as OpenSCAD's built-in `mirror()` module.

  \param    o <point-3d | point-2d> The point through which the mirror
              plane or line passes. When \b undef (default), the origin
              is set automatically to \p origin2d or \p origin3d based
              on the dimensionality of \p c.

  \returns  <points-3d | points-2d> A list of mirrored coordinate
            points.

  \details

    Reflects points about the plane or line defined by the normal
    vector \p m passing through \p o using the standard reflection
    matrix `M = I - 2*(n*nT)/|n|^2`. When \p m is a zero vector or
    \b undef the point list is returned unchanged.

    See [Wikipedia] for more information on [reflection matrix].

  [Wikipedia]: https://en.wikipedia.org/wiki/Transformation_matrix
  [reflection matrix]: https://en.wikipedia.org/wiki/Transformation_matrix#Reflection
*******************************************************************************/
function mirror_p
(
  c,
  m,
  o
) = is_undef(m) ? c
  : (len(c) == 0) ? c
  : let
    (
      d  = len(first(c)),
      eo = defined_or( o, d == 2 ? origin2d : origin3d ),
      ox = eo[0], oy = eo[1],
      nx = m[0],  ny = m[1],
      nz = (d == 3) ? m[2] : 0,
      l2 = nx*nx + ny*ny + nz*nz
    )
    (l2 == 0) ? c
    : (d == 2) ?
      let
      (
        // 2D reflection matrix about line through o with normal [nx,ny]:
        // M = I - 2*(n*nT)/|n|^2
        f   = 2 / l2,

        r11 = 1 - f*nx*nx,
        r12 =   - f*nx*ny,
        r21 =   - f*ny*nx,
        r22 = 1 - f*ny*ny
      )
      [
        for (ci=c)
          let( dx = ci[0]-ox, dy = ci[1]-oy )
          [
            ox + r11*dx + r12*dy,
            oy + r21*dx + r22*dy
          ]
      ]
    : let
      (
        // 3D reflection matrix about plane through o with normal [nx,ny,nz]:
        oz  = eo[2],
        f   = 2 / l2,

        r11 = 1 - f*nx*nx,
        r12 =   - f*nx*ny,
        r13 =   - f*nx*nz,
        r21 =   - f*ny*nx,
        r22 = 1 - f*ny*ny,
        r23 =   - f*ny*nz,
        r31 =   - f*nz*nx,
        r32 =   - f*nz*ny,
        r33 = 1 - f*nz*nz
      )
      [
        for (ci=c)
          let( dx = ci[0]-ox, dy = ci[1]-oy, dz = ci[2]-oz )
          [
            ox + r11*dx + r12*dy + r13*dz,
            oy + r21*dx + r22*dy + r23*dz,
            oz + r31*dx + r32*dy + r33*dz
          ]
      ];

//! Rotate all coordinates about one or more axes in 2D or 3D.
/***************************************************************************//**
  \param    c      <points-3d | points-2d> A list of 3d or 2d coordinate
                   points.

  \param    a      <decimal-list-3 | decimal> The axis rotation angle; A
                   list [ax, ay, az] or a single decimal to specify az only.
                   When \b undef the point list is returned unchanged.

  \param    av     <vector-3d> An arbitrary axis for the rotation. When
                   specified, the rotation angle will be \p a or az about
                   the line \p av that passes through point \p o.

  \param    center <boolean> When \b true, the rotated result is passed
                   through \c center_p() so that the output bounding box
                   is centered about the origin. When \b false (default),
                   the result is positioned as determined by \p o.

  \param    o      <point-3d | point-2d> The origin for the rotation. In 2D,
                   the center of rotation. In 3D, used only when \p av is
                   specified. When \b undef (default), the origin is set
                   automatically to \p origin2d or \p origin3d based on the
                   dimensionality of \p c. Ignored when \p center is \b true.

  \returns  <points-3d | points-2d> A list of rotated coordinate
            points.

  \details

    Three rotation branches are selected based on dimensionality and
    the presence of \p av:
    - \b 2D (\p d = 2): rotates about point \p o by angle \p az
      (extracted as \c a[2], or \p a itself when scalar). \p o is
      the center of rotation.
    - \b 3D Euler (\p d = 3, \p av undef or \p a is a list): applies
      extrinsic rotations in the order Z (`az`), Y (`ay`), X (`ax`),
      equivalent to the standard OpenSCAD `rotate([ax, ay, az])`
      convention. Missing angle components default to \b 0.
    - \b 3D arbitrary axis (\p d = 3, \p av defined, \p a scalar):
      rotates by \p az about the line through \p o with direction
      \p av, using the Rodrigues rotation formula. \p av need not be
      a unit vector; it is normalised internally.

    When \p center is \b true, \c center_p() is called on the rotated
    result to center the output bounding box about the origin.

    \note In the 3D Euler branch the origin \p o is silently ignored
          — rotation always occurs about the world origin. Only the 2D
          branch and the 3D arbitrary-axis branch respect \p o.

    See [Wikipedia] for more information on [transformation matrix]
    and [axis rotation].

  [Wikipedia]: https://en.wikipedia.org/wiki/Rotation_matrix
  [transformation matrix]: https://en.wikipedia.org/wiki/Transformation_matrix
  [axis rotation]: http://inside.mines.edu/fs_home/gmurray/ArbitraryAxisRotation
*******************************************************************************/
function rotate_p
(
  c,
  a,
  av,
  center = false,
  o
) = is_undef(a) ? c
  : (len(c) == 0) ? c
  : let
    (
      d  = len(first(c)),
      eo = defined_or( o, d == 2 ? origin2d : origin3d ),
      az = defined_e_or(a, 2, is_scalar(a) ? a : 0),
      cg = cos(az), sg = sin(az),

      rc = (d == 2) ?
            let( ox = eo[0], oy = eo[1] )
            [
              for (ci=c)
                let( dx = ci[0]-ox, dy = ci[1]-oy )
                [
                  ox + cg*dx - sg*dy,
                  oy + sg*dx + cg*dy
                ]
            ]

         : (d != 3) ? c

         : (is_undef(av) || is_list(a)) ?
            let
            (
              ax  = defined_e_or(a, 0, 0),
              ay  = defined_e_or(a, 1, 0),

              ca  = cos(ax), cb = cos(ay),
              sa  = sin(ax), sb = sin(ay),

              m11 = cb*cg,
              m12 = cg*sa*sb-ca*sg,
              m13 = ca*cg*sb+sa*sg,
              m21 = cb*sg,
              m22 = ca*cg+sa*sb*sg,
              m23 = -cg*sa+ca*sb*sg,
              m31 = -sb,
              m32 = cb*sa,
              m33 = ca*cb
            )
            multmatrix_p(c, [[m11,m12,m13,0], [m21,m22,m23,0], [m31,m32,m33,0]])

         :  let
            (
              vx  = av[0], vy  = av[1], vz  = av[2],
              vx2 = vx*vx, vy2 = vy*vy, vz2 = vz*vz,
              l2  = vx2 + vy2 + vz2
            )
            (l2 == 0) ? c

         :  let
            (
              // normalise av to a unit vector; all matrix coefficients then
              // follow the standard unit-vector Rodrigues rotation formula
              ll  = sqrt(l2),
              ux  = vx/ll, uy = vy/ll, uz = vz/ll,
              ux2 = ux*ux, uy2 = uy*uy, uz2 = uz*uz,
              ox  = eo[0], oy = eo[1], oz = eo[2],
              oc  = 1 - cg,

              m11 = ux2+(uy2+uz2)*cg,
              m12 = ux*uy*oc-uz*sg,
              m13 = ux*uz*oc+uy*sg,
              m14 = (ox*(uy2+uz2)-ux*(oy*uy+oz*uz))*oc+(oy*uz-oz*uy)*sg,
              m21 = ux*uy*oc+uz*sg,
              m22 = uy2+(ux2+uz2)*cg,
              m23 = uy*uz*oc-ux*sg,
              m24 = (oy*(ux2+uz2)-uy*(ox*ux+oz*uz))*oc+(oz*ux-ox*uz)*sg,
              m31 = ux*uz*oc-uy*sg,
              m32 = uy*uz*oc+ux*sg,
              m33 = uz2+(ux2+uy2)*cg,
              m34 = (oz*(ux2+uy2)-uz*(ox*ux+oy*uy))*oc+(ox*uy-oy*ux)*sg
            )
            multmatrix_p(c, [[m11,m12,m13,m14], [m21,m22,m23,m24], [m31,m32,m33,m34]])
    )
    center ? center_p(rc) : rc;

//! Apply an optional mirror, rotation, and translation to a list of 2D or 3D coordinates.
/***************************************************************************//**
  \param    c      <points-3d | points-2d> A list of 3d or 2d coordinate
                   points.

  \param    m      <vector-3d | vector-2d> The normal vector of the mirror
                   plane or line. The mirror is applied about the plane or
                   line passing through \p o with the given normal. When \b
                   undef (default), no mirror is applied.

  \param    a      <decimal-list-3 | decimal> The axis rotation angle; A
                   list [ax, ay, az] or a single decimal to specify az only.
                   When \b undef, no rotation is applied.

  \param    av     <vector-3d> An arbitrary axis for the rotation. When
                   specified, the rotation angle will be \p a or az about
                   the line \p av that passes through point \p o.

  \param    center <boolean> When \b true, the fully transformed result is
                   passed through \c center_p() so that the output bounding
                   box is centered about the origin. Centering is applied
                   after mirror, rotation, and translation. When \b false
                   (default), the result is positioned as determined by \p o
                   and \p t.

  \param    o      <point-3d | point-2d> The origin for the rotation and
                   mirror. In 2D, the center of rotation. In 3D, used only
                   when \p av is specified. When \b undef (default), the
                   origin is set automatically to \p origin2d or \p origin3d
                   based on the dimensionality of \p c.

  \param    t      <point-3d | point-2d> A translation vector applied after
                   mirror and rotation. When \b undef (default), no
                   translation is applied. Translation is always applied
                   last before centering.

  \returns  <points-3d | points-2d> A list of 3d or 2d transformed
            coordinates. Operations are applied in order: mirror about
            \p o, rotate about \p o, translate by \p t, then optionally
            center via \c center_p(). In 3D Euler mode, rotation order is
            extrinsic Z, Y, X (equivalent to OpenSCAD \c rotate([ax,ay,az])).

  \details

    Applies a transformation to a list of coordinate points by
    composing mirror_p(), rotate_p(), and translate_p() in sequence.
    The mirror \p m, when specified, reflects points about the plane or
    line defined by the normal vector \p m passing through \p o.
    Rotation \p a is then applied about \p o, followed by the optional
    translation \p t. Any combination of the three operations may be
    used independently — in particular, \p m and \p t may be specified
    without \p a to mirror and then translate without rotation. When
    \p center is \b true, \c center_p() is called on the final result
    to center the output bounding box about the origin.

    The mirror normal \p m follows the same convention as OpenSCAD's
    built-in `mirror()` module: a 2D vector `[nx, ny]` defines the
    normal to the mirror line, and a 3D vector `[nx, ny, nz]` defines
    the normal to the mirror plane.

    When \p a, \p m, \p t, and \p center are all \b undef or \b false
    the point list is returned unchanged.

    See [Wikipedia] for more information on [transformation matrix],
    [axis rotation], and [reflection matrix].

  [Wikipedia]: https://en.wikipedia.org/wiki/Rotation_matrix
  [transformation matrix]: https://en.wikipedia.org/wiki/Transformation_matrix
  [axis rotation]: http://inside.mines.edu/fs_home/gmurray/ArbitraryAxisRotation
  [reflection matrix]: https://en.wikipedia.org/wiki/Transformation_matrix#Reflection
*******************************************************************************/
function transform_p
(
  c,
  m,
  a,
  av,
  center = false,
  o,
  t
) = let( r = translate_p( rotate_p( mirror_p( c, m, o ), a, av, o=o ), t ) )
    center ? center_p(r) : r;

//! Shear all coordinates in 2D or 3D.
/***************************************************************************//**
  \param    c      <points-3d | points-2d> A list of 3d or 2d coordinate
                   points.

  \param    s      <decimal-list> The shear factors. In 2D, a list
                   `[sxy, syx]` where \c sxy shifts x proportional to y and
                   \c syx shifts y proportional to x. In 3D, a list `[sxy,
                   sxz, syx, syz, szx, szy]` following the standard shear
                   matrix convention.

  \param    center <boolean> When \b true, the sheared result is passed
                   through \c center_p() so that the output bounding box
                   is centered about the origin. When \b false (default),
                   the result is positioned as determined by \p o.

  \param    o      <point-3d | point-2d> The origin about which shearing is
                   applied. When \b undef (default), the origin is set
                   automatically to \p origin2d or \p origin3d based on the
                   dimensionality of \p c. Shearing about an explicit origin
                   is equivalent to translating by `-o`, shearing, then
                   translating back by `+o`. Ignored when \p center is
                   \b true.

  \returns  <points-3d | points-2d> A list of sheared coordinate
            points.

  \details

    Applies a shear transformation to a list of coordinate points.
    Shearing displaces each coordinate in one axis proportionally to
    its position along another axis, leaving the shear origin fixed.

    The 2D shear matrix for factors `[sxy, syx]` is:
    ```
    | 1    sxy |
    | syx  1   |
    ```

    The 3D shear matrix for factors `[sxy, sxz, syx, syz, szx, szy]` is:
    ```
    | 1    sxy  sxz |
    | syx  1    syz |
    | szx  szy  1   |
    ```

    Missing list elements default to \b 0 (no shear in that direction).
    When \p center is \b true, \c center_p() is called on the sheared
    result to center the output bounding box about the origin, and \p o
    is ignored. When \p s is \b undef the point list is returned unchanged.

    See [Wikipedia] for more information on [shear mapping].

  [Wikipedia]: https://en.wikipedia.org/wiki/Shear_mapping
  [shear mapping]: https://en.wikipedia.org/wiki/Shear_mapping
*******************************************************************************/
function shear_p
(
  c,
  s,
  center = false,
  o
) = is_undef(s) ? c
  : (len(c) == 0) ? c
  : let
    (
      d   = len(first(c)),
      eo  = defined_or( o, d == 2 ? origin2d : origin3d ),

      r   = (d == 2) ?
              let
              (
                ox  = eo[0], oy = eo[1],
                sxy = defined_e_or(s, 0, 0),
                syx = defined_e_or(s, 1, 0)
              )
              [
                for (ci=c)
                  let( dx = ci[0]-ox, dy = ci[1]-oy )
                  [
                    ox + dx + sxy*dy,
                    oy + syx*dx + dy
                  ]
              ]
            : (d == 3) ?
              let
              (
                ox  = eo[0], oy = eo[1], oz = eo[2],
                sxy = defined_e_or(s, 0, 0),
                sxz = defined_e_or(s, 1, 0),
                syx = defined_e_or(s, 2, 0),
                syz = defined_e_or(s, 3, 0),
                szx = defined_e_or(s, 4, 0),
                szy = defined_e_or(s, 5, 0)
              )
              [
                for (ci=c)
                  let( dx = ci[0]-ox, dy = ci[1]-oy, dz = ci[2]-oz )
                  [
                    ox + dx  + sxy*dy + sxz*dz,
                    oy + syx*dx + dy  + syz*dz,
                    oz + szx*dx + szy*dy + dz
                  ]
              ]
            : c
    )
    center ? center_p(r) : r;

//! Scale all coordinates dimensions.
/***************************************************************************//**
  \param    c      <points-nd> A list of nd coordinate points.

  \param    v      <decimal-list-n | decimal> A list of scale factors for
                   each dimension, or a single decimal to scale uniformly
                   across all dimensions.

  \param    center <boolean> When \b true, the scaled result is passed
                   through \c center_p() so that the output bounding box
                   is centered about the origin. When \b false (default),
                   the result is positioned as determined by \p o.

  \param    o      <point-nd> The origin about which scaling is applied.
                   When \b undef (default), the origin is set automatically
                   to \p origin2d or \p origin3d based on the dimensionality
                   of \p c. Scaling about an explicit origin is equivalent
                   to translating by `-o`, scaling, then translating back by
                   `+o`. Ignored when \p center is \b true.

  \returns  <points-nd> A list of scaled coordinate points.

  \details

    When \p v is a scalar, the same scale factor is applied to every
    dimension. When \p v is a list shorter than the point dimensionality,
    missing elements default to \b 1 (no scaling). When \p o is the
    origin the result is identical to scaling about the origin. When
    \p center is \b true, \c center_p() is called on the scaled result
    to center the output bounding box about the origin, and \p o is
    ignored. When \p v is \b undef the point list is returned unchanged.

    See [Wikipedia] for more information on [transformation matrix].

  [Wikipedia]: https://en.wikipedia.org/wiki/Scaling_(geometry)
  [transformation matrix]: https://en.wikipedia.org/wiki/Transformation_matrix
*******************************************************************************/
function scale_p
(
  c,
  v,
  center = false,
  o
) = is_undef(v) ? c
  : (len(c) == 0) ? c
  : let
    (
      d  = len(first(c)),
      eo = defined_or( o, d == 2 ? origin2d : origin3d ),

      u  = is_scalar(v) ? v : 1,
      w  = [for (i=[0 : d-1]) defined_e_or(v, i, u)],

      r  = [for (ci=c) [for (di=[0 : d-1]) eo[di] + (ci[di] - eo[di]) * w[di]]]
    )
    center ? center_p(r) : r;

//! Scale all coordinates dimensions proportionately to fit inside a region.
/***************************************************************************//**
  \param    c      <points-nd> A list of nd coordinate points.

  \param    v      <decimal-list-n | decimal> A list of target extents
                   for each dimension. When a scalar, the same target
                   extent is applied to every dimension (the aspect
                   ratio of the input is not preserved). When a list
                   shorter than the point dimensionality, missing
                   elements default to \b 1.

  \param    center <boolean> When \b true, the scaled result is centered
                   about the origin by passing the scaled point list
                   through \c center_p(). When \b false (default), the
                   bounding box minimum is placed at the origin before
                   scaling so that the result spans `[0, v[i]]` in each
                   dimension.

  \param    o      <point-nd> The origin to which the bounding box
                   minimum is aligned before scaling. When \b undef
                   (default), the origin is set automatically to
                   \p origin2d or \p origin3d based on the
                   dimensionality of \p c. Ignored when \p center is
                   \b true — the result is centered about the coordinate
                   origin regardless of \p o.

  \returns  <points-nd> A list of proportionately scaled coordinate
            points which exactly fit the region bounds \p v.

  \details

    Points are first translated so that the bounding box minimum of
    each dimension is aligned to \p o, then scaled to fit \p v. This
    ensures a consistent result regardless of where the input points
    are positioned. When a dimension has zero extent (all points share
    the same coordinate), that dimension is left unchanged to avoid
    division by zero. When \p center is \b true, the scaled result is
    passed through \c center_p() to center it about the coordinate
    origin, and \p o is ignored. When \p v is \b undef the point list
    is returned unchanged.

    \note The bounding box is computed by iterating \p c once per
          dimension, giving O(n*d) total work where n = len(c) and
          d = len(first(c)). When \p center is \b true an additional
          O(n*d) pass is performed by \c center_p(). For typical 2D or
          3D inputs this is negligible, but callers passing very large
          point lists should be aware of the linear scaling with both
          n and d.

    See [Wikipedia] for more information on [transformation matrix].

  [Wikipedia]: https://en.wikipedia.org/wiki/Scaling_(geometry)
  [transformation matrix]: https://en.wikipedia.org/wiki/Transformation_matrix
*******************************************************************************/
function resize_p
(
  c,
  v,
  center = false,
  o
) = is_undef(v) ? c
  : (len(c) == 0) ? c
  : let
    (
      d  = len(first(c)),
      eo = defined_or( o, d == 2 ? origin2d : origin3d ),

      u  = is_scalar(v) ? v : 1,
      w  = [for (i=[0 : d-1]) defined_e_or(v, i, u)],

      // per-dimension [min, max] bounding values
      bv = [for (i=[0 : d-1]) let (cv = [for (ci=c) ci[i]]) [min(cv), max(cv)]],

      // per-dimension extent; zero extent yields scale factor 1 (no change)
      s  = [for (i=[0 : d-1]) let (e = bv[i][1] - bv[i][0]) e == 0 ? 1 : w[i]/e],

      // scaled result aligned to eo; centering is delegated to center_p()
      r  = [for (ci=c) [for (di=[0 : d-1]) (ci[di] - bv[di][0]) * s[di] + eo[di]]]
    )
    center ? center_p(r) : r;

//! Center all coordinates about the origin.
/***************************************************************************//**
  \param    c <points-nd> A list of nd coordinate points.

  \returns  <points-nd> A list of coordinate points translated so that
            the bounding box of the result is centered about the origin.

  \details

    Computes the per-dimension bounding box midpoint of \p c and
    translates all points by the negation of that midpoint, so that the
    output bounding box is symmetric about the origin in every dimension.
    The shape, size, and relative positions of all points are preserved —
    only the position of the point cloud as a whole changes.

    Centering is performed by a single bounding-box pass (O(n*d) where
    n = len(c) and d = len(first(c))) followed by a single translation
    pass, making the total work O(n*d). Passing an empty list returns
    an empty list unchanged.

    \note This function is called directly by \c resize_p when its
          \p center parameter is \b true. It may be composed freely
          with any other spatial function in this group to post-center
          the result of an arbitrary transformation pipeline.

    See [Wikipedia] for more information on [translation].

  [Wikipedia]: https://en.wikipedia.org/wiki/Translation_(geometry)
  [translation]: https://en.wikipedia.org/wiki/Translation_(geometry)
*******************************************************************************/
function center_p
(
  c
) = (len(c) == 0) ? c
  : let
    (
      d   = len(first(c)),

      // per-dimension [min, max] bounding values
      bv  = [for (i=[0 : d-1]) let (cv = [for (ci=c) ci[i]]) [min(cv), max(cv)]],

      // per-dimension midpoint of bounding box
      mid = [for (i=[0 : d-1]) (bv[i][0] + bv[i][1]) / 2]
    )
    [for (ci=c) [for (di=[0 : d-1]) ci[di] - mid[di]]];

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
    for (i=[1:9]) echo( "not tested:" );

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
