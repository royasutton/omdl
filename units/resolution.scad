//! An abstraction for arc rendering resolution control.
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

    \amu_pathid parent  (++path)
    \amu_pathid group   (++path ++stem)

  \ingroup \amu_eval(${parent} ${group})
*******************************************************************************/

include <../console.scad>;
include <../constants.scad>;
include <length.scad>;

//----------------------------------------------------------------------------//
// group.
//----------------------------------------------------------------------------//

/***************************************************************************//**
  \addtogroup \amu_eval(${parent})
  @{

  \defgroup \amu_eval(${group}) Resolutions
  \brief    Arch rendering resolution management.

  \details

    Functions, global variables, and configuration presets to provide a
    common mechanism for managing arc rendering resolution.
    Specifically, the number of fragments/facets with which arcs
    (circles, spheres, and cylinders, etc.) are rendered in OpenSCAD.

    \b Example

      \dontinclude \amu_scope(index=1).scad
      \skip include
      \until f));

    \b Result (base_unit_length = \b mm):  \include \amu_scope(index=1)_mm.log
    \b Result (base_unit_length = \b cm):  \include \amu_scope(index=1)_cm.log
    \b Result (base_unit_length = \b mil): \include \amu_scope(index=1)_mil.log
    \b Result (base_unit_length = \b in):  \include \amu_scope(index=1)_in.log

  @{
*******************************************************************************/

//----------------------------------------------------------------------------//

//! <string> Global special variable that configures the arc resolution mode.
$resolution_mode = "fast";

//! <number> Global special variable for modes that use custom resolutions.
$resolution_value = 0;

//! Return facets number for the given arc radius.
/***************************************************************************//**
  \param    r <decimal> The arc radius.

  \returns  <integer> The number of facets to be assigned to $fn.

  \details

    The result of this function can be assigned to the special
    variables \p $fn to render arcs according to the resolution mode
    set by \ref $resolution_mode and \ref $resolution_value.

    The following table shows the modes that require \ref $resolution_value
    to be set prior to specifying the custom values used during resolution
    calculation.

     $resolution_mode | $resolution_value sets | radius dependent
    :----------------:|:----------------------:|:----------------:
      set             | fixed value            | no
      upf             | units per facet        | yes
      fpu             | facets per unit        | yes
      fpi             | facets per inch        | yes

    The following table has common resolution presets. Equivalent
    configuration can be obtained using \ref $resolution_mode and
    \ref $resolution_value as described in the preview table.

     $resolution_mode | preset description        | radius dependent
    :----------------:|:--------------------------|:----------------:
      fast            | fast rendering mode       | no
      low             | low resolution            | yes
      medium          | medium resolution         | yes
      high            | high resolution           | yes
      50um            | 50 micron per facets      | yes
      100um           | 100 micron per facets     | yes
      200um           | 200 micron per facets     | yes
      300um           | 300 micron per facets     | yes
      400um           | 400 micron per facets     | yes
      500um           | 500 micron per facets     | yes
      50mil           | 50 thousandth per facets  | yes
      100mil          | 100 thousandth per facets | yes
      200mil          | 200 thousandth per facets | yes
      300mil          | 300 thousandth per facets | yes
      400mil          | 400 thousandth per facets | yes
      500mil          | 500 thousandth per facets | yes
*******************************************************************************/
function resolution_fn
(
  r
) = $resolution_mode == "set"
    ? ceil(max(3, $resolution_value))

  // custom resolutions
  : $resolution_mode == "upf"
    ? ceil(max(3, r*tau / $resolution_value))
  : $resolution_mode == "fpu"
    ? ceil(max(3, r*tau * $resolution_value))
  : $resolution_mode == "fpi"
    ? ceil(max(3, unit_length_convert(r, to="in")*tau * $resolution_value))

  // common resolutions per unit (base_units)
  : $resolution_mode == "fast"
    ? 18
  : $resolution_mode == "low"
    ? ceil(max(3, r*tau * 1))
  : $resolution_mode == "medium"
    ? ceil(max(3, r*tau * 10))
  : $resolution_mode == "high"
    ? ceil(max(3, r*tau * 100))

  // common resolutions in microns
  : $resolution_mode == "50um"
    ? ceil(max(3, r*tau / unit_length_convert(  50, "um")))
  : $resolution_mode == "100um"
    ? ceil(max(3, r*tau / unit_length_convert( 100, "um")))
  : $resolution_mode == "200um"
    ? ceil(max(3, r*tau / unit_length_convert( 200, "um")))
  : $resolution_mode == "300um"
    ? ceil(max(3, r*tau / unit_length_convert( 300, "um")))
  : $resolution_mode == "400um"
    ? ceil(max(3, r*tau / unit_length_convert( 400, "um")))
  : $resolution_mode == "500um"
    ? ceil(max(3, r*tau / unit_length_convert( 500, "um")))

  // common resolutions in thousands
  : $resolution_mode == "50mil"
    ? ceil(max(3, r*tau / unit_length_convert(  50, "mil")))
  : $resolution_mode == "100mil"
    ? ceil(max(3, r*tau / unit_length_convert( 100, "mil")))
  : $resolution_mode == "200mil"
    ? ceil(max(3, r*tau / unit_length_convert( 200, "mil")))
  : $resolution_mode == "300mil"
    ? ceil(max(3, r*tau / unit_length_convert( 300, "mil")))
  : $resolution_mode == "400mil"
    ? ceil(max(3, r*tau / unit_length_convert( 400, "mil")))
  : $resolution_mode == "500mil"
    ? ceil(max(3, r*tau / unit_length_convert( 500, "mil")))

  // otherwise
  : undef;

