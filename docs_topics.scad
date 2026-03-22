//! Library documentation topics.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2018-2026

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

  \amu_include (include/amu/doxyg_init_ppd_gp.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// The omdl Distinctions
//----------------------------------------------------------------------------//
/***************************************************************************//**
  /+

    Pre-define level-1 group id's to establish order in documentation.
    These group id must be kept coherent with groups in documentation.

    Each group name and brief is subsequently defined in its
    docs_group.scad

  +/

  \defgroup datatypes
  \defgroup common
  \defgroup units
  \defgroup database
  \defgroup math
  \defgroup shapes
  \defgroup transforms
  \defgroup tools
  \defgroup models
  \defgroup parts
*******************************************************************************/

//----------------------------------------------------------------------------//
// The omdl Distinctions
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \page omdl_distinctions Distinctions

  \section distinctions What Makes omdl Distinct from Other OpenSCAD Libraries

  The OpenSCAD Mechanical Design Library ([omdl]) began as the work of
  an electrical engineer without formal training in mechanical
  engineering or graphical design. Its approach reflects patterns drawn
  from electrical hardware description languages, which may feel
  unconventional to designers accustomed to geometry-first or
  graphics-driven workflows.

  It is intentionally positioned differently from widely used OpenSCAD
  libraries such as [MCAD] and [BOSL2]. While all three support
  parametric modeling, they target different abstraction levels and
  workflows.

  \subsection engineering_first 1. Mechanical-Engineering-First Abstraction

  omdl is designed around mechanical design intent, not just
  geometry creation.

  - Parameters represent physical concepts (lengths, angles,
    tolerances, fits)

  - Modules reflect mechanical parts and operations, not just shapes

  - Design choices emphasize manufacturability and assembly

  In contrast:

  - \b [MCAD] focuses on providing a catalog of reusable mechanical
    parts

  - \b [BOSL2] focuses on robust geometric primitives and utilities

  omdl treats geometry as a consequence of mechanical decisions, not
  the starting point.


  \subsection structured_parameters 2. Emphasis on Structured Parameters

  omdl encourages the use of structured, self-describing parameters
  rather than long positional argument lists.

  omdl takes the view that design application flexibility is increased
  by providing detailed construction options through careful
  parameterization and by managing those parameters as configurations
  with defaults, inheritance, and instance-level control. Designers
  should be able to create useful mechanical parts using defaults,
  while still retaining the ability to drill down into low-level
  geometric details when required.

  This results in:

  - More readable designs
  - Fewer silent failures
  - Easier long-term maintenance

  By comparison:

  - \b [MCAD] often relies on positional parameters

  - \b [BOSL2] provides powerful helpers but leaves structure decisions
    to the user


  \subsection unit_aware_design 3. Unit-Aware Design Philosophy

  omdl natively supports unit-aware modeling, making mixed-unit
  mechanical work safer and clearer.

  Key ideas:

  - Explicit unit conversion (`length()`, `angle()`)
  - Reduced risk of inch/mm confusion
  - Clear documentation of expected units

  Most other libraries:

  - Assume a single unit system (usually millimeters)
  - Leave unit discipline entirely to user convention

  For mechanical engineers working from drawings or standards, this is
  a major differentiator.


  \subsection workflow_oriented 4. Workflow-Oriented Organization

  omdl mirrors how mechanical designs evolve. This is reflected
  directly in the library structure:

  - \ref datatypes
  - \ref common
  - \ref units
  - \ref database
  - \ref math
  - \ref shapes
  - \ref transforms
  - \ref tools
  - \ref models
  - \ref parts

  Other libraries are typically organized by shape type, not design
  process.


  \subsection documentation_first_class 5. Documentation as a First-Class Feature

  omdl is written to be self-documenting by design:

  - Doxygen-style comments embedded in source
  - Generated API documentation in multiple output formats (HTML, PDF, etc.)
  - Parameters explained in engineering terms

  The goal is that reading the documentation teaches mechanical design
  usage, not just syntax.

  By contrast:

  - \b [MCAD] documentation is sparse and example-driven
  - \b [BOSL2] documentation is extensive but geometry-centric


  \subsection conservative_behavior 6. Conservative, Predictable Behavior

  omdl favors:

  - Explicit behavior over “magic”
  - Predictable defaults
  - Minimal global state

  This makes designs:

  - Easier to audit
  - Easier to debug
  - More suitable for long-lived or shared projects


  \section differentiation_summary Differentiation Summary

  Feature              | omdl                      | MCAD                      | BOSL2
  :-------------------:|:-------------------------:|:-------------------------:|:----------------------:
  Primary Focus        | Mechanical design intent  | Part catalog              | Geometric power tools
  Units                | Explicit, unit-aware      | Implicit                  | Implicit
  Parameter Style      | Structured & named        | Positional                | Mixed
  Workflow Orientation | Yes                       | No                        | No
  Documentation Depth  | High, engineering-centric | Minimal                   | High, geometry-centric
  Target User          | Mechanical engineers      | Hobbyists & general users | Power users

  omdl is not just a geometry library, it is a mechanical design
  framework for OpenSCAD, built to reflect how engineers think,
  document, and maintain real mechanical systems.


  [omdl]: https://royasutton.github.io/omdl
  [MCAD]: https://github.com/openscad/MCAD
  [BOSL2]: https://github.com/BelfrySCAD/BOSL2
*******************************************************************************/

//----------------------------------------------------------------------------//
// Architecture Overview
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \page architecture_overview Architecture Overview

  \section design_goals Design Goals

  The OpenSCAD Mechanical Design Library (omdl) is structured as
  a **layered parametric design framework** rather than a flat
  collection of modules. The architecture is intended to:

  - Separate mechanical intent and properties from geometric
    implementation

  - Promote reuse through parametric primitives

  - Enable automated documentation generation

  - Support both end-users (designers) and contributors (developers)

  omdl emphasizes predictable behavior, explicit parameters, and
  attempts consistent naming so that models remain maintainable as
  assemblies grow.

  \section architectural_layers Architectural Layers

  The omdl library is organized into a set of logical layers, where
  each successive layer builds upon the capabilities provided by the
  previous one. The development and documentation workflow relies on a
  dedicated toolchain composed of custom utilities together with freely
  available open-source software, including openscad-amu, Doxygen, GNU
  Make, GNU Bash, and their prerequisites.

  \dot Library Tools, Components, and Layers
  digraph omdl_architecture
  {
    graph [fontname="Helvetica", fontsize=12, style="dashed", color="gray"];
    node  [fontname="Helvetica", fontsize=10, shape=record, style="rounded"];
    edge  [fontname="Helvetica", fontsize=8, arrowhead=vee];

    subgraph cluster_layers
    {
      subgraph cluster_tools
      {
        label = "Tooling";

        node [fontname="Helvetica", fontsize=10, shape=box, peripheries=2, style="filled"];

        openscad_amu [label="openscad-amu" URL="https://royasutton.github.io/openscad-amu"];
        doxygen [label="Doxygen" URL="http://www.doxygen.nl"];
      }

      assemblies
      [
        label = "\
        { \
          Assembly Layer |\
          - Design intent\l \
          - Multi-part constructs\l \
        }"
      ];

      features
      [
        label = " \
        { \
          Mechanical Feature Layer | \
          - Components & parts\l \
          - Engineering conventions\l \
        }"
      ];

      primitives
      [
        label=" \
        { \
          Geometry Primitives Layer | \
          - Parametric solids\l \
          - Structural profiles\l \
        }"
      ];

      core
      [
        label=" \
        { \
          Core Utilities Layer | \
          - Configuration management\l \
          - Computations & transformations\l \
          - Shared conventions & constants\l \
        }"
      ];

      doxygen -> assemblies [style="invis"];
      openscad_amu -> assemblies [style="invis"];

      assemblies -> features   [label="uses"];
      features   -> primitives [label="builds from"];
      primitives -> core       [label="depends on"];
    }
  }
  \enddot

  \section module_philosophy Module Design Philosophy

  When adding or modifying modules, follow these architectural
  guidelines:

  - Prefer composition over duplication: reuse existing building blocks
    (primitives, features, utilities) by composing them together, rather
    than rewriting geometry or functionality from scratch.

  - Separate intent from implementation: Modules should express what
    the design is supposed to do independently from how the geometry is
    actually created.

  - Thoughtful Parameter Contracts: Modules should define and enforce
    their inputs to ensure predictable, safe, and reusable designs.
*******************************************************************************/

//----------------------------------------------------------------------------//
// Building and Installing
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \page building_and_installing Building and Installing

  \section setup_script Setup Script

  A script is provided to build the library documentation. If the setup
  script does not detect that [openscad-amu], the development environment
  used by [omdl], is installed, it will automatically download and
  configure it in a local cache directory within the current path. This
  ensures that the documentation can be generated without requiring a
  system-wide installation of the development environment.

  Download the omdl setup script:
  \code{bash}
  $ mkdir tmp && cd tmp

  $ wget https://raw.githubusercontent.com/royasutton/omdl/master/share/scripts/setup-omdl.bash

  $ chmod +x setup-omdl.bash
  \endcode

  Fetch and install the latest library distribution:
  \code{bash}
  $ ./setup-omdl.bash --branch-list tags1 --yes --install
  \endcode

  or, a specific version, say v0.9.6, can be installed using:
  \code{bash}
  $ ./setup-omdl.bash --branch v0.9.6 --yes --install
  \endcode

  View documentation:
  \code{bash}
  $ google-chrome ~/.local/share/OpenSCAD/docs/html/index.html
  \endcode

  The generated HTML documentation will be installed to the OpenSCAD
  user library path in a subfolder named 'docs/html'.

  The example above assumes a Linux operating system; paths may differ
  on other platforms.

  [omdl]: https://royasutton.github.io/omdl
  [repository]: https://github.com/royasutton/omdl
  [openscad-amu]: https://royasutton.github.io/openscad-amu
  [GNU Make]: https://www.gnu.org/software/make
*******************************************************************************/

//----------------------------------------------------------------------------//
// Library Usage
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \page library_usage Library Usage

  \section module_inclusion Module Inclusion

  The standard library includes are encapsulated within the base include
  file omdl-base.scad. This file provides only the minimal subset of
  commonly used functionality, consisting primarily of core utilities
  and geometric primitives, in order to maintain a lightweight
  dependency footprint. Modules outside of this base set are not
  imported implicitly and must be explicitly included prior to use.
  This approach allows developers to control library scope and
  selectively import functionality as required by a given project.

  \amu_shell omdl_base    ( "grep include omdl-base.scad | awk -v FS='(<|>)' '{print $2}'" ++rmnl )
  \amu_word omdl_base_cnt ( words="${omdl_base}" t=" " r="^" ++count)
  \amu_word omdl_base     ( words="${omdl_base}" t=" " r="^" ++list)
  \amu_table
  (
    id="omdl_base"
    table_caption="Standard includes: Core utilities and geometric primitives"
    columns="3" cell_texts="${omdl_base}"
  )

  To load the library base includes, use the wrapper as follows:

  \code{.C}
  include <omdl-base.scad>;
  include <models/3d/misc/omdl_logo.scad>;

  $fn = 36;

  omdl_logo(c=false, b=true, t=true);
  \endcode

  This process reads the \b \amu_eval(${omdl_base_cnt}) files listed in
  the table above. Modules not included in this base set must be
  explicitly included before use. This design reflects omdl’s modular
  architecture, where functionality is grouped by purpose (primitives,
  mechanical features, assemblies, etc.) and only the essential
  components are loaded by default.

  Explicit inclusion ensures that:

  - Projects remain lightweight, importing only the modules they need.

  - Dependencies are clear, reducing the chance of runtime errors from
    missing includes.

  - Developers can maintain control over which features are integrated,
    supporting flexible recomposition and integration with other
    libraries.
*******************************************************************************/

//----------------------------------------------------------------------------//
// Type Conventions
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \page type_conventions Type Conventions

  \section types_values Types and Values

  OpenSCAD defines a value as one of the following: a number, boolean,
  string, range, vector, or the undefined value. Within omdl, what the
  [OpenSCAD types] documentation calls a vector is referred to as a
  \em list. This distinction helps differentiate between sequential
  collections of general or compound values and [Euclidean vectors]
  representing numeric coordinates.

  \subsection base_types Base types

  | type      | description                                         |
  |:---------:|:----------------------------------------------------|
  | boolean   | a binary logic value (\c true or \c false)          |
  | number    | a numerical value                                   |
  | string    | an iterable sequence of of character values         |
  | list      | an iterable sequence of arbitrary values            |
  | range     | an arithmetic sequence                              |
  | function  | a function literal or variable containing functions |

  \subsection special_values Special values

  | value     | description                                         |
  |:---------:|:----------------------------------------------------|
  | undef     | a value with no definition                          |
  | ""        | a string with no characters, the empty string       |
  | []        | a list with no element-values, the empty list       |
  | [nan]     | a numerical value which is not a number             |
  | [inf]     | a numerical value which is infinite                 |

  \subsection type_naming_conventions Type naming conventions

  For clarity and consistency, the following naming conventions are
  used when referring to common [data types] within the library.

  | name          | description                                       |
  |:-------------:|:--------------------------------------------------|
  | [value]       | any datum that can be stored in OpenSCAD          |
  | [scalar]      | a single non-iterable value                       |
  | [iterable]    | any value with iterable elements                  |
  | [empty]       | any iterable value with zero elements             |
  | [bit]         | a binary numerical value ( \c 0 or \c 1 )         |
  | [integer]     | a positive, negative, or zero whole number        |
  | [even]        | an even integer                                   |
  | [odd]         | an odd integer                                    |
  | [decimal]     | a real number with a fractional part              |
  | [index]       | a list index sequence                             |
  | [datastruct]  | a defined data structure                          |
  | [data]        | an arbitrary data structure                       |
  | [map]         | data store of keys mapped to values               |
  | [table]       | data store of values arranged in rows and columns |


  \subsection list_naming_conventions List naming conventions

  When a value is a list and has an expected number of elements, the
  suffix \c -n is appended to indicate the required element count. If a
  range of acceptable elements is allowed, the lower and upper bounds
  are appended using the form \c l:u.

  When values list elements are expected to be of a specific data type,
  the element type is prefixed to the value list name. These
  conventions provide a concise way to describe parameter value
  contracts and expected data structures throughout the documentation.

  See the tables below for examples.

  | name                | description                               |
  |:-------------------:|:------------------------------------------|
  | list-n              | a list of \c n values                     |
  | list-l:u            | a list of \c l to \c u values             |
  | typed-list          | a list of \c typed values                 |
  | typed-list-n        | a list of \c n \c typed values            |
  | typed-list-m-list-n | \c m lists of \c n \c typed value lists   |


  \section euclidean_types Euclidean Space Types

  For [geometric] specifications and [geometric algebra], omdl adopts
  the following type definitions and conventions.

  | name        | description                                       |
  |:-----------:|:--------------------------------------------------|
  | [point]     | a list of numbers to identify a location in space |
  | [vector]    | a direction and magnitude in space                |
  | [line]      | a start and end point in space ([line wiki])      |
  | [normal]    | a vector that is perpendicular to a given object  |
  | [pnorm]     | a vector that is perpendicular to a plane         |
  | [plane]     | a flat 2d infinite surface ([plane wiki])         |
  | [matrix]    | a rectangular array of values                     |

  When a particular dimension is expected, the dimensional expectation
  is appended to the end of the name after a \c '-' dash as in the
  following table.

  | name        | description                                       |
  |:-----------:|:--------------------------------------------------|
  | point-nd    | a point in an \c n dimensional space              |
  | vector-nd   | a vector in an \c n dimensional space             |
  | line-nd     | a line in an \c n dimensional space               |
  | matrix-mxn  | an \c m by \c n matrix of values                  |

  When a type is specified in plural form, such as \c points, it
  implies a list of the specified type. For example, \c points is
  equivalent to a \c point-list.

  \subsection data_types_lines Lines and vectors

  A \c vector has both direction and magnitude in space. A \c line
  likewise has direction and magnitude, but also includes location, as
  it begins at one point in space and ends at another. Although a line
  may be defined in one dimension, most library functions operate on
  two- and/or three-dimensional lines. Operators in omdl follow a
  common convention for representing Euclidean vectors and straight
  lines, as summarized in the following table:

  Given two points \c p1 and \c p2, in space:

  | no. | form      | description                       |
  |:---:|:---------:|:----------------------------------|
  |  1  | p2        | a vector from the origin to \c p2 |
  |  2  | [p2]      | a vector from the origin to \c p2 |
  |  3  | [p1, p2]  | a line from \c p1 to \c p2        |

  The functions is_point(), is_vector(), is_line(), line_dim(),
  line_tp(), line_ip(), vol_to_point(), and vol_to_origin(), are
  available for type identification and conversion.

  \b Examples

  \code{.c}
  // points
  p1 = [a,b,c]
  p2 = [d,e,f]

  // vectors
  v1 = p2       = [d,e,f]
  v2 = [p2]     = [[d,e,f]]

  // lines
  v3 = [p1, p2] = [[a,b,c], [d,e,f]]

  v1 == v2
  v1 == v2 == v3, iff p1 == origin3d
  \endcode

  \subsection data_types_planes Planes

  Operators in omdl follow a common convention for defining planes. A
  \c plane is specified by a [point] located on its surface together
  with a [normal] vector, denoted by \c pnorm, which is described in
  the following section. The plane definition is therefore represented
  as a list containing both the point and its corresponding normal
  vector, as shown below:

  | name    | form                |
  |:-------:|:-------------------:|
  | [plane] | [[point], [pnorm]]  |

  \subsection data_types_normals Planes' normal

  The data type \c pnorm defines a convention for specifying a
  direction vector that is perpendicular to a plane. Given three points
  \c p1, \c p2, \c p3, and three vectors \c v1, \c v2, \c vn, the plane
  [normal] may be expressed using any of the following equivalent
  forms:

  | no. | form          | description                                   |
  |:---:|:-------------:|:----------------------------------------------|
  |  1  | vn            | the predetermined normal vector to the plane  |
  |  2  | [vn]          | the predetermined normal vector to the plane  |
  |  3  | [v1, v2]      | two distinct but intersecting vectors         |
  |  4  | [p1, p2, p3]  | three (or more) non-collinear coplanar points |

  The functions is_plane() and plane_to_normal() are available for
  type identification and conversion.

  \b Example

  \code{.c}
  // points
  p1 = [a,b,c];
  p2 = [d,e,f];
  p3 = [g,h,i];

  // lines and vectors
  v1 = [p1, p2] = [[a,b,c], [d,e,f]]
  v2 = [p1, p3] = [[a,b,c], [g,h,i]]
  vn = cross_ll(v1, v2)

  // planes' normal
  n1 = vn           = cross_ll(v1, v2)
  n2 = [vn]         = cross_ll(v1, v2)
  n3 = [v1, v2]     = [[[a,b,c],[d,e,f]], [[a,b,c],[g,h,i]]]
  n4 = [p1, p2, p3] = [[a,b,c], [d,e,f], [g,h,i]]

  n1 || n2 || n3 || n4

  // planes
  pn1 = [p1, n1]
  pn2 = [p2, n2]
  pn3 = [p3, n3]
  pn4 = [n4[0], n4]
  pn5 = [mean(n4), n4]

  pn1 == pn4
  \endcode


  /+

    References: Value Types

  +/

  [OpenSCAD types]: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/The_OpenSCAD_Language#Values_and_data_types
  [nan]: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/The_OpenSCAD_Language#Infinities_and_NaNs
  [inf]: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/The_OpenSCAD_Language#Infinities_and_NaNs

  [data types]: https://en.wikipedia.org/wiki/Data_type

  [value]: https://en.wikipedia.org/wiki/Value_(computer_science)
  [scalar]: https://en.wikipedia.org/wiki/Variable_(computer_science)
  [iterable]: https://en.wikipedia.org/wiki/Iterator
  [empty]: https://en.wikipedia.org/wiki/Empty_set

  [bit]: https://en.wikipedia.org/wiki/Bit

  [integer]: https://en.wikipedia.org/wiki/Integer
  [even]: https://en.wikipedia.org/wiki/Parity_(mathematics)
  [odd]: https://en.wikipedia.org/wiki/Parity_(mathematics)

  [decimal]: https://en.wikipedia.org/wiki/Decimal
  [index]: \ref index_sel()
  [datastruct]: https://en.wikipedia.org/wiki/Data_structure
  [data]: https://en.wikipedia.org/wiki/Data

  [map]: https://en.wikipedia.org/wiki/Associative_array
  [table]: https://en.wikipedia.org/wiki/Table_(information)

  [Euclidean vectors]: https://en.wikipedia.org/wiki/Euclidean_vector

  /+

    References: Euclidean Space Types

  +/

  [geometric]: https://en.wikipedia.org/wiki/Geometry
  [geometric algebra]: https://en.wikipedia.org/wiki/Geometric_algebra

  [point]: https://en.wikipedia.org/wiki/Point_(geometry)
  [vector]: https://en.wikipedia.org/wiki/Euclidean_vector
  [line wiki]: https://en.wikipedia.org/wiki/Line_(geometry)
  [line]: \ref data_types_lines
  [normal]: https://en.wikipedia.org/wiki/Normal_(geometry)
  [pnorm]: \ref data_types_planes_normal
  [plane wiki]: https://en.wikipedia.org/wiki/Plane_(geometry)
  [plane]: \ref data_types_planes
  [matrix]: https://en.wikipedia.org/wiki/Matrix_(mathematics)
*******************************************************************************/

//----------------------------------------------------------------------------//
// Examples
//----------------------------------------------------------------------------//

/***************************************************************************//**
*******************************************************************************/

//----------------------------------------------------------------------------//
// Auto-tests and Validation
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \page tv Auto-tests and Validation

  \section auto_test_results Library Build Test Results

  The documentation for [omdl] is generated using [openscad-amu].
  An integral part of the documentation build process is the validation
  of core library operations to ensure they behave as expected. As
  [OpenSCAD] evolves, changes to the language or compiler may introduce
  regressions that affect existing functionality. These validation steps
  help identify library routines that require updates to maintain
  compatibility and correct behavior.

  | format                  | description
  |:-----------------------:|:------------------------------------------
  | \subpage tv_tree "Tree" | Tree of all test scripts and test results.
  | \subpage tv_list "List" | A flat list of all test results.
  | \subpage tv_fail "Fail" | A flat list of current test failures.
  | \subpage tv_warn "Warn" | A flat list of current test warnings.

  \section auto_test_issues Build Test Failures and Warnings

  [omdl]: https://royasutton.github.io/omdl
  [openscad-amu]: https://royasutton.github.io/openscad-amu
  [OpenSCAD]: http://www.openscad.org
*******************************************************************************/

// Tests and Results
/***************************************************************************//**
  /+
      Define separate pages for validation results. Modules can
      attached results to the related page reference show below in this
      section.
  +/

  \page tv_tree Validation Tests and Results

  \page tv_list Validation Tests Summary
    \amu_include (include/amu/validate_log_th.amu)
    \amu_table(columns=${tv_tc} column_headings=${tv_th})

  \page tv_fail Current Tests Failures
  \page tv_warn Current Tests Warnings
*******************************************************************************/

//----------------------------------------------------------------------------//
// Build Information
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \page build_information Build Information

  \section build_general General

  \amu_file bi_general (file="${DOXYGEN_OUTPUT}buildinfo/general.amu" ++read)
  \amu_table
  (
    id="bi_general"
    table_caption="General"
    columns="2"
    table_class="amuBuildInfo"
    column_headings="name^value"
    cell_texts="${bi_general}"
  )

  \section build_toolchain Toolchain

  \amu_file bi_toolchain (file="${DOXYGEN_OUTPUT}buildinfo/toolchain.amu" ++read)
  \amu_table
  (
    id="bi_toolchain"
    table_caption="Toolchain"
    columns="3"
    table_class="amuBuildInfo"
    column_headings="name^version^path"
    cell_texts="${bi_toolchain}"
  )

  \section build_components Components

  \amu_file bi_components (file="${DOXYGEN_OUTPUT}buildinfo/components.amu" ++read)
  \amu_table
  (
    id="bi_components"
    table_caption="Components"
    columns="3"
    table_class="amuBuildInfo"
    column_headings="name^count^value"
    cell_texts="${bi_components}"
  )

  \section build_scopes Scopes

  \amu_file bi_scopes (file="${DOXYGEN_OUTPUT}buildinfo/scopes.amu" ++read)
  \amu_table
  (
    id="bi_scopes"
    table_caption="Scopes"
    columns="3"
    table_class="amuBuildInfo"
    column_headings="name^count^value"
    cell_texts="${bi_scopes}"
  )

  \section build_groups Groups

  \amu_file bi_groups (file="${DOXYGEN_OUTPUT}buildinfo/groups.amu" ++read)
  \amu_table
  (
    id="bi_groups"
    table_caption="Groups"
    columns="3"
    table_class="amuBuildInfo"
    column_headings="name^count^value"
    cell_texts="${bi_groups}"
  )

  \section build_sources Sources

  \amu_file bi_sources (file="${DOXYGEN_OUTPUT}buildinfo/sources.amu" ++read)
  \amu_table
  (
    id="bi_sources"
    table_caption="Sources"
    columns="3"
    table_class="amuBuildInfo"
    column_headings="name^count^value"
    cell_texts="${bi_sources}"
  )
*******************************************************************************/

//----------------------------------------------------------------------------//
// Copyright Notice
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \page Copyright Copyright Notice

  \section copyright GNU Lesser General Public License

  \verbatim
  \amu_include (gnu-lgpl-v2.1.txt)
  \endverbatim
*******************************************************************************/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
