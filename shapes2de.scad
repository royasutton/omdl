//! Linearly extruded two-dimensional basic shapes.
/***************************************************************************//**
  \file   shapes2de.scad
  \author Roy Allen Sutton
  \date   2015-2017

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

  \ingroup shapes shapes_2de
*******************************************************************************/

include <shapes2d.scad>;

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \addtogroup shapes
  @{

    \amu_define caption (2D Extrusions)

    \amu_make png_files (append=dim extension=png)
    \amu_make eps_files (append=dim extension=png2eps)
    \amu_shell file_cnt ("echo ${png_files} | wc -w")
    \amu_shell cell_num ("seq -f '(%g)' -s '^' ${file_cnt}")

    \htmlonly
      \amu_image_table
        (
          type=html columns=4 image_width="200" cell_files="${png_files}"
          table_caption="${caption}" cell_captions="${cell_num}"
        )
    \endhtmlonly
    \latexonly
      \amu_image_table
        (
          type=latex columns=4 image_width="1.25in" cell_files="${eps_files}"
          table_caption="${caption}" cell_captions="${cell_num}"
        )
    \endlatexonly

  \defgroup shapes_2de 2D Extrusions
  \brief    Extruded two dimensional geometric shapes.
  @{
*******************************************************************************/
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
// amu macros
//----------------------------------------------------------------------------//
/***************************************************************************//**
  \amu_define scope (shapes2de_dim)
  \amu_define tuple (qvga_diag)

  \amu_define example_dim
  (
    \image html  ${scope}_${tuple}_${function}.png "${function}"
    \image latex ${scope}_${tuple}_${function}.eps "${function}" width=2.5in
    \dontinclude ${scope}.scad \skipline ${function}(
  )
*******************************************************************************/
//----------------------------------------------------------------------------//

//! An extruded rectangle.
/***************************************************************************//**
  \param    size <vector|decimal> A vector [x, y] of decimals
            or a single decimal for (x=y).

  \param    h <vector|decimal> A vector of decimals or a single decimal to
            specify simple extrusion height.

  \param    vr <vector|decimal> The corner rounding radius.
            A vector [v1r, v2r, v3r, v4r] of decimals or a single decimal
            for (v1r=v2r=v3r=v4r). Unspecified corners are not rounded.

  \param    center <boolean> Center about origin.

  \details

    \sa st_linear_extrude_scale for a description on specifying \p h.

    \b Example
    \amu_eval ( function=erectangle ${example_dim} )
*******************************************************************************/
module erectangle
(
  size,
  h,
  vr,
  center = false
)
{
  st_linear_extrude_scale(h=h, center=center)
  rectangle(size=size, vr=vr, center=center);
}

//! An extruded rectangle with a removed rectangular core.
/***************************************************************************//**
  \param    size <vector|decimal> A vector [x, y] of decimals
            or a single decimal for (x=y).
  \param    core <vector|decimal> A vector [x, y] of decimals
            or a single decimal for (x=y).

  \param    h <vector|decimal> A vector of decimals or a single decimal to
            specify simple extrusion height.

  \param    t <vector|decimal> A vector [x, y] of decimals
            or a single decimal for (x=y).

  \param    co <vector> Core offset. A vector [x, y] of decimals.
  \param    cr <decimal> Core z-rotation.

  \param    vr <vector|decimal> The default corner rounding radius.
            A vector [v1r, v2r, v3r, v4r] of decimals or a single decimal
            for (v1r=v2r=v3r=v4r). Unspecified corners are not rounded.
  \param    vr1 <vector|decimal> The outer corner rounding radius.
            A vector [v1r, v2r, v3r, v4r] of decimals or a single decimal
            for (v1r=v2r=v3r=v4r). Unspecified corners are not rounded.
  \param    vr2 <vector|decimal> The core corner rounding radius.
            A vector [v1r, v2r, v3r, v4r] of decimals or a single decimal
            for (v1r=v2r=v3r=v4r). Unspecified corners are not rounded.

  \param    center <boolean> Center about origin.

  \details

    \sa st_linear_extrude_scale for a description on specifying \p h.

    Thickness \p t
    \li <tt>core = size - t</tt>; when \p t and \p size are given.
    \li <tt>size = core + t</tt>; when \p t and \p core are given.

    \b Example
    \amu_eval ( function=erectangle_c ${example_dim} )
*******************************************************************************/
module erectangle_c
(
  size,
  core,
  h,
  t,
  co,
  cr = 0,
  vr,
  vr1,
  vr2,
  center = false
)
{
  st_linear_extrude_scale(h=h, center=center)
  rectangle_c
  (
    size=size, core=core, t=t,
    co=co, cr=cr,
    vr=vr, vr1=vr1, vr2=vr2,
    center=center
  );
}

//! An extruded rhombus.
/***************************************************************************//**
  \param    size <vector|decimal> A vector [w, h] of decimals
            or a single decimal for (w=h).

  \param    h <vector|decimal> A vector of decimals or a single decimal to
            specify simple extrusion height.

  \param    vr <vector|decimal> The corner rounding radius.
            A vector [v1r, v2r, v3r, v4r] of decimals or a single decimal
            for (v1r=v2r=v3r=v4r). Unspecified corners are not rounded.

  \param    center <boolean> Center about origin.

  \details

    \sa st_linear_extrude_scale for a description on specifying \p h.

    \b Example
    \amu_eval ( function=erhombus ${example_dim} )
*******************************************************************************/
module erhombus
(
  size,
  h,
  vr,
  center = false
)
{
  st_linear_extrude_scale(h=h, center=center)
  rhombus(size=size, vr=vr, center=center);
}

//! An extruded general triangle specified by three vertices.
/***************************************************************************//**
  \param    v1 <vector> A vector [x, y] for vertex 1.
  \param    v2 <vector> A vector [x, y] for vertex 2.
  \param    v3 <vector> A vector [x, y] for vertex 3.

  \param    h <vector|decimal> A vector of decimals or a single decimal to
            specify simple extrusion height.

  \param    vr <decimal> The default vertex rounding radius.
  \param    v1r <decimal> Vertex 1 rounding radius.
  \param    v2r <decimal> Vertex 2 rounding radius.
  \param    v3r <decimal> Vertex 3 rounding radius.

  \param    centroid <boolean> Center centroid at origin.
  \param    incenter <boolean> Center incenter at origin.
  \param    center <boolean> Center about origin.

  \details

    \sa st_linear_extrude_scale for a description on specifying \p h.

    \b Example
    \amu_eval ( function=etriangle_ppp ${example_dim} )
*******************************************************************************/
module etriangle_ppp
(
  v1,
  v2,
  v3,
  h,
  vr,
  v1r,
  v2r,
  v3r,
  centroid = false,
  incenter = false,
  center = false
)
{
  st_linear_extrude_scale(h=h, center=center)
  triangle_ppp
  (
    v1=v1, v2=v2, v3=v3,
    vr=vr, v1r=v1r, v2r=v2r, v3r=v3r,
    centroid=centroid, incenter=incenter
  );
}

//! An extruded general triangle specified by a vector of its three vertices.
/***************************************************************************//**
  \param    v <vector> A vector [v1, v2, v3] of vectors [x, y].

  \param    h <vector|decimal> A vector of decimals or a single decimal to
            specify simple extrusion height.

  \param    vr <vector|decimal> The vertex rounding radius. A vector
            [v1r, v2r, v3r] of decimals or a single decimal for (v1r=v2r=v3r).

  \param    centroid <boolean> Center centroid at origin.
  \param    incenter <boolean> Center incenter at origin.
  \param    center <boolean> Center about origin.

  \details

    \sa st_linear_extrude_scale for a description on specifying \p h.

    \b Example
    \code{.C}
    t = triangle_lll2vp( 30, 40, 50 );
    r = [2, 4, 6];
    etriangle_vp( v=t, h=5, vr=r );
    \endcode
*******************************************************************************/
module etriangle_vp
(
  v,
  h,
  vr,
  centroid = false,
  incenter = false,
  center = false
)
{
  st_linear_extrude_scale(h=h, center=center)
  triangle_vp(v=v, vr=vr, centroid=centroid, incenter=incenter);
}

//! An extruded general triangle specified by its three side lengths.
/***************************************************************************//**
  \param    s1 <decimal> The length of the side 1 (along the x-axis).
  \param    s2 <decimal> The length of the side 2.
  \param    s3 <decimal> The length of the side 3.

  \param    h <vector|decimal> A vector of decimals or a single decimal to
            specify simple extrusion height.

  \param    vr <decimal> The default vertex rounding radius.
  \param    v1r <decimal> Vertex 1 rounding radius.
  \param    v2r <decimal> Vertex 2 rounding radius.
  \param    v3r <decimal> Vertex 3 rounding radius.

  \param    centroid <boolean> Center centroid at origin.
  \param    incenter <boolean> Center incenter at origin.
  \param    center <boolean> Center about origin.

  \details

    \sa st_linear_extrude_scale for a description on specifying \p h.

    \b Example
    \amu_eval ( function=etriangle_lll ${example_dim} )
*******************************************************************************/
module etriangle_lll
(
  s1,
  s2,
  s3,
  h,
  vr,
  v1r,
  v2r,
  v3r,
  centroid = false,
  incenter = false,
  center = false
)
{
  st_linear_extrude_scale(h=h, center=center)
  triangle_lll
  (
    s1=s1, s2=s2, s3=s3,
    vr=vr, v1r=v1r, v2r=v2r, v3r=v3r,
    centroid=centroid, incenter=incenter
  );
}

//! An extruded general triangle specified by a vector of its three side lengths.
/***************************************************************************//**
  \param    v <vector> A vector [s1, s2, s3] of decimals.

  \param    h <vector|decimal> A vector of decimals or a single decimal to
            specify simple extrusion height.

  \param    vr <vector|decimal> The vertex rounding radius. A vector
            [v1r, v2r, v3r] of decimals or a single decimal for (v1r=v2r=v3r).

  \param    centroid <boolean> Center centroid at origin.
  \param    incenter <boolean> Center incenter at origin.
  \param    center <boolean> Center about origin.

  \details

    \sa st_linear_extrude_scale for a description on specifying \p h.

    \b Example
    \code{.C}
    t = triangle_lll2vp( 3, 4, 5 );
    s = triangle_vp2vl( t );
    etriangle_vl( v=s, h=5, vr=2 );
    \endcode
*******************************************************************************/
module etriangle_vl
(
  v,
  h,
  vr,
  centroid = false,
  incenter = false,
  center = false
)
{
  st_linear_extrude_scale(h=h, center=center)
  triangle_vl(v=v, vr=vr, centroid=centroid, incenter=incenter);
}

//! A general triangle specified by its sides with a removed triangular core.
/***************************************************************************//**
  \param    vs <vector|decimal> The size. A vector [s1, s2, s3] of decimals
            or a single decimal for (s1=s2=s3).
  \param    vc <vector|decimal> The core. A vector [s1, s2, s3] of decimals
            or a single decimal for (s1=s2=s3).

  \param    h <vector|decimal> A vector of decimals or a single decimal to
            specify simple extrusion height.

  \param    co <vector> Core offset. A vector [x, y] of decimals.
  \param    cr <decimal> Core z-rotation.

  \param    vr <vector|decimal> The default vertex rounding radius. A vector
            [v1r, v2r, v3r] of decimals or a single decimal for (v1r=v2r=v3r).
  \param    vr1 <vector|decimal> The outer vertex rounding radius. A vector
            [v1r, v2r, v3r] of decimals or a single decimal for (v1r=v2r=v3r).
  \param    vr2 <vector|decimal> The core vertex rounding radius. A vector
            [v1r, v2r, v3r] of decimals or a single decimal for (v1r=v2r=v3r).

  \param    centroid <boolean> Center centroid at origin.
  \param    incenter <boolean> Center incenter at origin.
  \param    center <boolean> Center about origin.

  \details

    \sa st_linear_extrude_scale for a description on specifying \p h.

    \b Example
    \amu_eval ( function=etriangle_vl_c ${example_dim} )

  \note The outer and inner triangles centroids are aligned prior to the
        core removal.
*******************************************************************************/
module etriangle_vl_c
(
  vs,
  vc,
  h,
  co,
  cr = 0,
  vr,
  vr1,
  vr2,
  centroid = false,
  incenter = false,
  center = false
)
{
  st_linear_extrude_scale(h=h, center=center)
  triangle_vl_c
  (
    vs=vs, vc=vc,
    co=co, cr=cr,
    vr=vr, vr1=vr1, vr2=vr2,
    centroid=centroid, incenter=incenter
  );
}

//! An extruded general triangle specified by two sides and the included angle.
/***************************************************************************//**
  \param    s1 <decimal> The length of the side 1.
  \param    a <decimal> The included angle in degrees.
  \param    s2 <decimal> The length of the side 2.

  \param    h <vector|decimal> A vector of decimals or a single decimal to
            specify simple extrusion height.

  \param    x <decimal> The side to draw on the positive x-axis (\p x=1 for \p s1).

  \param    vr <decimal> The default vertex rounding radius.
  \param    v1r <decimal> Vertex 1 rounding radius.
  \param    v2r <decimal> Vertex 2 rounding radius.
  \param    v3r <decimal> Vertex 3 rounding radius.

  \param    centroid <boolean> Center centroid at origin.
  \param    incenter <boolean> Center incenter at origin.
  \param    center <boolean> Center about origin.

  \details

    \sa st_linear_extrude_scale for a description on specifying \p h.

    \b Example
    \amu_eval ( function=etriangle_lal ${example_dim} )
*******************************************************************************/
module etriangle_lal
(
  s1,
  a,
  s2,
  h,
  x = 1,
  vr,
  v1r,
  v2r,
  v3r,
  centroid = false,
  incenter = false,
  center = false
)
{
  st_linear_extrude_scale(h=h, center=center)
  triangle_lal
  (
    s1=s1, a=a, s2=s2, x=x,
    vr=vr, v1r=v1r, v2r=v2r, v3r=v3r,
    centroid=centroid, incenter=incenter
  );
}

//! An extruded general triangle specified by a side and two adjacent angles.
/***************************************************************************//**
  \param    a1 <decimal> The adjacent angle 1 in degrees.
  \param    s <decimal> The side length adjacent to the angles.
  \param    a2 <decimal> The adjacent angle 2 in degrees.

  \param    h <vector|decimal> A vector of decimals or a single decimal to
            specify simple extrusion height.

  \param    x <decimal> The side to draw on the positive x-axis (\p x=1 for \p s).

  \param    vr <decimal> The default vertex rounding radius.
  \param    v1r <decimal> Vertex 1 rounding radius.
  \param    v2r <decimal> Vertex 2 rounding radius.
  \param    v3r <decimal> Vertex 3 rounding radius.

  \param    centroid <boolean> Center centroid at origin.
  \param    incenter <boolean> Center incenter at origin.
  \param    center <boolean> Center about origin.

  \details

    \sa st_linear_extrude_scale for a description on specifying \p h.

    \b Example
    \amu_eval ( function=etriangle_ala ${example_dim} )
*******************************************************************************/
module etriangle_ala
(
  a1,
  s,
  a2,
  h,
  x = 1,
  vr,
  v1r,
  v2r,
  v3r,
  centroid = false,
  incenter = false,
  center = false
)
{
  st_linear_extrude_scale(h=h, center=center)
  triangle_ala
  (
    a1=a1, s=s, a2=a2, x=x,
    vr=vr, v1r=v1r, v2r=v2r, v3r=v3r,
    centroid=centroid, incenter=incenter
  );
}

//! An extruded general triangle specified by a side, one adjacent angle and the opposite angle.
/***************************************************************************//**
  \param    a1 <decimal> The opposite angle 1 in degrees.
  \param    a2 <decimal> The adjacent angle 2 in degrees.
  \param    s <decimal> The side length.

  \param    h <vector|decimal> A vector of decimals or a single decimal to
            specify simple extrusion height.

  \param    x <decimal> The side to draw on the positive x-axis (\p x=1 for \p s).

  \param    vr <decimal> The default vertex rounding radius.
  \param    v1r <decimal> Vertex 1 rounding radius.
  \param    v2r <decimal> Vertex 2 rounding radius.
  \param    v3r <decimal> Vertex 3 rounding radius.

  \param    centroid <boolean> Center centroid at origin.
  \param    incenter <boolean> Center incenter at origin.
  \param    center <boolean> Center about origin.

  \details

    \sa st_linear_extrude_scale for a description on specifying \p h.

    \b Example
    \amu_eval ( function=etriangle_aal ${example_dim} )
*******************************************************************************/
module etriangle_aal
(
  a1,
  a2,
  s,
  h,
  x = 1,
  vr,
  v1r,
  v2r,
  v3r,
  centroid = false,
  incenter = false,
  center = false
)
{
  st_linear_extrude_scale(h=h, center=center)
  triangle_aal
  (
    a1=a1, a2=a2, s=s, x=x,
    vr=vr, v1r=v1r, v2r=v2r, v3r=v3r,
    centroid=centroid, incenter=incenter
  );
}

//! An extruded right-angled triangle specified by its opposite and adjacent side lengths.
/***************************************************************************//**
  \param    x <decimal> The length of the side along the x-axis.
  \param    y <decimal> The length of the side along the y-axis.

  \param    h <vector|decimal> A vector of decimals or a single decimal to
            specify simple extrusion height.

  \param    vr <decimal> The default vertex rounding radius.
  \param    v1r <decimal> Vertex 1 rounding radius.
  \param    v2r <decimal> Vertex 2 rounding radius.
  \param    v3r <decimal> Vertex 3 rounding radius.

  \param    centroid <boolean> Center centroid at origin.
  \param    incenter <boolean> Center incenter at origin.
  \param    center <boolean> Center about origin.

  \details

    \sa st_linear_extrude_scale for a description on specifying \p h.

    \b Example
    \amu_eval ( function=etriangle_ll ${example_dim} )
*******************************************************************************/
module etriangle_ll
(
  x,
  y,
  h,
  vr,
  v1r,
  v2r,
  v3r,
  centroid = false,
  incenter = false,
  center = false
)
{
  st_linear_extrude_scale(h=h, center=center)
  triangle_ll
  (
    x=x, y=y,
    vr=vr, v1r=v1r, v2r=v2r, v3r=v3r,
    centroid=centroid, incenter=incenter
  );
}

//! An extruded right-angled triangle specified by a side length and an angle.
/***************************************************************************//**
  \param    x <decimal> The length of the side along the x-axis.
  \param    y <decimal> The length of the side along the y-axis.
  \param    aa <decimal> The adjacent angle in degrees.
  \param    oa <decimal> The opposite angle in degrees.

  \param    h <vector|decimal> A vector of decimals or a single decimal to
            specify simple extrusion height.

  \param    vr <decimal> The default vertex rounding radius.
  \param    v1r <decimal> Vertex 1 rounding radius.
  \param    v2r <decimal> Vertex 2 rounding radius.
  \param    v3r <decimal> Vertex 3 rounding radius.

  \param    centroid <boolean> Center centroid at origin.
  \param    incenter <boolean> Center incenter at origin.
  \param    center <boolean> Center about origin.

  \details

    \sa st_linear_extrude_scale for a description on specifying \p h.

    \b Example
    \amu_eval ( function=etriangle_la ${example_dim} )

  \note     When both \p x and \p y are given, both triangles are rendered.
  \note     When both \p aa and \p oa are given, \p aa is used.
*******************************************************************************/
module etriangle_la
(
  x,
  y,
  aa,
  oa,
  h,
  vr,
  v1r,
  v2r,
  v3r,
  centroid = false,
  incenter = false,
  center = false
)
{
  st_linear_extrude_scale(h=h, center=center)
  triangle_la
  (
    x=x, y=y, aa=aa, oa=oa,
    vr=vr, v1r=v1r, v2r=v2r, v3r=v3r,
    centroid=centroid, incenter=incenter
  );
}

//! An extruded n-sided equiangular/equilateral regular polygon.
/***************************************************************************//**
  \param    n <decimal> The number of sides.
  \param    r <decimal> The ngon vertex radius.

  \param    h <vector|decimal> A vector of decimals or a single decimal to
            specify simple extrusion height.

  \param    vr <decimal> The vertex rounding radius.

  \param    center <boolean> Center about origin.

  \details

    \sa st_linear_extrude_scale for a description on specifying \p h.

    \b Example
    \amu_eval ( function=engon ${example_dim} )

    See [Wikipedia](https://en.wikipedia.org/wiki/Regular_polygon)
    for more information.
*******************************************************************************/
module engon
(
  n,
  r,
  h,
  vr,
  center = false
)
{
  st_linear_extrude_scale(h=h, center=center)
  ngon(n=n, r=r, vr=vr);
}

//! An extruded ellipse.
/***************************************************************************//**
  \param    size <vector|decimal> A vector [rx, ry] of decimals
            or a single decimal for (rx=ry).

  \param    h <vector|decimal> A vector of decimals or a single decimal to
            specify simple extrusion height.

  \param    center <boolean> Center about origin.

  \details

    \sa st_linear_extrude_scale for a description on specifying \p h.

    \b Example
    \amu_eval ( function=eellipse ${example_dim} )
*******************************************************************************/
module eellipse
(
  size,
  h,
  center = false
)
{
  st_linear_extrude_scale(h=h, center=center)
  ellipse(size=size);
}

//! An extruded ellipse with a removed elliptical core.
/***************************************************************************//**
  \param    size <vector|decimal> A vector [rx, ry] of decimals
            or a single decimal for (rx=ry).
  \param    core <vector|decimal> A vector [rx, ry] of decimals
            or a single decimal for (rx=ry).

  \param    h <vector|decimal> A vector of decimals or a single decimal to
            specify simple extrusion height.

  \param    t <vector|decimal> A vector [x, y] of decimals
            or a single decimal for (x=y).

  \param    co <vector> Core offset. A vector [x, y] of decimals.
  \param    cr <decimal> Core z-rotation.

  \param    center <boolean> Center about origin.

  \details

    \sa st_linear_extrude_scale for a description on specifying \p h.

    Thickness \p t
    \li <tt>core = size - t</tt>; when \p t and \p size are given.
    \li <tt>size = core + t</tt>; when \p t and \p core are given.

    \b Example
    \amu_eval ( function=eellipse_c ${example_dim} )
*******************************************************************************/
module eellipse_c
(
  size,
  core,
  h,
  t,
  co,
  cr = 0,
  center = false
)
{
  st_linear_extrude_scale(h=h, center=center)
  ellipse_c(size=size, core=core, t=t, co=co, cr=cr);
}

//! An extruded ellipse sector.
/***************************************************************************//**
  \param    size <vector|decimal> A vector [rx, ry] of decimals
            or a single decimal for (rx=ry).

  \param    h <vector|decimal> A vector of decimals or a single decimal to
            specify simple extrusion height.

  \param    a1 <decimal> The start angle in degrees.
  \param    a2 <decimal> The stop angle in degrees.

  \param    center <boolean> Center about origin.

  \details

    \sa st_linear_extrude_scale for a description on specifying \p h.

    \b Example
    \amu_eval ( function=eellipse_s ${example_dim} )
*******************************************************************************/
module eellipse_s
(
  size,
  h,
  a1 = 0,
  a2 = 0,
  center = false
)
{
  st_linear_extrude_scale(h=h, center=center)
  ellipse_s(size=size, a1=a1, a2=a2);
}

//! An extruded sector of an ellipse with a removed elliptical core.
/***************************************************************************//**
  \param    size <vector|decimal> A vector [rx, ry] of decimals
            or a single decimal for (rx=ry).
  \param    core <vector|decimal> A vector [rx, ry] of decimals
            or a single decimal for (rx=ry).

  \param    h <vector|decimal> A vector of decimals or a single decimal to
            specify simple extrusion height.

  \param    t <vector|decimal> A vector [x, y] of decimals
            or a single decimal for (x=y).

  \param    a1 <decimal> The start angle in degrees.
  \param    a2 <decimal> The stop angle in degrees.

  \param    co <vector> Core offset. A vector [x, y] of decimals.
  \param    cr <decimal> Core z-rotation.

  \param    center <boolean> Center about origin.

  \details

    \sa st_linear_extrude_scale for a description on specifying \p h.

    Thickness \p t
    \li <tt>core = size - t</tt>; when \p t and \p size are given.
    \li <tt>size = core + t</tt>; when \p t and \p core are given.

    \b Example
    \amu_eval ( function=eellipse_cs ${example_dim} )
*******************************************************************************/
module eellipse_cs
(
  size,
  core,
  h,
  t,
  a1 = 0,
  a2 = 0,
  co,
  cr = 0,
  center = false
)
{
  st_linear_extrude_scale(h=h, center=center)
  ellipse_cs(a1=a1, a2=a2, size=size, core=core, t=t, co=co, cr=cr);
}

//! An extruded two dimensional star.
/***************************************************************************//**
  \param    size <vector|decimal> A vector [l, w] of decimals
            or a single decimal for (size=l=2*w).

  \param    h <vector|decimal> A vector of decimals or a single decimal to
            specify simple extrusion height.

  \param    n <decimal> The number of points.

  \param    vr <vector|decimal> The vertex rounding radius. A vector
            [v1r, v2r, v3r] of decimals or a single decimal for (v1r=v2r=v3r).

  \param    center <boolean> Center about origin.

  \details

    \sa st_linear_extrude_scale for a description on specifying \p h.

    \b Example
    \amu_eval ( function=estar2d ${example_dim} )
*******************************************************************************/
module estar2d
(
  size,
  h,
  n = 5,
  vr,
  center = false
)
{
  st_linear_extrude_scale(h=h, center=center)
  star2d(size=size, n=n, vr=vr);
}

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE dim;
  BEGIN_OPENSCAD;
    include <shapes2de.scad>;

    shape = "eellipse_cs";
    $fn = 72;

    if (shape == "erectangle")
      erectangle( size=[25,40], vr=5, h=20, center=true );
    else if (shape == "erectangle_c")
      erectangle_c(size=[40,20], t=[10,1], co=[0,-6], cr=10, vr=5, h=30, center=true);
    else if (shape == "erhombus")
      erhombus( size=[40,25], h=10, vr=[3,0,3,9], center=true );
    else if (shape == "etriangle_ppp")
      etriangle_ppp( v1=[0,0], v2=[5,25], v3=[40,5], h=20, vr=2, centroid=true, center=true );
    else if (shape == "etriangle_lll")
      etriangle_lll( s1=30, s2=40, s3=50, h=20, vr=2, centroid=true, center=true );
    else if (shape == "etriangle_vl_c")
      etriangle_vl_c(vs=50, vc=30, h=15, co=[0,-10], cr=180, vr=[2,2,8], centroid=true, center=true);
    else if (shape == "etriangle_lal")
      etriangle_lal( s1=50, a=60, s2=30, h=20, vr=2, centroid=true, center=true );
    else if (shape == "etriangle_ala")
      etriangle_ala( a1=30, s=50, a2=60, h=20, vr=2, centroid=true, center=true );
    else if (shape == "etriangle_aal")
      etriangle_aal( a1=60, a2=30, s=40, h=20, vr=2, centroid=true, center=true );
    else if (shape == "etriangle_ll")
      etriangle_ll( x=30, y=40, h=20, vr=2, centroid=true, center=true );
    else if (shape == "etriangle_la")
      etriangle_la( x=40, aa=30, h=20, vr=2, centroid=true, center=true );
    else if (shape == "engon")
      engon( n=6, r=25, h=20, vr=6, center=true );
    else if (shape == "eellipse")
      eellipse( size=[25, 40], h=20, center=true );
    else if (shape == "eellipse_c")
      eellipse_c( size=[25,40], core=[16,10], co=[0,10], cr=45, h=20, center=true );
    else if (shape == "eellipse_s")
      eellipse_s( size=[25,40], h=20, a1=90, a2=180, center=true );
    else if (shape == "eellipse_cs")
      eellipse_cs( size=[25,40], t=[10,5], a1=90, a2=180, co=[10,0], cr=45, h=20, center=true );
    else if (shape == "estar2d")
      estar2d( size=[40, 15], h=15, n=5, vr=2, center=true );
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {config_base,config_png}.mfs;

    views     name "views" views "diag";
    defines   name "shapes" define "shape"
              strings "
                erectangle
                erectangle_c
                erhombus
                etriangle_ppp
                etriangle_lll
                etriangle_vl_c
                etriangle_lal
                etriangle_ala
                etriangle_aal
                etriangle_ll
                etriangle_la
                engon
                eellipse
                eellipse_c
                eellipse_s
                eellipse_cs
                estar2d
              ";
    variables add_opts_combine "views shapes";
    variables add_opts "--viewall --autocenter";

    include --path "${INCLUDE_PATH}" script_std.mfs;
  END_MFSCRIPT;
END_SCOPE;

BEGIN_SCOPE manifest;
  BEGIN_OPENSCAD;
    include <shapes2de.scad>;

    $fn = 72;

    st_cartesian_copy( grid=5, incr=60, center=true )
    {
      erectangle( size=[25,40], vr=5, h=20, center=true );
      erectangle_c(size=[40,20], t=[10,1], co=[0,-6], cr=10, vr=5, h=30, center=true);
      erhombus( size=[40,25], h=10, vr=[3,0,3,9], center=true );
      etriangle_ppp( v1=[0,0], v2=[5,25], v3=[40,5], h=20, vr=2, centroid=true, center=true );
      etriangle_lll( s1=30, s2=40, s3=50, h=20, vr=2, centroid=true, center=true );
      etriangle_vl_c(vs=50, vc=30, h=15, co=[0,-10], cr=180, vr=[2,2,8], centroid=true, center=true);
      etriangle_lal( s1=50, a=60, s2=30, h=20, vr=2, centroid=true, center=true );
      etriangle_ala( a1=30, s=50, a2=60, h=20, vr=2, centroid=true, center=true );
      etriangle_aal( a1=60, a2=30, s=40, h=20, vr=2, centroid=true, center=true );
      etriangle_ll( x=30, y=40, h=20, vr=2, centroid=true, center=true );
      etriangle_la( x=40, aa=30, h=20, vr=2, centroid=true, center=true );
      engon( n=6, r=25, h=20, vr=6, center=true );
      eellipse( size=[25, 40], h=20, center=true );
      eellipse_c( size=[25,40], core=[16,10], co=[0,10], cr=45, h=20, center=true );
      eellipse_s( size=[25,40], h=20, a1=90, a2=180, center=true );
      eellipse_cs( size=[25,40], t=[10,5], a1=90, a2=180, co=[10,0], cr=45, h=20, center=true );
      estar2d( size=[40, 15], h=15, n=5, vr=2, center=true );
    }
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {config_base,config_stl}.mfs;
    include --path "${INCLUDE_PATH}" script_std.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
