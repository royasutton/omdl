//! Two-dimensional basic shapes.
/***************************************************************************//**
  \file   shapes2d.scad
  \author Roy Allen Sutton
  \date   2015-2016

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

  \ingroup shapes shapes_2d
*******************************************************************************/

include <transform.scad>;

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \addtogroup shapes
  @{

  \defgroup shapes_2d 2D Shapes
  \brief    Two dimensional geometric shapes.
  @{
*******************************************************************************/
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
// amu macros
//----------------------------------------------------------------------------//
/***************************************************************************//**
  \amu_define scope (shapes2d_dim)
  \amu_define tuple (qvga_top)

  \amu_define example_dim
  (
    \image html  ${scope}_${tuple}_${function}.png "${function}"
    \image latex ${scope}_${tuple}_${function}.eps "${function}" width=2.5in
    \dontinclude ${scope}.scad \skipline ${function}(
  )
*******************************************************************************/
//----------------------------------------------------------------------------//

//! A rectangle.
/***************************************************************************//**
  \param    size <vector|decimal> A vector [x, y] of decimals
            or a single decimal for (x=y).

  \param    vr <vector|decimal> The corner rounding radius.
            A vector [v1r, v2r, v3r, v4r] of decimals or a single decimal
            for (v1r=v2r=v3r=v4r). Unspecified corners are not rounded.

  \param    center <boolean> Center about origin.

  \details

    \b Example
    \amu_eval ( function=rectangle ${example_dim} )
*******************************************************************************/
module rectangle
(
  size,
  vr,
  center = false
)
{
  rx = (len(size) >= 1) ? size[0] : size;
  ry = (len(size) >= 2) ? size[1] : rx;

  translate(center==true ? [-rx/2, -ry/2] : [0,0])
  {
    if ( vr == undef )                  // no rounding
    {
      square([rx, ry]);
    }
    else if ( len(vr) == undef )        // equal rounding
    {
      for (y = [ [0, 1], [1, -1] ],
           x = [ [0, 1], [1, -1] ])
      {
        translate([rx*x[0] + vr*x[1], ry*y[0] + vr*y[1]])
        circle (r=vr);
      }

      translate([0, vr])
      square([rx, ry] - [0, vr*2]);

      translate([vr, 0])
      square([rx, ry] - [vr*2, 0]);
    }
    else                                // individual rounding
    {
      crv = [ (len(vr) >= 1) ? vr[0] : 0,
              (len(vr) >= 2) ? vr[1] : 0,
              (len(vr) >= 3) ? vr[2] : 0,
              (len(vr) >= 4) ? vr[3] : 0 ];

      for ( i =  [ [0, 0,  1, 0,  1],
                   [1, 1, -1, 0,  1],
                   [2, 1, -1, 1, -1],
                   [3, 0,  1, 1, -1] ] )
      {
        if ( crv[i[0]] > 0 )
        {
         translate([rx*i[1] + crv[i[0]] * i[2], ry*i[3] + crv[i[0]] * i[4]])
         circle (r=crv[i[0]]);
        }
      }

      ppv =
      [
        for
        (
          i = [
                [0,  0,  0,  0,  1],
                [0,  0,  1,  0,  0],
                [1,  1, -1,  0,  0],
                [1,  1,  0,  0,  1],
                [2,  1,  0,  1, -1],
                [2,  1, -1,  1,  0],
                [3,  0,  1,  1,  0],
                [3,  0,  0,  1, -1]
              ]
        )
          [rx*i[1] + crv[i[0]] * i[2], ry*i[3] + crv[i[0]] * i[4]]
      ];

      polygon( points=ppv, paths=[ [0,1,2,3,4,5,6,7] ] );
    }
  }
}

//! A rectangle with a removed rectangular core.
/***************************************************************************//**
  \param    size <vector|decimal> A vector [x, y] of decimals
            or a single decimal for (x=y).
  \param    core <vector|decimal> A vector [x, y] of decimals
            or a single decimal for (x=y).

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

    Thickness \p t
    \li <tt>core = size - t</tt>; when \p t and \p size are given.
    \li <tt>size = core + t</tt>; when \p t and \p core are given.

    \b Example
    \amu_eval ( function=rectangle_c ${example_dim} )
*******************************************************************************/
module rectangle_c
(
  size,
  core,
  t,
  co,
  cr = 0,
  vr,
  vr1,
  vr2,
  center = false
)
{
  rx = (len(size) >= 1) ? size[0] : size;
  ry = (len(size) >= 2) ? size[1] : rx;

  od = ((t != undef) && (core != undef)) ? (core + t) : size;
  id = ((t != undef) && (size != undef)) ? (size - t) : core;

  or = (vr1 == undef) ? vr : vr1;
  ir = (vr2 == undef) ? vr : vr2;

  if ( id != undef )
  {
    translate(center==true ? [0,0] : [rx/2, ry/2])
    difference()
    {
      rectangle(size=od, vr=or, center=true);

      translate(co==undef ? [0,0] : co)
      rotate([0, 0, cr])
      rectangle(size=id, vr=ir, center=true);
    }
  }
  else
  {
    rectangle(size=od, vr=or, center=center);
  }
}

//! A rhombus.
/***************************************************************************//**
  \param    size <vector|decimal> A vector [w, h] of decimals
            or a single decimal for (w=h).

  \param    vr <vector|decimal> The corner rounding radius.
            A vector [v1r, v2r, v3r, v4r] of decimals or a single decimal
            for (v1r=v2r=v3r=v4r). Unspecified corners are not rounded.

  \param    center <boolean> Center about origin.

  \details

    \b Example
    \amu_eval ( function=rhombus ${example_dim} )

    See [Wikipedia](https://en.wikipedia.org/wiki/Rhombus)
    for more information.
*******************************************************************************/
module rhombus
(
  size,
  vr,
  center = false
)
{
  rx = (len(size) >= 1) ? size[0]/2 : size/2;
  ry = (len(size) >= 2) ? size[1]/2 : rx;

  translate(center==true ? [0,0] : [rx, ry])
  {
    if ( vr == undef )                    // no rounding
    {
      polygon
      (
        points=[ [rx,0], [0,ry], [-rx,0], [0,-ry] ],
        paths=[ [0,1,2,3] ]
      );
    }
    else                                  // individual rounding
    {
      erc = (len(vr) == undef) ? vr : 0;  // equal rounding

      crv = [ (len(vr) >= 1) ? vr[0] : erc,
              (len(vr) >= 2) ? vr[1] : erc,
              (len(vr) >= 3) ? vr[2] : erc,
              (len(vr) >= 4) ? vr[3] : erc ];

      a1 = angle_pp2pp(v1t=[0,ry], v1i=[rx,0], v2t=[0,-ry], v2i=[rx,0]) / 2;
      a2 = 90 - a1;

      for ( i = [ [0,  1, -1,  0,  0],
                  [1,  0,  0,  1, -1],
                  [2, -1,  1,  0,  0],
                  [3,  0,  0, -1,  1] ] )
      {
        translate
        (
          [ rx*i[1] + crv[i[0]]/sin(a1) * i[2], ry*i[3] + crv[i[0]]/sin(a2) * i[4] ]
        )
        circle (r=crv[i[0]]);
      }

      ppv =
      [
        for
        (
          i = [
                [0,  0,  1, -1,  0, -1],
                [0,  0,  1, -1,  0,  1],
                [1,  1,  0,  1,  1, -1],
                [1,  1,  0, -1,  1, -1],
                [2,  0, -1,  1,  0,  1],
                [2,  0, -1,  1,  0, -1],
                [3,  1,  0, -1, -1,  1],
                [3,  1,  0, +1, -1, +1]
              ]
        )
          ( i[1] == 0 )
          ? [
              rx*i[2] + crv[i[0]] * (1/sin(a1)-sin(a1)) * i[3],
              ry*i[4] + crv[i[0]] * cos(a1) * i[5]
            ]
          : [
              rx*i[2] + crv[i[0]] * cos(a2) * i[3],
              ry*i[4] + crv[i[0]] * (1/sin(a2)-sin(a2)) * i[5]
            ]
      ];

      polygon( points=ppv, paths=[ [0,1,2,3,4,5,6,7] ] );
    }
  }
}

//! A general triangle specified by three vertices.
/***************************************************************************//**
  \param    v1 <vector> A vector [x, y] for vertex 1.
  \param    v2 <vector> A vector [x, y] for vertex 2.
  \param    v3 <vector> A vector [x, y] for vertex 3.

  \param    vr <decimal> The default vertex rounding radius.
  \param    v1r <decimal> Vertex 1 rounding radius.
  \param    v2r <decimal> Vertex 2 rounding radius.
  \param    v3r <decimal> Vertex 3 rounding radius.

  \param    centroid <boolean> Center centroid at origin.
  \param    incenter <boolean> Center incenter at origin.

  \details

    \b Example
    \amu_eval ( function=triangle_ppp ${example_dim} )
*******************************************************************************/
module triangle_ppp
(
  v1,
  v2,
  v3,
  vr,
  v1r,
  v2r,
  v3r,
  centroid = false,
  incenter = false
)
{
  cr1 = (v1r == undef) ? vr : v1r;
  cr2 = (v2r == undef) ? vr : v2r;
  cr3 = (v3r == undef) ? vr : v3r;

  translate
  (
    ( centroid==false ) && ( incenter==true )
      ? -triangle_incenter_ppp( v1=v1, v2=v2, v3=v3 )
      : [0,0]
  )
  translate
  (
    ( centroid==true ) && ( incenter==false )
      ? -triangle_centroid_ppp( v1=v1, v2=v2, v3=v3 )
      : [0,0]
  )
  if ( (cr1==undef) || (cr2==undef) || (cr3==undef) )
  {
    polygon( points=[v1, v2, v3], paths=[[0,1,2]] );
  }
  else
  {
    ic = triangle_incenter_ppp( v1=v1, v2=v2, v3=v3 );

    a1 = angle_pp2pp(v1t=v2, v1i=v1, v2t=ic, v2i=v1);
    a2 = angle_pp2pp(v1t=v3, v1i=v2, v2t=ic, v2i=v2);
    a3 = angle_pp2pp(v1t=v1, v1i=v3, v2t=ic, v2i=v3);

    c1 = v1 + cr1/sin(a1) * normalized_pp(vt=ic, vi=v1);
    c2 = v2 + cr2/sin(a2) * normalized_pp(vt=ic, vi=v2);
    c3 = v3 + cr3/sin(a3) * normalized_pp(vt=ic, vi=v3);

    hull()
    {
      translate( c1 )
      circle( r=cr1 );
      translate( c2 )
      circle( r=cr2 );
      translate( c3 )
      circle( r=cr3 );
    }
  }
}

//! A general triangle specified by a vector of its three vertices.
/***************************************************************************//**
  \param    v <vector> A vector [v1, v2, v3] of vectors [x, y].

  \param    vr <vector|decimal> The vertex rounding radius. A vector
            [v1r, v2r, v3r] of decimals or a single decimal for (v1r=v2r=v3r).

  \param    centroid <boolean> Center centroid at origin.
  \param    incenter <boolean> Center incenter at origin.

  \details

    \b Example
    \code{.C}
    t = triangle_lll2vp( 30, 40, 50 );
    r = [2, 4, 6];
    triangle_vp( v=t, vr=r  );
    \endcode
*******************************************************************************/
module triangle_vp
(
  v,
  vr,
  centroid = false,
  incenter = false
)
{
  if ( len(vr) == undef )
  {
    triangle_ppp
    (
      v1=v[0], v2=v[1], v3=v[2],
      vr=vr,
      centroid=centroid, incenter=incenter
    );
  }
  else
  {
    triangle_ppp
    (
      v1=v[0], v2=v[1], v3=v[2],
      v1r=vr[0], v2r=vr[1], v3r=vr[2],
      centroid=centroid, incenter=incenter
    );
  }
}

//! A general triangle specified by its three side lengths.
/***************************************************************************//**
  \param    s1 <decimal> The length of the side 1 (along the x-axis).
  \param    s2 <decimal> The length of the side 2.
  \param    s3 <decimal> The length of the side 3.

  \param    vr <decimal> The default vertex rounding radius.
  \param    v1r <decimal> Vertex 1 rounding radius.
  \param    v2r <decimal> Vertex 2 rounding radius.
  \param    v3r <decimal> Vertex 3 rounding radius.

  \param    centroid <boolean> Center centroid at origin.
  \param    incenter <boolean> Center incenter at origin.

  \details

    \b Example
    \amu_eval ( function=triangle_lll ${example_dim} )

    See [Wikipedia](https://en.wikipedia.org/wiki/Solution_of_triangles)
    for more information.
*******************************************************************************/
module triangle_lll
(
  s1,
  s2,
  s3,
  vr,
  v1r,
  v2r,
  v3r,
  centroid = false,
  incenter = false
)
{
  a1 = acos( (s2*s2 + s3*s3 - s1*s1) / (2 * s2 * s3) );
  a2 = acos( (s1*s1 + s3*s3 - s2*s2) / (2 * s1 * s3) );
  a3 = 180 - a1 - a2;

  p3 = [s2*cos(a3), s2*sin(a3)];

  if ( is_nan( p3[0] ) || is_nan( p3[1] ) )
  {
    log_warn
    (
      str( "can not render triangle with sides (", s1, ", ", s2, ", ", s3, ")" )
    );
  }
  else
  {
    v1 = [0, 0];
    v2 = [s1, 0];
    v3 = [s1 - p3[0], p3[1]];

    triangle_ppp
    (
      v1=v1, v2=v2, v3=v3,
      vr=vr, v1r=v1r, v2r=v2r, v3r=v3r,
      centroid=centroid, incenter=incenter
    );
  }
}

//! A general triangle specified by a vector of its three side lengths.
/***************************************************************************//**
  \param    v <vector> A vector [s1, s2, s3] of decimals.

  \param    vr <vector|decimal> The vertex rounding radius. A vector
            [v1r, v2r, v3r] of decimals or a single decimal for (v1r=v2r=v3r).

  \param    centroid <boolean> Center centroid at origin.
  \param    incenter <boolean> Center incenter at origin.

  \details

    \b Example
    \code{.C}
    t = triangle_lll2vp( 3, 4, 5 );
    s = triangle_vp2vl( t );
    triangle_vl( v=s, vr=2, centroid=true );
    \endcode
*******************************************************************************/
module triangle_vl
(
  v,
  vr,
  centroid = false,
  incenter = false
)
{
  if ( len(vr) == undef )
  {
    triangle_lll
    (
      s1=v[0], s2=v[1], s3=v[2],
      vr=vr,
      centroid=centroid, incenter=incenter
    );
  }
  else
  {
    triangle_lll
    (
      s1=v[0], s2=v[1], s3=v[2],
      v1r=vr[0], v2r=vr[1], v3r=vr[2],
      centroid=centroid, incenter=incenter
    );
  }
}

//! A general triangle specified by its sides with a removed triangular core.
/***************************************************************************//**
  \param    vs <vector|decimal> The size. A vector [s1, s2, s3] of decimals
            or a single decimal for (s1=s2=s3).
  \param    vc <vector|decimal> The core. A vector [s1, s2, s3] of decimals
            or a single decimal for (s1=s2=s3).

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

  \details

    \b Example
    \amu_eval ( function=triangle_vl_c ${example_dim} )

  \note The outer and inner triangles centroids are aligned prior to the
        core removal.
*******************************************************************************/
module triangle_vl_c
(
  vs,
  vc,
  co,
  cr = 0,
  vr,
  vr1,
  vr2,
  centroid = false,
  incenter = false
)
{
  ts1 = (len(vs) >= 1) ? vs[0] : vs;
  ts2 = (len(vs) >= 2) ? vs[1] : ts1;
  ts3 = (len(vs) >= 3) ? vs[2] : ts2;

  tc1 = (len(vc) >= 1) ? vc[0] : vc;
  tc2 = (len(vc) >= 2) ? vc[1] : tc1;
  tc3 = (len(vc) >= 3) ? vc[2] : tc2;

  vrs = (vr1 == undef) ? vr : vr1;
  vrc = (vr2 == undef) ? vr : vr2;


  if ( vc != undef )
  {
    translate
    (
      ( centroid==false ) && ( incenter==true )
        ? -triangle_incenter_vp( triangle_lll2vp(s1=ts1, s2=ts2, s3=ts3) )
        : [0,0]
    )
    translate
    (
      ( centroid==true ) && ( incenter==false )
        ? [0,0]
        : triangle_centroid_vp( triangle_lll2vp(s1=ts1, s2=ts2, s3=ts3) )
    )
    difference()
    {
      triangle_vl
      (
        v=[ts1, ts2, ts3],
        vr=vrs,
        centroid=true, incenter=false
      );

      translate(co==undef ? [0,0] : co)
      rotate([0, 0, cr])
      triangle_vl
      (
        v=[tc1, tc2, tc3],
        vr=vrc,
        centroid=true, incenter=false
      );
    }
  }
  else
  {
    triangle_vl
    (
      v=[ts1, ts2, ts3],
      vr=vrs,
      centroid=centroid, incenter=incenter
    );
  }
}

//! A general triangle specified by two sides and the included angle.
/***************************************************************************//**
  \param    s1 <decimal> The length of the side 1.
  \param    a <decimal> The included angle in degrees.
  \param    s2 <decimal> The length of the side 2.

  \param    x <decimal> The side to draw on the positive x-axis (\p x=1 for \p s1).

  \param    vr <decimal> The default vertex rounding radius.
  \param    v1r <decimal> Vertex 1 rounding radius.
  \param    v2r <decimal> Vertex 2 rounding radius.
  \param    v3r <decimal> Vertex 3 rounding radius.

  \param    centroid <boolean> Center centroid at origin.
  \param    incenter <boolean> Center incenter at origin.

  \details

    \b Example
    \amu_eval ( function=triangle_lal ${example_dim} )

    See [Wikipedia](https://en.wikipedia.org/wiki/Solution_of_triangles)
    for more information.
*******************************************************************************/
module triangle_lal
(
  s1,
  a,
  s2,
  x = 1,
  vr,
  v1r,
  v2r,
  v3r,
  centroid = false,
  incenter = false
)
{
  s3 = sqrt( s1*s1 + s2*s2 - 2*s1*s2*cos(a) );

  if ( x%4 == 1 )
  {
    triangle_lll
    (
      s1=s1, s2=s2, s3=s3,
      vr=vr, v1r=v1r, v2r=v2r, v3r=v3r,
      centroid=centroid, incenter=incenter
    );
  }
  else if ( x%4 == 2 )
  {
    triangle_lll
    (
      s1=s2, s2=s3, s3=s1,
      vr=vr, v1r=v2r, v2r=v3r, v3r=v1r,
      centroid=centroid, incenter=incenter
    );
  }
  else if ( x%4 == 3 )
  {
    triangle_lll
    (
      s1=s3, s2=s1, s3=s2,
      vr=vr, v1r=v3r, v2r=v1r, v3r=v2r,
      centroid=centroid, incenter=incenter
    );
  }
}

//! A general triangle specified by a side and two adjacent angles.
/***************************************************************************//**
  \param    a1 <decimal> The adjacent angle 1 in degrees.
  \param    s <decimal> The side length adjacent to the angles.
  \param    a2 <decimal> The adjacent angle 2 in degrees.

  \param    x <decimal> The side to draw on the positive x-axis (\p x=1 for \p s).

  \param    vr <decimal> The default vertex rounding radius.
  \param    v1r <decimal> Vertex 1 rounding radius.
  \param    v2r <decimal> Vertex 2 rounding radius.
  \param    v3r <decimal> Vertex 3 rounding radius.

  \param    centroid <boolean> Center centroid at origin.
  \param    incenter <boolean> Center incenter at origin.

  \details

    \b Example
    \amu_eval ( function=triangle_ala ${example_dim} )

    See [Wikipedia](https://en.wikipedia.org/wiki/Solution_of_triangles)
    for more information.
*******************************************************************************/
module triangle_ala
(
  a1,
  s,
  a2,
  x = 1,
  vr,
  v1r,
  v2r,
  v3r,
  centroid = false,
  incenter = false
)
{
  if ( (a1 + a2) >= 180 )
  {
    log_warn
    (
      str( "can not render triangle with angles (", a1, ", ", a2, ")" )
    );
  }
  else
  {
    s3 = s;
    a3 = 180 - a1 - a2;

    s1 = s3 * sin( a1 ) / sin( a3 );
    s2 = s3 * sin( a2 ) / sin( a3 );

    if ( x%4 == 1 )
    {
      triangle_lll
      (
        s1=s3, s2=s1, s3=s2,
        vr=vr, v1r=v3r, v2r=v1r, v3r=v2r,
        centroid=centroid, incenter=incenter
      );
    }
    else if ( x%4 == 2 )
    {
      triangle_lll
      (
        s1=s1, s2=s2, s3=s3,
        vr=vr, v1r=v1r, v2r=v2r, v3r=v3r,
        centroid=centroid, incenter=incenter
      );
    }
    else if ( x%4 == 3 )
    {
      triangle_lll
      (
        s1=s2, s2=s3, s3=s1,
        vr=vr, v1r=v2r, v2r=v3r, v3r=v1r,
        centroid=centroid, incenter=incenter
      );
    }
  }
}

//! A general triangle specified by a side, one adjacent angle and the opposite angle.
/***************************************************************************//**
  \param    a1 <decimal> The opposite angle 1 in degrees.
  \param    a2 <decimal> The adjacent angle 2 in degrees.
  \param    s <decimal> The side length.

  \param    x <decimal> The side to draw on the positive x-axis (\p x=1 for \p s).

  \param    vr <decimal> The default vertex rounding radius.
  \param    v1r <decimal> Vertex 1 rounding radius.
  \param    v2r <decimal> Vertex 2 rounding radius.
  \param    v3r <decimal> Vertex 3 rounding radius.

  \param    centroid <boolean> Center centroid at origin.
  \param    incenter <boolean> Center incenter at origin.

  \details

    \b Example
    \amu_eval ( function=triangle_aal ${example_dim} )

    See [Wikipedia](https://en.wikipedia.org/wiki/Solution_of_triangles)
    for more information.
*******************************************************************************/
module triangle_aal
(
  a1,
  a2,
  s,
  x = 1,
  vr,
  v1r,
  v2r,
  v3r,
  centroid = false,
  incenter = false
)
{
  if ( (a1 + a2) >= 180 )
  {
    log_warn
    (
      str( "can not render triangle with angles (", a1, ", ", a2, ")" )
    );
  }
  else
  {
    s1 = s;
    a3 = 180 - a1 - a2;

    s2 = s1 * sin( a2 ) / sin( a1 );
    s3 = s1 * sin( a3 ) / sin( a1 );

    if ( x%4 == 1 )
    {
      triangle_lll
      (
        s1=s1, s2=s2, s3=s3,
        vr=vr, v1r=v1r, v2r=v2r, v3r=v3r,
        centroid=centroid, incenter=incenter
      );
    }
    else if ( x%4 == 2 )
    {
      triangle_lll
      (
        s1=s2, s2=s3, s3=s1,
        vr=vr, v1r=v2r, v2r=v3r, v3r=v1r,
        centroid=centroid, incenter=incenter
      );
    }
    else if ( x%4 == 3 )
    {
      triangle_lll
      (
        s1=s3, s2=s1, s3=s2,
        vr=vr, v1r=v3r, v2r=v1r, v3r=v2r,
        centroid=centroid, incenter=incenter
      );
    }
  }
}

//! A right-angled triangle specified by its opposite and adjacent side lengths.
/***************************************************************************//**
  \param    x <decimal> The length of the side along the x-axis.
  \param    y <decimal> The length of the side along the y-axis.

  \param    vr <decimal> The default vertex rounding radius.
  \param    v1r <decimal> Vertex 1 rounding radius.
  \param    v2r <decimal> Vertex 2 rounding radius.
  \param    v3r <decimal> Vertex 3 rounding radius.

  \param    centroid <boolean> Center centroid at origin.
  \param    incenter <boolean> Center incenter at origin.

  \details

    \b Example
    \amu_eval ( function=triangle_ll ${example_dim} )
*******************************************************************************/
module triangle_ll
(
  x,
  y,
  vr,
  v1r,
  v2r,
  v3r,
  centroid = false,
  incenter = false
)
{
  triangle_ppp
  (
    v1=[0,0], v2=[x,0], v3=[0,y],
    vr=vr, v1r=v1r, v2r=v2r, v3r=v3r,
    centroid=centroid, incenter=incenter
  );
}

//! A right-angled triangle specified by a side length and an angle.
/***************************************************************************//**
  \param    x <decimal> The length of the side along the x-axis.
  \param    y <decimal> The length of the side along the y-axis.
  \param    aa <decimal> The adjacent angle in degrees.
  \param    oa <decimal> The opposite angle in degrees.

  \param    vr <decimal> The default vertex rounding radius.
  \param    v1r <decimal> Vertex 1 rounding radius.
  \param    v2r <decimal> Vertex 2 rounding radius.
  \param    v3r <decimal> Vertex 3 rounding radius.

  \param    centroid <boolean> Center centroid at origin.
  \param    incenter <boolean> Center incenter at origin.

  \details

    \b Example
    \amu_eval ( function=triangle_la ${example_dim} )

  \note     When both \p x and \p y are given, both triangles are rendered.
  \note     When both \p aa and \p oa are given, \p aa is used.
*******************************************************************************/
module triangle_la
(
  x,
  y,
  aa,
  oa,
  vr,
  v1r,
  v2r,
  v3r,
  centroid = false,
  incenter = false
)
{
  a = ( aa != undef ) ? aa : (90 - oa);

  if ( x != undef )
  {
    triangle_ppp
    (
      v1=[0,0], v2=[x,0], v3=[0,tan(a)*x],
      vr=vr, v1r=v1r, v2r=v2r, v3r=v3r,
      centroid=centroid, incenter=incenter
    );
  }

  if ( y != undef )
  {
    triangle_ppp
    (
      v1=[0,0], v2=[tan(a)*y,0], v3=[0,y],
      vr=vr, v1r=v1r, v2r=v2r, v3r=v3r,
      centroid=centroid, incenter=incenter
    );
  }
}

//! An n-sided equiangular/equilateral regular polygon.
/***************************************************************************//**
  \param    n <decimal> The number of sides.
  \param    r <decimal> The ngon vertex radius.

  \param    vr <decimal> The vertex rounding radius.

  \details

    \b Example
    \amu_eval ( function=ngon ${example_dim} )

    See [Wikipedia](https://en.wikipedia.org/wiki/Regular_polygon)
    for more information.
*******************************************************************************/
module ngon
(
  n,
  r,
  vr
)
{
  if ( vr == undef )
  {
    circle(r=r, $fn=n);
  }
  else
  {
    hull()
    {
      for ( c = ngon_vp( r=r, n=n, vr=vr ) )
      {
        translate( c )
        circle( r=vr );
      }
    }
  }
}

//! An ellipse.
/***************************************************************************//**
  \param    size <vector|decimal> A vector [rx, ry] of decimals
            or a single decimal for (rx=ry).

  \details

    \b Example
    \amu_eval ( function=ellipse ${example_dim} )
*******************************************************************************/
module ellipse
(
  size
)
{
  rx = (len(size) >= 1) ? size[0] : size;
  ry = (len(size) >= 2) ? size[1] : rx;

  if ( rx == ry )
  {
    circle(r=rx);
  }
  else
  {
    scale([1, ry/rx])
    circle(r=rx);
  }
}

//! An ellipse with a removed elliptical core.
/***************************************************************************//**
  \param    size <vector|decimal> A vector [rx, ry] of decimals
            or a single decimal for (rx=ry).
  \param    core <vector|decimal> A vector [rx, ry] of decimals
            or a single decimal for (rx=ry).

  \param    t <vector|decimal> A vector [x, y] of decimals
            or a single decimal for (x=y).

  \param    co <vector> Core offset. A vector [x, y] of decimals.
  \param    cr <decimal> Core z-rotation.

  \details

    Thickness \p t
    \li <tt>core = size - t</tt>; when \p t and \p size are given.
    \li <tt>size = core + t</tt>; when \p t and \p core are given.

    \b Example
    \amu_eval ( function=ellipse_c ${example_dim} )
*******************************************************************************/
module ellipse_c
(
  size,
  core,
  t,
  co,
  cr = 0
)
{
  od = ((t != undef) && (core != undef)) ? (core + t) : size;
  id = ((t != undef) && (size != undef)) ? (size - t) : core;

  if ( id != undef )
  {
    difference()
    {
      ellipse(size=od);

      translate(co==undef ? [0,0] : co)
      rotate([0, 0, cr])
      ellipse(size=id);
    }
  }
  else
  {
    ellipse(size=od);
  }
}

//! An ellipse sector.
/***************************************************************************//**
  \param    size <vector|decimal> A vector [rx, ry] of decimals
            or a single decimal for (rx=ry).

  \param    a1 <decimal> The start angle in degrees.
  \param    a2 <decimal> The stop angle in degrees.

  \details

    \b Example
    \amu_eval ( function=ellipse_s ${example_dim} )
*******************************************************************************/
module ellipse_s
(
  size,
  a1 = 0,
  a2 = 0
)
{
  rx = (len(size) >= 1) ? size[0] : size;
  ry = (len(size) >= 2) ? size[1] : rx;

  trx = rx * sqrt(2) + 1;
  try = ry * sqrt(2) + 1;

  pa0 = (4 * a1 + 0 * a2) / 4;
  pa1 = (3 * a1 + 1 * a2) / 4;
  pa2 = (2 * a1 + 2 * a2) / 4;
  pa3 = (1 * a1 + 3 * a2) / 4;
  pa4 = (0 * a1 + 4 * a2) / 4;

  if(a2 > a1)
  {
    intersection()
    {
      ellipse(size);

      polygon
      ([
        [0,0],
        [trx * cos(pa0), try * sin(pa0)],
        [trx * cos(pa1), try * sin(pa1)],
        [trx * cos(pa2), try * sin(pa2)],
        [trx * cos(pa3), try * sin(pa3)],
        [trx * cos(pa4), try * sin(pa4)],
        [0,0]
      ]);
    }
  }
  else
  {
    ellipse(size);
  }
}

//! A sector of an ellipse with a removed elliptical core.
/***************************************************************************//**
  \param    size <vector|decimal> A vector [rx, ry] of decimals
            or a single decimal for (rx=ry).
  \param    core <vector|decimal> A vector [rx, ry] of decimals
            or a single decimal for (rx=ry).

  \param    t <vector|decimal> A vector [x, y] of decimals
            or a single decimal for (x=y).

  \param    a1 <decimal> The start angle in degrees.
  \param    a2 <decimal> The stop angle in degrees.

  \param    co <vector> Core offset. A vector [x, y] of decimals.
  \param    cr <decimal> Core z-rotation.

  \details

    Thickness \p t
    \li <tt>core = size - t</tt>; when \p t and \p size are given.
    \li <tt>size = core + t</tt>; when \p t and \p core are given.

    \b Example
    \amu_eval ( function=ellipse_cs ${example_dim} )
*******************************************************************************/
module ellipse_cs
(
  size,
  core,
  t,
  a1 = 0,
  a2 = 0,
  co,
  cr = 0
)
{
  od = ((t != undef) && (core != undef)) ? (core + t) : size;
  id = ((t != undef) && (size != undef)) ? (size - t) : core;

  if ( id != undef )
  {
    difference()
    {
      ellipse_s(a1=a1, a2=a2, size=od);

      translate(co==undef ? [0,0] : co)
      rotate([0, 0, cr])
      ellipse(size=id);
    }
  }
  else
  {
    ellipse_s(a1=a1, a2=a2, size=od);
  }
}

//! A two dimensional star.
/***************************************************************************//**
  \param    size <vector|decimal> A vector [l, w] of decimals
            or a single decimal for (size=l=2*w).

  \param    n <decimal> The number of points.

  \param    vr <vector|decimal> The vertex rounding radius. A vector
            [v1r, v2r, v3r] of decimals or a single decimal for (v1r=v2r=v3r).

  \details

    \b Example
    \amu_eval ( function=star2d ${example_dim} )
*******************************************************************************/
module star2d
(
  size,
  n = 5,
  vr
)
{
  l = (len(size) >= 1) ? size[0] : size;
  w = (len(size) >= 2) ? size[1] : l/2;

  st_radial_copy(n=n, angle=true, move=false)
  rotate([0, 0, -90])
  translate([-w/2, 0])
  triangle_vl(v=[w, l, l], vr=vr);
}

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE dim;
  BEGIN_OPENSCAD;
    include <shapes2d.scad>;

    shape = "ellipse_cs";
    $fn = 72;

    if (shape == "rectangle")
      rectangle( size=[25,40], vr=[0,10,10,5], center=true );
    else if (shape == "rectangle_c")
      rectangle_c( size=[40,25], t=[15,5], vr1=[0,0,10,10], vr2=2.5, co=[0,5], center=true );
    else if (shape == "rhombus")
      rhombus( size=[40,25], vr=[2,4,2,4], center=true );
    else if (shape == "triangle_ppp")
      triangle_ppp( v1=[0,0], v2=[5,25], v3=[40,5], vr=2, centroid=true );
    else if (shape == "triangle_lll")
      triangle_lll( s1=30, s2=40, s3=50, vr=2, centroid=true );
    else if (shape == "triangle_vl_c")
      triangle_vl_c( vs=[30,50,50], vc=[20,40,40], co=[0,-4], vr1=[1,1,6], vr2=4, centroid=true );
    else if (shape == "triangle_lal")
      triangle_lal( s1=50, a=60, s2=30, vr=2, centroid=true );
    else if (shape == "triangle_ala")
      triangle_ala( a1=30, s=50, a2=60, vr=2, centroid=true );
    else if (shape == "triangle_aal")
      triangle_aal( a1=60, a2=30, s=40, vr=2, centroid=true );
    else if (shape == "triangle_ll")
      triangle_ll( x=30, y=40, vr=2, centroid=true );
    else if (shape == "triangle_la")
      triangle_la( x=40, aa=30, vr=2, centroid=true );
    else if (shape == "ngon")
      ngon( n=6, r=25, vr=6 );
    else if (shape == "ellipse")
      ellipse( size=[25, 40] );
    else if (shape == "ellipse_c")
      ellipse_c( size=[25,40], core=[16,10], co=[0,10], cr=45 );
    else if (shape == "ellipse_s")
      ellipse_s( size=[25,40], a1=90, a2=180 );
    else if (shape == "ellipse_cs")
      ellipse_cs( size=[25,40], t=[10,5], a1=90, a2=180, co=[10,0], cr=45);
    else if (shape == "star2d")
      star2d( size=[40, 15], n=5, vr=2 );
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {config_std,config_png}.mfs;
    views     name "views" views "top";
    defines   name "shapes" define "shape"
              strings "
                rectangle
                rectangle_c
                rhombus
                triangle_ppp
                triangle_lll
                triangle_vl_c
                triangle_lal
                triangle_ala
                triangle_aal
                triangle_ll
                triangle_la
                ngon
                ellipse
                ellipse_c
                ellipse_s
                ellipse_cs
                star2d
              ";
    variables add_opts_combine "views shapes";
    variables add_opts "--viewall --autocenter";
    include --path "${INCLUDE_PATH}" script_std.mfs;
  END_MFSCRIPT;
END_SCOPE;

BEGIN_SCOPE manifest;
  BEGIN_OPENSCAD;
    include <shapes2d.scad>;

    $fn = 72;

    st_cartesian_copy( grid=5, incr=60, center=true )
    {
      rectangle( size=[25,40], vr=[0,10,10,5], center=true );
      rectangle_c( size=[40,25], t=[15,5], vr1=[0,0,10,10], vr2=2.5, co=[0,5], center=true );
      rhombus( size=[40,25], vr=[2,4,2,4], center=true );
      triangle_ppp( v1=[0,0], v2=[5,25], v3=[40,5], vr=2, centroid=true );
      triangle_lll( s1=30, s2=40, s3=50, vr=2, centroid=true );
      triangle_vl_c( vs=[30,50,50], vc=[20,40,40], co=[0,-4], vr1=[1,1,6], vr2=4, centroid=true );
      triangle_lal( s1=50, a=60, s2=30, vr=2, centroid=true );
      triangle_ala( a1=30, s=50, a2=60, vr=2, centroid=true );
      triangle_aal( a1=60, a2=30, s=40, vr=2, centroid=true );
      triangle_ll( x=30, y=40, vr=2, centroid=true );
      triangle_la( x=40, aa=30, vr=2, centroid=true );
      ngon( n=6, r=25, vr=6 );
      ellipse( size=[25, 40] );
      ellipse_c( size=[25,40], core=[16,10], co=[0,10], cr=45 );
      ellipse_s( size=[25,40], a1=90, a2=180 );
      ellipse_cs( size=[25,40], t=[10,5], a1=90, a2=180, co=[10,0], cr=45);
      star2d( size=[40, 15], n=5, vr=2 );
    }
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {config_std,config_dxf}.mfs;
    include --path "${INCLUDE_PATH}" script_std.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
