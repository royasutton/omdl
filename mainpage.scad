//! Documentation main page.
/***************************************************************************//**
  \file   mainpage.scad
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

/***************************************************************************//**
  \mainpage omdl
  \tableofcontents

    It is an [OpenSCAD] mechanical design library ([omdl]) that
    provides open-source high-level design primitives with coherent
    documentation generated by [Doxygen] using [openscad-amu].

    With Doxygen, the code documentation is written within the code
    itself, and is thus easy to keep current. Moreover, it provides a
    standard way to both write and present OpenSCAD design
    documentation, compilable to common output formats (html, pdf,
    etc). With [omdl], all library primitives are \em parametric with
    minimal, mostly zero, global variable dependencies and all library
    API's include [markups] that describe its parameters, behavior, and
    use.

    \ref validation "Validation" scripts are used to verify that the
    core operations work as expected across evolving [OpenSCAD]
    versions (validations are performed when rebuilding the
    documentation). [omdl] uses a common set of assumptions and
    conventions for specifying \ref dt "data types" and is divided into
    individual components of functionality that may be \c included as
    desired.

    \b Example:

    \dontinclude mainpage_quickstart.scad
    \skip include
    \until valign="center" );

    \amu_make png_files (append=quickstart extension=png)
    \amu_make eps_files (append=quickstart extension=png2eps)
    \amu_make stl_files (append=quickstart extension=stl)

    \htmlonly
      \amu_image_table
        (
          type=html columns=4 image_width="200" table_caption="Example Result"
          cell_captions="Bottom^Diagonal^Right^Top"
          cell_files="${png_files}"
          cell_urls="${stl_files} ${stl_files} ${stl_files} ${stl_files}"
        )
    \endhtmlonly
    \latexonly
      \amu_image_table
        (
          type=latex columns=4 image_width="1.25in" table_caption="Example Result"
          cell_captions="Bottom^Diagonal^Right^Top"
          cell_files="${eps_files}"
        )
    \endlatexonly

  \section using Using

    To use [omdl], the library files must be copied to an OpenSCAD
    [library location]. This can be done manually or can be done using
    using [openscad-amu].

    The ladder is recommended and has several advantages. When using
    [openscad-amu], the generated documentation is installed together
    with the library source. A link to this documentation is also added
    to a browsable index of libraries, which greatly facilitates design
    reference access. Additionally, with [openscad-amu] installed, new
    designs can be similarly documented.

    See the recommended \ref install "installation method" for more
    information. Library releases are periodically made available in
    the [omdl repository] under [snapshots].

  \section contributing Contributing

    [omdl] uses [git] for development tracking, and is hosted on
    [GitHub] following the usual practice of [forking] and submitting
    [pull requests] to the source repository.

    As it is released under the [GNU Lesser General Public License],
    any file you change should bear your copyright notice alongside the
    original authors' copyright notices typically located at the top of
    each file.

    Ideas, requests, comments, contributions, and constructive
    criticism are welcome.

  \section support Support

    In case you have any questions or would like to make feature
    requests, you can contact the maintainer of the project or file an
    [issue].


  [GNU Lesser General Public License]: https://www.gnu.org/licenses/lgpl.html

  [omdl]: https://royasutton.github.io/omdl
  [omdl repository]: https://github.com/royasutton/omdl
  [snapshots]: https://github.com/royasutton/omdl/tree/master/snapshots
  [issue]: https://github.com/royasutton/omdl/issues

  [openscad-amu]: https://royasutton.github.io/openscad-amu

  [Doxygen]: http://www.stack.nl/~dimitri/doxygen/index.html
  [markups]: http://www.stack.nl/~dimitri/doxygen/manual/commands.html

  [OpenSCAD]: http://www.openscad.org
  [library location]: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Libraries

  [git]: http://git-scm.com
  [GitHub]: http://github.com
  [forking]: http://help.github.com/forking
  [pull requests]: https://help.github.com/articles/about-pull-requests
*******************************************************************************/

//----------------------------------------------------------------------------//
// conventions.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \page conventions Conventions
    \li \subpage dt
*******************************************************************************/

