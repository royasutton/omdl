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
      for ( p = polygon2d_regular_lp( r=20, n=5, vr=vr ) )
        translate( p )
        circle( r=vr );
    }
    \endcode

    See [Wikipedia] for more information.

  [Wikipedia]: https://en.wikipedia.org/wiki/Regular_polygon
*******************************************************************************/
function polygon2d_regular_lp
(
  n,
  r,
  a,
  vr,
  cw = true
) =
[
  let
  (
    s = is_defined(r) ? r
      : is_defined(a) ? a / cos(180/n)
      : 0,

    b = (cw == true) ? [360:-(360/n):1] : [0:(360/n):359]
  )
  for ( a = b )
    let( v = [s*cos(a), s*sin(a)] )
    not_defined(vr) ? v : v - vr/cos(180/n) * unit_l(v)
];

//! Compute the coordinates of an arc with radius \p r between two vectors in 2D.
/***************************************************************************//**
  \param    r <decimal> The arc radius.
  \param    c <point-2d> The arc center coordinate [x, y].
  \param    l1 <line-2d> A 2d line (or vector) 1.
  \param    l2 <line-2d> A 2d line (or vector) 2.
  \param    cw <boolean> Sweep clockwise along arc from the head of vector
            \p l1 to the head of vector \p l2 when \p cw = \b true,
            otherwise sweep counter clockwise.

  \returns  <coords-2d> A list of arc coordinates points [[x, y], ...].

  \details

    The arc coordinates will be at radius \p r centered about \p c
    contained within the heads of vectors \p l1 and \p l2. When vectors
    \p l1 and \p l2 are parallel, the arc will be a complete circle.
*******************************************************************************/
function polygon2d_arc_lp
(
  r,
  c  = origin2d,
  l1 = x_axis2d_ul,
  l2 = x_axis2d_ul,
  cw = true
) =
  let
  (
    // number of arc segments
    ns   = (r < grid_fine) ? 3
         : ($fn > 0.0) ? ($fn >= 3) ? $fn : 3
         : ceil( max( min(360/$fa, r*tau/$fs), 5 ) ),

    // arc starting angle (signed and positive)
    ia_s = angle_ll(x_axis2d_ul, l1),
    ia_p = (ia_s  < 0) ? 360 + ia_s
         : ia_s,

    // angle bwetween vectors (signed and positive)
    va_s = angle_ll(l2, l1),
    va_p = (va_s == 0) ? 360
         : (va_s  < 0) ? 360 + va_s
         : va_s,

    // arc angle sweep sequence cw and ccw
    aas  = (cw == true)
         ? [ia_p : -va_p/ns : ia_p-va_p]
         : [ia_p : (360-va_p)/ns : 360+ia_p-va_p]
  )
  [
    for (a = aas)
      c + r * [cos(a), sin(a)]
  ];

//! @}
//! @}

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
