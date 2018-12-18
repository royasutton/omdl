//! Polygon shapes generated in 2D space.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2018

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

    \amu_define group_name  (2d Polygon)
    \amu_define group_brief (Polygon shapes generated in 2D space.)
    \amu_define view        (top)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
*******************************************************************************/

include <../math/triangle.scad>;
include <../math/polygon_primitives.scad>;
include <../tools/repeat.scad>;

//----------------------------------------------------------------------------//
// dim macro, dim table, and group.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/example_dim_table.amu)

  \amu_include (include/amu/group_in_parent_start.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//! An edge round with constant radius between two vectors.
/***************************************************************************//**
  \copydetails polygon2d_round_p()

  The coordinate points are rendered using polygon().
  Parameter \p cw = \b true preset.

  \details

    \b Example
    \amu_eval ( function=polygon_round ${example_dim} )
*******************************************************************************/

module polygon_round
(
  m  = 1,
  r  = 1,
  c  = origin2d,
  v1 = x_axis2d_uv,
  v2 = y_axis2d_uv,
  fn
)
{
  cw = true;

  pp = concat
  ( [c],
    polygon2d_round_p(m=m, r=r, c=c, v1=v1, v2=v2, fn=fn, cw=cw)
  );

  polygon( pp );
}


//! A trapezoid with vertex rounding.
/***************************************************************************//**
  \copydetails polygon2d_trapezoid_p()

  The coordinate points are rendered using polygon().
  Parameter \p cw = \b true preset.

  \param    centroid <boolean> Center polygon centroid at origin.

  \details

    \b Example
    \amu_eval ( function=polygon_trapezoid ${example_dim} )
*******************************************************************************/
module polygon_trapezoid
(
  b = 1,
  h,
  l = 1,
  a = 90,
  vr = 0,
  vrm = 1,
  vfn,
  centroid = false
)
{
  cw = true;

  c = polygon2d_trapezoid_p(b=b, h=h, l=l, a=a, vr=vr, vrm=vrm, vfn=vfn, cw=cw);

  translate ( (centroid==true) ? -polygon2d_centroid(c) : origin2d )
  polygon( c );
}

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE dim;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;

    shape = "polygon_round";
    $fn = 36;

    if (shape == "polygon_round")
      polygon_round( r=20, v1=[1,1], v2=135 );
    else if (shape == "polygon_trapezoid")
      polygon_trapezoid( b=[20,20], l=25, a=45, vr=[25,10,3,5], vrm=[4,1,1,4] );
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {config_base,config_png}.mfs;

    views     name "views" views "top";
    defines   name "shapes" define "shape"
              strings "
                polygon_round
                polygon_trapezoid
              ";
    variables add_opts_combine "views shapes";
    variables add_opts "--viewall --autocenter";

    include --path "${INCLUDE_PATH}" script_std.mfs;
  END_MFSCRIPT;
END_SCOPE;

BEGIN_SCOPE manifest;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;

    $fn = 36;

    grid_repeat( g=5, i=60, center=true )
    {
      polygon_round( r=20, v1=[1,1], v2=135 );
      polygon_trapezoid( b=[20,20], l=25, a=45, vr=[25,10,3,5], vrm=[4,1,1,4] );
    }
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {config_base,config_svg}.mfs;
    include --path "${INCLUDE_PATH}" script_std.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
