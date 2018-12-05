//! Common 2D shapes revolved about the z-axis.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2015-2018

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

    \amu_define group_name  (3d Torus)
    \amu_define group_brief (Common 2D shapes revolved about the z-axis.)
    \amu_define view        (diag)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
*******************************************************************************/

include <derivative_2d.scad>;
include <../tools/extrude.scad>;

//----------------------------------------------------------------------------//
// dim macro, dim table, and group.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/example_dim_table.amu)

  \amu_include (include/amu/group_in_parent_start.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//! A rectangular cross-sectional profile revolved about the z-axis.
/***************************************************************************//**
  \copydoc rotate_extrude_tre()

  \copydoc rectangle_c()

  \details

    \b Example
    \amu_eval ( function=torus_rp ${example_dim} )
*******************************************************************************/
module torus_rp
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
    \amu_eval ( function=torus_tp ${example_dim} )
*******************************************************************************/
module torus_tp
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
    \amu_eval ( function=torus_ep ${example_dim} )
*******************************************************************************/
module torus_ep
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

//! A rectangular profile revolved about the z-axis for generating cylinders.
/***************************************************************************//**
  \copydoc rotate_extrude_tre()

  \param    cr <decimal-list-2|decimal> The lower and upper radius. A
            list [cr1, cr2] of decimals or a single decimal for (cr1=cr2).
  \param    h <decimal> The height.

  \param    vr <decimal-list-2|decimal> The profile corner rounding
            radius. A list [vr1, vr2] of decimals or a single decimal
            for (vr1=vr2). Unspecified corners are not rounded.

  \param    center <boolean> Center profile height.

  \details

    \b Example
    \amu_eval ( function=torus_cp ${example_dim} )

  \todo Use generic rounded trapezoid function for profile.
*******************************************************************************/
module torus_cp
(
  r,
  pa = 0,
  ra = 360,
  profile = false,
  l,
  m = 255,

  cr,
  h,
  vr = 0,
  center = false
)
{
  cr1  = edefined_or(cr, 0, cr);
  cr2  = edefined_or(cr, 1, cr1);

  // limit corner rounding to [0, cr1/2]
  vr1 = limit(edefined_or(vr, 0, vr), 0, cr1/2);
  vr2 = limit(edefined_or(vr, 1, vr1), 0, cr2/2);

  pc1 = [cr1-vr1,   vr1];
  pc2 = [cr2-vr2, h-vr2];

  a  = 90
     + angle_ll (x_axis2d_ul, [pc2, pc1])
     - angle_ll (x_axis2d_ul, [distance_pp(pc2, pc1), vr2-vr1]);

  p =
  [
    [0, 0],
    [cr1-vr1, 0],
    pc1 + vr1*[cos(a), sin(a)],
    pc2 + vr2*[cos(a), sin(a)],
    [cr2-vr2, h],
    [0, h]
  ];

  translate(center==true ? [0, 0, -h/2] : origin3d)
  rotate_extrude_tre( r=r, l=l, pa=pa, ra=ra, m=m, profile=profile )
  union()
  {
    translate(pc1)
    circle(r=vr1);

    translate(pc2)
    circle(r=vr2);

    polygon(points=p, paths=[[0,1,2,3,4,5,6]]);
  }
}

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE dim;
  BEGIN_OPENSCAD;
    include <shapes/derivative_torus.scad>;

    shape = "torus_rp";
    $fn = 72;

    if (shape == "torus_rp")
      torus_rp( size=[40,20], core=[35,20], r=40, l=[90,60], co=[0,2.5], vr=4, vrm=15, center=true );
    else if (shape == "torus_tp")
      torus_tp( vs=40, vc=30, r=60, co=[0,-4], vr=4, pa=90, ra=270, centroid=true );
    else if (shape == "torus_ep")
      torus_ep( size=[20,15], t=[2,4], r=50, a1=0, a2=180, pa=90, ra=270, co=[0,2] );
    else if (shape == "torus_cp")
      torus_cp( cr=[15,10], h=30, vr=[5,2], r=40, l=[90,60], center=true );
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {config_base,config_png}.mfs;

    views     name "views" views "diag";
    defines   name "shapes" define "shape"
              strings "
                torus_rp
                torus_tp
                torus_ep
                torus_cp
              ";
    variables add_opts_combine "views shapes";
    variables add_opts "--viewall --autocenter";

    include --path "${INCLUDE_PATH}" script_std.mfs;
  END_MFSCRIPT;
END_SCOPE;

BEGIN_SCOPE manifest;
  BEGIN_OPENSCAD;
    include <shapes/derivative_torus.scad>;

    $fn = 72;

    grid_repeat( g=4, i=150, center=true )
    {
      torus_rp( size=[40,20], core=[35,20], r=40, l=[25,60], co=[0,2.5], vr=4, vrm=15, center=true );
      torus_tp( vs=40, vc=30, r=60, co=[0,-4], vr=4, pa=90, ra=270, centroid=true );
      torus_ep( size=[20,15], t=[2,4], r=60, a1=0, a2=180, pa=90, ra=270, co=[0,2] );
      torus_cp( cr=[15,10], h=30, vr=[5,2], r=40, l=[25,60], center=true );
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
