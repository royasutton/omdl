//! Polyhedra data table: \c pyramids.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2017-2023

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

    This [omdl] formatted data table has been assembled using a script
    that converts the polyhedra data obtained from [Anthony Thyssen]'s
    [Studies into Polyhedra]. The vertices are tabulated in both their
    original Cartesian as well as their converted spherical coordinate
    form, which is convenient when scaling. The data originates from
    one of three sources:

      \li Exact Mathematics as presented by [Anthony Thyssen],
      \li the [Polyhedron Database] maintained by [Netlib], and
      \li an [Encyclopedia of Polyhedra] by [George W. Hart].

  [omdl]: https://github.com/royasutton/omdl

  [Anthony Thyssen]: http://www.ict.griffith.edu.au/anthony/anthony.html
  [Studies into Polyhedra]: http://www.ict.griffith.edu.au/anthony/graphics/polyhedra

  [George W. Hart]: http://www.georgehart.com
  [Encyclopedia of Polyhedra]: http://www.georgehart.com/virtual-polyhedra/vp.html

  [Netlib]: http://www.netlib.org
  [Polyhedron Database]: http://www.netlib.org/polyhedra

    \amu_pathid parent  (++path_parent)
    \amu_pathid group   (++path)

  \ingroup \amu_eval(${group})
