//! Include wrapper of base library components.
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

  \amu_include (include/amu/pgid_pparent_path_n.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// console + constants
//----------------------------------------------------------------------------//
include <common/console.scad>;
include <common/constants.scad>;

//----------------------------------------------------------------------------//
// data types
//----------------------------------------------------------------------------//
include <datatypes/scalar_test.scad>;
include <datatypes/scalar_operate.scad>;

include <datatypes/iterable_test.scad>;
include <datatypes/iterable_operate.scad>;

include <datatypes/list_operate.scad>;
include <datatypes/list_compare.scad>;

include <datatypes/euclidean.scad>;
include <datatypes/binary.scad>;

include <datatypes/map.scad>;
include <datatypes/table.scad>;

//----------------------------------------------------------------------------//
// math
//----------------------------------------------------------------------------//
include <math/triangle.scad>;
include <math/linear_algebra.scad>;

include <math/polygon.scad>;
include <math/polyhedron.scad>;
include <math/polytope.scad>;

include <math/utility.scad>;

//----------------------------------------------------------------------------//
// shapes
//----------------------------------------------------------------------------//
include <shapes/basic_2d.scad>;
include <shapes/basic_3d.scad>;
include <shapes/polygon.scad>;

//----------------------------------------------------------------------------//
// tools
//----------------------------------------------------------------------------//
include <tools/extrude.scad>;
include <tools/repeat.scad>;

//----------------------------------------------------------------------------//
// units
//----------------------------------------------------------------------------//
include <units/angle.scad>;
include <units/length.scad>;

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
