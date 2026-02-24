//! Ordered sequences of geometric transforms as a single composite operation.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2026

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

    \amu_define group_name  (Layout)
    \amu_define group_brief (Ordered sequences of geometric transforms as a single composite operation.)

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

//! An sequence of transforms to replicate and place a child shape.
/***************************************************************************//**
  \param  t       <datastuct> The transform sequence configuration
                  (see below).

  \param  b       <decimal-list-2:3> The placement reference region
                  (bounding box).

  \param center   <boolean-list-2:3 | boolean> Center the replication
                  group about the child objects' local origin.

  \param debug    <boolean> Highlight the objects for layout and
                  placement debugging.

  \param  s       <integer | integer-list | range> The optional child
                  object selection(s).

  \details

  This module performs an ordered sequence of geometric transforms as a
  single composite operation. Using a transformation configuration
  list, child objects may be translated, rotated, mirrored, placed, and
  replicated as specified in the table below.

  An optional bounding box region may be defined to provide a reference
  frame for layout placement. The layout—also referred to as the
  bounding box—serves as a positional guide only; placements may extend
  beyond this region if desired.

  ## Multi-value and structured parameters

  ### t

  The transform sequence is specified as a configuration list with the
  elements described below. The operation supports both 2D and 3D
  modes. The configuration list does not need to be fully specified;
  any unspecified elements are automatically assigned the default
  values shown in the table.

    e | data type         | 3D default | 2D default | parameter description
  ---:|:-----------------:|:----------:|:----------:|:------------------------------------
    0 | integer-list-2:3 \| integer | [1,1,1]   | [1,1]      | child replication
    1 | integer-list-2:3 \| integer | [1,1,1]   | [1,1]      | replication layout grid
    2 | decimal-list-2:3 \| decimal | [0,0,0]   | [0,0]      | layout placement
    3 | decimal-list-2:3 \| decimal | 0         | 0          | layout rotate
    4 | integer-list-2:3 \| integer | [0,0,0]   | [0,0]      | child mirror
    5 | decimal-list-2:3 \| decimal | 0         | 0          | child rotate
    6 | decimal-list-2:3 \| decimal | [0,0,0]   | [0,0]      | layout translate
    7 | boolean-list-2:3 \| boolean | \p center | \p center  | center replication
    8 | boolean                     | \p debug  | \p debug   | highlight layout objects (debug)

  \amu_define scope_id      (example)
  \amu_define title         (Transform example)
  \amu_define image_views   (top front diag)
  \amu_define image_size    (sxga)

  \amu_include (include/amu/scope_diagrams_3d.amu)
*******************************************************************************/
module layout_grid_rp
(
  t,
  b = zero3d,
  center = false,
  debug = false,
  s
)
{
  cs = defined_or(s, [0:$children-1]);

  ac  = is_list(b) ? len(b) : undef;

  assert
  (
    ac == 2 || ac == 3,
    "Bounds must have two or three dimensions."
  );

  c0  = [for (i = [0:ac-1]) 0];
  c1  = [for (i = [0:ac-1]) 1];
  cf  = is_list( center ) ? center
      : [for (i = [0:ac-1]) center];

  //
  // decode layout list
  //

  // rc: child replication; rg: replication layout grid
  rc  = list_get_value(t, 0, c1, ac, 1);
  rg  = list_get_value(t, 1, c0, ac, 0);

  // lP; layout placement; lr: layout rotate
  lp  = list_get_value(t, 2, c0, ac, 0);
  lr  = defined_e_or  (t, 3, 0);

  // cm: child mirror; cr: child rotate
  cm  = list_get_value(t, 4, c0, ac, 0);
  cr  = defined_e_or  (t, 5, 0);

  // lt: layout translate
  lt  = list_get_value(t, 6, c0, ac, 0);

  // lc: center replication; lh: highlight layout objects
  lc  = list_get_value(t, 7, cf, ac, center);
  lh  = defined_e_or  (t, 8, debug);

  // z-axis object instances and grid spacing (2d and 3d)
  rc_z = (ac == 2) ? 0 : [0:rc.z-1];
  rg_z = (ac == 2) ? 0 : rg.z;

  // group translate
  gt  = [ for (i = [0:ac-1]) b[i] * lp[i] ];

  // re-center object group offset
  co  = [ for (i = [0:ac-1]) (rg[i] * (rc[i]-1))/2 * (lc[i] == true ? 1 : 0) ];

  //
  // apply transform sequence
  //

  // group placement
  translate( gt )
  rotate( lr )

  // center group + offsets
  translate( lt - co )

  // group instances
  for (i = [0:rc.x-1], j = [0:rc.y-1], k = rc_z)
  translate( [rg.x * i, rg.y * j, rg_z * k] )

  // object placement
  rotate( cr )
  mirror( cm )
  if ( lh )
   #children(cs);
  else
    children(cs);
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
    include <transforms/layout.scad>;

    $fn = 36;

    b = [20, 5, 20];

    v =
    [
      [6,6,1],
      [3,3,6],

      [0,0,0],
      [90,0,0]
    ];

    %cube(b, center=true);
    layout_grid_rp( t=v, b=b, center=true, debug=true )
    cylinder( r=1, h=6, center=true );

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "top front diag";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//

