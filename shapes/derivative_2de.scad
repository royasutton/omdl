//! Common 2D derivative shapes linearly extruded.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2015-2018

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

    \amu_pathid parent  (++path)
    \amu_pathid group   (++path ++stem)

  \ingroup \amu_eval(${parent} ${group})
*******************************************************************************/

include <derivative_2d.scad>;

//----------------------------------------------------------------------------//
// group.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \addtogroup \amu_eval(${parent})

    \amu_define caption (2d Extrusions)

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
*******************************************************************************/

/***************************************************************************//**
  \addtogroup \amu_eval(${parent})
  @{

  \defgroup \amu_eval(${group}) 2d Extrusions
  \brief    Common 2D derivative shapes linearly extruded.
  @{
*******************************************************************************/

//----------------------------------------------------------------------------//
// openscad-amu macros
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_scope  mfs   (index=1)
  \amu_source stem  (++stem)
  \amu_define scope (dim)
  \amu_define size  (qvga)
  \amu_define view  (diag)
  \amu_define image (${stem}_${scope}_${size}_${view}_${function})

  \amu_define example_dim
  (
    \image html  ${image}.png "${function}"
    \image latex ${image}.eps "${function}" width=2.5in
    \dontinclude ${mfs}.scad \skipline ${function}(
  )
*******************************************************************************/

//----------------------------------------------------------------------------//

//! An extruded rectangle with edge, fillet, and/or chamfer corners.
/***************************************************************************//**
  \param    size <decimal-list-2|decimal> A list [x, y] of decimals
            or a single decimal for (x=y).

  \param    h <decimal-list-3:9|decimal> A list of decimals or a single
            decimal to specify simple extrusion height.

  \param    vr <decimal-list-4|decimal> The corner rounding radius.
            A list [v1r, v2r, v3r, v4r] of decimals or a single decimal
            for (v1r=v2r=v3r=v4r). Unspecified corners are not rounded.

  \param    vrm <integer> The corner radius mode.
            A 4-bit encoded integer that indicates each corner finish.
            Use bit value \b 0 for \em fillet and \b 1 for \em chamfer.

  \param    center <boolean> Center about origin.

  \details

    \sa linear_extrude_uls for a description on specifying \p h.

    \b Example
    \amu_eval ( function=erectangle ${example_dim} )
*******************************************************************************/
module erectangle
(
  size,
  h,
  vr,
  vrm = 0,
  center = false
)
{
  linear_extrude_uls(h=h, center=center)
  rectangle(size=size, vr=vr, vrm=vrm, center=center);
}

//! An extruded rectangle with a removed rectangular core.
/***************************************************************************//**
  \param    size <decimal-list-2|decimal> A list [x, y] of decimals
            or a single decimal for (x=y).
  \param    core <decimal-list-2|decimal> A list [x, y] of decimals
            or a single decimal for (x=y).

  \param    h <decimal-list-3:9|decimal> A list of decimals or a single
            decimal to specify simple extrusion height.

  \param    t <decimal-list-2|decimal> A list [x, y] of decimals
            or a single decimal for (x=y).

  \param    co <decimal-list-2> Core offset. A list [x, y] of decimals.
  \param    cr <decimal> Core z-rotation.

  \param    vr <decimal-list-4|decimal> The default corner rounding radius.
            A list [v1r, v2r, v3r, v4r] of decimals or a single decimal
            for (v1r=v2r=v3r=v4r). Unspecified corners are not rounded.
  \param    vr1 <decimal-list-4|decimal> The outer corner rounding radius.
  \param    vr2 <decimal-list-4|decimal> The core corner rounding radius.

  \param    vrm <integer> The default corner radius mode.
            A 4-bit encoded integer that indicates each corner finish.
            Use bit value \b 0 for \em fillet and \b 1 for \em chamfer.
  \param    vrm1 <integer> The outer corner radius mode.
  \param    vrm2 <integer> The core corner radius mode.

  \param    center <boolean> Center about origin.

  \details

    \sa linear_extrude_uls for a description on specifying \p h.

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
  vrm = 0,
  vrm1,
  vrm2,
  center = false
)
{
  linear_extrude_uls(h=h, center=center)
  rectangle_c
  (
    size=size, core=core, t=t,
    co=co, cr=cr,
    vr=vr, vr1=vr1, vr2=vr2,
    vrm=vrm, vrm1=vrm1, vrm2=vrm2,
    center=center
  );
}

//! An extruded rhombus.
/***************************************************************************//**
  \param    size <decimal-list-2|decimal> A list [w, h] of decimals
            or a single decimal for (w=h).

  \param    h <decimal-list-3:9|decimal> A list of decimals or a single
            decimal to specify simple extrusion height.

  \param    vr <decimal-list-4|decimal> The corner rounding radius.
            A list [v1r, v2r, v3r, v4r] of decimals or a single decimal
            for (v1r=v2r=v3r=v4r). Unspecified corners are not rounded.

  \param    center <boolean> Center about origin.

  \details

    \sa linear_extrude_uls for a description on specifying \p h.

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
  linear_extrude_uls(h=h, center=center)
  rhombus(size=size, vr=vr, center=center);
}

//! An extruded general triangle specified by three vertices.
/***************************************************************************//**
  \param    v1 <point-2d> A point [x, y] for vertex 1.
  \param    v2 <point-2d> A point [x, y] for vertex 2.
  \param    v3 <point-2d> A point [x, y] for vertex 3.

  \param    h <decimal-list-3:9|decimal> A list of decimals or a single
            decimal to specify simple extrusion height.

  \param    vr <decimal> The default vertex rounding radius.
  \param    v1r <decimal> Vertex 1 rounding radius.
  \param    v2r <decimal> Vertex 2 rounding radius.
  \param    v3r <decimal> Vertex 3 rounding radius.

  \param    centroid <boolean> Center centroid at origin.
  \param    incenter <boolean> Center incenter at origin.
  \param    center <boolean> Center about origin.

  \details

    \sa linear_extrude_uls for a description on specifying \p h.

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
  linear_extrude_uls(h=h, center=center)
  triangle_ppp
  (
    v1=v1, v2=v2, v3=v3,
    vr=vr, v1r=v1r, v2r=v2r, v3r=v3r,
    centroid=centroid, incenter=incenter
  );
}

//! An extruded general triangle specified by a list of its three vertices.
/***************************************************************************//**
  \param    v <point-2d-list-3> A list [v1, v2, v3] of points [x, y].

  \param    h <decimal-list-3:9|decimal> A list of decimals or a single
            decimal to specify simple extrusion height.

  \param    vr <decimal-list-3|decimal> The vertex rounding radius. A
            list [v1r, v2r, v3r] of decimals or a single decimal for
            (v1r=v2r=v3r).

  \param    centroid <boolean> Center centroid at origin.
  \param    incenter <boolean> Center incenter at origin.
  \param    center <boolean> Center about origin.

  \details

    \sa linear_extrude_uls for a description on specifying \p h.

    \b Example
    \code{.C}
    t = triangle_sss2lp( 30, 40, 50 );
    r = [2, 4, 6];
    etriangle_lp( v=t, h=5, vr=r );
    \endcode
*******************************************************************************/
module etriangle_lp
(
  v,
  h,
  vr,
  centroid = false,
  incenter = false,
  center = false
)
{
  linear_extrude_uls(h=h, center=center)
  triangle_lp(v=v, vr=vr, centroid=centroid, incenter=incenter);
}

//! An extruded general triangle specified by its three side lengths.
/***************************************************************************//**
  \param    s1 <decimal> The length of the side 1 (along the x-axis).
  \param    s2 <decimal> The length of the side 2.
  \param    s3 <decimal> The length of the side 3.

  \param    h <decimal-list-3:9|decimal> A list of decimals or a single
            decimal to specify simple extrusion height.

  \param    vr <decimal> The default vertex rounding radius.
  \param    v1r <decimal> Vertex 1 rounding radius.
  \param    v2r <decimal> Vertex 2 rounding radius.
  \param    v3r <decimal> Vertex 3 rounding radius.

  \param    centroid <boolean> Center centroid at origin.
  \param    incenter <boolean> Center incenter at origin.
  \param    center <boolean> Center about origin.

  \details

    \sa linear_extrude_uls for a description on specifying \p h.

    \b Example
    \amu_eval ( function=etriangle_sss ${example_dim} )
*******************************************************************************/
module etriangle_sss
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
  linear_extrude_uls(h=h, center=center)
  triangle_sss
  (
    s1=s1, s2=s2, s3=s3,
    vr=vr, v1r=v1r, v2r=v2r, v3r=v3r,
    centroid=centroid, incenter=incenter
  );
}

