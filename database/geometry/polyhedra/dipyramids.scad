//! Polyhedra data table: \c dipyramids.
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
    ### Dipyramids ###
    \amu_include (include/amu/includes_required.amu)

    \amu_eval
      (
        ++global
        title="Examples"
        stem=dipyramids scope=db_dim size=qvga view=diag
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

//! <map> \c dipyramids polyhedra data table columns definition.
//! \hideinitializer
dtc_polyhedra_dipyramids =
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

//! \<table> \c dipyramids polyhedra data table rows.
//! \hideinitializer
dtr_polyhedra_dipyramids =
[
  [
    "decagonal_bi_pyramid",
    "Decagonal Bi-Pyramid",
    empty_str,
    "dipyramids",
    "George W. Hart, 1997.  george@li.net",
    [
      [ 0.09592986243,  0.00000000000,  0.31043557716],
      [-0.10486056224,  0.00000000000,  0.30753382347],
      [-0.00000000000, -1.00000000000, -0.00000000000],
      [ 0.26007835274,  0.00000000000,  0.19476148707],
      [-0.00000000000,  1.00000000000, -0.00000000000],
      [-0.26559780113,  0.00000000000,  0.18716458288],
      [ 0.32488563406,  0.00000000000,  0.00469514267],
      [-0.32488563406, -0.00000000000, -0.00469514267],
      [ 0.26559780113, -0.00000000000, -0.18716458288],
      [-0.26007835274, -0.00000000000, -0.19476148707],
      [ 0.10486056224, -0.00000000000, -0.30753382347],
      [-0.09592986243, -0.00000000000, -0.31043557716]
    ],
    [
      [0.32491966095,    0.00000000000,  17.17203674418],
      [0.32491966714,  179.99999999999,  18.82796235856],
      [1.00000000000,  -89.99999999999,  89.99999999999],
      [0.32491966147,    0.00000000000,  53.17203948142],
      [1.00000000000,   89.99999999999,  89.99999999999],
      [0.32491964091,  179.99999999999,  54.82796225358],
      [0.32491955863,    0.00000000000,  89.17203746329],
      [0.32491955863, -179.99999999999,  90.82796253670],
      [0.32491964091,   -0.00000000000, 125.17203774641],
      [0.32491966147, -179.99999999999, 126.82796051856],
      [0.32491966714,   -0.00000000000, 161.17203764143],
      [0.32491966095, -179.99999999999, 162.82796325581]
    ],
    [
      [1,0,2],
      [0,3,2],
      [1,4,0],
      [2,5,1],
      [4,3,0],
      [6,2,3],
      [5,4,1],
      [7,5,2],
      [4,6,3],
      [6,8,2],
      [5,7,4],
      [2,9,7],
      [8,6,4],
      [10,2,8],
      [9,4,7],
      [11,9,2],
      [4,10,8],
      [10,11,2],
      [9,11,4],
      [11,10,4]
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
      [2,6],
      [2,7],
      [2,8],
      [2,9],
      [2,10],
      [2,11],
      [3,4],
      [3,6],
      [4,5],
      [4,6],
      [4,7],
      [4,8],
      [4,9],
      [4,10],
      [4,11],
      [5,7],
      [6,8],
      [7,9],
      [8,10],
      [9,11],
      [10,11]
    ]
  ],
  [
    "hexagonal_bi_pyramid",
    "Hexagonal Bi-Pyramid",
    empty_str,
    "dipyramids",
    "George W. Hart, 1997.  george@li.net",
    [
      [-0.28867510881,  0.00000003609,  0.49999997158],
      [-0.57735022075, -0.00000000361, -0.00000000000],
      [ 0.00000000000, -1.00000000000,  0.00000000000],
      [ 0.28867512444, -0.00000000361,  0.49999994993],
      [ 0.00000000000,  1.00000000000,  0.00000000000],
      [-0.28867512444,  0.00000000361, -0.49999994993],
      [ 0.57735022075,  0.00000000361,  0.00000000000],
      [ 0.28867510881, -0.00000003609, -0.49999997158]
    ],
    [
      [0.57735023169,  179.99999283787,  29.99999919429],
      [0.57735022075, -179.99999964192,  89.99999999999],
      [1.00000000000,  -89.99999999999,  89.99999999999],
      [0.57735022075,   -0.00000071611,  30.00000161142],
      [1.00000000000,   89.99999999999,  89.99999999999],
      [0.57735022075,  179.99999928388, 149.99999838857],
      [0.57735022075,    0.00000035806,  89.99999999999],
      [0.57735023169,   -0.00000716211, 150.00000080570]
    ],
    [
      [1,0,2],
      [0,3,2],
      [1,4,0],
      [2,5,1],
      [4,3,0],
      [6,2,3],
      [5,4,1],
      [7,5,2],
      [4,6,3],
      [6,7,2],
      [5,7,4],
      [7,6,4]
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
      [2,6],
      [2,7],
      [3,4],
      [3,6],
      [4,5],
      [4,6],
      [4,7],
      [5,7],
      [6,7]
    ]
  ],
  [
    "octagonal_di_pyramid",
    "Octagonal Di-Pyramid",
    empty_str,
    "dipyramids",
    "George W. Hart, 1997.  george@li.net",
    [
      [ 0.14804268343,  0.00000005300,  0.38685420990],
      [-0.16886526074,  0.00000001992,  0.37822922144],
      [-0.00000000000, -1.00000000000, -0.00000000000],
      [ 0.37822922540,  0.00000001750,  0.16886525092],
      [ 0.00000000000,  1.00000000000,  0.00000000000],
      [-0.38685424213, -0.00000000493,  0.14804270850],
      [ 0.38685424213,  0.00000000493, -0.14804270850],
      [-0.37822922540, -0.00000001750, -0.16886525092],
      [ 0.16886526074, -0.00000001992, -0.37822922144],
      [-0.14804268343, -0.00000005300, -0.38685420990]
    ],
    [
      [0.41421349065,    0.00002051089,  20.94101873648],
      [0.41421349596,  179.99999324038,  24.05898259437],
      [1.00000000000,  -89.99999999999,  89.99999999999],
      [0.41421349557,    0.00000265101,  65.94101886917],
      [1.00000000000,   89.99999999999,  89.99999999999],
      [0.41421352971, -179.99999927041,  69.05897961852],
      [0.41421352971,    0.00000072957, 110.94102038147],
      [0.41421349557, -179.99999734898, 114.05898113082],
      [0.41421349596,   -0.00000675961, 155.94101740562],
      [0.41421349065, -179.99997948910, 159.05898126351]
    ],
    [
      [1,0,2],
      [0,3,2],
      [1,4,0],
      [2,5,1],
      [4,3,0],
      [6,2,3],
      [5,4,1],
      [7,5,2],
      [4,6,3],
      [6,8,2],
      [5,7,4],
      [2,9,7],
      [8,6,4],
      [9,2,8],
      [9,4,7],
      [4,9,8]
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
      [2,6],
      [2,7],
      [2,8],
      [2,9],
      [3,4],
      [3,6],
      [4,5],
      [4,6],
      [4,7],
      [4,8],
      [4,9],
      [5,7],
      [6,8],
      [7,9],
      [8,9]
    ]
  ],
  [
    "pentagonal_di_pyramid",
    "Pentagonal Di-Pyramid",
    empty_str,
    "dipyramids",
    "George W. Hart, 1997.  george@li.net",
    [
      [ 0.00000000000,  0.00000001425, -0.72654252016],
      [ 0.69098295556,  0.00000000091, -0.22451392694],
      [-0.00000009880, -1.00000000000, -0.00000008837],
      [-0.69098274808,  0.00000008787, -0.22451399518],
      [ 0.00000000000,  0.99999995655,  0.00000000000],
      [ 0.42705100182, -0.00000004706,  0.58778529964],
      [-0.42705111050, -0.00000001253,  0.58778523101]
    ],
    [
      [0.72654252016,   89.99999999999, 179.99999887622],
      [0.72654246143,    0.00000007552, 107.99999661865],
      [1.00000000000,  -90.00000566107,  90.00000506351],
      [0.72654228519,  179.99999271350, 108.00000679313],
      [0.99999995655,   89.99999999999,  89.99999999999],
      [0.72654257730,   -0.00000631324,  35.99999899818],
      [0.72654258566, -179.99999831890,  36.00000911322]
    ],
    [
      [1,0,2],
      [0,3,2],
      [1,4,0],
      [2,5,1],
      [4,3,0],
      [6,2,3],
      [5,4,1],
      [6,5,2],
      [4,6,3],
      [5,6,4]
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
      [2,6],
      [3,4],
      [3,6],
      [4,5],
      [4,6],
      [5,6]
    ]
  ],
  [
    "square_di_pyramid",
    "Square Di-Pyramid",
    "Octahedron",
    "dipyramids",
    "Exact Mathematics",
    [
      [ 0.00000000000,  1.00000000000,  0.00000000000],
      [-0.70710678119,  0.00000000000,  0.70710678119],
      [-0.70710678119,  0.00000000000, -0.70710678119],
      [ 0.70710678119,  0.00000000000, -0.70710678119],
      [ 0.70710678119,  0.00000000000,  0.70710678119],
      [ 0.00000000000, -1.00000000000,  0.00000000000]
    ],
    [
      [1.00000000000,   89.99999999999,  89.99999999999],
      [1.00000000000,  179.99999999999,  45.00000000000],
      [1.00000000000,  179.99999999999, 134.99999999999],
      [1.00000000000,    0.00000000000, 134.99999999999],
      [1.00000000000,    0.00000000000,  45.00000000000],
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
    "triangular_di_pyramid",
    "Triangular Di-Pyramid",
    empty_str,
    "dipyramids",
    "George W. Hart, 1997.  george@li.net",
    [
      [-0.00000000000,  0.00000000000, -1.00000000000],
      [ 0.86602529650,  0.00000016113,  0.49999996108],
      [ 0.00000012570, -0.57735024545,  0.00000005844],
      [-0.86602535292, -0.00000013763,  0.50000000631],
      [-0.00000006928,  0.57735022194, -0.00000002583]
    ],
    [
      [1.00000000000,  179.99999999999, 179.99999999999],
      [0.99999988763,    0.00001066053,  59.99999885779],
      [0.57735024545,  -89.99998752578,  89.99999420016],
      [0.99999995911, -179.99999089475,  59.99999823004],
      [0.57735022194,   90.00000687480,  90.00000256309]
    ],
    [
      [1,0,2],
      [0,3,2],
      [1,4,0],
      [2,3,1],
      [4,3,0],
      [3,4,1]
    ],
    [
      [0,1],
      [0,2],
      [0,3],
      [0,4],
      [1,2],
      [1,3],
      [1,4],
      [2,3],
      [3,4]
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
    include <database/geometry/polyhedra/dipyramids.scad>;

    fs  = "^";

    tc = dtc_polyhedra_dipyramids;
    tr = dtr_polyhedra_dipyramids;

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
    include <database/geometry/polyhedra/dipyramids.scad>;

    config = 0;

    tc = dtc_polyhedra_dipyramids;
    tr = dtr_polyhedra_dipyramids;

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
                decagonal_bi_pyramid
                hexagonal_bi_pyramid
                octagonal_di_pyramid
                pentagonal_di_pyramid
                square_di_pyramid
                triangular_di_pyramid
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
