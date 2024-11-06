//! Library documentation start page.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2015-2024

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
    documentation, translatable to common output formats (html, pdf,
    etc). With [omdl], all library operations are \em parametric with
    minimal, mostly zero, global variable dependencies and all library
    API's include [markups] that describe its parameters, behavior, and
    use.

    [Validation] scripts are used to verify that the core operations
    work as expected across evolving [OpenSCAD] versions. This
    validation is performed when building and [installing] the library
    documentation). The library uses a common set of conventions for
    specifying [data types] and is divided into individual component
    modules of functionality, organized into groups, that may be
    included as desired.

  \section starting Getting Started

    \amu_define title         (Hello world)
    \amu_define image_views   (right top front diag)
    \amu_define image_size    (sxga)
    \amu_define image_columns (4)
    \amu_define scope_id      (quickstart)
    \amu_define notes_scad
      ( The \ref make_bearing_linear_rod operations can be used to
        transform 2D and 3D objects into 3D-printable linear rod
        bearings with arbitrary bearing-ball and rod sizes. )
    \amu_define notes_diagrams
      ( Click image above to expand. See the end of ${FILE_NAME} in the
        scope [ \em ${scope_id} ] for the the dimension operations used
        in the above example. )

    \amu_include (include/amu/scope_diagrams_3d.amu)

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

  [Validation]: \ref tv
  [data types]: \ref dt
  [installing]: \ref lb

  [openscad-amu]: https://royasutton.github.io/openscad-amu

  [Doxygen]: http://www.doxygen.nl
  [markups]: http://www.doxygen.nl/manual/commands.html

  [OpenSCAD]: http://www.openscad.org

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

    s  = 10;

    fs = [3, 5, 4] * s;
    cs = fs * 2 / 3;
    vr = [4, 2, 1]/10 * s;

    ft = triangle2d_sss2ppp(fs);
    ct = triangle2d_sss2ppp(cs);

    cone( h=s*2, r=s, vr=2/10*s );
    rotate([0, 0, 360/20])
    repeat_radial( n=5, angle=true )
    extrude_linear_mss( h=s )
    translate(triangle_centroid(ft) + [-15,2]/s)
    difference()
    {
      translate(-triangle_centroid(ft))
      polygon( polygon_round_eve_all_p(ft, vr=vr) );
      translate(-triangle_centroid(ct))
      polygon( polygon_round_eve_all_p(ct, vr=vr) );
    }
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;

    views     name "views" distance "250" views "top";
    images    name "slogo" aspect "1:1" xsizes "55";
    variables set_opts_combine "views slogo";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;

BEGIN_SCOPE quickstart;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <tools/operation_cs.scad>;
    include <tools/drafting/draft-base.scad>;
    include <parts/3d/bearing/bearing_linear_rod.scad>;

    $fn = 36;

    p = [length(0.706, "in"), length(0.622, "in")];
    b = length(6, "mm");

    r = 21.5; c = 6; a = 85;
    h = [b*8, undef, false];

    v = is_undef ( __mfs__diag ) ? 2: undef;

    make_bearing_linear_rod(pipe=p, ball=b, count=c, angle=a, h=h, align=4, view=v)
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
