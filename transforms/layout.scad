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

  \amu_include (include/amu/doxyg_init_pd_gds_ipg.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group and macros.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/doxyg_define_in_parent_open.amu)
  \amu_include (include/amu/includes_required.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//! A transform sequence to place a child shape.
/***************************************************************************//**
  \param  t       <datastuct> The transform sequence configuration
                  (see below).

  \param  s       <integer | integer-list | range> The optional child
                  object selection(s).

  \param  b       <decimal-list-2:3> The placement reference region
                  (bounding box).

  \param mode     <integer> Modifier mode.

  \param  verb    <integer> Console output verbosity.

  \details

  This module performs an ordered sequence of geometric transforms as a
  single composite operation. Using a transformation configuration
  list, child objects may be translated, rotated, mirrored, and placed
  as specified in the table below.

  This function is a simplified version of layout_grid_rp() that omits
  child replication functionality.

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

    e | data type         | 3D default | 2D default | scalar updates | parameter description
  ---:|:-----------------:|:----------:|:----------:|:-----------:|:------------------------------------
    0 | integer                     | \p mode   | \p mode   | - | layout modifier mode
    1 | decimal-list-2:3 \| decimal | [0,0,0]   | [0,0]     | x | layout placement
    2 | integer-list-2:3 \| integer | [0,0,0]   | [0,0]     | x | child mirror
    3 | decimal-list-2:3 \| decimal | 0         | 0         | z | child rotate
    4 | decimal-list-2:3 \| decimal | [0,0,0]   | [0,0]     | x | layout translate

  #### t[0]: layout modifier mode

    v | description
  ---:|:------------------------------------
    0 | none
    1 | disable
    2 | show only
    3 | highlight / debug
    4 | transparent / background
*******************************************************************************/
module layout_grid_p
(
  t,
  s,
  b = zero3d,
  mode = 0,
  verb = 0
)
{
  // apply transform on all children
  module transform_all()
  {
    // group translate
    gt  = [ for (i = [0:ac-1]) b[i] * lp[i] ];

    translate( gt + lt )
    rotate( cr )
    mirror( cm )

    children();
  }

  cs = defined_or(s, [0:$children-1]);

  ac  = is_list(b) ? len(b) : undef;

  assert
  (
    ac == 2 || ac == 3,
    "Bounds must have two or three dimensions."
  );

  c0  = [for (i = [0:ac-1]) 0];

  //
  // decode layout list
  //

  // mm: modifier mode
  mm  = defined_e_or  (t, 0, mode);

  // lP; layout placement
  lp  = list_get_value(t, 1, c0, ac, 0);

  // cm: child mirror; cr: child rotate
  cm  = list_get_value(t, 2, c0, ac, 0);
  cr  = defined_e_or  (t, 3, 0);

  // lt: layout translate
  lt  = list_get_value(t, 4, c0, ac, 0);

  //
  // apply transform sequence with modifier
  //

  if      ( mm == 0 )
    transform_all() children(cs);
  else if ( mm == 2 )
   !transform_all() children(cs);
  else if ( mm == 3 )
   #transform_all() children(cs);
  else if ( mm == 4 )
   %transform_all() children(cs);

  if (verb > 0)
  {
    log_info(strl(["t = ", t, ", s = ", cs, ", b = ", b, ", mode = ", mode]));

    if (verb >1)
      echo(mm=mm, lp=lp, cm=cm, cr=cr, lt=lt);
  }
}

//! A transform sequence to replicate and place a child shape.
/***************************************************************************//**
  \param  t       <datastuct> The transform sequence configuration
                  (see below).

  \param  s       <integer | integer-list | range> The optional child
                  object selection(s).

  \param  b       <decimal-list-2:3> The placement reference region
                  (bounding box).

  \param center   <boolean-list-2:3 | boolean> Center the replication
                  group about the child objects' local origin.

  \param mode     <integer> Modifier mode.

  \param  verb    <integer> Console output verbosity.

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

    e | data type         | 3D default | 2D default | scalar updates | parameter description
  ---:|:-----------------:|:----------:|:----------:|:-----------:|:------------------------------------
    0 | integer                     | \p mode   | \p mode   | - | layout modifier mode
    1 | decimal-list-2:3 \| decimal | [0,0,0]   | [0,0]     | x | layout placement
    2 | decimal-list-2:3 \| decimal | 0         | 0         | z | layout rotate
    3 | integer-list-2:3 \| integer | [0,0,0]   | [0,0]     | x | child mirror
    4 | decimal-list-2:3 \| decimal | 0         | 0         | z | child rotate
    5 | decimal-list-2:3 \| decimal | [0,0,0]   | [0,0]     | x | layout translate
    6 | integer-list-2:3 \| integer | [1,1,1]   | [1,1]     | x | child replication
    7 | integer-list-2:3 \| integer | [1,1,1]   | [1,1]     | x | replication layout grid
    8 | boolean-list-2:3 \| boolean | \p center | \p center | [x, y, z] | center replication

  #### t[0]: layout modifier mode

    v | description
  ---:|:------------------------------------
    0 | none
    1 | disable
    2 | show only
    3 | highlight / debug
    4 | transparent / background

  \amu_define scope_id      (example)
  \amu_define title         (Transform example)
  \amu_define image_views   (top front diag)
  \amu_define image_size    (sxga)

  \amu_include (include/amu/scope_diagrams_3d.amu)
*******************************************************************************/
module layout_grid_rp
(
  t,
  s,
  b = zero3d,
  center = false,
  mode = 0,
  verb = 0
)
{
  // apply transform on all children
  module transform_all()
  {
    // z-axis object instances and grid spacing (2d and 3d)
    rc_z = (ac == 2) ? 0 : [0:rc.z-1];
    rg_z = (ac == 2) ? 0 : rg.z;

    // group translate
    gt  = [ for (i = [0:ac-1]) b[i] * lp[i] ];

    // re-center object group offset
    co  = [ for (i = [0:ac-1]) (rg[i] * (rc[i]-1))/2 * (lc[i] == true ? 1 : 0) ];

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

    children();
  }

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

  // mm: modifier mode
  mm  = defined_e_or  (t, 0, mode);

  // lP; layout placement; lr: layout rotate
  lp  = list_get_value(t, 1, c0, ac, 0);
  lr  = defined_e_or  (t, 2, 0);

  // cm: child mirror; cr: child rotate
  cm  = list_get_value(t, 3, c0, ac, 0);
  cr  = defined_e_or  (t, 4, 0);

  // lt: layout translate
  lt  = list_get_value(t, 5, c0, ac, 0);

  // rc: child replication; rg: replication layout grid
  rc  = list_get_value(t, 6, c1, ac, 1);
  rg  = list_get_value(t, 7, c0, ac, 0);

  // lc: center replication
  lc  = list_get_value(t, 8, cf, ac, center, -1);

  //
  // apply transform sequence with modifier
  //

  if      ( mm == 0 )
    transform_all() children(cs);
  else if ( mm == 2 )
   !transform_all() children(cs);
  else if ( mm == 3 )
   #transform_all() children(cs);
  else if ( mm == 4 )
   %transform_all() children(cs);

  if (verb > 0)
  {
    log_info(strl(["t = ", t, ", s = ", cs, ", b = ", b, ", center = ", center, ", mode = ", mode]));

    if (verb >1)
      echo(mm=mm, lp=lp, lr=lr, cm=cm, cr=cr, lt=lt, rc=rc, rg=rg, lc=lc);
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
    include <transforms/layout.scad>;

    $fn = 36;

    b = [20, 5, 20];

    v =
    [
      3,
      0,
      [90,0,0],
      0,
      0,
      0,
      [6,6,1],
      [3,3,6]
    ];

    %cube(b, center=true);
    layout_grid_rp( t=v, b=b, center=true, mode=3 )
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

