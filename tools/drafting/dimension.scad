//! Drafting dimension operations.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2019-2023

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

    \amu_define group_name  (Dimension)
    \amu_define group_brief (Drafting dimension operations.)

  \amu_include (include/amu/pgid_path_pstem_g.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)

  \amu_include (include/amu/scope_diagram_2d_object.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//
// dimension operations
//----------------------------------------------------------------------------//

//! \name Dimensioning
//! @{

//! Construct a dimension leader line at a point.
/***************************************************************************//**
  \param    p <point-2d> The leader line point.

  \param    v1 <line-2d | decimal> The leader line 1 angle.
            A 2d line, vector, or decimal angle.
  \param    l1 <decimal> The leader line 1 length.
  \param    v2 <line-2d | decimal> The leader line 2 angle.
            A 2d line, vector, or decimal angle.
  \param    l2 <decimal> The leader line 2 length.

  \param    h <string> An optional text heading.
  \param    t <string | string-list> A single or multi-line text string.
  \param    ts <decimal-list-3> A list of decimals that define the
            <width, line-height, heading-height> of the text.
  \param    tp <integer-list-2> The text alignment point.
            A list [tpx, tpy] of decimals. Requires \p tr.
  \param    tr <decimal> The text rotation angle.
  \param    ta <string> The text horizontal alignment. One of:
            < \b "left" | \b "center" | \b "right" >.

  \param    bw <decimal> The boarder line weight.
  \param    bs <integer | integer-list> The boarder line [style].

  \param    w <decimal> The line weight.
  \param    s <integer | integer-list> The line [style].
  \param    a <integer | integer-list-5> The arrowhead [style][arrow].

  \param    o <decimal> The leader point offset.

  \param    cmh <decimal> The horizontal width minimum unit cell size.
  \param    cmv <decimal> The vertical height minimum unit cell size.

  \param    window <boolean> Return text window rectangle.
  \param    layers <string-list> The List of drafting layer names.

  \details

    \amu_eval ( html_image_w=256 latex_image_w="1.50in" object=draft_dim_leader ${object_diagram_2d} )

  [style]: \ref draft_line()
  [arrow]: \ref draft_arrow()
*******************************************************************************/
module draft_dim_leader
(
  p = origin2d,

  v1 = 30,
  l1 = draft_get_config("dim-leader-length"),
  v2,
  l2,

  h,
  t,
  ts,
  tp,
  tr,
  ta = "center",

  bw = draft_get_config("dim-leader-box-weight"),
  bs = draft_get_config("dim-leader-box-style"),

  w = draft_get_config("dim-leader-weight"),
  s = draft_get_config("dim-leader-style"),
  a = draft_get_config("dim-leader-arrow"),

  o  = draft_get_config("dim-offset"),

  cmh = draft_get_config("dim-cmh"),
  cmv = draft_get_config("dim-cmv"),

  window = false,
  layers = draft_get_config("layers-dim")
)
{
  if (draft_layers_any_active(layers))
  draft_make_3d_if_configured()
  {
    // offset
    plo = is_undef(o) ? p
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
    tra = is_undef(tr) ? angle_ll(x_axis2d_uv, ll2, false)
        : is_number(tr)   ? tr
        :                   angle_ll(x_axis2d_uv, tr, false);

    // text alignment point
    dtp = is_undef(tr) ? [-1, 0]
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
      layers=layers,
      $draft_make_3d=false
    );
  }
}

