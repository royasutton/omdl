//! Shape edge finishing tools.
/***************************************************************************//**
  \file   tools_edge.scad
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

  \ingroup tools tools_edge
*******************************************************************************/

include <shapes/shapes2d.scad>;

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \addtogroup tools

    \amu_define caption (Edge)

    \amu_make png_files (append=dim extension=png)
    \amu_make eps_files (append=dim extension=png2eps)
    \amu_shell file_cnt ("echo ${png_files} | wc -w")
    \amu_shell cell_num ("seq -f '(%g)' -s '^' ${file_cnt}")

    \htmlonly
      \amu_image_table
        (
          type=html columns=4 image_width="200" cell_files="${png_files}"
          table_caption="${caption}" cell_captions="${cell_num}"
        )
    \endhtmlonly
    \latexonly
      \amu_image_table
        (
          type=latex columns=4 image_width="1.25in" cell_files="${eps_files}"
          table_caption="${caption}" cell_captions="${cell_num}"
        )
    \endlatexonly
*******************************************************************************/

/***************************************************************************//**
  \addtogroup tools
  @{

  \defgroup tools_edge Edge
  \brief    Shape edge finishing tools.
  @{
*******************************************************************************/
//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
// openscad-amu macros
//----------------------------------------------------------------------------//
/***************************************************************************//**
  \amu_define scope (tools_edge_dim)
  \amu_define size  (qvga)
  \amu_define view  (diag)

  \amu_define example_dim
  (
    \image html  ${scope}_${size}_${view}_${function}.png "${function}"
    \image latex ${scope}_${size}_${view}_${function}.eps "${function}" width=2.5in
    \dontinclude ${scope}.scad \skipline ${function}(
  )
*******************************************************************************/
//----------------------------------------------------------------------------//

//! A 2d edge-finish profile specified by intersection radius.
/***************************************************************************//**
  \param    r <decimal> The radius length.
  \param    p <integer> The profile identifier.
  \param    f <decimal> The mid-point offset factor.
  \param    a <decimal> The sweep angle.

  \details

    \b Example
    \amu_eval ( function=edge_profile_r view=top ${example_dim} )

  \b Profiles:

    |  p  | Description                           |
    |:---:|:--------------------------------------|
    |  0  | Two segment bevel with mid inflection |
    |  1  | A cove with cut-out offset            |
    |  2  | A quarter round with offset           |

  \note     An offset factor greater than 1 moves the mid-point away
            from the profile edge-vertex. A factor less than 1 move it
            inwards towards the edge-vertex.
*******************************************************************************/
module edge_profile_r
(
  r,
  p = 0,
  f = 1,
  a = 90,
)
{
  // bevel with mid inflection
  if ( p == 0 )
  {
    c1x = r;
    c3x = c1x*cos(a);
    c3y = c1x*sin(a);

    mpc = f*[(c1x+c3x)/2, c3y/2];

    polygon([[0,0], [c1x,0], mpc, [c3x,c3y]]);
  }
  // cove with cut-out offset
  else if ( p == 1 )
  {
    difference()
    {
      c1x = r/tan(a/2);
      c3x = c1x*cos(a);
      c3y = c1x*sin(a);

      polygon([[0,0], [c1x,0], [c3x,c3y]]);

      translate(f*[c1x,r])
      circle(r=r);
    }
  }
  // quarter round with offset
  else if ( p == 2 )
  {
    c1x = r;
    c3x = c1x*cos(a);
    c3y = c1x*sin(a);

    mpc = unit_l([(c1x+c3x)/2, c3y/2]);

    if ( f < 1 )
      intersection()
      {
        polygon([[0,0], [c1x,0], [c3x,c3y]]);

        translate(f*mpc - mpc)
        ellipse_s(r, a1=0, a2=a);
      }
    else if ( f > 1 )
      union()
      {
        polygon([[0,0], [c1x,0], [c3x,c3y]]);

        translate(f*mpc - mpc)
        ellipse_s(r, a1=0, a2=a);
      }
    else
      ellipse_s(r, a1=0, a2=a);
  }
}

//! A 3d edge-finish additive shape specified by intersection radius.
/***************************************************************************//**
  \param    r <decimal> The radius length.
  \param    l <decimal> The edge length.

  \param    p <integer> The profile identifier.
  \param    f <decimal> The mid-point offset factor.

  \param    m <integer> The end finish mode: (B0: bottom, B1: top).
  \param    ba <decimal> The end bevel angle.

  \param    a1 <decimal> The edge plane start angle.
  \param    a2 <decimal> The edge plane end angle.

  \param    center <boolean> Center length about origin.

  \details

    \b Example
    \amu_eval ( function=edge_add_r ${example_dim} )

    | m   | B1  | B0  | Description                   |
    |:---:|:---:|:---:|:------------------------------|
    |  0  |  0  |  0  | cut bottom (-z) and top (+z)  |
    |  1  |  0  |  1  | bevel bottom and cut top      |
    |  2  |  1  |  0  | cut bottom and bevel top      |
    |  3  |  1  |  1  | bevel bottom and top          |

    See edge_profile_r() for description of available profiles.
*******************************************************************************/
module edge_add_r
(
  r,
  l = 1,
  p = 0,
  f = 1,
  m = 3,
  ba = 45,
  a1 = 0,
  a2 = 90,
  center = false
)
{
  sa = a2-a1;

  wx = (p == 0) ? max(r, r*f)
     : (p == 1) ? r/tan(sa/2)
     : max(r, r*f);

  wy = (p == 0) ? r
     : (p == 1) ? r/tan(sa/2)
     : r ;

  wz = wx*tan(ba);

  rotate([0, 0, a1])
  translate(center==true ? origin3d : [0, 0, l/2])
  difference()
  {
    translate([0,0,-l/2])
    linear_extrude(height=l)
    edge_profile_r(r, p, f, sa);

    rotate([0,0,sa/2])
    for ( c = [0, 1] )
    {
      if ( bitwise_is_equal(m, c, 1) )
      mirror([0, 0, c])
      polyhedron
      (
        points =
        [
          [ 0, -wy, -(l/2+aeps)],
          [ 0, +wy, -(l/2+aeps)],
          [wx, +wy, -(l/2+aeps)],
          [wx, -wy, -(l/2+aeps)],
          [wx, -wy, -(l/2-aeps-wz)],
          [wx, +wy, -(l/2-aeps-wz)]
        ],
        faces = [[1,5,4,0], [0,4,3], [1,2,5], [5,2,3,4], [2,1,0,3]]
      );
    }
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
    include <tools/tools_edge.scad>;

    shape = "edge_profile_r";
    $fn = 72;

    if (shape == "edge_profile_r")
      edge_profile_r( r=5, p=1, f=1+10/100, a=75 );
    else if (shape == "edge_add_r")
      rotate([90,-90,90]) edge_add_r( r=5, l=20, f=5/8, center=true );
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {config_base,config_png}.mfs;

    views     name "views" views "top diag";
    defines   name "shapes" define "shape"
              strings "
                edge_profile_r
                edge_add_r
              ";
    variables add_opts_combine "views shapes";
    variables add_opts "--viewall --autocenter";

    include --path "${INCLUDE_PATH}" script_std.mfs;
  END_MFSCRIPT;
END_SCOPE;

BEGIN_SCOPE manifest;
  BEGIN_OPENSCAD;
    include <tools_edge.scad>;

    $fn = 72;

    grid_repeat( g=5, i=10, center=true )
    {
      linear_extrude(1) edge_profile_r( r=5, p=1, f=1+10/100, a=75 );
      edge_add_r( r=5, l=20, f=5/8, center=true );
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
