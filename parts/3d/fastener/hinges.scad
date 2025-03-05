//! Print-in-place hinge generators.
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

    \amu_define group_name  (Hinges)
    \amu_define group_brief (Print-in-place hinge generators.)

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

//! A print-in-place single-fold hinge generator.
/***************************************************************************//**

  \param  wth     <decimal> wall thickness.

  \param  size    <datastruct | decimal> pivot and plate sizes; a list
                  [l, w], the lengths and widths or a single decimal to
                  set the lengths. The parameter \p l is a <decimal
                  list-3 | decimal> [lh, lpl, lpr], the hinge, left,
                  and right plate lengths or a single decimal to set
                  (lh=lpl=lpr). Parameter \p w is a <decimal-list-2 |
                  decimal> [wpl, wpr], the left and right plate widths
                  or a single decimal to set (wpl=wpr). Any unspecified
                  parameters are assigned the last specified value.

  \param  vr      <datastruct | decimal> plate rounding radii; a list
                  [vrl, vrr], the left and right rounding radii or a
                  single decimal to set (vrl=vrr). The parameters \p
                  vrl and \p vrr are <decimal-list-4 | decimal>, the
                  corner rounding radii for the left and right plates
                  or a single decimal to round all corners the same.

  \param  vrm     <datastruct | integer> plate rounding mode; a list
                  [vrml, vrmr], the left and right rounding modes or a
                  single integer to set (vrml=vrmr). The parameters \p
                  vrml and \p vrmr are <integer-list-4 | integer>, the
                  corner rounding modes for the left and right plates
                  or a single integer to round all corners the same.

  \param  knuckle <datastruct> knuckles (see below).

  \param  offset  <decimal-list-2 | dcimal> pivot-to-plate offset; a
                  list [oz, oy], the z-offset and y-offset between the
                  pivot and plates or a single decimal to set \p oz.
                  The default offset value is [-wth/2, 0] for a
                  backflap hinge configuration.


  \param  pbore   <datastruct> the knuckle pivot bore (see below).

  \param  mbore   <datastruct> mount plate bore (see below).

  \param  mbores  <datastruct> mount plate bore instance list (see
                  below).

  \param  support <boolean> add print support for knuckles.

  \param  mode    <integer> part mode (see below).

  \param  pivot   <decimal-list-2 | decimal> the pivot; a list [pl,
                  pr], the left and right mount plate pivots or a
                  single decimal to set (pl=pr).

  \param  align   <integer-list-3 | integer> the part alignment; a
                  list [x, y, z], or a single integer to set \p z
                  (default = [0, 0, 0]).

  \param  verb    <integer> console output verbosity {0=quiet, 1=info}.

  \details

    This module constructs custom single-fold hinges; such as a butt,
    backflap, strap, gate, offset, continuous, or a knuckle hinge. Most
    aspects of the hinge can be controlled via a parameter and the base
    configuration is for a version that can be printed in-place on a 3d
    printer. Alternatively, the pivot bore can be specified for use
    with metal pins. The plate size and mount holes are configurable
    and the bores are generated by screw_bore().

    ## Multi-value and structured parameters

    ### knuckle

    #### Data structure fields: knuckle

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | <decimal>         | wth               | \p kd: diameter
      1 | <integer>         | 2                 | count
      2 | <decimal>         | 1/2               | gap
      3 | <integer>         | 0                 | mode
      4 | <datastruct>      | 4                 | pin


    ##### Data structure fields: knuckle[3]: mode

      v | description
    ---:|:---------------------------------------
      0 | cylinder with no gap
      1 | male pin
      2 | female pin
      3 | gaped cylinders
      4 | hole for external pin
      5 | print support projection (for internal use)

    ##### Data structure fields: knuckle[4]: pin

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | <decimal>         | kd*3/4            | \p pd: cone base diameter
      1 | <decimal>         | pd/2              | cone height
      2 | <decimal>         | pd/3              | point rounding radius

    ### pbore, mbore

      The hinge pivot and the mount plate bores use a common
      specification and are performed using screw_bore(). The data
      structure is detailed in the following section.

    #### Data structure fields: pbore, mbore

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | <decimal>         | 0                 | \p bd: bore diameter
      1 | <datastruct>      | undef             | \p bh: bore head
      2 | <datastruct>      | undef             | \p bn: bore nut
      3 | <datastruct>      | 1                 | \p bf: bore scale factor

      The documentation of the bore parameters \p bh, \p bn and \p bf
      can be found in the screw_bore().

    ### mbores

    #### Data structure schema:

    name            | schema
    ---------------:|:----------------------------------------------
    mbores          | [ instances ]
    instances       | [ instance, instance, ..., instance ]

    ##### mbores[0]: instances

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | <datastruct-list> | undef             | instance list

    ##### Data structure fields: mbores[0]: instance

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | <decimal-list-2 \| decimal> | required | bore center offset [x, y]

      For an instance with a single decimal, the supplied value
      controls the bore instance \p x-offset (with y=0).

    ### part mode

      A binary encoded integer value.

      b | description
    ---:|:---------------------------------------
      0 | generate left mount plate
      1 | generate right mount plate

    \amu_define scope_id      (example_sf_backflap)
    \amu_define title         (Backflap hinge example)
    \amu_define image_views   (top bottom right diag)
    \amu_define image_columns (4)
    \amu_define image_size    (sxga)

    \amu_include (include/amu/scope_diagrams_3d.amu)

    \amu_define scope_id      (example_sf_custom)
    \amu_define title         (Custom hinge example)
    \amu_define image_views   (top bottom right diag)
    \amu_define image_columns (4)
    \amu_define image_size    (sxga)

    \amu_include (include/amu/scope_diagrams_3d.amu)
*******************************************************************************/
module hinge_sf
(
  wth = 1,
  size,
  vr,
  vrm,
  knuckle,
  offset,
  pbore,
  mbore,
  mbores,
  support = true,
  mode = 3,
  pivot,
  align,
  verb = 0
)
{
  // construct knuckle section
  module construct_knuckle
  (
    m,        // modes [l, r]: (see below)
    d,        // diameter
    l,        // length
    p,        // pip-pin [diameter, height, vr];
    w,        // shadow width
    g = 0     // gap
  )
  {
    // modes:
    //  0: un-gaped-cylinder
    //  1: male, 2=female
    //  3: gaped cylinder
    //  4: hole for external pin
    //  5: shadow

    // side modes [l, r]
    ml = defined_eon_or(m, 0, 0);
    mr = defined_e_or  (m, 1, ml);

    // side gaps [l, r]
    gl = (ml != 0) ? g/2 : 0;
    gr = (mr != 0) ? g/2 : 0;

    // section length
    sl = l - gl - gr;

    // shaddow: m={[5,*]|[*,5}}
    if ((ml == 5) || (mr == 5))
    {
      translate([-l/2 + gl, eps/2, -w/2])
      cube([sl, eps, w], center=false);
    }
    else
    // others: m={0|1|2|3|4}
    {
      // pin
      pd  = defined_eon_or(p, 0, d*3/4);
      ph  = defined_e_or(p, 1, pd/2);
      pvr = defined_e_or(p, 2, ph/3);

      // male and female cone transforms, m*={1|2}: [side, mirror, offset]
      mc_l = [ if (ml == 1) [+1, 1, +(gl + eps*4)], if (mr == 1) [-1, 0, -(gr + eps*4)] ];
      fc_l = [ if (ml == 2) [+1, 0, +(gl - eps*4)], if (mr == 2) [-1, 1, -(gr - eps*4)] ];

      difference()
      {
        // cylinder section
        translate([0, 0, -l/2 + gl])
        cylinder(d=d, h=sl, center=false);

        // female cone
        for ( i = fc_l )
        translate([0, 0, -l/2 * first(i) + third(i)])
        mirror([0, 0, second(i)])
        cone(d=pd, h=ph, vr=[0, pvr]);

        // pin thru-hole
        if ((ml == 4) || (mr == 4))
        cylinder(d=pd, h=l + eps*8, center=true);
      }

      // male cone
      for ( i = mc_l )
      translate([0, 0, -l/2 * first(i) + third(i)])
      mirror([0, 0, second(i)])
      cone(d=pd, h=ph, vr=[0, pvr]);
    }
  }

  // assemble enabled hinge-half sides
  module assemble_ehhs()
  {
    // generate transform list of enabled hinge-half sides
    hht_ls  = [[0, -1, 1], [1, 1, 0]];
    hht_lse = [
                for ( s = [0: len(hht_ls)-1] )
                  if ( binary_bit_is(mode, s, 1) )
                    hht_ls[ s ]
              ];

    // hinge-half transforms: [hn, hs, hm]
    for ( hht_l = hht_lse )
    {
      ns    = first( hht_l );   // number
      hs    = second( hht_l );  // sign
      hm    = third( hht_l );   // mirror

      // current side width, vr, vrm, and bores
      p_l   = defined_e_or(l_plr, ns, undef);
      p_w   = defined_e_or(w_plr, ns, undef);

      p_vr  = defined_eon_or(vr, ns, undef);
      p_vrm = defined_eon_or(vrm, ns, 0);

      pbo_l =  defined_e_or(mbores, ns, undef);

      if (verb > 0)
      echo(strl([ "side=", ns, ", w=", p_w, ", vr=", p_vr,
        ", vrm=", p_vrm, ", bores=", pbo_l ]));

      // hinge-half
      rotate([defined_eon_or(pivot, ns, 0) * hs, 0, 0])
      union()
      {
        // cylinder section length and x-offset
        cs_len = l_h/(k_spc*2+1);
        cs_xos = -(l_h - cs_len)/2;

        // cylinder section half list and flatten-list
        //  right(+1)=even, left(-1)=odd
        cs_hl  = (hs == +1) ? [0:2:k_spc*2] : [1:2:k_spc*2];
        cs_hf  = [for ( x=cs_hl ) x];

        // hinge-half: knuckle sections
        for (s = cs_hf)
        translate([(cs_xos + cs_len * s) * hs, 0, 0])
        union()
        {
          is_fst = (s == first(cs_hf));
          is_lst = (s == last(cs_hf));
          is_eve = is_even( s );

          // cylinders
          mc  = is_fst ? is_eve ? [0, 3] : 3
              : is_lst ? is_eve ? [3, 0] : 3
              : 3;

          // shadows
          ms  = is_fst ? is_eve ? [0, 5] : 5
              : is_lst ? is_eve ? [5, 0] : 5
              : 5;

          // pin mode (selection based on k_mps)
          mp  = (k_mps == 0) ?
                ( // fingers: even=male, odd=female
                    is_fst ? is_eve ? [0, 1] : 2
                  : is_lst ? is_eve ? [1, 0] : 2
                  : is_eve ? 1 : 2
                )
              : (k_mps == 1) ?
                ( // fingers: even=female, odd=male
                    is_fst ? is_eve ? [0, 2] : 1
                  : is_lst ? is_eve ? [2, 0] : 1
                  : is_eve ? 2 : 1
                )
              : (k_mps == 2) ?
                ( // hole for external pin
                    is_fst ? is_eve ? [0, 4] : 4
                  : is_lst ? is_eve ? [4, 0] : 4
                  : 4
                )
              : mc;

          difference()
          {
            hull()
            {
              // knuckle section cylinder-only (reduce diameter)
              rotate([0, 90, 0])
              construct_knuckle(m=mc, d=k_dia - eps*4, l=cs_len, g=k_gap, p=k_pin);

              // plate wall interface
              translate([0, (k_dia/2 + k_yo) * hs, k_zo])
              construct_knuckle(m=ms, l=cs_len, w=wth, g=k_gap, p=k_pin);

              // print-in-place 45% angle build-up
              if ( support )
              translate([0, k_dia/2 * hs, -wth/2 + k_zo])
              rotate([90, 0, 0])
              construct_knuckle(m=ms, l=cs_len, w=k_dia/2, g=k_gap, p=k_pin);
            }

            // remove knuckle section cylinder-only (increase length)
            rotate([0, 90, 0])
            construct_knuckle(m=mc, d=k_dia, l=cs_len+eps*4, g=k_gap, p=k_pin);
          }

          // add knuckle section (with selected pin mode)
          rotate([0, 90, 0])
          construct_knuckle(m=mp, d=k_dia, l=cs_len, g=k_gap, p=k_pin);
        }

        // hinge-half: plate
        translate([0, (p_w/2 + k_dia/2 + k_yo) * hs, k_zo])
        mirror([0, hm, 0])
        difference()
        {
          // plate
          extrude_linear_uss(wth, center=true)
          pg_rectangle([p_l, p_w], vr=p_vr, vrm=p_vrm, center=true);

          // remove mount plate bores
          if ( is_defined(mbore) && is_defined(pbo_l) )
          {
            pb_d = defined_eon_or(mbore, 0, 0);
            pb_h = defined_e_or(mbore, 1, undef);
            pb_n = defined_e_or(mbore, 2, undef);
            pb_f = defined_e_or(mbore, 3, 1);

            pb_l = wth + eps*8;

            for ( pb = pbo_l )
            {
              xo = defined_eon_or(pb, 0, 0);
              yo = defined_e_or(pb, 1, 0);

              translate([xo, yo, 0])
              screw_bore(d=pb_d, l=pb_l, h=pb_h, n=pb_n, f=pb_f);

              if (verb > 0)
              echo(strl([ "bore=[", xo, ", ", yo, "]" ]));
            }
          }
        }
      }
    }
  }

  // assemble
  module assemble()
  {
    difference()
    {
      assemble_ehhs();

      // remove pivot pin bore
      if ( is_defined(pbore) )
      {
        pb_d = defined_eon_or(pbore, 0, 0);
        pb_h = defined_e_or(pbore, 1, undef);
        pb_n = defined_e_or(pbore, 2, undef);
        pb_f = defined_e_or(pbore, 3, 1);

        pb_l = l_h + eps*8;

        rotate([0, -90, 0])
        screw_bore(d=pb_d, l=pb_l, h=pb_h, n=pb_n, f=pb_f);
      }
    }
  }

  //
  // global parameters
  //

  // size: length and width
  l     = defined_eon_or(size, 0, undef);
  w     = defined_e_or(size, 1, undef);

  // length: hinge and plates
  l_h   = defined_eon_or(l, 0, wth);
  l_pl  = defined_e_or(l, 1, l_h);
  l_pr  = defined_e_or(l, 2, l_pl);

  l_plr = [l_pl, l_pr];

  // widths: plates
  w_pl  =  defined_eon_or(w, 0, wth);
  w_pr  =  defined_e_or(w, 1, w_pl);

  w_plr = [w_pl, w_pr];

  // knuckle: diameter, count, gap, pin-mode, pin
  //  when pbore is specified always set k_mps, pin-mode, to 3
  k_dia = defined_eon_or(knuckle, 0, wth);
  k_spc = ceil(defined_e_or(knuckle, 1, 2));
  k_gap = defined_e_or(knuckle, 2, 1/2);
  k_mps = is_defined(pbore) ? 3
        : defined_e_or(knuckle, 3, 0);
  k_pin = defined_e_or(knuckle, 4, k_dia*3/5);

  // hinge offsets: open z-offset (closed y-offset) and open y-offset
  k_zo  = defined_eon_or(offset, 0, -wth/2);
  k_yo  = defined_e_or(offset, 1, 0);

  //
  // global variables
  //

  if (verb > 0)
  {
    echo(strl([ "size: l=", l, ", w=", w ]));
    echo(strl([ "size: hinge=", l_h,
      ", left-plate=[", w_pl, ", ", l_pl, "]",
      ", right-plate=[", w_pr, ", ", l_pr, "]"]));
    echo(strl([ "knuckle: mode=", k_mps, ", diameter=", k_dia,
       ", count=", k_spc, ", gap=", k_gap, ", pin=", k_pin ]));
    echo(strl([ "offset: zo=", k_zo, ", yo=", k_yo ]));
  }

  //
  // object assembly
  //

  alignments =
  let
  (
    ey = k_yo + k_dia/2,
    ez = k_zo + wth/2
  )
  [
    [0, -l_h, -l_pl, -l_pr, +l_pr, +l_pl, +l_h]/2,
    [0, -ey, -ey-w_pr/2, -ey-w_pr, +ey, +ey+w_pl/2, +ey+w_pl ],
    [0, -ez, -ez+wth/2, -ez+wth]
  ];

  // when 'align' is scalar assign to 'align_z'
  align_x = select_ci ( alignments.x, defined_e_or(align, 0, 0), false );
  align_y = select_ci ( alignments.y, defined_e_or(align, 1, 0), false );
  align_z = select_ci ( alignments.z, defined_eon_or(align, 2, 0), false );

  translate([align_x, align_y, align_z])
  assemble();
}

