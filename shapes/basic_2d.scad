//! Basic 2D derivative shapes.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2015-2023

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

    \amu_define group_name  (2d Shapes)
    \amu_define group_brief (Basic 2D derivative shapes.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group and macros.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_include (include/amu/includes_required.amu)

  \amu_define view (top)
  \amu_include (include/amu/table_example_dim.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//! A rectangle with edge, round, or chamfer corners.
/***************************************************************************//**
  \param    size <decimal-list-2|decimal> A list [x, y] of decimals
            or a single decimal for (x=y).

  \param    vr <decimal-list-4|decimal> The corner rounding radius.
            A list [v1r, v2r, v3r, v4r] of decimals or a single decimal
            for (v1r=v2r=v3r=v4r). Unspecified corners are not rounded.

  \param    vrm <integer> The corner radius mode.
            A 4-bit encoded integer that indicates each corner finish.
            Use bit value \b 0 for \em round and \b 1 for \em chamfer.

  \param    center <boolean> Center about origin.

  \details

    \b Example
    \amu_eval ( function=rectangle ${example_dim} )

  \note     A corner \em round replaces an edge with a quarter circle of
            radius \p vr, inset <tt>[vr, vr]</tt> from the corner vertex.
  \note     A corner \em chamfer replaces an edge with an isosceles right
            triangle with side lengths equal to the corresponding corner
            rounding radius \p vr. Therefore the chamfer length will be
            <tt>vr*sqrt(2)</tt> at 45 degree angles.
*******************************************************************************/
module rectangle
(
  size,
  vr,
  vrm = 0,
  center = false
)
{
  rx = defined_e_or(size, 0, size);
  ry = defined_e_or(size, 1, rx);

  translate(center==true ? [-rx/2, -ry/2] : origin2d)
  {
    if ( is_undef(vr) )              // no rounding
    {
      square([rx, ry]);
    }
    else if ( is_scalar(vr) )           // equal rounding
    {
      for ( i =  [ [0, 0,  1, 0,  1,   0],
                   [1, 1, -1, 0,  1,  90],
                   [2, 1, -1, 1, -1, 180],
                   [3, 0,  1, 1, -1, 270] ] )
      {
        translate([rx*i[1] + vr * i[2], ry*i[3] + vr * i[4]])
        if ( binary_bit_is(vrm, i[0], 0) )
        {
          circle(r=vr);
        }
        else
        {
          rotate([0, 0, i[5]])
          polygon(points=[[eps,-vr], [eps,eps], [-vr,eps]], paths=[[0,1,2]]);
        }
      }

      translate([0, vr])
      square([rx, ry] - [0, vr*2]);

      translate([vr, 0])
      square([rx, ry] - [vr*2, 0]);
    }
    else                                // individual rounding
    {
      crv = [ defined_e_or(vr, 0, 0),
              defined_e_or(vr, 1, 0),
              defined_e_or(vr, 2, 0),
              defined_e_or(vr, 3, 0) ];

      for ( i =  [ [0, 0,  1, 0,  1],
                   [1, 1, -1, 0,  1],
                   [2, 1, -1, 1, -1],
                   [3, 0,  1, 1, -1] ] )
      {
        if ( (crv[i[0]] > 0) && binary_bit_is(vrm, i[0], 0) )
        {
         translate([rx*i[1] + crv[i[0]] * i[2], ry*i[3] + crv[i[0]] * i[4]])
         circle(r=crv[i[0]]);
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
  \param    size <decimal-list-2|decimal> A list [x, y] of decimals
            or a single decimal for (x=y).
  \param    core <decimal-list-2|decimal> A list [x, y] of decimals
            or a single decimal for (x=y).

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
            Use bit value \b 0 for \em round and \b 1 for \em chamfer.
  \param    vrm1 <integer> The outer corner radius mode.
  \param    vrm2 <integer> The core corner radius mode.

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
  vrm = 0,
  vrm1,
  vrm2,
  center = false
)
{
  od = all_defined([t, core]) ? (core + t*2) : size;
  id = all_defined([t, size]) ? (size - t*2) : core;

  rx = defined_e_or(od, 0, od);
  ry = defined_e_or(od, 1, od);

  or = defined_or(vr1, vr);
  ir = defined_or(vr2, vr);

  om = defined_or(vrm1, vrm);
  im = defined_or(vrm2, vrm);

  if ( is_defined(id) )
  {
    translate(center==true ? origin2d : [rx/2, ry/2])
    difference()
    {
      rectangle(size=od, vr=or, vrm=om, center=true);

      translate(is_defined(co) ? co : origin2d)
      rotate([0, 0, cr])
      rectangle(size=id, vr=ir, vrm=im, center=true);
    }
  }
  else
  {
    rectangle(size=od, vr=or, vrm=om, center=center);
  }
}

//! A rhombus.
/***************************************************************************//**
  \param    size <decimal-list-2|decimal> A list [w, h] of decimals
            or a single decimal for (w=h).

  \param    vr <decimal-list-4|decimal> The corner rounding radius.
            A list [v1r, v2r, v3r, v4r] of decimals or a single decimal
            for (v1r=v2r=v3r=v4r). Unspecified corners are not rounded.

  \param    center <boolean> Center about origin.

  \details

    \b Example
    \amu_eval ( function=rhombus ${example_dim} )

    See [Wikipedia] for more information.

  [Wikipedia]: https://en.wikipedia.org/wiki/Rhombus
*******************************************************************************/
module rhombus
(
  size,
  vr,
  center = false
)
{
  rx = defined_e_or(size, 0, size) / 2;
  ry = defined_e_or(size, 1, rx*2) / 2;

  translate(center==true ? origin2d : [rx, ry])
  {
    if ( is_undef(vr) )              // no rounding
    {
      polygon
      (
        points=[ [rx,0], [0,ry], [-rx,0], [0,-ry] ],
        paths=[ [0,1,2,3] ]
      );
    }
    else                                // individual rounding
    {
      erc = is_scalar(vr) ? vr : 0;     // equal rounding

      crv = [ defined_e_or(vr, 0, erc),
              defined_e_or(vr, 1, erc),
              defined_e_or(vr, 2, erc),
              defined_e_or(vr, 3, erc) ];

      a1 = angle_ll([[rx,0], [0,ry]], [[rx,0], [0,-ry]]) / 2;
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
  \param    v1 <point-2d> A point [x, y] for vertex 1.
  \param    v2 <point-2d> A point [x, y] for vertex 2.
  \param    v3 <point-2d> A point [x, y] for vertex 3.

  \param    vr <decimal> The default vertex rounding radius.
  \param    v1r <decimal> Vertex 1 rounding radius.
  \param    v2r <decimal> Vertex 2 rounding radius.
  \param    v3r <decimal> Vertex 3 rounding radius.

  \param    centroid <boolean> Center centroid at origin.
  \param    incenter <boolean> Center incenter at origin.

  \details

    \b Example
    \amu_eval ( function=triangle_ppp ${example_dim} )

  \warning  Currently, in order to round any vertex, all must be given
            a rounding radius, either via \p vr or individually.

  \todo     Replace the hull() operation with calculated tangential
            intersection of the rounded vertexes.
  \todo     Remove the all or nothing requirement for vertex rounding.
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
  cr1 = defined_or(v1r, vr);
  cr2 = defined_or(v2r, vr);
  cr3 = defined_or(v3r, vr);

  translate
  (
    ( centroid==false ) && ( incenter==true )
      ? -triangle2d_incenter( [v1, v2, v3] )
      : origin2d
  )
  translate
  (
    ( centroid==true ) && ( incenter==false )
      ? -triangle_centroid( [v1, v2, v3] )
      : origin2d
  )
  if ( any_undefined([cr1, cr2, cr3]) )
  {
    polygon( points=[v1, v2, v3], paths=[[0,1,2]] );
  }
  else
  {
    ic = triangle2d_incenter( [v1, v2, v3] );

    a1 = angle_ll([v1, v2], [v1, ic]);
    a2 = angle_ll([v2, v3], [v2, ic]);
    a3 = angle_ll([v3, v1], [v3, ic]);

    c1 = v1 + cr1/sin(a1) * unit_l([v1, ic]);
    c2 = v2 + cr2/sin(a2) * unit_l([v2, ic]);
    c3 = v3 + cr3/sin(a3) * unit_l([v3, ic]);

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

//! A general triangle specified by its sides with a removed triangular core.
/***************************************************************************//**
  \param    vs <decimal-list-3|decimal> The size. A list [s1, s2, s3] of
            decimals or a single decimal for (s1=s2=s3).
  \param    vc <decimal-list-3|decimal> The core. A list [s1, s2, s3] of
            decimals or a single decimal for (s1=s2=s3).

  \param    co <decimal-list-2> Core offset. A list [x, y] of decimals.
  \param    cr <decimal> Core z-rotation.

  \param    vr <decimal-list-3|decimal> The default vertex rounding radius.
            A list [v1r, v2r, v3r] of decimals or a single decimal for
            (v1r=v2r=v3r).
  \param    vr1 <decimal-list-3|decimal> The outer vertex rounding radius.
  \param    vr2 <decimal-list-3|decimal> The core vertex rounding radius.

  \param    centroid <boolean> Center centroid at origin.
  \param    incenter <boolean> Center incenter at origin.

  \details

    \b Example
    \amu_eval ( function=triangle_ls_c ${example_dim} )

  \note     The outer and inner triangles centroids are aligned prior to
            the core removal.
*******************************************************************************/
module triangle_ls_c
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
  module triangle_sss
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
      v1 = origin2d;
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

  module triangle_ls
  (
    v,
    vr,
    centroid = false,
    incenter = false
  )
  {

    if ( is_scalar(vr) )
    {
      triangle_sss
      (
        s1=v[0], s2=v[1], s3=v[2],
        vr=vr,
        centroid=centroid, incenter=incenter
      );
    }
    else
    {
      triangle_sss
      (
        s1=v[0], s2=v[1], s3=v[2],
        v1r=vr[0], v2r=vr[1], v3r=vr[2],
        centroid=centroid, incenter=incenter
      );
    }
  }

  ts1 = defined_e_or(vs, 0, vs);
  ts2 = defined_e_or(vs, 1, ts1);
  ts3 = defined_e_or(vs, 2, ts2);

  tc1 = defined_e_or(vc, 0, vc);
  tc2 = defined_e_or(vc, 1, tc1);
  tc3 = defined_e_or(vc, 2, tc2);

  vrs = defined_or(vr1, vr);
  vrc = defined_or(vr2, vr);

  if ( is_defined(vc) )
  {
    translate
    (
      ( centroid==false ) && ( incenter==true )
        ? -triangle2d_incenter( triangle2d_sss2ppp([ts1, ts2, ts3]) )
        : origin2d
    )
    translate
    (
      ( centroid==true ) && ( incenter==false )
        ? origin2d
        : triangle_centroid( triangle2d_sss2ppp([ts1, ts2, ts3]) )
    )
    difference()
    {
      triangle_ls
      (
        v=[ts1, ts2, ts3],
        vr=vrs,
        centroid=true, incenter=false
      );

      translate(is_defined(co) ? co : origin2d)
      rotate([0, 0, cr])
      triangle_ls
      (
        v=[tc1, tc2, tc3],
        vr=vrc,
        centroid=true, incenter=false
      );
    }
  }
  else
  {
    triangle_ls
    (
      v=[ts1, ts2, ts3],
      vr=vrs,
      centroid=centroid, incenter=incenter
    );
  }
}

//! An n-sided equiangular/equilateral regular polygon.
/***************************************************************************//**
  \param    n <integer> The number of sides.
  \param    r <decimal> The ngon vertex radius.

  \param    vr <decimal> The vertex rounding radius.

  \details

    \b Example
    \amu_eval ( function=ngon ${example_dim} )

    See [Wikipedia] for more information.

  [Wikipedia]: https://en.wikipedia.org/wiki/Regular_polygon
*******************************************************************************/
module ngon
(
  n,
  r,
  vr
)
{
  if ( is_undef(vr) )
  {
    circle(r=r, $fn=n);
  }
  else
  {
    hull()
    {
      for ( c = polygon_regular_p( r=r, n=n, vr=vr ) )
      {
        translate( c )
        circle( r=vr );
      }
    }
  }
}

//! An ellipse.
/***************************************************************************//**
  \param    size <decimal-list-2|decimal> A list [rx, ry] of decimals
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
  rx = defined_e_or(size, 0, size);
  ry = defined_e_or(size, 1, rx);

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
  \param    size <decimal-list-2|decimal> A list [rx, ry] of decimals
            or a single decimal for (rx=ry).
  \param    core <decimal-list-2|decimal> A list [rx, ry] of decimals
            or a single decimal for (rx=ry).

  \param    t <decimal-list-2|decimal> A list [x, y] of decimals
            or a single decimal for (x=y).

  \param    co <decimal-list-2> Core offset. A list [x, y] of decimals.
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
  od = all_defined([t, core]) ? (core + t) : size;
  id = all_defined([t, size]) ? (size - t) : core;

  if ( is_defined(id) )
  {
    difference()
    {
      ellipse(size=od);

      translate(is_defined(co) ? co : origin2d)
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
  \param    size <decimal-list-2|decimal> A list [rx, ry] of decimals
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
  rx = defined_e_or(size, 0, size);
  ry = defined_e_or(size, 1, rx);

  trx = rx * sqrt(2) + 1;
  try = ry * sqrt(2) + 1;

  pa0 = (4 * a1 + 0 * a2) / 4;
  pa1 = (3 * a1 + 1 * a2) / 4;
  pa2 = (2 * a1 + 2 * a2) / 4;
  pa3 = (1 * a1 + 3 * a2) / 4;
  pa4 = (0 * a1 + 4 * a2) / 4;

  if (a2 > a1)
  {
    intersection()
    {
      ellipse(size);

      polygon
      ([
        origin2d,
        [trx * cos(pa0), try * sin(pa0)],
        [trx * cos(pa1), try * sin(pa1)],
        [trx * cos(pa2), try * sin(pa2)],
        [trx * cos(pa3), try * sin(pa3)],
        [trx * cos(pa4), try * sin(pa4)],
        origin2d
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
  \param    size <decimal-list-2|decimal> A list [rx, ry] of decimals
            or a single decimal for (rx=ry).
  \param    core <decimal-list-2|decimal> A list [rx, ry] of decimals
            or a single decimal for (rx=ry).

  \param    t <decimal-list-2|decimal> A list [x, y] of decimals
            or a single decimal for (x=y).

  \param    a1 <decimal> The start angle in degrees.
  \param    a2 <decimal> The stop angle in degrees.

  \param    co <decimal-list-2> Core offset. A list [x, y] of decimals.
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
  od = all_defined([t, core]) ? (core + t) : size;
  id = all_defined([t, size]) ? (size - t) : core;

  if ( is_defined(id) )
  {
    difference()
    {
      ellipse_s(a1=a1, a2=a2, size=od);

      translate(is_defined(co) ? co : origin2d)
      rotate([0, 0, cr])
      ellipse(size=id);
    }
  }
  else
  {
    ellipse_s(a1=a1, a2=a2, size=od);
  }
}

//! A two-dimensional star.
/***************************************************************************//**
  \param    size <decimal-list-2|decimal> A list [l, w] of decimals
            or a single decimal for (size=l=2*w).

  \param    n <decimal> The number of points.

  \param    vr <decimal-list-3|decimal> The vertex rounding radius.
            A list [v1r, v2r, v3r] of decimals or a single decimal for
            (v1r=v2r=v3r).

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
  l = defined_e_or(size, 0, size);
  w = defined_e_or(size, 1, l/2);

  repeat_radial(n=n, angle=true, move=false)
  rotate([0, 0, -90])
  translate([-w/2, 0])
  triangle_ls_c(vs=[w, l, l], vr=vr);
}

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE dim;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;

    shape = "ellipse_cs";
    $fn = 36;

    if (shape == "rectangle")
      rectangle( size=[25,40], vr=[0,10,10,5], vrm=4, center=true );
    else if (shape == "rectangle_c")
      rectangle_c( size=[40,25], t=[15,5], vr1=[0,0,10,10], vr2=2.5, vrm2=3, co=[0,5], center=true );
    else if (shape == "rhombus")
      rhombus( size=[40,25], vr=[2,4,2,4], center=true );
    else if (shape == "triangle_ppp")
      triangle_ppp( v1=[0,0], v2=[5,25], v3=[40,5], vr=2, centroid=true );
    else if (shape == "triangle_ls_c")
      triangle_ls_c( vs=[30,50,50], vc=[20,40,40], co=[0,-4], vr1=[1,1,6], vr2=4, centroid=true );
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
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;

    views     name "views" views "top";
    defines   name "shapes" define "shape"
              strings "
                rectangle
                rectangle_c
                rhombus
                triangle_ppp
                triangle_ls_c
                ngon
                ellipse
                ellipse_c
                ellipse_s
                ellipse_cs
                star2d
              ";
    variables add_opts_combine "views shapes";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_std_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;

BEGIN_SCOPE manifest;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;

    $fn = 36;

    repeat_grid( g=5, i=60, center=true )
    {
      rectangle( size=[25,40], vr=[0,10,10,5], vrm=4, center=true );
      rectangle_c( size=[40,25], t=[15,5], vr1=[0,0,10,10], vr2=2.5, vrm2=3, co=[0,5], center=true );
      rhombus( size=[40,25], vr=[2,4,2,4], center=true );
      triangle_ppp( v1=[0,0], v2=[5,25], v3=[40,5], vr=2, centroid=true );
      triangle_ls_c( vs=[30,50,50], vc=[20,40,40], co=[0,-4], vr1=[1,1,6], vr2=4, centroid=true );
      ngon( n=6, r=25, vr=6 );
      ellipse( size=[25, 40] );
      ellipse_c( size=[25,40], core=[16,10], co=[0,10], cr=45 );
      ellipse_s( size=[25,40], a1=90, a2=180 );
      ellipse_cs( size=[25,40], t=[10,5], a1=90, a2=180, co=[10,0], cr=45);
      star2d( size=[40, 15], n=5, vr=2 );
    }
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_svg}.mfs;
    include --path "${INCLUDE_PATH}" scr_std_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
