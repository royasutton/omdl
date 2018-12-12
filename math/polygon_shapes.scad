//! Mathematical functions of polygon shapes.
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

    \amu_define group_name  (Polygon Shapes)
    \amu_define group_brief (Mathematical functions of polygon shapes.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
*******************************************************************************/

include <../datatypes/datatypes-base.scad>;
include <polytope.scad>;

//----------------------------------------------------------------------------//
// group.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//! Compute the coordinates for an n-sided regular polygon in 2D.
/***************************************************************************//**
  \param    n <integer> The number of sides.
  \param    r <decimal> The circumradius of the circumcircle.
  \param    a <decimal> The inradius of the incircle.
  \param    vr <decimal> The vertex rounding radius.
  \param    cw <boolean> Use clockwise point ordering.

  \returns  <coords-2d> A list of coordinates points [[x, y], ...].

  \details

    The radius can be specified by either the circumradius \p r or the
    inradius \p a. If both are specified, \p r is used.

    \b Example
    \code{.C}
    vr=5;

    hull()
    {
      for ( p = polygon2d_regular_p( r=20, n=5, vr=vr ) )
        translate( p )
        circle( r=vr );
    }
    \endcode

    See [Wikipedia] for more information.

  [Wikipedia]: https://en.wikipedia.org/wiki/Regular_polygon
*******************************************************************************/
function polygon2d_regular_p
(
  n,
  r,
  a,
  vr,
  cw = true
) =
  let
  (
    s = is_defined(r) ? r
      : is_defined(a) ? a / cos(180/n)
      : 0,

    b = (cw == true) ? [360:-(360/n):1] : [0:(360/n):359]
  )
  [
    for (a = b)
      let( v = [s*cos(a), s*sin(a)] )
      not_defined(vr) ? v : v - vr/cos(180/n) * unit_l(v)
  ];

//! Compute the coordinates of an arc with radius \p r between two vectors in 2D.
/***************************************************************************//**
  \param    r <decimal> The arc radius.
  \param    c <point-2d> The arc center coordinate [x, y].
  \param    v1 <vector-2d> A 2d vector 1. The start angle.
  \param    v2 <vector-2d> A 2d vector 2. The end angle.
  \param    n <integer> The number of arc fragments.
  \param    cw <boolean> Sweep clockwise along arc from the head of vector
            \p v1 to the head of vector \p v2 when \p cw = \b true,
            otherwise sweep counter clockwise.

  \returns  <coords-2d> A list of arc coordinates points [[x, y], ...].

  \details

    The arc coordinates will be at radius \p r centered about \p c
    contained within the heads of vectors \p v1 and \p v2. When vectors
    \p v1 and \p v2 are parallel, the arc will be a complete circle.
    When \p n is not specified, the arc facets are controlled by the
    special variables \p $fa, \p $fs, and \p $fn.
*******************************************************************************/
function polygon2d_arc_p
(
  r  = 1,
  c  = origin2d,
  v1 = x_axis2d_ul,
  v2 = x_axis2d_ul,
  n,
  cw = true
) =
  let
  (
    // number of arc facets
    fn   = is_defined(n) ? n
         : (r < grid_fine) ? 3
         : ($fn > 0.0) ? ($fn >= 3) ? $fn : 3
         : ceil( max( min(360/$fa, r*tau/$fs), 5 ) ),

    // arc starting angle (signed and positive)
    ia_s = angle_ll(x_axis2d_ul, v1),
    ia_p = (ia_s  < 0) ? 360 + ia_s
         : ia_s,

    // angle bwetween vectors (signed and positive)
    va_s = angle_ll(v2, v1),
    va_p = (va_s == 0) ? 360
         : (va_s  < 0) ? 360 + va_s
         : va_s,

    // arc angle sweep sequence cw and ccw
    aas  = (cw == true)
         ? [ia_p : -va_p/fn : ia_p-va_p]
         : [ia_p : (360-va_p)/fn : 360+ia_p-va_p]
  )
  [
    for (a = aas)
      c + r * [cos(a), sin(a)]
  ];

//! Compute the coordinates for a rounded trapezoid in 2D space.
/***************************************************************************//**
  \param    b <decimal-list-2|decimal> The base lengths. A list [b1, b2]
            of 2 decimals or a single decimal for (b1=b2).
  \param    h <decimal> The perpendicular height between bases.
  \param    l <decimal> The left side leg length.
  \param    a <decimal> The angle between the lower base and left leg.
  \param    vr <decimal-list-4|decimal> The vertices rounding radius.
            A list [v1r, v2r, v3r, v4r] of 4 decimals or a single
            decimal for (v1r=v2r=v3r=v4r). Unspecified corners are not
            rounded.
  \param    vrm <integer-list-4|integer> The vertices rounding mode.
            A list [v1rm, v2rm, v3rm,v4rm] of 4 integers or a single
            integer for (v1rm=v2rm=v3rm=v4rm). Unspecified vertices are
            not rounded.
  \param    vfn <integer-list-4> The vertices arc fragment number.
            A list [v1fn, v2fn, v3fn, v4fn] of 4 integers.
  \param    cw <boolean> Polygon vertex ordering.

  \returns  <coords-2d> A list of coordinates points [[x, y], ...]
            that define the rounded trapezoid.

  \details

    When both \p h and \p l are specified, \p h has precedence.
    Each vertex may be assigned one of the available rounding
    \ref polygon2d_vertices_round3_p "modes". See [Wikipedia] for
    more information.

  [Wikipedia]: https://en.wikipedia.org/wiki/Trapezoid
*******************************************************************************/
function polygon2d_trapezoid_p
(
  b = 1,
  h,
  l = 1,
  a = 90,
  vr = 0,
  vrm = 1,
  vfn,
  cw = true
) =
  let
  (
    b1 = edefined_or(b, 0, b),
    b2 = edefined_or(b, 1, b1),

    // trapezoid vertices from origin
    p1 = [0, 0],
    p2 = is_defined(h)
       ? h*[cos(a), 1]
       : l*[cos(a), sin(a)],
    p3 = p2 + [b2, 0],
    p4 = [b1, 0],

    // cw ordering
    c  = [p4, p1, p2, p3],

    pp = polygon2d_vertices_round3_p(c=c, vr=vr, vrm=vrm, vfn=vfn, cw=true)
  )
  (cw == true) ? pp : reverse(pp);

//! @}
//! @}

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
