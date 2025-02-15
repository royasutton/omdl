//! Select 2D shapes revolved about the z-axis.
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

    \amu_define group_name  (Revolutions)
    \amu_define group_brief (Select 2D shapes revolved about the z-axis.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group and macros.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_include (include/amu/includes_required.amu)

  \amu_define image_view (diag)

  \amu_define group_id (${parent})
  \amu_include (include/amu/scope_diagrams_3d_in_group.amu)

  \amu_define group_id (${group})
  \amu_include (include/amu/scope_diagrams_3d_in_group.amu)

  \amu_include (include/amu/scope_diagram_3d_object.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//! A rectangular cross-sectional profile revolved about the z-axis.
/***************************************************************************//**
  \copydoc extrude_rotate_trl()

  \copydoc rectangle_c()

  \details

    \amu_eval ( object=torus_rectangle_c ${object_ex_diagram_3d} )
*******************************************************************************/
module torus_rectangle_c
(
  r,
  pa = 0,
  ra = 360,
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
  extrude_rotate_trl( r=r, l=l, pa=pa, ra=ra, m=m )
  rectangle_c
  (
    size=size, core=core, t=t,
    co=co, cr=cr,
    vr=vr, vr1=vr1, vr2=vr2,
    vrm=vrm, vrm1=vrm1, vrm2=vrm2,
    center=center
  );
}

//! An elliptical cross-sectional profile revolved about the z-axis.
/***************************************************************************//**
  \copydoc extrude_rotate_trl()

  \copydoc ellipse_cs()

  \details

    \amu_eval ( object=torus_ellipse_cs ${object_ex_diagram_3d} )
*******************************************************************************/
module torus_ellipse_cs
(
  r,
  pa = 0,
  ra = 360,
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
  extrude_rotate_trl( r=r, l=l, pa=pa, ra=ra, m=m )
  ellipse_cs
  (
    size=size, core=core, t=t,
    a1=a1, a2=a2,
    co=co, cr=cr
  );
}

//! A trapezoidal cross-sectional profile revolved about the z-axis.
/***************************************************************************//**
  \copydoc extrude_rotate_trl()

  \copydoc pg_trapezoid()

  \param    sl <decimal> The left side leg length of the trapezoid
            polygon \p l.

  \details

    \amu_eval ( object=torus_pg_trapezoid ${object_ex_diagram_3d} )
*******************************************************************************/
module torus_pg_trapezoid
(
  r,
  pa = 0,
  ra = 360,
  l,
  m = 255,

  b = 1,
  h,
  sl = 1,
  a = 90,
  vr,
  vrm = 1,
  vfn,
  center = false
)
{
  extrude_rotate_trl( r=r, l=l, pa=pa, ra=ra, m=m )
  pg_trapezoid
  (
    b=b,
    h=h,
    l=sl,
    a=a,
    vr=vr,
    vrm=vrm,
    vfn=vfn,
    center=center
  );
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
    include <shapes/revolved.scad>;

    shape = "torus_rectangle_c";
    $fn = 36;

    if (shape == "torus_rectangle_c")
      torus_rectangle_c( size=[40,20], core=[35,20], r=40, l=[90,60], co=[0,2.5], vr=4, vrm=15, m=63, center=true );
    else if (shape == "torus_ellipse_cs")
      torus_ellipse_cs( size=[20,15], t=[2,4], r=50, a1=0, a2=180, pa=90, ra=270, co=[0,2] );
    else if (shape == "torus_pg_trapezoid")
      torus_pg_trapezoid( b=[20,30], sl=30, a=45, vr=[5,5,5,5], vrm=[2,1,4,3], r=40, l=[90,60], m=63, center=true );
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;

    views     name "views" views "diag";
    defines   name "shapes" define "shape"
              strings "
                torus_rectangle_c
                torus_ellipse_cs
                torus_pg_trapezoid
              ";
    variables add_opts_combine "views shapes";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
