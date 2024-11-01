//! Table data structure and operations.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2015-2024

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

//----------------------------------------------------------------------------//
// group.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \amu_include (include/amu/group_in_parent_start.amu)
  \amu_include (include/amu/includes_required.amu)

  \details

    The table functions were originally coded with the row and column
    data as separate parameters. Some equivalent functions are provided
    that accept the row and column data as a single combined parameter,
    where <tt>t = [r, c];</tt> for convenience and are prefaced with
    the letter 'c'.

    \amu_define title (Table use)
    \amu_define scope_id (example_use)
    \amu_include (include/amu/scope.amu)
*******************************************************************************/

//----------------------------------------------------------------------------//
// Separate
//----------------------------------------------------------------------------//

//! \name Separate table data
//! @{

//! Get the table row index that matches a table row identifier.
/***************************************************************************//**
  \param    r \<table> The table row data matrix (C-columns x R-rows).
  \param    ri <string> The row identifier.

  \returns  <integer> The row index where the identifier exists.
            Returns \b undef if the identifier does not exists.
*******************************************************************************/
function table_get_row_index
(
  r,
  ri
) = let(i = first( search( [ri], r, 1, 0 ) ) )
    (i == empty_lst) ? undef : i;

//! Get the table row that matches a table row identifier.
/***************************************************************************//**
  \param    r \<table> The table row data matrix (C-columns x R-rows).
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
  \param    c <map> The table column identifier matrix (2 x C-columns).
  \param    ci <string> The column identifier.

  \returns  <integer> The column index where the identifier exists.
            Returns \b undef if the identifier does not exists.
*******************************************************************************/
function table_get_column_index
(
  c,
  ci
) = let(i = first( search( [ci], c, 1, 0 ) ) )
    (i == empty_lst) ? undef : i;

//! Get the table column that matches a table column identifier.
/***************************************************************************//**
  \param    c <map> The table column identifier matrix (2 x C-columns).
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
  \param    r \<table> The table row data matrix (C-columns x R-rows).
  \param    c <map> The table column identifier matrix (2 x C-columns).
  \param    ri <string> The row identifier.
  \param    ci <string> The column identifier.

  \returns  \<value> The value of the table cell <tt>[ri, ci]</tt>.
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
  \param    r \<table> The table row data matrix (C-columns x R-rows).
  \param    c <map> The table column identifier matrix (2 x C-columns).
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
    select_e(table_get_copy(r,c,cs=[ci]),f=true)
  : undef;

//! Get a row, a column, or a specific cell value from a table.
/***************************************************************************//**
  \param    r \<table> The table row data matrix (C-columns x R-rows).
  \param    c <map> The table column identifier matrix (2 x C-columns).
  \param    ri <string> The row identifier.
  \param    ci <string> The column identifier.

  \returns  (1) \<value> The value of the table cell <tt>[ri, ci]</tt>
            when both \p ri and \p ci are defined. (2) The row <list-R>
            when only \p ri is defined. (3) The column <list-C> when
            only \p ci is defined. (4) Returns \b undef when the
            specified row or column identifier is not present in the
            table or when both are undefined.

  \details

    This function combines the behavior of several other table access
    functions dependent on the supplied parameters.

    \b Example
    \code
    rows = table_get( r, c, ri );
    cols = table_get( r, c, ci=ci );
    cell = table_get( r, c, ri, ci );
    \endcode
*******************************************************************************/
function table_get
(
  r,
  c,
  ri,
  ci
) = let ( dr = is_defined(ri), dc = is_defined(ci) )
    ( dr && dc ) ? table_get_value(r, c, ri, ci)
  : dr ? table_get_row(r, ri)
  : dc ? table_get_columns(r, c, ci)
  : undef;

//! Form a list of all table row identifiers.
/***************************************************************************//**
  \param    r \<table> The table row data matrix (C-columns x R-rows).

  \returns  \<list> The list of all row identifiers.

  \details

    This functions assumes the first element of each table row to be
    the row identifier, as enforced by the table_check(). As an
    alternative, the function table_get_columns(), of the form
    table_get_columns(r, c, id), may be used without this assumption.
*******************************************************************************/
function table_get_row_ids
(
  r
) = select_e(r,f=true);

