//! Documentation main page.
/***************************************************************************//**
  \file   mainpage.scad
  \author Roy Allen Sutton
  \date   2016

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

*******************************************************************************/

/***************************************************************************//**
  \mainpage omdl
  \tableofcontents

  \section overview Overview

    This is an OpenSCAD mechanical design library, \em omdl, and documentation
    licensed under the [LGPL 2.1] (https://www.gnu.org/licenses/lgpl-2.1.html).
    [omdl] (https://github.com/royasutton/omdl) uses git for development
    tracking and is hosted on GitHub. The library documentation is generated
    using the [openscad-amu] (https://github.com/royasutton/openscad-amu)
    design flow.

  \section using Using

    Use the library files just like any other OpenSCAD library:

    \code{.C}
    t = triangle_lll2vp( 30, 40, 50 );
    r = [2, 4, 6];
    triangle_vp( v=t, vr=r  );
    \endcode


  \section install Install
  \section example Example

  \todo Design a project logo.
*******************************************************************************/

/***************************************************************************//**
  \defgroup constants Constants
  \brief    General design constants.
*******************************************************************************/

/***************************************************************************//**
  \defgroup data Data
  \brief    Data values and reference
*******************************************************************************/

/***************************************************************************//**
  \defgroup designs Designs
  \brief    Standalone parametric designs
*******************************************************************************/

/***************************************************************************//**
  \defgroup math Math
  \brief    Mathematical functions.
*******************************************************************************/

/***************************************************************************//**
  \defgroup parts Parts
  \brief    Parametric parts/components.
*******************************************************************************/

/***************************************************************************//**
  \defgroup shapes Shapes
  \brief    2D and 3D shapes.
*******************************************************************************/

/***************************************************************************//**
  \defgroup tools Tools
  \brief    Design tools and techniques.
*******************************************************************************/

/***************************************************************************//**
  \defgroup transforms Transformations
  \brief    Shape transformations.
*******************************************************************************/

/***************************************************************************//**
  \defgroup units Units
  \brief    Units and unit conversions.
*******************************************************************************/

/***************************************************************************//**
  \defgroup utilities Utilities
  \brief General utilities.
*******************************************************************************/

//----------------------------------------------------------------------------//
// end of file
//----------------------------------------------------------------------------//