//! A print-in-place bi-fold hinge generator.
/***************************************************************************//**

  \param  wth     <decimal> wall thickness.

  \param  size    <datastruct | decimal> pivot and plate sizes; a list
                  [l, w], the lengths and widths or a single decimal to
                  set the lengths. The parameter \p l is a <decimal
                  list-5 | decimal> [lh, lpl, lpr, lpml, lpmr], the
                  hinge, left plate, right plate, left-middle plate,
                  and right-middle plage lengths or a single decimal to
                  set (lh=lpl=lpr=lpml=lpmr). Parameter \p w is a
                  <decimal-list-4 | decimal> [wpl, wpr, wpml, wpmr],
                  the left, right, left-middle, and right-middle plate
                  widths or a single decimal to set
                  (wpl=wpr=wpml=wpmr). Any unspecified parameters are
                  assigned the last specified value.

  \param  vr      <datastruct | decimal> plate rounding radii; a list
                  [vrl, vrr, vrml, vrmr], the left, right, left-middle,
                  and right-middle rounding radii or a single decimal
                  to set (vrl=vrr=vrml=vrmr). The parameters are
                  <decimal-list-4 | decimal>, the individual corner
                  rounding radii or a single decimal to round all
                  corners the same.

  \param  vrm     <datastruct | integer> plate rounding mode; a list
                  [vrml, vrmr, vrmml, vrmmr], the left, right,
                  left-middle, and right-middle rounding mode or a
                  single integer to set (vrml=vrmr=vrmml=vrmmr). The
                  parameters are <integer-list-4 | integer>, the
                  individual corner rounding modes or a single integer
                  to round all corners the same.

  \param  knuckle <datastruct> knuckles (see below).

  \param  offset  <decimal-list-3 | dcimal> pivot-to-plate offsets; a
                  list [oz, oyl, oyr], the z-offset, left, and right
                  y-offset between the pivots and plates or a single
                  decimal to set \p oz (default = [0, 0, 0]).


  \param  pbore   <datastruct> the knuckle pivot bore (see below).

  \param  mbore   <datastruct> mount plate bore (see below).

  \param  mbores  <datastruct> mount plate bore instance list (see
                  below).

  \param  support <boolean> add print support for knuckles.

  \param  mode    <integer> part mode (see below).

  \param  pivot   <decimal-list-2 | decimal> the pivot; a list [pl,
                  pr], the left and right mount plate pivots or a
                  single decimal to set (pl=pr).

  \param  align   <integer-list-3 | integer> the part alignment; a
                  list [x, y, z], or a single integer to set \p z
                  (default = [0, 0, 0]).

  \param  verb    <integer> console output verbosity {0=quiet, 1=info,
                  2=details}.

  \details

    This module constructs custom bi-fold hinges with print-in-place
    pivot pins. This type of hinge allows for full folding in both
    directions. Most aspects of the hinge can be controlled via a
    parameter. Alternatively, the pivot bore can be specified for use
    with externally supplied pins. The plate size and mount holes are
    configurable and the bores are generated by screw_bore().

    ## Multi-value and structured parameters

    ### knuckle

    #### Data structure fields: knuckle

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | <decimal>         | wth               | \p kd: diameter
      1 | <integer>         | 2                 | count
      2 | <decimal>         | 1/4               | gap
      3 | <integer>         | 0                 | mode
      4 | <datastruct>      | 4                 | pin


    ##### Data structure fields: knuckle[3]: mode

      v | description
    ---:|:---------------------------------------
      0 | cylinder with no gap
      1 | male pin
      2 | female pin
      3 | gaped cylinders
      4 | hole for external pin
      5 | print support projection (for internal use)

    ##### Data structure fields: knuckle[4]: pin

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | <decimal>         | kd*3/4            | \p pd: cone base diameter
      1 | <decimal>         | pd/2              | cone height
      2 | <decimal>         | pd/3              | point rounding radius

    ### pbore, mbore

      The hinge pivot and the mount plate bores use a common
      specification and are performed using screw_bore(). The data
      structure is detailed in the following section.

    #### Data structure fields: pbore, mbore

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | <decimal>         | 0                 | \p bd: bore diameter
      1 | <datastruct>      | undef             | \p bh: bore head
      2 | <datastruct>      | undef             | \p bn: bore nut
      3 | <datastruct>      | 1                 | \p bf: bore scale factor

      The documentation of the bore parameters \p bh, \p bn and \p bf
      can be found in the screw_bore().

    ### mbores

    #### Data structure schema:

    name            | schema
    ---------------:|:----------------------------------------------
    mbores          | [ instances-l, instances-r, instances-lm, instances-rm ]
    instances-*     | [ instance, instance, ..., instance ]

    #### Data structure fields: mbores

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | <datastruct-list> | undef             | instance list left plate
      1 | <datastruct-list> | undef             | instance list right plate
      2 | <datastruct-list> | undef             | instance list left-middle plate
      3 | <datastruct-list> | undef             | instance list right-middle plate

      The left- and right-middle plate bores can be specified together
      or separately as configured by a mode bit described below.

    ##### Data structure fields: mbores[0-3]: instance-*

      e | data type         | default value     | parameter description
    ---:|:-----------------:|:-----------------:|:------------------------------------
      0 | <decimal-list-2 \| decimal> | required | bore center offset [x, y]

      For an instance with a single decimal, the supplied value
      controls the bore instance \p x-offset (with y=0).

    ### part mode

      A binary encoded integer value.

      b | description
    ---:|:---------------------------------------
      0 | generate left mount plate
      1 | generate right mount plate
      2 | generate middle mount plate
      3 | specification of left and right middle-plate bores are separate

      When mode bit-3 is set to one, the specification of the
      left-middle and right-middle plate bores are independent and
      specified by \p mbores[2] and \p mbores[3], respectively. When
      mode bit-3 is set to zero, both the left and right are specified
      together using by \p mbores[2].

    \amu_define scope_id      (example_bf)
    \amu_define title         (Bi-fold hinge example)
    \amu_define image_views   (top bottom right diag)
    \amu_define image_columns (4)
    \amu_define image_size    (sxga)

    \amu_include (include/amu/scope_diagrams_3d.amu)
*******************************************************************************/
module hinge_bf
(
  wth = 1,
  size,
  vr,
  vrm,
  knuckle,
  offset,
  pbore,
  mbore,
  mbores,
  support = true,
  mode = 7,
  pivot,
  align,
  verb = 0
)
{
  // assemble
  module assemble()
  {
    // assemble left (n=0) and right (n=1) sides
    for ( n=[0, 1] )
    mirror([0, n, 0])
    hinge_sf
    (
      // common and fixed
      wth = wth,
      knuckle = knuckle,
      pbore = pbore,
      mbore = mbore,
      support = support,
      verb = verb-1,
      align = [0, 3, 0],

      // side-dependent adjustments
      size = size_df[n],
      vr = vr_df[n],
      vrm = vrm_df[n],
      offset = offset_df[n],
      mbores = mbores_df[n],
      mode = mode_df[n],
      pivot = pivot_df[n]
    );
  }

  //
  // global parameters
  //

  // size: length and width
  l     = defined_eon_or(size, 0, undef);
  w     = defined_e_or(size, 1, undef);

  // length: hinge and plates
  l_h   = defined_eon_or(l, 0, wth);
  l_pl  = defined_e_or(l, 1, l_h);
  l_pr  = defined_e_or(l, 2, l_pl);
  l_pml = defined_e_or(l, 3, l_h);
  l_pmr = defined_e_or(l, 4, l_pml);

  // widths: plates
  w_pl  =  defined_eon_or(w, 0, wth);
  w_pr  =  defined_e_or(w, 1, w_pl);
  w_pml =  defined_e_or(w, 2, wth/2);
  w_pmr =  defined_e_or(w, 3, w_pml);

  // middle rounding radius and modes
  vr_ml  = defined_eon_or(vr, 2, undef);
  vr_mr  = defined_eon_or(vr, 3, vr_ml);

  vrm_ml = defined_eon_or(vrm, 2, 0);
  vrm_mr = defined_eon_or(vrm, 3, vrm_ml);

  // hinge offsets
  k_zo  = defined_eon_or(offset, 0, 0);
  kl_yo = defined_e_or(offset, 1, 0);
  kr_yo = defined_e_or(offset, 2, kl_yo);

  //  hinge bores: middle handling; mode bit b3;
  //    0 = right bores same as left
  //    1 = right bores separate at mbores[3]
  mbores_l  = defined_e_or(mbores, 0, undef);
  mbores_r  = defined_e_or(mbores, 1, undef);
  mbores_ml = defined_e_or(mbores, 2, undef);
  mbores_mr = binary_bit_is(mode, 3, 0)
            ? mbores_ml
            : defined_e_or(mbores, 3, undef);

  // part mode: b0=left, b1=right, b2=middle
  mode_dm   = binary_ishr(binary_and(mode, 4));
  mode_dl   = binary_and(mode, 1) + mode_dm;
  mode_dr   = binary_ishr(binary_and(mode, 2)) + mode_dm;

  // pivots
  pivot_l   = defined_eon_or(pivot, 0, 0);
  pivot_r   = defined_e_or(pivot, 1, pivot_l);

  //
  // global variables
  //

  size_df   = [ [[l_h, l_pl, l_pml], [w_pl, w_pml]],
                [[l_h, l_pr, l_pmr], [w_pr, w_pmr]] ];

  vr_df     = [ [defined_eon_or(vr, 0, undef), vr_ml],
                [defined_eon_or(vr, 1, undef), vr_mr] ];

  vrm_df    = [ [defined_eon_or(vrm, 0, 0), vrm_ml],
                 [defined_eon_or(vrm, 1, 0), vrm_mr] ];

  offset_df = [ [k_zo, kl_yo],
                [k_zo, kr_yo] ];

  mbores_df = [ [mbores_l, mbores_ml],
                [mbores_r, mbores_mr] ];

  mode_df   = [ mode_dl, mode_dr ];

  pivot_df  = [ [pivot_l, 0], [pivot_r, 0] ];

  if (verb > 0)
  {
    echo(strl([ "size: l=", l, ", w=", w ]));

    echo(strl([
      "size: hinge=", l_h,
      ", left-plate=[", w_pl, ", ", l_pl, "]",
      ", right-plate=[", w_pr, ", ", l_pr, "]",
      ", middle-left-plate=[", w_pml, ", ", l_pml, "]",
      ", middle-right-plate=[", w_pmr, ", ", l_pmr, "]"
    ]));

    echo(strl([ "offset: zo=", k_zo, ", left-yo=", kl_yo, ", right-yo=", kr_yo ]));

    echo(strl([
      "bores: left-plate=", mbores_l, ", right-plate=", mbores_r,
      ", middle-left-plate=", mbores_ml, ", middle-right-plate=", mbores_mr
    ]));
  }

  //
  // object assembly
  //

  alignments =
  let
  ( // decode knuckle radius (diameter/2)
    kr    = defined_eon_or(knuckle, 0, wth)/2,

    // x alignments
    xap   = [l_h, l_pl, l_pr, l_pml, l_pmr]/2,

    // y-left alignments
    eyl   = kl_yo + kr,
    yapl  = [w_pml, w_pml+eyl, w_pml+eyl*2, w_pml+eyl*2+w_pl/2, w_pml+eyl*2+w_pl],

    // y-right alignments
    eyr   = kr_yo + kr,
    yapr  = [w_pmr, w_pmr+eyr, w_pmr+eyr*2, w_pmr+eyr*2+w_pr/2, w_pmr+eyr*2+w_pr],

    // z alignments
    ez    = k_zo + wth/2,
    zap   = [-kr, kr, ez-wth, ez-wth/2, ez]
  )
  [
    concat(0, -xap, 0, +xap),
    concat(0, -yapr, 0, +yapl),
    concat(0, -zap)
  ];

  // when 'align' is scalar assign to 'align_z'
  align_x = select_ci ( alignments.x, defined_e_or(align, 0, 0), false );
  align_y = select_ci ( alignments.y, defined_e_or(align, 1, 0), false );
  align_z = select_ci ( alignments.z, defined_eon_or(align, 2, 0), false );

  // assemble left and right sides and align
  translate([align_x, align_y, align_z])
  assemble();
}

