//! Basic 2D shapes revolved about the z-axis.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2015-2019

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

    \amu_define group_name  (2d Revolutions)
    \amu_define group_brief (Basic 2D shapes revolved about the z-axis.)
    \amu_define view        (diag)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group and macros.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)

  \amu_include (include/amu/example_dim_table.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//! A rectangular cross-sectional profile revolved about the z-axis.
/***************************************************************************//**
  \copydoc rotate_extrude_tre()

  \copydoc rectangle_c()

  \details

    \b Example
    \amu_eval ( function=rectangular_torus ${example_dim} )
*******************************************************************************/
module rectangular_torus
(
  r,
  pa = 0,
  ra = 360,
  profile = false,
  l,
  m = 255,

  size,
  core,
  t,
  co,
  cr = 0,
  vr,
  vr1,
  vr2,
  vrm = 0,
  vrm1,
  vrm2,
  center = false
)
{
  rotate_extrude_tre( r=r, l=l, pa=pa, ra=ra, m=m, profile=profile )
  rectangle_c
  (
    size=size, core=core, t=t,
    co=co, cr=cr,
    vr=vr, vr1=vr1, vr2=vr2,
    vrm=vrm, vrm1=vrm1, vrm2=vrm2,
    center=center
  );
}

//! A triangular cross-sectional profile revolved about the z-axis.
/***************************************************************************//**
  \copydoc rotate_extrude_tre()

  \copydoc triangle_ls_c()

  \details

    \b Example
    \amu_eval ( function=triangular_torus ${example_dim} )
*******************************************************************************/
module triangular_torus
(
  r,
  pa = 0,
  ra = 360,
  profile = false,
  l,
  m = 255,

  vs,
  vc,
  co,
  cr = 0,
  vr,
  vr1,
  vr2,
  centroid = false,
  incenter = false
)
{
  rotate_extrude_tre( r=r, l=l, pa=pa, ra=ra, m=m, profile=profile )
  triangle_ls_c
  (
    vs=vs, vc=vc,
    co=co, cr=cr,
    vr=vr, vr1=vr1, vr2=vr2,
    centroid=centroid, incenter=incenter
  );
}

//! An elliptical cross-sectional profile revolved about the z-axis.
/***************************************************************************//**
  \copydoc rotate_extrude_tre()

  \copydoc ellipse_cs()

  \details

    \b Example
    \amu_eval ( function=elliptical_torus ${example_dim} )
*******************************************************************************/
module elliptical_torus
(
  r,
  pa = 0,
  ra = 360,
  profile = false,
  l,
  m = 255,

  size,
  core,
  t,
  a1 = 0,
  a2 = 0,
  co,
  cr = 0
)
{
  rotate_extrude_tre( r=r, l=l, pa=pa, ra=ra, m=m, profile=profile )
  ellipse_cs
  (
    size=size, core=core, t=t,
    a1=a1, a2=a2,
    co=co, cr=cr
  );
}

//! A trapezoidal cross-sectional profile revolved about the z-axis.
/***************************************************************************//**
  \copydoc rotate_extrude_tre()

  \copydoc polygon_trapezoid()

  \param    sl <decimal> The left side leg length of the trapezoid
            polygon \p l.

  \details

    \b Example
    \amu_eval ( function=trapezoidal_torus ${example_dim} )

  \todo Use generic rounded trapezoid function for profile.
*******************************************************************************/
module trapezoidal_torus
(
  r,
  pa = 0,
  ra = 360,
  profile = false,
  l,
  m = 255,

  b = 1,
  h,
  sl = 1,
  a = 90,
  vr = 0,
  vrm = 1,
  vfn,
  cw = true,
  centroid = false
)
{
  rotate_extrude_tre( r=r, l=l, pa=pa, ra=ra, m=m, profile=profile )
  polygon_trapezoid
  (
    b=b,
    h=h,
    l=sl,
    a=a,
    vr=vr,
    vrm=vrm,
    vfn=vfn,
    cw=cw,
    centroid=centroid
  );
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

    shape = "rectangular_torus";
    $fn = 36;

    if (shape == "rectangular_torus")
      rectangular_torus( size=[40,20], core=[35,20], r=40, l=[90,60], co=[0,2.5], vr=4, vrm=15, m=63, center=true );
    else if (shape == "triangular_torus")
      triangular_torus( vs=40, vc=30, r=60, co=[0,-4], vr=4, pa=90, ra=270, centroid=true );
    else if (shape == "elliptical_torus")
      elliptical_torus( size=[20,15], t=[2,4], r=50, a1=0, a2=180, pa=90, ra=270, co=[0,2] );
    else if (shape == "trapezoidal_torus")
      trapezoidal_torus( b=[20,30], sl=30, a=45, vr=[5,5,5,5], vrm=[3,2,1,4], r=40, l=[90,60], m=63, centroid=true );
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {config_base,config_png}.mfs;

    views     name "views" views "diag";
    defines   name "shapes" define "shape"
              strings "
                rectangular_torus
                triangular_torus
                elliptical_torus
                trapezoidal_torus
              ";
    variables add_opts_combine "views shapes";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" script_std.mfs;
  END_MFSCRIPT;
END_SCOPE;

BEGIN_SCOPE manifest;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;

    $fn = 36;

    grid_repeat( g=4, i=150, center=true )
    {
      rectangular_torus( size=[40,20], core=[35,20], r=40, l=[25,60], co=[0,2.5], vr=4, vrm=15, m=63, center=true );
      triangular_torus( vs=40, vc=30, r=60, co=[0,-4], vr=4, pa=90, ra=270, centroid=true );
      elliptical_torus( size=[20,15], t=[2,4], r=60, a1=0, a2=180, pa=90, ra=270, co=[0,2] );
      trapezoidal_torus( b=[20,30], sl=30, a=45, vr=[5,5,5,5], vrm=[3,2,1,4], r=40, l=[25,60], m=63, centroid=true );
    }
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {config_base,config_stl}.mfs;
    include --path "${INCLUDE_PATH}" script_std.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
