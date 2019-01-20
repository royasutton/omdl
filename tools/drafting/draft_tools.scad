//! Drafting tools and operations.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2019

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

    \amu_define group_name  (Draft)
    \amu_define group_brief (Drafting tools and operations.)

  \amu_include (include/amu/pgid_path_pstem_g.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
// tool components
//----------------------------------------------------------------------------//

//! .
/***************************************************************************//**
*******************************************************************************/
module draft_layers
(
  layers = draft_get_default("layers")
)
{
  if (exists(is_list(layers)?layers:[layers], draft_layers_show, true))
    children();
}

//! .
/***************************************************************************//**
    draft_sheet_get_zone()
    v = [ [ zp:[px=0, py=0], [rx/ix, ry/iy], child_idx, layer="root" ] ... ]

  draft_move ( [ for (x=[0:7], y=[0:3] ) [[0,0], [x,y], 0] ] )
  square([10,10]);
*******************************************************************************/
module draft_move
(
  list
)
{
  // do nothing when no children
  if ( $children )
  for ( i = [0:max($children-1, len(list)-1)] )
  {
    e = list[i];

    // default layer
    l = defined_or(e[3], draft_get_default("layers"));

    // iff layer active
    if (exists(is_list(l)?l:[l], draft_layers_show, true))
    {
      // default alignment
      p = defined_or(e[0], [0, 0]);

      // numerical or string references
      n = all_numbers(e[1]) ? e[1] : [undef, undef];
      s = all_strings(e[1]) ? e[1] : [undef, undef];;

      // child index default
      c = defined_or(e[2], i);

      translate
      (
        draft_sheet_get_zone
        (
          rx=s[0], ry=s[1],
          ix=n[0], iy=n[1],
          zp=p,
          frame=false, window=false
        )
      )
      children(c);
    }
  }
}

//! .
/***************************************************************************//**
*******************************************************************************/
module draft_sheet
(
  sheet,
  frame,
  zone,
  grid,
  zero,
  check = false,    // check configuration
  layers = draft_get_default("layers")
)
{
  if ( !table_exists( r=draft_sheet_config_tr, ri=draft_sheet_config ) )
    log_error( str("unknown sheet configuration [", draft_sheet_config, "]") );
  else if (exists(is_list(layers)?layers:[layers], draft_layers_show, true))
  {
    // check tables
    if ( check )
    {
      table_check( r=draft_sheet_config_tr, c=draft_sheet_config_tc );
      table_check( r=draft_sheet_sizes_tr, c=draft_sheet_sizes_tc );
    }

    //
    // get configuration values (scale all lengths)
    //

    // sheet size
    sdx = draft_sheet_get_value(ci="sdx") * draft_scaler;
    sdy = draft_sheet_get_value(ci="sdy") * draft_scaler;

    // sheet layout
    sll = draft_config_get_value(ci="sll");

    // sheet frame and zone margins
    smx = draft_config_get_value(ci="smx") * draft_scaler;
    smy = draft_config_get_value(ci="smy") * draft_scaler;
    szm = draft_config_get_value(ci="szm") * draft_scaler;

    // reference zone labels
    zox = draft_config_get_value(ci="zox");
    zoy = draft_config_get_value(ci="zoy");
    zlx = draft_config_get_value(ci="zlx");
    zly = draft_config_get_value(ci="zly");
    zrf = draft_config_get_value(ci="zrf");
    zfs = draft_config_get_value(ci="zfs");

    // sheet, frame, zone, grid, and zero/origin line configuration
    slc = draft_config_get_value(ci="slc");
    flc = draft_config_get_value(ci="flc");
    zlc = draft_config_get_value(ci="zlc");
    glc = draft_config_get_value(ci="glc");
    olc = draft_config_get_value(ci="olc");

    //
    // derived values
    //

    // sheet layout dimensions
    ldx = sll ? sdy : sdx;
    ldy = sll ? sdx : sdy;

    // sheet frame dimensions
    fdx = ldx - smx;
    fdy = ldy - smy;

    //
    // sheet layout
    //
    sheet_w = edefined_or(defined_or(sheet, slc), 0, defined_or(sheet, slc));
    if ( sheet_w )
    {
      sheet_s = edefined_or(defined_or(sheet, slc), 1, 4);

      // layout
      draft_rectangle( d=[ldx, ldy], w=sheet_w, s=sheet_s );
    }

    //
    // sheet frame
    //
    frame_w = edefined_or(defined_or(frame, flc), 0, defined_or(frame, flc));
    if ( frame_w )
    {
      frame_s = edefined_or(defined_or(frame, flc), 1, 1);

      // frame
      draft_rectangle( d=[fdx, fdy], w=frame_w, s=frame_s );
    }

    //
    // zone reference
    //
    zone_w = edefined_or(defined_or(zone, zlc), 0, defined_or(zone, zlc));
    if ( zone_w )
    {
      zone_s = edefined_or(defined_or(zone, zlc), 1, 1);

      // zone frame
      draft_rectangle( d=[fdx, fdy]-2*[szm, szm], w=zone_w, s=zone_s );

      // zone x-grid and references
      for ( ix = [0:len(zlx)-1], iyo = [1,-1] )
      {
        x  = ix * fdx/len(zlx) - fdx/2;
        yo = iyo * (fdy/2 - szm/2);

        if (ix > 0)
        draft_line( l=[ [x, yo-szm/2], [x, yo+szm/2] ], w=zone_w, s=zone_s );

        zlt = (zox > 0) ? zlx[ix] : zlx[len(zlx)-1-ix];
        translate( [x + fdx/len(zlx)/2, yo] )
        text(zlt, font=zrf, size=szm*zfs, halign="center", valign="center");
      }

      // zone y-grid and references
      for ( iy = [0:len(zly)-1], ixo = [1,-1] )
      {
        y  = iy * fdy/len(zly) - fdy/2;
        xo = ixo * (fdx/2 - szm/2);

        if (iy > 0)
        draft_line( l=[ [xo-szm/2, y], [xo+szm/2, y] ], w=zone_w, s=zone_s );

        zlt = (zoy > 0) ? zly[iy] : zly[len(zly)-1-iy];
        translate( [xo, y + fdy/len(zly)/2] )
        text(zlt, font=zrf, size=szm*zfs, halign="center", valign="center");
      }
    }

    //
    // feild grid
    //
    grid_w = edefined_or(defined_or(grid, glc), 0, defined_or(grid, glc));
    if ( grid_w )
    {
      grid_s = edefined_or(defined_or(grid, glc), 1, 2);

      // x-grid
      for ( ix = [1:len(zlx)-1], iyo = [1,-1] )
      {
        x  = ix * fdx/len(zlx) - fdx/2;
        draft_line( l=[ [x, -fdy/2], [x, fdy/2] ], w=grid_w, s=grid_s );
      }
      // y-grid
      for ( iy = [1:len(zly)-1], ixo = [1,-1] )
      {
        y  = iy * fdy/len(zly) - fdy/2;
        draft_line( l=[ [-fdx/2, y], [fdx/2, y] ], w=grid_w, s=grid_s );
      }
    }

    //
    // zero/origin tics
    //
    origin_w = edefined_or(defined_or(zero, olc), 0, defined_or(zero, olc));
    if ( origin_w )
    {
      origin_s = edefined_or(defined_or(zero, olc), 1, 1);      // line style
      origin_l = edefined_or(defined_or(zero, olc), 2, 1);      // length factor
      origin_a = edefined_or(defined_or(zero, olc), 3, 1);      // arrow style

      // x-origin
      for ( ix = [1,-1] )
        draft_line
        (
          l=ix*[[fdx/2-szm, 0], [fdx/2-szm*origin_l, 0]],
          w=origin_w, s=origin_s, a2=origin_a
        );

      // y-origin
      for ( iy = [1,-1] )
        draft_line
        (
          l=iy*[[0, fdy/2-szm], [0, fdy/2-szm*origin_l]],
          w=origin_w, s=origin_s, a2=origin_a
        );
    }
  }
}

//! .
/***************************************************************************//**
*******************************************************************************/
module draft_ruler
(
  marks = 10,       // unit division marks
  groups = 5,       // grouped marks
  linel = 5,        // grouped line unit-lengths
  label = 2/3,      // label scaler
  order = 1,        // marks direction
  scaler = true,    // scale ruler
  hide = false,     // hide label
  w = 1,            // mark line weight
  layers = draft_get_default("layers")
)
{

  if (exists(is_list(layers)?layers:[layers], draft_layers_show, true))
  {
    u  = length_unit_base;
    s  = length(linel, u) * (scaler?draft_scaler:1);

    ox = edefined_or(order, 0, order);
    oy = edefined_or(order, 1, ox);
    oo = [ox, oy];

    for ( i=[marks/2:groups*marks], j=[0, 1] )
    {
      p = length(i, u) * (scaler?draft_scaler:1) * oo[j];
      l = line2d_new
          (
            m  = ((i%marks) ? s/2 : s) * oo[(j==0)?1:0],
            p1 = (j == 0) ? [p, 0] : [0, p],
            v  = (j == 0) ? y_axis2d_uv : x_axis2d_uv
          );

      // draw tick
      draft_line (l=l, w=(i%marks) ? w/2 : w, s=1 );

      // label measurement
      if ((i == groups*marks) && !hide)
      {
        offset = length(1, u) * (scaler?draft_scaler:1);

        translate
        (
          (line_ip(l) + line_tp(l))/2 +
          (j == 0 ? [offset, 0] : [0, offset])
        )
        rotate( (j == 0) ? 0 : 90 )
        text
        (
          str( groups * marks * (scaler?draft_scaler:1), " ", u),
          valign="center", size=s*label
        );
      }
    }
  }
}

//! .
/***************************************************************************//**

  difference() {
  draft_sheet();
  translate( draft_sheet_get_zone(zp=[1,-1]) )
  draft_title_block(window=true);
  }

  translate( draft_sheet_get_zone(zp=[1,-1]) )
  union()
  {
    text =
    [
      ["data0.0", "data0.1"], "data1", "data2", "data3", "data4",
      "data5", "data6", "data7", "data8", "data9", "data10", "data11",
      ["data12.0", "data12.1", "data12.2", "data12.3"]
    ];

    draft_title_block
    (
      text = text,
      zones = true,
      hlines = true,
      vlines = true
    );
  }

*******************************************************************************/
module draft_title_block
(
  text,
  map = draft_title_block_map,
  zp = 0,
  number = false,
  window = false,
  layers = draft_get_default("layers")
)
{
  if (exists(is_list(layers)?layers:[layers], draft_layers_show, true))
  {
    translate( -draft_ztable_get_zone(zp=zp, map=map) )
    if (window)
    { // solid retangular window
      polygon(draft_ztable_get_zone(window=true, map=map));
    }
    else
    {
      // number: zones, hlines, and vlines
      num_zn = edefined_or(number, 0, number);
      num_hl = edefined_or(number, 1, num_zn);
      num_vl = edefined_or(number, 2, num_hl);

      // get title block configuration
      cmh    = map_get_value(map, "cmh") * draft_scaler;
      cmv    = map_get_value(map, "cmv") * draft_scaler;

      // coh = map_get_value(map, "coh");
      cov    = map_get_value(map, "cov");

      hldata = map_get_value(map, "hlines");
      vldata = map_get_value(map, "vlines");

      htdefs = map_get_value(map, "hdefs");
      etdefs = map_get_value(map, "edefs");
      zddata = map_get_value(map, "zones");

      lts    = cmv/6;
      tts    = cmv/6;

      // draw hlines
      for( i=[0:len(hldata)-1] )
      {
          ic = hldata[i][1][0];   // start hline
          tc = hldata[i][1][1];   // end hline
          lw = hldata[i][2];      // line weight
          ls = hldata[i][3];      // line style

          ip = draft_ztable_get_point( ix=ic, iy=i, map=map );
          tp = draft_ztable_get_point( ix=tc, iy=i, map=map );

          draft_line (l=[ip, tp], w=lw, s=ls );

          // number horizontal lines
          if ( num_hl )
          {
            translate(tp + [lts, lts/2, 0])
            text(str("H", i), size=lts);
          }
      }

      // draw vlines
      for( i=[0:len(vldata)-1] )
      {
          ic = vldata[i][1][0];   // start vline
          tc = vldata[i][1][1];   // end vline
          lw = vldata[i][2];      // line weight
          ls = vldata[i][3];      // line style

          ip = draft_ztable_get_point( ix=i, iy=ic, map=map );
          tp = draft_ztable_get_point( ix=i, iy=tc, map=map );

          draft_line (l=[ip, tp], w=lw, s=ls );

          // number vertical lines
          if ( num_vl )
          {
            translate(ip - [lts/2, -lts, 0]) rotate(90)
            text(str("V", i), size=lts);
          }
      }

      // add zone text
      for( i=[0:len(zddata)-1] )
      {
        hidden = zddata[i][2];

        if ( !zddata[i][2] )
        {
          // number zone
          if ( num_zn )
          {
            translate
            (
              draft_ztable_get_zone( i=i, zp=[1,1], map=map ) - [1/2, 1] * lts
            )
            text ( str( "Z", i ), valign="center", halign="right", size=lts );
          }

          // zone heading-text
          draft_ztable_text( i, zddata[i][3][0], tts, htdefs, zddata[i][3], map );

          // zone entry-text
          et  = (is_empty(text[i]) || not_defined(text[i])) ?
                zddata[i][4][0]
              : text[i];

          draft_ztable_text( i, et, tts, etdefs, zddata[i][4], map );
        } // not hidden
      } // zone text
    } // window
  } // layers
}

//! .
/***************************************************************************//**
*******************************************************************************/
module draft_table
(
  map,
  fmap,
  zp = 0,
  window = false,
  layers = draft_get_default("layers")
)
{
  if (exists(is_list(layers)?layers:[layers], draft_layers_show, true))
  {
    translate( -draft_table_get_cell(zp=zp, map=map, fmap=fmap) )
    if (window)
    { // solid retangular window
      polygon(draft_table_get_cell(window=true, map=map, fmap=fmap));
    }
    else
    {
      // get table format
      cmh = map_get_firstof2_or(map, fmap, "cmh", length(1/4,"in")) * draft_scaler;
      cmv = map_get_firstof2_or(map, fmap, "cmv", length(1/4,"in")) * draft_scaler;

      coh = map_get_firstof2_or(map, fmap, "coh", +1);
      cov = map_get_firstof2_or(map, fmap, "cov", -1);

      //
      // default lines when not in map nor fmap:
      //  no horizontal or vertical lines.
      //
      hlines  = map_get_firstof2_or(map, fmap, "hlines", consts(5,[0,0]));
      vlines  = map_get_firstof2_or(map, fmap, "vlines", consts(3,[0,0]));

      //
      // cell default text format when not in map nor fmap:
      //  'cll'=centered title,  left justified headings and entries
      //
      cll = [empty_str, [-1,-1], [2/5,-9/10], [0,-1-1/5], 0, 1, ["left", "center"]];

      tdefs = map_get_firstof2_or(map, fmap, "tdefs", cll);
      hdefs = map_get_firstof2_or(map, fmap, "hdefs", cll);
      edefs = map_get_firstof2_or(map, fmap, "edefs", cll);

      // get table data
      title = map_get_value(map, "title");
      heads = map_get_value(map, "heads");
      cols  = map_get_value(map, "cols");
      rows  = map_get_value(map, "rows");

      // draw hlines
      for( i=[0:len(rows)+2] )
      {
          ic = 0;                                 // from left
          tc = len(cols);                         // to right

          // get line configuration
          lc = (i == 0) ? hlines[0]               // top
             : (i == len(rows)+2) ? hlines[1]     // bottom
             : (i == 1) ? hlines[2]               // title
             : (i == 2) ? hlines[3]               // headings
             : hlines[4];                         // rows

          //
          // don't draw title or headings lines when they are
          // not defined. set line style to '0' no line.
          //
          lw = lc[0];
          ls = (not_defined(title)  && (i==1)) ? 0
             : (not_defined(heads)  && (i==2)) ? 0
             : lc[1];

          ip = draft_table_get_point( ix=ic, iy=i, map=map, fmap=fmap );
          tp = draft_table_get_point( ix=tc, iy=i, map=map, fmap=fmap );

          draft_line (l=[ip, tp], w=lw, s=ls );
      }

      // draw vlines
      for( i=[0:len(cols)] )
      {
          ic = (i==0||i==len(cols)) ? 0 : 1;      // left & right start at top
          tc = len(rows)+2;                       // to bottom of table

          // get line configuration
          lc = (i == 0) ? vlines[0]               // left
             : (i == len(cols)) ? vlines[1]       // right
             : vlines[2];                         // columns

          lw = lc[0];                             // line weight
          ls = lc[1];                             // line style

          ip = draft_table_get_point( ix=i, iy=ic, map=map, fmap=fmap );
          tp = draft_table_get_point( ix=i, iy=tc, map=map, fmap=fmap );

          draft_line (l=[ip, tp], w=lw, s=ls );
      }

      // add title text
      draft_table_text( 0, 0, title[0], cmh, tdefs, map, fmap );

      // add heading entries text
      for ( c = [0:len(cols)-1] )
        draft_table_text( c, 1, heads[0][c], cmh/2, hdefs, map, fmap );

      // add cell entries text
      for ( r = [2:len(rows)+1], c = [0:len(cols)-1] )
        draft_table_text( c, r, rows[r-2][0][c], cmh/2, edefs, map, fmap );

    } // window
  } // layers
}

//! .
/***************************************************************************//**
*******************************************************************************/
module draft_note
(
  head,
  note,
  size,
  line,
  cell,
  halign = "left",
  zp = 0,
  window = false,
  layers = draft_get_default("layers")
)
{
  if (exists(is_list(layers)?layers:[layers], draft_layers_show, true))
  {
    // cell minimum horizontal and vertical
    cmh = edefined_or(cell, 0, defined_or(cell, length(1/4, "in") ));
    cmv = edefined_or(cell, 1, cmh);

    // default line configuration
    lnd = defined_or(line, [1,1]);
    lnc = is_list(lnd[0]) ? [lnd[0], lnd[1]] : [lnd, lnd];

    // default heading text when size specified without text
    htd = is_defined(size[2]) && not_defined(head) ? empty_str : head;

    // local table map
    map =
    [
      ["cmh",     cmh],
      ["cmv",     cmv],

      not_defined(htd) ? empty_lst :
      ["heads",   [[htd], edefined_or(size, 2, 1)]],

      ["cols",    [edefined_or(size, 0, 10)]],
      ["rows",    [[[note], edefined_or(size, 1, 1)]]],

      ["hlines",  concat(consts(3,lnc[0]), consts(2,lnc[1]))],
      ["vlines",  consts(3,lnc[0])]
    ];

    // local table format map
    fmap  = (halign == "center") ? draft_table_format_ccc_map
          : (halign == "left")   ? draft_table_format_cll_map
          : (halign == "right")  ? draft_table_format_crr_map
          : undef;

    // layers handled locally, no need to pass
    draft_table(map=map, fmap=fmap, zp=zp, window=window);
  } // layers
}

//! @}
//! @}

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
