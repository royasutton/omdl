//! A catch latch generator.
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

    \amu_define group_name  (Catch latch)
    \amu_define group_brief (Catch latch generator.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group and macros.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_define includes_required_add
  (
    models/3d/fastener/screws.scad
  )
  \amu_include (include/amu/includes_required.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//! A catch latch generator.
/***************************************************************************//**
  \param  size  <decimal-list-6 | decimal> latch size;
                a list [px, py, pz, bx, by, bz], the latch profile and
                base-mount dimensions, or a single decimal px and the
                remainder using predefined scaling of px.

  \param  screw <decimal-list-5 | decimal> mount screw hole specifications;
                a list [d, t, h, r, b], the hole-diameter, tolerance,
                head-diameter, recess-height, bevel-height, or a single
                decimal for the hole diameter.

  \param  latch <integer-list-1 | integer> latch; the latch type;
                {1=no mount, 2=vertical mount, 3=horizontal mount}.

  \param  catch <<integer, decimal, decimal> | integer> catch; a list
                [t, h, g], the catch type, thickness, and gap, or a
                single decimal t for the catch type; {1=no mount,
                2=vertical mount, 3=horizontal mount}.

  \param  p_bevel <decimal-list-3> profile beveling; a list [f, v, h],
                  the flat-height, bevel-height, bevel-width, specified
                  as a percentage of the latch size.

  \param  p_width <decimal-list-3> profile width shaping; a list [t, c, h],
                  the width of the throat, catch, head, specified as a
                  percentage of the latch size.

  \param  p_height <decimal-list-3> profile height shaping; a list [t, s, e],
                   the height of the throat-end, catch-start, catch-end,
                   specified as a percentage of the latch size.

  \param  align <integer-list-3> object alignment; a list [x, y, z], the
                latch or catch alignment. Available alignment options
                depends on the object and its mount-type.

  \param  verb  <integer> console output verbosity {0=quiet, 1=info}.

  \details

    Construct a catch and latch.

    \amu_define scope_id      (example)
    \amu_define title         (Catch latch example)
    \amu_define image_views   (top bottom diag)
    \amu_define image_size    (sxga)

    \amu_include (include/amu/scope_diagrams_3d.amu)
*******************************************************************************/

module catch_latch
(
  size = 5,

  screw,

  latch,
  catch,

  p_bevel,
  p_width,
  p_height,

  align,
  verb = 0
)
{
  // construct latch
  module construct_latch()
  {
    extrude_linear_mss( h=bevel_mss_h )
    polygon(latch_p);
  }

  // construct catch
  module construct_catch()
  {
    extrude_linear_mss( h=bevel_mss_h )
    difference()
    {
      offset(r=catch_g+catch_h) polygon(latch_p);
      offset(r=catch_g) polygon(catch_p);

      // open mouth
      throat_w = hprofile_p[1].x*2;

      translate([0, -catch_h/2])
      square([ throat_w + catch_g*2 + catch_h*2, catch_h + catch_g*2], center = true);
    }
  }

  // construct mount
  module construct_mount(n, t)
  {
    difference()
    {
      union()
      {
        // mount
        rotate([0, 90, 0])
        extrude_linear_mss( h=mnt_dx, center=true )
        pg_rectangle(size=[size_my, size_mz], vr=pad_vr, center=true);

         // pad
        for( p=[-1, 1] )
        translate([p*mnt_dx/2, pad_dy/2 - size_mz/2, 0])
        extrude_linear_mss( h=size_my, center=true )
        pg_rectangle(size=[pad_dx, pad_dy], vr=mnt_vr, center=true);
      }

      // screw holes on both sizes of mount
      for( s=[-1, 1] )
      translate([s*mnt_dx/2, pad_dy/2 - size_mz/2, 0])
      screw_bore(d=screw_d, l=size_my+eps*8, h=[screw_h, screw_r, screw_b], t=[screw_t]);
    }

    if (verb > 0)
    {
      echo(strl
      ([ n, " mount, type ", t, ": screw hole diameter = ",
         screw_d, ", offset = ", mnt_dx
      ]));
    }
  }

  // assemble
  module assemble()
  {
    //
    // latch
    //

    if ( is_defined( latch ) )
    {
      if ( latch_t == 1 )
      {
        construct_latch();
      }

      if ( latch_t == 2 )
      {
        construct_latch();

        translate([0, -size_my/2, size_mz/2])
        mirror([0, 1, 0])
        rotate([90, 0, 0])
        construct_mount("latch", latch_t);

        // connect latch to mount
        translate([0, -size_my/4+eps*2, size_mz/2])
        extrude_linear_mss( h=size_mz, center=true )
        pg_rectangle(size=[width_t*2, size_my/2], vr=2, vrm=[0, 0, 4, 3], center=true);
      }

      if ( latch_t == 3 )
      {
        construct_latch();

        translate([0, -size_mz/2, size_my/2])
        mirror([0, 0, 1])
        rotate([180, 0, 0])
        construct_mount("latch", latch_t);

        // connect latch to mount
        rotate([270, 270, 270])
        extrude_rotate_tr(r=grid_coarse, ra=90)
        rotate([0, 0, 90])
        projection(cut=true)
        rotate([90, 0, 0])
        construct_latch();
      }
    }

    //
    // catch
    //

    if ( is_defined( catch ) )
    {
      if ( catch_t == 1 )
      {
        construct_catch();
      }

      if ( catch_t == 2 )
      {
        construct_catch();

        translate([0, size_my/2 + size_py + catch_g + catch_h*0, size_mz/2])
        rotate([90, 0, 0])
        construct_mount("catch", catch_t);
      }

      if ( catch_t == 3 )
      {
        construct_catch();

        difference()
        {
          translate([0, -size_mz/8 + size_py + catch_g + catch_h, size_my/2])
          construct_mount("catch", catch_t);

          resize([size_px+catch_g*4, size_py+catch_g*4, size_pz])
          construct_latch();
        }
      }
    }
  }

  //
  // global parameters
  //

  // latch/catch profile size: x, y, z
  size_px = defined_e_or(size, 0, size);
  size_py = defined_e_or(size, 1, size_px*5/2);
  size_pz = defined_e_or(size, 2, size_px*5/4);

  // latch/catch mount size: x, y, z
  size_mx = defined_e_or(size, 3, size_py*5/3);
  size_my = defined_e_or(size, 4, size_px/2);
  size_mz = defined_e_or(size, 5, size_pz);

  // mount screw: hole-diameter, tolerance, head-diameter, recess-height, bevel-height
  screw_d = defined_e_or(screw, 0, defined_or(screw, size_mz/3));
  screw_t = defined_e_or(screw, 1, 0);
  screw_h = defined_e_or(screw, 2, 0);
  screw_r = defined_e_or(screw, 3, 0);
  screw_b = defined_e_or(screw, 4, 0);

  // latch: mount-type
  latch_t = defined_e_or(latch, 0, latch);

  // catch: mount-type, thickness, gap
  catch_t = defined_e_or(catch, 0, catch);
  catch_h = defined_e_or(catch, 1, size_px/5);
  catch_g = defined_e_or(catch, 2, size_px/20);

  // latch/catch edge bevel (percentages): v-flat, v-bevel, h-bevel
  bevel_f = defined_e_or(p_bevel, 0, 0) / 100 * size_pz;
  bevel_v = defined_e_or(p_bevel, 1, 0) / 100 * size_pz;
  bevel_h = defined_e_or(p_bevel, 2, 0) / 100;

  // latch/catch profile width percentages): throat, catch, head
  width_t = defined_e_or(p_width, 0,  60) / 100 * size_px/2;
  width_c = defined_e_or(p_width, 1, 100) / 100 * size_px/2;
  width_h = defined_e_or(p_width, 2,  10) / 100 * size_px/2;

  // latch/catch profile height (percentages): throat-end, catch-start, catch-end
  height_t = defined_e_or(p_height, 0, 20) / 100 * size_py;
  height_s = defined_e_or(p_height, 1, 40) / 100 * size_py;
  height_e = defined_e_or(p_height, 2, 60) / 100 * size_py;

  //
  // global variables
  //

  // mount pad: separation, size-y, size-x, rounding(s)
  mnt_dx = size_mx - size_mz;

  pad_dy = max(screw_d*3, size_mz);
  pad_dx = pad_dy + screw_t;

  mnt_vr = pad_dy*2/5;
  pad_vr = size_my/2;

  // half-profile polygon points, rounding, and rounding-mode
  hprofile_p =
  [
    origin2d,                                 // base
    [width_t, 0], [width_t, height_t],        // throat; start, end
    [width_c, height_s], [width_c, height_e], // catch; start, end
    [width_h, size_py]                        // head
  ];

  hprofile_vr = [1/3, 1/2, 1, 1, 1/10] * size_px/2;
  hprofile_vrm = [0, 1, 1, 1, 1];

  // assemble full profile polygon points, rounding, and rounding-modes
  profile_p = concat( [for (i=hprofile_p) i], [for (i=reverse(hprofile_p)) [-i.x, i.y]] );
  profile_vr = concat( [for (i=hprofile_vr) i], [for (i=reverse(hprofile_vr)) i] );
  latch_vrm = concat( [for (i=hprofile_vrm) i], [for (i=reverse(hprofile_vrm)) i] );

  // flare-out catch mouth; replace first and last rounding elements of latch
  catch_vrm = concat( headn(concat( [3], tailn(latch_vrm))), [4] );

  // rounded polygon points for latch and catch
  latch_p = polygon_round_eve_all_p(c=profile_p, vr=profile_vr, vrm=latch_vrm);
  catch_p = polygon_round_eve_all_p(c=profile_p, vr=profile_vr, vrm=catch_vrm);

  // mss extrusion for bevels
  bevel_mss_h =
    let( h1 = bevel_f, h2 = bevel_v, s  = 1 - bevel_h )
    [ [h1, [s, s]], [h2, [s, 1]], size_pz - (h1 + h2)*2, [h2, [1, s]], [h1, [s, s]] ];

  //
  // orientation and alignment configuration
  //
  oaa = let
        (
          idl = is_defined(latch), idc = is_defined(catch),
           tl = latch_t, tc = catch_t,

          // repeating values and configurations
          v01 = catch_g+catch_h,
          v02 = +size_mz/8-size_py-v01,

          c01 = [ [0,0,0], [0,0,0], [ [0],[0],[0] ] ],
          c02 = [0, +mnt_dx/2+pad_dx/2, +mnt_dx/2, -mnt_dx/2, -mnt_dx/2-pad_dx/2],
          c03 = [0, -size_pz/2, -size_pz, -pad_dy/2, -pad_dy],
          c04 = [0, -size_my/2, -size_my, -size_pz/2, -size_pz]
        )
        !idc && idl ? // latch only
        (
            (tl == 1) ? [ [0, 0, 0], [0, 0, 0],
                          [ [0, -width_t, +width_t],
                            [0, -size_py/2, -size_py],
                            [0, -size_pz/2, -size_pz] ] ]
          : (tl == 2) ? [ [0, 0, 0], [0, +size_my, 0],
                          [ c02,
                            [0, -size_my, -size_py/2-size_my, -size_py-size_my],
                            c03 ] ]
          : (tl == 3) ? [ [0, 0, 0], [0, +pad_dy, 0],
                          [ c02,
                            [0, -pad_dy/2, -pad_dy, -size_py/2-pad_dy, -size_py-pad_dy],
                            c04 ] ]
          : c01
        )
      : idc && !idl ? // catch only
        (
            (tc == 1) ? [ [0, 0, 180], [0, +size_py+v01, 0],
                          [ [0, +size_px/2+v01, -size_px/2-v01],
                            [0, -catch_h, -size_py/2-catch_h, -size_py-catch_h],
                            [0, -size_pz/2, -size_pz] ] ]
          : (tc == 2) ? [ [0, 0, 180], [0, +size_py+catch_g+size_my, 0],
                          [ c02,
                            [0, -size_my, -size_py/2-size_my-catch_g, -size_py-size_my],
                            c03 ] ]
          : (tc == 3) ? [ [0, 0, 180], [0, pad_dy/2-v02, 0],
                          [ c02,
                            [0, -pad_dy/2, -pad_dy, v02-pad_dy/2+size_py/2, v02-pad_dy/2],
                            c04 ] ]
          : c01
        )
      : idc && idl ?  // both latch and catch
        (
          [ [0, 0, 0], [0, 0, 0],
            [ c02,
              [ 0,
                -size_py/2, +v02/2+pad_dy/4,
                -size_py-catch_g, +size_my, -size_py-catch_g-size_my,
                +pad_dy, +pad_dy/2, +v02+pad_dy/2, +v02, +v02-pad_dy/2
              ],
              concat(c03, [-size_my]) ]
          ]
        )
      : c01; // neither

  align_x = select_ci ( third(oaa).x, defined_e_or(align, 0, 0), false );
  align_y = select_ci ( third(oaa).y, defined_e_or(align, 1, 0), false );
  align_z = select_ci ( third(oaa).z, defined_e_or(align, 2, 0), false );

  //
  // object assembly
  //

  translate(second(oaa) + [align_x, align_y, align_z])
  rotate(first(oaa))
  assemble();
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
    include <models/3d/fastener/screws.scad>;
    include <parts/3d/fastener/catch_latch.scad>;

    s = 10;
    p = [10, 25, 10];
    c = [5, 4, 10, 2, 1] * s/10;

    catch_latch(latch=2, size=s, p_bevel=p, screw=c);

    translate([0, s*7, 0]) rotate([0, 0, 180])
    catch_latch(catch=3, size=s, p_bevel=p, screw=c);

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "top bottom diag";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//

