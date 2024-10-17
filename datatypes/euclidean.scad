//! Tests and operations for Euclidean 3d space.
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

    \amu_define group_name  (Euclidean)
    \amu_define group_brief (Tests and operations for Euclidean 3d space.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// validation.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/validate_log_th.amu)
  \amu_include (include/amu/validate_log_td.amu)
  \amu_include (include/amu/validate_results.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_include (include/amu/includes_required.amu)

  \details

  \amu_include (include/amu/validate_summary.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
// set 1: identify
//----------------------------------------------------------------------------//

//! Test if a value defines a point.
/***************************************************************************//**
  \param    v <list-2d | list-3d> A 2d or 3d list of numbers.

  \returns  (1) <boolean> \b true when the \p v can be interpreted as a
                point and \b false otherwise.

  \details

    See \ref dt_line for argument specification and conventions.
*******************************************************************************/
function is_point
(
  v
) = !is_list(v) ? false
  : !all_numbers(v) ? false
  : !is_between(len(v), 2, 3) ? false
  : true;

//! Test if a value defines a Euclidean vector.
/***************************************************************************//**
  \param    v <list-2d | list-3d> A 2d or 3d list of numbers.

  \returns  (1) <boolean> \b true when the \p v can be interpreted as a
                Euclidean vector and \b false otherwise.

  \details

    See \ref dt_line for argument specification and conventions.
*******************************************************************************/
function is_vector
(
  v
) = !is_list(v) ? false
  : (len(v) == 1) && !is_point(v[0]) ? false
  : !is_point(v) ? false
  : true;

//! Test if a value defines a line.
/***************************************************************************//**
  \param    v <list-2d | list-3d> A 2d or 3d list of numbers.

  \returns  (1) <boolean> \b true when the \p v can be interpreted as a
                line and \b false otherwise.

  \details

    See \ref dt_line for argument specification and conventions.
*******************************************************************************/
function is_line
(
  v
) = !is_list(v) ? false
  : (len(v) != 2) ? false
  : !is_point(v[0]) ? false
  : !is_point(v[1]) ? false
  : (len(v[0]) != len(v[1])) ? false
  : true;

//! Test if a value defines a vector or a line.
/***************************************************************************//**
  \param    v <list-2d | list-3d> A 2d or 3d list of numbers.

  \returns  (1) <boolean> \b true when the \p v can be interpreted as a
                vector or a line and \b false otherwise.

  \details

    See \ref dt_line for argument specification and conventions.
*******************************************************************************/
function is_vol
(
  v
) = is_vector(v) ? true
  : is_line(v) ? true
  : false;

//! Test if a value defines a plane.
/***************************************************************************//**
  \param    v <list-2d | list-3d> A 2d or 3d list of numbers.

  \returns  (1) <boolean> \b true when the \p v can be interpreted as a
                plane and \b false otherwise.

  \details

    See \ref dt_line for argument specification and conventions.
*******************************************************************************/
function is_plane
(
  v
    // predetermined normal vector
) = is_vector(v) ? true

    // intersecting vectors [v1, v2] like line.
  : is_line(v) ? true

    // otherwise, 3 points of same dimension.
  : !is_list(v) ? false
  : (len(v) != 3) ? false
  : !is_point(v[0]) ? false
  : !is_point(v[1]) ? false
  : !is_point(v[2]) ? false
  : (len(v[0]) != len(v[1])) ? false
  : (len(v[1]) != len(v[2])) ? false
  : true;

//----------------------------------------------------------------------------//
// set 2: point
//----------------------------------------------------------------------------//

//! Compute the distance between two points.
/***************************************************************************//**
  \param    p1 <point> A point coordinate 1.
  \param    p2 <point> A point coordinate 2.

  \returns  (1) <decimal> The distance between the two points.
            (2) Returns \b undef when \p p1 or \p p2 are not points or
                do not have equal dimensions.

  \details

    When \p p2 is not given, it is assumed to be at the origin. This
    function is similar to [norm].

  [norm]: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Mathematical_Functions#norm
*******************************************************************************/
function distance_pp
(
  p1,
  p2
) = !is_point(p1) ? undef
  : !is_undef(p2) && !is_point(p2) ? undef
  :  is_undef(p2) ?
        sqrt(sum([for (i=[0:len(p1)-1]) p1[i]*p1[i]]))
      : sqrt(sum([for (i=[0:len(p1)-1]) (p1[i]-p2[i])*(p1[i]-p2[i])]));

//! Compute the shortest distance between a point and a line.
/***************************************************************************//**
  \param    p <point> A point coordinate.
  \param    l <line> A line or vector.

  \returns  (1) <decimal> The shortest distance between the point and
                the line.
            (2) Returns \b undef when \p p is not a point or \p l is
                not a line.

  \details

  \sa point_closest_pl().
*******************************************************************************/
function distance_pl
(
  p,
  l
) = distance_pp(p, point_closest_pl(p, l));

//! Compute the shortest distance between a point and a plane.
/***************************************************************************//**
  \param    p <point> A point coordinate.
  \param    n <pnorm> A plane normal [specification].
  \param    np <point> A point coordinate on the plane \p n.

  \returns  (1) <decimal> The shortest distance between the point and
                the plane.
            (2) Returns \b undef when \p p is not a point or \p l is
                not a line.

  \details

  \sa point_closest_pn().

  [specification]: \ref dt_pnorm
*******************************************************************************/
function distance_pn
(
  p,
  n,
  np
) = distance_pp(p, point_closest_pn(p, n, np));

//! Test if a point is left, on, or right of an infinite line in a 2d-space.
/***************************************************************************//**
  \param    p1 <point-2d> A 2d point coordinate 1.
  \param    p2 <point-2d> A 2d point coordinate 2.
  \param    p3 <point-2d> A 2d point coordinate 3.

  \returns  (1) <decimal> (\b > 0) for \p p3 \em left of the line
                through \p p1 and \p p2, (\b = 0) for p3  \em on the
                line, and (\b < 0) for p3  right of the line.
            (2) Returns \b undef when \p p1, \p p2, or \p p3 is not a
                point.

  \details

    Function patterned after [Dan Sunday, 2012].

    [Dan Sunday, 2012]: http://geomalgorithms.com/a01-_area.html
*******************************************************************************/
function is_left_ppp
(
  p1,
  p2,
  p3
) = !is_point(p1) ? undef
  : !is_point(p2) ? undef
  : !is_point(p3) ? undef
  : ((p2[0]-p1[0]) * (p3[1]-p1[1]) - (p3[0]-p1[0]) * (p2[1]-p1[1]));

//! Compute the coordinates of the closest point on a line to a given point.
/***************************************************************************//**
  \param    p <point> A point coordinate.
  \param    l <line> A line or vector.

  \returns  (1) <point-3d> The coordinates of the point on the line
                closest to the given point.
            (2) Returns \b undef when \p p is not a point or \p l is
                not a line.
*******************************************************************************/
function point_closest_pl
(
  p,
  l
) = !is_point(p) ? undef
  : !is_line(l) ? undef
  : let
    (
      t = line_tp(l),
      i = line_ip(l),

      v = t - i,
      w = p - i,

      x = (w * v) / (v * v)
    )
    i + x * v;

//! Compute the coordinates of the closest point on a plane to a given point.
/***************************************************************************//**
  \param    p <point> A point coordinate.
  \param    n <pnorm> A plane normal [specification].
  \param    np <point> A point coordinate on the plane \p n.

  \returns  (1) <point-3d> The coordinates of the point on the plane
                closest to the given point.
            (2) Returns \b undef when \p p or \p np is not a point or
                when \p n is not a plane.

  [specification]: \ref dt_pnorm
*******************************************************************************/
function point_closest_pn
(
  p,
  n,
  np
) = !is_point(p) ? undef
  : !is_plane(n) ? undef
  : !is_point(np) ? undef
  : let
    (
      m = plane_to_normal(n),

      q = m * (np - p),
      r = m * m,

      s = q / r
    )
    p + s * m;

//! Return 3d point unchanged or add a zeroed third dimension to 2d point.
/***************************************************************************//**
  \param    p <point-3d | point-2d> A point.

  \returns  (1) <point-3d> The 3d point or the 2d point converted to 3d
                with its third dimension assigned zero.
            (2) Returns \b undef when \p p is not a point.

  \details

    This function assumes any point that is not 3d to be 2d.
*******************************************************************************/
function point_to_3d
(
  p
) = !is_point(p) ? undef
  : (len(p) == 3) ? p : [p[0], p[1], 0];

//! Linearly interpolate along a line established by two points in 2d.
/***************************************************************************//**
  \param    p1 <point-2d> The line initial coordinate [x, y].
  \param    p2 <point-2d> The line terminal coordinate [x, y].

  \param    y <decimal> The \p y coordinate at which to interpolate
              along the line.
  \param    x <decimal> The \p x coordinate at which to interpolate
              along the line.

  \returns  (1) <point-2d> The interpolated coordinates point [x, y].
            (2) Returns \b undef when \p p1 or \p p2 is not a point or
                when \p x or \p y are not numbers.

  \details

    The order of precedence for interpolation is: \p y, \p x. See
    [Wikipedia] for more information.

  [Wikipedia]: https://en.wikipedia.org/wiki/Linear_interpolation
*******************************************************************************/
function interpolate2d_l_pp
(
  p1,
  p2,
  x,
  y
) = !is_point(p1) ? undef
  : !is_point(p1) ? undef

    // 'y' is given, get 'lx' for given 'y'
  : !is_undef(y) && !is_number(y) ? undef
  : !is_undef(y) ?
    let( lx = (p1[0]*(p2[1]-y) + p2[0]*(y-p1[1])) / (p2[1]-p1[1]) )
    [lx, y]

    // 'y' not given, get 'ly' for given 'x'
  : !is_number(x) ? undef
  : let( ly = (p1[1]*(p2[0]-x) + p2[1]*(x-p1[0])) / (p2[0]-p1[0]) )
    [x, ly];

//----------------------------------------------------------------------------//
// set 3: vector
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
// set 4: line (or vector)
//----------------------------------------------------------------------------//

//! Construct a 2 dimensional directed line.
/***************************************************************************//**
  \param    m <decimal> The magnitude.
  \param    a <decimal> The azmuthal angle.
  \param    p1 <point-2d> The initial point.
  \param    p2 <point-2d> The terminal point.
  \param    v <vector-2d> An orientation line or vector.

  \returns  (1) <line-2d> The 2d directed line.
            (2) Returns \b undef when required parameters are not
                defined.

  \details

    The initial point (or tail) of the line is specified by \p p1. The
    terminal point (or head) can be specified by one of, in order of
    precedence, \p p2, \p v, or \p a.

    See \ref dt_line for argument specification and conventions.
*******************************************************************************/
function line2d_new
(
  m = 1,
  a = 0,
  p1 = origin2d,
  p2,
  v
) = !is_point(p1) ? undef

    // using 'p2' ('p1')
  : !is_undef(p2) ? !is_point(p2) ? undef
      : [p1, p2]

    // using 'v' ('p1' and 'm')
  : !is_number(m) ? undef
  : !is_undef(v) ? !is_vol(v) ? undef
      : [p1, p1 + m*unit_l(v)]

    // using 'a' ('p1' and 'm')
  : !is_number(a) ? undef
      : [p1, p1 + m*[cos(a), sin(a)]];

//! Construct a 3 dimensional directed line.
/***************************************************************************//**
  \param    m <decimal> The magnitude.
  \param    a <decimal> The azmuthal angle.
  \param    t <decimal> The polar angle.
  \param    p1 <point-3d> The initial point.
  \param    p2 <point-3d> The terminal point.
  \param    v <vector-3d> An orientation line or vector.

  \returns  (1) <line-3d> The 3d directed line.
            (2) Returns \b undef when required parameters are not
                defined.

  \details

    The initial point (or tail) of the line is specified by \p p1. The
    terminal point (or head) can be specified by one of, in order of
    precedence, \p p2, \p v, or \p a and \p t.

    See \ref dt_line for argument specification and conventions.
*******************************************************************************/
function line3d_new
(
  m = 1,
  a = 0,
  t = 90,
  p1 = origin3d,
  p2,
  v
) = !is_point(p1) ? undef

    // using 'p2' ('p1')
  : !is_undef(p2) ? !is_point(p2) ? undef
      : [p1, p2]

    // using 'v' ('p1' and 'm')
  : !is_number(m) ? undef
  : !is_undef(v) ? !is_vol(v) ? undef
      : [p1, p1 + m*unit_l(v)]

    // using 'a' and 't' ('p1' and 'm')
  : (!is_number(a) || !is_number(t)) ? undef
      : [p1, p1 + m*[sin(t)*cos(a), sin(t)*sin(a), cos(t)]];

//! Construct a directed line.
/***************************************************************************//**
  \param    m <decimal> The magnitude.
  \param    a <decimal> The azmuthal angle.
  \param    t <decimal> The polar angle.
  \param    p1 <point> The initial point.
  \param    p2 <point> The terminal point.
  \param    v <vector> An orientation line or vector.

  \returns  (1) <line> The directed line.
            (2) Returns \b undef when required parameters are not
                defined.

  \details

    The initial point (or tail) of the line is specified by \p p1. The
    terminal point (or head) can be specified by one of, in order of
    precedence, \p p2, \p v, or \p a and \p t.

    This function will construct a 2d or 3d line as required based on
    the supplied arguments. A 3d line is constructed only when
    required. Because the argument dimensions are inspected, this
    function has more overhead when compared to line2d_new() and
    line3d_new().

    See \ref dt_line for argument specification and conventions.
*******************************************************************************/
function line_new
(
  m = 1,
  a = 0,
  t,
  p1,
  p2,
  v
    // using 'p2'
) = !is_undef(p2) ? !is_point(p2) ? undef
      : let
        (
          pd = !is_undef(p1) ? p1
             : (len(p2) == 2) ? origin2d : origin3d
        )
        [pd, p2]

    // using 'v' ('m')
  : !is_number(m) ? undef
  : !is_undef(v) ? !is_vol(v) ? undef
      : let
        (
          pd = !is_undef(p1) ? p1
             : (len(v) == 2) ? origin2d : origin3d
        )
        [pd, pd + m*unit_l(v)]

    // using 'a' ('m')
  : is_undef(t) ? !is_number(a) ? undef
      : let
        (
          pd = !is_undef(p1) ? p1 : origin2d
        )
        [pd, pd + m*[cos(a), sin(a)]]

    // using 'a' and 't' ('m')
  : (!is_number(a) || !is_number(t)) ? undef
      : let
        (
          pd = !is_undef(p1) ? p1 : origin3d
        )
        [pd, pd + m*[sin(t)*cos(a), sin(t)*sin(a), cos(t)]];

//! Return the number of dimensions of a line or vector.
/***************************************************************************//**
  \param    l <line> A line or vector.

  \returns  (1) <integer> The line or vector dimensions.
            (2) Returns \b undef when \p l is not a line or vector.

  \details

    See \ref dt_line for argument specification and conventions.
*******************************************************************************/
function line_dim
(
  l
) = is_vector(l) ? (len(l) == 1) ? len( l[0] ) : len( l )
  : is_line(l) ? len( l[0] )
  : undef;

//! Return the terminal point of a line or vector.
/***************************************************************************//**
  \param    l <line> A line or vector.

  \returns  (1) <point> The terminal point of the line or vector.
            (2) Returns \b undef when \p l is not a line or vector.

  \details

    See \ref dt_line for argument specification and conventions.
*******************************************************************************/
function line_tp
(
  l
) = is_vector(l) ? (len(l) == 1) ? l[0] : l
  : is_line(l) ? l[1]
  : undef;

//! Return the initial point of a line or vector.
/***************************************************************************//**
  \param    l <line> A line or vector.

  \returns  (1) <point> The initial point of the line or vector.
            (2) Returns \b undef when \p l is not a line or vector.

  \details

    See \ref dt_line for argument specification and conventions.
*******************************************************************************/
function line_ip
(
  l
) = is_vector(l) ?
    let
    (
      d = (len(l) == 1) ? len(l[0]) : len(l)
    )
    consts(d, 0)
  : is_line(l) ? l[0]
  : undef;

//! Convert line to vector by shifting it to the origin.
/***************************************************************************//**
  \param    l <line> A line or vector.

  \returns  (1) <vector> The line shifted to the origin.
            (2) Returns \b undef when \p l is not a line or vector.

  \details

    See \ref dt_line for argument specification and conventions.
*******************************************************************************/
function vol_to_origin
(
  l
) = is_vector(l) ? (len(l) == 1) ? l[0] : l
  : !is_line(l) ? undef
  : (len(l) == 1) ? l[0]
  : (len(l) == 2) ? (l[1]-l[0])
  : undef;

//! Convert a vector to a line or move a line to another coordinate point.
/***************************************************************************//**
  \param    l <line> A line or vector.
  \param    p <point> The new initial point.

  \returns  (1) <line> The line or vector moved to \p p.
            (2) Returns \b undef when \p l is not a line or vector or
                when \p p is not a point.

  \details

    When \p p is not specified, the line or vector is moved to the
    origin.

    See \ref dt_line for argument specification and conventions.
*******************************************************************************/
function vol_to_point
(
  l,
  p
) = !is_line(l) ? undef
  : !is_undef(p) && !is_point(p) ? undef
  : let
    (
      d = !is_undef(p) ? p
                       : (line_dim(l) == 2) ? origin2d
                                            : origin3d
    )
    [d, d + vol_to_origin(l)];

//! Compute the dot product of two lines or vectors in a 3d or 2d-space.
/***************************************************************************//**
  \param    l1 <line-3d | line-2d> A 3d or 2d line or vector 1.
  \param    l2 <line-3d | line-2d> A 3d or 2d line or vector 2.

  \returns  (1) <decimal> The dot product of \p l1 with \p l2.
            (2) Returns \b undef when \p l1 or \p l2 is not a line or
                vector or have different dimensions.

  \details

    This function supports the abstraction outlined in \ref dt_line.
    The built-in operation will be more efficient in situations that do
    not make use of this abstraction.

    See \ref dt_line for argument specification and conventions. See
    [Wikipedia] for more information.

    [Wikipedia]: https://en.wikipedia.org/wiki/Dot_product
*******************************************************************************/
function dot_ll
(
  l1,
  l2
) = !is_vol(l1) ? undef
  : !is_vol(l2) ? undef
  : (len(l1) != len(l2)) ? undef
  : (vol_to_origin(l1) * vol_to_origin(l2));

//! Compute the cross product of two lines or vectors in a 3d or 2d-space.
/***************************************************************************//**
  \param    l1 <line-3d | line-2d> A 3d or 2d line or vector 1.
  \param    l2 <line-3d | line-2d> A 3d or 2d line or vector 2.

  \returns  (1) <decimal | vector-2d> The cross product of \p l1 with
                \p l2.
            (2) Returns \b undef when \p l1 or \p l2 is not a line or
                vector or have different dimensions.

  \details

    This function supports the abstraction outlined in \ref dt_line.
    The built-in operation will be more efficient in situations that do
    not make use of the aforementioned abstraction.

    See \ref dt_line for argument specification and conventions. See
    Wikipedia [cross] and [determinant] for more information.

  \note     This function returns the 2x2 determinant for 2d vectors.

  [cross]: https://en.wikipedia.org/wiki/Cross_product
  [determinant]: https://en.wikipedia.org/wiki/Determinant
*******************************************************************************/
function cross_ll
(
  l1,
  l2
) = !is_vol(l1) ? undef
  : !is_vol(l2) ? undef
  : (len(l1) != len(l2)) ? undef
  : cross(vol_to_origin(l1), vol_to_origin(l2));

//! Compute the scalar triple product of three lines or vectors in a 3d or 2d-space.
/***************************************************************************//**
  \param    l1 <line-3d | line-2d> A 3d or 2d line or vector 1.
  \param    l2 <line-3d | line-2d> A 3d or 2d line or vector 2.
  \param    l3 <line-3d | line-2d> A 3d or 2d line or vector 3.

  \returns  (1) <decimal | vector-2d> The scalar triple product.
            (2) Returns \b undef when \p l1, \p l2, or \p l3 is not a
                line or vector or have different dimensions,

  \details

    Returns a 2d vector result for 2d vectors. The cross product
    computes the 2x2 determinant of the vectors <tt>(l2 x l3)</tt>, a
    scalar value, which is then \e multiplied by \c l1.

    \verbatim
    [l1, l2, l3] = l1 * (l2 x l3)
    \endverbatim

    See \ref dt_line for argument specification and conventions. See
    [Wikipedia] for more information.

  [Wikipedia]: https://en.wikipedia.org/wiki/Triple_product
*******************************************************************************/
function striple_lll
(
  l1,
  l2,
  l3
) = !is_vol(l1) ? undef
  : !is_vol(l2) ? undef
  : !is_vol(l3) ? undef
  : (len(l1) != len(l2)) ? undef
  : (len(l2) != len(l3)) ? undef
  : (vol_to_origin(l1) * cross_ll(l2, l3));

//! Compute the angle between two lines or vectors in a 3d or 2d-space.
/***************************************************************************//**
  \param    l1 <line-3d | line-2d> A 3d or 2d line or vector 1.
  \param    l2 <line-3d | line-2d> A 3d or 2d line or vector 2.
  \param    s <boolean> Return the 2d signed angle.

  \returns  (1) <decimal> The angle between the two lines or vectors in
                degrees.
            (2) Returns \b undef when \p l1 or \p l2 is not a line or
                vector or have different dimensions or when they do not
                intersect.

  \details

    For 2d lines or vectors, the signed angle is calculated. The
    parameter \p s determines if the \em signed (\p s == \b true) or
    \em positive (\p s == \b false) angle is returned. For 3d lines or
    vectors, a normal is required to uniquely identify the
    perpendicular plane and axis of rotation. This function calculates
    the positive angle, and the plane and axis of rotation will be that
    which fits this assumed positive angle.

    See \ref dt_line for argument specification and conventions.

  \sa angle_lll().
*******************************************************************************/
function angle_ll
(
  l1,
  l2,
  s = true
) = !is_vol(l1) ? undef
  : !is_vol(l2) ? undef
  : let
    (
      d = line_dim(l1) + line_dim(l2)
    )
    // two 2d
    (d == 4) ?
        let
        (
          sa = atan2(cross_ll(l1, l2), dot_ll(l1, l2))
        )
        ((sa < 0) && (s == false)) ? sa+360
                                   : sa
    // two 3d
  : (d == 6) ?
        atan2(distance_pp(cross_ll(l1, l2)), dot_ll(l1, l2))
  : undef;

//! Compute the angle between two lines or vectors in a 3d-space.
/***************************************************************************//**
  \param    l1 <line-3d> A 3d line or vector 1.
  \param    l2 <line-3d> A 3d line or vector 2.
  \param    n <line-3d> A 3d normal line or vector.

  \returns  (1) <decimal> The angle between the two lines or vectors in
                degrees.
            (2) Returns \b undef when \p l1, \p l2, or \p n is not a
                line or vector or have different dimensions or when
                they do not intersect.

  \details

    See \ref dt_line for argument specification and conventions.

  \sa angle_ll().
*******************************************************************************/
function angle_lll
(
  l1,
  l2,
  n
) = !is_vol(l1) ? undef
  : !is_vol(l2) ? undef
  : !is_vol(n) ? undef
  : (len(l1) != len(l2)) ? undef
  : (len(l2) != len(n)) ? undef
  : atan2(striple_lll(n, l1, l2), dot_ll(l1, l2));

//! Compute the normalized unit vector of a line or vector.
/***************************************************************************//**
  \param    l <line> A line or vector.

  \returns  (1) <vector> The normalized unit vector.
            (2) Returns \b undef when \p l is not a line or vector.

  \details

    See \ref dt_line for argument specification and conventions.
*******************************************************************************/
function unit_l
(
  l
) = !is_vol(l) ? undef
  : vol_to_origin(l) / distance_pp(vol_to_origin(l));

//! Test if three lines or vectors are coplanar in 3d-space.
/***************************************************************************//**
  \param    l1 <line-3d> A 3d line or vector 1.
  \param    l2 <line-3d> A 3d line or vector 2.
  \param    l3 <line-3d> A 3d line or vector 3.
  \param    d <integer> The number of decimal places to consider.

  \returns  (1) <boolean> \b true when all three lines or vectors are
                coplanar, and \b false otherwise.
            (2) Returns \b undef when \p l1, \p l2, or \p l3 is not a
                line or vector or have different dimensions,

  \details

    See \ref dt_line for argument specification and conventions. See
    [Wikipedia] for more information.

  \note     When lines or vectors are specified with start and end
            points, this function tests if they are in a planes
            parallel to the coplanar.

  [Wikipedia]: https://en.wikipedia.org/wiki/Coplanarity
*******************************************************************************/
function are_coplanar_lll
(
  l1,
  l2,
  l3,
  d = 6
) = !is_vol(l1) ? undef
  : !is_vol(l2) ? undef
  : !is_vol(l3) ? undef
  : (len(l1) != len(l2)) ? undef
  : (len(l2) != len(l3)) ? undef
  : (round_d(striple_lll(l1, l2, l3), d) ==  0);

//----------------------------------------------------------------------------//
// set 5: plane and pnorm
//----------------------------------------------------------------------------//

//! Convert a planes' normal specification into a normal vector.
/***************************************************************************//**
  \param    n <pnorm> A plane normal [specification].

  \param    cw <boolean> Point ordering. When the plane specified as
            non-collinear points, this indicates ordering.

  \returns  (1) <normal> A vector-3d normal to the plane.
            (2) Returns \b undef when \p n is not a plane.

  \details

    When \p n is not a valid plane, \b undef is returned. The computed
    normal vector is not normalized to its unit vector.

    See \ref dt_pnorm for argument specification and conventions.

  [specification]: \ref dt_pnorm
*******************************************************************************/
function plane_to_normal
(
  n,
  cw = true
) = !is_plane(n) ? undef

    // n is normal
  : is_vector(n) ? point_to_3d(vol_to_origin(n))

    // make 3d
  : let
    (
      q = [for (i=n) point_to_3d(i)]
    )
    (len(n) == 2) ?
        // vectors [v1, v2].
        cross(q[0], q[1])

        // 3 points.
      : cross(q[0]-q[1], q[2]-q[1]) * ((cw == true) ? 1 : -1);

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

    // test-values columns
    test_c =
    [
      ["id", "identifier"],
      ["td", "description"],
      ["tv", "test value"]
    ];

    // test-values rows
    test_r =
    [
      ["fac", "Function argument count",    undef
      ],
      ["crp", "Result precision",           undef
      ],
      ["t01", "All undefined",              [undef,undef,undef,undef,undef,undef]
      ],
      ["t02", "All empty lists",            [empty_lst,empty_lst,empty_lst,empty_lst,empty_lst,empty_lst]
      ],
      ["t03", "All scalars",                [60, 50, 40, 30, 20, 10]
      ],
      ["t04", "All 1d vectors",             [[99], [58], [12], [42], [15], [1]]
      ],
      ["t05", "All 2d vectors",             [
                                              [99,2], [58,16], [12,43],
                                              [42,13], [15,59], [1,85]
                                            ]
      ],
      ["t06", "All 3d vectors",             [
                                              [199,20,55], [158,116,75], [12,43,90],
                                              [42,13,34], [15,59,45], [62,33,69]
                                            ]
      ],
      ["t07", "All 4d vectors",             [
                                              [169,27,35,10], [178,016,25,20], [12,43,90,30],
                                              [42,13,34,60], [15,059,45,50], [62,33,69,40]
                                            ]
      ],
      ["t08", "Orthogonal vectors",         [
                                              +x_axis3d_uv, +y_axis3d_uv, +z_axis3d_uv,
                                              -x_axis3d_uv, -y_axis3d_uv, -z_axis3d_uv,
                                            ]
      ],
      ["t09", "Coplanar vectors",           [
                                              +x_axis3d_uv, +y_axis3d_uv, [2,2,0],
                                              origin3d, origin3d, origin3d,
                                            ]
      ]
    ];

    test_ids = table_get_row_ids( test_r );

    // expected columns: ("id" + one column for each test)
    good_c = merge_p([concat("id", test_ids), concat("identifier", test_ids)]);

    // expected rows: ("golden" test results), use 'skip' to skip test
    skip = -1;  // skip test

    good_r =
    [ // function
      ["distance_pp",
        2,                                                  // fac
        4,                                                  // crp
        undef,                                              // t01
        undef,                                              // t02
        undef,                                              // t03
        undef,                                              // t04
        43.3244,                                            // t05
        106.2873,                                           // t06
        undef,                                              // t07
        1.4142,                                             // t08
        1.4142                                              // t09
      ],
      ["is_left_ppp",
        3,                                                  // fac
        4,                                                  // crp
        undef,                                              // t01
        undef,                                              // t02
        undef,                                              // t03
        undef,                                              // t04
        -463,                                               // t05
        17009,                                              // t06
        undef,                                              // t07
        1,                                                  // t08
        -3                                                  // t09
      ],
      ["point_to_3d",
        1,                                                  // fac
        4,                                                  // crp
        undef,                                              // t01
        undef,                                              // t02
        undef,                                              // t03
        undef,                                              // t04
        [99,2,0],                                           // t05
        [199,20,55],                                        // t06
        undef,                                              // t07
        x_axis3d_uv,                                        // t08
        x_axis3d_uv                                         // t09
      ],
      ["line_dim",
        2,                                                  // fac
        4,                                                  // crp
        undef,                                              // t01
        undef,                                              // t02
        2,                                                  // t03
        undef,                                              // t04
        2,                                                  // t05
        3,                                                  // t06
        undef,                                              // t07
        3,                                                  // t08
        3                                                   // t09
      ],
      ["line_tp",
        2,                                                  // fac
        4,                                                  // crp
        undef,                                              // t01
        undef,                                              // t02
        [60,50],                                            // t03
        undef,                                              // t04
        [58,16],                                            // t05
        [158,116,75],                                       // t06
        undef,                                              // t07
        y_axis3d_uv,                                        // t08
        y_axis3d_uv                                         // t09
      ],
      ["line_ip",
        2,                                                  // fac
        4,                                                  // crp
        undef,                                              // t01
        undef,                                              // t02
        origin2d,                                           // t03
        undef,                                              // t04
        [99,2],                                             // t05
        [199,20,55],                                        // t06
        undef,                                              // t07
        x_axis3d_uv,                                        // t08
        x_axis3d_uv                                         // t09
      ],
      ["vol_to_origin",
        2,                                                  // fac
        4,                                                  // crp
        undef,                                              // t01
        undef,                                              // t02
        [60,50],                                            // t03
        undef,                                              // t04
        [-41,14],                                           // t05
        [-41,96,20],                                        // t06
        undef,                                              // t07
        [-1,1,0],                                           // t08
        [-1,1,0]                                            // t09
      ],
      ["dot_ll",
        4,                                                  // fac
        4,                                                  // crp
        undef,                                              // t01
        undef,                                              // t02
        3900,                                               // t03
        undef,                                              // t04
        -1650,                                              // t05
        -5230,                                              // t06
        undef,                                              // t07
        1,                                                  // t08
        0                                                   // t09
      ],
      ["cross_ll",
        4,                                                  // fac
        4,                                                  // crp
        skip,                                               // t01
        skip,                                               // t02
        skip,                                               // t03
        skip,                                               // t04
        810,                                                // t05
        [-4776,-1696,-1650],                                // t06
        skip,                                               // t07
        [-1,-1,1],                                          // t08
        [0,0,4]                                             // t09
      ],
      ["striple_lll",
        6,                                                  // fac
        4,                                                  // crp
        skip,                                               // t01
        skip,                                               // t02
        skip,                                               // t03
        skip,                                               // t04
        [-14760,5040],                                      // t05
        -219976,                                            // t06
        skip,                                               // t07
        -2,                                                 // t08
        0                                                   // t09
      ],
      ["angle_ll",
        4,                                                  // fac
        4,                                                  // crp
        undef,                                              // t01
        undef,                                              // t02
        -2.9357,                                            // t03
        undef,                                              // t04
        153.8532,                                           // t05
        134.4573,                                           // t06
        undef,                                              // t07
        60,                                                 // t08
        90                                                  // t09
      ],
      ["angle_lll",
        6,                                                  // fac
        4,                                                  // crp
        skip,                                               // t01
        skip,                                               // t02
        skip,                                               // t03
        skip,                                               // t04
        skip,                                               // t05
        -91.362,                                            // t06
        skip,                                               // t07
        -63.4349,                                           // t08
        0                                                   // t09
      ],
      ["unit_l",
        2,                                                  // fac
        4,                                                  // crp
        undef,                                              // t01
        undef,                                              // t02
        [.7682,0.6402],                                     // t03
        undef,                                              // t04
        [-0.9464,0.3231],                                   // t05
        [-0.3857,0.9032,0.1882],                            // t06
        undef,                                              // t07
        [-0.7071,0.7071,0],                                 // t08
        [-0.7071,0.7071,0]                                  // t09
      ],
      ["are_coplanar_lll",
        6,                                                  // fac
        4,                                                  // crp
        skip,                                               // t01
        skip,                                               // t02
        skip,                                               // t03
        skip,                                               // t04
        skip,                                               // t05
        false,                                              // t06
        skip,                                               // t07
        false,                                              // t08
        true                                                // t09
      ],
      ["plane_to_normal",
        2,                                                  // fac
        4,                                                  // crp
        skip,                                               // t01
        skip,                                               // t02
        [60,50,0],                                          // t03
        skip,                                               // t04
        [0,0,1468],                                         // t05
        [-4880,-6235,19924],                                // t06
        skip,                                               // t07
        z_axis3d_uv,                                        // t08
        z_axis3d_uv                                         // t09
      ]
    ];

    // sanity-test tables
    table_check( test_r, test_c, false );
    table_check( good_r, good_c, false );

    // validate helper function and module
    function get_value( vid ) = table_get_value(test_r, test_c, vid, "tv");
    function gv( vid, e ) = get_value( vid )[e];
    module log_test( m ) { log_type ( "test", m ); }
    module log_skip( f ) { log_test ( str("ignore: '", f, "'") ); }
    module run( fname, vid )
    {
      value_text = table_get_value(test_r, test_c, vid, "td");

      if ( table_get_value(good_r, good_c, fname, vid) != skip )
        children();
      else
        log_test( str(vid, " -skip-: '", fname, "(", value_text, ")'") );
    }
    module test( fname, fresult, vid, pair )
    {
      value_text = table_get_value(test_r, test_c, vid, "td");
      fname_argc = table_get_value(good_r, good_c, fname, "fac");
      comp_prcsn = table_get_value(good_r, good_c, fname, "crp");
      pass_value = table_get_value(good_r, good_c, fname, vid);

      test_pass = validate(cv=fresult, t="almost", ev=pass_value, p=comp_prcsn, pf=true);
      farg_text = (pair == true)
                ? strl(append_e(", ", sequence_ns(select_r(get_value(vid), [0:fname_argc-1]), n=2, s=2), r=false, j=false, l=false))
                : strl(append_e(", ", select_r(get_value(vid), [0:fname_argc-1]), r=false, j=false, l=false));
      test_text = validate(str(fname, "(", farg_text, ")=", pass_value), fresult, "almost", pass_value, comp_prcsn);

      if ( pass_value != skip )
      {
        if ( !test_pass )
          log_test( str(vid, " ", test_text, " (", value_text, ")") );
        else
          log_test( str(vid, " ", test_text) );
      }
      else
        log_test( str(vid, " -skip-: '", fname, "(", value_text, ")'") );
    }

    // Indirect function calls would be very useful here!!!
    run_ids = delete( test_ids, mv=["fac", "crp"] );

    // set 1: identify
    log_skip( "is_point()" );
    log_skip( "is_vector()" );
    log_skip( "is_line()" );
    log_skip( "is_vol()" );
    log_skip( "is_plane()" );

    // set 2: point
    for (vid=run_ids) run("distance_pp",vid) test( "distance_pp", distance_pp(gv(vid,0),gv(vid,1)), vid, false );
    log_skip( "distance_pl()" );
    log_skip( "distance_pn()" );
    for (vid=run_ids) run("is_left_ppp",vid) test( "is_left_ppp", is_left_ppp(gv(vid,0),gv(vid,1),gv(vid,2)), vid, false );
    log_skip( "point_closest_pl()" );
    log_skip( "point_closest_pn()" );
    for (vid=run_ids) run("point_to_3d",vid) test( "point_to_3d", point_to_3d(gv(vid,0)), vid, false );
    log_skip( "interpolate2d_l_pp()" );

    // set 3: vector

    // set 4: line (or vector)
    log_skip( "line2d_new()" );
    log_skip( "line3d_new()" );
    log_skip( "line_new()" );
    for (vid=run_ids) run("line_dim",vid) test( "line_dim", line_dim([gv(vid,0),gv(vid,1)]), vid, true );
    for (vid=run_ids) run("line_tp",vid) test( "line_tp", line_tp([gv(vid,0),gv(vid,1)]), vid, true );
    for (vid=run_ids) run("line_ip",vid) test( "line_ip", line_ip([gv(vid,0),gv(vid,1)]), vid, true );
    for (vid=run_ids) run("vol_to_origin",vid) test( "vol_to_origin", vol_to_origin([gv(vid,0),gv(vid,1)]), vid, true );
    log_skip( "vol_to_point()" );
    for (vid=run_ids) run("dot_ll",vid) test( "dot_ll", dot_ll([gv(vid,0),gv(vid,1)],[gv(vid,2),gv(vid,3)]), vid, true );
    for (vid=run_ids) run("cross_ll",vid) test( "cross_ll", cross_ll([gv(vid,0),gv(vid,1)],[gv(vid,2),gv(vid,3)]), vid, true );
    for (vid=run_ids) run("striple_lll",vid) test( "striple_lll", striple_lll([gv(vid,0),gv(vid,1)],[gv(vid,2),gv(vid,3)],[gv(vid,4),gv(vid,5)]), vid, true );
    for (vid=run_ids) run("angle_ll",vid) test( "angle_ll", angle_ll([gv(vid,0),gv(vid,1)],[gv(vid,2),gv(vid,3)]), vid, true );
    for (vid=run_ids) run("angle_lll",vid) test( "angle_lll", angle_lll([gv(vid,0),gv(vid,1)],[gv(vid,2),gv(vid,3)],[gv(vid,4),gv(vid,5)]), vid, true );
    for (vid=run_ids) run("unit_l",vid) test( "unit_l", unit_l([gv(vid,0),gv(vid,1)]), vid, true );
    for (vid=run_ids) run("are_coplanar_lll",vid) test( "are_coplanar_lll", are_coplanar_lll([gv(vid,0),gv(vid,1)],[gv(vid,2),gv(vid,3)],[gv(vid,4),gv(vid,5)]), vid, true );

    // set 5: plane and pnorm
    for (vid=run_ids) run("plane_to_normal",vid) test( "plane_to_normal", plane_to_normal([gv(vid,0),gv(vid,1)]), vid, true );

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
