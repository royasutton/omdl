//! Message logging functions.
/***************************************************************************//**
  \file   console.scad
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

  \ingroup data data_console
*******************************************************************************/

use <utilities.scad>;

//----------------------------------------------------------------------------//
/***************************************************************************//**
  \addtogroup data
  @{

  \defgroup data_console Console
  \brief    Console message logging.

  \details

    \b Example

      \dontinclude console_example.scad
      \skip use
      \until log_error( message );

    \b Result \include console_example.log

  @{
*******************************************************************************/
//----------------------------------------------------------------------------//

//! Output message to console.
/***************************************************************************//**
  \param    message <string> The message to output.
*******************************************************************************/
module log_echo( message )
{
  um = (message==undef) ? "" : message;

  echo ( um );
}

//! Output diagnostic message to console.
/***************************************************************************//**
  \param    message <string> The message to output.

  \details

    When \p $log_debug == \p true, message are written to the console. When
    \p false, output is not generated.
*******************************************************************************/
module log_debug( message )
{
  um = (message==undef) ? "" : message;

  mt = "[ DEBUG ]";
  sp = chr( 32 );
  cs = stack( idx_e = 1 );

  if ( $log_debug == true )
    echo ( str(mt, sp, cs, ";", sp, um) );

}

//! Output information message to console.
/***************************************************************************//**
  \param    message <string> The message to output.
*******************************************************************************/
module log_info( message )
{
  um = (message==undef) ? "" : message;

  mt = "[ INFO ]";
  sp = chr( 32 );
  cs = stack( idx_e = 1 );

  echo ( str(mt, sp, cs, ";", sp, um) );
}

//! Output warning message to console.
/***************************************************************************//**
  \param    message <string> The message to output.
*******************************************************************************/
module log_warn( message )
{
  um = (message==undef) ? "" : message;

  mt = "[ WARNING ]";
  bc = 35;
  sp = chr( 32 );
  cs = stack( idx_e = 1 );
  hb = chr( [for (i=[0:1:len(um)+len(mt)+4]) bc] );
  ms = str(chr(bc), sp, mt, sp, um, sp, chr(bc));

  echo ();
  echo (cs);
  echo (hb);
  echo (ms);
  echo (hb);
}

//! Output error message to console.
/***************************************************************************//**
  \param    message <string> The message to output.

  \details

    Output an error message to the console. Ideally, rendering should halt
    and the script should exit. However, no suitable abort function exists.
    To alert of the critical error, the error message is also rendered
    graphically.
*******************************************************************************/
module log_error( message )
{
  um = (message==undef) ? "" : message;

  mt = "[ ERROR ]";
  bc = 35;
  sp = chr( 32 );
  cs = stack( idx_e = 1 );
  hb = chr( [for (i=[0:1:len(um)+len(mt)+6]) bc] );
  hs = chr( concat([bc, bc],[for (i=[0:1:len(um)+len(mt)+2]) 32],[bc, bc]) );
  ms = str(chr(bc), chr(bc), sp, mt, sp, um, sp, chr(bc), chr(bc));

  echo ();
  echo (cs);
  echo (hb); echo (hb);
  echo (hs);
  echo (ms);
  echo (hs);
  echo (hb); echo (hb);

  color( "red" )
  text( ms );
}

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE example;
  BEGIN_OPENSCAD;
    use <console.scad>;

    $log_debug = true;
    message = "console log message";

    // general
    log_echo( message );

    // debugging
    log_debug( message );
    log_debug( message, $log_debug = false );

    // information
    log_info( message );

    // warning
    log_warn( message );

    // error
    log_error( message );
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
