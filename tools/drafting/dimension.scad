//! Drafting dimension operations.
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

    \amu_define group_name  (Dimension)
    \amu_define group_brief (Drafting dimension operations.)

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
// dimension operations
//----------------------------------------------------------------------------//

//! .
/***************************************************************************//**
*******************************************************************************/
module draft_dim_leader
(
  p = origin2d,

  v1 = 30,
  l1 = draft_get_default("dim-leader-length"),
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
      layers=layers,
      $draft_make_3d=false
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

//! .
/***************************************************************************//**
*******************************************************************************/
module draft_dim_radius
(
  c = origin2d,

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

//! .
/***************************************************************************//**
*******************************************************************************/
module draft_dim_angle
(
  c = origin2d,
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

//! .
/***************************************************************************//**
*******************************************************************************/
module draft_dim_center
(
  c = origin2d,

  r,
  e,

  v = 0,
  l = draft_get_default("dim-center-length"),

  w  = draft_get_default("dim-center-weight"),
  s  = draft_get_default("dim-center-style"),
  es = draft_get_default("dim-angle-extension-style"),

  layers = draft_get_default("layers-dim")
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
    dl = edefined_or(e, 0, e);                  // default length

    if ( is_defined(e) )
    for ( q = [0:3] )
    {
      la = aa + 90*q;
      p1 = c + rs * [cos(la), sin(la)];         // start point
      el = edefined_or(e, q, dl) - rs;          // individual lengths

      if (el > 0)
      draft_line(l=line2d_new(m=el, a=la, p1=p1), w=w, s=es);
    }

  }
}

//! @}
//! @}

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