*******************************************************************************/

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \addtogroup \amu_eval(${group})
  @{
    <br>
    ### Pyramids ###
    \amu_include (include/amu/includes_required.amu)

    \amu_eval
      (
        ++global
        title="Examples"
        stem=pyramids scope=db_dim size=qvga view=diag
      )

    \amu_define object_stem (${stem}_${scope}_${size}_${view}_${shape})
    \amu_make     files_png (append=db_dim extension=png)
    \amu_make     files_stl (append=db_dim extension=stl)
    \amu_word     files_cnt (words="${files_png}" ++count)
    \amu_seq       cell_num (prefix="(" suffix=")" last="${files_cnt}" ++number)
    \amu_eval object_prefix (shape="" ${object_stem})
    \amu_filename  cell_txt (files="${files_png}" separator="^" ++stem)
    \amu_replace    cell_id (text="${cell_txt}" search="${object_prefix}" replace="id: ")
    \amu_replace   cell_end (text="${cell_txt}" search="${object_prefix}")
    \amu_replace   cell_end (text="${cell_end}" search="_" replace="<br>")
    \amu_combine   cell_end (p="<center>" s="</center>" j="" f="^" t="^" ${cell_end})

    \htmlonly
      \amu_image_table
        (
          type=html columns=4 image_width="200" cell_files="${files_png}"
          table_caption="${title}" cell_captions="${cell_num}"
          cell_titles="${cell_id}" cell_end="${cell_end}"
          cell_urls="${files_stl}"
        )
    \endhtmlonly

    \amu_make     eps_files (append=db_dim extension=png2eps)

    \latexonly
      \amu_image_table
        (
          type=latex columns=4 image_width="1.25in" cell_files="${eps_files}"
          table_caption="${title}" cell_captions="${cell_num}"
        )
    \endlatexonly

    \b Autostats

    \amu_scope        scope (index=1)
    \amu_file       heading (file="${scope}.log"  last=1 ++rmecho ++rmnl ++read ++quiet)
    \amu_file         texts (file="${scope}.log" first=2 ++rmecho ++rmnl ++read ++quiet)
    \amu_word       columns (tokenizer="^" words="${heading}" ++count)

    \amu_table table
      (
        columns=${columns} column_headings="${heading}" cell_texts="${texts}"
      )

    \amu_if ( -w ${heading} )
      { ${table} }
    else
      { \note Statistics table not available. To build and include, remove
              \c db_autostat from \c scopes_exclude in library makefile.
               For more information see \ref lb. }
    endif
*******************************************************************************/
//----------------------------------------------------------------------------//

//! <map> \c pyramids polyhedra data table columns definition.
//! \hideinitializer
dtc_polyhedra_pyramids =
[
  ["id", "identifier"],
  ["n", "name"],
  ["o", "other name"],
  ["g", "group"],
  ["d", "data source"],
  ["c", "cartesian vertices"],
  ["s", "spherical vertices"],
  ["f", "faces"],
  ["e", "edges"]
];

//! \<table> \c pyramids polyhedra data table rows.
//! \hideinitializer
dtr_polyhedra_pyramids =
[
  [
    "pentagonal_dipyramid",
    "Pentagonal Dipyramid",
    "J13",
    "pyramids",
    "Polyhedron Database #57",
    [
      [ 0.00000000000,  0.61803398875,  0.00000000000],
      [ 0.00000000000, -0.00000000000,  1.00000000000],
      [ 0.95105651630, -0.00000000000,  0.30901699437],
      [-0.95105651630, -0.00000000000,  0.30901699437],
      [ 0.58778525229,  0.00000000000, -0.80901699437],
      [-0.58778525229, -0.00000000000, -0.80901699437],
      [ 0.00000000000, -0.61803398875,  0.00000000000]
    ],
    [
      [0.61803398875,   89.99999999999,  89.99999999999],
      [1.00000000000,   -0.00000000000,   0.00000000000],
      [1.00000000000,   -0.00000000000,  72.00000000000],
      [1.00000000000, -179.99999999999,  72.00000000000],
      [1.00000000000,    0.00000000000, 143.99999999999],
      [1.00000000000, -179.99999999999, 143.99999999999],
      [0.61803398875,  -89.99999999999,  89.99999999999]
    ],
    [
      [0,2,1],
      [0,5,4],
      [0,4,2],
      [0,1,3],
      [0,3,5],
      [6,1,2],
      [6,4,5],
      [6,2,4],
      [6,3,1],
      [6,5,3]
    ],
    [
      [0,1],
      [0,2],
      [0,3],
      [0,4],
      [0,5],
      [1,2],
      [1,3],
      [1,6],
      [2,4],
      [2,6],
      [3,5],
      [3,6],
      [4,5],
      [4,6],
      [5,6]
    ]
  ],
  [
    "pentagonal_pyramid",
    "Pentagonal Pyramid",
    "J2",
    "pyramids",
    "Polyhedron Database #46",
    [
      [ 0.00000000000,  0.51231760759,  0.00000000000],
      [ 0.00000000000, -0.10246352152,  0.99473676254],
      [ 0.94605088002, -0.10246352152,  0.30739056456],
      [-0.94605088002, -0.10246352152,  0.30739056456],
      [ 0.58469159894, -0.10246352152, -0.80475894583],
      [-0.58469159894, -0.10246352152, -0.80475894583]
    ],
    [
      [0.51231760759,   89.99999999999,  89.99999999999],
      [1.00000000000,  -89.99999999999,   5.88104874729],
      [1.00000000000,   -6.18141426337,  72.09795604403],
      [1.00000000000, -173.81858573661,  72.09795604404],
      [1.00000000000,   -9.93979324212, 143.58698182134],
      [1.00000000000, -170.06020675786, 143.58698182134]
    ],
    [
      [0,2,1],
      [0,5,4],
      [0,4,2],
      [0,1,3],
      [0,3,5],
      [1,2,4,5,3]
    ],
    [
      [0,1],
      [0,2],
      [0,3],
      [0,4],
      [0,5],
      [1,2],
      [1,3],
      [2,4],
      [3,5],
      [4,5]
    ]
  ],
  [
    "square_dipryamid",
    "Square Dipryamid",
    "Octahedron",
    "pyramids",
    "Exact Mathematics",
    [
      [ 0.00000000000,  1.00000000000,  0.00000000000],
      [-1.00000000000,  0.00000000000,  0.00000000000],
      [ 0.00000000000,  0.00000000000, -1.00000000000],
      [ 1.00000000000,  0.00000000000,  0.00000000000],
      [ 0.00000000000,  0.00000000000,  1.00000000000],
      [ 0.00000000000, -1.00000000000,  0.00000000000]
    ],
    [
      [1.00000000000,   89.99999999999,  89.99999999999],
      [1.00000000000,  179.99999999999,  89.99999999999],
      [1.00000000000,    0.00000000000, 179.99999999999],
      [1.00000000000,    0.00000000000,  89.99999999999],
      [1.00000000000,    0.00000000000,   0.00000000000],
      [1.00000000000,  -89.99999999999,  89.99999999999]
    ],
    [
      [0,1,2],
      [0,2,3],
      [0,3,4],
      [0,4,1],
      [5,2,1],
      [5,3,2],
      [5,4,3],
      [5,1,4]
    ],
    [
      [0,1],
      [0,2],
      [0,3],
      [0,4],
      [1,2],
      [1,4],
      [1,5],
      [2,3],
      [2,5],
      [3,4],
      [3,5],
      [4,5]
    ]
  ],
  [
    "square_pyramid",
    "Square Pyramid",
    "J1",
    "pyramids",
    "Exact Mathematics",
    [
      [ 0.00000000000,  1.00000000000,  0.00000000000],
      [-1.00000000000,  0.00000000000,  0.00000000000],
      [ 0.00000000000,  0.00000000000, -1.00000000000],
      [ 1.00000000000,  0.00000000000,  0.00000000000],
      [ 0.00000000000,  0.00000000000,  1.00000000000]
    ],
    [
      [1.00000000000,   89.99999999999,  89.99999999999],
      [1.00000000000,  179.99999999999,  89.99999999999],
      [1.00000000000,    0.00000000000, 179.99999999999],
      [1.00000000000,    0.00000000000,  89.99999999999],
      [1.00000000000,    0.00000000000,   0.00000000000]
    ],
    [
      [0,1,2],
      [0,2,3],
      [0,3,4],
      [0,4,1],
      [4,3,2,1]
    ],
    [
      [0,1],
      [0,2],
      [0,3],
      [0,4],
      [1,2],
      [1,4],
      [2,3],
      [3,4]
    ]
  ],
  [
    "triangular_dipyramid",
    "Triangular Dipyramid",
    "J12",
    "pyramids",
    "Exact Mathematics",
    [
      [ 0.00000000000,  1.00000000000,  0.00000000000],
      [-0.61237243570,  0.00000000000,  0.35355339059],
      [ 0.61237243570,  0.00000000000,  0.35355339059],
      [ 0.00000000000,  0.00000000000, -0.70710678119],
      [ 0.00000000000, -1.00000000000,  0.00000000000]
    ],
    [
      [1.00000000000,   89.99999999999,  89.99999999999],
      [0.70710678119,  179.99999999999,  59.99999999999],
      [0.70710678119,    0.00000000000,  59.99999999999],
      [0.70710678119,    0.00000000000, 179.99999999999],
      [1.00000000000,  -89.99999999999,  89.99999999999]
    ],
    [
      [0,2,1],
      [0,1,3],
      [0,3,2],
      [4,1,2],
      [4,3,1],
      [4,2,3]
    ],
    [
      [0,1],
      [0,2],
      [0,3],
      [1,2],
      [1,3],
      [1,4],
      [2,3],
      [2,4],
      [3,4]
    ]
  ],
  [
    "triangular_pyramid",
    "Triangular Pyramid",
    "Tetrahedron",
    "pyramids",
    "Exact Mathematics",
    [
      [ 0.00000000000,  1.00000000000,  0.00000000000],
      [-0.81649658093, -0.33333333333,  0.47140452079],
      [ 0.81649658093, -0.33333333333,  0.47140452079],
      [-0.00000000000, -0.33333333333, -0.94280904158]
    ],
    [
      [1.00000000000,   89.99999999999,  89.99999999999],
      [1.00000000000, -157.79234570139,  61.87449429794],
      [1.00000000000,  -22.20765429859,  61.87449429794],
      [1.00000000000,  -89.99999999999, 160.52877936550]
    ],
    [
      [0,2,1],
      [0,1,3],
      [0,3,2],
      [1,2,3]
    ],
    [
      [0,1],
      [0,2],
      [0,3],
      [1,2],
      [1,3],
      [2,3]
    ]
  ]
];

//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE db;
BEGIN_SCOPE autostat;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <database/geometry/polyhedra/pyramids.scad>;

    fs  = "^";

    tc = dtc_polyhedra_pyramids;
    tr = dtr_polyhedra_pyramids;

    ids = table_get_row_ids(tr);

    echo
    (
      str
      (
        "no.", fs, "id", fs, "other name", fs,
        "vertices", fs, "faces", fs, "edges",

        fs, "face-verticies",
        fs, "face-angles",
        fs, "edge-lengths",
        fs, "edge-angles"
      )
    );

    for ( id = ids )
    {
      i = first(find(id, ids, c=1))+1;

      n = table_get_value(tr, tc, id, "n");
      o = table_get_value(tr, tc, id, "o");
      g = table_get_value(tr, tc, id, "g");
      d = table_get_value(tr, tc, id, "d");

      c = table_get_value(tr, tc, id, "c");
      s = table_get_value(tr, tc, id, "s");
      f = table_get_value(tr, tc, id, "f");
      e = table_get_value(tr, tc, id, "e");

      fo = is_empty(o) ? "-" : o;

      echo
      (
        str
        (
          i, fs, id, fs, fo, fs,
          len(c), fs, len(f), fs, len(e),

          fs, histogram(sort_q(polytope_face_vertex_counts(f)), m=9),
          fs, histogram(sort_q(round_d(polytope_face_angles(c, f), d=1)), m=9),
          fs, histogram(sort_q(round_s(polytope_edge_lengths(c, e), d=3)), m=9),
          fs, histogram(sort_q(round_d(polytope_edge_angles(c, f), d=1)), m=9),

          fs
        )
      );
    }
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_term}.mfs;
    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
