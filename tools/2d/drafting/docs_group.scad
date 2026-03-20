//! Group: drafting and drawing tools for graphical design documentation.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2019-2024,2026

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
    \amu_define group_brief (Drafting and drawing tools for graphical design documentation.)

  \amu_include (include/amu/doxyg_init_ppd_gp.amu)
*******************************************************************************/

// group begin and includes-required
/***************************************************************************//**
  \amu_include (include/amu/doxyg_define_in_parent.amu)

  /+
    remove *this* file and add draft-base.scad file as required include
  +/

  \amu_define FILE_NAME ()
  \amu_define includes_required_add
  (
    transforms/base_cs.scad
    tools/common/polytope.scad
    ${PATH_NAME}/draft-base.scad
  )
  \amu_include (include/amu/includes_required.amu)
*******************************************************************************/

// member-wide reference definitions
/***************************************************************************//**
  \amu_define group_references
  (
  )
*******************************************************************************/

// member-wide documentation and conventions
/***************************************************************************//**
  \addtogroup \amu_eval(${group})
  \details
  \anchor \amu_eval(${group})_conventions
  \par Conventions

  \b Naming

  All public modules and functions are prefixed with \c draft_*.
  Internal (private) identifiers carry an additional leading
  underscore: \c \_draft_*.  Configuration getter functions follow the
  form \c \_draft_get_* and are private; callers should use the public
  variable \ref draft_config_map together with the map_merge() or
  map_update() override pattern shown in that variable's documentation.

  \b Common \b Parameters

  The following short-name parameters carry consistent meaning across
  all modules in this library:

   parameter    | data type                 | meaning
  :------------:|:-------------------------:|:----------------------------------------------
   \c w         | decimal                   | line weight (width multiplier)
   \c s         | integer \| integer-list   | line style; see \ref draft_line()
   \c a         | integer \| integer-list-5 | arrowhead style; see \ref draft_arrow()
   \c a1, \c a2 | integer \| integer-list-5 | per-endpoint arrowhead overrides
   \c o         | point-2d                  | origin or center coordinate
   \c off       | decimal \| decimal-list-2 | dimension line offset distance
   \c t         | string \| string-list     | text string or measured-value override
   \c u         | string                    | unit identifier for measured values
   \c ts        | decimal-list-3            | text size [width, line-height, heading-height]
   \c tp        | decimal-list-2..4         | text placement [-1, +1 per axis] (1)
   \c rm        | integer \| integer-list-2 | measurement rounding mode (2)
   \c cmh       | decimal                   | minimum horizontal cell size
   \c cmv       | decimal                   | minimum vertical cell size
   \c layers    | string-list               | drafting layer names to render this object on
   \c window    | boolean                   | return bounding rectangle instead of geometry
   \c zp        | decimal-list-2 \| decimal | zone/window alignment scaler [-1, +1]
   \c line      | value-list-2              | border line config [width, [style]]

  (1) text placement [-1, +1] per axis with optional \c tp[2] pivot
      offset (angle dims) and optional \c tp[3] rotation offset.

  (2) measurement rounding mode: 0=none, 1=round_d, 2=round_s.

  \b Scale \b Variables

  Two scale variables govern geometry size and must be kept in sync:

  - \ref draft_sheet_scale is a plain variable set once at design time.
    Scales all sheet-level constructions (frame, zones, title block,
    tables). Does \b not propagate through children automatically.
  - \ref $draft_scale is a special variable that \b does propagate
    through the OpenSCAD child scope.  Set it explicitly inside
    composite operations so that objects placed via \ref draft_move
    inherit the correct scale:

    \code{.C}
    draft_move ( [ ... ] )
    {
      $draft_scale = draft_sheet_scale;
      // child objects here inherit $draft_scale automatically
    }
    \endcode

  \b Layers

  Every module accepts a \c layers parameter.  The global variable \ref
  draft_layers_show lists the layers that will actually be rendered;
  all others are suppressed.  Setting it to \c ["all"] renders
  everything; \c "all" is a wildcard that matches any layer list.

  Default layer assignments by module category:

    category          | default layer name
  :-------------------|:------------------:
    general geometry  | \c "default"
    sheet / frame     | \c "sheet"
    tables            | \c "table"
    notes             | \c "note"
    title block       | \c "titleblock"
    dimensions        | \c "dim"

  To isolate a drawing phase, restrict \ref draft_layers_show:

  \code{.C}
  draft_layers_show = ["default", "dim"];   // geometry + dimensions only
  \endcode

  \b Configuration \b and \b Style \b Maps

  All style defaults live in \ref draft_config_map, initialised to \ref
  draft_config_map_style1.  Apply selective overrides with map_merge(),
  placing overrides first so they take precedence:

  \code{.C}
  draft_config_map =
    map_merge
    (
      [ ["dim-offset", length(3)], ["line-use-hull", false] ],
      draft_config_map_style1
    );
  \endcode

  All dimension values in configuration maps should be expressed via \c
  length() or \c angle() with an explicit unit string so that designs
  remain unit-independent.

  \b Typical \b Workflow

  A minimal complete script follows the pattern shown in the auxiliary
  example block at the bottom of this file:

  -# Add required include files (see Required above).
  -# Set \ref length_unit_base and \ref draft_layers_show.
  -# Optionally override \ref draft_config_map with \c map_merge() or
     map_update().
  -# Call draft_sheet() to establish the frame and zones.
  -# Use draft_move() to place the title block, tables, and notes
     into named or indexed sheet zones.
  -# Draw geometry inside draft_in_layers() to assign it to a layer,
     then annotate with draft_dim_line(), draft_dim_radius(), etc.

  \par Example

  An example script and its output are shown below. There are numerous
  ways to generate a printable form of the 2D result. For example: (1)
  render the 2D design; (2) export it as a DXF file; (3) open the
  exported DXF file in [LibreCAD]; (4) select print preview and adjust
  the print scale as needed for the target sheet size and output
  format; (5) then print or save the result as a PDF.

  \amu_define title             (Drafting example)
  \amu_define image_views       (top)
  \amu_define image_size        (uxga)
  \amu_define html_image_w      (768)
  \amu_define output_scad_last  (true)

  \amu_include (include/amu/scope_diagrams_3d.amu)

  [LibreCAD]: https://librecad.org
*******************************************************************************/

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE example;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <transforms/base_cs.scad>;
    include <tools/2d/drafting/draft-base.scad>;

    length_unit_base = "mm";
    length_unit_default = "mm";

    draft_sheet_scale = 1;
    draft_sheet_size = "A";

    draft_layers_show = ["default", "sheet", "titleblock", "table", "note", "dim"];
    //draft_layers_show = ["default", "dim"];
    //draft_layers_show = ["default"];

    draft_config_map =
      map_merge
      (
        [ // override defaults
          ["line-use-hull", false],
          ["dim-offset", length(3)],
          ["dim-leader-length", length(3)],
          ["dim-line-distance", length(3)],
          ["dim-line-extension-length", length(5)]
        ],
        draft_config_map_style1
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
        fmap=draft_table_format_map_ccc,
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

          draft_arc(o=[o1-r1, 0], r=r3, s=2, fn=72);
        }

        draft_dim_center(r=r2);
        draft_dim_center(o=[o1-r1, 0], r=r3, v=45);

        draft_dim_radius(r=r1, v=360/t1*1);
        draft_dim_radius(r=r1-o1, v=360/t1*7);
        draft_dim_radius(r=o2, v=360/t2*4.5, u="in");

        draft_dim_radius(o=[o1-r1, 0], r=r3, v=0, d=true, off=0);

        draft_dim_angle(r=r1*(1+1/8), v1 = 360/t2*(t2-1));

        bt = bev([0, r1-o1-r3], 90, a1, r3);
        b1 = first(bt); b2 = second(bt); b3 = third(bt);
        draft_dim_angle(o=b1, r=r3*2, v1=[b1, b3], v2=[b1, b2], e=1+1/10);

        draft_dim_line(p1=[0,r1-o1-r3], d=r1*1.4, e=[r1*1.35, r1/4], u="mm");

        draft_dim_leader(p=[o2,0], l1=10, v2=0, l2=15, ts=[2,1.5], t=[str("D ", r4), str("X ", t2)]);
      }
    }

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "uxga";
    views     name "views" distance "600" views "top";

    variables set_opts_combine "sizes views";
    variables add_opts "--autocenter";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
