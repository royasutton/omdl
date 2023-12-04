//! Library documentation start page.
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

*******************************************************************************/

//----------------------------------------------------------------------------//
// introduction.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \mainpage Introduction
  \tableofcontents

  \anchor introduction

    [omdl] is an [OpenSCAD] mechanical design library that provides
    open-source high-level design primitives with coherent
    documentation generated by [Doxygen] using [openscad-amu].

    With Doxygen, the code documentation is written within the code
    itself, and is thus easy to keep current. Moreover, it provides a
    standard way to both write and present OpenSCAD design
    documentation, compilable to common output formats (html, pdf,
    etc). With [omdl], all library primitives are \em parametric with
    minimal, mostly zero, global variable dependencies and all library
    API's include [markups] that describe its parameters, behavior, and
    use.

    [Validation] scripts are used to verify that the core operations
    work as expected across evolving [OpenSCAD] versions (validation
    performed when building the documentation). The library uses a
    common set of conventions for specifying [data types] and is
    divided into individual component modules of functionality,
    organized into groups, that may be included as desired.

  \section starting Getting Started

    \b Example:

    \dontinclude \amu_scope(index=2).scad
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
  [issue]: https://github.com/royasutton/omdl/issues

  [Validation]: \ref validation
  [data types]: \ref dt
  [installation]: \ref install

  [openscad-amu]: https://royasutton.github.io/openscad-amu

  [Doxygen]: http://www.doxygen.nl
  [markups]: http://www.doxygen.nl/manual/commands.html

  [OpenSCAD]: http://www.openscad.org
  [library location]: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Libraries

  [git]: http://git-scm.com
  [GitHub]: http://github.com
  [forking]: http://help.github.com/forking
  [pull requests]: https://help.github.com/articles/about-pull-requests
*******************************************************************************/

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE logo;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;

    $fn = 36;

    frame = triangle_ppp2sss( [[30,40], [30,0], [0,40]] );
    core  = 2 * frame / 3;
    vrnd  = [1, 2, 4];

    cone( h=20, r=10, vr=2 );
    rotate([0, 0, 360/20])
    repeat_radial( n=5, angle=true )
      translate([15,-5,0])
        extrude_linear_uls( h=10 )
          triangle_ls_c( vs=frame, vc=core, vr=vrnd );
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
    include <omdl-base.scad>;

    $fn = 36;

    frame = triangle_ppp2sss( [[30,40], [30,0], [0,40]] );
    core  = 2 * frame / 3;
    vrnd  = [1, 2, 4];

    cone( h=20, r=10, vr=2 );
    rotate([0, 0, 360/20])
    repeat_radial( n=5, angle=true )
      translate([15,-5,0])
        extrude_linear_uls( h=10 )
          triangle_ls_c( vs=frame, vc=core, vr=vrnd );

    translate([0, -50, 0])
    linear_extrude(height=10)
    text( text="omdl", size=20, halign="center", valign="center" );
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {config_base,config_png}.mfs;

    views     name "views" views "top bottom right diag";
    variables add_opts_combine "views";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" script_new.mfs;

    include --path "${INCLUDE_PATH}" config_stl.mfs;
    include --path "${INCLUDE_PATH}" script_app.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
