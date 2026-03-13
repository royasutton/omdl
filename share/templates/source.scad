//! grouped-members source file description (single group).
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2015

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

  \amu_define group_name  (Grouped-members Name)
  \amu_define group_brief (Grouped-members description.)

  \amu_include (include/amu/doxyg_init_pd_gds_ipg.amu)
*******************************************************************************/

// auto-tests (append to test results page)
/***************************************************************************//**
  \amu_include (include/amu/validate_log.amu)
  \amu_include (include/amu/validate_results.amu)
*******************************************************************************/

// group(s) begin (test summary and includes-required)
/***************************************************************************//**
  \amu_include (include/amu/doxyg_define_in_parent_open.amu)
  \amu_include (include/amu/validate_summary.amu)
  \amu_include (include/amu/includes_required.amu)
*******************************************************************************/

// member-wide reference definitions
/***************************************************************************//**
  \amu_define group_references
  (
   /+ [wikipedia]: https://www.wikipedia.org +/
  )
*******************************************************************************/

// member-wide documentation and conventions
/***************************************************************************//**
  \addtogroup \amu_eval(${group})
  \details
  \anchor \amu_eval(${group})_conventions
  \par Conventions

  - Convention list
*******************************************************************************/

//----------------------------------------------------------------------------//
// members
//----------------------------------------------------------------------------//

/*

  Private and public members can segregate members into named member
  group collections by wrapping the members with open and close group
  comment blobs.

  //! \name collection name 1 (subgroup)
  //! @{
  //! @}

  //! \name collection name 2 (subgroup)
  //! @{
  //! @}

  //! \cond DOXYGEN_SHOULD_SKIP_THIS
  //! \endcond

  //! <map> complex map data structure to skip in documentation.
  //! \hideinitializer

*/

//----------------------------------------------------------------------------//
// private members (helper)
//----------------------------------------------------------------------------//

// private variables

// private functions

// private modules

//----------------------------------------------------------------------------//
// public members
//----------------------------------------------------------------------------//

// variables

// functions

// modules

//----------------------------------------------------------------------------//
// group(s) end
//----------------------------------------------------------------------------//
//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu scripts
//----------------------------------------------------------------------------//

// auto-tests and validation

// documentation examples
/*
BEGIN_SCOPE example;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "front right back diag";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
