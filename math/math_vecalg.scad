//! Vector algebra mathematical functions.
/***************************************************************************//**
  \file   math_vecalg.scad
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

  \details

  \note Include this library file using the \b include statement.

  \ingroup math math_vecalg
*******************************************************************************/

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \page tv_math_vecalg Vector Algebra
    \li \subpage tv_math_vecalg_s
    \li \subpage tv_math_vecalg_r
  \page tv_math_vecalg_s Script
    \dontinclude math_vecalg_validate.scad
    \skip include
    \until end-of-tests
  \page tv_math_vecalg_r Results
    \include math_vecalg_validate.log
*******************************************************************************/
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \addtogroup math
  @{

  \defgroup math_vecalg Vector Algebra
  \brief    Algebraic operations on Euclidean vectors.

  \details

    See validation \ref tv_math_vecalg_r "results".
  @{
*******************************************************************************/
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
// group 1: points
//----------------------------------------------------------------------------//

//! Compute the distance between two Euclidean points.
/***************************************************************************//**
  \param    p1 <point> A point coordinate.
  \param    p2 <point> A point coordinate.

  \returns  <decimal> The distance between the two points.
            Returns \b undef when points do not have equal dimensions.

  \details

    When \p p2 is not given, it is assumed to be at the origin.
    This function is similar to [norm].

  [norm]: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Mathematical_Functions#norm
*******************************************************************************/
function distance_pp
(
  p1,
  p2
) = let(d = len(p1))
    !(d > 0) ? abs(p1 - defined_or(p2, 0))
  : is_defined(p2) ?
    sqrt(sum([for (i=[0:d-1]) (p1[i]-p2[i])*(p1[i]-p2[i])]))
  : sqrt(sum([for (i=[0:d-1]) p1[i]*p1[i]]));

//! Test if a point is left, on, or right of an infinite line in a Euclidean 2d-space.
/***************************************************************************//**
  \param    p1 <point-2d> A 2d point coordinate.
  \param    p2 <point-2d> A 2d point coordinate.
  \param    p3 <point-2d> A 2d point coordinate.

  \returns  <decimal> (\b > 0) for \p p3 \em left of the line through
            \p p1 and \p p2, (\b = 0) for p3  \em on the line, and
            (\b < 0) for p3  right of the line.

  \details

    Function patterned after [Dan Sunday, 2012].

    [Dan Sunday, 2012]: http://geomalgorithms.com/a01-_area.html
*******************************************************************************/
function is_left_ppp
(
  p1,
  p2,
  p3
) = ((p2[0]-p1[0]) * (p3[1]-p1[1]) - (p3[0]-p1[0]) * (p2[1]-p1[1]));

//----------------------------------------------------------------------------//
// group 2: vectors
//----------------------------------------------------------------------------//

//! Return the number of dimensions of a Euclidean line or vector.
/***************************************************************************//**
  \param    v <vector> A vector or a line.

  \returns  <integer> The number of dimensions for the vector or line.

  \details

    See \ref dt_vectors for argument specification and conventions.
*******************************************************************************/
function dimension_l
(
  v
) = is_defined(len(v[0])) ? len(v[0]) : len(v);

//! Return the termination point of a Euclidean line or vector.
/***************************************************************************//**
  \param    v <vector> A vector or a line.

  \returns  <integer> The terminating point of the vector or line.

  \details

    See \ref dt_vectors for argument specification and conventions.
*******************************************************************************/
function term_point_l
(
  v
) = is_iterable(v[0]) ? (len(v)>1) ? v[1] : v[0] : v;

//! Return the initiating point of a Euclidean line or vector.
/***************************************************************************//**
  \param    v <vector> A vector or a line.

  \returns  <integer> The initiating point of the vector or line.

  \details

    See \ref dt_vectors for argument specification and conventions.
*******************************************************************************/
function init_point_l
(
  v
) = is_iterable(v[0]) ? (len(v)>1) ? v[0] : consts(len(v[0]), 0)
  : is_iterable(v) ? consts(len(v), 0) : 0;

//! Shift a Euclidean line or vector to the origin.
/***************************************************************************//**
  \param    v <vector> A vector or a line.

  \returns  <integer> The vector or line shifted to the origin.

  \details

    See \ref dt_vectors for argument specification and conventions.
*******************************************************************************/
function to_origin_l
(
  v
) = not_defined(len(v[0])) ? v
  : (len(v) == 1) ? v[0]
  : (len(v) == 2) ? (v[1]-v[0])
  : undef;

//! Convert a planes' normal specification into a normal vector.
/***************************************************************************//**
  \param    p <*> A plane normal \ref dt_planes_normal "specification".

  \param    cw <boolean> Point ordering. When the plane specified as
            non-collinear points, this indicates ordering.

  \returns  <vector-3d> A vector normal to the plane.

  \details

    See \ref dt_planes_normal for argument specification and conventions.
*******************************************************************************/
function normal_ps
(
  p,
  cw = true
) = not_defined(len(p[0])) ?
    (
      (len(p) == 3) ? p : (len(p) == 2) ? [p[0], p[1], 0]: undef
    )
  : let
    (
      q = [for (i=p) (len(i) == 3) ? i : (len(i) == 2) ? [i[0], i[1], 0]: undef]
    )
    (len(p) == 1) ? q[0]
  : (len(p) == 2) ? cross(q[0], q[1])
  : cross(q[0]-q[1], q[2]-q[1]) * ((cw == true) ? 1 : -1);

//! Compute the dot product of two vectors.
/***************************************************************************//**
  \param    v1 <vector> A n-dimensional vector 1.
  \param    v2 <vector> A n-dimensional vector 2.

  \returns  <decimal> The dot product of \p v1 with \p v2.
            Returns \b undef when vectors have different dimensions.

  \details

    This function supports the abstraction outlined in \ref dt_vectors.
    The built-in operation will be more efficient in situations that do
    not make use of the aforementioned abstraction.

    See \ref dt_vectors for argument specification and conventions.
    See [Wikipedia] for more information.

    [Wikipedia]: https://en.wikipedia.org/wiki/Dot_product
*******************************************************************************/
function dot_vv
(
  v1,
  v2
) = (to_origin_l(v1) * to_origin_l(v2));

//! Compute the cross product of two vectors in a Euclidean 3d-space (2d).
/***************************************************************************//**
  \param    v1 <vector-3d|vector-2d> A 3d or 2d vector 1.
  \param    v2 <vector-3d|vector-2d> A 3d or 2d vector 2.

  \returns  <decimal|vector-2d> The cross product of \p v1 with \p v2.
            Returns \b undef when vectors have different dimensions.

  \details

    This function supports the abstraction outlined in \ref dt_vectors.
    The built-in operation will be more efficient in situations that do
    not make use of the aforementioned abstraction.

    See \ref dt_vectors for argument specification and conventions.
    See Wikipedia [cross] and [determinant] for more information.

  \note     This function returns the 2x2 determinant for 2d vectors.

  [cross]: https://en.wikipedia.org/wiki/Cross_product
  [determinant]: https://en.wikipedia.org/wiki/Determinant
*******************************************************************************/
function cross_vv
(
  v1,
  v2
) = cross(to_origin_l(v1), to_origin_l(v2));

//! Compute the scalar triple product of three vectors in a Euclidean 3d-space (2d).
/***************************************************************************//**
  \param    v1 <vector-3d|vector-2d> A 3d or 2d vector 1.
  \param    v2 <vector-3d|vector-2d> A 3d or 2d vector 2.
  \param    v3 <vector-3d|vector-2d> A 3d or 2d vector 3.

  \returns  <decimal|vector-2d> The scalar triple product.
            Returns \b undef when vectors have different dimensions.

  \details

    [v1, v2, v3] = v1 * (v2 x v3)

    See \ref dt_vectors for argument specification and conventions.
    See [Wikipedia] for more information.

  \warning  Returns a 2d vector result for 2d vectors. The cross product
            computes the 2x2 determinant of the vectors <tt>(v2 x v3)</tt>,
            a scalar value, which is then \e multiplied by vector \c v1.

  [Wikipedia]: https://en.wikipedia.org/wiki/Triple_product
*******************************************************************************/
function striple_vvv
(
  v1,
  v2,
  v3
) = dot_vv(to_origin_l(v1), cross_vv(v2, v3));

//! Compute the angle between two vectors in a Euclidean 2 or 3d-space.
/***************************************************************************//**
  \param    v1 <vector-3d|vector-2d> A 3d or 2d vector 1.
  \param    v2 <vector-3d|vector-2d> A 3d or 2d vector 2.

  \returns  <decimal> The angle between the two vectors in degrees.
            Returns \b undef when vectors have different dimensions
            or when they do not intersect.

  \details

    See \ref dt_vectors for argument specification and conventions.

  \note     For 3d vectors, a normal vector is required to uniquely
            identify the perpendicular plane and axis of rotation. This
            function calculates the positive angle, and the plane and
            axis of rotation will be that which fits this assumed
            positive angle.

  \sa angle_vvv().
*******************************************************************************/
function angle_vv
(
  v1,
  v2
) = let(d = dimension_l(v1))
    (d == 2) ? atan2(cross_vv(v1, v2), dot_vv(v1, v2))
  : (d == 3) ? atan2(distance_pp(cross_vv(v1, v2)), dot_vv(v1, v2))
  : undef;

//! Compute the angle between two vectors in a Euclidean 3d-space.
/***************************************************************************//**
  \param    v1 <vector-3d> A 3d vector 1.
  \param    v2 <vector-3d> A 3d vector 2.
  \param    nv <vector-3d> A 3d normal vector.

  \returns  <decimal> The angle between the two vectors in degrees.
            Returns \b undef when vectors have different dimensions
            or when they do not intersect.

  \details

    See \ref dt_vectors for argument specification and conventions.

  \sa angle_vv().
*******************************************************************************/
function angle_vvv
(
  v1,
  v2,
  nv
) = atan2(striple_vvv(nv, v1, v2), dot_vv(v1, v2));

//! Compute the normalized unit vector of a Euclidean vector.
/***************************************************************************//**
  \param    v <vector> A vector or a line.

  \returns  <vector> The normalized unit vector.

  \details

    See \ref dt_vectors for argument specification and conventions.
*******************************************************************************/
function unit_v
(
  v
) = to_origin_l(v) / distance_pp(to_origin_l(v));

//! Test if three vectors are coplanar in Euclidean 3d-space.
/***************************************************************************//**
  \param    v1 <vector-3d> A 3d vector 1.
  \param    v2 <vector-3d> A 3d vector 2.
  \param    v3 <vector-3d> A 3d vector 3.
  \param    d <integer> A positive numerical distance, proximity, or
            tolerance. The number of decimal places to consider.

  \returns  <boolean> \b true when all three vectors are coplanar,
            and \b false otherwise.
  \details

    See \ref dt_vectors for argument specification and conventions.
    See [Wikipedia] for more information.

  \note     When vectors are specified with start and end points, this
            function tests if vectors are in a planes parallel to the
            coplanar.

  [Wikipedia]: https://en.wikipedia.org/wiki/Coplanarity
*******************************************************************************/
function are_coplanar_vvv
(
  v1,
  v2,
  v3,
  d = 6
) = (dround(striple_vvv(v1, v2, v3), d) ==  0);

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE validate;
  BEGIN_OPENSCAD;
    include <math.scad>;
    use <datatypes/datatypes_table.scad>;
    use <console.scad>;
    use <validation.scad>;

    show_passing = true;    // show passing tests
    show_skipped = true;    // show skipped tests

    echo( str("OpenSCAD Version ", version()) );

    // test-values columns
    test_c =
    [
      ["id", "identifier"],
      ["td", "description"],
      ["tv", "test value"]
    ];

    // test-values rows
    test_r =
    [
      ["fac", "Function argument count",    undef],
      ["crp", "Result precision",           undef],
      ["t01", "All undefined",              [undef,undef,undef,undef,undef,undef]],
      ["t02", "All empty lists",            [empty_lst,empty_lst,empty_lst,empty_lst,empty_lst,empty_lst]],
      ["t03", "All scalars",                [60, 50, 40, 30, 20, 10]],
      ["t04", "All 1d vectors",             [[99], [58], [12], [42], [15], [1]]],
      ["t05", "All 2d vectors",             [
                                              [99,2], [58,16], [12,43],
                                              [42,13], [15,59], [1,85]
                                            ]],
      ["t06", "All 3d vectors",             [
                                              [199,20,55], [158,116,75], [12,43,90],
                                              [42,13,34], [15,59,45], [62,33,69]
                                            ]],
      ["t07", "All 4d vectors",             [
                                              [169,27,35,10], [178,016,25,20], [12,43,90,30],
                                              [42,13,34,60], [15,059,45,50], [62,33,69,40]
                                            ]],
      ["t08", "Orthogonal vectors",         [
                                              +x_axis3d_uv, +y_axis3d_uv, +z_axis3d_uv,
                                              -x_axis3d_uv, -y_axis3d_uv, -z_axis3d_uv,
                                            ]],
      ["t09", "Coplanar vectors",           [
                                              +x_axis3d_uv, +y_axis3d_uv, [2,2,0],
                                              origin3d, origin3d, origin3d,
                                            ]]
    ];

    test_ids = table_get_allrow_ids( test_r );

    // expected columns: ("id" + one column for each test)
    good_c = pmerge([concat("id", test_ids), concat("identifier", test_ids)]);

    // expected rows: ("golden" test results), use 'skip' to skip test
    skip = -1;  // skip test

    good_r =
    [ // function
      ["distance_pp",
        2,                                                  // fac
        4,                                                  // crp
        undef,                                              // t01
        undef,                                              // t02
        10,                                                 // t03
        41,                                                 // t04
        43.3244,                                            // t05
        106.2873,                                           // t06
        20.0499,                                            // t07
        1.4142,                                             // t08
        1.4142                                              // t09
      ],
      ["dimension_l",
        2,                                                  // fac
        4,                                                  // crp
        2,                                                  // t01
        0,                                                  // t02
        2,                                                  // t03
        1,                                                  // t04
        2,                                                  // t05
        3,                                                  // t06
        4,                                                  // t07
        3,                                                  // t08
        3                                                   // t09
      ],
      ["term_point_l",
        2,                                                  // fac
        4,                                                  // crp
        [undef,undef],                                      // t01
        empty_lst,                                          // t02
        [60,50],                                            // t03
        [58],                                               // t04
        [58,16],                                            // t05
        [158,116,75],                                       // t06
        [178,16,25,20],                                     // t07
        y_axis3d_uv,                                        // t08
        y_axis3d_uv                                         // t09
      ],
      ["init_point_l",
        2,                                                  // fac
        4,                                                  // crp
        origin2d,                                           // t01
        empty_lst,                                          // t02
        origin2d,                                           // t03
        [99],                                               // t04
        [99,2],                                             // t05
        [199,20,55],                                        // t06
        [169,27,35,10],                                     // t07
        x_axis3d_uv,                                        // t08
        x_axis3d_uv                                         // t09
      ],
      ["to_origin_l",
        2,                                                  // fac
        4,                                                  // crp
        [undef, undef],                                     // t01
        empty_lst,                                          // t02
        [60,50],                                            // t03
        [-41],                                              // t04
        [-41,14],                                           // t05
        [-41,96,20],                                        // t06
        [9,-11,-10,10],                                     // t07
        [-1,1,0],                                           // t08
        [-1,1,0]                                            // t09
      ],
      ["normal_ps",
        2,                                                  // fac
        4,                                                  // crp
        skip,                                               // t01
        skip,                                               // t02
        [60,50,0],                                          // t03
        skip,                                               // t04
        [0,0,1468],                                         // t05
        [-4880,-6235,19924],                                // t06
        skip,                                               // t07
        z_axis3d_uv,                                        // t08
        z_axis3d_uv                                         // t09
      ],
      ["dot_vv",
        4,                                                  // fac
        4,                                                  // crp
        undef,                                              // t01
        undef,                                              // t02
        3900,                                               // t03
        -1230,                                              // t04
        -1650,                                              // t05
        -5230,                                              // t06
        1460,                                               // t07
        1,                                                  // t08
        0                                                   // t09
      ],
      ["cross_vv",
        4,                                                  // fac
        4,                                                  // crp
        skip,                                               // t01
        skip,                                               // t02
        skip,                                               // t03
        skip,                                               // t04
        810,                                                // t05
        [-4776,-1696,-1650],                                // t06
        skip,                                               // t07
        [-1,-1,1],                                          // t08
        [0,0,4]                                             // t09
      ],
      ["striple_vvv",
        6,                                                  // fac
        4,                                                  // crp
        skip,                                               // t01
        skip,                                               // t02
        skip,                                               // t03
        skip,                                               // t04
        [-14760,5040],                                      // t05
        -219976,                                            // t06
        skip,                                               // t07
        -2,                                                 // t08
        0                                                   // t09
      ],
      ["angle_vv",
        4,                                                  // fac
        4,                                                  // crp
        undef,                                              // t01
        undef,                                              // t02
        -2.9357,                                            // t03
        undef,                                              // t04
        153.8532,                                           // t05
        134.4573,                                           // t06
        undef,                                              // t07
        60,                                                 // t08
        90                                                  // t09
      ],
      ["angle_vvv",
        6,                                                  // fac
        4,                                                  // crp
        skip,                                               // t01
        skip,                                               // t02
        skip,                                               // t03
        skip,                                               // t04
        skip,                                               // t05
        -91.362,                                            // t06
        skip,                                               // t07
        -63.4349,                                           // t08
        0                                                   // t09
      ],
      ["unit_v",
        2,                                                  // fac
        4,                                                  // crp
        undef,                                              // t01
        undef,                                              // t02
        [.7682,0.6402],                                     // t03
        [-1],                                               // t04
        [-0.9464,0.3231],                                   // t05
        [-0.3857,0.9032,0.1882],                            // t06
        [0.44888,-0.5486,-0.4988,0.4988],                   // t07
        [-0.7071,0.7071,0],                                 // t08
        [-0.7071,0.7071,0]                                  // t09
      ],
      ["are_coplanar_vvv",
        6,                                                  // fac
        4,                                                  // crp
        skip,                                               // t01
        skip,                                               // t02
        skip,                                               // t03
        skip,                                               // t04
        skip,                                               // t05
        false,                                              // t06
        skip,                                               // t07
        false,                                              // t08
        true                                                // t09
      ]
    ];

    // sanity-test tables
    table_check( test_r, test_c, false );
    table_check( good_r, good_c, false );

    // validate helper function and module
    function get_value( vid ) = table_get(test_r, test_c, vid, "tv");
    function gv( vid, e ) = get_value( vid )[e];
    module run( fname, vid )
    {
      value_text = table_get(test_r, test_c, vid, "td");

      if ( table_get(good_r, good_c, fname, vid) != skip )
        children();
      else if ( show_skipped )
        log_info( str("*skip*: ", vid, " '", fname, "(", value_text, ")'") );
    }
    module test( fname, fresult, vid, pair )
    {
      value_text = table_get(test_r, test_c, vid, "td");
      fname_argc = table_get(good_r, good_c, fname, "fac");
      comp_prcsn = table_get(good_r, good_c, fname, "crp");
      pass_value = table_get(good_r, good_c, fname, vid);

      test_pass = validate(cv=fresult, t="almost", ev=pass_value, p=comp_prcsn, pf=true);
      farg_text = (pair == true)
                ? lstr(eappend(", ", nssequence(rselect(get_value(vid), [0:fname_argc-1]), n=2, s=2), r=false, j=false, l=false))
                : lstr(eappend(", ", rselect(get_value(vid), [0:fname_argc-1]), r=false, j=false, l=false));
      test_text = validate(str(fname, "(", farg_text, ")=~", pass_value), fresult, "almost", pass_value, comp_prcsn);

      if ( pass_value != skip )
      {
        if ( !test_pass )
          log_warn( str(vid, "(", value_text, ") ", test_text) );
        else if ( show_passing )
          log_info( str(vid, " ", test_text) );
      }
      else if ( show_skipped )
        log_info( str(vid, " *skip*: '", fname, "(", value_text, ")'") );
    }

    // Indirect function calls would be very useful here!!!
    run_ids = delete( test_ids, mv=["fac", "crp"] );

    // group 1: points
    for (vid=run_ids) run("distance_pp",vid) test( "distance_pp", distance_pp(gv(vid,0),gv(vid,1)), vid, false );
    // not tested: is_left_ppp()

    // group 2: vectors
    for (vid=run_ids) run("dimension_l",vid) test( "dimension_l", dimension_l([gv(vid,0),gv(vid,1)]), vid, true );
    for (vid=run_ids) run("term_point_l",vid) test( "term_point_l", term_point_l([gv(vid,0),gv(vid,1)]), vid, true );
    for (vid=run_ids) run("init_point_l",vid) test( "init_point_l", init_point_l([gv(vid,0),gv(vid,1)]), vid, true );
    for (vid=run_ids) run("to_origin_l",vid) test( "to_origin_l", to_origin_l([gv(vid,0),gv(vid,1)]), vid, true );
    for (vid=run_ids) run("normal_ps",vid) test( "normal_ps", normal_ps([gv(vid,0),gv(vid,1)]), vid, true );
    for (vid=run_ids) run("dot_vv",vid) test( "dot_vv", dot_vv([gv(vid,0),gv(vid,1)],[gv(vid,2),gv(vid,3)]), vid, true );
    for (vid=run_ids) run("cross_vv",vid) test( "cross_vv", cross_vv([gv(vid,0),gv(vid,1)],[gv(vid,2),gv(vid,3)]), vid, true );
    for (vid=run_ids) run("striple_vvv",vid) test( "striple_vvv", striple_vvv([gv(vid,0),gv(vid,1)],[gv(vid,2),gv(vid,3)],[gv(vid,4),gv(vid,5)]), vid, true );
    for (vid=run_ids) run("angle_vv",vid) test( "angle_vv", angle_vv([gv(vid,0),gv(vid,1)],[gv(vid,2),gv(vid,3)]), vid, true );
    for (vid=run_ids) run("angle_vvv",vid) test( "angle_vvv", angle_vvv([gv(vid,0),gv(vid,1)],[gv(vid,2),gv(vid,3)],[gv(vid,4),gv(vid,5)]), vid, true );
    for (vid=run_ids) run("unit_v",vid) test( "unit_v", unit_v([gv(vid,0),gv(vid,1)]), vid, true );
    for (vid=run_ids) run("are_coplanar_vvv",vid) test( "are_coplanar_vvv", are_coplanar_vvv([gv(vid,0),gv(vid,1)],[gv(vid,2),gv(vid,3)],[gv(vid,4),gv(vid,5)]), vid, true );

    // end-of-tests
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {config_base,config_csg}.mfs;
    include --path "${INCLUDE_PATH}" script_std.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
