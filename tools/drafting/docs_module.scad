//! Drafting Module documentation.
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

    \amu_define group_name  (Drafting)
    \amu_define group_brief (Drafting and drawing tools.)

  \amu_include (include/amu/pgid_pparent_path_n.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent.amu)

  /+
    remove this file and add draft-base.scad file as required include
  +/
  \amu_define FILE_NAME ()
  \amu_define includes_required_add
  (
    units/length.scad
    units/angle.scad
    tools/align.scad
    tools/operation_cs.scad
    tools/polytope.scad
    ${PATH_NAME}/draft-base.scad
  )
  \amu_include (include/amu/includes_required.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//

/***************************************************************************//**
  \addtogroup \amu_eval(${group})

  \details

    This module provides basic 2D drafting tools. Below is an example
    output (png and svg format) and script. Numerous ways exists to
    generate a printable form of the 2D result. For example: (1) Render
    the 2D design. (2) Export as DXF. (3) Open the exported DXF file
    using [LibreCAD]. (4) Select print preview and change the print
    scale as needed for the sheet size and target output page. (5)
    Finally print or save a PDF file.

    \b Example

    \amu_scope  mfscript (index=1)
    \amu_define img_conf (2048x1536_top)

    \amu_image
    (
      caption="Result (png)"
      title="click to expand"
      file="${mfscript}_${img_conf}.png"
      url="${mfscript}_${img_conf}.png"
      width=640
    )
    \amu_image
    (
      caption="Result (svg)"
      file="${mfscript}.svg"
      url="${mfscript}.svg"
      width=640
    )

    \b Script

    \dontinclude \amu_eval(${mfscript}).scad
    \skip include
    \until // EOS

  [LibreCAD]: https://librecad.org
*******************************************************************************/

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE example;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <units/length.scad>;
    include <units/angle.scad>;
    include <tools/align.scad>;
    include <tools/operation_cs.scad>;
    include <tools/drafting/draft-base.scad>;

    length_unit_base = "mm";
    length_unit_default = "mm";

    draft_sheet_scale = 1;
    draft_sheet_size = "A";

    draft_layers_show = ["default", "sheet", "titleblock", "table", "note", "dim"];
    //draft_layers_show = ["default", "dim"];
    //draft_layers_show = ["default"];

    draft_defaults_map =
      map_merge
      (
        [ // override defaults
          ["line-use-hull", false],
          ["dim-offset", length(3)],
          ["dim-leader-length", length(3)],
          ["dim-line-distance", length(3)],
          ["dim-line-extension-length", length(5)]
        ],
        draft_defaults_style1_map
      );

    draft_sheet(grid=0);

    draft_move
    (
      [
        [[-1,  1]], [[1, 1]], [[-1,-1]], [[1, -1]],
        [[0, 1/2], ["H","4"]], [[1,   0], ["H","1"]]
      ]
    )
    {
      $draft_scale = draft_sheet_scale;

      draft_ruler(order=[1,-1], label_hide=true);
      draft_ruler(order=-1, label_hide=true);
      draft_ruler();
      draft_title_block
      (
        text=
        [
          ["SPROCKET", "LOWER REAR SECTION, ASSEMBLY 2 OF 3"],
          "02/22/2019", "RAS", "X1234567890", "1", "",
          ["ABS", "BLACK"], "STANDARD", "RAS", "SAR",
          "3 COPIES REQUIRED", "APPROX. 30 MINUTE BUILD TIME",
          ["UNLESS STATED OTHERWISE ALL", "DIMS ARE +/- 0.25", "ANGLES +/- 1", "REMOVE ALL BURRS"]
        ],
        zp=[1,-1], number=false
      );

      draft_table
      (
        map=
        [
          [ "title",  [ "REVISIONS", 3/2 ] ],
          [ "heads",  [ ["DATE", "REV", "REF", "AUTH"], 3/4 ] ],
          [ "cols",   [ 3, 2, 2, 2 ] ],
          [ "rows", [ [ ["01-01-19", "R0", "X0", "RAS"], 1 ],
                      [ ["01-14-19", "R1", "X1", "RAS"], 1 ],
                      [ ["01-21-19", "R2", "X2", "RAS"], 1 ]
                    ]
          ]
        ],
        fmap=draft_table_format_ccc_map,
        zp=[-1,-1]
      );

      draft_note
      (
        head="NOTE:",
        note=["INSTALL SPROCKET", "BEFORE HUB-S32", "SEE: X1234567891"],
        size=[7, 2, 3/4],
        zp=[-1/2,0]
      );
    }

    t1 = 12;
    r1 = length(50);
    r2 = length(25);
    o1 = length(2);
    r3 = length(10);
    a1 = 47.5;

    t2 = 5;
    o2 = length(32);
    r4 = length(4);

    function bev(p, a, o, r) = [p, p+r*[cos(a+o), sin(a+o)], p+r*[cos(a-o), sin(a-o)]];

    draft_move ( [ [[1, -1/2], ["E","3"]] ] )
    union()
    {
      draft_in_layers()
      difference()
      {
        circle(r=r1);

        circle(r=r2);

        for (i=[0:360/t1:360])
        {
          p1 = (r1-o1)*[cos(i), sin(i)];
          p2 = (r1-o1-r3)*[cos(i), sin(i)];

          translate(p1) circle(r=r3);
          polygon(bev(p2, angle_ll(x_axis2d_uv, p2), a1, r3*2));
        }

        for (i=[0:360/t2:360])
          translate(o2*[cos(i), sin(i)])
          circle(r=r4);
      }

      color("black")
      {
        draft_in_layers(["dim"])
        {
          draft_arc(r=r1, s=2, v1=360/t1*2.25, v2=360/t1*0.25);
          draft_arc(r=r1-o1, s=2, v1=360/t1*8, v2=360/t1*5);
          draft_arc(r=o2, s=2, fn=72);

          draft_arc(c=[o1-r1, 0], r=r3, s=2, fn=72);
        }

        draft_dim_center(r=r2);
        draft_dim_center(c=[o1-r1, 0], r=r3, v=45);

        draft_dim_radius(r=r1, v=360/t1*1);
        draft_dim_radius(r=r1-o1, v=360/t1*7);
        draft_dim_radius(r=o2, v=360/t2*4.5, u="in");

        draft_dim_radius(c=[o1-r1, 0], r=r3, v=0, d=true, o=0);

        draft_dim_angle(r=r1*(1+1/8), v1 = 360/t2*(t2-1));

        bt = bev([0, r1-o1-r3], 90, a1, r3);
        b1 = first(bt); b2 = second(bt); b3 = third(bt);
        draft_dim_angle(c=b1, r=r3*2, v1=[b1, b3], v2=[b1, b2], e=1+1/10);

        draft_dim_line(p1=[0,r1-o1-r3], d=r1*1.4, e=[r1*1.35, r1/4], u="mm");

        draft_dim_leader(p=[o2,0], l1=10, v2=0, l2=15, ts=[2,1.5], t=[str("D ", r4), str("X ", t2)]);
      }
    }

    // EOS
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" aspect "4:3" wsizes "2048";
    views     name "views" distance "600" views "top";
    variables add_opts_combine "views";

    include --path "${INCLUDE_PATH}" scr_new_mf.mfs;

    include --path "${INCLUDE_PATH}" var_gen_svg.mfs;
    include --path "${INCLUDE_PATH}" scr_app_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
