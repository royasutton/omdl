//! Miscellaneous mathematical utilities.
/***************************************************************************//**
  \file
  \author Roy Allen Sutton
  \date   2017-2019, 2026

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

    \amu_define group_name  (Utilities)
    \amu_define group_brief (Miscellaneous mathematical utilities.)

  \amu_include (include/amu/doxyg_init_pd_gds_ipg.amu)
*******************************************************************************/

// auto-tests (add to test results page)
/***************************************************************************//**
  \amu_include (include/amu/validate_log.amu)
  \amu_include (include/amu/validate_results.amu)
*******************************************************************************/

// group(s) begin (test summary and includes-required)
/***************************************************************************//**
  \amu_include (include/amu/doxyg_define_in_parent_open.amu)
  \amu_include (include/amu/validate_summary.amu)
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

    The following conventions apply to all functions in this group.
    - OpenSCAD special variables \p $fn, \p $fa, and \p $fs are read
      directly at the call site and are never passed as parameters;
      their values at the point of call control fragment counts.
    - \c grid_fine is an omdl library-level constant defining the
      minimum meaningful geometry size. Inputs below this threshold
      are treated as degenerate and return safe fallback values.
    - Bit-field parameters (e.g. \p m in histogram()) are documented
      with an explicit bit-table in the function's \c \\details block.
      Bit 0 always selects the primary output mode (0 = numerical,
      1 = string). Higher bits select sub-modes within the string path.
    - HTML passthrough parameters (\p cb, \p cp, \p ca, \p cf, \p d)
      follow the interface of strl_html() exactly; see its documentation
      for type and semantics. They are ignored in non-html modes.
    - \c tau is an omdl library constant equal to 2*PI.
    - No input validation is performed unless an explicit \c assert is
      present. Out-of-range or wrongly-typed inputs produce \b undef,
      \b nan, or \b inf without warning.
*******************************************************************************/

//----------------------------------------------------------------------------//
// members
//----------------------------------------------------------------------------//

//! Return facets number for the given arc radius.
/***************************************************************************//**
  \param    r <decimal> The arc radius. Must be >= 0. Defaults to \b 0,
              which returns \b 3 (the minimum facet count).

  \returns  <integer> The number of facets.

  \details

    This function approximates the \c get_fragments_from_r() code that
    is used by OpenSCAD to calculate the number of fragments in a
    circle or arc. The arc facets are controlled by the special
    variables \p $fa, \p $fs, and \p $fn. The three branches are:
    - \p r < \c grid_fine: returns \b 3 (minimum). \c grid_fine is the
      library-level constant for the minimum meaningful geometry size;
      radii below it are treated as degenerate.
    - \p $fn > 0: returns \p $fn clamped to a minimum of \b 3,
      respecting the caller's explicit fragment count override.
    - otherwise: returns \c ceil(max(min(360/\p $fa, r*tau/\p $fs), 5)),
      where \c tau = 2*PI is an omdl library constant.

  \note Passing a negative \p r is invalid and caught by an internal
        assert. If \p $fa is 0, \c 360/$fa produces \c inf; \c min()
        then selects the \c r*tau/$fs term, which is the correct
        fallback behaviour.
*******************************************************************************/
function get_fn
(
  r = 0
) = let
    (
      _ = assert( r >= 0, "get_fn: r must be >= 0." )
    )
    (r < grid_fine) ? 3
  : ($fn > 0.0) ? ($fn >= 3) ? $fn : 3
  : ceil( max( min(360/$fa, r*tau/$fs), 5 ) );

