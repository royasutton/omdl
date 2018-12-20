//! Table data type operations.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2015-2018

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

    \amu_define group_name  (Tables)
    \amu_define group_brief (Table data type and operations.)

  \amu_include (include/amu/pgid_path_pstem_pg.amu)
*******************************************************************************/

include <../console.scad>;
include <datatypes-base.scad>;

//----------------------------------------------------------------------------//
// group.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)

  \details

    \b Example

      \dontinclude \amu_scope(index=1).scad
      \skip include
      \until ( tsum=tsum );

    \b Result \include \amu_scope(index=1).log

*******************************************************************************/

//----------------------------------------------------------------------------//

//! Get the table row index that matches a table row identifier.
/***************************************************************************//**
  \param    r <matrix-CxR> The table data matrix (C-columns x R-rows).
  \param    ri <string> The row identifier.

  \returns  <integer> The row index where the identifier exists.
            If the identifier does not exists, returns \b empty_lst.
*******************************************************************************/
function table_get_row_index
(
  r,
  ri
) = first( search( [ri], r, 1, 0 ) );

//! Get the table row that matches a table row identifier.
/***************************************************************************//**
  \param    r <matrix-CxR> The table data matrix (C-columns x R-rows).
  \param    ri <string> The row identifier.

  \returns  <list-C> The table row where the row identifier exists.
            If the identifier does not exists, returns \b undef.
*******************************************************************************/
function table_get_row
(
  r,
  ri
) = r[ table_get_row_index(r, ri) ];

//! Get the table column index that matches a table column identifier.
/***************************************************************************//**
  \param    c <matrix-2xC> The table column matrix (2 x C-columns).
  \param    ci <string> The column identifier.

  \returns  <integer> The column index where the identifier exists.
            If the identifier does not exists, returns \b empty_lst.
*******************************************************************************/
function table_get_column_index
(
  c,
  ci
) = first( search( [ci], c, 1, 0 ) );

//! Get the table column that matches a table column identifier.
/***************************************************************************//**
  \param    c <matrix-2xC> The table column matrix (2 x C-columns).
  \param    ci <string> The column identifier.

  \returns  <list-2> The table column where the column identifier exists.
            If the identifier does not exists, returns \b undef.
*******************************************************************************/
function table_get_column
(
  c,
  ci
) = c[ table_get_column_index(c, ci) ];

//! Get the table cell value for a specified row and column identifier.
/***************************************************************************//**
  \param    r <matrix-CxR> The table data matrix (C-columns x R-rows).
  \param    c <matrix-2xC> The table column matrix (2 x C-columns).
  \param    ri <string> The row identifier.
  \param    ci <string> The column identifier.

  \returns  \<value> The value of the matrix cell [ri, ci].
            If either identifier does not exists, returns \b undef.
*******************************************************************************/
function table_get_value
(
  r,
  c,
  ri,
  ci
) = r[table_get_row_index(r,ri)][table_get_column_index(c,ci)];

//! Form a list of a select column across all table rows.
/***************************************************************************//**
  \param    r <matrix-CxR> The table data matrix (C-columns x R-rows).
  \param    c <matrix-2xC> The table column matrix (2 x C-columns).
  \param    ci <string> The column identifier.

  \returns  \<list> The list of a select column across all rows.
            If the identifier does not exists, returns \b undef.
*******************************************************************************/
function table_get_columns
(
  r,
  c,
  ci
) = table_exists(r,c,ci=ci) ?
    eselect(table_get_copy(r,c,cs=[ci]),f=true)
  : undef;

//! Form a list of all table row identifiers.
/***************************************************************************//**
  \param    r <matrix-CxR> The table data matrix (C-columns x R-rows).

  \returns  \<list> The list of all row identifiers.

  \details

  \note     This functions assumes the first element of each table row
            to be the row identifier, as enforced by the table_check().
            As an alternative, the function table_get_columns(), of
            the form table_get_columns(r, c, "id"), may be used
            without this assumption.
*******************************************************************************/
function table_get_row_ids
(
  r
) = eselect(r,f=true);

