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
  \param  s   <decimal> scale factor.
  \param  c   <boolean> color model.
  \param  b   <boolean> bevel fins.
  \param  t   <boolean> add "omdl" text.
  \param  td  <string> text output direction {"ltr"|"rtl"}.

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
  s = 10,
  c = false,
  b = false,
  t = false,
 td = "ltr"
)
{
  fs = [3, 5, 4] * s;
  vr = [4, 2, 1]/10 * s;

  ft = triangle2d_sss2ppp(fs * 1);
  ct = triangle2d_sss2ppp(fs * 2/3);

  fn = "Liberation Sans:style=Italic";

  // mss extrusions
  h1 = s/2;
  h2 = let( sh = 1/6, sf = 75/100 )
       [ [sh, [sf, 1]], sh, [sh, [1, sf]] ];

  // cone
  color(c?"slategray":undef)
  translate( [0, 0, -h1/2-eps*2] )
  cone( h=s, r=s, vr=1/5*s );

  // fins
  color(c?"gainsboro":undef)
  rotate(18)
  repeat_radial( n=5, angle=true )
  translate( triangle_centroid(ft) )
  extrude_linear_mss( h=(b?h2:h1), center=true )
  difference()
  {
    translate( -triangle_centroid(ft) )
    polygon( polygon_round_eve_all_p(ft, vr=vr) );

    translate( -triangle_centroid(ct) )
    polygon( polygon_round_eve_all_p(ct, vr=vr) );
  }

  // text
  if( t )
  {
    color(c?"slategray":undef)
    extrude_linear_mss( h=h1, center=true )
    translate([0, -fs.y, 0])
    text(text="omdl", size=s, font=fn, halign="left", valign="bottom", direction=td);
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

    omdl_logo(c=true, b=false, t=true);

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