END_SCOPE;
*/

/*
BEGIN_SCOPE db;
BEGIN_SCOPE dim;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <units/coordinate.scad>;
    include <tools/align.scad>;
    include <tools/polytope.scad>;
    include <database/geometry/polyhedra/pyramids.scad>;

    config = 0;

    tc = dtc_polyhedra_pyramids;
    tr = dtr_polyhedra_pyramids;

    id = "default";
    sr = 100;

    pv = table_get_value(tr, tc, id, "c");
    pf = table_get_value(tr, tc, id, "f");
    pe = table_get_value(tr, tc, id, "e");

    sv = coordinate_scale3d_csc(pv, sr);

    if (config == 0)  // png preview
    {
      $fn = 25;

      %polyhedron(sv, pf);

      polytope_frame(sv, pf, pe)
      {
        circle(r = sr / 25);
        color("lightblue")
        sphere(r = sr / 25 * (1 + 1/2));
      }
    }

    if (config == 1)  // stl model
    {
      polyhedron(sv, pf);
    }
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;

    views     name "views" views "diag";
    defines   name "ids" define "id"
              strings
              "
                pentagonal_dipyramid
                pentagonal_pyramid
                square_dipryamid
                square_pyramid
                triangular_dipyramid
                triangular_pyramid
              ";
    variables add_opts_combine "views ids";
    variables add_opts "-D config=0 --viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf_begin.mfs;
    include --path "${INCLUDE_PATH}" scr_make_mf_add_ext.mfs;

    include --path "${INCLUDE_PATH}" var_gen_stl.mfs;
    variables add_opts_combine "ids";
    variables add_opts "-D config=1";

    include --path "${INCLUDE_PATH}" scr_make_mf_add_ext.mfs;
    include --path "${INCLUDE_PATH}" scr_make_mf_end.mfs;
  END_MFSCRIPT;
END_SCOPE;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
