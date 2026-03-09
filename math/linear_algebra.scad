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

//! Multiply all coordinates by a 4x4 transformation matrix in 3D.
/***************************************************************************//**
  \param    c <points-3d> A list of 3d coordinate points.

  \param    m <matrix-4x4> A 4x4 transformation matrix.

  \returns  <points-3d> A list of 3d coordinate points multiplied by
            the transformation matrix.

  \details

    See [Wikipedia] and [multmatrix] for more information.

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

  \param    v <decimal-list-n> A list of translations for each dimension.

  \returns  <points-nd> A list of translated coordinate points.

  \details

    See [Wikipedia] for more information and [transformation matrix].

    [Wikipedia]: https://en.wikipedia.org/wiki/Translation_(geometry)
    [transformation matrix]: https://en.wikipedia.org/wiki/Transformation_matrix
*******************************************************************************/
function translate_p
(
  c,
  v
) = is_undef(v) ? c
  : let
    (
      d = len(first(c)),
      u = is_scalar(v) ? v : 0,
      w = [for (i=[0 : d-1]) defined_e_or(v, i, u)]
    )
    [for (ci=c) [for (di=[0 : d-1]) ci[di] + w[di]]];

//! Apply an optional mirror, rotation, and translation to a list of 2D or 3D coordinates.
/***************************************************************************//**
  \param    c <points-3d | points-2d> A list of 3d or 2d coordinate
              points.

  \param    a <decimal-list-3 | decimal> The axis rotation angle; A
              list [ax, ay, az] or a single decimal to specify az only.

  \param    v <vector-3d> An arbitrary axis for the rotation. When
              specified, the rotation angle will be \p a or az about the
              line \p v that passes through point \p o.

  \param    o <point-3d | point-2d> The origin for the rotation. In 2D,
              the center of rotation. In 3D, used only when \p v is
              specified. When \b undef (default), the origin is set
              automatically to \p origin2d or \p origin3d based on the
              dimensionality of \p c.

  \param    t <point-3d | point-2d> A translation vector applied after
              rotation. When \b undef (default), no translation is
              applied.

  \param    m <vector-3d | vector-2d> The normal vector of the mirror
              plane or line. The mirror is applied about the plane or
              line passing through \p o with the given normal. When \b
              undef (default), no mirror is applied.

  \returns  <points-3d | points-2d> A list of 3d or 2d transformed
            coordinates. Operations are applied in order: mirror about
            \p o, rotate about \p o, translate by \p t. Rotation order
            is rz, ry, rx.

  \details

  Applies a transformation to a list of coordinate points. The mirror
  \p m, when specified, reflects points about the plane or line defined
  by the normal vector \p m passing through \p o. Rotation \p a is then
  applied about \p o, followed by the optional translation \p t. Any
  combination of the three operations may be used independently.

  The mirror normal \p m follows the same convention as OpenSCAD's
  built-in `mirror()` module: a 2D vector `[nx, ny]` defines the normal
  to the mirror line, and a 3D vector `[nx, ny, nz]` defines the normal
  to the mirror plane.

  When \p a is \b undef and \p m is \b undef the point list is returned
  unchanged.

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
  a,
  v,
  o,
  t,
  m
) = let
    (
      d  = len(first(c)),
      eo = defined_or( o, d == 2 ? origin2d : origin3d ),

      // apply mirror first if requested
      cm  = is_undef(m) ? c
          : let
            (
              ox  = eo[0], oy = eo[1],
              nx  = m[0],  ny = m[1],
              l2  = nx*nx + ny*ny
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
                nz  = m[2],
                l2b = l2 + nz*nz,
                oz  = eo[2],
                f   = 2 / l2b,

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
              ]
    )
    // then apply rotation + translation
    is_undef(a) ? cm
  : let
    (
      az = defined_e_or(a, 2, is_scalar(a) ? a : 0),
      cg = cos(az), sg = sin(az),

      tx = defined_e_or(t, 0, 0),
      ty = defined_e_or(t, 1, 0),
      tz = defined_e_or(t, 2, 0),

      rc = (d == 2) ?
            let( ox = eo[0], oy = eo[1] )
            [
              for (ci=cm)
                let( dx = ci[0]-ox, dy = ci[1]-oy )
                [
                  ox + cg*dx - sg*dy + tx,
                  oy + sg*dx + cg*dy + ty
                ]
            ]

         : (d != 3) ? cm

         : (is_undef(v) || is_list(a)) ?
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
            multmatrix_p(cm, [[m11,m12,m13,tx], [m21,m22,m23,ty], [m31,m32,m33,tz]])

         :  let
            (
              vx  = v[0],  vy  = v[1],  vz  = v[2],
              vx2 = vx*vx, vy2 = vy*vy, vz2 = vz*vz,
              l2  = vx2 + vy2 + vz2
            )
            (l2 == 0) ? cm

         :  let
            (
              ox  = eo[0], oy = eo[1], oz = eo[2],
              ll  = sqrt(l2),
              oc  = 1 - cg,

              m11 = vx2+(vy2+vz2)*cg,
              m12 = vx*vy*oc-vz*ll*sg,
              m13 = vx*vz*oc+vy*ll*sg,
              m14 = (ox*(vy2+vz2)-vx*(oy*vy+oz*vz))*oc+(oy*vz-oz*vy)*ll*sg,
              m21 = vx*vy*oc+vz*ll*sg,
              m22 = vy2+(vx2+vz2)*cg,
              m23 = vy*vz*oc-vx*ll*sg,
              m24 = (oy*(vx2+vz2)-vy*(ox*vx+oz*vz))*oc+(oz*vx-ox*vz)*ll*sg,
              m31 = vx*vz*oc-vy*ll*sg,
              m32 = vy*vz*oc+vx*ll*sg,
              m33 = vz2+(vx2+vy2)*cg,
              m34 = (oz*(vx2+vy2)-vz*(ox*vx+oy*vy))*oc+(ox*vy-oy*vx)*ll*sg
            )
            multmatrix_p(cm, [[m11,m12,m13,m14+tx], [m21,m22,m23,m24+ty], [m31,m32,m33,m34+tz]])/l2
    )
    rc;

//! Scale all coordinates dimensions.
/***************************************************************************//**
  \param    c <points-nd> A list of nd coordinate points.

  \param    v <decimal-list-n> A list of scalers for each dimension.

  \returns  <points-nd> A list of scaled coordinate points.
*******************************************************************************/
function scale_p
(
  c,
  v
) = is_undef(v) ? c
  : let
    (
      d = len(first(c)),
      u = is_scalar(v) ? v : 1,
      w = [for (i=[0 : d-1]) defined_e_or(v, i, u)]
    )
    [for (ci=c) [for (di=[0 : d-1]) ci[di] * w[di]]];

//! Scale all coordinates dimensions proportionately to fit inside a region.
/***************************************************************************//**
  \param    c <points-nd> A list of nd coordinate points.

  \param    v <decimal-list-n> A list of bounds for each dimension.

  \returns  <points-nd> A list of proportionately scaled coordinate
            points which exactly fit the region bounds \p v.
*******************************************************************************/
function resize_p
(
  c,
  v
) = is_undef(v) ? c
  : let
    (
      d = len(first(c)),
      u = is_scalar(v) ? v : 1,
      w = [for (i=[0 : d-1]) defined_e_or(v, i, u)],
      m = [for (i=[0 : d-1]) let (cv = [for (ci=c) (ci[i])]) [min(cv), max(cv)]],
      s = [for (i=[0 : d-1]) second(m[i]) - first(m[i])]
    )
    [for (ci=c) [for (di=[0 : d-1]) ci[di]/s[di] * w[di]]];

//! @}
//! @}

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