//! Construct a dimension line between two points.
/***************************************************************************//**
  \param    p1 <point-2d> The dimension point 1.
  \param    p2 <point-2d> The dimension point 2.

  \param    v1 <line-2d | decimal> The point 1 extension line vector.
            A 2d line, vector, or decimal angle.
  \param    v2 <line-2d | decimal> The point 2 extension line vector.
            A 2d line, vector, or decimal angle.

  \param    t <string | string-list> A single or multi-line text string
            that overrides the measured distance.
  \param    u <string> The units for the measured distance.
            One of the predefined in \ref units_length.

  \param    d <decimal | decimal-list-2> The minimum distance between the
            reference point and the start of the extension line.
            A list [d1, d2] of decimals or a single decimal for (d1=d2).
  \param    e <decimal | decimal-list-2> The length of the extension line.
            A list [e1, e2] of decimals or a single decimal for (e1=e2).
  \param    es <integer | integer-list> The extension line [style].

  \param    w <decimal> The line weight.
  \param    s <integer | integer-list> The line [style].
  \param    a <integer | integer-list-5> The arrowheads [style][arrow].

  \param    a1 <integer | integer-list-5> The arrowhead 1 [style][arrow]
            override.
  \param    a2 <integer | integer-list-5> The arrowhead 2 [style][arrow]
            override.

  \param    o <decimal> The dimension line offset.

  \param    ts <decimal-list-3> A list of decimals that define the
            <width, line-height, heading-height> of the text.
  \param    tp <integer-list-2> The text alignment point.
            A list [tpx, tpy] of decimals.
  \param    rm <integer> The measurement rounding mode.
            One of: 0=none, 1=[round_d], and 2=[round_s].

  \param    cmh <decimal> The horizontal width minimum unit cell size.
  \param    cmv <decimal> The vertical height minimum unit cell size.

  \param    layers <string-list> The List of drafting layer names.

  \details

    Only one of \p v1 or \p v2 should normally be used at a time. When
    neither is specified, the extension line vector angle will be at a
    right angle to the line formed by the dimension points \p p1 and \p
    p2.

    \amu_eval ( html_image_w=512 latex_image_w="3.00in" object=draft_dim_line ${object_diagram_2d} )

  [style]: \ref draft_line()
  [arrow]: \ref draft_arrow()
  [round_d]: \ref round_d()
  [round_s]: \ref round_s()
*******************************************************************************/
module draft_dim_line
(
  p1 = origin2d,
  p2 = origin2d,

  v1,
  v2,

  t,
  u,

  d  = draft_get_config("dim-line-distance"),
  e  = draft_get_config("dim-line-extension-length"),
  es = draft_get_config("dim-line-extension-style"),

  w  = draft_get_config("dim-line-weight"),
  s  = draft_get_config("dim-line-style"),
  a  = draft_get_config("dim-line-arrow"),

  a1,
  a2,

  o  = draft_get_config("dim-offset"),

  ts = draft_get_config("dim-text-size"),
  tp = draft_get_config("dim-text-place"),
  rm = draft_get_config("dim-round-mode"),

  cmh = draft_get_config("dim-cmh"),
  cmv = draft_get_config("dim-cmv"),

  layers = draft_get_config("layers-dim")
)
{
  if (draft_layers_any_active(layers))
  draft_make_3d_if_configured()
  {
    // identify measurement reference points
    // only one of 'v1', 'v2' should normally be used at a time
    // create vector if numerical angle has been specified.
    mr1 = is_undef(v1) ? p1
        : let( va1 = is_number(v1) ? line2d_new(a=v1, p1=p1) : v1 )
          point_closest_pl(p2, va1);
    mr2 = is_undef(v2) ? p2
        : let( va2 = is_number(v2) ? line2d_new(a=v2, p1=p2) : v2 )
          point_closest_pl(p1, va2);

    // minimum distance from reference points to dimension line
    dm1 = defined_e_or(d, 0, d);
    dm2 = defined_e_or(d, 1, dm1);

    // extension line lengths (back towards reference points)
    de1 = defined_e_or(e, 0, e);
    de2 = defined_e_or(e, 1, de1);

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
           du = is_undef(u) ? md
              : length(md, from=length_unit_base, to=u),

           // rounding: [mode:0, digits]
           rs = defined_e_or(rm, 0, 0),

           rd = rs == 1 ? round_d(du, defined_e_or(rm, 1, 2))
              : rs == 2 ? round_s(du, defined_e_or(rm, 1, 3))
              : du
         )
         // add units id when 'u' is specified
         is_undef(u) ? str(rd) : str(rd, " ", u);

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
        layers=layers,
        $draft_make_3d=false
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
      layers=layers,
      $draft_make_3d=false
    );
  }
}

