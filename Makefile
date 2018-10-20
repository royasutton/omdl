#!/usr/bin/make -f
################################################################################
#
# Project Makefile
# OpenSCAD Mechanical Design Library (omdl)
# requires the openscad-amu Design Flow.
#
################################################################################

AMU_TOOL_VERSION    := v2.1

AMU_TOOL_PREFIX     := /usr/local/bin/
AMU_LIB_PATH        := /usr/local/share/openscad-amu/$(AMU_TOOL_VERSION)

AMU_PM_PREFIX       := $(AMU_LIB_PATH)/include/pmf/
AMU_PM_INIT         := $(AMU_PM_PREFIX)amu_pm_init
AMU_PM_RULES        := $(AMU_PM_PREFIX)amu_pm_rules

# Uncomment following for increased verbosity and/or debugging.
# AMU_PM_VERBOSE    := defined
# AMU_PM_DEBUG      := defined

#------------------------------------------------------------------------------#
# Project Announcements
#------------------------------------------------------------------------------#
define AMU_SETUP_ANNOUNCE

 $1 not found...
 Tried [$2].

 Please update AMU_TOOL_PREFIX and AMU_LIB_PATH in $(lastword $(MAKEFILE_LIST))
 as needed for your installation or setup openscad-amu ($(AMU_TOOL_VERSION))
 using the following:

 $$ wget http://git.io/setup-amu.bash && chmod +x setup-amu.bash
 $$ sudo ./setup-amu.bash --branch $(AMU_TOOL_VERSION) --yes --install

endef

define OPENSCAD_SETUP_ANNOUNCE

  This library uses language features only available in recent versions
  of OpenSCAD. Please install a development snapshots released after
  $1.

  See: http://www.openscad.org/downloads.html#snapshots

endef

define IMAGEMAGICK_CODER_ANNOUNCE

  The current ImageMagick security policy denies access rights ($2)
  to the $1 coder required to compile this library.

  Please grant these rights by editing /etc/ImageMagick*/policy.xml.
  set: <policy domain="coder" rights="$3" pattern="$1" />

  See: http://imagemagick.org/script/security-policy.php

endef

#------------------------------------------------------------------------------#
# Design Flow Init (DO NO EDIT THIS SECTION)
#------------------------------------------------------------------------------#
ifeq ($(wildcard $(AMU_PM_INIT)),)
$(info $(call AMU_SETUP_ANNOUNCE,Init file,$(AMU_PM_INIT)))
$(error unable to continue.)
else
include $(AMU_PM_INIT)
endif

#------------------------------------------------------------------------------#
# Overrides to Design Flow Configuration Defaults
#------------------------------------------------------------------------------#
# parallel_jobs                         := $(true)
# target_headings                       := $(false)
# verbose_seam                          := $(false)
# debug_dif_filter                      := $(true)

output_path_add_project_version         := $(false)

targets_depends_project                 := $(false)
version_checks                          := $(true)
generate_latex                          := $(false)

release_project                         := $(false)
release_library                         := $(false)
release_archive_doxygen                 := $(true)
release_archive_scopes                  := $(false)

#------------------------------------------------------------------------------#
# Design Flow Tools Assertions
#------------------------------------------------------------------------------#
ifeq ($(version_checks),$(true))

$(call check_version,openscad,gt,2018.01,$(true), \
  $(call OPENSCAD_SETUP_ANNOUNCE,2018.01) \
)

$(call check_version,amuseam,ge,$(subst v,,$(AMU_TOOL_VERSION)),$(true), \
  requires openscad-amu $(AMU_TOOL_VERSION) or later. \
)

ifeq ($(generate_latex),$(true))
$(call check_version,doxygen,le,1.8.9.1,$(true), \
  latex output broken since v1.8.9.1. \
)
endif

ifneq ($(strip $(shell \
        identify -list policy \
        | sed -n '/pattern: EPS/{x;p;d;}; x' \
        | sed -n 's/^.*rights:[[:space:]]*//p' \
     )),Read Write)
  $(error $(call IMAGEMAGICK_CODER_ANNOUNCE,EPS,Read Write,read|write))
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

project_files_add   := $(wildcard include/mfs/*.mfs) \
                       $(wildcard include/mf/*.mk)

library_info        := README.md \
                       lgpl-2.1.txt

#------------------------------------------------------------------------------#
# Include Library Modules
#------------------------------------------------------------------------------#
# load module macros
include include/mf/modules.mk

# load root module
include $(local_module_name).mk

#------------------------------------------------------------------------------#
# Excluded Design Flow Scopes
#------------------------------------------------------------------------------#
# to exclude nothing (ie: build everything) from the command line, use:
# make scopes_exclude="" all

# exclude shape manifests; required only when doing a library "release."
scopes_exclude      := manifest

# exclude database tests and statitics; required for complete documentation
# build, but may be skipped during routine library development.
scopes_exclude      += db_autotest db_autostat

#------------------------------------------------------------------------------#
# Design Flow Release Additions
#------------------------------------------------------------------------------#
# use recursive assignment '=' for references that use derived paths
# such as: $(output_path), $(release_path), etc.
release_files_add    = $(library_info) \
                       \
                       $(output_path)stl/mainpage_quickstart.stl \
                       $(output_path)svg/shapes2d_manifest.svg \
                       $(output_path)stl/shapes2de_manifest.stl \
                       $(output_path)stl/shapes3d_manifest_1.stl \
                       $(output_path)stl/shapes3d_manifest_2.stl \
                       $(output_path)stl/tools_edge_manifest.stl

release_archive_files_add := $(library_info)

#------------------------------------------------------------------------------#
# Library Source Backup Additions
#------------------------------------------------------------------------------#
backup_files_add    := $(library_info) \
                       \
                       $(library_backup_add)

#------------------------------------------------------------------------------#
# Design Flow Rules (DO NO EDIT THIS SECTION)
#------------------------------------------------------------------------------#
ifeq ($(wildcard $(AMU_PM_RULES)),)
$(info $(call AMU_SETUP_ANNOUNCE,Rules file,$(AMU_PM_RULES)))
$(error unable to continue.)
else
include $(AMU_PM_RULES)
endif

################################################################################
# eof
################################################################################
