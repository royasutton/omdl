//! Sizable polyhedra generated from shape database.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2024

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

    \amu_define group_name  (Polyhedrons db)
    \amu_define group_brief (Sizable polyhedra generated from shape database.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// group and macros.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_define includes_required_add
  (
    database/geometry/polyhedra/polyhedra_all.scad
  )
  \amu_include (include/amu/includes_required.amu)

  \details

    To work with a smaller data table set, include the specific table
    of interest rather than \ref polyhedra_all.scad, shown as required
    above. Here is an example that uses a limited set.

    \amu_define title         (Cupolas example)
    \amu_define image_views   (top bottom diag)
    \amu_define image_size    (sxga)

    \amu_include (include/amu/scope_diagrams_3d.amu)

    For a list of all available polyhedra, see the polyhedra
    \ref database_geometry_polyhedra "datbase".
*******************************************************************************/

//----------------------------------------------------------------------------//

//! <map> The default polyhedra data table columns.
ph_db_dtc = dtc_polyhedra_polyhedra_all;

//! \<table> The default polyhedra data table rows.
ph_db_dtr = dtr_polyhedra_polyhedra_all;

//! Get the number of shape identifiers in data table.
/***************************************************************************//**
  \param    tr \<table> The polyhedra data table rows.

  \returns  <integer>  The total number of identifiers
*******************************************************************************/
function ph_db_get_size
(
  tr = ph_db_dtr
) = let ( ids = table_get_row_ids( r=tr ) )
    is_list( ids ) ? len(ids) : undef;

//! Get data table identifier name (or names).
/***************************************************************************//**
  \param    n <integer> An index number.
  \param    tr \<table> The polyhedra data table rows.

  \returns  <string | string-list> The identifier name at index \c n or
            the list of all identifier names for \p n = 0.

  \details

    Identifiers numbering start from 1 and end at ph_db_get_size().
*******************************************************************************/
function ph_db_get_id
(
  n,
  tr = ph_db_dtr
) = let ( ids = table_get_row_ids( r=tr ) )
    (n == 0) ? ids : ids[n-1];

//! Construct a named polyhedron.
/***************************************************************************//**
  \param    id <string> The polyhedron identifier name.

  \param    size <decimal-list-3 | decimal> A list [x, y, z] of decimals
            or a single decimal for (x=y=z).

  \param    align <decimal-list-3 | decimal> A list [x, y, z] of decimals
            or a single decimal for (x=y=z).

  \param    yz <boolean> An internal dataset rotation control variable.

  \param    tr \<table> The polyhedra data table rows.
  \param    tc <map> The polyhedra data table columns.

  \details

    Each axis may be assigned an alignment value of 0, 1 or 2 as
    summarized in the following table.

       align          | value description
      :---------------|:---------------------------------
       0              | do not align axis
       1              | align axis at lower shape bounds
       2              | align axis at upper shape bounds

    Using this module, polyhedron can be incorporated into designs as
    shown in this simple example.

    \amu_define title         (Design example)
    \amu_define image_views   (front diag)
    \amu_define image_size    (sxga)
    \amu_define scope_id      (example_design)

    \amu_include (include/amu/scope_diagrams_3d.amu)
*******************************************************************************/
module ph_db_polyhedron
(
  id,
  size,
  align,
  yz = true,
  tr = ph_db_dtr,
  tc = ph_db_dtc
)
{
  shape_id_exists = table_exists(tr, tc, ri=id);

  // shape id must exists
  assert
  (
    shape_id_exists,
    str
    (
      "id does not exists for id=[", id,
      "], tr=[ph_db_dtr], and tc=[ph_db_dtc]."
    )
  );

  // only when id exists
  if ( shape_id_exists )
  {
    // lookup (1) coordinates and (2) face-list
    c  = table_get_value(tr, tc, id, "c");
    f  = table_get_value(tr, tc, id, "f");

    // data structured more for shape viewing; rotate y to z
    r  = rotate_p(c, [yz ? 90 : 0, 0, 0]);

    // x, y, and z size
    sx = defined_e_or(size, 0, size);
    sy = defined_e_or(size, 1, sx);
    sz = defined_e_or(size, 2, sy);

    // resize iff size has be defined
    s = is_undef(size) ? r : resize_p(r, [sx, sy, sz]);

    // get bounding box for alignment
    b = polytope_limits(s, f, s=false);

    ax = defined_e_or(align, 0, 0);
    ay = defined_e_or(align, 1, 0);
    az = defined_e_or(align, 2, 0);

    tx = defined_e_or(b[0], ax-1, 0);
    ty = defined_e_or(b[1], ay-1, 0);
    tz = defined_e_or(b[2], az-1, 0);

    // translate to alignment location
    m = yz
      ? translate_p(s, [tx, ty, -tz] )
      : translate_p(s, [tx, -ty, tz] );

    polyhedron(m, f);
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
    include <database/geometry/polyhedra/cupolas.scad>;
    include <shapes/polyhedron_db.scad>;

    ph_db_dtc = dtc_polyhedra_cupolas;
    ph_db_dtr = dtr_polyhedra_cupolas;

    gx = ceil( sqrt( ph_db_get_size() ) );
    gy = gx;

    sx = 2.25;
    sy = sx;

    for ( i = [ 1 : ph_db_get_size() ] )
      translate([sx * (i%gx), sy * (floor(i/gx)%gy), 0])
        ph_db_polyhedron( id=ph_db_get_id(i) );

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "top bottom diag";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;

BEGIN_SCOPE example_design;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <database/geometry/polyhedra/johnson.scad>;
    include <shapes/polyhedron_db.scad>;

    ph_db_dtc = dtc_polyhedra_johnson;
    ph_db_dtr = dtr_polyhedra_johnson;

    $fn = 5;

    // shape sizes
    h1 = 1; s1 = [10, 10, h1];
    h2 = 5; s2 = 2;
    h3 = 3; s3 = [15, 15, h3];

    translate([0, 0, h1])
    {
      ph_db_polyhedron( id=ph_db_get_id(65), size=s1, align=[0,0,2] );

      rotate(-360/4/$fn)
      cylinder(r=s2, h=h2);

      translate([0, 0, h2]) mirror([0,0,1])
      ph_db_polyhedron( id=ph_db_get_id(41), size=s3, align=[0,0,2] );
    }

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_png2eps}.mfs;
    table_unset_all sizes;

    images    name "sizes" types "sxga";
    views     name "views" views "front diag";

    variables set_opts_combine "sizes views";
    variables add_opts "--viewall --autocenter --view=axes";

    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
