//! Drafting base functions and primitives.
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

    \amu_define group_name  (Primitives)
    \amu_define group_brief (Drafting base functions and primitives.)

  \amu_include (include/amu/pgid_path_pstem_g.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group and macros.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)

  \amu_include (include/amu/scope_diagram_2d_object.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//! \name Layers
//! @{

//! Check if any identified layers are active.
/***************************************************************************//**
  \param    layers <string-list> The list of layer names.

  \returns  <boolean> \b true if any identified layer is active as
            indicated by \ref draft_layers_show.
*******************************************************************************/
function draft_layers_any_active
(
  layers = draft_get_config("layers-default")
) = exists( is_list(layers) ? layers : [layers], draft_layers_show, true );

//! @}

//----------------------------------------------------------------------------//

//! \name Placement
//! @{

//! \cond DOXYGEN_SHOULD_SKIP_THIS

//! Get sheet, sheet-frame, or sheet-zone reference window or limits.
/***************************************************************************//**
  \param    rx <string> A sheet x-axis zone reference identifier.
  \param    ry <string> A sheet y-axis zone reference identifier.

  \param    ix <integer> A sheet x-axis zone reference index.
  \param    iy <integer> A sheet x-axis zone reference index.

  \param    limits <boolean> Return window limits rather than coordinates.
  \param    frame <boolean> Use frame when zone not specified.

  \returns  <datastruct> The reference window.

  \details

    The returned datastruct will be one of the following forms:

     limits | description                     | data type
    :------:|:--------------------------------|:------------------------
     true   | [[xmin, xmax], [ymin, ymax]]    | <decimal-list-2-list-2>
     false  | [p0, p1, p2, p3], pn=[x,y]      | <point-2d-list-4>

    The windows coordinate points [p0, p1, p2, p3] are clockwise
    ordered with p0=[xmin, ymin].

  \private
*******************************************************************************/
function draft_sheet_get_window
(
  rx,
  ry,
  ix,
  iy,
  limits = false,
  frame = false
) =
  let
  (
    //
    // get configuration values (scale all lengths)
    //

    // sheet size
    sdx = draft_get_sheet_size(ci="sdx") * draft_sheet_scale,
    sdy = draft_get_sheet_size(ci="sdy") * draft_sheet_scale,

    // sheet layout
    sll = draft_get_sheet_config(ci="sll"),

    // sheet frame and zone margins
    smx = draft_get_sheet_config(ci="smx") * draft_sheet_scale,
    smy = draft_get_sheet_config(ci="smy") * draft_sheet_scale,
    szm = draft_get_sheet_config(ci="szm") * draft_sheet_scale,

    // reference zone labels
    zox = draft_get_sheet_config(ci="zox"),
    zoy = draft_get_sheet_config(ci="zoy"),
    zlx = draft_get_sheet_config(ci="zlx"),
    zly = draft_get_sheet_config(ci="zly"),

    // sheet layout dimensions
    ldx = sll ? sdy : sdx,
    ldy = sll ? sdx : sdy,

    // sheet frame dimensions
    fdx = ldx - smx,
    fdy = ldy - smy,

    // working dimensions excluding reference zone
    wdx = fdx - szm * 2,
    wdy = fdy - szm * 2,

    // zone start coordinates
    zxs = is_defined(ix) ?
          let
          ( // reference ordering
            iox = (zox > 0) ? ix : len(zlx)-1-ix
          )
          iox * fdx/len(zlx) -fdx/2
        : is_defined(rx) ?
          let
          ( // assign '-1', outside of frame, if not found
            zxi = defined_or(first(find(rx, zlx)), -1),
            iox = (zox > 0) ? zxi : len(zlx)-1-zxi
          )
          iox * fdx/len(zlx) -fdx/2
        : 0,
    zys = is_defined(iy) ?
          let
          ( // reference ordering
            ioy = (zoy > 0) ? iy : len(zly)-1-iy
          )
          ioy * fdy/len(zly) -fdy/2
        : is_defined(ry) ?
          let
          ( // assign '-1', outside of frame, if not found
            zyi = defined_or(first(find(ry, zly)), -1),
            ioy = (zoy > 0) ? zyi : len(zly)-1-zyi
          )
          ioy * fdy/len(zly) - fdy/2
        : 0,

    // reference window coordinates
    wx  = is_defined(ix) || is_defined(rx) ?
          [zxs, zxs + fdx/len(zlx)]
        : frame ?
          [-fdx/2, fdx/2]
        : [-wdx/2, wdx/2],
    wy  = is_defined(iy) || is_defined(ry) ?
          [zys, zys + fdy/len(zly)]
        : frame ?
          [-fdy/2, fdy/2]
        : [-wdy/2, wdy/2]
  )
    limits ?
    // limits: [[xmin, xmax], [ymin, ymax]
    [wx, wy]
    // window points in cw order from [xmin, ymin]
  : [[wx[0],wy[0]], [wx[0],wy[1]], [wx[1],wy[1]], [wx[1],wy[0]]];

//! \endcond

//! Get sheet, sheet-frame, or sheet-zone reference coordinates.
/***************************************************************************//**
  \param    rx <string-list | string> Sheet x-axis zone reference identifier(s).
  \param    ry <string-list | string> Sheet y-axis zone reference identifier(s).

  \param    ix <integer-list | integer> Sheet x-axis zone reference index(es).
  \param    iy <integer-list | integer> Sheet x-axis zone reference index(es).

  \param    zp <integer-list-2 | integer> The window coordinate scaler. A
            list [zpx, zpy] of decimals or a single decimal for (zpx=zpy).

  \param    window <boolean> Return window rather than point.
  \param    frame <boolean> Use frame when zone not specified.

  \returns  <datastruct> The reference coordinates.

  \details

    The returned datastruct will be one of the following forms:

     window | description                     | data type
    :------:|:--------------------------------|:------------------------
     true   | [p0, p1, p2, p3], pn=[x,y]      | <point-2d-list-4>
     false  | [x, y]                          | <point-2d>

    The parameter \p zp is used to linearly scale the window
    coordinate. For both axes, \b -1 = left/bottom, \b 0 =
    center/middle, and \b +1 = right/top. The windows coordinate points
    [p0, p1, p2, p3] are clockwise ordered with p0=[xmin, ymin].
*******************************************************************************/
function draft_sheet_get_zone
(
  rx,
  ry,
  ix,
  iy,
  zp = 0,
  window = false,
  frame = false
) =
  let
  (
    // get reference window xy-limits
    wl  = !is_list(rx) && !is_list(ix) && !is_list(ry) && !is_list(iy) ?
          // no reference lists, just get single zone window
          draft_sheet_get_window( rx=rx, ry=ry, ix=ix, iy=iy, frame=frame, limits=true )
        : let
          (
            // determine x-limits
            wx  = is_list(ix) ?
                  let
                  (
                    w1 = draft_sheet_get_window( ix=first(ix), frame=frame, limits=true ),
                    w2 = draft_sheet_get_window( ix=last(ix),  frame=frame, limits=true )
                  )
                  [min(w1[0][0], w2[0][0]), max(w1[0][1], w2[0][1])]
                : is_list(rx) ?
                  let
                  (
                    w1 = draft_sheet_get_window( rx=first(rx), frame=frame, limits=true ),
                    w2 = draft_sheet_get_window( rx=last(rx),  frame=frame, limits=true )
                  )
                  [min(w1[0][0], w2[0][0]), max(w1[0][1], w2[0][1])]
                : let
                  (
                    w1 = draft_sheet_get_window( rx=rx, ix=ix, frame=frame, limits=true )
                  )
                  w1[0],

            // determine y-limits
            wy  = is_list(iy) ?
                  let
                  (
                    w1 = draft_sheet_get_window( iy=first(iy), frame=frame, limits=true ),
                    w2 = draft_sheet_get_window( iy=last(iy),  frame=frame, limits=true )
                  )
                  [min(w1[1][0], w2[1][0]), max(w1[1][1], w2[1][1])]
                : is_list(ry) ?
                  let
                  (
                    w1 = draft_sheet_get_window( ry=first(ry), frame=frame, limits=true ),
                    w2 = draft_sheet_get_window( ry=last(ry),  frame=frame, limits=true )
                  )
                  [min(w1[1][0], w2[1][0]), max(w1[1][1], w2[1][1])]
                : let
                  (
                    w1 = draft_sheet_get_window( ry=ry, iy=iy, frame=frame, limits=true )
                  )
                  w1[1]
          )
          // xy-limits
          [wx, wy]
  )
    window ?
    // window points in cw order from [xmin, ymin]
    [
      [wl[0][0], wl[1][0]],
      [wl[0][0], wl[1][1]],
      [wl[0][1], wl[1][1]],
      [wl[0][1], wl[1][0]]
    ]
  : let
    (
      // linearly scale window by px, py
      // [-1]=left/bottom, [0]=center/middle, [+1]=right/top]
      px = defined_e_or(zp, 0, zp),
      py = defined_e_or(zp, 1, px),

      cx = ( px * (wl[0][1]-wl[0][0]) + (wl[0][0]+wl[0][1]) )/2,
      cy = ( py * (wl[1][1]-wl[1][0]) + (wl[1][0]+wl[1][1]) )/2
    )
    // point
    [cx, cy];

//! @}

//----------------------------------------------------------------------------//

//! \name Tables
//! @{

//! Get a coordinate point for a defined draft table column and row.
/***************************************************************************//**
  \param    ix <integer> A table column vertical line index.
  \param    iy <integer> A table row horizontal line index.

  \param    map <map> A table definition map.
  \param    fmap <map> A table format map.

  \returns  <point-2d> The table column and row intersection coordinate
            point.

  \private
*******************************************************************************/
function draft_table_get_point
(
  ix,
  iy,
  map,
  fmap
) =
  let
  (
    // get table format
    cmh = map_get_firstof2_or(map, fmap, "cmh", draft_get_config("table-cmh")) * $draft_scale,
    cmv = map_get_firstof2_or(map, fmap, "cmv", draft_get_config("table-cmv")) * $draft_scale,

    coh = map_get_firstof2_or(map, fmap, "coh", draft_get_config("table-coh")),
    cov = map_get_firstof2_or(map, fmap, "cov", draft_get_config("table-cov")),

    // get table data
    title = map_get_value(map, "title"),
    heads = map_get_value(map, "heads"),
    cols  = map_get_value(map, "cols"),
    rows  = map_get_value(map, "rows"),

    // vertical line index
    xu  = is_undef(ix) ? 0                  // not specified
        : (ix <= 0) ? 0                     // left
        : sum([for( i=[1:ix] ) cols[i-1]]), // sum column units widths

    yt  = defined_e_or(title, 1, 0),        // title: '0' unit default height
    yh  = defined_e_or(heads, 1, 0),        // heads: '0' unit default height

    // horizontal line index
    yu  = is_undef(iy) ? 0                  // not specified
        : (iy <= 0) ? 0                     // top
        : (iy == 1) ? yt                    // title
        : (iy == 2) ? sum( [yt, yh] )       // title + heads
        : sum
          (
            [
              yt, yh,                       // rows: '1' unit default height
              for( i=[3:iy] ) defined_e_or(rows[i-3], 1, 1)
            ]
          )
  )
  [xu*cmh*coh, yu*cmv*cov];                 // units * unit-size * order

//! Get table cell coordinates given a column and row.
/***************************************************************************//**
  \param    ix <integer> A table column vertical line index.
  \param    iy <integer> A table row horizontal line index.

  \param    zp <integer-list-2 | integer> The cell coordinate scaler. A
            list [zpx, zpy] of decimals or a single decimal for (zpx=zpy).

  \param    limits <boolean> Return cell limits rather than coordinates.
  \param    window <boolean> Return cell window rather than point.

  \param    map <map> A table definition map.
  \param    fmap <map> A table format map.

  \returns  <datastruct> The table cell coordinates.

  \details

    The returned datastruct will be one of the following forms:

     limits | window | description                     | data type
    :------:|:------:|:--------------------------------|:------------------------
     true   | -      | [[xmin, xmax], [ymin, ymax]]    | <decimal-list-2-list-2>
     false  | true   | [p0, p1, p2, p3], pn=[x,y]      | <point-2d-list-4>
     false  | false  | [x, y]                          | <point-2d>

    The parameter \p zp is used to linearly scale the window
    coordinate. For both axes, \b -1 = left/bottom, \b 0 =
    center/middle, and \b +1 = right/top. The windows coordinate points
    [p0, p1, p2, p3] are clockwise ordered with p0=[xmin, ymin].
*******************************************************************************/
function draft_table_get_cell
(
  ix,
  iy,
  zp = 0,
  limits = false,
  window = false,
  map,
  fmap
) =
  let
  (
    // get table data
    cols = map_get_value(map, "cols"),
    rows = map_get_value(map, "rows"),

    // vertical lines
    lv  = is_undef(ix) ?    [0, len(cols)]      // table width
        : (iy <= 0) ?       [0, len(cols)]      // title cell
        :                   [ix, ix+1],         // heading or row

    // horizontal lines
    lh  = is_undef(iy) ?    [0, len(rows)+2]    // table height
        :                   [iy, iy+1],         // any row

    // get cell window xy-limits [min, max]
    wl =
    [
      [ for( i=[0, 1] ) draft_table_get_point( ix=lv[i], map=map, fmap=fmap )[0] ],
      [ for( i=[0, 1] ) draft_table_get_point( iy=lh[i], map=map, fmap=fmap )[1] ]
    ]
  )
    limits ?
    // limits: [[xmin, xmax], [ymin, ymax]
    wl
  : window ?
    // window points in cw order from [xmin, ymin]
    [
      [wl[0][0], wl[1][0]],
      [wl[0][0], wl[1][1]],
      [wl[0][1], wl[1][1]],
      [wl[0][1], wl[1][0]]
    ]
  : let
    (
      // linearly scale window by px, py
      // [-1]=left/bottom, [0]=center/middle, [+1]=right/top]
      px = defined_e_or(zp, 0, zp),
      py = defined_e_or(zp, 1, px),

      cx = ( px * (wl[0][1]-wl[0][0]) + (wl[0][0]+wl[0][1]) )/2,
      cy = ( py * (wl[1][1]-wl[1][0]) + (wl[1][0]+wl[1][1]) )/2
    )
    // point
    [cx, cy];

//! Add text to table cell at a given a column and row.
/***************************************************************************//**
  \param    ix <integer> A table column vertical line index.
  \param    iy <integer> A table row horizontal line index.

  \param    text <string | string-list> The text to add. A single string
            or a list of strings for multiple line text.
  \param    size <decimal> The text size.

  \param    dfmt <datastruct> The default text format.

  \param    map <map> A table definition map.
  \param    fmap <map> A table format map.

  \details

    The parameter \p dfmt of type <datastruct> is a list of eleven
    values:

    \verbatim
    <datastruct> =
    [
      0:text, 1:<align-point>, 2:<align-offset>, 3:<multi-line-offset>,
      4:rotate, 5:text-scale, 6:<text-align>, 7:font,
      8:spacing, 9:direction, 10:language, 11:script
    ]
    \endverbatim

     field  | description           | data type
    :------:|-----------------------|:--------------------------
      0     | text                  | <string>
      1     | [h-align, v-align]    | <decimal-list-2>
      2     | [h-offset, v-offset]  | <decimal-list-2>
      3     | [h-offset, v-offset]  | <decimal-list-2>
      4     | rotate                | <decimal>
      5     | text-scale            | <decimal>
      6     | [h-align, v-align]    | <string-list-2>
      7     | font                  | <string>
      8     | spacing               | <decimal>
      9     | direction             | <string>
      10    | language              | <string>
      11    | script                | <string>

    \b Example
    \code{.C}
    dfmt = [empty_str, [-1,-1], [2/5,-9/10], [0,-1-1/5], 0, 1, ["left", "center"]]];
    \endcode

    Unassigned fields are initialized with defaults.
*******************************************************************************/
module draft_table_text
(
  ix,
  iy,
  text,
  size,
  dfmt,
  map,
  fmap
)
{ // element-wise default assignment
  function erdefined_or (v, r, d) = [for (i = r) defined_or( v[i], d[i] )];

  /*
   handled-input-cases          tv(text)      sf(text)
   (1)   "t1"                   ["t1"]        [ "t1" ]
   (2) [ "t1" ]                 ["t1"]        [ "t1" ]
   (3) [ "t1", "t2" ]           ["t1", "t2"]  [ ["t1", "t2"] ]
   (4) [ ["t1", "t2"] ]         ["t1", "t2"]  [ ["t1", "t2"] ]
   (5) [ ["t1", "t2"], [0,0] ]  ["t1", "t2"]  [ ["t1", "t2"], [0,0] ]
   (6) [ "t1", [0,0] ]          ["t1"]        [ "t1", [0,0] ]
  */

  // text format
  sf = is_string(text)   ? [text]       // (1)
     : all_strings(text) ? [text]       // (2), (3)
     : text;                            // (4), (5), (6)

  // text list
  tv = is_string(text)   ? [text]       // (1)
     : all_strings(text) ? text         // (2), (3)
     : is_list(text[0])  ? text[0]      // (4), (5)
     : [text[0]];                       // (6)

  // assign defaults where needed
  df = erdefined_or( sf, [0:11], dfmt );

  for ( l=[0:len(tv)-1] )
  translate
  (
    // cell coordinates
    draft_table_get_cell( ix=ix, iy=iy, zp=df[1], map=map, fmap=fmap )
    // configured offset
    + [ df[2][0], df[2][1] ] * size * df[5]
    // multi-line offset
    + df[3] * size * df[5] * l
  )
  rotate( df[4] )
  text
  (
         text=tv[l],
         size=df[5]*size,
       halign=df[6][0],
       valign=df[6][1],
         font=df[7],
      spacing=df[8],
    direction=df[9],
     language=df[10],
       script=df[11]
  );
}

//! Get a coordinate point for a defined draft zoned-table column and row.
/***************************************************************************//**
  \param    ix <integer> A ztable column vertical line index.
  \param    iy <integer> A ztable row horizontal line index.

  \param    map <map> A ztable definition map.

  \returns  <point-2d> The ztable column and row intersection coordinate
            point.

  \private
*******************************************************************************/
function draft_ztable_get_point
(
  ix,
  iy,
  map
) =
  let
  (
    // get table configuration
    cmh    = map_get_value(map, "cmh") * $draft_scale,
    cmv    = map_get_value(map, "cmv") * $draft_scale,

    coh    = map_get_value(map, "coh"),
    cov    = map_get_value(map, "cov"),

    vlines = map_get_value(map, "vlines"),
    hlines = map_get_value(map, "hlines"),

    x = is_undef(ix) ? 0 : sum([for( i=[0:ix] ) vlines[i][0]]) * cmh * coh,
    y = is_undef(iy) ? 0 : sum([for( i=[0:iy] ) hlines[i][0]]) * cmv * cov
  )
  [x, y];

//! Get ztable zone coordinates given a zone index.
/***************************************************************************//**
  \param    i <integer> A ztable zone index.

  \param    zp <integer-list-2 | integer> The zone coordinate scaler. A
            list [zpx, zpy] of decimals or a single decimal for (zpx=zpy).

  \param    limits <boolean> Return zone limits rather than coordinates.
  \param    window <boolean> Return zone window rather than point.

  \param    map <map> A ztable definition map.

  \returns  <datastruct> The ztable cell coordinates.

  \details

    The returned datastruct will be one of the following forms:

     limits | window | description                     | data type
    :------:|:------:|:--------------------------------|:------------------------
     true   | -      | [[xmin, xmax], [ymin, ymax]]    | <decimal-list-2-list-2>
     false  | true   | [p0, p1, p2, p3], pn=[x,y]      | <point-2d-list-4>
     false  | false  | [x, y]                          | <point-2d>

    The parameter \p zp is used to linearly scale the window
    coordinate. For both axes, \b -1 = left/bottom, \b 0 =
    center/middle, and \b +1 = right/top. The windows coordinate points
    [p0, p1, p2, p3] are clockwise ordered with p0=[xmin, ymin].
*******************************************************************************/
function draft_ztable_get_zone
(
  i,
  zp = 0,
  limits = false,
  window = false,
  map
) =
  let
  (
    // get table configuration
    zones  = map_get_value(map, "zones"),

                        // [min vline, max vline]
    zx  = is_undef(i) ? [0, len(map_get_value(map, "vlines"))-1] : zones[i][0],

                        // [min hline, max hline]
    zy  = is_undef(i) ? [0, len(map_get_value(map, "hlines"))-1] : zones[i][1],

    // get zone window xy-limits [min, max]
    wl =
    [
      [ for( i=[1, 0] ) draft_ztable_get_point( ix=zx[i], map=map )[0] ],
      [ for( i=[0, 1] ) draft_ztable_get_point( iy=zy[i], map=map )[1] ]
    ]
  )
    limits ?
    // limits: [[xmin, xmax], [ymin, ymax]
    wl
  : window ?
    // window points in cw order from [xmin, ymin]
    [
      [wl[0][0], wl[1][0]],
      [wl[0][0], wl[1][1]],
      [wl[0][1], wl[1][1]],
      [wl[0][1], wl[1][0]]
    ]
  : let
    (
      // linearly scale window by px, py
      // [-1]=left/bottom, [0]=center/middle, [+1]=right/top]
      px = defined_e_or(zp, 0, zp),
      py = defined_e_or(zp, 1, px),

      cx = ( px * (wl[0][1]-wl[0][0]) + (wl[0][0]+wl[0][1]) )/2,
      cy = ( py * (wl[1][1]-wl[1][0]) + (wl[1][0]+wl[1][1]) )/2
    )
    // point
    [cx, cy];

//! Add text to ztable at a given zone index.
/***************************************************************************//**
  \param    i <integer> A ztable zone index.

  \param    text <string | string-list> The text to add. A single string
            or a list of strings for multiple line text.
  \param    size <decimal> The text size.

  \param    fmt <datastruct> The text format.
  \param    dfmt <datastruct> The default text format.

  \param    map <map> A ztable definition map.

  \details

    The parameters \p fmt and \p dfmt of type <datastruct> is a list of
    eleven values:

    \verbatim
    <datastruct> =
    [
      0:text, 1:<align-point>, 2:<align-offset>, 3:<multi-line-offset>,
      4:rotate, 5:text-scale, 6:<text-align>, 7:font,
      8:spacing, 9:direction, 10:language, 11:script
    ]
    \endverbatim

     field  | description           | data type
    :------:|-----------------------|:--------------------------
      0     | text                  | <string>
      1     | [h-align, v-align]    | <decimal-list-2>
      2     | [h-offset, v-offset]  | <decimal-list-2>
      3     | [h-offset, v-offset]  | <decimal-list-2>
      4     | rotate                | <decimal>
      5     | text-scale            | <decimal>
      6     | [h-align, v-align]    | <string-list-2>
      7     | font                  | <string>
      8     | spacing               | <decimal>
      9     | direction             | <string>
      10    | language              | <string>
      11    | script                | <string>

    \b Example
    \code{.C}
    dfmt = [empty_str, [-1,-1], [2/5,-9/10], [0,-1-1/5], 0, 1, ["left", "center"]]];
    \endcode

    Unassigned fields are initialized with defaults.
*******************************************************************************/
module draft_ztable_text
(
  i,
  text,
  size,
  fmt,
  dfmt,
  map
)
{ // element-wise default assignment
  function erdefined_or (v, r, d) = [for (i = r) defined_or( v[i], d[i] )];

  // multi- or single-line
  tv = is_list(text) ? text : [text];

  // assign defaults where needed
  df = erdefined_or( fmt, [0:11], dfmt );

  for ( l=[0:len(tv)-1] )
  translate
  (
    // zone coordinates
    draft_ztable_get_zone( i=i, zp=df[1], map=map )
    // configured offset
    + [ df[2][0], df[2][1] ] * size * df[5]
    // multi-line offset
    + df[3] * size * df[5] * l
  )
  rotate( df[4] )
  text
  (
         text=tv[l],
         size=df[5]*size,
       halign=df[6][0],
       valign=df[6][1],
         font=df[7],
      spacing=df[8],
    direction=df[9],
     language=df[10],
       script=df[11]
  );
}

//! @}

//----------------------------------------------------------------------------//

//! \name Shapes
//! @{

//! Draft a simple line from an initial to a terminal point.
/***************************************************************************//**
  \param    i <point-2d> The initial point coordinate [x, y].
  \param    t <point-2d> The terminal point coordinate [x, y].
  \param    w <decimal> The line weight.

  \details

    \ref $draft_line_fn sets arc fragment number for line construction.

    | see: \ref draft_config_map  |
    |:---------------------------:|
    | line-width-min              |
    | line-use-hull               |
*******************************************************************************/
module draft_line_pp
(
  i,
  t,
  w = 1
)
{
  $fn = $draft_line_fn;
  p = draft_get_config("line-width-min") * w * $draft_scale;

  if ( draft_get_config("line-use-hull")  )
  {
    // hulled end-circles
    hull() { translate(i) circle(d=p); translate(t) circle(d=p); }
  }
  else
  {
    // rectangle line
    align_ll(r=[i, t], rp=2, l=y_axis3d_ul)
    square([p, distance_pp(i, t)], center=true);

    // add rounded ends
    // translate(i) circle(d=p); translate(t) circle(d=p);
  }
}

//! Draft an arrowhead at the terminal point of a line.
/***************************************************************************//**
  \param    l <line> A line or vector.
  \param    w <decimal> The line segment weight.
  \param    s <integer | integer-list-5> The arrowhead style.

  \details

    The style can be customize via the following optional parameter
    list fields.

     field  | description                     | data type           | default
    :------:|:--------------------------------|:--------------------|:-------:
      0     | style                           | <integer>           | 0
      1     | fill: 0,1 or true,false         | <integer \| boolean>| 0
      2     | side: 0=both, 1=left, 2=right   | <integer>           | 0
      3     | length multiplier               | <decimal>           | 1
      4     | angle multiplier                | <decimal>           | 1

    When parameter \p s is assigned a single integer it sets the style
    and the other fields are assigned their default values.

     style  | description
    :------:|:--------------------------
      0     | no arrowhead
      1     | closed 3-point arrowhead
      2     | closed 4-point arrowhead
      3     | open 3-point arrowhead
      4     | slash / cross arrowhead
      5     | circle arrowhead

    \amu_eval ( object=draft_arrow ${object_diagram_2d} )

    \ref $draft_arrow_fn sets arc fragment number for arrowhead
    construction. The line segments are constructed by draft_line_pp().

    | see: \ref draft_config_map  |
    |:---------------------------:|
    | arrow-line-length-min       |
    | arrow-angle-min             |
*******************************************************************************/
module draft_arrow
(
  l = x_axis2d_ul,
  w = 1,
  s = 1
)
{
  s1 = defined_e_or(s, 0, s);                 // arrow selection

  if ( s1 )
  {
    s2  = defined_e_or(s, 1, 0);              // fill [0:1, t:f]
    s3  = defined_e_or(s, 2, 0);              // sections [0:all,1:left,2:right]

    s4  = defined_e_or(s, 3, 1);              // length multiplier
    s5  = defined_e_or(s, 4, 1);              // angle multiplier


    al  = draft_get_config("arrow-line-length-min") * s4 * $draft_scale;
                                              // length

    ca  = draft_get_config("arrow-angle-min") * s5;
                                              // cut angle

    alx = angle_ll(x_axis2d_uv, l, true);     // line angle
    aa1 = alx+180-ca;                         // angle a1
    aa2 = alx-180+ca;                         // angle a2

    pah = line_tp(l);                         // head point

    ls1 = line2d_new(m=al, a=aa1, p1=pah);    // side line1
    ls2 = line2d_new(m=al, a=aa2, p1=pah);    // side line2

    ps1 = line_tp(ls1);                       // line1 end point
    ps2 = line_tp(ls2);                       // line2 end point

    ptm = (ps1 + ps2)/2;                      // tail mid point
    pam = (ptm + pah)/2;                      // middle point

    // update fn for arrow line construction
    $draft_line_fn = $draft_arrow_fn;

    if ( s1 == 1 )
    { // closed 3-point
      hull_cs( !s2 )
      {
        draft_line_pp(pah, ptm, w=w);
        if (binary_bit_is(s3, 0, 0))
          { draft_line_pp(ls1[0], ls1[1], w=w); draft_line_pp(ps1, ptm, w=w); }
        if (binary_bit_is(s3, 1, 0))
        { draft_line_pp(ls2[0], ls2[1], w=w); draft_line_pp(ps2, ptm, w=w); }
      }
    }
    else if ( s1 == 2 )
    { // closed 4-point
      hull_cs( !s2 )
      {
        draft_line_pp(pah, pam, w=w);
        if (binary_bit_is(s3, 0, 0))
          { draft_line_pp(ls1[0], ls1[1], w=w); draft_line_pp(ps1, pam, w=w); }
      }
      hull_cs( !s2 )
      {
        draft_line_pp(pah, pam, w=w);
        if (binary_bit_is(s3, 1, 0))
        { draft_line_pp(ls2[0], ls2[1], w=w); draft_line_pp(ps2, pam, w=w); }
      }
    }
    else if ( s1 == 3 )
    { // open 3-point
      if (binary_bit_is(s3, 0, 0))
        draft_line_pp(ls1[0], ls1[1], w=w);
      if (binary_bit_is(s3, 1, 0))
        draft_line_pp(ls2[0], ls2[1], w=w);
    }
    else if ( s1 == 4 )
    { // slash / cross
      if (binary_bit_is(s3+1, 0, 1))
      {
        xl1 = line2d_new(m=+al/3*2, a=alx+180-ca*2, p1=pah);
        xl2 = line2d_new(m=-al/3*2, a=alx+180-ca*2, p1=pah);

        draft_line_pp(xl1[0], xl1[1], w=w);
        draft_line_pp(xl2[0], xl2[1], w=w);
      }
      if (binary_bit_is(s3+1, 1, 1))
      {
        xl1 = line2d_new(m=+al/3*2, a=alx-180+ca*2, p1=pah);
        xl2 = line2d_new(m=-al/3*2, a=alx-180+ca*2, p1=pah);

        draft_line_pp(xl1[0], xl1[1], w=w);
        draft_line_pp(xl2[0], xl2[1], w=w);
      }
    }
    else if ( s1 == 5 )
    { // circle
      hull_cs( !s2 )
      for ( ls = sequence_ns( polygon_arc_p( r=al/3, c=pah, fn=$draft_arrow_fn ), 2, 1 ) )
        draft_line_pp(ls[0], ls[1], w=w);
    }
  }
}

//! Draft a line with configurable style and optional arrowheads.
/***************************************************************************//**
  \param    l <line> A line or vector.
  \param    w <decimal> The line weight.
  \param    s <integer | integer-list> The line style.
  \param    a1 <integer | integer-list-5> The arrowhead style at initial point.
  \param    a2 <integer | integer-list-5> The arrowhead style at terminal point.

  \details

    When parameter \p s is assigned a single integer it sets the style
    with its default optional values. The line style \p s can be one of
    the following:

     style  | description
    :------:|:--------------------------
      0     | no line
      1     | solid line
      2     | single dash pattern centered
      3     | dual overlapped dash patterns
      4     | both ends and center
      5     | line section break

    Each style can be customize via optional parameter list fields. The
    options differ by style:

    <b>style 2</b>

     field  | description                     | data type           | default
    :------:|:--------------------------------|:--------------------|:-------:
      1     | length multiplier               | <decimal>           | 1
      2     | stride                          | <decimal>           | 2

    <b>style 3</b>

     field  | description                     | data type           | default
    :------:|:--------------------------------|:--------------------|:-------:
      1     | length multiplier 1             | <decimal>           | 1
      2     | stride 1                        | <decimal>           | 2
      3     | length multiplier 2             | <decimal>           | 2
      4     | stride 2                        | <decimal>           | 3

    <b>style 4</b>

     field  | description                     | data type           | default
    :------:|:--------------------------------|:--------------------|:-------:
      1     | number of centered segments     | <decimal>           | 1
      2     | centered-length multiplier      | <decimal>           | 1
      3     | end-length multiplier           | <decimal>           | 1

    <b>style 5</b>

     field  | description                     | data type           | default
    :------:|:--------------------------------|:--------------------|:-------:
      1     | number of breaks                | <decimal>           | 1
      2     | break length multiplier         | <decimal>           | 2
      3     | break width multiplier          | <decimal>           | 2
      4     | break angle                     | <decimal>           | 67.5

    \amu_eval ( object=draft_line ${object_diagram_2d} )

    The line segments are constructed by draft_line_pp().

    | see: \ref draft_config_map  |
    |:---------------------------:|
    | line-segment-min            |
*******************************************************************************/
module draft_line
(
  l  = x_axis2d_ul,
  w  = 1,
  s  = 1,
  a1 = 0,
  a2 = 0
)
{
  s1 = defined_e_or(s, 0, s);                 // line selection

  if ( !all_equal([s1, a1, a2], 0) )
  {
    lsm = draft_get_config("line-segment-min") * $draft_scale;

    i  = line_ip(l);
    t  = line_tp(l);

    if ( s1 == 1 )
    { // solid line
      draft_line_pp(i, t, w);
    }
    else if ( s1 == 2 )
    { // single pattern centered
      s2 = defined_e_or(s, 1, 1)*lsm;         // length multiplier
      s3 = defined_e_or(s, 2, 2);             // stride

      for ( ls = sequence_ns( polygon_line_p(l=l, ft=s2), 2, s3 ) )
        draft_line_pp(ls[0], ls[1], w);
    }
    else if ( s1 == 3 )
    { // dual overlapped patterns
      s2 = defined_e_or(s, 1, 1)*lsm;         // length multiplier 1
      s3 = defined_e_or(s, 2, 2);             // stride 1
      s4 = defined_e_or(s, 3, 2)*lsm;         // length multiplier 2
      s5 = defined_e_or(s, 4, 3);             // stride 2

      for ( ls = sequence_ns( polygon_line_p(l=l, fs=s2), 2, s3 ) )
        draft_line_pp(ls[0], ls[1], w);

      for ( ls = sequence_ns( polygon_line_p(l=l, fs=s4), 2, s5 ) )
        draft_line_pp(ls[0], ls[1], w);
    }
    else if ( s1 == 4 )
    { // at both ends and 'n' centered
      s2 = defined_e_or(s, 1, 1);             // number 'n'
      s3 = defined_e_or(s, 2, 1)*lsm;         // centered-length multiplier
      s4 = defined_e_or(s, 3, 1)*lsm;         // end-length multiplier

      // at both ends
      el1 = line2d_new(s4, p1=i, v=[i, t]);
      el2 = line2d_new(s4, p1=t, v=[t, i]);

      draft_line_pp(el1[0], el1[1], w);
      draft_line_pp(el2[0], el2[1], w);

      // 'n' centered
      if (s2 > 0)
      {
        mp = polygon_line_p(l=l, fn=s2+1);
        for (j = [1:len(mp)-2])
        {
          cl1 = line2d_new(s3/2, p1=mp[j], v=[t, i]);
          cl2 = line2d_new(s3/2, p1=mp[j], v=[i, t]);

          draft_line_pp(cl1[1], cl2[1], w);
        }
      }
    }
    else if ( s1 == 5 )
    { // line break(s)
      s2 = defined_e_or(s, 1, 1);             // number of breaks
      s3 = defined_e_or(s, 2, 2)*lsm;         // length multiplier
      s4 = defined_e_or(s, 3, 2)*lsm;         // width multiplier
      s5 = defined_e_or(s, 4, 67.5);          // angle*

      // *s5=90 invokes bug: https://github.com/CGAL/cgal/issues/2631

      la = angle_ll(x_axis2d_uv, l);
      bp = polygon_line_p(l=l, fn=1+max(1,s2));

      xp =
      [
        for (i = [1:len(bp)-2])
        let
        (
          mp = bp[i],                         // mid, cross, & line points
          xp = polygon_regular_p(n=2, r=s4, o=la+s5, c=mp),
          lp = polygon_regular_p(n=2, r=s3, o=la, c=mp)
        )
        [ lp[1], xp[0], xp[1], lp[0] ]
      ];

      for ( ls = sequence_ns(concat([i],merge_s(xp),[t]), 2, 1 ) )
        draft_line_pp(ls[0], ls[1], w);
    }

    // arrows
    draft_arrow(l=[t, i], w=w, s=a1);
    draft_arrow(l=[i, t], w=w, s=a2);
  }
}

//! Draft an arc with configurable style and optional arrowheads.
/***************************************************************************//**
  \copydetails polygon_arc_p()
    These coordinates will be used to draft an arc according to the
    following additional parameters.

  \param    w <decimal> The line weight.
  \param    s <integer | integer-list> The line style.
  \param    a1 <integer | integer-list-5> The arrowhead style at initial point.
  \param    a2 <integer | integer-list-5> The arrowhead style at terminal point.

  \details

    When parameter \p s is assigned a single integer it sets the style
    with its default optional values. The line style \p s can be one of
    the following:

     style  | description
    :------:|:--------------------------
      0     | no line
      1     | solid line
      2     | single dash pattern

    Style 2 can be customize via optional parameter as shown below:

    <b>style 2</b>

     field  | description                     | data type           | default
    :------:|:--------------------------------|:--------------------|:-------:
      1     | stride                          | <decimal>           | 2

    \amu_eval ( object=draft_arc ${object_diagram_2d} )

    The line segments are constructed by draft_line_pp().
*******************************************************************************/
module draft_arc
(
  r  = 1,
  c  = origin2d,
  v1 = x_axis2d_uv,
  v2 = x_axis2d_uv,
  fn,
  cw = true,

  w  = 1,
  s  = 1,
  a1 = 0,
  a2 = 0
)
{
  s1 = defined_e_or(s, 0, s);                 // line selection

  if ( !all_equal([s1, a1, a2], 0) )
  {
    pp = polygon_arc_p( r=r, c=c, v1=v1, v2=v2, fn=fn, cw=cw );

    if ( s1 == 1 )
    { // solid line
      for ( ls = sequence_ns( pp, 2, 1 ) )
        draft_line_pp(ls[0], ls[1], w);
    }
    else if ( s1 == 2 )
    { // single pattern
      s2 = defined_e_or(s, 1, 2);             // point stride

      for ( ls = sequence_ns( pp, 2, s2 ) )
        draft_line_pp(ls[0], ls[1], w);
    }

    // arrows
    draft_arrow(l=reverse(firstn(pp, 2)), w=w, s=a1);
    draft_arrow(l=lastn(pp, 2), w=w, s=a2);
  }
}

//! Draft a rectangle with configurable style.
/***************************************************************************//**
  \param    d <decimal-list-2 | decimal> A list [x, y] of decimals
            or a single decimal for (x=y).
  \param    c <point-2d> The center coordinate [x, y].
  \param    w <decimal> The line weight.
  \param    s <integer | integer-list> The line style.

  \details

    \amu_eval ( object=draft_rectangle ${object_diagram_2d} )

    The line segments are constructed by draft_line().
*******************************************************************************/
module draft_rectangle
(
  d = 1,
  c = origin2d,
  w = 1,
  s = 1
)
{
  dx = defined_e_or(d, 0, d);
  dy = defined_e_or(d, 1, dx);

  mx = dx/2;
  my = dy/2;

  pl =
  [
    [-mx, -my] + c,
    [-mx,  my] + c,
    [ mx,  my] + c,
    [ mx, -my] + c
  ];

  // draft each edge
  for ( cp = sequence_ns(pl, n=2, s=1, w=true) )
    draft_line(l=[cp[0], cp[1]], w=w, s=s);
}

//! Draft a polygon with configurable style.
/***************************************************************************//**
  \param    c <coords-2d> A list of 2d coordinate points.

  \param    p <integer-list-list> A list of paths that enclose the
            shape where each face is a list of coordinate indexes.
  \param    e <integer-list-2-list> A list of edges where each edge is
            a list of two coordinate indexes.
  \param    i <index> An index sequence [specification].

  \param    w <decimal> The line weight.
  \param    s <integer | integer-list> The line style.

  \details

    Parameter \p p is optional and when it is not given, the listed
    order of the coordinates establishes the polygon path. When
    parameter \p e is not specified, it is computed from \p p using
    polytope_faces2edges(). Parameter \p i allows coordinate indexes to
    be selected using several selection [schemes][specification].

    \amu_eval ( object=draft_polygon ${object_diagram_2d} )

    The line segments are constructed by draft_line().

  [specification]: \ref dt_index
*******************************************************************************/
module draft_polygon
(
  c,
  p,
  e,
  i = true,

  w = 1,
  s = 1
)
{
  el  = is_defined(e) ? e           // use supplied edge list 'e'
      : polytope_faces2edges        // construct from paths
        (
            is_defined(p) ? p       // use supplied path list 'p'
          : [consts(len(c))]        // connect all points in order supplied
        );

  // draft each selected edge
  for (i = index_gen(el, i))        // allow edge selection index
    draft_line(l=[c[first(el[i])], c[second(el[i])]], w=w, s=s);
}

//! @}

//----------------------------------------------------------------------------//

//! \name Miscellaneous
//! @{

//! Extrude 2D drafted constructions to 3D if configured.
/***************************************************************************//**
  \details

    When \ref $draft_make_3d is \b true, all children objects are
    extruded to 3D.

    | see: \ref draft_config_map  |
    |:---------------------------:|
    | make-3d-height              |
*******************************************************************************/
module draft_make_3d_if_configured
(
)
{
  if ( $draft_make_3d )
    linear_extrude
    (
      height=draft_get_config("make-3d-height") * $draft_scale, center=true
    )
    children();
  else
    children();
}

//! @}

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE diagram;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <tools/align.scad>;
    include <tools/operation_cs.scad>;
    include <tools/polytope.scad>;
    include <tools/drafting/draft-base.scad>;

    object = "draft_arrow";

    if (object == "draft_arrow")
    {
      grid = [20, 10];

      for ( s=[1:5], f=[0:1], p=[0:2] )
        translate( [(p+1)*first(grid) + f*3*first(grid), s*second(grid)] )
        draft_arrow( l=x_axis2d_ul, s=[s, f, p] );
    }

    if (object == "draft_line")
    {
      line = [[0,0], [100,0]];
      for ( s=[1:5] )
        translate( [0, s*5] )
        draft_line(l=line, s=s);
    }

    if (object == "draft_arc")
    {
      for ( s=[1:2] )
        draft_arc (r=50-5*s, v1=[-1,1], v2=45, cw=true, s=s);
    }

    if (object == "draft_rectangle")
    {
      draft_rectangle ([100, 30], s=[4, 3, 2, 5]);
    }

    if (object == "draft_polygon")
    {
      pp = length
      (
        [ [+1.5 + 1/3, -1.25], [+1.5/4, 0], [+1.5 - 1/3, +1.25],
          [-1.5 + 1/3, +1.25], [-1.5/4, 0], [-1.5 - 1/3, -1.25]
        ], "in"
      );

      polytope_number(pp, vi=true, ei=false, fi=false);

      rp = polygon_round_eve_all_p(c=pp, vr=length(1/4, "in"), vrm=1, cw=false);
      draft_polygon(rp, s=2);
    }
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_svg}.mfs;

    defines   name "objects" define "object"
              strings "
                draft_arrow
                draft_line
                draft_arc
                draft_rectangle
                draft_polygon
              ";
    variables add_opts_combine "objects";
    variables add_opts "--viewall --autocenter";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