//! Construct a radial dimension line.
/***************************************************************************//**
  \param    c <point-2d> The radius center point.

  \param    p <point-2d> A point on the radius.
  \param    r <decimal> The radius length.
  \param    v <line-2d | decimal> The dimension line angle for radius \p r.
            A 2d line, vector, or decimal angle.

  \param    t <string | string-list> A single or multi-line text string
            that overrides the measured length.
  \param    u <string> The units for the measured length.
            One of the predefined in \ref units_length.

  \param    d <boolean> Construct a diameter dimension line.

  \param    w <decimal> The line weight.
  \param    s <integer | integer-list> The line [style].
  \param    a <integer | integer-list-5> The arrowheads [style][arrow].

  \param    a1 <integer | integer-list-5> The arrowhead 1 [style][arrow]
            override.
  \param    a2 <integer | integer-list-5> The arrowhead 2 [style][arrow]
            override.

  \param    o <decimal | decimal-list-2> The dimension line offset. A list
            [o1, o2] of decimals or a single decimal for (o1=o2).

  \param    ts <decimal-list-3> A list of decimals that define the
            <width, line-height, heading-height> of the text.
  \param    tp <integer-list-2> The text alignment point.
            A list [tpx, tpy] of decimals.
  \param    rm <integer> The measurement rounding mode.
            One of: 0=none, 1=[round_d], and 2=[round_s].

  \param    cmh <decimal> The horizontal width minimum unit cell size.
  \param    cmv <decimal> The vertical height minimum unit cell size.

  \param    layers <string-list> The List of drafting layer names.

  \details

    \amu_eval ( html_image_w=256 latex_image_w="1.50in" object=draft_dim_radius ${object_diagram_2d} )

  [style]: \ref draft_line()
  [arrow]: \ref draft_arrow()
  [round_d]: \ref round_d()
  [round_s]: \ref round_s()
*******************************************************************************/
module draft_dim_radius
(
  c = origin2d,

  p,
  r = 1,
  v,

  t,
  u,

  d  = false,

  w  = draft_get_config("dim-radius-weight"),
  s  = draft_get_config("dim-radius-style"),
  a  = draft_get_config("dim-radius-arrow"),

  a1,
  a2,

  o  = draft_get_config("dim-offset"),

  ts = draft_get_config("dim-text-size"),
  tp = draft_get_config("dim-text-place"),
  rm = draft_get_config("dim-round-mode"),

  cmh = draft_get_config("dim-cmh"),
  cmv = draft_get_config("dim-cmv"),

  layers = draft_get_config("layers-dim")
)
{
  if (draft_layers_any_active(layers))
  draft_make_3d_if_configured()
  {
    // identify radius reference points
    // create vector if numerical angle has been specified.
    rr1 = c;
    rr2 = is_defined(p)  ? p
        : is_undef(v) ? line_tp(line2d_new(m=r, p1=c))
        : is_number(v)   ? line_tp(line2d_new(m=r, a=v, p1=c))
        :                  line_tp(line2d_new(m=r, v=v, p1=c));

    // identify measurement reference points
    mr1 = d ? line_tp(line2d_new(m=distance_pp(rr1, rr2), v=[rr2, rr1], p1=rr1))
        : rr1;
    mr2 = rr2;

    // minimum distance from reference points to dimension line
    do1 = defined_e_or(o, 0, o);
    do2 = defined_e_or(o, 1, d ? do1 : 0);

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
           du = is_undef(u) ? md
              : length(md, from=length_unit_base, to=u),

           // rounding: [mode:0, digits]
           rs = defined_e_or(rm, 0, 0),

           rd = rs == 1 ? round_d(du, defined_e_or(rm, 1, 2))
              : rs == 2 ? round_s(du, defined_e_or(rm, 1, 3))
              : du,

           rt = d ? "D" : "R"
         )
         // add units id when 'u' is specified
         is_undef(u) ? str(rt, " ", rd) : str(rt, " ", rd, " ", u);

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
        layers=layers,
        $draft_make_3d=false
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
      layers=layers,
      $draft_make_3d=false
    );
  }
}

