#!/usr/bin/make -f
################################################################################
#
# Project Makefile
# OpenSCAD Mechanical Design Library (omdl)
#
################################################################################

AMU_TOOL_VERSION              := v2.7

AMU_TOOL_PREFIX               := /usr/local/bin/
AMU_LIB_PATH                  := /usr/local/share/openscad-amu/$(AMU_TOOL_VERSION)

AMU_PM_PREFIX                 := $(AMU_LIB_PATH)/include/pmf/
AMU_PM_INIT                   := $(AMU_PM_PREFIX)amu_pm_init
AMU_PM_RULES                  := $(AMU_PM_PREFIX)amu_pm_rules
AMU_PM_DESIGN_FLOW            := df1/

AMU_PM_COMPONENTS_LOCAL_PATH  := include/pmf
AMU_PM_COMPONENTS_LOCAL       := modules

# Uncomment following for increased verbosity and/or debugging.
# AMU_PM_VERBOSE              := defined
# AMU_PM_DEBUG                := defined

#------------------------------------------------------------------------------#
# Project Announcements
#------------------------------------------------------------------------------#
define ANNOUNCE_AMU_INIT

  [$1] file not found...
  Tried [$2].

  Please review the definitions at the top of $(firstword $(MAKEFILE_LIST)) and
  update as needed for your installation.

endef

define ANNOUNCE_AMU_VERSION

  This library has been designed and tested to work with openscad-amu $1
  or later. To install:

  $$ wget http://git.io/setup-amu.bash && chmod +x setup-amu.bash
  $$ sudo ./setup-amu.bash --branch $(AMU_TOOL_VERSION) --yes --install

endef

define ANNOUNCE_OPENSCAD_VERSION

  This library has been designed and tested to work with OpenSCAD $1.

  Please make sure this version is available in the search path. This
  or all version checks can be disabled in this project makefile using
  the control variable [version_checks] or individually in the tools
  assertions section.

  see: $(firstword $(MAKEFILE_LIST))
  See: http://www.openscad.org/downloads.html

endef

define ANNOUNCE_IMAGEMAGICK_POLICY

  The current ImageMagick security policy denies access rights ($2)
  to a coder ($1) required to compile this library. Please grant
  these rights in the policy.xml file as follows;

    <policy domain="coder" rights="$3" pattern="$1" />

  command:

    $$ policy_path=$$(identify -list configure |
        sed -n "/CONFIGURE_PATH/s/CONFIGURE_PATH[[:space:]]*//p")

    $$ sudo sed -i.orig $\\
        '/"$1"/s/rights="[^"]*"/rights="$3"/' $\\
        $${policy_path}policy.xml

  See: http://imagemagick.org/script/security-policy.php

endef

#------------------------------------------------------------------------------#
# Include Design Flow Init (DO NO EDIT THIS SECTION)
#------------------------------------------------------------------------------#
ifeq ($(wildcard $(AMU_PM_INIT)),)
  $(info $(call ANNOUNCE_AMU_INIT,AMU_PM_INIT,$(AMU_PM_INIT)))
  $(error unable to continue.)
else
  include $(AMU_PM_INIT)
endif

#------------------------------------------------------------------------------#
# Overrides to Design Flow Configuration Defaults
#------------------------------------------------------------------------------#
# target_headings                       := $(false)
# verbose_seam                          := $(false)
# debug_dif_filter                      := $(true)

output_root                             := build
output_path_add_project_version         := $(false)

scopes_output_prefix                    := amu/
prefix_scopes_output_path               := $(true)
prefix_scopes_output_prefix             := $(true)
prefix_scopes_input_prefix              := $(true)

doxygen_output_prefix                   := docs/
prefix_doxygen_output_path              := $(true)
prefix_doxygen_output_prefix            := $(true)

targets_depends_project                 := $(false)
version_checks                          := $(true)
version_checks_skip_warnings            := $(true)
generate_latex                          := $(false)

