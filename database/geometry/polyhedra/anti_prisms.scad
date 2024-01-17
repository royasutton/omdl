//! Polyhedra data table: \c anti_prisms.
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
    ### Anti Prisms ###
    \amu_include (include/amu/includes_required.amu)

    \amu_eval
      (
        ++global
        title="Examples"
        stem=anti_prisms scope=db_dim size=qvga view=diag
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

//! <map> \c anti_prisms polyhedra data table columns definition.
//! \hideinitializer
dtc_polyhedra_anti_prisms =
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

//! \<table> \c anti_prisms polyhedra data table rows.
//! \hideinitializer
dtr_polyhedra_anti_prisms =
[
  [
    "decagonal_antiprism",
    "Decagonal Antiprism",
    empty_str,
    "anti_prisms",
    "Polyhedron Database #31",
    [
      [-0.96627614511,  0.25750808025,  0.00000000000],
      [-0.91898322435, -0.25750808025,  0.29859575010],
      [-0.91898322435, -0.25750808025, -0.29859575010],
      [-0.78173382265,  0.25750808025,  0.56796286774],
      [-0.78173382265,  0.25750808025, -0.56796286774],
      [-0.56796286774, -0.25750808025,  0.78173382265],
      [-0.56796286774, -0.25750808025, -0.78173382265],
      [-0.29859575010,  0.25750808025,  0.91898322435],
      [-0.29859575010,  0.25750808025, -0.91898322435],
      [ 0.00000000000, -0.25750808025,  0.96627614511],
      [-0.00000000000, -0.25750808025, -0.96627614511],
      [ 0.29859575010,  0.25750808025,  0.91898322435],
      [ 0.29859575010,  0.25750808025, -0.91898322435],
      [ 0.56796286774, -0.25750808025,  0.78173382265],
      [ 0.56796286774, -0.25750808025, -0.78173382265],
      [ 0.78173382265,  0.25750808025,  0.56796286774],
      [ 0.78173382265,  0.25750808025, -0.56796286774],
      [ 0.91898322435, -0.25750808025,  0.29859575010],
      [ 0.91898322435, -0.25750808025, -0.29859575010],
      [ 0.96627614511,  0.25750808025,  0.00000000000]
    ],
    [
      [1.00000000000,  165.07774833349,  89.99999999998],
      [1.00000000000, -164.34660886021,  72.62671986748],
      [1.00000000000, -164.34660886022, 107.37328013251],
      [1.00000000000,  161.76778911692,  55.39170785296],
      [1.00000000000,  161.76778911692, 124.60829214706],
      [1.00000000000, -155.61098626194,  38.58040216792],
      [1.00000000000, -155.61098626190, 141.41959783208],
      [1.00000000000,  139.22561430131,  23.22211397117],
      [1.00000000000,  139.22561430129, 156.77788602884],
      [1.00000000000,  -89.99999999999,  14.92225166649],
      [1.00000000000,  -90.00000000002, 165.07774833348],
      [1.00000000000,   40.77438569868,  23.22211397117],
      [1.00000000000,   40.77438569868, 156.77788602883],
      [1.00000000000,  -24.38901373808,  38.58040216789],
      [1.00000000000,  -24.38901373808, 141.41959783206],
      [1.00000000000,   18.23221088306,  55.39170785296],
      [1.00000000000,   18.23221088307, 124.60829214706],
      [1.00000000000,  -15.65339113976,  72.62671986755],
      [1.00000000000,  -15.65339113978, 107.37328013249],
      [1.00000000000,   14.92225166649,  89.99999999998]
    ],
    [
      [13,17,18,14,10,6,2,1,5,9],
      [3,0,4,8,12,16,19,15,11,7],
      [8,10,12],
      [6,10,8],
      [4,6,8],
      [2,6,4],
      [0,2,4],
      [1,2,0],
      [3,1,0],
      [5,1,3],
      [7,5,3],
      [9,5,7],
      [11,9,7],
      [13,9,11],
      [15,13,11],
      [17,13,15],
      [19,17,15],
      [18,17,19],
      [16,18,19],
      [14,18,16],
      [12,14,16],
      [10,14,12]
    ],
    [
      [0,1],
      [0,2],
      [0,3],
      [0,4],
      [1,2],
      [1,3],
      [1,5],
      [2,4],
      [2,6],
      [3,5],
      [3,7],
      [4,6],
      [4,8],
      [5,7],
      [5,9],
      [6,8],
      [6,10],
      [7,9],
      [7,11],
      [8,10],
      [8,12],
      [9,11],
      [9,13],
      [10,12],
      [10,14],
      [11,13],
      [11,15],
      [12,14],
      [12,16],
      [13,15],
      [13,17],
      [14,16],
      [14,18],
      [15,17],
      [15,19],
      [16,18],
      [16,19],
      [17,18],
      [17,19],
      [18,19]
    ]
  ],
  [
    "hexagonal_antiprism",
    "Hexagonal Antiprism",
    empty_str,
    "anti_prisms",
    "Polyhedron Database #29",
    [
      [-0.91940168676,  0.39331989319, -0.00000000000],
      [-0.79622521702, -0.39331989319,  0.45970084338],
      [-0.79622521702, -0.39331989319, -0.45970084338],
      [-0.45970084338,  0.39331989319,  0.79622521702],
      [-0.45970084338,  0.39331989319, -0.79622521702],
      [ 0.00000000000, -0.39331989319,  0.91940168676],
      [ 0.00000000000, -0.39331989319, -0.91940168676],
      [ 0.45970084338,  0.39331989319,  0.79622521702],
      [ 0.45970084338,  0.39331989319, -0.79622521702],
      [ 0.79622521702, -0.39331989319,  0.45970084338],
      [ 0.79622521702, -0.39331989319, -0.45970084338],
      [ 0.91940168676,  0.39331989319, -0.00000000000]
    ],
    [
      [1.00000000000,  156.83876877392,  90.00000000002],
      [1.00000000000, -153.71151678612,  62.63219484139],
      [1.00000000000, -153.71151678612, 117.36780515857],
      [1.00000000000,  139.44971443987,  37.22886588833],
      [1.00000000000,  139.44971443986, 142.77113411166],
      [1.00000000000,  -89.99999999999,  23.16123122606],
      [1.00000000000,  -89.99999999995, 156.83876877393],
      [1.00000000000,   40.55028556012,  37.22886588833],
      [1.00000000000,   40.55028556011, 142.77113411165],
      [1.00000000000,  -26.28848321388,  62.63219484133],
      [1.00000000000,  -26.28848321388, 117.36780515864],
      [1.00000000000,   23.16123122606,  90.00000000002]
    ],
    [
      [9,10,6,2,1,5],
      [0,4,8,11,7,3],
      [4,6,8],
      [2,6,4],
      [0,2,4],
      [1,2,0],
      [3,1,0],
      [5,1,3],
      [7,5,3],
      [9,5,7],
      [11,9,7],
      [10,9,11],
      [8,10,11],
      [6,10,8]
    ],
    [
      [0,1],
      [0,2],
      [0,3],
      [0,4],
      [1,2],
      [1,3],
      [1,5],
      [2,4],
      [2,6],
      [3,5],
      [3,7],
      [4,6],
      [4,8],
      [5,7],
      [5,9],
      [6,8],
      [6,10],
      [7,9],
      [7,11],
      [8,10],
      [8,11],
      [9,10],
      [9,11],
      [10,11]
    ]
  ],
  [
    "octagonal_antiprism",
    "Octagonal Antiprism",
    empty_str,
    "anti_prisms",
    "Polyhedron Database #30",
    [
      [-0.94984865176, -0.31270999145, -0.00000000000],
      [-0.87754572834,  0.31270999145,  0.36349134228],
      [-0.87754572834,  0.31270999145, -0.36349134228],
      [-0.67164442276, -0.31270999145,  0.67164442276],
      [-0.67164442276, -0.31270999145, -0.67164442276],
      [-0.36349134228,  0.31270999145,  0.87754572834],
      [-0.36349134228,  0.31270999145, -0.87754572834],
      [-0.00000000000, -0.31270999145,  0.94984865176],
      [-0.00000000000, -0.31270999145, -0.94984865176],
      [ 0.36349134228,  0.31270999145,  0.87754572834],
      [ 0.36349134228,  0.31270999145, -0.87754572834],
      [ 0.67164442276, -0.31270999145,  0.67164442276],
      [ 0.67164442276, -0.31270999145, -0.67164442276],
      [ 0.87754572834,  0.31270999145,  0.36349134228],
      [ 0.87754572834,  0.31270999145, -0.36349134228],
      [ 0.94984865176, -0.31270999145, -0.00000000000]
    ],
    [
      [1.00000000000, -161.77737671140,  90.00000000004],
      [1.00000000000,  160.38667322856,  68.68523321433],
      [1.00000000000,  160.38667322856, 111.31476678565],
      [1.00000000000, -155.03384957250,  47.80589064816],
      [1.00000000000, -155.03384957249, 132.19410935186],
      [1.00000000000,  139.29473544049,  28.65229139610],
      [1.00000000000,  139.29473544048, 151.34770860390],
      [1.00000000000,  -90.00000000001,  18.22262328859],
      [1.00000000000,  -90.00000000001, 161.77737671138],
      [1.00000000000,   40.70526455950,  28.65229139610],
      [1.00000000000,   40.70526455950, 151.34770860390],
      [1.00000000000,  -24.96615042747,  47.80589064819],
      [1.00000000000,  -24.96615042752, 132.19410935182],
      [1.00000000000,   19.61332677143,  68.68523321432],
      [1.00000000000,   19.61332677143, 111.31476678565],
      [1.00000000000,  -18.22262328858,  90.00000000001]
    ],
    [
      [11,15,12,8,4,0,3,7],
      [1,2,6,10,14,13,9,5],
      [6,8,10],
      [4,8,6],
      [2,4,6],
      [0,4,2],
      [1,0,2],
      [3,0,1],
      [5,3,1],
      [7,3,5],
      [9,7,5],
      [11,7,9],
      [13,11,9],
      [15,11,13],
      [14,15,13],
      [12,15,14],
      [10,12,14],
      [8,12,10]
    ],
    [
      [0,1],
      [0,2],
      [0,3],
      [0,4],
      [1,2],
      [1,3],
      [1,5],
      [2,4],
      [2,6],
      [3,5],
      [3,7],
      [4,6],
      [4,8],
      [5,7],
      [5,9],
      [6,8],
      [6,10],
      [7,9],
      [7,11],
      [8,10],
      [8,12],
      [9,11],
      [9,13],
      [10,12],
      [10,14],
      [11,13],
      [11,15],
      [12,14],
      [12,15],
      [13,14],
      [13,15],
      [14,15]
    ]
  ],
  [
    "pentagonal_antiprism",
    "Pentagonal Antiprism",
    empty_str,
    "anti_prisms",
    "Polyhedron Database #28",
    [
      [ 0.85065080835, -0.44721359550, -0.27639320225],
      [ 0.85065080835,  0.44721359550,  0.27639320225],
      [ 0.52573111212,  0.44721359550, -0.72360679775],
      [ 0.52573111212, -0.44721359550,  0.72360679775],
      [ 0.00000000000, -0.44721359550, -0.89442719100],
      [ 0.00000000000,  0.44721359550,  0.89442719100],
      [-0.52573111212,  0.44721359550, -0.72360679775],
      [-0.52573111212, -0.44721359550,  0.72360679775],
      [-0.85065080835, -0.44721359550, -0.27639320225],
      [-0.85065080835,  0.44721359550,  0.27639320225]
    ],
    [
      [1.00000000000,  -27.73230144776, 106.04505713536],
      [1.00000000000,   27.73230144775,  73.95494286463],
      [1.00000000000,   40.38617755921, 136.35307289117],
      [1.00000000000,  -40.38617755920,  43.64692710879],
      [1.00000000000,  -89.99999999998, 153.43494882290],
      [1.00000000000,   89.99999999997,  26.56505117711],
      [1.00000000000,  139.61382244076, 136.35307289118],
      [1.00000000000, -139.61382244074,  43.64692710885],
      [1.00000000000, -152.26769855227, 106.04505713531],
      [1.00000000000,  152.26769855223,  73.95494286462]
    ],
    [
      [7,3,0,4,8],
      [1,5,9,6,2],
      [1,3,5],
      [0,3,1],
      [2,0,1],
      [4,0,2],
      [6,4,2],
      [8,4,6],
      [9,8,6],
      [7,8,9],
      [5,7,9],
      [3,7,5]
    ],
    [
      [0,1],
      [0,2],
      [0,3],
      [0,4],
      [1,2],
      [1,3],
      [1,5],
      [2,4],
      [2,6],
      [3,5],
      [3,7],
      [4,6],
      [4,8],
      [5,7],
      [5,9],
      [6,8],
      [6,9],
      [7,8],
      [7,9],
      [8,9]
    ]
  ],
  [
    "square_antiprism",
    "Square Antiprism",
    empty_str,
    "anti_prisms",
    "Polyhedron Database #27",
    [
      [-0.85953250377, -0.51108108453, -0.00000000000],
      [-0.60778126207,  0.51108108453,  0.60778126207],
      [-0.60778126207,  0.51108108453, -0.60778126206],
      [ 0.00000000000, -0.51108108453,  0.85953250377],
      [ 0.00000000000, -0.51108108453, -0.85953250377],
      [ 0.60778126207,  0.51108108453,  0.60778126207],
      [ 0.60778126207,  0.51108108453, -0.60778126206],
      [ 0.85953250377, -0.51108108453, -0.00000000000]
    ],
    [
      [1.00000000000, -149.26413289761,  90.00000000002],
      [1.00000000000,  139.93964097361,  52.57075390722],
      [1.00000000000,  139.93964097360, 127.42924609275],
      [1.00000000000,  -89.99999999999,  30.73586710238],
      [1.00000000000,  -89.99999999998, 149.26413289761],
      [1.00000000000,   40.06035902638,  52.57075390722],
      [1.00000000000,   40.06035902638, 127.42924609274],
      [1.00000000000,  -30.73586710238,  90.00000000002]
    ],
    [
      [7,4,0,3],
      [2,6,5,1],
      [2,4,6],
      [0,4,2],
      [1,0,2],
      [3,0,1],
      [5,3,1],
      [7,3,5],
      [6,7,5],
      [4,7,6]
    ],
    [
      [0,1],
      [0,2],
      [0,3],
      [0,4],
      [1,2],
      [1,3],
      [1,5],
      [2,4],
      [2,6],
      [3,5],
      [3,7],
      [4,6],
      [4,7],
      [5,6],
      [5,7],
      [6,7]
    ]
  ],
  [
    "triangular_antiprism",
    "Triangular Antiprism",
    "Octahedron",
    "anti_prisms",
    "Exact Mathematics",
    [
      [-0.70710678119,  0.57735026919, -0.40824829046],
      [ 0.00000000000,  0.57735026919,  0.81649658093],
      [ 0.70710678119,  0.57735026919, -0.40824829046],
      [-0.70710678119, -0.57735026919,  0.40824829046],
      [ 0.00000000000, -0.57735026919, -0.81649658093],
      [ 0.70710678119, -0.57735026919,  0.40824829046]
    ],
    [
      [1.00000000000,  140.76847951640, 114.09484255210],
      [1.00000000000,   89.99999999999,  35.26438968275],
      [1.00000000000,   39.23152048359, 114.09484255210],
      [1.00000000000, -140.76847951640,  65.90515744789],
      [1.00000000000,  -89.99999999999, 144.73561031724],
      [1.00000000000,  -39.23152048359,  65.90515744789]
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
    include <database/geometry/polyhedra/anti_prisms.scad>;

    fs  = "^";

    tc = dtc_polyhedra_anti_prisms;
    tr = dtr_polyhedra_anti_prisms;

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
    include <database/geometry/polyhedra/anti_prisms.scad>;

    config = 0;

    tc = dtc_polyhedra_anti_prisms;
    tr = dtr_polyhedra_anti_prisms;

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
                decagonal_antiprism
                hexagonal_antiprism
                octagonal_antiprism
                pentagonal_antiprism
                square_antiprism
                triangular_antiprism
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