//! Form a list of all table column identifiers.
/***************************************************************************//**
  \param    c <map> The table column identifier matrix (2 x C-columns).

  \returns  \<list> The list of all column identifiers.

  \details

    This functions assumes the first element of each table column to be
    the column identifier.
*******************************************************************************/
function table_get_column_ids
(
  c
) = select_e(c,f=true);

//! Test the existence of a table row identifier, table column identifier, or both.
/***************************************************************************//**
  \param    r \<table> The table row data matrix (C-columns x R-rows).
  \param    c <map> The table column identifier matrix (2 x C-columns).
  \param    ri <string> The row identifier.
  \param    ci <string> The column identifier.

  \returns  \b true if the specified row and/or column identifier
            exists, and \b false otherwise.

  \details

    The functions can be used to check for a row or a column identifier
    alone, or can be use to check for the existence of a specific row
    and column combination.
*******************************************************************************/
function table_exists
(
  r,
  c,
  ri,
  ci
) = let ( dr = is_defined(ri), dc = is_defined(ci) )
    ( dr && dc ) ? is_defined(table_get_value(r, c, ri, ci))
  : dr ? is_number(table_get_row_index(r,ri))
  : dc ? is_number(table_get_column_index(c,ci))
  : false;

//! Get the size of a table.
/***************************************************************************//**
  \param    r \<table> The table row data matrix (C-columns x R-rows).
  \param    c <map> The table column identifier matrix (2 x C-columns).

  \returns  <integer> The table size.

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
) = ( is_defined(r) && is_undef(c) ) ? len( r )
  : ( is_undef(r) && is_defined(c) ) ? len( c )
  : len( r ) * len( c );

//! Create a new matrix from select rows and columns of a table.
/***************************************************************************//**
  \param    r \<table> The table row data matrix (C-columns x R-rows).
  \param    c <map> The table column identifier matrix (2 x C-columns).
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
      is_undef( rs ) ||
      is_number( first( search( r_iter, rs, 1, 0 ) ) )
    )
    [
      for ( c_iter = c )
        if
        (
          is_undef( cs ) ||
          is_number( first( search( c_iter, cs, 1, 0 ) ) )
        )
          table_get_value(r, c, r_iter, c_iter)

    ]
];

//! Sum select rows and columns of a table.
/***************************************************************************//**
  \param    r \<table> The table row data matrix (C-columns x R-rows).
  \param    c <map> The table column identifier matrix (2 x C-columns).
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

//! Perform basic format checks on a table and return errors.
/***************************************************************************//**
  \param    r \<table> The table row data matrix (C-columns x R-rows).
  \param    c <map> The table column identifier matrix (2 x C-columns).

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


//! Perform basic format checks on a table and output errors to console.
/***************************************************************************//**
  \param    r \<table> The table row data matrix (C-columns x R-rows).
  \param    c <map> The table column identifier matrix (2 x C-columns).
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
    assert
    (
      col_cnt ==  len ( r_iter ),
      str
      (
        "row ", table_get_row_index(r, r_iter),
        ", id=[", first(r_iter), "]",
        ", has incorrect column count=[", len ( r_iter ),"]",
        ", expecting=[", col_cnt, "]"
      )
    );
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
  \param    r \<table> The table row data matrix (C-columns x R-rows).
  \param    c <map> The table column identifier matrix (2 x C-columns).
  \param    rs <string-list> A list of selected row identifiers.
  \param    cs <string-list> A list of selected column identifiers.
  \param    number <boolean> Number the rows.

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
  // determine maximum field lengths
  maxr0 = max( [for (r_iter = r) len( first(r_iter) )] ) + 1;
  maxc0 = max( [for (c_iter = c) len( first(c_iter) )] ) + 1;
  maxc1 = max( [for (c_iter = c) len( c_iter[1] )] ) + 1;

  for ( r_iter = r )
  {
    if
    (
      is_undef( rs ) ||
      is_number( first( search( r_iter, rs, 1, 0 ) ) )
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
          is_undef( cs ) ||
          is_number( first( search( c_iter, cs, 1, 0 ) ) )
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

  if ( number )
  {
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

//! Dump table getter functions to the console.
/***************************************************************************//**
  \param    r \<table> The table row data matrix (C-columns x R-rows).
  \param    c <map> The table column identifier matrix (2 x C-columns).
  \param    tr <string> The table row data matrix variable name.
  \param    tc <string> The table column identifier matrix variable name.
  \param    ri <string | value> The row identifier variable name or value.
  \param    ci <string | value> The column identifier variable name or value.
  \param    vri <boolean> The row identifier \p ri is a value.
  \param    vci <boolean> The column identifier \p ci is a value.
  \param    name <string> The getter function name.
  \param    append <boolean> Append id to names.
  \param    comment <integer> Output comment mode {0, 1, 2}.
  \param    verbose <boolean> Be verbose.

  \details

    Output getter functions for a table to the console. The resulting
    functions can be used within scripts to access table data.

    \b Example
    \code
    table_dump_getters
    (
      r=my_config_tr, c=my_config_tc, tr="my_config_tr", tc="my_config_tc",
      ri="my_config", vri=true, name="my_get_function", comment=2
    );
    \endcode
*******************************************************************************/
module table_dump_getters
(
r,
c,

tr = "table_rows",
tc = "table_cols",

ri = "ri",
ci = "ci",

vri = false,
vci = false,

name = "get_helper",
append = false,
comment = 0,
verbose = false
)
{
  function qri(ri) = (ri == "ri") ? ri : (vri == true) ? ri : str("\"", ri, "\"");
  function qci(ci) = (ci == "ci") ? ci : (vci == true) ? ci : str("\"", ci, "\"");
  function gfn(fn) =
    str
    (
      fn,
      (ri == "ri")?"":(append?str("_", ri):""),
      (ci == "ci")?"":(append?str("_", ci):"")
    );

  //
  // check table
  //
  echo();
  echo("Checking table...");
  table_check(r=r, c=c, verbose=verbose);

  if ( table_errors(r=r, c=c) == empty_lst )
  {
    //
    // output helper function
    //
    echo();

    // getter function comment
    gct =
      str
      (
        "// table value getter function",
        (ri == "ri")?"":str(", constant row ri=", qri(ri)),
        (ci == "ci")?"":str(", constant column ci=", qci(ci)),
        "."
      );
    if (comment > 0) echo (str(gct));

    // getter function
    echo
    (
      str
      (
        "function ", gfn(name),
        "(",
        (ri == "ri")?"ri":"",
        (ri == "ri") && (ci == "ci")?", ":"",
        (ci == "ci")?"ci":"",
        ") = table_get_value (r=", tr,
        ", c=", tc,
        ", ri=", qri(ri),
        ", ci=", qci(ci),
        ");"
      )
    );

    //
    // output value functions
    //
    echo();

    // constant row (ri)
    if ( (ri != "ri") && (ci == "ci") )
    {
      if ( vri || table_exists( r=r, c=c, ri=ri ) )
      {
        for ( i = table_get_column_ids (c=c) )
        {
          cic = table_get_column( c=c, ci=i );

          gct = str("// get ci=", qci(i), " (", second(cic), ") & ri=", qri(ri), ".");
          if (comment == 1) echo (str(gct));

          echo
          (
            str
            (
              (append?str(ri, "_"):""), i, " = ",
              gfn(name), "(ci=", qci(i), ");",
              (comment == 2)?str("\t", gct):""
            )
          );
        }
      }
      else
      {
        echo( str( "row ri=", qri(ri), " does not exist in table." ) );
      }
    }

    // constant col (ci)
    else if ( (ri == "ri") && (ci != "ci") )
    {
      if ( vci || table_exists( r=r, c=c, ci=ci ) )
      {
        for ( i = table_get_row_ids (r=r) )
        {
          gct = str("// get ri=", qri(i), " & ci=", qci(ci), ".");
          if (comment == 1) echo (str(gct));

          echo
          (
            str
            (
              i, (append?str("_", ci):""), " = ",
              gfn(name), "(ri=", qri(i), ");",
              (comment == 2)?str("\t", gct):""
            )
          );
        }
      }
      else
      {
        echo( str( "column ci=", qci(ci), " does not exist in table." ) );
      }
    }

    // constant row and col (ri & ci)
    else if ( (ri != "ri") && (ci != "ci") )
    {
      if ( vri || vci || table_exists( r=r, c=c, ri=ri, ci=ci ) )
      {        gct = str("// get ri=", qri(ri), " & ci=", qci(ci), ".");
        if (comment == 1) echo (str(gct));

        echo
        (
          str
          (
            ri, "_", ci, " = ",
            gfn(name), "(ri=", qri(ri), ", ci=", qci(ci), ");",
            (comment == 2)?str("\t", gct):""
          )
        );
      }
      else
      {
        echo
        (
          str
          (
            "row ri=", qri(ri), ", column ci=", qci(ci),
            " does not exist in table."
          )
        );
      }
    }
  }
  else
  {
    echo ( "Table has errors." );
  }
}

