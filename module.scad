//! Root Module documentation.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2018-2023

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
    the [OpenSCAD types] documentation is refereed to as a \em list
    here in order to distinguish between sequential lists of values and
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

    When a list has an expected number of elements 'n', the \em count
    is appended following a '-'. When there is a range of expected
    elements, the lower and upper bounds are separated by a ':' and
    appended (order of bounds may be reversed). When the elements
    values are of an expected type, that \em type is prepended.
    Combinations are used as needed as in the following table:

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
    following general type specifications and conventions.

    | name          | description                                     |
    |:-------------:|:------------------------------------------------|
    | [bit]         | a binary numerical value (0 or 1)               |
    | [integer]     | a positive, negative, or zero whole number      |
    | [decimal]     | integer numbers with a fractional part          |
    | [index]       | a list index sequence                           |
    | [datastruct]  | a defined data structure                        |
    | [data]        | an arbitrary data structure                     |

  \subsubsection dt_index Index sequence

    The data type \b index refers to a specified sequence of list
    element indexes. A list index sequence may be specified in one of
    the following forms.

    | value / form    | description                                   |
    |:---------------:|:----------------------------------------------|
    | \b true         | All index positions of the list [0:size-1]    |
    | \b false        | No index positions                            |
    | "all"           | All index positions of the list [0:size-1]    |
    | "none"          | No index positions                            |
    | "rands"         | Random index selection of the list [0:size-1] |
    | "even"          | The even index of the list [0:size-1]         |
    | "odd"           | The odd index of the list [0:size-1]          |
    | <integer>       | The single position given by an <integer>     |
    | <range>         | The range of positions given by a <range>     |
    | <integer-list>  | The list of positions give in <integer-list>  |

    The function get_index() can be used to convert a value of this
    data type into a sequence of list element indexes.

    \b Example

    \code{.c}
    // list
    l1 = [a,b,c,d,e,f]

    // index sequence
    get_index(l1)          = [0,1,2,3,4,5]
    get_index(l1, "rands") = [0,2,5]
    \endcode

  \subsection dt_geometric Geometric

    For [geometric] specifications and [geometric algebra], [omdl] adds
    the following type specifications and conventions.

    | name        | description                                       |
    |:-----------:|:--------------------------------------------------|
    | [point]     | a list of numbers to identify a location in space |
    | [vector]    | a direction and magnitude in space                |
    | [line]      | a start and end point in space ([line wiki])      |
    | [normal]    | a vector that is perpendicular to a given object  |
    | [pnorm]     | a vector that is perpendicular to a plane         |
    | [plane]     | a flat 2d infinite surface ([plane wiki])         |
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

  \subsubsection dt_line Lines and vectors

    A \b vector has a direction and magnitude in space. A \b line, too,
    has direction and magnitude, but also has location, as it starts at
    one point in space and ends at another. Although a line can be
    specified in one dimension, most library functions operate on two
    and/or three dimensional lines. Operators in [omdl] make use of a
    common convention for specifying Euclidean vectors and straight
    lines as summarized in the following table:

    Given two points \c 'p1' and \c 'p2', in space:

    | no. | form      | description                       |
    |:---:|:---------:|:----------------------------------|
    |  1  | p2        | a vector from the origin to 'p2'  |
    |  2  | [p2]      | a vector from the origin to 'p2'  |
    |  3  | [p1, p2]  | a line from 'p1' to 'p2'          |

    The functions is_point(), is_vector(), is_line(), line_dim(),
    line_tp(), line_ip(), vector_to_line(), and line_to_vector(), are
    available for type identification and convertion.

    \b Example

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

  \subsubsection dt_plane Planes

    Operators in [omdl] use a common convention for specifying planes.
    A \b plane is identified by a [point] on its surface together with
    its [normal] vector specified by [pnorm], which is discussed in the
    following section. A list with a point and normal together specify
    the plane as follows:

    | name    | form                |
    |:-------:|:-------------------:|
    | [plane] | [[point], [pnorm]]  |

  \subsubsection dt_pnorm Planes' normal

    The data type \b pnorm refers to a convention for specifying a
    direction vector that is perpendicular to a plane. Given three
    points \c 'p1', \c 'p2', \c 'p3', and three vectors \c 'v1',
    \c 'v2', \c 'vn', the planes' [normal] can be specified in any of
    the following forms:

    | no. | form          | description                                   |
    |:---:|:-------------:|:----------------------------------------------|
    |  1  | vn            | the predetermined normal vector to the plane  |
    |  2  | [vn]          | the predetermined normal vector to the plane  |
    |  3  | [v1, v2]      | two distinct but intersecting vectors         |
    |  4  | [p1, p2, p3]  | three (or more) non-collinear coplanar points |

    The functions is_plane() and plane_to_normal() are available for
    type identification and convertion.

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

  [omdl]: https://royasutton.github.io/omdl
  [Data types]: https://en.wikipedia.org/wiki/Data_type
  [value]: https://en.wikipedia.org/wiki/Value_(computer_science)
  [Euclidean vectors]: https://en.wikipedia.org/wiki/Euclidean_vector

  [OpenSCAD types]: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/The_OpenSCAD_Language#Values_and_data_types
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
  [index]: \ref dt_index
  [datastruct]: https://en.wikipedia.org/wiki/Data_structure
  [data]: https://en.wikipedia.org/wiki/Data

  [geometric]: https://en.wikipedia.org/wiki/Geometry
  [geometric algebra]: https://en.wikipedia.org/wiki/Geometric_algebra

  [point]: https://en.wikipedia.org/wiki/Point_(geometry)
  [vector]: https://en.wikipedia.org/wiki/Euclidean_vector
  [line wiki]: https://en.wikipedia.org/wiki/Line_(geometry)
  [line]: \ref dt_line
  [normal]: https://en.wikipedia.org/wiki/Normal_(geometry)
  [pnorm]: \ref dt_pnorm
  [plane wiki]: https://en.wikipedia.org/wiki/Plane_(geometry)
  [plane]: \ref dt_plane
  [coords]: https://en.wikipedia.org/wiki/Coordinate_system
  [matrix]: https://en.wikipedia.org/wiki/Matrix_(mathematics)
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
    \amu_include (include/amu/validate_log_th.amu)
    \amu_table(columns=${tv_tc} column_headings=${tv_th})
*******************************************************************************/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