//! An extruded general triangle specified by a list of its three side lengths.
/***************************************************************************//**
  \param    v <decimal-list-3> A list [s1, s2, s3] of decimals.

  \param    h <decimal-list-3:9|decimal> A list of decimals or a single
            decimal to specify simple extrusion height.

  \param    vr <decimal-list-3|decimal> The vertex rounding radius. A
            list [v1r, v2r, v3r] of decimals or a single decimal for
            (v1r=v2r=v3r).

  \param    centroid <boolean> Center centroid at origin.
  \param    incenter <boolean> Center incenter at origin.
  \param    center <boolean> Center about origin.

  \details

    \sa linear_extrude_uls for a description on specifying \p h.

    \b Example
    \code{.C}
    t = triangle_sss2lp( 3, 4, 5 );
    s = triangle_lp2ls( t );
    etriangle_ls( v=s, h=5, vr=2 );
    \endcode
*******************************************************************************/
module etriangle_ls
(
  v,
  h,
  vr,
  centroid = false,
  incenter = false,
  center = false
)
{
  linear_extrude_uls(h=h, center=center)
  triangle_ls(v=v, vr=vr, centroid=centroid, incenter=incenter);
}

//! A general triangle specified by its sides with a removed triangular core.
/***************************************************************************//**
  \param    vs <decimal-list-3|decimal> The size. A list [s1, s2, s3] of
            decimals or a single decimal for (s1=s2=s3).
  \param    vc <decimal-list-3|decimal> The core. A list [s1, s2, s3] of
            decimals or a single decimal for (s1=s2=s3).

  \param    h <decimal-list-3:9|decimal> A list of decimals or a single
            decimal to specify simple extrusion height.

  \param    co <decimal-list-2> Core offset. A list [x, y] of decimals.
  \param    cr <decimal> Core z-rotation.

  \param    vr <decimal-list-3|decimal> The default vertex rounding radius.
            A list [v1r, v2r, v3r] of decimals or a single decimal for
            (v1r=v2r=v3r).
  \param    vr1 <decimal-list-3|decimal> The outer vertex rounding radius.
  \param    vr2 <decimal-list-3|decimal> The core vertex rounding radius.

  \param    centroid <boolean> Center centroid at origin.
  \param    incenter <boolean> Center incenter at origin.
  \param    center <boolean> Center about origin.

  \details

    \sa linear_extrude_uls for a description on specifying \p h.

    \b Example
    \amu_eval ( function=etriangle_ls_c ${example_dim} )

  \note The outer and inner triangles centroids are aligned prior to the
        core removal.
*******************************************************************************/
module etriangle_ls_c
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
  linear_extrude_uls(h=h, center=center)
  triangle_ls_c
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

  \param    h <decimal-list-3:9|decimal> A list of decimals or a single
            decimal to specify simple extrusion height.

  \param    x <decimal> The side to draw on the positive x-axis
            (\p x=1 for \p s1).

  \param    vr <decimal> The default vertex rounding radius.
  \param    v1r <decimal> Vertex 1 rounding radius.
  \param    v2r <decimal> Vertex 2 rounding radius.
  \param    v3r <decimal> Vertex 3 rounding radius.

  \param    centroid <boolean> Center centroid at origin.
  \param    incenter <boolean> Center incenter at origin.
  \param    center <boolean> Center about origin.

  \details

    \sa linear_extrude_uls for a description on specifying \p h.

    \b Example
    \amu_eval ( function=etriangle_sas ${example_dim} )