//! Form a list of all table column identifiers.
/***************************************************************************//**
  \param    c <matrix-2xC> The table column matrix (2 x C-columns).

  \returns  \<list> The list of all column identifiers.

  \details

  \note     This functions assumes the first element of each table column
            to be the column identifier.
*******************************************************************************/
function table_get_column_ids
(
  c
) = eselect(c,f=true);

//! Test the existence of a table row and column identifier.
/***************************************************************************//**
  \param    r <matrix-CxR> The table data matrix (C-columns x R-rows).
  \param    c <matrix-2xC> The table column matrix (2 x C-columns).
  \param    ri <string> The row identifier.
  \param    ci <string> The column identifier.

  \returns  \b true if the row and column identifier exists, and
            \b false otherwise.
*******************************************************************************/
function table_exists
(
  r,
  c,
  ri,
  ci
) = ( is_defined(ri) && is_defined(ci) ) ?
      is_defined(table_get_value(r, c, ri, ci))
  : ( is_defined(ri) && not_defined(ci) ) ?
      !is_empty(table_get_row_index(r,ri))
  : ( not_defined(ri) && is_defined(ci) ) ?
      !is_empty(table_get_column_index(c,ci))
  : false;

//! Get the size of a table.
/***************************************************************************//**
  \param    r <matrix-CxR> The table data matrix (C-columns x R-rows).
  \param    c <matrix-2xC> The table column matrix (2 x C-columns).

  \returns  <decimal> The table size.

  \details

    The size is reported as: (1) The number of rows when only the \p r
    parameter is specified. (2) The number of columns when only the \p c
    parameter is specified. (3) The (r * columns) when both parameters
    are specified.
*******************************************************************************/
function table_get_size
(
  r,
  c
) = ( is_defined(r) && not_defined(c) ) ? len( r )
  : ( not_defined(r) && is_defined(c) ) ? len( c )
  : len( r ) * len( c );

//! Create a new matrix from select rows and columns of a table.
/***************************************************************************//**
  \param    r <matrix-CxR> The table data matrix (C-columns x R-rows).
  \param    c <matrix-2xC> The table column matrix (2 x C-columns).
  \param    rs <string-list> A list of selected row identifiers.
  \param    cs <string-list> A list of selected column identifiers.

  \returns  <matrix> A matrix of the selected rows and columns.
*******************************************************************************/
function table_get_copy
(
  r,
  c,
  rs,
  cs
) =
[
  for ( r_iter = r )
    if
    (
      not_defined( rs ) || is_empty( rs ) ||
      !is_empty( first( search( r_iter, rs, 1, 0 ) ) )
    )
    [
      for ( c_iter = c )
        if
        (
          not_defined( cs ) || is_empty( cs ) ||
          !is_empty( first( search( c_iter, cs, 1, 0 ) ) )
        )
          table_get_value(r, c, r_iter, c_iter)
    ]
];

//! Sum select rows and columns of a table.
/***************************************************************************//**
  \param    r <matrix-CxR> The table data matrix (C-columns x R-rows).
  \param    c <matrix-2xC> The table column matrix (2 x C-columns).
  \param    rs <string-list> A list of selected row identifiers.
  \param    cs <string-list> A list of selected column identifiers.

  \returns  \<list> A list with the sum of each selected rows and columns.
*******************************************************************************/
function table_get_sum
(
  r,
  c,
  rs,
  cs
) = sum( table_get_copy(r, c, rs, cs) );

