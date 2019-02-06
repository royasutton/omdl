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

    \amu_define group_name  (Tools)
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
module draft_in_layers
(
  layers = draft_get_default("layers-default")
)
{
  if (draft_layers_any_active(layers))
    children();
}

//! .
/***************************************************************************//**
    draft_sheet_get_zone()
    v = [ [ zp:[px=0, py=0], [rx/ix, ry/iy], child_idx ] ... ]

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

//! .
/***************************************************************************//**
*******************************************************************************/
module draft_sheet
(
  sheet,
  frame,
  zone,
  grid,
  origin,
  check = false,    // check configuration
  layers = draft_get_default("layers-sheet")
)
{
  if ( !table_exists( r=draft_sheet_config_tr, ri=draft_sheet_config ) )
    log_error( str("unknown sheet configuration [", draft_sheet_config, "]") );
  else if (draft_layers_any_active(layers))
  draft_make_3d_if_configured()
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

    // sheet, frame, zone, grid, and origin line configuration
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
    // origin tics
    //
    origin_w = edefined_or(defined_or(origin, olc), 0, defined_or(origin, olc));
    if ( origin_w )
    {
      origin_s = edefined_or(defined_or(origin, olc), 1, 1);    // line style
      origin_l = edefined_or(defined_or(origin, olc), 2, 1);    // length factor
      origin_a = edefined_or(defined_or(origin, olc), 3, 1);    // arrow style

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
  layers = draft_get_default("layers-sheet")
)
{

  if (draft_layers_any_active(layers))
  draft_make_3d_if_configured()
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
*******************************************************************************/
module draft_table
(
  map,
  fmap,
  zp = 0,
  window = false,
  layers = draft_get_default("layers-table")
)
{
  if (draft_layers_any_active(layers))
  draft_make_3d_if_configured()
  {
    translate( -draft_table_get_cell(zp=zp, map=map, fmap=fmap) )
    if (window)
    { // solid retangular window
      polygon(draft_table_get_cell(window=true, map=map, fmap=fmap));
    }
    else
    {
      //
      // get table format
      //
      cmh = map_get_firstof2_or(map, fmap, "cmh", draft_get_default("table-cmh")) * draft_scaler;
      cmv = map_get_firstof2_or(map, fmap, "cmv", draft_get_default("table-cmv")) * draft_scaler;

      coh = map_get_firstof2_or(map, fmap, "coh", draft_get_default("table-coh"));
      cov = map_get_firstof2_or(map, fmap, "cov", draft_get_default("table-cov"));

      //
      // default lines when not in map nor fmap:
      //  no horizontal or vertical lines.
      //
      hlines  = map_get_firstof2_or(map, fmap, "hlines", draft_get_default("table-hlines"));
      vlines  = map_get_firstof2_or(map, fmap, "vlines", draft_get_default("table-vlines"));

      //
      // cell default text format when not in map nor fmap:
      //
      tdefs = map_get_firstof2_or(map, fmap, "tdefs", draft_get_default("table-txt-fmt"));
      hdefs = map_get_firstof2_or(map, fmap, "hdefs", draft_get_default("table-txt-fmt"));
      edefs = map_get_firstof2_or(map, fmap, "edefs", draft_get_default("table-txt-fmt"));

      //
      // get table contents
      //
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
module draft_ztable
(
  text,
  map = draft_title_block_map,
  zp = 0,
  number = false,
  window = false,
  layers = draft_get_default("layers-table")
)
{
  if (draft_layers_any_active(layers))
  draft_make_3d_if_configured()
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
module draft_note
(
  head,
  note,
  size,
  line,
  halign = "left",
  cmh = draft_get_default("note-cmh"),
  cmv = draft_get_default("note-cmv"),
  zp = 0,
  window = false,
  layers = draft_get_default("layers-note")
)
{
  if (draft_layers_any_active(layers))
  // draft_make_3d_if_configured() handled by draft_table()
  {
    // default line configuration
    lnd = defined_or(line, [1, 1]);
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

      ["cols",    [edefined_or(size, 0, defined_or(size,1))]],
      ["rows",    [[[note], edefined_or(size, 1, 1)]]],

      ["hlines",  concat(consts(3,lnc[0]), consts(2,lnc[1]))],
      ["vlines",  consts(3,lnc[0])]
    ];

    // local table format map
    fmap  = (halign == "center") ? draft_table_format_ccc_map
          : (halign == "left")   ? draft_table_format_cll_map
          : (halign == "right")  ? draft_table_format_crr_map
          : undef;

    draft_table
    (
      map=map, fmap=fmap, zp=zp, window=window, layers=layers
    );
  } // layers
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
  layers = draft_get_default("layers-titleblock")
)
{
  draft_ztable
  (
    text=text, map=map, zp=zp, number=number, window=window, layers=layers
  );
}

//! .
/***************************************************************************//**
*******************************************************************************/
module draft_dim_leader
(
  p = origin2d,

  v1 = 30,
  l1 = 10,
  v2,
  l2,

  h,
  t,
  ts,
  tp,
  ta = "center",
  tr,

  bw = draft_get_default("dim-leader-box-weight"),
  bs = draft_get_default("dim-leader-box-style"),

  w = draft_get_default("dim-leader-weight"),
  s = draft_get_default("dim-leader-style"),
  a = draft_get_default("dim-leader-arrow"),

  o  = draft_get_default("dim-offset"),

  cmh = draft_get_default("dim-cmh"),
  cmv = draft_get_default("dim-cmv"),

  window = false,
  layers = draft_get_default("layers-dim")
)
{
  if (draft_layers_any_active(layers))
  draft_make_3d_if_configured()
  {
    // offset
    plo = not_defined(o) ? p
        : is_number(v1)  ? line_tp(line2d_new(m=o, a=v1, p1=p))
        :                  line_tp(line2d_new(m=o, v=v1, p1=p));

    // leader 1
    ll1 = is_number(v1)  ? line2d_new(m=l1, a=v1, p1=plo)
        :                  line2d_new(m=l1, v=v1, p1=plo);

    draft_line(l=ll1, w=w, s=s, a1=a);


    // leader 2
    dv2 = defined_or(v2, ll1);
    dl2 = defined_or(l2, l1);

    ll2 = is_number(v2)  ? line2d_new(m=dl2, a=dv2, p1=line_tp(ll1))
        :                  line2d_new(m=dl2, v=dv2, p1=line_tp(ll1));

    draft_line(l=ll2, w=w, s=s);

    // text rotation
    tra = not_defined(tr) ? angle_ll(x_axis2d_uv, ll2, false)
        : is_number(tr)   ? tr
        :                   angle_ll(x_axis2d_uv, tr, false);

    // text alignment point
    dtp = not_defined(tr) ? [-1, 0]
        : is_defined(tp)  ? tp
        : let( al2 = (angle_ll(x_axis2d_uv, ll2, false)+360-tra)%360 )
          (al2>  45 && al2< 135) ? [ 0, 1]
        : (al2>=135 && al2<=225) ? [ 1, 0]
        : (al2> 225 && al2< 315) ? [ 0,-1]
        :                          [-1, 0];

    translate( line_tp(ll2) )
    rotate( [0, 0, tra] )
    draft_note
    (
      head=h,
      note=t,
      size=ts,
      line=[bw, bs],
      halign=ta,
      cmh=cmh,
      cmv=cmv,
      zp=dtp,
      window=window,
      layers=layers
    );
  }
}

//! .
/***************************************************************************//**
*******************************************************************************/
module draft_dim_line
(
  p1,
  p2,

  v1,
  v2,

  t,
  u,

  d  = draft_get_default("dim-line-distance"),
  e  = draft_get_default("dim-line-extension-length"),
  es = draft_get_default("dim-line-extension-style"),

  w  = draft_get_default("dim-line-weight"),
  s  = draft_get_default("dim-line-style"),
  a  = draft_get_default("dim-line-arrow"),

  a1,
  a2,

  o  = draft_get_default("dim-offset"),

  ts = draft_get_default("dim-text-size"),
  tp = draft_get_default("dim-text-place"),
  rm = draft_get_default("dim-round-mode"),

  cmh = draft_get_default("dim-cmh"),
  cmv = draft_get_default("dim-cmv"),

  layers = draft_get_default("layers-dim")
)
{
  if (draft_layers_any_active(layers))
  draft_make_3d_if_configured()
  {
    // identify measurement reference points
    // only one of 'v1', 'v2' should normally be used at a time
    // create vector if numerical angle has been specified.
    mr1 = not_defined(v1) ? p1
        : let( va1 = is_number(v1) ? line2d_new(a=v1, p1=p1) : v1 )
          point_closest_pl(p2, va1);
    mr2 = not_defined(v2) ? p2
        : let( va2 = is_number(v2) ? line2d_new(a=v2, p1=p2) : v2 )
          point_closest_pl(p1, va2);

    // minimum distance from reference points to dimension line
    dm1 = edefined_or(d, 0, d);
    dm2 = edefined_or(d, 1, dm1);

    // extension line lengths (back towards reference points)
    de1 = edefined_or(e, 0, e);
    de2 = edefined_or(e, 1, de1);

    // extension lines angle
    // construct perpendicular to line form by reference points
    ape = angle_ll(x_axis2d_uv, [mr1, mr2]) + 90;

    // minimum distances to dimension line
    dmt = max(dm1, dm2);

    // extension line end points
    pe1 = line_tp(line2d_new(m=dmt, a=ape, p1=mr1));
    pe2 = line_tp(line2d_new(m=dmt, a=ape, p1=mr2));

    // dimension line offset at extension line end-points
    pd1 = line_tp(line2d_new(m=-o, a=ape, p1=pe1));
    pd2 = line_tp(line2d_new(m=-o, a=ape, p1=pe2));

    //
    // draft
    //

    // extension lines
    draft_line(l=line2d_new(m=-de1, a=ape, p1=pe1), w=w/2, s=es);
    draft_line(l=line2d_new(m=-de2, a=ape, p1=pe2), w=w/2, s=es);

    // dimension text
    dt = is_defined(t) ? t
       : let
         (
           // measure distance between reference points
           md = distance_pp(mr1, mr2),

           // use specified units 'u'
           du = not_defined(u) ? md
              : length(md, from=length_unit_base, to=u),

           // rounding: [mode:0, digits]
           rs = edefined_or(rm, 0, 0),

           rd = rs == 1 ? dround(du, edefined_or(rm, 1, 2))
              : rs == 2 ? sround(du, edefined_or(rm, 1, 3))
              : du
         )
         // add units id when 'u' is specified
         not_defined(u) ? str(rd) : str(rd, " ", u);

    // individual or common arrowheads
    da1 = defined_or(a1, a);
    da2 = defined_or(a2, a);

    // when text placed over line
    if ( second(tp) == 0 && !is_empty(dt) )
    difference()
    {
      // remove window from dimension line for text
      draft_line(l=[pd1, pd2], w=w, s=s, a1=da1, a2=da2);

      translate( (pd1+pd2)/2 )
      rotate( [0, 0, ape-90] )
      draft_note
      (
        note=dt,
        size=ts,
        line=[0,0],
        halign="center",
        cmh=cmh,
        cmv=cmv,
        zp=tp,
        window=true,
        layers=layers
      );
    }
    else
    {
      draft_line(l=[pd1, pd2], w=w, s=s, a1=da1, a2=da2);
    }

    if ( !is_empty(dt)  )
    translate( (pd1+pd2)/2 )
    rotate( [0, 0, ape-90] )
    draft_note
    (
      note=dt,
      size=ts,
      line=[0,0],
      halign="center",
      cmh=cmh,
      cmv=cmv,
      zp=tp,
      window=false,
      layers=layers
    );
  }
}

//! .
/***************************************************************************//**
*******************************************************************************/
module draft_dim_radius
(
  c,
  p,

  r,
  v,

  t,
  u,

  d  = false,

  w  = draft_get_default("dim-radius-weight"),
  s  = draft_get_default("dim-radius-style"),
  a  = draft_get_default("dim-radius-arrow"),

  a1,
  a2,

  o  = draft_get_default("dim-offset"),

  ts = draft_get_default("dim-text-size"),
  tp = draft_get_default("dim-text-place"),
  rm = draft_get_default("dim-round-mode"),

  cmh = draft_get_default("dim-cmh"),
  cmv = draft_get_default("dim-cmv"),

  layers = draft_get_default("layers-dim")
)
{
  if (draft_layers_any_active(layers))
  draft_make_3d_if_configured()
  {
    // identify radius reference points
    // create vector if numerical angle has been specified.
    rr1 = c;
    rr2 = is_defined(p)  ? p
        : not_defined(r) ? line_tp(line2d_new(p1=c))
        : not_defined(v) ? line_tp(line2d_new(m=r, p1=c))
        : is_number(v)   ? line_tp(line2d_new(m=r, a=v, p1=c))
        :                  line_tp(line2d_new(m=r, v=v, p1=c));

    // identify measurement reference points
    mr1 = d ? line_tp(line2d_new(m=distance_pp(rr1, rr2), v=[rr2, rr1], p1=rr1))
        : rr1;
    mr2 = rr2;

    // minimum distance from reference points to dimension line
    do1 = edefined_or(o, 0, o);
    do2 = edefined_or(o, 1, d ? do1 : 0);

    // dimension lines angle
    ape = angle_ll(x_axis2d_uv, [mr1, mr2]);

    // dimension line offset at end-points
    pd1 = (do1 == 0) ? mr1
        : line_tp( line2d_new(m=distance_pp(mr1, mr2)-do1, v=[mr2, mr1], p1=mr2) );
    pd2 = (do2 == 0) ? mr2
        : line_tp( line2d_new(m=distance_pp(mr1, mr2)-do2, v=[mr1, mr2], p1=mr1) );

    //
    // draft
    //

    // dimension text
    dt = is_defined(t) ? t
       : let
         (
           // measure distance between reference points
           md = distance_pp(mr1, mr2),

           // use specified units 'u'
           du = not_defined(u) ? md
              : length(md, from=length_unit_base, to=u),

           // rounding: [mode:0, digits]
           rs = edefined_or(rm, 0, 0),

           rd = rs == 1 ? dround(du, edefined_or(rm, 1, 2))
              : rs == 2 ? sround(du, edefined_or(rm, 1, 3))
              : du,

           rt = d ? "D" : "R"
         )
         // add units id when 'u' is specified
         not_defined(u) ? str(rt, " ", rd) : str(rt, " ", rd, " ", u);

    // individual or common arrowheads
    da1 = defined_or(a1, d ? a : 0);
    da2 = defined_or(a2, a);

    // when text placed over line
    if ( second(tp) == 0 && !is_empty(dt) )
    difference()
    {
      // remove window from dimension line for text
      draft_line(l=[pd1, pd2], w=w, s=s, a1=da1, a2=da2);

      translate( (pd1+pd2)/2 )
      rotate( [0, 0, ape] )
      draft_note
      (
        note=dt,
        size=ts,
        line=[0,0],
        halign="center",
        cmh=cmh,
        cmv=cmv,
        zp=tp,
        window=true,
        layers=layers
      );
    }
    else
    {
      draft_line(l=[pd1, pd2], w=w, s=s, a1=da1, a2=da2);
    }

    if ( !is_empty(dt)  )
    translate( (pd1+pd2)/2 )
    rotate( [0, 0, ape] )
    draft_note
    (
      note=dt,
      size=ts,
      line=[0,0],
      halign="center",
      cmh=cmh,
      cmv=cmv,
      zp=tp,
      window=false,
      layers=layers
    );
  }
}

//! .
/***************************************************************************//**
*******************************************************************************/
module draft_dim_angle
(
  c,
  r,

  v1,
  v2,

  fn,
  cw = false,

  t,
  u,

  e  = draft_get_default("dim-angle-extension-ratio"),
  es = draft_get_default("dim-angle-extension-style"),

  w  = draft_get_default("dim-angle-weight"),
  s  = draft_get_default("dim-angle-style"),
  a  = draft_get_default("dim-angle-arrow"),

  a1,
  a2,

  o  = draft_get_default("dim-offset"),

  ts = draft_get_default("dim-text-size"),
  tp = draft_get_default("dim-text-place"),
  rm = draft_get_default("dim-round-mode"),

  cmh = draft_get_default("dim-cmh"),
  cmv = draft_get_default("dim-cmv"),

  layers = draft_get_default("layers-dim")
)
{
  if (draft_layers_any_active(layers))
  draft_make_3d_if_configured()
  {
    // identify measurement reference points at center 'c'
    // handle (1) point, (2) angle, or (3) vector.
    mr1 = is_point(v1)  ? v1
        : is_number(v1) ? line_tp(line2d_new(a=v1, p1=c))
        :                 line_tp(line2d_new(v=v1, p1=c));
    mr2 = is_point(v2)  ? v2
        : is_number(v2) ? line_tp(line2d_new(a=v2, p1=c))
        :                 line_tp(line2d_new(v=v2, p1=c));

    // extension line to radius ratio
    er1 = edefined_or(e, 0, e);
    er2 = edefined_or(e, 1, er1);

    // extension line end points
    pe1 = line_tp(line2d_new(m=r, v=[c, mr1], p1=c));
    pe2 = line_tp(line2d_new(m=r, v=[c, mr2], p1=c));

    // dimension text angle and position
    dta = angle_ll(x_axis2d_uv, cw ? [mr1, mr2] : [mr2, mr1], false)
        + defined_or(third(tp), 0);
    dtp = line_tp(line2d_new(m=r-o, a=dta+90, p1=c));

    //
    // draft
    //

    // extension lines (back towards center point)
    draft_line(l=line2d_new(m=r*er1, v=[mr1, c], p1=pe1), w=w/2, s=es);
    draft_line(l=line2d_new(m=r*er2, v=[mr2, c], p1=pe2), w=w/2, s=es);

    // dimension text
    dt = is_defined(t) ? t
       : let
         (
           // measure angle between reference points
           ma = cw ?
                angle_ll([c, mr2], [c, mr1], false)
              : angle_ll([c, mr1], [c, mr2], false),

           // use specified units 'u'
           au = not_defined(u) ? ma
              : angle(ma, from=angle_unit_base, to=u),

           // rounding: [mode:0, digits]
           rs = edefined_or(rm, 0, 0),

           rd = rs == 1 ? dround(au, edefined_or(rm, 1, 2))
              : rs == 2 ? sround(au, edefined_or(rm, 1, 3))
              : au
         )
         // add units id when 'u' is specified
         not_defined(u) ? str(rd) : str(rd, " ", u);

    // individual or common arrowheads
    da1 = defined_or(a1, a);
    da2 = defined_or(a2, a);

    // when text placed over line
    if ( second(tp) == 0 && !is_empty(dt) )
    difference()
    {
      // remove window from dimension line for text
      draft_arc(r=r-o, c=c, v1=[c, pe1], v2=[c, pe2], fn=fn, cw=cw, w=w, s=s, a1=da1, a2=da2);

      translate( dtp )
      rotate( [0, 0, dta + defined_or(tp[3], 0)] )
      draft_note
      (
        note=dt,
        size=ts,
        line=[0,0],
        halign="center",
        cmh=cmh,
        cmv=cmv,
        zp=tp,
        window=true,
        layers=layers
      );
    }
    else
    {
      draft_arc(r=r-o, c=c, v1=[c, pe1], v2=[c, pe2], fn=fn, cw=cw, w=w, s=s, a1=da1, a2=da2);
    }

    if ( !is_empty(dt)  )
    translate( dtp )
    rotate( [0, 0, dta + defined_or(tp[3], 0)] )
    draft_note
    (
      note=dt,
      size=ts,
      line=[0,0],
      halign="center",
      cmh=cmh,
      cmv=cmv,
      zp=tp,
      window=false,
      layers=layers
    );
  }
}

//! @}
//! @}

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