*******************************************************************************/
module etriangle_sas
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
  linear_extrude_uls(h=h, center=center)
  triangle_sas
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

  \param    h <decimal-list-3:9|decimal> A list of decimals or a single
            decimal to specify simple extrusion height.

  \param    x <decimal> The side to draw on the positive x-axis
            (\p x=1 for \p s).

  \param    vr <decimal> The default vertex rounding radius.
  \param    v1r <decimal> Vertex 1 rounding radius.
  \param    v2r <decimal> Vertex 2 rounding radius.
  \param    v3r <decimal> Vertex 3 rounding radius.

  \param    centroid <boolean> Center centroid at origin.
  \param    incenter <boolean> Center incenter at origin.
  \param    center <boolean> Center about origin.

  \details

    \sa linear_extrude_uls for a description on specifying \p h.

    \b Example
    \amu_eval ( function=etriangle_asa ${example_dim} )
*******************************************************************************/
module etriangle_asa
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
  linear_extrude_uls(h=h, center=center)
  triangle_asa
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

  \param    h <decimal-list-3:9|decimal> A list of decimals or a single
            decimal to specify simple extrusion height.

  \param    x <decimal> The side to draw on the positive x-axis
            (\p x=1 for \p s).

  \param    vr <decimal> The default vertex rounding radius.
  \param    v1r <decimal> Vertex 1 rounding radius.
  \param    v2r <decimal> Vertex 2 rounding radius.
  \param    v3r <decimal> Vertex 3 rounding radius.

  \param    centroid <boolean> Center centroid at origin.
  \param    incenter <boolean> Center incenter at origin.
  \param    center <boolean> Center about origin.

  \details

    \sa linear_extrude_uls for a description on specifying \p h.

    \b Example
    \amu_eval ( function=etriangle_aas ${example_dim} )