//! Perform basic validation/checks on a table and return errors.
/***************************************************************************//**
  \param    r <matrix-CxR> The table data matrix (C-columns x R-rows).
  \param    c <matrix-2xC> The table column matrix (2 x C-columns).

  \returns  <list-N> A list of table format errors.

  \details

    Check that: (1) the first table column identifier is 'id'. (2) Make
    sure that each row has the same number of columns as defined in the
    columns vector. (3) Make sure that there are no repeating column
    identifiers. (4) Make sure that there are no repeating row
    identifiers. When there are no errors, the \b empty_lst is
    returned.
*******************************************************************************/
function table_errors
(
  r,
  c
) =
  let
  (
    // (1) first word of first column should be 'id'
    ec1 =
    [
      if ( first( first(c) ) != "id")
        str ("table column 0 should be 'id'")
    ],

    // (2) each row has correct column count
    ec2 =
    [
      let (col_cnt = table_get_size(c=c))
      for ( r_iter = r )
        if ( col_cnt !=  len ( r_iter ) )
          str
          (
            "row ", table_get_row_index(r, r_iter),
            ", id=[", first(r_iter), "]",
            ", has incorrect column count=[", len ( r_iter ),"]"
          )
    ],

    // (3) no repeat column identifiers
    ec3 =
    [
      for ( c_iter = c )
        if ( len(first(search([first(c_iter)], c, 0, 0))) > 1 )
          str("repeating column identifier [", first(c_iter), "]")
    ],

    // (4) no repeat row identifiers
    ec4 =
    [
      for ( r_iter = r )
        if ( len(first(search([first(r_iter)], r, 0, 0))) > 1 )
          str("repeating row identifier [", first(r_iter), "]")
    ]
  )
  concat(ec1, ec2, ec3, ec4);


//! Perform basic validation/checks on a table and output errors to console.
/***************************************************************************//**
  \param    r <matrix-CxR> The table data matrix (C-columns x R-rows).
  \param    c <matrix-2xC> The table column matrix (2 x C-columns).
  \param    verbose <boolean> Be verbose during check.

  \details

    Check that: (1) the first table column identifier is 'id'. (2) Make
    sure that each row has the same number of columns as defined in the
    columns vector. (3) Make sure that there are no repeating column
    identifiers. (4) Make sure that there are no repeating row
    identifiers.
*******************************************************************************/
module table_check
(
  r,
  c,
  verbose = false
)
{
  if (verbose) log_info("begin table check");

  // (1) first word of first column should be 'id'
  if ( first( first(c) ) != "id")
  {
    log_warn ("table column 0 should be 'id'");
  }
  else
  {
    if (verbose) log_info ("row identifier found at column zero.");
  }

  // (2) each row has correct column count
  if (verbose) log_info ("checking row column counts.");
  col_cnt = table_get_size(c=c);
  for ( r_iter = r )
  {
    if ( col_cnt !=  len ( r_iter ) )
    {
      log_error
      (
        str
        (
          "row ", table_get_row_index(r, r_iter),
          ", id=[", first(r_iter), "]",
          ", has incorrect column count=[", len ( r_iter ),"]"
        )
      );
    }
  }

  // (3) no repeat column identifiers
  if (verbose) log_info ("checking for repeat column identifiers.");
  for ( c_iter = c )
    if ( len(first(search([first(c_iter)], c, 0, 0))) > 1 )
      log_warn ( str("repeating column identifier [", first(c_iter), "]") );

  // (4) no repeat row identifiers
  if (verbose) log_info ("checking for repeat row identifiers.");
  for ( r_iter = r )
    if ( len(first(search([first(r_iter)], r, 0, 0))) > 1 )
      log_warn ( str("repeating row identifier [", first(r_iter), "]") );

  if (verbose)
  {
    log_info
    (
      str (
        "table size: ",
        table_get_size(r=r), " rows by ",
        table_get_size(c=c), " columns."
      )
    );

    log_info("end table check");
  }
}

