//! Library documentation home page.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2015-2026

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
// introduction.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \mainpage Introduction
  \tableofcontents

  \section intro_overview Overview

  [omdl], OpenSCAD Mechanical Design Library, is an open-source
  parametric framework for mechanical design in [OpenSCAD]. It provides
  reusable design primitives and fabrication-oriented modules intended
  to support real mechanical workflows rather than isolated geometric
  modeling.

  omdl was originally conceived to support the design of mechanically
  engineered objects intended for real-world CNC-based fabrication. A
  central goal of the library is to **separate design intent from
  implementation parameters**, enabling late-time parameter binding
  during model composition.

  By decoupling intent from geometry, designers can work at a higher
  level of abstraction, describing what a component must achieve rather
  than committing early to specific dimensions or configurations. This
  approach increases target outcome flexibility, allowing designs to be
  recomposed or adapted to new requirements without rewriting core
  geometry.

  In practice, this means that assemblies can be adjusted to match a
  particular application, manufacturing constraint, or the commodity
  components currently available. Late parameter binding allows the
  same design definition to integrate different off-the-shelf parts,
  making omdl well suited for iterative engineering workflows and
  fabrication-driven design.

  The library emphasizes:

  - **Parametric mechanical design:** components are defined by
    properties and intent rather than fixed geometry.

  - **Standardized data types:** Structured parameter abstractions used
    to convey configuration, intent, and implementation details between
    modules.

  - **Minimal global state:** modules are designed to be predictable and
    composable.

  - **Unit operations:** consistent handling of lengths, angles, and
    dimensional data.

  - **Integrated documentation:** API behavior and usage are documented
    directly in source using [Doxygen] and [openscad-amu].

  - **Validation-driven development:** automated scripts verify
    functionality of core primitives across evolving OpenSCAD versions.

  Instead of treating OpenSCAD purely as a shape generator, omdl
  introduces a structured mechanical design layer that helps bridge
  conceptual design, drafting, and fabrication.

  \section intro_philosophy Design Philosophy

  omdl is shaped by a set of design decisions that follow from its
  engineering focus.

  Geometry is treated as a consequence of mechanical decisions, not
  their starting point. Rather than exposing low-level shape primitives
  as the primary interface, omdl encourages working at the level of
  components, operations, and assemblies — describing what a part must
  achieve before specifying how it is constructed.

  Modules are designed to be included individually as needed, helping
  keep projects lightweight and reducing unnecessary dependencies. This
  modular approach also supports interoperability, making it easier to
  integrate omdl alongside other OpenSCAD design libraries without
  imposing a rigid project structure.

  The library is organized into modular groups that represent distinct
  functional areas, including tooling utilities, drafting operations,
  design data, mathematical operations, geometric primitives, and
  mechanical components. This structure encourages separation of
  concerns while allowing developers to work at the appropriate level
  of abstraction for their design.

  \section intro_docs Documentation Approach

  All documentation is generated from inline source comments using
  [Doxygen]. The documentation is retrieved from the source code and
  pre-processed by [openscad-amu] before being sent to Doxygen for
  processing into the desired output format.

  This approach ensures that:

  - examples remain synchronized with the implementation,

  - parameter behavior is clearly described,

  - documentation can be exported to multiple formats such as HTML or PDF.

  Validation scripts are executed during the documentation build
  process to confirm that core operations behave consistently across
  supported OpenSCAD versions. This has become less pressing with the
  maturing OpenSCAD language.

  \section intro_audience Who This Library Is For

  omdl is intended for:

  - Mechanical engineers using OpenSCAD for parametric design

  - Makers building fabrication-ready components

  - Developers creating reusable mechanical modules

  - Projects that benefit from application-specific mechanical design

  - “Just-fit” solutions using available commodity components

  It may be less suitable for purely artistic modeling workflows where
  strict dimensional control is unnecessary.

  \section intro_getting_started Getting Started

  Before running examples, follow the [installing] instructions to set
  up omdl and its build environment. For an introduction to the type
  system and parameter conventions used throughout the library, see
  [data types].

  The minimal example below demonstrates how omdl modules can be
  combined to construct a fabrication-oriented component. The example
  builds a custom linear rod bearing using parametric dimensions and
  unit conversion functions.

  \amu_define title         (Hello world)
  \amu_define image_views   (right top front diag)
  \amu_define image_size    (sxga)
  \amu_define image_columns (4)
  \amu_define scope_id      (quickstart)

  \amu_define notes_scad
    ( In this example, bearing_linear_rod() is used to construct
      a custom linear bearing for fabrication on a 3D printer. )

  \amu_define notes_diagrams
    ( The dimension operations in the above example can be found near
      the end of ${FILE_NAME} within the \em scope \c ${scope_id}. )

  \amu_include (include/amu/scope_diagrams_3d.amu)

  \section intro_contributing Contributing

  omdl is developed using [Git] and hosted on [GitHub]. Contributions
  typically follow the standard [forking] and [pull requests] workflow.
  Because the project is licensed under the GNU Lesser General Public
  License, modified files should retain original copyright notices
  alongside any new authorship.

  Ideas, bug reports, feature requests, and improvements to
  documentation are encouraged.

  \section intro_support Support

  Questions, feature requests, or issues can be submitted through the
  project’s [issue] tracker.

  \section intro_further Further Reading

  - \ref omdl_distinctions        "Distinctions:"
    How omdl differs from libraries like MCAD and BOSL2.

  - \ref architecture_overview    "Architecture Overview:"
    omdl's four-layer framework and module design guidelines.

  - \ref building_and_installing  "Building and Installing the Library:"
    Setup script instructions for installing omdl locally.

  - \ref library_usage            "Library Usage:"
    How to include modules and use omdl-base.scad.

  - \ref type_conventions         "Type Conventions:"
    Naming conventions for all parameter and Euclidean types.

  - \ref tv                       "Auto-tests and Validation:"
    Automated test results across supported OpenSCAD versions.

  - \ref build_information        "Build Information:"
    Toolchain versions and component counts at build time.


  [GNU Lesser General Public License]: https://www.gnu.org/licenses/lgpl.html

  [omdl]: https://royasutton.github.io/omdl
  [omdl repository]: https://github.com/royasutton/omdl
  [issue]: https://github.com/royasutton/omdl/issues

  [openscad-amu]: https://royasutton.github.io/openscad-amu

  [Doxygen]: https://www.doxygen.nl
  [markups]: https://www.doxygen.nl/manual/commands.html

  [OpenSCAD]: https://www.openscad.org

  [Git]: https://git-scm.com
  [GitHub]: https://github.com
  [forking]: https://help.github.com/forking
  [pull requests]: https://help.github.com/articles/about-pull-requests