//! Write formatted map entries to the console.
/***************************************************************************//**
  \param    r \<table> The table row data matrix (C-columns x R-rows).
  \param    c <map> The table column identifier matrix (2 x C-columns).
  \param    rs <string-list> A list of selected row identifiers.
  \param    cs <string-list> A list of selected column identifiers.
  \param    number <boolean> Number the rows.
  \param    heading_id <boolean> Output table heading identifiers.
  \param    heading_text <boolean> Output table heading description text.
  \param    fs <string> A field separator.
  \param    thn <string> Column heading for numbered row output.
  \param    index_tags <string-list> List of html formatting tags.
  \param    row_id_tags <string-list> List of html formatting tags.
  \param    value_tags <string-list> List of html formatting tags.

  \details

    Output each table row to the console. To output only select rows
    and columns, assign the desired identifiers to \p rs and \p cs. For
    example to output only the column identifiers 'c1' and 'c2', assign
    <tt>cs = ["c1", "c2"]</tt>. The output can then be processed to
    produce documentation tables as shown in the example below.

    \amu_define title (Table write)
    \amu_define scope_id (example_table)

    \amu_define th_line (1)
    \amu_define td_line_begin (2)
    \amu_define td_line_end (9)
    \amu_include (include/amu/scope_table.amu)

    \amu_define output_scad (false)
    \amu_define output_console (false)
    \amu_define th_line (10)
    \amu_define td_line_begin (11)
    \amu_define td_line_end (0)
    \amu_include (include/amu/scope_table.amu)
*******************************************************************************/
module table_write
(
  r,
  c,
  rs,
  cs,
  number = false,
  heading_id = true,
  heading_text = false,
  fs = "^",
  thn = "idx",
  index_tags = empty_lst,
  row_id_tags = ["b"],
  value_tags = empty_lst
)
{
  // heading identifiers and/or text descriptions
  th_text =
  [
    if(number == true)
      thn,

    for ( c_iter = c )
      if
      ( // when column selected
        is_undef( cs ) ||
        is_number( first( search( c_iter, cs, 1, 0 ) ) )
      )
        (heading_id && heading_text) ? str(second(c_iter)," (", first(c_iter), ")")
      : (heading_id                ) ? first(c_iter)
      : (              heading_text) ? second(c_iter)
      : empty_str
  ];

  if ( heading_id  || heading_text )
    // reformat so that 'fs' exists only between fields
    log_echo ( strl([for ( i = headn(th_text) ) str(i,fs), last(th_text)]) );

  // row data
  for ( r_iter = r )
  {
    if
    ( // when row selected
      is_undef( rs ) ||
      is_number( first( search( r_iter, rs, 1, 0 ) ) )
    )
    {
      tdr_text =
      [
        if (number == true)
          str(strl_html([table_get_row_index(r, r_iter)], p=[index_tags]),fs),

        strl_html(first(r_iter), p=[row_id_tags]), fs,
        for ( c_iter = tailn(c, n=1) )
          if
          ( // when column selected
            is_undef( cs ) ||
            is_number( first( search( c_iter, cs, 1, 0 ) ) )
          )
            str(strl_html([table_get_value(r, c, r_iter, c_iter)], p=[value_tags]),fs)
      ];

      log_echo ( strl(tdr_text) );
    }
  }
}

