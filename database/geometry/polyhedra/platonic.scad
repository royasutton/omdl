//! Table of polyhedra data group: \c platonic
/***************************************************************************//**
  \file   platonic.scad
  \author Roy Allen Sutton
  \date   2017

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

      \li [Exact Mathematics] as presented by [Anthony Thyssen],
      \li the [Polyhedron Database] maintained by [Netlib], and
      \li an [Encyclopedia of Polyhedra] by [George W. Hart].

  \note Include this library file using the \b include statement.

  [omdl]: https://github.com/royasutton/omdl

  [Anthony Thyssen]: http://www.ict.griffith.edu.au/anthony/anthony.html
  [Studies into Polyhedra]: http://www.ict.griffith.edu.au/anthony/graphics/polyhedra
  [Exact Mathematics]: http://www.ict.griffith.edu.au/anthony/graphics/polyhedra/maths.shtml

  [George W. Hart]: http://www.georgehart.com
  [Encyclopedia of Polyhedra]: http://www.georgehart.com/virtual-polyhedra/vp.html

  [Netlib]: http://www.netlib.org
  [Polyhedron Database]: http://www.netlib.org/polyhedra

  \ingroup database_polyhedra
*******************************************************************************/

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \addtogroup database_polyhedra
  @{
    <br>
    ### Group: platonic ###

    \amu_define caption (platonic)
    \amu_make png_files (append=db_dim extension=png)
    \amu_make stl_files (append=db_dim extension=stl)

    \amu_shell file_cnt ("echo ${png_files} | wc -w")
    \amu_shell cell_num ("seq -f '(%g)' -s '^' ${file_cnt}")

    \amu_shell html_cell_titles
      (
        "echo ${stl_files} | grep -Po 'db_dim_\K[^.]*' | tr '\n' '^'"
      )

    \htmlonly
      \amu_image_table
        (
          type=html columns=4 image_width="200" cell_files="${png_files}"
          table_caption="${caption}" cell_captions="${cell_num}"
          cell_titles="${html_cell_titles}" cell_urls="${stl_files}"
        )
    \endhtmlonly

    \amu_define caption (platonic)
    \amu_make eps_files (append=db_dim extension=png2eps)

    \latexonly
      \amu_image_table
        (
          type=latex columns=4 image_width="1.25in" cell_files="${eps_files}"
          table_caption="${caption}" cell_captions="${cell_num}"
        )
    \endlatexonly

    \amu_shell data
      (
        "grep -Po 'ECHO: \"\K[^\"]*' build/csg/platonic_db_autostat.log" --rmnl
      )
    \amu_shell columns ("echo '${data}' | awk -F '^' 'NR==1 {print NF;exit}'")
    \amu_shell heading ("echo '${data}' | awk -F '^' 'NR==1 {print;exit}'")
    \amu_shell texts   ("echo '${data}' | awk -F '^' 'NR>1 {print}'")

    \amu_table
      (
        columns=${columns} column_headings="${heading}" cell_texts="${texts}"
      )
*******************************************************************************/
//----------------------------------------------------------------------------//

//! \<table> \c platonic polyhedra data table columns definition.
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
    include <math/math_polytope.scad>;
    include <math/math_utility.scad>;
    include <datatypes/datatypes_table.scad>;
    include <database/geometry/polyhedra/platonic.scad>;

    fs  = "^";

    tc = dtc_polyhedra_platonic;
    tr = dtr_polyhedra_platonic;

    ids = table_get_allrow_ids(tr);

    echo
    (
      str
      (
        "no.", fs, "table id", fs, "other name", fs,
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

      n = table_get(tr, tc, id, "n");
      o = table_get(tr, tc, id, "o");
      g = table_get(tr, tc, id, "g");
      d = table_get(tr, tc, id, "d");

      c = table_get(tr, tc, id, "c");
      s = table_get(tr, tc, id, "s");
      f = table_get(tr, tc, id, "f");
      e = table_get(tr, tc, id, "e");

      fo = is_empty(o) ? "-" : o;

      echo
      (
        str
        (
          i, fs, id, fs, fo, fs,
          len(c), fs, len(f), fs, len(e),

          fs, hist(qsort(polytope_faceverticies(f)), m=9),
          fs, hist(qsort(dround(polytope_faceangles(c, f), d=1)), m=9),
          fs, hist(qsort(sround(polytope_edgelengths(c, e), d=3)), m=9),
          fs, hist(qsort(dround(polytope_edgeangles(c, f), d=1)), m=9),

          fs
        )
      );
    }
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {config_base,config_csg}.mfs;
    include --path "${INCLUDE_PATH}" script_std.mfs;
  END_MFSCRIPT;
END_SCOPE;
END_SCOPE;
*/

/*
BEGIN_SCOPE db;
BEGIN_SCOPE dim;
  BEGIN_OPENSCAD;
    include <constants.scad>;
    include <tools/tools_polytope.scad>;
    include <datatypes/datatypes_table.scad>;
    include <database/geometry/polyhedra/platonic.scad>;

    tc = dtc_polyhedra_platonic;
    tr = dtr_polyhedra_platonic;

    id = "default";
    ct = 1/25;

    config = 0;
    rp = config == 0 ? true : false;
    rs = config == 0 ? true : false;
    rc = config == 0 ? true : false;

    pv = table_get(tr, tc, id, "c");
    pf = table_get(tr, tc, id, "f");
    pe = table_get(tr, tc, id, "e");

    if( rp )
    %polyhedron(points=pv, faces=pf);
    else
    polyhedron(points=pv, faces=pf);

    if ( rs )
    color("lightblue")
    for(p=pv)
      translate(p)
        sphere(r=ct*(1+1/2), $fn=25);

    if ( rc )
    for(e=pe)
      align_axis2v([pv[first(e)], pv[second(e)]], t=2, a=2)
      cylinder(r=ct, h=norm(pv[first(e)]-pv[second(e)]), center=true);
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {config_base,config_png}.mfs;

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
    variables add_opts "-D config=0 --viewall --autocenter";

    include --path "${INCLUDE_PATH}" script_new.mfs;

    include --path "${INCLUDE_PATH}" config_stl.mfs;
    variables add_opts_combine "ids";
    variables add_opts "-D config=1";

    include --path "${INCLUDE_PATH}" script_app.mfs;
  END_MFSCRIPT;
END_SCOPE;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
