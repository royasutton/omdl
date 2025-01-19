//! OpenSCAD mechanical design library logos.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2025

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

    \amu_define group_name  (omdl logos)
    \amu_define group_brief (OpenSCAD mechanical design library logos.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group and macros.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_include (include/amu/includes_required.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//! Standard omdl logo.
/***************************************************************************//**
  \param  r   <decimal> logo radius.
  \param  c   <boolean> color model.
  \param  b   <boolean> bevel fins.
  \param  t   <boolean> add logo text.
  \param  td  <string> text direction: {"ltr" | "rtl"}.
  \param  a   <integer> z-alignment: {0 | 1 | 2 | 3}.
  \param  d   <decimal> logo diameter (overrides \p r).

  \details

    \amu_define scope_id      (example)
    \amu_define title         (omdl logo example)
    \amu_define image_views   (top bottom back diag)
    \amu_define image_columns (4)
    \amu_define image_size    (sxga)

    \amu_include (include/amu/scope_diagrams_3d.amu)
*******************************************************************************/

module omdl_logo
(
  r   = 5,
  c   = false,
  b   = false,
  t   = false,
  td  = "ltr",
  a   = 0,
  d
)
{
   s  = is_defined(d) ? d/10 : r/5;

  v1  = s/5;
  v2  = [4, 2, 1] * s/10;

  // mss extrusions
  h1  = s/2;
  h2  = let
        (
          sh = s/6,
          sf = 75/100
        )
        [ [sh, [sf, 1]], sh, [sh, [1, sf]] ];

  translate( [0, 0, select_ci([0, -h1/2, -h1, v1/2-s], a, false)] )
  union()
  {
    fn = "Liberation Sans:style=Italic";

    ts = [3, 5, 4] * s;

    t1 = triangle2d_sss2ppp(ts * 1);
    t2 = triangle2d_sss2ppp(ts * 2/3);

    // cone
    color(c?"slategray":undef)
    translate( [0, 0, -eps*2] )
    cone( h=s, r=s, vr=v1 );

    // fins
    color(c?"gainsboro":undef)
    rotate(18)
    repeat_radial( n=5, angle=true )
    translate( triangle_centroid(t1) )
    extrude_linear_mss( h=(b?h2:h1), center=false )
    difference()
    {
      translate( -triangle_centroid(t1) )
      polygon( polygon_round_eve_all_p(t1, vr=v2) );

      translate( -triangle_centroid(t2) )
      polygon( polygon_round_eve_all_p(t2, vr=v2) );
    }

    // text
    if( t )
    {
      color(c?"slategray":undef)
      translate([third(ts) * 4/5, 0])
      extrude_linear_mss( h=h1, center=false )
      text(text="omdl", size=s, font=fn, halign="center", valign="center", direction=td);
    }
  }
}

//! @}
//! @}


//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE example;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <models/3d/misc/omdl_logo.scad>;

    $fn = 36;

    omdl_logo(c=false, b=true, t=true);

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "top bottom back diag";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//