*******************************************************************************/
module etriangle_aas
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
  linear_extrude_uls(h=h, center=center)
  triangle_aas
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

  \param    h <decimal-list-3:9|decimal> A list of decimals or a single
            decimal to specify simple extrusion height.

  \param    vr <decimal> The default vertex rounding radius.
  \param    v1r <decimal> Vertex 1 rounding radius.
  \param    v2r <decimal> Vertex 2 rounding radius.
  \param    v3r <decimal> Vertex 3 rounding radius.

  \param    centroid <boolean> Center centroid at origin.
  \param    incenter <boolean> Center incenter at origin.
  \param    center <boolean> Center about origin.

  \details

    \sa linear_extrude_uls for a description on specifying \p h.

    \b Example
    \amu_eval ( function=etriangle_ss ${example_dim} )
*******************************************************************************/
module etriangle_ss
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
  linear_extrude_uls(h=h, center=center)
  triangle_ss
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

  \param    h <decimal-list-3:9|decimal> A list of decimals or a single
            decimal to specify simple extrusion height.

  \param    vr <decimal> The default vertex rounding radius.
  \param    v1r <decimal> Vertex 1 rounding radius.
  \param    v2r <decimal> Vertex 2 rounding radius.
  \param    v3r <decimal> Vertex 3 rounding radius.

  \param    centroid <boolean> Center centroid at origin.
  \param    incenter <boolean> Center incenter at origin.
  \param    center <boolean> Center about origin.

  \details

    \sa linear_extrude_uls for a description on specifying \p h.

    \b Example
    \amu_eval ( function=etriangle_sa ${example_dim} )

  \note     When both \p x and \p y are given, both triangles are rendered.
  \note     When both \p aa and \p oa are given, \p aa is used.
