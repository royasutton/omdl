//! Conditional version of standard transformations and operations.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2019-2024

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

    \amu_define group_name  (Conditional Operations)
    \amu_define group_brief (Conditional transformations and operations.)

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

//
// Transformations
//

//! Conditionally apply the convex hull transformation.
/***************************************************************************//**
  \param    c <boolean> conditional.
  \param    s <integer | integer-list | range> child object selection(s).

  \details

    When \p c is \b true, apply the transformation to the children
    objects, otherwise return the children unmodified. When a child
    object selection is specified, only the selected children are
    returned irrespective of \p c.
*******************************************************************************/
module hull_cs
(
  c = true,
  s
)
{
  if ( is_defined(s) )
    children(s);
  else if ( c )
    hull()
    {
      children();
    }
  else
    children();
}

//! Conditionally apply the minkowski sum transformation.
/***************************************************************************//**
  \param    c <boolean> conditional.
  \param    s <integer | integer-list | range> child object selection(s).
  \param    convexity <integer> The maximum number of front sides (or back
            sides) a ray intersection the object might penetrate..

  \details

    When \p c is \b true, apply the transformation to the children
    objects, otherwise return the children unmodified. When a child
    object selection is specified, only the selected children are
    returned irrespective of \p c.
*******************************************************************************/
module minkowski_cs
(
  c = true,
  s,
  convexity
)
{
  if ( is_defined(s) )
    children(s);
  else if ( c )
    minkowski(convexity)
    {
      children(0);
      children([1:$children-1]);
    }
  else
    children();
}

//
// Boolean operations
//

//! Conditionally apply the union boolean operation.
/***************************************************************************//**
  \param    c <boolean> conditional.
  \param    s <integer | integer-list | range> child object selection(s).

  \details

    When \p c is \b true, apply the operation on the children objects,
    otherwise return the children unmodified. When a child object
    selection is specified, only the selected children are returned
    irrespective of \p c.
*******************************************************************************/
module union_cs
(
  c = true,
  s
)
{
  if ( is_defined(s) )
    children(s);
  else if ( c )
    union()
    {
      children();
    }
  else
    children();
}

//! Conditionally apply the difference boolean operation.
/***************************************************************************//**
  \param    c <boolean> conditional.
  \param    s <integer | integer-list | range> child object selection(s).

  \details

    When \p c is \b true, apply the operation on the children objects,
    otherwise return the children unmodified. When a child object
    selection is specified, only the selected children are returned
    irrespective of \p c.
*******************************************************************************/
module difference_cs
(
  c = true,
  s
)
{
  if ( is_defined(s) )
    children(s);
  else if ( c && $children > 1 )
    difference()
    {
      children(0);
      children([1:$children-1]);
    }
  else
    children();
}

//! Conditionally apply the difference intersection operation.
/***************************************************************************//**
  \param    c <boolean> conditional.
  \param    s <integer | integer-list | range> child object selection(s).

  \details

    When \p c is \b true, apply the operation on the children objects,
    otherwise return the children unmodified. When a child object
    selection is specified, only the selected children are returned
    irrespective of \p c.
*******************************************************************************/
module intersection_cs
(
  c = true,
  s
)
{
  if ( is_defined(s) )
    children(s);
  else if ( c && $children > 1 )
    intersection()
    {
      children(0);
      children([1:$children-1]);
    }
  else
    children();
}

//! @}
//! @}

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
