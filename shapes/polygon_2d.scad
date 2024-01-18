//! Polygon shapes generated in 2D space.
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

    \amu_define group_name  (2d Polygons)
    \amu_define group_brief (Polygon shapes generated in 2D space.)

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
*******************************************************************************/

//----------------------------------------------------------------------------//

//! An edge round with constant radius between two vectors.
/***************************************************************************//**
  \copydetails polygon_round_eve_p()

  \details

    \amu_eval ( object=polygon_corner_round ${object_ex_diagram_3d} )
*******************************************************************************/
module polygon_corner_round
(
  r  = 1,
  m  = 1,
  c  = origin2d,
  v1 = x_axis2d_uv,
  v2 = y_axis2d_uv
)
{
  pp = concat
  ( [c],
    polygon_round_eve_p(r=r, m=m, c=c, v1=v1, v2=v2)
  );

  polygon( pp );
}

//! An elliptical sector.
/***************************************************************************//**
  \copydetails polygon_elliptical_sector_p()

  \details

    \amu_eval ( object=polygon_elliptical_sector ${object_ex_diagram_3d} )
*******************************************************************************/
module polygon_elliptical_sector
(
  r = 1,
  c = origin2d,
  v1 = x_axis2d_uv,
  v2 = x_axis2d_uv,
  s = true
)
{
  c = polygon_elliptical_sector_p(r=r, c=c, v1=v1, v2=v2, s=s);

  polygon( c );
}

//! A trapezoid with individual vertex rounding and arc facets.
/***************************************************************************//**
  \copydetails polygon_trapezoid_p()

  \details

    \amu_eval ( object=polygon_trapezoid ${object_ex_diagram_3d} )
*******************************************************************************/
module polygon_trapezoid
(
  b = 1,
  h,
  l = 1,
  a = 90,
  vr = 0,
  vrm = 1,
  vfn
)
{
  c = polygon_trapezoid_p(b=b, h=h, l=l, a=a, vr=vr, vrm=vrm, vfn=vfn);

  polygon( c );
}

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE diagram;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;

    shape = "polygon_corner_round";
    $fn = 36;

    if (shape == "polygon_corner_round")
      polygon_corner_round( r=20, v1=[1,1], v2=135 );
    else if (shape == "polygon_elliptical_sector")
      polygon_elliptical_sector( r=[20, 15], v1=115, v2=-115 );
    else if (shape == "polygon_trapezoid")
      polygon_trapezoid( b=[20,20], l=25, a=45, vr=[25,10,3,5], vrm=[4,1,1,4] );
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;

    views     name "views" views "top";
    defines   name "shapes" define "shape"
              strings "
                polygon_corner_round
                polygon_elliptical_sector
                polygon_trapezoid
              ";
    variables add_opts_combine "views shapes";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;

BEGIN_SCOPE manifest;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;

    $fn = 36;

    repeat_grid( g=5, i=60, center=true )
    {
      polygon_corner_round( r=20, v1=[1,1], v2=135 );
      polygon_elliptical_sector( r=[20, 15], v1=115, v2=-115 );
      polygon_trapezoid( b=[20,20], l=25, a=45, vr=[25,10,3,5], vrm=[4,1,1,4] );
    }
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_svg}.mfs;
    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