*******************************************************************************/
module etriangle_sa
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
  linear_extrude_uls(h=h, center=center)
  triangle_sa
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

  \param    h <decimal-list-3:9|decimal> A list of decimals or a single
            decimal to specify simple extrusion height.

  \param    vr <decimal> The vertex rounding radius.

  \param    center <boolean> Center about origin.

  \details

    \sa linear_extrude_uls for a description on specifying \p h.

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
  linear_extrude_uls(h=h, center=center)
  ngon(n=n, r=r, vr=vr);
}

//! An extruded ellipse.
/***************************************************************************//**
  \param    size <decimal-list-2|decimal> A list [rx, ry] of decimals
            or a single decimal for (rx=ry).

  \param    h <decimal-list-3:9|decimal> A list of decimals or a single
            decimal to specify simple extrusion height.

  \param    center <boolean> Center about origin.

  \details

    \sa linear_extrude_uls for a description on specifying \p h.

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
  linear_extrude_uls(h=h, center=center)
  ellipse(size=size);
}

//! An extruded ellipse with a removed elliptical core.
/***************************************************************************//**
  \param    size <decimal-list-2|decimal> A list [rx, ry] of decimals
            or a single decimal for (rx=ry).
  \param    core <decimal-list-2|decimal> A list [rx, ry] of decimals
            or a single decimal for (rx=ry).

  \param    h <decimal-list-3:9|decimal> A list of decimals or a single
            decimal to specify simple extrusion height.

  \param    t <decimal-list-2|decimal> A list [x, y] of decimals
            or a single decimal for (x=y).

  \param    co <decimal-list-2> Core offset. A list [x, y] of decimals.
  \param    cr <decimal> Core z-rotation.

  \param    center <boolean> Center about origin.

  \details

    \sa linear_extrude_uls for a description on specifying \p h.

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
  linear_extrude_uls(h=h, center=center)
  ellipse_c(size=size, core=core, t=t, co=co, cr=cr);
}

//! An extruded ellipse sector.
/***************************************************************************//**
  \param    size <decimal-list-2|decimal> A list [rx, ry] of decimals
            or a single decimal for (rx=ry).

  \param    h <decimal-list-3:9|decimal> A list of decimals or a single
            decimal to specify simple extrusion height.

  \param    a1 <decimal> The start angle in degrees.
  \param    a2 <decimal> The stop angle in degrees.

  \param    center <boolean> Center about origin.

  \details

    \sa linear_extrude_uls for a description on specifying \p h.

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
  linear_extrude_uls(h=h, center=center)
  ellipse_s(size=size, a1=a1, a2=a2);
}

//! An extruded sector of an ellipse with a removed elliptical core.
/***************************************************************************//**
  \param    size <decimal-list-2|decimal> A list [rx, ry] of decimals
            or a single decimal for (rx=ry).
  \param    core <decimal-list-2|decimal> A list [rx, ry] of decimals
            or a single decimal for (rx=ry).

  \param    h <decimal-list-3:9|decimal> A list of decimals or a single
            decimal to specify simple extrusion height.

  \param    t <decimal-list-2|decimal> A list [x, y] of decimals
            or a single decimal for (x=y).

  \param    a1 <decimal> The start angle in degrees.
  \param    a2 <decimal> The stop angle in degrees.

  \param    co <decimal-list-2> Core offset. A list [x, y] of decimals.
  \param    cr <decimal> Core z-rotation.

  \param    center <boolean> Center about origin.

  \details

    \sa linear_extrude_uls for a description on specifying \p h.

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
  linear_extrude_uls(h=h, center=center)
  ellipse_cs(a1=a1, a2=a2, size=size, core=core, t=t, co=co, cr=cr);
}

//! An extruded two-dimensional star.
/***************************************************************************//**
  \param    size <decimal-list-2|decimal> A list [l, w] of decimals
            or a single decimal for (size=l=2*w).

  \param    h <decimal-list-3:9|decimal> A list of decimals or a single
            decimal to specify simple extrusion height.

  \param    n <decimal> The number of points.

  \param    vr <decimal-list-3|decimal> The vertex rounding radius.
            A list [v1r, v2r, v3r] of decimals or a single decimal for
            (v1r=v2r=v3r).

  \param    center <boolean> Center about origin.

  \details

    \sa linear_extrude_uls for a description on specifying \p h.

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
  linear_extrude_uls(h=h, center=center)
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
    include <shapes/derivative_2de.scad>;

    shape = "eellipse_cs";
    $fn = 72;

    if (shape == "erectangle")
      erectangle( size=[25,40], vr=5, vrm=3, h=20, center=true );
    else if (shape == "erectangle_c")
      erectangle_c( size=[40,20], t=[10,1], co=[0,-6], cr=10, vr=5, vrm1=12, h=30, center=true );
    else if (shape == "erhombus")
      erhombus( size=[40,25], h=10, vr=[3,0,3,9], center=true );
    else if (shape == "etriangle_ppp")
      etriangle_ppp( v1=[0,0], v2=[5,25], v3=[40,5], h=20, vr=2, centroid=true, center=true );
    else if (shape == "etriangle_sss")
      etriangle_sss( s1=30, s2=40, s3=50, h=20, vr=2, centroid=true, center=true );
    else if (shape == "etriangle_ls_c")
      etriangle_ls_c(vs=50, vc=30, h=15, co=[0,-10], cr=180, vr=[2,2,8], centroid=true, center=true);
    else if (shape == "etriangle_sas")
      etriangle_sas( s1=50, a=60, s2=30, h=20, vr=2, centroid=true, center=true );
    else if (shape == "etriangle_asa")
      etriangle_asa( a1=30, s=50, a2=60, h=20, vr=2, centroid=true, center=true );
    else if (shape == "etriangle_aas")
      etriangle_aas( a1=60, a2=30, s=40, h=20, vr=2, centroid=true, center=true );
    else if (shape == "etriangle_ss")
      etriangle_ss( x=30, y=40, h=20, vr=2, centroid=true, center=true );
    else if (shape == "etriangle_sa")
      etriangle_sa( x=40, aa=30, h=20, vr=2, centroid=true, center=true );
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
                etriangle_sss
                etriangle_ls_c
                etriangle_sas
                etriangle_asa
                etriangle_aas
                etriangle_ss
                etriangle_sa
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
    include <shapes/derivative_2de.scad>;

    $fn = 72;

    grid_repeat( g=5, i=60, center=true )
    {
      erectangle( size=[25,40], vr=5, vrm=3, h=20, center=true );
      erectangle_c( size=[40,20], t=[10,1], co=[0,-6], cr=10, vr=5, vrm1=12, h=30, center=true );
      erhombus( size=[40,25], h=10, vr=[3,0,3,9], center=true );
      etriangle_ppp( v1=[0,0], v2=[5,25], v3=[40,5], h=20, vr=2, centroid=true, center=true );
      etriangle_sss( s1=30, s2=40, s3=50, h=20, vr=2, centroid=true, center=true );
      etriangle_ls_c( vs=50, vc=30, h=15, co=[0,-10], cr=180, vr=[2,2,8], centroid=true, center=true );
      etriangle_sas( s1=50, a=60, s2=30, h=20, vr=2, centroid=true, center=true );
      etriangle_asa( a1=30, s=50, a2=60, h=20, vr=2, centroid=true, center=true );
      etriangle_aas( a1=60, a2=30, s=40, h=20, vr=2, centroid=true, center=true );
      etriangle_ss( x=30, y=40, h=20, vr=2, centroid=true, center=true );
      etriangle_sa( x=40, aa=30, h=20, vr=2, centroid=true, center=true );
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