/***************************************************************************//**
  \page dt Data types
  \tableofcontents

  \section dt_builtin Built-in

    [omdl] assumes a [value] is either a number, a boolean, a string, a
    list, a range, or the undefined value. What is called a vector in
    the [OpenSCAD types] documentation is refereed to as a list here in
    order to distinguish between sequential lists of values and
    [Euclidean vectors].

    | type      | description                                         |
    |:---------:|:----------------------------------------------------|
    | [value]   | any valid OpenSCAD storable datum                   |
    | number    | an arithmetic value                                 |
    | boolean   | a binary logic value (true or false)                |
    | string    | a sequential list of of character values            |
    | list      | a sequential list of arbitrary values               |
    | range     | an arithmetic sequence                              |
    | undef     | the undefined value                                 |

  \subsection dt_special Special numerical values

    | value     | description                                         |
    |:---------:|:----------------------------------------------------|
    | [nan]     | a numerical value which is not a number             |
    | [inf]     | a numerical value which is infinite                 |

  \section dt_additions Additional conventions

    When a list has an expected number of elements 'n' the \em count is
    appended following a '-'. Where there is a range of expected
    elements, the lower and upper bounds are separated by a ':' and
    appended. when the elements values are of an expected type, that
    \em type is prepended. Combinations are used as needed as in
    the following table:

    | name        | description                                       |
    |:-----------:|:--------------------------------------------------|
    | list-n      | a list of of n elements                           |
    | list-l:u    | a list of l to u elements                         |
    | type-list   | a list of elements with an expected type          |
    | type-list-n | a list of n elements with an expected type        |

  \subsection dt_distinctions Distinctions

    [omdl] make the following distinctions on variable types.

    | name        | description                                       |
    |:-----------:|:--------------------------------------------------|
    | [scalar]    | a single non-iterable value                       |
    | [iterable]  | a multi-part sequence of values                   |
    | [empty]     | an iterable value with zero elements              |
    | [even]      | an even numerical value                           |
    | [odd]       | an odd numerical value                            |

  \subsection dt_general General

    From the fixed built-in set of [data types], [omdl] adds the
    following general type specification conventions.

    | name        | description                                       |
    |:-----------:|:--------------------------------------------------|
    | [bit]       | a binary numerical value (0 or 1)                 |
    | [integer]   | a positive, negative, or zero whole number        |
    | [decimal]   | integer numbers with a fractional part            |
    | [datalist]  | a list of arbitrary data values                   |
    | indexs      | a list index sequence specification               |

  \subsubsection dt_indexs Index sequence

    The data type \em indexs refers to a convention for specifying a
    sequence of indexes for a list of elements. A list index sequence
    may be specified in one of the following forms.

    | value / form    | description                                   |
    |:---------------:|:----------------------------------------------|
    | \b true         | All index positions of the list [0:size-1]    |
    | \b false        | No index positions                            |
    | "all"           | All index positions of the list [0:size-1]    |
    | "none"          | No index positions                            |
    | "random"        | Random index positions of the list [0:size-1] |
    | <integer>       | The single position given by an <integer>     |
    | <range>         | The range of positions given by a <range>     |
    | <integer-list>  | The list of positions give in <integer-list>  |

    The function indexs() can be used to convert a value of this data
    type into an index sequence list.

  \subsection dt_geometric Geometric

    For [geometric] specifications and [geometric algebra], [omdl] adds
    the following type specification conventions.

    | name        | description                                       |
    |:-----------:|:--------------------------------------------------|
    | [point]     | a list of numbers to identify a location in space |
    | [vector]    | a direction and magnitude in space                |
    | [line]      | a start and end point in space                    |
    | [normal]    | a vector that is perpendicular to a given object  |
    | [plane]     | a flat two-dimensional infinite surface           |
    | [coords]    | a list of points in space                         |
    | [matrix]    | a rectangular array of values                     |

    When a particular dimension is expected, the dimensional
    expectation is appended to the end of the name after a '-' dash as
    in the following table.

    | name        | description                                       |
    |:-----------:|:--------------------------------------------------|
    | point-Nd    | a point in an 'N' dimensional space               |
    | vector-Nd   | a vector in an 'N' dimensional space              |
    | line-Nd     | a line in an 'N' dimensional space                |
    | coords-Nd   | a coordinate list in an 'N' dimensional space     |
    | matrix-MxN  | a 'M' by 'N' matrix of values                     |

  \subsubsection dt_vectors Vectors and lines

    A [vector] is a direction and magnitude in space. A [line], too,
    has direction and magnitude, but also has location, as it starts at
    one point in space and ends at another. Operators in [omdl] make
    use of a common convention for specifying Euclidean vectors and
    straight lines as summarized in the following table:

    Given two points \c 'p1' and \c 'p2', in space:

    | no. | form      | description                                   |
    |:---:|:---------:|:----------------------------------------------|
    |  1  | p2        | a vector or line from the origin to 'p2'      |
    |  2  | [p2]      | a vector or line from the origin to 'p2'      |
    |  3  | [p1, p2]  | vector or line from 'p1' to 'p2'              |

    \b Example: vector specifications.

    \code{.c}
    // points
    p1 = [a,b,c]
    p2 = [d,e,f]

    // vectors
    v1 = p2       = [d,e,f]
    v2 = [p2]     = [[d,e,f]]
    v3 = [p1, p2] = [[a,b,c], [d,e,f]]

    v1 == v2
    v1 == v2 == v3, iff p1 == origin3d
    \endcode

  \subsubsection dt_planes Planes

    Operators in [omdl] use a common convention for specifying planes.
    A [plane] is identified by a [point] on its surface together with
    its [normal], which is discussed in the following section. A
    point and normal together specify a plane as follows:

    | name    | form                |
    |:-------:|:-------------------:|
    | [plane] | [[point], [normal]] |

  \subsubsection dt_planes_normal Planes' normal

    Given three points \c 'p1', \c 'p2', \c 'p3', and three vectors
    \c 'v1', \c 'v2', \c 'vn', the planes' [normal] can be specified
    in any of the following forms:

    | no. | form          | description                                   |
    |:---:|:-------------:|:----------------------------------------------|
    |  1  | vn            | the predetermined normal vector to the plane  |
    |  2  | [vn]          | the predetermined normal vector to the plane  |
    |  3  | [v1, v2]      | two distinct but intersecting vectors         |
    |  4  | [p1, p2, p3]  | three (or more) non-collinear coplanar points |

    \b Example: plane specifications.

    \code{.c}
    // points
    p1 = [a,b,c];
    p2 = [d,e,f];
    p3 = [g,h,i];

    // vectors
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


  [omdl]: https://royasutton.github.io/omdl
  [Data types]: https://en.wikipedia.org/wiki/Data_type
  [value]: https://en.wikipedia.org/wiki/Value_(computer_science)
  [Euclidean vectors]: https://en.wikipedia.org/wiki/Euclidean_vector

  [OpenSCAD types]: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/The_OpenSCAD_Language#Values_and_Data_Types
  [nan]: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/The_OpenSCAD_Language#Infinities_and_NaNs
  [inf]: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/The_OpenSCAD_Language#Infinities_and_NaNs

  [scalar]: https://en.wikipedia.org/wiki/Variable_(computer_science)
  [iterable]: https://en.wikipedia.org/wiki/Iterator
  [empty]: https://en.wikipedia.org/wiki/Empty_set
  [even]: https://en.wikipedia.org/wiki/Parity_(mathematics)
  [odd]: https://en.wikipedia.org/wiki/Parity_(mathematics)

  [bit]: https://en.wikipedia.org/wiki/Bit
  [integer]: https://en.wikipedia.org/wiki/Integer
  [decimal]: https://en.wikipedia.org/wiki/Decimal
  [datalist]: https://en.wikipedia.org/wiki/Data

  [geometric]: https://en.wikipedia.org/wiki/Geometry
  [geometric algebra]: https://en.wikipedia.org/wiki/Geometric_algebra

  [point]: https://en.wikipedia.org/wiki/Point_(geometry)
  [vector]: https://en.wikipedia.org/wiki/Euclidean_vector
  [line]: https://en.wikipedia.org/wiki/Line_(geometry)
  [normal]: https://en.wikipedia.org/wiki/Normal_(geometry)
  [plane]: https://en.wikipedia.org/wiki/Plane_(geometry)
  [coords]: https://en.wikipedia.org/wiki/Coordinate_system
  [matrix]: https://en.wikipedia.org/wiki/Matrix_(mathematics)
*******************************************************************************/

