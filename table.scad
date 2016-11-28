//! Data table encoding and lookup.
/***************************************************************************//**
  \file   table.scad
  \author Roy Allen Sutton
  \date   2015-2016

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
include <math.scad>;

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

    result:  \include table_example_na.log

  @{
*******************************************************************************/
//----------------------------------------------------------------------------//

//! Get the index for a table row identifier.
/***************************************************************************//**
  \param    rows <2d-vector> A two dimensional vector (r-tuple x c-tuple)
            containing the table rows.
  \param    row_id <string> The row identifier string to locate.
  \returns  <decimal> The row index where the identifier is located. If the
            identifier does not exists, returns \b [].
*******************************************************************************/
function table_get_row_idx
(
  rows,
  row_id
) = search( [row_id], rows, 1, 0 )[0];

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

//! Get the first table row.
/***************************************************************************//**
  \param    rows <2d-vector> A two dimensional vector (r-tuple x c-tuple)
            containing the table rows.
  \returns  <vector> The first table row. If the table is empty,
            returns \b undef.
*******************************************************************************/
function table_first_row
(
  rows
) = rows[ 0 ];

//! Get the last table row.
/***************************************************************************//**
  \param    rows <2d-vector> A two dimensional vector (r-tuple x c-tuple)
            containing the table rows.
  \returns  <vector> The last table row. If the table is empty,
            returns \b undef.
*******************************************************************************/
function table_last_row
(
  rows
) = rows[ len( rows ) - 1 ];

//! Get the index for a table column identifier.
/***************************************************************************//**
  \param    cols <2d-vector> A two dimensional vector (c-tuple x 1-tuple)
            containing the table columns.
  \param    col_id <string> The column identifier string to locate.
  \returns  <decimal> The column index where the identifier is located. If the
            identifier does not exists, returns \b [].
*******************************************************************************/
function table_get_col_idx
(
  cols,
  col_id
) = search( [col_id], cols, 1, 0 )[0];

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

//! Get the first table column.
/***************************************************************************//**
  \param    cols <2d-vector> A two dimensional vector (c-tuple x 1-tuple)
            containing the table columns.
  \returns  <vector> The first table column. If the table is empty,
            returns \b undef.
*******************************************************************************/
function table_first_col
(
  cols
) = cols[ 0 ];

//! Get the last table column.
/***************************************************************************//**
  \param    cols <2d-vector> A two dimensional vector (c-tuple x 1-tuple)
            containing the table columns.
  \returns  <vector> The last table column. If the table is empty,
            returns \b undef.
*******************************************************************************/
function table_last_col
(
  cols
) = cols[ len( cols ) - 1];

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
) = ( (row_id != undef) && (col_id != undef) ) ?
      ( table_get(trows, tcols, row_id, col_id) != undef )
  : ( (row_id != undef) && (col_id == undef) ) ?
      ( table_get_row_idx(rows,row_id) != [] )
  : ( (row_id == undef) && (col_id != undef) ) ?
      ( table_get_col_idx(cols,col_id) != [] )
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
) = ( (rows != undef) && (cols == undef) ) ? len( rows )
  : ( (rows == undef) && (cols != undef) ) ? len( cols )
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

  // column one should be 'id'
  if ( cols[0][0] != "id")
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
          ", id=[", r[0], "]",
          ", has incorrect column count=[", len ( r ),"]"
        )
      );
    }
  }

  // no repeat column identifiers
  if (verbose) log_info ("checking for repeat column identifiers.");
  for (c = cols)
    if ( len(search( [c[0]] , cols, 0, 0 )[0]) > 1 )
      log_warn ( str("repeating column identifier [", c[0], "]") );

  // no repeat row identifiers
  if (verbose) log_info ("checking for repeat row identifiers.");
  for (r = rows)
    if ( len(search( [r[0]] , rows, 0, 0 )[0]) > 1 )
      log_warn ( str("repeating row identifier [", r[0], "]") );

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
  maxr0 = max( [for (r = rows) (len(r[0]))] ) + 1;
  maxc0 = max( [for (c = cols) (len(c[0]))] ) + 1;
  maxc1 = max( [for (c = cols) (len(c[1]))] ) + 1;

  for ( r = rows )
  {
    if
    (
      ( search( r, rows_sel, 1, 0 )[0] != [] ) ||
      ( len( rows_sel ) == 0 ) ||
      ( len( rows_sel ) == undef )
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
          ( search( c, cols_sel, 1, 0 )[0] != [] ) ||
          ( len( cols_sel ) == 0 ) ||
          ( len( cols_sel ) == undef )
        )
        {
          log_echo (
            str (
              "[", r[0], "]", chr([for (i=[0:1:maxr0-len(r[0])]) 32]),
              "[", c[0], "]", chr([for (i=[0:1:maxc0-len(c[0])]) 32]),
              "(", c[1], ")", chr([for (i=[0:1:maxc1-len(c[1])]) 32]),
              "= [", table_get(rows, cols, r, c), "]"
            )
          );
        }
      }
    }
  }

  if ( number ) {
    log_echo();
    log_echo (
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
      ( search( r, rows_sel, 1, 0 )[0] != [] ) ||
      ( len( rows_sel ) == 0 ) ||
      ( len( rows_sel ) == undef )
    )
    [
      for ( c = cols )
        if
        (
          ( search( c, cols_sel, 1, 0 )[0] != [] ) ||
          ( len( cols_sel ) == 0 ) ||
          ( len( cols_sel ) == undef )
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
) = sum_v ( table_copy(rows, cols, rows_sel, cols_sel) );

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
     [// id,  description
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

    tnew = table_copy( table_rows, table_cols, cols_sel=["tl", "nl"] );
    tsum = table_sum( table_rows, table_cols, cols_sel=["tl", "nl"] );

    echo ( m3r16r_tl=m3r16r_tl );
    echo ( tnew=tnew );
    echo ( tsum=tsum );
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {config_std,config_csg}.mfs;
    defines   name "na" define "na" strings "na";
    variables add_opts_combine "na";
    include --path "${INCLUDE_PATH}" script_std.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
