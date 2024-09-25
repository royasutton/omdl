//! Polyhedra data table: \c platonic.
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
    ### Platonic ###
    \amu_include (include/amu/includes_required.amu)

    \amu_eval
      (
        ++global
        title="Examples"
        stem=platonic scope=db_dim size=qvga view=diag
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

//! <map> \c platonic polyhedra data table columns definition.
//! \hideinitializer
dtc_polyhedra_platonic =
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

//! \<table> \c platonic polyhedra data table rows.
//! \hideinitializer
dtr_polyhedra_platonic =
[
  [
    "cube",
    "Cube",
    "Hexahedron",
    "platonic",
    "Exact Mathematics",
    [
      [ 1.00000000000,  1.00000000000,  1.00000000000],
      [ 1.00000000000,  1.00000000000, -1.00000000000],
      [ 1.00000000000, -1.00000000000,  1.00000000000],
      [ 1.00000000000, -1.00000000000, -1.00000000000],
      [-1.00000000000,  1.00000000000,  1.00000000000],
      [-1.00000000000,  1.00000000000, -1.00000000000],
      [-1.00000000000, -1.00000000000,  1.00000000000],
      [-1.00000000000, -1.00000000000, -1.00000000000]
    ],
    [
      [1.73205080757,   45.00000000000,  54.73561031724],
      [1.73205080757,   45.00000000000, 125.26438968275],
      [1.73205080757,  -45.00000000000,  54.73561031724],
      [1.73205080757,  -45.00000000000, 125.26438968275],
      [1.73205080757,  134.99999999999,  54.73561031724],
      [1.73205080757,  134.99999999999, 125.26438968275],
      [1.73205080757, -134.99999999999,  54.73561031724],
      [1.73205080757, -134.99999999999, 125.26438968275]
    ],
    [
      [6,4,0,2],
      [5,1,0,4],
      [7,5,4,6],
      [1,3,2,0],
      [3,7,6,2],
      [7,3,1,5]
    ],
    [
      [0,1],
      [0,2],
      [0,4],
      [1,3],
      [1,5],
      [2,3],
      [2,6],
      [3,7],
      [4,5],
      [4,6],
      [5,7],
      [6,7]
    ]
  ],
  [
    "dodecahedron",
    "Dodecahedron",
    empty_str,
    "platonic",
    "Exact Mathematics",
    [
      [ 0.57735026919,  0.57735026919,  0.57735026919],
      [-0.00000000000,  0.93417235896, -0.35682208977],
      [-0.57735026919,  0.57735026919,  0.57735026919],
      [-0.00000000000,  0.93417235896,  0.35682208977],
      [-0.93417235896,  0.35682208977, -0.00000000000],
      [-0.57735026919,  0.57735026919, -0.57735026919],
      [ 0.93417235896, -0.35682208977, -0.00000000000],
      [ 0.93417235896,  0.35682208977, -0.00000000000],
      [ 0.57735026919,  0.57735026919, -0.57735026919],
      [ 0.57735026919, -0.57735026919,  0.57735026919],
      [ 0.35682208977,  0.00000000000,  0.93417235896],
      [-0.35682208977,  0.00000000000,  0.93417235896],
      [-0.93417235896, -0.35682208977, -0.00000000000],
      [-0.57735026919, -0.57735026919,  0.57735026919],
      [-0.00000000000, -0.93417235896,  0.35682208977],
      [ 0.35682208977,  0.00000000000, -0.93417235896],
      [ 0.57735026919, -0.57735026919, -0.57735026919],
      [-0.00000000000, -0.93417235896, -0.35682208977],
      [-0.35682208977,  0.00000000000, -0.93417235896],
      [-0.57735026919, -0.57735026919, -0.57735026919]
    ],
    [
      [1.00000000000,   45.00000000000,  54.73561031724],
      [1.00000000000,   89.99999999999, 110.90515744788],
      [1.00000000000,  134.99999999999,  54.73561031724],
      [1.00000000000,   89.99999999999,  69.09484255211],
      [1.00000000000,  159.09484255210,  89.99999999999],
      [1.00000000000,  134.99999999999, 125.26438968275],
      [1.00000000000,  -20.90515744789,  89.99999999999],
      [1.00000000000,   20.90515744789,  89.99999999999],
      [1.00000000000,   45.00000000000, 125.26438968275],
      [1.00000000000,  -45.00000000000,  54.73561031724],
      [1.00000000000,    0.00000000000,  20.90515744789],
      [1.00000000000,  179.99999999999,  20.90515744789],
      [1.00000000000, -159.09484255210,  89.99999999999],
      [1.00000000000, -134.99999999999,  54.73561031724],
      [1.00000000000,  -89.99999999999,  69.09484255211],
      [1.00000000000,    0.00000000000, 159.09484255210],
      [1.00000000000,  -45.00000000000, 125.26438968275],
      [1.00000000000,  -89.99999999999, 110.90515744788],
      [1.00000000000,  179.99999999999, 159.09484255210],
      [1.00000000000, -134.99999999999, 125.26438968275]
    ],
    [
      [2,4,5,1,3],
      [0,7,6,9,10],
      [8,15,16,6,7],
      [8,7,0,3,1],
      [5,18,15,8,1],
      [0,10,11,2,3],
      [6,16,17,14,9],
      [11,13,12,4,2],
      [11,10,9,14,13],
      [19,17,16,15,18],
      [19,12,13,14,17],
      [18,5,4,12,19]
    ],
    [
      [0,3],
      [0,7],
      [0,10],
      [1,3],
      [1,5],
      [1,8],
      [2,3],
      [2,4],
      [2,11],
      [4,5],
      [4,12],
      [5,18],
      [6,7],
      [6,9],
      [6,16],
      [7,8],
      [8,15],
      [9,10],
      [9,14],
      [10,11],
      [11,13],
      [12,13],
      [12,19],
      [13,14],
      [14,17],
      [15,16],
      [15,18],
      [16,17],
      [17,19],
      [18,19]
    ]
  ],
  [
    "icosahedron",
    "Icosahedron",
    empty_str,
    "platonic",
    "Exact Mathematics",
    [
      [-1.00000000000,  0.00000000000,  0.61803398875],
      [ 1.00000000000,  0.00000000000,  0.61803398875],
      [-1.00000000000,  0.00000000000, -0.61803398875],
      [ 1.00000000000,  0.00000000000, -0.61803398875],
      [ 0.00000000000,  0.61803398875,  1.00000000000],
      [ 0.00000000000,  0.61803398875, -1.00000000000],
      [ 0.00000000000, -0.61803398875,  1.00000000000],
      [ 0.00000000000, -0.61803398875, -1.00000000000],
      [ 0.61803398875,  1.00000000000,  0.00000000000],
      [-0.61803398875,  1.00000000000,  0.00000000000],
      [ 0.61803398875, -1.00000000000,  0.00000000000],
      [-0.61803398875, -1.00000000000,  0.00000000000]
    ],
    [
      [1.17557050458,  179.99999999999,  58.28252558853],
      [1.17557050458,    0.00000000000,  58.28252558853],
      [1.17557050458,  179.99999999999, 121.71747441145],
      [1.17557050458,    0.00000000000, 121.71747441145],
      [1.17557050458,   89.99999999999,  31.71747441146],
      [1.17557050458,   89.99999999999, 148.28252558853],
      [1.17557050458,  -89.99999999999,  31.71747441146],
      [1.17557050458,  -89.99999999999, 148.28252558853],
      [1.17557050458,   58.28252558853,  89.99999999999],
      [1.17557050458,  121.71747441145,  89.99999999999],
      [1.17557050458,  -58.28252558853,  89.99999999999],
      [1.17557050458, -121.71747441145,  89.99999999999]
    ],
    [
      [4,8,1],
      [10,6,1],
      [4,6,0],
      [6,4,1],
      [8,3,1],
      [3,10,1],
      [4,9,8],
      [2,9,0],
      [9,4,0],
      [11,6,10],
      [11,2,0],
      [6,11,0],
      [5,3,8],
      [9,5,8],
      [5,9,2],
      [3,7,10],
      [7,11,10],
      [11,7,2],
      [7,5,2],
      [5,7,3]
    ],
    [
      [0,2],
      [0,4],
      [0,6],
      [0,9],
      [0,11],
      [1,3],
      [1,4],
      [1,6],
      [1,8],
      [1,10],
      [2,5],
      [2,7],
      [2,9],
      [2,11],
      [3,5],
      [3,7],
      [3,8],
      [3,10],
      [4,6],
      [4,8],
      [4,9],
      [5,7],
      [5,8],
      [5,9],
      [6,10],
      [6,11],
      [7,10],
      [7,11],
      [8,9],
      [10,11]
    ]
  ],
  [
    "octahedron",
    "Octahedron",
    empty_str,
    "platonic",
    "Exact Mathematics",
    [
      [ 0.00000000000,  0.00000000000,  1.00000000000],
      [ 0.00000000000,  1.00000000000,  0.00000000000],
      [-1.00000000000,  0.00000000000,  0.00000000000],
      [ 1.00000000000,  0.00000000000,  0.00000000000],
      [ 0.00000000000, -1.00000000000,  0.00000000000],
      [ 0.00000000000,  0.00000000000, -1.00000000000]
    ],
    [
      [1.00000000000,    0.00000000000,   0.00000000000],
      [1.00000000000,   89.99999999999,  89.99999999999],
      [1.00000000000,  179.99999999999,  89.99999999999],
      [1.00000000000,    0.00000000000,  89.99999999999],
      [1.00000000000,  -89.99999999999,  89.99999999999],
      [1.00000000000,    0.00000000000, 179.99999999999]
    ],
    [
      [1,0,2],
      [0,1,3],
      [5,1,2],
      [1,5,3],
      [4,0,3],
      [0,4,2],
      [4,5,2],
      [5,4,3]
    ],
    [
      [0,1],
      [0,2],
      [0,3],
      [0,4],
      [1,2],
      [1,3],
      [2,4],
      [3,4],
      [1,5],
      [2,5],
      [3,5],
      [4,5]
    ]
  ],
  [
    "tetrahedron",
    "Tetrahedron",
    empty_str,
    "platonic",
    "Exact Mathematics",
    [
      [ 1.00000000000,  1.00000000000, -1.00000000000],
      [-1.00000000000,  1.00000000000,  1.00000000000],
      [ 1.00000000000, -1.00000000000,  1.00000000000],
      [-1.00000000000, -1.00000000000, -1.00000000000]
    ],
    [
      [1.73205080757,   45.00000000000, 125.26438968275],
      [1.73205080757,  134.99999999999,  54.73561031724],
      [1.73205080757,  -45.00000000000,  54.73561031724],
      [1.73205080757, -134.99999999999, 125.26438968275]
    ],
    [
      [0,2,1],
      [3,0,1],
      [2,3,1],
      [3,2,0]
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
    include <database/geometry/polyhedra/platonic.scad>;

    fs  = "^";

    tc = dtc_polyhedra_platonic;
    tr = dtr_polyhedra_platonic;

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
    include <database/geometry/polyhedra/platonic.scad>;

    config = 0;

    tc = dtc_polyhedra_platonic;
    tr = dtr_polyhedra_platonic;

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
                cube
                dodecahedron
                icosahedron
                octahedron
                tetrahedron
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