//----------------------------------------------------------------------------//
// validation results.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \page validation Validation
    \li \subpage tv_datatypes
    \li \subpage tv_math
*******************************************************************************/

//----------------------------------------------------------------------------//
// group categories.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \defgroup constants Constants
  \brief    Design constant definitions.
*******************************************************************************/

/***************************************************************************//**
  \defgroup database Database
  \brief    Design specification data.

  \addtogroup database
  @{

  \defgroup database_component Component
  \brief    Component specifications.

  \defgroup database_electrical Electrical
  \brief    Electrical specifications.

  \defgroup database_geometry Geometry
  \brief    Predefined geometry.

  \defgroup database_material Material
  \brief    Material specifications.

  @}
*******************************************************************************/

/***************************************************************************//**
  \defgroup datatypes Datatypes
  \brief    Data type definitions and operators.

    See \ref dt for nomenclature, assumptions, and conventions used to
    specify values and data types throughout the library.
*******************************************************************************/

/***************************************************************************//**
  \defgroup math Math
  \brief    Mathematical functions.
*******************************************************************************/

/***************************************************************************//**
  \defgroup parts Parts
  \brief    Parametric parts and assemblies.
*******************************************************************************/

/***************************************************************************//**
  \defgroup shapes Shapes
  \brief    2d and 3d shapes.
*******************************************************************************/

