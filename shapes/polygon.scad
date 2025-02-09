//! Roundable polygons generated in 2D space.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2019-2024

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

    \amu_define group_name  (Polygons)
    \amu_define group_brief (Roundable polygons generated in 2D space.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group and macros.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_include (include/amu/includes_required.amu)

  \amu_define image_view (top)

  \amu_define group_id (${parent})
  \amu_include (include/amu/scope_diagrams_3d_in_group.amu)

  \amu_define group_id (${group})
  \amu_include (include/amu/scope_diagrams_3d_in_group.amu)

  \amu_include (include/amu/scope_diagram_3d_object.amu)
  \amu_include (include/amu/scope_diagram_2d_object.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// rounding
//----------------------------------------------------------------------------//

//! \name Rounding
//! @{

/***************************************************************************//**
  \amu_define round_sr_common_api
  (
    The side rounding radius may be zero, positive, or negative. When
    positive, the rounding arc is swept clockwise. When negative, the
    arc is swept counter clockwise. A positive radius must be greater
    than the side length. The arch center point is located along a line
    that starts at the mid-point of the side vertices and extends
    perpendicularly by the radius distance. The arch is swept about the
    center point with constant radius from one vertex to the next.
  )
*******************************************************************************/

/***************************************************************************//**
  \amu_define round_vr_common_api
  (
    Each vertex may be assigned an individual rounding radius, rounding
    mode, and facet number as described in \ref polygon_round_eve_all_p
    by using the parameters: \p vr, \p vrm, and \p vfn. When \p vr is
    undefined, no rounding is performed on the polygon vertices.
  )
*******************************************************************************/

//! A polygon edge round with constant radius between two vectors.
/***************************************************************************//**
  \copydetails polygon_round_eve_p()

  \details

    \amu_eval ( object=pg_corner_round ${object_ex_diagram_3d} )
*******************************************************************************/
module pg_corner_round
(
  r  = 1,
  m  = 1,
  c  = origin2d,
  v1 = x_axis2d_uv,
  v2 = y_axis2d_uv
)
{
  p = concat([c], polygon_round_eve_p(r=r, m=m, c=c, v1=v1, v2=v2));

  polygon(p);
}

//! @}

//----------------------------------------------------------------------------//
// round side general
//----------------------------------------------------------------------------//

//! \name Round side general
//! @{

//! A polygon rectangle with side rounding.
/***************************************************************************//**
  \param    size <decimal-list-2 | decimal> A list [x, y] of decimals
            or a single decimal for (x=y).

  \param    o <point-2d> The origin offset coordinate [x, y].

  \param    sr  <decimal-list-2 | decimal> The side rounding radius.

  \param    center <boolean> Center about origin.

  \details

    \amu_eval ( ${round_sr_common_api} )
    \amu_eval ( object=pg_rectangle_rs ${object_ex_diagram_3d} )
*******************************************************************************/
module pg_rectangle_rs
(
  size = 1,
  o,
  sr,
  center = false
)
{
  sx = defined_e_or(size, 0, size);
  sy = defined_e_or(size, 1, sx);

  rd = defined_or(sr, 1/grid_fine);
  rx = defined_e_or(sr, 0, rd);
  ry = defined_e_or(sr, 1, rx);

  assert( (rx <= 0) || (rx > 0) && (rx >= sx), "(+) x-radius less than x-side" );
  assert( (ry <= 0) || (ry > 0) && (ry >= sy), "(+) y-radius less than y-side" );

  cwx = (ry > 0) ? true : false;
  cwy = (rx > 0) ? true : false;

  ts =
  [ // centered around origin
    ["arc_pv", [[  0, +ry], [-sx, +sy]/2, cwx]],
    ["arc_pv", [[-rx,   0], [-sx, -sy]/2, cwy]],
    ["arc_pv", [[  0, -ry], [+sx, -sy]/2, cwx]],
    ["arc_pv", [[+rx,   0], [+sx, +sy]/2, cwy]]
  ];

  c = polygon_turtle_p( ts, i=[sx,sy]/2 );

  p = (center == true)  &&  is_undef( o ) ? c
    : (center == true)  && !is_undef( o ) ? translate_p(c, o)
    : (center == false) &&  is_undef( o ) ? translate_p(c, [sx, sy]/2)
    : translate_p(c, o + [sx, sy]/2);

  polygon(p);
}

//! @}

//----------------------------------------------------------------------------//
// round vertex general
//----------------------------------------------------------------------------//

//! \name Round vertex general
//! @{

//! A polygon elliptical sector.
/***************************************************************************//**
  \copydetails polygon_elliptical_sector_p()

  \details

    \amu_eval ( object=pg_elliptical_sector ${object_ex_diagram_3d} )
*******************************************************************************/
module pg_elliptical_sector
(
  r = 1,
  c = origin2d,
  v1 = x_axis2d_uv,
  v2 = x_axis2d_uv,
  s = true
)
{
  p = polygon_elliptical_sector_p(r=r, c=c, v1=v1, v2=v2, s=s);

  polygon(p);
}

//! A polygon trapezoid with individual vertex rounding and arc facets.
/***************************************************************************//**
  \copydetails polygon_trapezoid_p()

  \param    vr  <decimal-list-4 | decimal> The vertices rounding radius.
  \param    vrm <integer-list-4 | integer> The vertices rounding mode.
  \param    vfn <integer-list-4> The vertices arc fragment number.

  \param    center <boolean> Center origin at trapezoid centroid.

  \details

    \amu_eval ( ${round_vr_common_api} )
    \amu_eval ( object=pg_trapezoid ${object_ex_diagram_3d} )
*******************************************************************************/
module pg_trapezoid
(
  b = 1,
  h,
  l = 1,
  a = 90,
  o = origin2d,
  vr,
  vrm = 1,
  vfn,
  center = false
)
{
  c = polygon_trapezoid_p(b=b, h=h, l=l, a=a, o=o);

  m = (center == false) ? c : translate_p(c, o-polygon_centroid(c));
  p = is_undef( vr ) ? m : polygon_round_eve_all_p(c=m, vr=vr, vrm=vrm, vfn=vfn);

  polygon(p);
}

//! A polygon rectangle with vertex rounding.
/***************************************************************************//**
  \param    size <decimal-list-2 | decimal> A list [x, y] of decimals
            or a single decimal for (x=y).

  \param    o <point-2d> The origin offset coordinate [x, y].

  \param    vr  <decimal-list-4 | decimal> The vertices rounding radius.
  \param    vrm <integer-list-4 | integer> The vertices rounding mode.
  \param    vfn <integer-list-4> The vertices arc fragment number.

  \param    center <boolean> Center about origin.

  \details

    \amu_eval ( ${round_vr_common_api} )
    \amu_eval ( object=pg_rectangle ${object_ex_diagram_3d} )
*******************************************************************************/
module pg_rectangle
(
  size = 1,
  o,
  vr,
  vrm = 1,
  vfn,
  center = false
)
{
  rx = defined_e_or(size, 0, size);
  ry = defined_e_or(size, 1, rx);

  c = (center == true)
    ? [[-rx,-ry], [-rx,ry], [rx,ry], [rx,-ry]]/2
    : [[0,0], [0,ry], [rx,ry], [rx,0]];

  m = is_undef(  o ) ? c : translate_p(c, o);
  p = is_undef( vr ) ? m : polygon_round_eve_all_p(c=m, vr=vr, vrm=vrm, vfn=vfn);

  polygon(p);
}

//! A polygon rhombus with vertex rounding.
/***************************************************************************//**
  \param    size <decimal-list-2 | decimal> A list [x, y] of decimals
            or a single decimal for (x=y).

  \param    o <point-2d> The origin offset coordinate [x, y].

  \param    vr  <decimal-list-4 | decimal> The vertices rounding radius.
  \param    vrm <integer-list-4 | integer> The vertices rounding mode.
  \param    vfn <integer-list-4> The vertices arc fragment number.

  \param    center <boolean> Center about origin.

  \details

    \amu_eval ( ${round_vr_common_api} )
    \amu_eval ( object=pg_rhombus ${object_ex_diagram_3d} )
*******************************************************************************/
module pg_rhombus
(
  size = 1,
  o,
  vr,
  vrm = 1,
  vfn,
  center = false
)
{
  rx = defined_e_or(size, 0, size)/2;
  ry = defined_e_or(size, 1, rx*2)/2;

  c = (center == true)
    ? [[-rx,0], [0,ry], [rx,0], [0,-ry]]
    : [[rx*2,ry], [rx,ry*2], [0,ry], [rx,0]];

  m = is_undef(  o ) ? c : translate_p(c, o);
  p = is_undef( vr ) ? m : polygon_round_eve_all_p(c=m, vr=vr, vrm=vrm, vfn=vfn);

  polygon(p);
}

//! A n-sided regular polygon with vertex rounding.
/***************************************************************************//**
  \param    n <integer> The number of sides.
  \param    r <decimal> The radius.
  \param    o <point-2d> The origin offset coordinate [x, y].

  \param    vr  <decimal-list-n | decimal> The vertices rounding radius.
  \param    vrm <integer-list-n | integer> The vertices rounding mode.
  \param    vfn <integer-list-n | integer> The vertices arc fragment number.

  \param    center <boolean> Center about origin.

  \details

    \amu_eval ( ${round_vr_common_api} )
    \amu_eval ( object=pg_ngon ${object_ex_diagram_3d} )
*******************************************************************************/
module pg_ngon
(
  n = 3,
  r = 1,
  o,
  vr,
  vrm = 1,
  vfn,
  center = true
)
{
  z = (center == true) ? origin2d : [r, r];

  c = polygon_regular_p(n=n, r=r, c=z);

  m = is_undef(  o ) ? c : translate_p(c, o);
  p = is_undef( vr ) ? m : polygon_round_eve_all_p(c=m, vr=vr, vrm=vrm, vfn=vfn);

  polygon(p);
}

//! @}

//----------------------------------------------------------------------------//
// round vertex triangles
//----------------------------------------------------------------------------//

//! \name Round vertex triangles
//! @{

/***************************************************************************//**
  \amu_define triangle_common_api
  (
    \param    o <point-2d> The origin offset coordinate [x, y].

    \param    vr  <decimal-list-3 | decimal> The vertices rounding radius.
    \param    vrm <integer-list-3 | integer> The vertices rounding mode.
    \param    vfn <integer-list-3 | integer> The vertices arc fragment number.

    \param    cm <integer> The center mode; [0,1,2, or 3].

    \details

       cm             | value description
      :---------------|:---------------------------------
       0              | origin at vertex v1
       1              | origin at triangle centroid
       2              | origin at triangle incenter
       3              | origin at triangle circumcenter

    ${round_vr_common_api}
  )
*******************************************************************************/

//! A polygon triangle specified by three coordinate points with vertex rounding.
/***************************************************************************//**
  \param    c <coords-list-3> A list, [v1, v2, v3], the vertex coordinates in 2d.

  \amu_eval ( ${triangle_common_api} )

  \amu_eval
  ( object=ppp
    title="Parameter location" scope_id=diagram_label
    html_image_w=384 latex_image_w="2.25in"
    ${object_diagram_2d}
  )
  \amu_eval ( object=pg_triangle_ppp ${object_ex_diagram_3d} )
*******************************************************************************/
module pg_triangle_ppp
(
  c,
  o,
  vr,
  vrm = 1,
  vfn,
  cm = 0
)
{
  l = (cm == 0) ? undef
    : (cm == 1) ? triangle_centroid(c=c, d=2)
    : (cm == 2) ? triangle2d_incenter(c=c)
    : (cm == 3) ? triangle_circumcenter(c=c, d=2)
    : undef;

  m = is_undef(  o ) ? c : translate_p(c, o);
  n = is_undef(  l ) ? m : translate_p(m, -l);
  p = is_undef( vr ) ? n : polygon_round_eve_all_p(c=n, vr=vr, vrm=vrm, vfn=vfn);

  polygon(p);
}

//! A polygon triangle specified by three side lengths with vertex rounding.
/***************************************************************************//**
  \param    v <decimal-list-3> A list, [s1, s2, s3], the side lengths.
  \param    a <integer> The triangle side alignment axis index
            < \b x_axis_ci | \b y_axis_ci >.

  \amu_eval ( ${triangle_common_api} )

  \amu_eval
  ( object=sss
    title="Parameter location" scope_id=diagram_label
    html_image_w=384 latex_image_w="2.25in"
    ${object_diagram_2d}
  )
  \amu_eval ( object=pg_triangle_sss ${object_ex_diagram_3d} )
*******************************************************************************/
module pg_triangle_sss
(
  v,
  a  = x_axis_ci,
  o,
  vr,
  vrm = 1,
  vfn,
  cm = 0
)
{
  c = triangle2d_sss2ppp(v, a=a);
  pg_triangle_ppp(c=c, o=o, vr=vr, vrm=vrm, vfn=vfn, cm=cm);
}

//! A polygon triangle specified by size-angle-size with vertex rounding.
/***************************************************************************//**
  \param    v <decimal-list-3> A list, [s1, a3, s2], the side lengths
            and the included angle.
  \param    a <integer> The triangle side alignment axis index
            < \b x_axis_ci | \b y_axis_ci >.

  \amu_eval ( ${triangle_common_api} )

  \amu_eval
  ( object=sas
    title="Parameter location" scope_id=diagram_label
    html_image_w=384 latex_image_w="2.25in"
    ${object_diagram_2d}
  )
  \amu_eval ( object=pg_triangle_sas ${object_ex_diagram_3d} )
*******************************************************************************/
module pg_triangle_sas
(
  v,
  a = x_axis_ci,
  o,
  vr,
  vrm = 1,
  vfn,
  cm = 0
)
{
  c = triangle2d_sss2ppp(triangle_sas2sss(v), a=a);
  pg_triangle_ppp(c=c, o=o, vr=vr, vrm=vrm, vfn=vfn, cm=cm);
}

//! A polygon triangle specified by angle-size-angle with vertex rounding.
/***************************************************************************//**
  \param    v <decimal-list-3> A list, [a1, s3, a2], the side length
            and two adjacent angles.
  \param    a <integer> The triangle side alignment axis index
            < \b x_axis_ci | \b y_axis_ci >.

  \amu_eval ( ${triangle_common_api} )

  \amu_eval
  ( object=asa
    title="Parameter location" scope_id=diagram_label
    html_image_w=384 latex_image_w="2.25in"
    ${object_diagram_2d}
  )
  \amu_eval ( object=pg_triangle_asa ${object_ex_diagram_3d} )
*******************************************************************************/
module pg_triangle_asa
(
  v,
  a = x_axis_ci,
  o,
  vr,
  vrm = 1,
  vfn,
  cm = 0
)
{
  c = triangle2d_sss2ppp(triangle_asa2sss(v), a=a);
  pg_triangle_ppp(c=c, o=o, vr=vr, vrm=vrm, vfn=vfn, cm=cm);
}

//! A polygon triangle specified by angle-angle-size with vertex rounding.
/***************************************************************************//**
  \param    v <decimal-list-3> A list, [a1, a2, s1], a side length,
            one adjacent and the opposite angle.
  \param    a <integer> The triangle side alignment axis index
            < \b x_axis_ci | \b y_axis_ci >.

  \amu_eval ( ${triangle_common_api} )

  \amu_eval
  ( object=aas
    title="Parameter location" scope_id=diagram_label
    html_image_w=384 latex_image_w="2.25in"
    ${object_diagram_2d}
  )
  \amu_eval ( object=pg_triangle_aas ${object_ex_diagram_3d} )
*******************************************************************************/
module pg_triangle_aas
(
  v,
  a = x_axis_ci,
  o,
  vr,
  vrm = 1,
  vfn,
  cm = 0
)
{
  c = triangle2d_sss2ppp(triangle_aas2sss(v), a=a);
  pg_triangle_ppp(c=c, o=o, vr=vr, vrm=vrm, vfn=vfn, cm=cm);
}

//! @}

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE diagram;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;

    shape = "pg_corner_round";
    $fn = 36;

    if (shape == "pg_corner_round")
      pg_corner_round( r=20, v1=[1,1], v2=135 );
    else if (shape == "pg_rectangle_rs")
      pg_rectangle_rs( [60,30], sr=[60,-100], center=true );
    else if (shape == "pg_elliptical_sector")
      pg_elliptical_sector( r=[20, 15], v1=115, v2=-115 );
    else if (shape == "pg_trapezoid")
      pg_trapezoid( b=[50,20], l=25, a=45, vr=2, center=true);
    else if (shape == "pg_rectangle")
      pg_rectangle( size=[30,10], vr=2, center=true );
    else if (shape == "pg_rhombus")
      pg_rhombus( size=[30, 15], vr=[3,1,3,1], center=true );
    else if (shape == "pg_ngon")
      pg_ngon( n=6, r=10, vr=1, center=true );
    else if (shape == "pg_triangle_ppp")
      pg_triangle_ppp( c=[[-15,-5],[10,15], [10,-10]], vr=1 );
    else if (shape == "pg_triangle_sss")
      pg_triangle_sss( v=[10,20,25], vr=1, cm=1);
    else if (shape == "pg_triangle_sas")
      pg_triangle_sas( v=[15,30,20], vr=1, cm=1);
    else if (shape == "pg_triangle_asa")
      pg_triangle_asa( v=[60,30,25], vr=1, cm=1);
    else if (shape == "pg_triangle_aas")
      pg_triangle_aas( v=[30,40,25], vr=1, cm=1);
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;

    views     name "views" views "top";
    defines   name "shapes" define "shape"
              strings "
                pg_corner_round
                pg_rectangle_rs
                pg_elliptical_sector
                pg_trapezoid
                pg_rectangle
                pg_rhombus
                pg_ngon
                pg_triangle_ppp
                pg_triangle_sss
                pg_triangle_sas
                pg_triangle_asa
                pg_triangle_aas
              ";
    variables add_opts_combine "views shapes";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;

BEGIN_SCOPE diagram_label;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <tools/operation_cs.scad>;
    include <tools/drafting/draft-base.scad>;

    module dt (vl = empty_lst, al = empty_lst, sl = empty_lst)
    {
      s = 10;
      t = [6, 8, 7];
      r = min(t)/len(t)*s;

      c = triangle2d_sss2ppp(t)*s;

      draft_polygon(c, w=s*2/3);
      draft_axes([[0,12], [0,7]]*s, ts=s/2);

      for (i = [0 : len(c)-1])
      {
        cv = c[i];
        os = shift(shift(v=c, n=i, r=false), 1, r=false, c=false);

        if ( !is_empty( find( mv=i, v=vl )) )
        draft_dim_leader(cv, v1=[mean(os), cv], l1=5, t=str("v", i+1), bs=0, cmh=s*1, cmv=s);

        if ( !is_empty( find( mv=i, v=al )) )
        draft_dim_angle(c=cv, r=r, v1=[cv, second(os)], v2=[cv, first(os)], t=str("a", i+1), a=0, cmh=s, cmv=s);

        if ( !is_empty( find( mv=i, v=sl )) )
        draft_dim_line(p1=first(os), p2=second(os), t=str("s", i+1), cmh=s, cmv=s);
      }
    }

    object = "triangle_sas2sss";

    if (object == "ppp") dt( vl = [0,1,2]);
    if (object == "sas") dt( vl = [0,1,2], al = [2], sl = [0,1]);
    if (object == "asa") dt( vl = [0,1,2], al = [0,1], sl = [2]);
    if (object == "aas") dt( vl = [0,1,2], al = [0,1], sl = [0]);
    if (object == "sss") dt( sl = [0,1,2]);
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_svg}.mfs;

    defines   name "objects" define "object"
              strings "
                ppp
                sas
                asa
                aas
                sss
              ";
    variables add_opts_combine "objects";
    variables add_opts "--viewall --autocenter";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
