//! Root Module documentation.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2018

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

    \amu_pathid parent      (++path_parent)
    \amu_pathid group       (++path)

    \amu_define group_name  ()
    \amu_define group_brief ()

*******************************************************************************/

//----------------------------------------------------------------------------//
// validation.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \page validation Validation

  ### Scripts and Results ###

    The documentation for [omdl] is produced by [openscad-amu]. An
    integral part of building the library documentation is verifying
    that the basic operations work as expected. As [OpenSCAD] evolves,
    changes in the language and/or compiler may break basic library
    behavior. These validations are performed to identify library
    routines that require updating to conform to any such changes.

    | category                | description
    |:-----------------------:|:----------------------------------------
    | \subpage tv_tree "Tree" | Tree of test scripts and test results.
    | \subpage tv_list "List" | A summary list of test results.

  ### Current Failures ###

  [omdl]: https://royasutton.github.io/omdl
  [openscad-amu]: https://royasutton.github.io/openscad-amu
  [OpenSCAD]: http://www.openscad.org

  \page tv_tree Validation Tests and Results

  \page tv_list Validation Summary
    \amu_define tv_th (file^group^script^results^passed^skipped^failed)
    \amu_word   tv_tc (w=${tv_th} ++c)
    \amu_table(columns=${tv_tc} column_headings=${tv_th})
*******************************************************************************/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