//! Return minimum facets size.
/***************************************************************************//**
  \returns  <integer> Minimum facet size to be assigned to $fs.

  \details

    The result of this function can be assigned to the special
    variables \p $fs to render arcs according to the resolution mode
    set by \ref $resolution_mode and \ref $resolution_value.

    The following table shows the modes that require \ref $resolution_value
    to be set prior to calling this function in order to specify the
    custom values used during resolution calculation.

     $resolution_mode | $resolution_value sets | radius dependent
    :----------------:|:----------------------:|:----------------:
      set             | fixed value            | no
      upf             | units per facet        | no
      fpu             | facets per unit        | no
      fpi             | facets per inch        | no

    The following table has common resolution presets. Equivalent
    configuration can be obtained using \ref $resolution_mode and
    \ref $resolution_value as described in the preview table.

     $resolution_mode | preset description        | radius dependent
    :----------------:|:--------------------------|:----------------:
      fast            | fast rendering mode       | no
      low             | low resolution            | no
      medium          | medium resolution         | no
      high            | high resolution           | no
      50um            | 50 micron per facets      | no
      100um           | 100 micron per facets     | no
      200um           | 200 micron per facets     | no
      300um           | 300 micron per facets     | no
      400um           | 400 micron per facets     | no
      500um           | 500 micron per facets     | no
      50mil           | 50 thousandth per facets  | no
      100mil          | 100 thousandth per facets | no
      200mil          | 200 thousandth per facets | no
      300mil          | 300 thousandth per facets | no
      400mil          | 400 thousandth per facets | no
      500mil          | 500 thousandth per facets | no
*******************************************************************************/
function resolution_fs ( )
  // OpenSCAD's minimum allowed value for $fa and $fs is 0.01
  = $resolution_mode == "set"
    ? max(0.01, $resolution_value)

  // custom resolutions
  : $resolution_mode == "upf"
    ? max(0.01, $resolution_value)
  : $resolution_mode == "fpu"
    ? max(0.01, 1 / $resolution_value)
  : $resolution_mode == "fpi"
    ? max(0.01, unit_length_convert(1, "in") / $resolution_value)

  // common resolutions per unit (base_units)
  : $resolution_mode == "fast"
    ? 10
  : $resolution_mode == "low"
    ? 1/001
  : $resolution_mode == "medium"
    ? 1/010
  : $resolution_mode == "high"
    ? 1/100

  // common resolutions in microns
  : $resolution_mode == "50um"
    ? unit_length_convert(  50, "um")
  : $resolution_mode == "100um"
    ? unit_length_convert( 100, "um")
  : $resolution_mode == "200um"
    ? unit_length_convert( 200, "um")
  : $resolution_mode == "300um"
    ? unit_length_convert( 300, "um")
  : $resolution_mode == "400um"
    ? unit_length_convert( 400, "um")
  : $resolution_mode == "500um"
    ? unit_length_convert( 500, "um")

  // common resolutions in thousands
  : $resolution_mode == "50mil"
    ? unit_length_convert(  50, "mil")
  : $resolution_mode == "100mil"
    ? unit_length_convert( 100, "mil")
  : $resolution_mode == "200mil"
    ? unit_length_convert( 200, "mil")
  : $resolution_mode == "300mil"
    ? unit_length_convert( 300, "mil")
  : $resolution_mode == "400mil"
    ? unit_length_convert( 400, "mil")
  : $resolution_mode == "500mil"
    ? unit_length_convert( 500, "mil")

  // otherwise
  : undef;

//! Return the minimum facets angle.
/***************************************************************************//**
  \param    r <decimal> The arc radius.

  \returns  <decimal> Minimum facet angle to be assigned to $fa.

  \details

    The result of this function can be assigned to the special
    variables \p $fa to render arcs.
*******************************************************************************/
function resolution_fa
(
  r
) = max(0.01, (360*$fs)/(tau*r));