//! @}

//----------------------------------------------------------------------------//
// Combined
//----------------------------------------------------------------------------//

//! \name Combined table data
//! @{

/***************************************************************************//**
  \param    t <datastruct-list-2> A list [\<table>, <map>], [r, c], of
            the row data matrix (C-columns x R-rows) and column
            identifier matrix (2 x C-columns).

  \copydoc table_get()
*******************************************************************************/
function ctable_get( t, ri, ci ) = table_get( first(t), second(t), ri, ci );

/***************************************************************************//**
  \param    t <datastruct-list-2> A list [\<table>, <map>], [r, c], of
            the row data matrix (C-columns x R-rows) and column
            identifier matrix (2 x C-columns).

  \copydoc table_exists()
*******************************************************************************/
function ctable_exists( t, ri, ci ) = table_exists( first(t), second(t), ri, ci );

/***************************************************************************//**
  \param    t <datastruct-list-2> A list [\<table>, <map>], [r, c], of
            the row data matrix (C-columns x R-rows) and column
            identifier matrix (2 x C-columns).

  \copydoc table_get_size()
*******************************************************************************/
function ctable_get_size( t ) = table_get_size( first(t), second(t) );

/***************************************************************************//**
  \param    t <datastruct-list-2> A list [\<table>, <map>], [r, c], of
            the row data matrix (C-columns x R-rows) and column
            identifier matrix (2 x C-columns).

  \copydoc table_errors()
*******************************************************************************/
function ctable_errors( t ) = table_errors( first(t), second(t) );