//! Construct a angular dimension arc.
/***************************************************************************//**
  \param    c <point-2d> The arc center point.
  \param    r <decimal> The arc radius length.

  \param    v1 <line-2d | decimal> The arc initial angle.
            A 2d line, vector, or decimal angle.
  \param    v2 <line-2d | decimal> The arc terminal angle.
            A 2d line, vector, or decimal angle.

  \param    fn <integer> The number of [facets].
  \param    cw <boolean> Sweep clockwise along arc from the head of
            vector \p v1 to the head of vector \p v2 when \p cw =
            \b true, and counter clockwise when \p cw = \b false.

  \param    t <string | string-list> A single or multi-line text string
            that overrides the measured angle.
  \param    u <string> The units for the measured angle.
            One of the predefined in \ref units_angle.

  \param    e <decimal | decimal-list-2> The extension line to radius ratio.
            A list [e1, e2] of decimals or a single decimal for (e1=e2).
  \param    es <integer | integer-list> The extension line [style].

  \param    w <decimal> The arc weight.
  \param    s <integer | integer-list> The arc [style].
  \param    a <integer | integer-list-5> The arrowheads [style][arrow].

  \param    a1 <integer | integer-list-5> The arrowhead 1 [style][arrow]
            override.
  \param    a2 <integer | integer-list-5> The arrowhead 2 [style][arrow]
            override.

  \param    o <decimal> The dimension arc offset.

  \param    ts <decimal-list-3> A list of decimals that define the
            <width, line-height, heading-height> of the text.
  \param    tp <integer-list-4> The text alignment point.
            A list [tpx, tpy, tpa, tra] of decimals, where \p tpa is
            the text pivot angle and \p tra is the text rotation angle.
  \param    rm <integer> The measurement rounding mode.
            One of: 0=none, 1=[round_d], and 2=[round_s].

  \param    cmh <decimal> The horizontal width minimum unit cell size.
  \param    cmv <decimal> The vertical height minimum unit cell size.

  \param    layers <string-list> The List of drafting layer names.

  \details

    \amu_eval ( html_image_w=256 latex_image_w="1.50in" object=draft_dim_angle ${object_diagram_2d} )

  [facets]: \ref get_fn()
  [style]: \ref draft_line()
  [arrow]: \ref draft_arrow()
  [round_d]: \ref round_d()
  [round_s]: \ref round_s()
*******************************************************************************/
module draft_dim_angle
(
  c = origin2d,
  r = 1,

  v1,
  v2,

  fn,
  cw = false,

  t,
  u,

  e  = draft_get_config("dim-angle-extension-ratio"),
  es = draft_get_config("dim-angle-extension-style"),

  w  = draft_get_config("dim-angle-weight"),
  s  = draft_get_config("dim-angle-style"),
  a  = draft_get_config("dim-angle-arrow"),

  a1,
  a2,

  o  = draft_get_config("dim-offset"),

  ts = draft_get_config("dim-text-size"),
  tp = draft_get_config("dim-text-place"),
  rm = draft_get_config("dim-round-mode"),

  cmh = draft_get_config("dim-cmh"),
  cmv = draft_get_config("dim-cmv"),

  layers = draft_get_config("layers-dim")
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
    er1 = defined_e_or(e, 0, e);
    er2 = defined_e_or(e, 1, er1);

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
           au = is_undef(u) ? ma
              : angle(ma, from=angle_unit_base, to=u),

           // rounding: [mode:0, digits]
           rs = defined_e_or(rm, 0, 0),

           rd = rs == 1 ? round_d(au, defined_e_or(rm, 1, 2))
              : rs == 2 ? round_s(au, defined_e_or(rm, 1, 3))
              : au
         )
         // add units id when 'u' is specified
         is_undef(u) ? str(rd) : str(rd, " ", u);

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
        layers=layers,
        $draft_make_3d=false
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
      layers=layers,
      $draft_make_3d=false
    );
  }
}