//! Return the radius at which arc resolution will begin to degrade.
/***************************************************************************//**
  \returns  <decimal> Transition radius where resolution reduction begins.

  \details

    The special variables \p $fs and \p $fa work together when \p $fn = 0.
    For a given \p $fs, the fragment angle of a drawn arc gets smaller
    with increasing radius. In other words, the fragment angle is
    inversely proportional to the arc radius for a given fragment size.

    The special variable \p $fa enforces a minimum fragment angle limit
    and at some radius, the fragment angle would becomes smaller than
    this limit. At this point, OpenSCAD limits further reduction in the
    facet angle which forces the use of increased fragment size. This
    in effect begins the gradual reduction of arc resolution with
    increasing radius.

    The return result of this function indicates the radius at which
    this enforced limiting begins. When \p $fn != 0, returns
    \b undef.
*******************************************************************************/
function resolution_reduced ( )
  = ($fn == 0.0)
    ? (360*$fs)/(tau*$fa)
  : undef;

//! Output resolution information to the console for given radius.
/***************************************************************************//**
  \param    r <decimal> The arc radius.
*******************************************************************************/
module resolution_info
(
  r
)
{
  log_echo
  (
    str
    (
      "$resolution_mode = [", $resolution_mode,
      "], $resolution_value = ", $resolution_value,
      ", base_unit_length = ", unit_length_name()
    )
  );

  log_echo
  (
    str
    (
      "$fn = ", $fn,
      ", $fa = ", $fa,
      ", $fs = ", $fs
    )
  );

  if ($fn == 0.0)
    log_echo
    (
      str
      (
        "resolution reduction at radius > ",
        resolution_reduced(), " ", unit_length_name()
      )
    );

  if ($fn > 0.0)
    log_echo
    (
      str
      (
        "for radius = ", r, " ", unit_length_name()," facets limited to ",
        max(3, $fn), " by $fn=", $fn
      )
    );
  else if (360.0/$fa < r*tau/$fs)
    log_echo
    (
      str
      (
        "for radius = ", r, " ", unit_length_name()," facets limited to ",
        max(5, ceil(360.0/$fa)), " by $fa=", $fa
      )
    );
  else
    log_echo
    (
      str
      (
        "for radius = ", r, " ", unit_length_name()," facets limited to ",
        max(5, ceil(r*tau/$fs)), " by $fs=", $fs, " ", unit_length_name()
      )
    );
}

//! Return facet count used to render a radius.
/***************************************************************************//**
  \param    r <decimal> The arc radius.

  \returns  <integer> The number of fragments/facets that will be used to
            render a radius given the current values for \p $fn, \p $fa,
            and \p $fs.
*******************************************************************************/
function resolution_facets
(
  r
) = ($fn > 0.0)             ? max(3, $fn)
  : (360.0/$fa < r*tau/$fs) ? max(5, ceil(360.0/$fa))
  :                           max(5, ceil(r*tau/$fs));

//! Return facet count information list used to render a radius.
/***************************************************************************//**
  \param    r <decimal> The arc radius.

  \returns  <list-3> A 3-tuple list of the form:
            [\b facets <integer>,\b limiter <string>,\b value <decimal>].

  \details

    Where \p facets is the number of fragments/facets that will be used to
    render the \p radius given the current values for \p $fn, \p $fa, and
    \p $fs. \p limiter identifies the special variable that currently limits
    the facets, and \p value is the current value assigned to the limiter.
*******************************************************************************/
function resolution_facetsv
(
  r
) = ($fn > 0.0)             ? [max(3, $fn), "$fn", $fn]
  : (360.0/$fa < r*tau/$fs) ? [max(5, ceil(360.0/$fa)), "$fa", $fa]
  :                           [max(5, ceil(r*tau/$fs)), "$fs", $fs ];

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE example;
  BEGIN_OPENSCAD;
    include <units/resolution.scad>;

    base_unit_length = "in";

    // set resolution to 25 fpi
    $resolution_mode  = "fpi";
    $resolution_value = 25;

    // use radius length of 1 inch
    r = convert_length(1, "in");

    $fs=resolution_fs();
    $fa=resolution_fa( r );

    resolution_info( r );

    f = resolution_facets( r );
    echo(str("for r = ", r, " ", unit_length_name(), ", facets = ", f));
  END_OPENSCAD;

  BEGIN_MFSCRIPT;
    include --path "${INCLUDE_PATH}" {config_base,config_csg}.mfs;

    defines   name "units" define "base_unit_length" strings "mm cm mil in";
    variables add_opts_combine "units";

    include --path "${INCLUDE_PATH}" script_std.mfs;
  END_MFSCRIPT;
END_SCOPE;
*/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