/***************************************************************************//**
  \defgroup tools Tools
  \brief    Design tools and techniques.
*******************************************************************************/

/***************************************************************************//**
  \defgroup units Units
  \brief    Units and unit conversions.
*******************************************************************************/

/***************************************************************************//**
  \defgroup utilities Utilities
  \brief    General utilities.
*******************************************************************************/

//----------------------------------------------------------------------------//
// Installing.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \page install Installing

    First install [openscad-amu]. More information can be found at
    [amu on Thingiverse] and in the GitHib [amu repository] where the
    source is maintained.

    A build script exists for \em Linux and \em Cygwin (pull requests
    for \em macos are welcome). If \c wget is not available, here is a
    downloadable link to the [bootstrap script].

    \verbatim
    $ mkdir tmp && cd tmp

    $ wget https://raw.githubusercontent.com/royasutton/openscad-amu/master/snapshots/bootstrap.{bash,conf} .
    $ chmod +x bootstrap.bash

    $ ./bootstrap.bash --yes --install

    $ openscad-seam -v -V
    \endverbatim

    If the last step reports the tool version, then the install most
    likely completed successfully and the temporary directory may be
    removed as desired.

    Now [omdl] can be compiled, verified, and installed. First download
    the source from [omdl on Thingiverse] or clone the GitHub
    [omdl repository] and install as follows:

    \verbatim
    $ git clone https://github.com/royasutton/omdl.git
    $ cd omdl

    $ make install
    \endverbatim

    The library and documentation should now have been installed to the
    OpenSCAD \em built-in library location along with the [omdl]
    reference documentation that can be views with a web browser.

    Have a look in:
    \li \b Linux: $HOME/.local/share/OpenSCAD/libraries
    \li \b Windows: My Documents\\\\OpenSCAD\\\\libraries

    You may include the desired library component from your project
    as follows, replacing the version number as needed:

    \verbatim
    include <omdl-v0.4/shapes2de.scad>;
    include <omdl-v0.4/shapes3d.scad>;
    ...
    \endverbatim


  [omdl]: https://royasutton.github.io/omdl
  [omdl repository]: https://github.com/royasutton/omdl

  [amu on Thingiverse]: http://www.thingiverse.com/thing:1858181
  [omdl on Thingiverse]: http://www.thingiverse.com/thing:1934498

  [openscad-amu]: https://royasutton.github.io/openscad-amu
  [amu repository]: https://github.com/royasutton/openscad-amu
  [bootstrap script]: https://raw.githubusercontent.com/royasutton/openscad-amu/master/snapshots/bootstrap.bash
*******************************************************************************/

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE logo;
  BEGIN_OPENSCAD;
    include <shapes/shapes2de.scad>;
    include <shapes/shapes3d.scad>;

    $fn = 36;

    frame = triangle_lp2ls( [ [30,0], [0,40], [30,40] ] );
    core  = 2 * frame / 3;
    vrnd  = [1, 2, 4];

    cone( h=20, r=10, vr=2 );
    rotate([0, 0, 360/20])
    radial_repeat( n=5, angle=true )
      etriangle_ls_c( vs=frame, vc=core, vr=vrnd, h=10 );
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {config_base,config_png}.mfs;

    views     name "views" distance "250" views "top";
    images    name "slogo" aspect "1:1" xsizes "55";
    variables set_opts_combine "views slogo";

    include --path "${INCLUDE_PATH}" script_std.mfs;
  END_MFSCRIPT;
END_SCOPE;

BEGIN_SCOPE quickstart;
  BEGIN_OPENSCAD;
    include <shapes/shapes2de.scad>;
    include <shapes/shapes3d.scad>;

    $fn = 36;

    frame = triangle_lp2ls( [ [30,0], [0,40], [30,40] ] );
    core  = 2 * frame / 3;
    vrnd  = [1, 2, 4];

    cone( h=20, r=10, vr=2 );
    rotate([0, 0, 360/20])
    radial_repeat( n=5, angle=true )
      etriangle_ls_c( vs=frame, vc=core, vr=vrnd, h=10 );

    translate([0, -50,0])
    linear_extrude(height=10)
    text( text="omdl", size=20, halign="center", valign="center" );
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {config_base,config_png}.mfs;

    views     name "views" views "top bottom right diag";
    variables add_opts_combine "views";
    variables add_opts "--viewall --autocenter";

    include --path "${INCLUDE_PATH}" script_new.mfs;

    include --path "${INCLUDE_PATH}" config_stl.mfs;
    include --path "${INCLUDE_PATH}" script_app.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