//! Construct a center mark dimension cross.
/***************************************************************************//**
  \param    c <point-2d> The center point.

  \param    r <decimal> A circular arc radius.

  \param    v <line-2d | decimal> The cross rotation angle.
            A 2d line, vector, or decimal angle.
  \param    l <decimal> The cross line length.

  \param    e <decimal | decimal-list-4> The length of the extension lines.
            A list [e1, e2, e3, e4] of decimals or a single decimal for
            (e1=e2=e3=e4).
  \param    es <integer | integer-list> The extension line [style].

  \param    w <decimal> The line weight.
  \param    s <integer | integer-list> The line [style].

  \param    layers <string-list> The List of drafting layer names.

  \details

    \amu_eval ( html_image_w=512 latex_image_w="3.00in" object=draft_dim_center ${object_diagram_2d} )

  [style]: \ref draft_line()
*******************************************************************************/
module draft_dim_center
(
  c = origin2d,

  r,

  v = 0,
  l = draft_get_config("dim-center-length"),

  e,
  es = draft_get_config("dim-angle-extension-style"),

  w  = draft_get_config("dim-center-weight"),
  s  = draft_get_config("dim-center-style"),

  layers = draft_get_config("layers-dim")
)
{
  if (draft_layers_any_active(layers))
  draft_make_3d_if_configured()
  {
    // alignment angle
    aa = is_number(v) ? v : angle_ll(x_axis2d_uv, v);

    //
    // draft
    //

    // center
    for ( q = [0,1] )
    {
      la = aa + 90*q;
      p1 = c - l * [cos(la), sin(la)];

      draft_line(l=line2d_new(m=l*2, a=la, p1=p1), w=w, s=s);
    }

    // radius
    if ( is_defined(r) )
    for ( q = [0:3] )
    {
      la = aa + 90*q;
      p1 = c + (r-l) * [cos(la), sin(la)];      // radius
      p2 = c + (r-l/2)/2 * [cos(la), sin(la)];  // mid

      draft_line(l=line2d_new(m=l*2, a=la, p1=p1), w=w, s=s);
      draft_line(l=line2d_new(m=l/2, a=la, p1=p2), w=w, s=s);
    }

    // individual extensions
    rs = is_defined(r) ? (r + 2*l) : (2*l);     // radial start distance
    dl = defined_e_or(e, 0, e);                 // default length

    if ( is_defined(e) )
    for ( q = [0:3] )
    {
      la = aa + 90*q;
      p1 = c + rs * [cos(la), sin(la)];         // start point
      el = defined_e_or(e, q, dl) - rs;         // individual lengths

      if (el > 0)
      draft_line(l=line2d_new(m=el, a=la, p1=p1), w=w, s=es);
    }

  }
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

    object = "draft_dim_leader";

    if (object == "draft_dim_leader") {
      draft_dim_leader (l1=25, v2=0, t="1");
    }

    if (object == "draft_dim_line") {
      draft_dim_line (p1=[0,0], p2=[100,0], u="cm");
    }

    if (object == "draft_dim_radius") {
      draft_arc (r=50, v1=90, s=2);
      draft_dim_radius (r=50, v=45, u="cm", a1=[4,0,2]);
    }

    if (object == "draft_dim_angle") {
      draft_dim_angle (r=50, v1=0, v2=angle(pi/4+pi/16,"r"), u="dms");
    }

    if (object == "draft_dim_center") {
      draft_arc (r=25, w=1/4);
      draft_dim_center (r=25, l=5, e=[100,0,100,0]);
    }
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_svg}.mfs;

    defines   name "objects" define "object"
              strings "
                draft_dim_leader
                draft_dim_line
                draft_dim_radius
                draft_dim_angle
                draft_dim_center
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