//! Generate a histogram for the elements of a list of values.
/***************************************************************************//**
  \param    v <data> A list of values.
  \param    m <integer> The output mode (a 5-bit encoded integer).

  \param    cs  <string-list-4> A list of strings \c [cs[0], cs[1],
                cs[2], cs[3]] used only with custom formatting (m =
                15), mapping to \c s1, \c s2, \c s3, and \c fs
                respectively in the output template: \c s1, value, \c
                s2, frequency, \c s3, \c fs.

  \param    cb  <string-list> Bold tag specifiers passed to
                strl_html(). Only used in html and custom string modes.
                See strl_html() for type and semantics.

  \param    cp  <string-list> HTML tag-pair specifiers passed to
                strl_html(). Only used in html and custom string modes.
                See strl_html() for type and semantics.

  \param    ca  <string-list> HTML attribute specifiers passed to
                strl_html(). Only used in html and custom string modes.
                See strl_html() for type and semantics.

  \param    cf  <string-list> Font specifiers passed to strl_html().
                Only used in html and custom string modes. See
                strl_html() for type and semantics.

  \param    d <boolean> When \b true, emit HTML debug output via
              strl_html(). Default \b false.

  \returns  <decimal-list | string> The occurrence frequencies of \p v.
            When \p m bit 0 = \b 0 (numerical mode), returns a list of
            \c [value, count] pairs. When \p m bit 0 = \b 1 (string
            mode), returns a single concatenated string, except for m =
            \b 1 which returns a list of bare \c "NxM" strings.

  \details

    The custom formatting strings are inserted in the output stream as
    follows:

    \verbatim
    s1, value, s2, value-frequency, s3, fs
    \endverbatim

    See strl_html() for description of the html formatting parameters
    \p cb, \p cp, \p ca, \p cf, and \p d.

    Output mode selection:

    | bit | Description             |  0          |  1          |
    |:---:|:------------------------|:------------|:------------|
    |  0  | output mode             | numerical   | string      |
    | 1-3 | string mode format      | see table   | see table   |
    |  4  | field separator mode    | not at end  | all         |

    String output modes:

    |     | B3  | B2  | B1  | B0  | Description                              |
    |:---:|:---:|:---:|:---:|:---:|:-----------------------------------------|
    |  1  |  0  |  0  |  0  |  1  | list of bare strings, each "NxM"         |
    |  3  |  0  |  0  |  1  |  1  | text format 1                            |
    |  9  |  1  |  0  |  0  |  1  | html format 1                            |
    | 15  |  1  |  1  |  1  |  1  | custom formatting (uses \p cs)           |

    Example outputs for \c v = ["a","b","a","c","a","b"]:
    - \c m=0 (numerical): \c [["a",3],["b",2],["c",1]]
    - \c m=1 (bare strings): \c ["3xa","2xb","1xc"]
    - \c m=3 (text format): \c "3<a> 2<b> 1<c>"
    - \c m=9 (html format): formatted as superscript-count + italic-value pairs

  \note histogram() uses unique() followed by a find() scan per unique
        value. Both are O(n) per call over the full list, making the
        combined complexity O(n*k) where k is the number of unique
        values — effectively O(n^2) in the worst case. Avoid passing
        very large lists.
*******************************************************************************/
function histogram
(
  v,
  m = 0,
  cs,
  cb,
  cp,
  ca,
  cf,
  d = false
) = let
    (
      hv = [for (i=unique(v)) [i, len(find(i, v, 0))]]
    )
    binary_bit_is(m, 0, 0) ? hv
  : let
    (
      sm = binary_iw2i(m, 1, 3),
      fm = binary_bit_is(m, 4, 1) ? true : false
    )
    (sm == 0) ? [for (i=hv) str(first(i), "x", second(i))]
  : let
    (
      s1 = (sm==1) ? empty_str
         : (sm==4) ? empty_str
         :           (is_list(cs) && len(cs) > 0 ? cs[0] : empty_str),
      s2 = (sm==1) ? "<"
         : (sm==4) ? "x"
         :           (is_list(cs) && len(cs) > 1 ? cs[1] : empty_str),
      s3 = (sm==1) ? ">"
         : (sm==4) ? empty_str
         :           (is_list(cs) && len(cs) > 2 ? cs[2] : empty_str),
      fs = (sm==1) ? " "
         : (sm==4) ? ", "
         :           (is_list(cs) && len(cs) > 3 ? cs[3] : empty_str),
      fb = (sm==1) ? undef
         : (sm==4) ? undef
         :           cb,
      fp = (sm==1) ? undef
         : (sm==4) ? [undef, undef, ["i", "sup"], ["b", "sup"], undef]
         :           cp,
      fa = (sm==1) ? undef
         : (sm==4) ? [undef, undef, undef, undef, undef, ["br"]]
         :           ca,
      ff = (sm==1) ? undef
         : (sm==4) ? undef
         :           cf,
      n  = len(hv)
    )
    strl
    ([
      for (i=[0:n-1])
        strl_html
        (
          [s1, first(hv[i]), s2, second(hv[i]), s3, if ((i<(n-1)) || fm) fs],
          b=fb, p=fp, a=fa, f=ff, d=d
        ),
    ]);

//! @}
//! @}

//----------------------------------------------------------------------------//
// openscad-amu auxiliary scripts
//----------------------------------------------------------------------------//

/*
BEGIN_SCOPE validate;
  BEGIN_OPENSCAD;
    include <omdl-base.scad>;
    include <common/validation.scad>;

    echo( str("openscad version ", version()) );
    for (i=[1:2]) echo( "not tested:" );

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