//! Dump a table to the console.
/***************************************************************************//**
  \param    r <matrix-CxR> The table data matrix (C-columns x R-rows).
  \param    c <matrix-2xC> The table column matrix (2 x C-columns).
  \param    rs <string-list> A list of selected row identifiers.
  \param    cs <string-list> A list of selected column identifiers.
  \param    number <boolean> Number the table rows.

  \details

    Output each table row to the console. To output only select rows and
    columns, assign the desired identifiers to \p rs and \p cs.
    For example to output only the column identifiers 'c1' and 'c2', assign
    <tt>cs = ["c1", "c2"]</tt>.
*******************************************************************************/
module table_dump
(
  r,
  c,
  rs,
  cs,
  number = true
)
{
  maxr0 = max( [for (r_iter = r) len( first(r_iter) )] ) + 1;
  maxc0 = max( [for (c_iter = c) len( first(c_iter) )] ) + 1;
  maxc1 = max( [for (c_iter = c) len( c_iter[1] )] ) + 1;

  for ( r_iter = r )
  {
    if
    (
      not_defined( rs ) || is_empty( rs ) ||
      !is_empty( first( search( r_iter, rs, 1, 0 ) ) )
    )
    {
      if ( number )
      {
        log_echo();
        log_echo( str("row: ", table_get_row_index(r, r_iter)) );
      }
      for ( c_iter = c )
      {
        if
        (
          not_defined( cs ) || is_empty( cs ) ||
          !is_empty( first( search( c_iter, cs, 1, 0 ) ) )
        )
        {
          log_echo
          (
            str
            (
              "[", first(r_iter), "]", chr(consts(maxr0-len(first(r_iter)), 32)),
              "[", first(c_iter), "]", chr(consts(maxc0-len(first(c_iter)), 32)),
              "(", c_iter[1], ")", chr(consts(maxc1-len(c_iter[1]), 32)),
              "= [", table_get_value(r, c, r_iter, c_iter), "]"
            )
          );
        }
      }
    }
  }

  if ( number ) {
    log_echo();
    log_echo
    (
      str (
        "table size: ",
        table_get_size(r=r), " rows by ",
        table_get_size(c=c), " columns."
      )
    );
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
    include <units/length.scad>;
    include <datatypes/table.scad>;

    base_unit_length = "mm";

    table_cols =
    [ // id,  description
      ["id",  "row identifier"],
      ["ht",  "head type [r|h|s]"],
      ["td",  "thread diameter"],
      ["tl",  "thread length"],
      ["hd",  "head diameter"],
      ["hl",  "head length"],
      ["nd",  "hex nut flat-to-flat width"],
      ["nl",  "hex nut length"]
    ];

    table_rows =
    [ //     id,  ht,     td,     tl,   hd,    hl,    nd,          nl
      ["m3r08r", "r",  3.000,   8.00, 5.50, 3.000,  5.50, length(1.00, "in")],
      ["m3r14r", "r",  3.000,  14.00, 5.50, 3.000,  5.50, length(1.25, "in")],
      ["m3r16r", "r",  3.000,  16.00, 5.50, 3.000,  5.50, length(1.50, "in")],
      ["m3r20r", "r",  3.000,  20.00, 5.50, 3.000,  5.50, length(1.75, "in")]
    ];

    table_check( table_rows, table_cols, true );
    table_dump( table_rows, table_cols );

    m3r16r_tl = table_get_value( table_rows, table_cols, "m3r16r", "tl" );

    if ( table_exists( c=table_cols, ci="nl" ) )
      echo ( "metric 'nl' available" );

    table_ids = table_get_row_ids( table_rows );
    table_cols_tl = table_get_columns( table_rows, table_cols, "tl" );

    echo ( table_ids=table_ids );
    echo ( table_cols_tl=table_cols_tl );

    tnew = table_get_copy( table_rows, table_cols, cs=["tl", "nl"] );
    tsum = table_get_sum( table_rows, table_cols, cs=["tl", "nl"] );

    echo ( m3r16r_tl=m3r16r_tl );
    echo ( tnew=tnew );
    echo ( tsum=tsum );
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {config_base,config_csg}.mfs;
    include --path "${INCLUDE_PATH}" script_std.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
