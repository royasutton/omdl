//! Include file wrapper of omdl base primitives.
/***************************************************************************//**
  \file   omdl-base.scad
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

*******************************************************************************/

//----------------------------------------------------------------------------//
// console + constants
//----------------------------------------------------------------------------//
//  include <console.scad>;
//  include <constants.scad>;

//----------------------------------------------------------------------------//
// units
//----------------------------------------------------------------------------//
//  include <units/units_length.scad>;
include <units/units_angle.scad>;
include <units/units_coordinate.scad>;
include <units/units_resolution.scad>;

//----------------------------------------------------------------------------//
// data types
//----------------------------------------------------------------------------//
//  include <datatypes/datatypes-base.scad>;

include <datatypes/datatypes_map.scad>;
include <datatypes/datatypes_table.scad>;

//----------------------------------------------------------------------------//
// math
//----------------------------------------------------------------------------//
//  include <math/math-base.scad>;

//  include <math/math_triangle.scad>;
//  include <math/math_oshapes.scad>;
//  include <math/math_polytope.scad>;
//  include <math/math_bitwise.scad>;
include <math/math_utility.scad>;

//----------------------------------------------------------------------------//
// shapes
//----------------------------------------------------------------------------//
//  include <shapes/shapes2d.scad>;
include <shapes/shapes2de.scad>;
include <shapes/shapes3d.scad>;

//----------------------------------------------------------------------------//
// tools
//----------------------------------------------------------------------------//
//  include <tools/tools_align.scad>;
include <tools/tools_edge.scad>;
include <tools/tools_polytope.scad>;
//  include <tools/tools_utility.scad>;

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
