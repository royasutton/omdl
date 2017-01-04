//! Data table encoding and lookup.
/***************************************************************************//**
  \file   table.scad
  \author Roy Allen Sutton
  \date   2015-2017

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

  \ingroup data data_table
*******************************************************************************/

use <console.scad>;
include <primitives.scad>;

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \addtogroup data
  @{

  \defgroup data_table Datatable
  \brief    Data table encoding and lookup.

  \details

    \b Example

      \dontinclude table_example.scad
      \skip use
      \until ( tsum=tsum );

    \b Result \include table_example.log

  @{
*******************************************************************************/
//----------------------------------------------------------------------------//

//! Get the index for a table row identifier.
/***************************************************************************//**
  \param    rows <2d-vector> A two dimensional vector (r-tuple x c-tuple)
            containing the table rows.
  \param    row_id <string> The row identifier string to locate.
  \returns  <decimal> The row index where the identifier is located. If the
            identifier does not exists, returns \b empty_v.
*******************************************************************************/
function table_get_row_idx
(
  rows,
  row_id
) = first( search( [row_id], rows, 1, 0 ) );

//! Get the row for a table row identifier.
/***************************************************************************//**
  \param    rows <2d-vector> A two dimensional vector (r-tuple x c-tuple)
            containing the table rows.
  \param    row_id <string> The row identifier string to locate.
  \returns  <vector> The row where the row identifier is located. If the
            identifier does not exists, returns \b undef.
*******************************************************************************/
function table_get_row
(
  rows,
  row_id
) = rows[ table_get_row_idx(rows, row_id) ];

//! Get the index for a table column identifier.
/***************************************************************************//**
  \param    cols <2d-vector> A two dimensional vector (c-tuple x 1-tuple)
            containing the table columns.
  \param    col_id <string> The column identifier string to locate.
  \returns  <decimal> The column index where the identifier is located. If the
            identifier does not exists, returns \b empty_v.
*******************************************************************************/
function table_get_col_idx
(
  cols,
  col_id
) = first( search( [col_id], cols, 1, 0 ) );

//! Get the column for a table column identifier.
/***************************************************************************//**
  \param    cols <2d-vector> A two dimensional vector (c-tuple x 1-tuple)
            containing the table columns.
  \param    col_id <string> The column identifier string to locate.
  \returns  <vector> The column where the row identifier is located. If the
            identifier does not exists, returns \b undef.
*******************************************************************************/
function table_get_col
(
  cols,
  col_id
) = cols[ table_get_col_idx(cols, col_id) ];

//! Get the value for a table row and column identifier.
/***************************************************************************//**
  \param    rows <2d-vector> A two dimensional vector (r-tuple x c-tuple)
            containing the table rows.
  \param    cols <2d-vector> A two dimensional vector (c-tuple x 1-tuple)
            containing the table columns.
  \param    row_id <string> The row identifier string to locate.
  \param    col_id <string> The column identifier string to locate.
  \returns  <decimal|string> The value at the located \p row_id and \p col_id.
            If it does not exists, returns \b undef.
*******************************************************************************/
function table_get
(
  rows,
  cols,
  row_id,
  col_id
) = rows[table_get_row_idx(rows,row_id)][table_get_col_idx(cols,col_id)];

//! Form a vector from the specified column of each table row.
/***************************************************************************//**
  \param    rows <2d-vector> A two dimensional vector (r-tuple x c-tuple)
            containing the table rows.
  \param    cols <2d-vector> A two dimensional vector (c-tuple x 1-tuple)
            containing the table columns.
  \param    col_id <string> The column identifier string.
  \returns  <vector> The vector formed by selecting the \p col_id for
            each row in the table.
            If column does not exists, returns \b undef.
*******************************************************************************/
function table_get_row_cols
(
  rows,
  cols,
  col_id
) = table_exists(rows,cols,col_id=col_id) ?
    eselect(table_copy(rows,cols,cols_sel=[col_id]),f=true)
  : undef;

//! Form a vector of each table row identifier.
/***************************************************************************//**
  \param    rows <2d-vector> A two dimensional vector (r-tuple x c-tuple)
            containing the table rows.
  \returns  <vector> The vector of table row identifiers.
            If column \c "id" does not exists, returns \b undef.

  \details

  \note     This functions assumes the first element of each table row to
            be the row identifier, as enforced by the table_check(). As
            an alternative, the function table_get_row_cols(), of the form
            table_get_row_cols(rows, cols, "id"), may be used without this
            assumption.
*******************************************************************************/
function table_get_row_ids
(
  rows
) = eselect(rows,f=true);

//! Test the existence of a table row and column identifier.
/***************************************************************************//**
  \param    rows <2d-vector> A two dimensional vector (r-tuple x c-tuple)
            containing the table rows.
  \param    cols <2d-vector> A two dimensional vector (c-tuple x 1-tuple)
            containing the table columns.
  \param    row_id <string> The row identifier string to locate.
  \param    col_id <string> The column identifier string to locate.
  \returns  \b true if the row and column identifier exists, otherwise
            returns \b false.
*******************************************************************************/
function table_exists
(
  rows,
  cols,
  row_id,
  col_id
) = ( is_defined(row_id) && is_defined(col_id) ) ?
      is_defined(table_get(trows, tcols, row_id, col_id))
  : ( is_defined(row_id) && not_defined(col_id) ) ?
      !is_empty(table_get_row_idx(rows,row_id))
  : ( not_defined(row_id) && is_defined(col_id) ) ?
      !is_empty(table_get_col_idx(cols,col_id))
  : false;

//! Get the size of a table.
/***************************************************************************//**
  \param    rows <2d-vector> A two dimensional vector (r-tuple x c-tuple)
            containing the table rows.
  \param    cols <2d-vector> A two dimensional vector (c-tuple x 1-tuple)
            containing the table columns.
  \returns  <decimal> The table size.

  \details

    The size is reported as: (1) The number of rows when only the \p rows
    parameter is specified. (2) The number of columns when only the \p cols
    parameter is specified. (3) The (rows * columns) when both parameters
    are specified.
*******************************************************************************/
function table_size
(
  rows,
  cols
) = ( is_defined(rows) && not_defined(cols) ) ? len( rows )
  : ( not_defined(rows) && is_defined(cols) ) ? len( cols )
  : len( rows ) * len( cols );

//! Perform some basic validation/checks on a table.
/***************************************************************************//**
  \param    rows <2d-vector> A two dimensional vector (r-tuple x c-tuple)
            containing the table rows.
  \param    cols <2d-vector> A two dimensional vector (c-tuple x 1-tuple)
            containing the table columns.
  \param    verbose <boolean> Be verbose during check.

  \details

    Check that: (1) the first table column identifier is 'id'. (2) Make
    sure that each row has the same number of columns as defined in the
    columns vector. (3) Make sure that there are no repeating column
    identifiers. (4) Make sure that there are no repeating row identifiers.
*******************************************************************************/
module table_check
(
  rows,
  cols,
  verbose=false
)
{
  if (verbose) log_info("begin table check");

  // first word of first column should be 'id'
  if ( first( first(cols) ) != "id")
  {
    log_warn ("table column 0 should be 'id'");
  }
  else
  {
    if (verbose) log_info ("row identifier found at column zero.");
  }

  // each row has correct column count
  if (verbose) log_info ("checking row column counts.");
  col_cnt = table_size(cols=cols);
  for ( r = rows )
  {
    if ( col_cnt !=  len ( r ) )
    {
      log_error (
        str (
          "row ", table_get_row_idx(rows, r),
          ", id=[", first(r), "]",
          ", has incorrect column count=[", len ( r ),"]"
        )
      );
    }
  }

  // no repeat column identifiers
  if (verbose) log_info ("checking for repeat column identifiers.");
  for (c = cols)
    if ( len(first(search([first(c)], cols, 0, 0))) > 1 )
      log_warn ( str("repeating column identifier [", first(c), "]") );

  // no repeat row identifiers
  if (verbose) log_info ("checking for repeat row identifiers.");
  for (r = rows)
    if ( len(first(search([first(r)], rows, 0, 0))) > 1 )
      log_warn ( str("repeating row identifier [", first(r), "]") );

  if (verbose)
  {
    log_info (
      str (
        "table size: ",
        table_size(rows=rows), " rows by ",
        table_size(cols=cols), " columns."
      )
    );

    log_info("end table check");
  }
}

//! Dump a table to the console.
/***************************************************************************//**
  \param    rows <2d-vector> A two dimensional vector (r-tuple x c-tuple)
            containing the table rows.
  \param    cols <2d-vector> A two dimensional vector (c-tuple x 1-tuple)
            containing the table columns.
  \param    rows_sel <1d-vector> A n-tuple vector of row identifier to select.
  \param    cols_sel <1d-vector> A n-tuple vector of column identifier to select.
  \param    number <boolean> Number the table rows.

  \details

    Output each table row to the console. To output only select rows and
    columns, assign the desired identifiers to \p rows_sel and \p cols_sel.
    For example to output only the column identifiers 'c1' and 'c2', assign
    <tt>cols_sel = ["c1", "c2"]</tt>.
*******************************************************************************/
module table_dump
(
  rows,
  cols,
  rows_sel,
  cols_sel,
  number=true
)
{
  maxr0 = max( [for (r = rows) len( first(r) )] ) + 1;
  maxc0 = max( [for (c = cols) len( first(c) )] ) + 1;
  maxc1 = max( [for (c = cols) len( c[1] )] ) + 1;

  for ( r = rows )
  {
    if
    (
      not_defined( rows_sel ) || is_empty( rows_sel ) ||
      !is_empty( first( search( r, rows_sel, 1, 0 ) ) )
    )
    {
      if ( number )
      {
        log_echo();
        log_echo( str("row: ", table_get_row_idx(rows, r)) );
      }
      for ( c = cols )
      {
        if
        (
          not_defined( cols_sel ) || is_empty( cols_sel ) ||
          !is_empty( first( search( c, cols_sel, 1, 0 ) ) )
        )
        {
          log_echo
          (
            str (
              "[", first(r), "]", chr(consts(maxr0-len(first(r)), 32)),
              "[", first(c), "]", chr(consts(maxc0-len(first(c)), 32)),
              "(", c[1], ")", chr(consts(maxc1-len(c[1]), 32)),
              "= [", table_get(rows, cols, r, c), "]"
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
        table_size(rows=rows), " rows by ",
        table_size(cols=cols), " columns."
      )
    );
  }
}

//! Create a copy of select rows and columns of a table.
/***************************************************************************//**
  \param    rows <2d-vector> A two dimensional vector (r-tuple x c-tuple)
            containing the table rows.
  \param    cols <2d-vector> A two dimensional vector (c-tuple x 1-tuple)
            containing the table columns.
  \param    rows_sel <1d-vector> A n-tuple vector of row identifier to select.
  \param    cols_sel <1d-vector> A n-tuple vector of column identifier to select.
  \returns  <2d-vector> The selected rows and columns of the table.
*******************************************************************************/
function table_copy
(
  rows,
  cols,
  rows_sel,
  cols_sel
) =
[
  for ( r = rows )
    if
    (
      not_defined( rows_sel ) || is_empty( rows_sel ) ||
      !is_empty( first( search( r, rows_sel, 1, 0 ) ) )
    )
    [
      for ( c = cols )
        if
        (
          not_defined( cols_sel ) || is_empty( cols_sel ) ||
          !is_empty( first( search( c, cols_sel, 1, 0 ) ) )
        )
          table_get(rows, cols, r, c)
    ]
];

//! Sum select rows and columns of a table.
/***************************************************************************//**
  \param    rows <2d-vector> A two dimensional vector (r-tuple x c-tuple)
            containing the table rows.
  \param    cols <2d-vector> A two dimensional vector (c-tuple x 1-tuple)
            containing the table columns.
  \param    rows_sel <1d-vector> A vector n-tuple of row identifier to select.
  \param    cols_sel <1d-vector> A vector n-tuple of column identifier to select.
  \returns  <1d-vector> The sum of the selected rows and columns of the table.
*******************************************************************************/
function table_sum
(
  rows,
  cols,
  rows_sel,
  cols_sel
) = sum( table_copy(rows, cols, rows_sel, cols_sel) );

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE example;
  BEGIN_OPENSCAD;
    include <units_length.scad>;
    use     <table.scad>;

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
    [ //     id,  ht,     td,     tl,   hd,    hl,    nd,                  nl
      ["m3r08r", "r",  3.000,   8.00, 5.50, 3.000,  5.50, convert_length(1.00, "in")],
      ["m3r14r", "r",  3.000,  14.00, 5.50, 3.000,  5.50, convert_length(1.25, "in")],
      ["m3r16r", "r",  3.000,  16.00, 5.50, 3.000,  5.50, convert_length(1.50, "in")],
      ["m3r20r", "r",  3.000,  20.00, 5.50, 3.000,  5.50, convert_length(1.75, "in")]
    ];

    table_check( table_rows, table_cols, true );
    table_dump( table_rows, table_cols );

    m3r16r_tl = table_get( table_rows, table_cols, "m3r16r", "tl" );

    if ( table_exists( cols=table_cols, col_id="nl" ) )
      echo ( "metric 'nl' available" );

    table_ids = table_get_row_ids( table_rows );
    table_cols_tl = table_get_row_cols( table_rows, table_cols, "tl" );

    echo ( table_ids=table_ids );
    echo ( table_cols_tl=table_cols_tl );

    tnew = table_copy( table_rows, table_cols, cols_sel=["tl", "nl"] );
    tsum = table_sum( table_rows, table_cols, cols_sel=["tl", "nl"] );

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