*******************************************************************************/

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE logo;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <models/3d/misc/omdl_logo.scad>;

    $fn = 36;

    omdl_logo(d=10, c=false, b=true, t=false);
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;

    views     name "views" distance "25" views "top";
    images    name "slogo" aspect "1:1" xsizes "55";
    variables set_opts_combine "views slogo";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

/*
BEGIN_SCOPE quickstart;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <transforms/base_cs.scad>;
    include <tools/2d/drafting/draft-base.scad>;
    include <parts/3d/motion/bearing_linear_rod.scad>;

    $fn = 36;

    p = [length(0.706, "in"), length(0.622, "in")];
    b = length(6, "mm");

    r = 21.5; c = 6; a = 85;
    h = [b*8, undef, false];

    v = is_undef ( __mfs__diag ) ? 2: undef;

    bearing_linear_rod(pipe=p, ball=b, count=c, angle=a, h=h, align=4, view=v)
    minkowski() {cylinder(r=r-b*2/3, h=first(h)-b*3/2, center=true); sphere(r=r/5);};

    // end_include

    if ( !is_undef(__mfs__top) ) color("brown"){
      draft_dim_center(r=r);
      draft_dim_radius(r=r, v=[+1,-1], u="mm");
      draft_dim_line(p1=[-r,0], p2=[+r,0], d=r*1.25, u ="mm");
      draft_dim_line(p1=[-first(p)/2,0], p2=[+first(p)/2,0], d=r*3/4, u ="mm");
    }

    if ( !is_undef(__mfs__front) ) color("brown") rotate([90,0,0]) {
      draft_dim_line(p1=[-r,0], p2=[+r,0], d=r*3/4, u ="mm");
      draft_dim_line(p1=[-first(p)/2,0], p2=[+first(p)/2,0], u ="mm");
      draft_dim_line(p1=[0,0], p2=[0,-first(h)], d=+r*1.25, u ="mm");
      draft_dim_leader(p=[-r+r/20,-r/15], v1=135, v2=180, l1=7, l2=7, t="r/5", tr=0, s=2);
    }

  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "diag front right top";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