//! @}
//! @}


//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE example_sf_backflap;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <models/3d/fastener/screws.scad>;
    include <parts/3d/fastener/hinges.scad>;

    $fn = 36;

    for (y = [[1, -2], [2, +2]])
    translate([0, second(y), 0])
    hinge_sf
    (
      wth=3,
      size=[[28,30], 10],
      vr=1,vrm=1,
      pivot=45/2,
          mode=first(y)
    );

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "top bottom right diag";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;

BEGIN_SCOPE example_sf_custom;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <models/3d/fastener/screws.scad>;
    include <parts/3d/fastener/hinges.scad>;

    $fn = 36;

    for (y = [[1, -3], [2, +3]])
    translate([0, second(y), 0])
    hinge_sf
    (
      wth=3,
      size=[[18, 20, 35], [4, 6]],
      vr=1,
      vrm=[[4,3,1,1],[10,9,5,5]],

      knuckle=[5, 2, 1/2],

      mbore=[1, [2, 1, 1/2], [2, 1]],
      mbores=[[-7, 0, 7], [-14, -7, 0, 7, 14]],

      offset=[undef, 2],
      mode=first(y)
    );

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "top bottom right diag";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;

BEGIN_SCOPE example_bf;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <models/3d/fastener/screws.scad>;
    include <parts/3d/fastener/hinges.scad>;

    $fn = 36;

    l = 150;  w = 75; h = 8;

    b = [for (x=[-1,0,1], y=[-1,1]) [l/3*x, w/4*y]];

    hinge_bf
    (
      wth=h,
      size=[[l*9/10, l], [w, w, h]],
      vr=[w, w]/10,
      vrm=5,
      knuckle=[h, 4, 1/2],
      mbore=[6, [12,2,1]],
      mbores=[b, b],
      offset=[0, h/2],
      pivot=30
    );

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "top bottom right diag";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//