//! @}

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE example_use;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;

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

    echo( "### table_check ###" );
    table_check( table_rows, table_cols, true );

    echo( "### table_dump ###" );
    table_dump( table_rows, table_cols );

    echo( "### table_get_value ###" );
    m3r16r_tl = table_get_value( table_rows, table_cols, "m3r16r", "tl" );
    echo ( m3r16r_tl=m3r16r_tl );

    echo( "### table_exists ###" );
    if ( table_exists( c=table_cols, ci="nl" ) )
      echo ( "metric 'nl' available" );
    else
      echo ( "metric 'nl' not available" );

    echo( "### table_get_row_ids ###" );
    table_ids = table_get_row_ids( table_rows );
    echo ( table_ids=table_ids );

    echo( "### table_get_columns 'tl' ###" );
    table_cols_tl = table_get_columns( table_rows, table_cols, "tl" );
    echo ( table_cols_tl=table_cols_tl );

    echo( "### table_get_copy  ['tl, 'nl'] ###" );
    tnew = table_get_copy( table_rows, table_cols, cs=["tl", "nl"] );
    echo ( tnew=tnew );

    echo( "### table_get_sum ['tl, 'nl'] ###" );
    tsum = table_get_sum( table_rows, table_cols, cs=["tl", "nl"] );
    echo ( tsum=tsum );

    echo( "### table_dump_getters ###" );
    table_dump_getters( r=table_rows, c=table_cols,
      tr="table_rows", tc="table_cols",
      ri="my_config", vri=true, name="get_my_value", comment=2 );

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_term}.mfs;
    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;

BEGIN_SCOPE example_table;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;

    base_unit_length = "mm";

    table_cols =
    [ // id,  description
      ["id",  "row identifier"],
      ["ht",  "head type"],
      ["td",  "thread diameter"],
      ["tl",  "thread length"],
      ["hd",  "head diameter"],
      ["hl",  "head length"],
      ["nd",  "nut width"],
      ["nl",  "nut length"]
    ];

    table_rows =
    [ //     id,  ht,     td,     tl,   hd,    hl,    nd,          nl
      ["m3r08r", "r",  3.000,   8.00, 5.50, 3.000,  5.50, length(1.00, "in")],
      ["m3r14r", "r",  3.000,  14.00, 5.50, 3.000,  5.50, length(1.25, "in")],
      ["m4r16s", "s",  4.000,  16.00, 4.50, 4.000,  5.50, length(1.50, "in")],
      ["m5r20h", "h",  5.000,  20.00, 6.00, 5.000,  5.50, length(1.75, "in")]
    ];

    map_write(table_cols, value_tags=["i"]);
    table_write(table_rows, table_cols);

    // end_include
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {var_init,var_gen_term}.mfs;
    include --path "${INCLUDE_PATH}" scr_make_mf.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