release_root                            := release
release_project                         := $(false)
release_library                         := $(false)
release_archive_project                 := $(false)
release_archive_doxygen                 := $(true)
release_archive_scopes                  := $(false)

backup_root                             := backups

#------------------------------------------------------------------------------#
# Design Flow Tools Assertions
#------------------------------------------------------------------------------#
ifeq ($(version_checks),$(true))

# require recent OpenSCAD version.
$(call check_version,openscad,eq,2021.01,$(true), \
  $(call ANNOUNCE_OPENSCAD_VERSION,2021.01) \
)

# require openscad-amu version stated by $(AMU_TOOL_VERSION).
$(call check_version,amuseam,ge,$(subst v,,$(AMU_TOOL_VERSION)),$(true), \
  $(call ANNOUNCE_AMU_VERSION,$(AMU_TOOL_VERSION)) \
)

# warn of known build issue when latax output configured.
ifeq ($(generate_latex),$(true))
$(call check_version,doxygen,le,1.8.9.1,$(true), \
  latex output broken since v1.8.9.1. \
)
endif

# require imagemagick/convert utility has eps-coder access rights.
ifneq ($(shell identify -list policy | $(grep) EPS),)
  ifneq ($(strip $(shell \
          identify -list policy \
          | $(sed) -n '/pattern: EPS/{x;p;d;}; x' \
          | $(sed) -n 's/^.*rights:[[:space:]]*//p' \
       )),Read Write)
    $(error $(call ANNOUNCE_IMAGEMAGICK_POLICY,EPS,Read Write,read|write))
  endif
endif

endif

#------------------------------------------------------------------------------#
# Library Project Basics
#------------------------------------------------------------------------------#
project_name        := omdl
project_version     := $(shell git describe --tags --dirty --always)
project_brief       := OpenSCAD Mechanical Design Library

docs_group_id       := primitives
project_logo        := mainpage_logo_top_55x55
seam_defines        := INCLUDE_PATH=include/mfs

doxygen_config      := Doxyfile
doxygen_html_footer := Doxyfooter.html
doxygen_html_css    := Doxystyle.css

project_files_add   := $(wildcard include/mf/*) \
                       $(wildcard include/mfs/*.mfs) \
                       $(wildcard include/amu/*.amu)

library_info        := README.md \
                       lgpl-2.1.txt

#------------------------------------------------------------------------------#
# Include Library Modules
#------------------------------------------------------------------------------#

# root module
include rootmodule.mk

#------------------------------------------------------------------------------#
# Excluded Design Flow Scopes
#------------------------------------------------------------------------------#
# to exclude nothing (ie: build everything) from the command line, use:
# make scopes_exclude="" all

# exclude shape manifests; required only when doing a library "release."
scopes_exclude                := manifest

# exclude database tests and statitics; required for complete documentation
# build, but may be skipped during routine library development.
scopes_exclude                += db_autotest \
                                 db_autostat

#------------------------------------------------------------------------------#
# Design Flow Release Additions
#------------------------------------------------------------------------------#
# use recursive assignment '=' for references that use derived paths
release_files_add              = $(library_info) \
                                 $(modules_release_add)

release_archive_files_add      = $(library_info)

#------------------------------------------------------------------------------#
# Library Source Backup Additions
#------------------------------------------------------------------------------#
backup_files_add              := $(library_info) \
                                 $(modules_backup_add)

#------------------------------------------------------------------------------#
# Include Design Flow Rules (DO NO EDIT THIS SECTION)
#------------------------------------------------------------------------------#
ifeq ($(wildcard $(AMU_PM_RULES)),)
  $(info $(call ANNOUNCE_AMU_INIT,AMU_PM_RULES,$(AMU_PM_RULES)))
  $(error unable to continue.)
else
  include $(AMU_PM_RULES)
endif

################################################################################
# eof
################################################################################
