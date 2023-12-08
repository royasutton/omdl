#!/usr/bin/make -f
################################################################################
#
# OpenSCAD Mechanical Design Library (omdl)
# Project Makefile
#
################################################################################

AMU_TOOL_VERSION                  := v2.9

AMU_TOOL_PREFIX                   := /usr/local/bin/
AMU_LIB_PATH                      := /usr/local/share/openscad-amu/$(AMU_TOOL_VERSION)

AMU_PM_PREFIX                     := $(AMU_LIB_PATH)/include/pmf/
AMU_PM_INIT                       := $(AMU_PM_PREFIX)amu_pm_init
AMU_PM_RULES                      := $(AMU_PM_PREFIX)amu_pm_rules
AMU_PM_DESIGN_FLOW                := df1/

# 'modules' extension to openscad-amu for omdl
AMU_PM_COMPONENTS_LOCAL_PATH      := include/pmf
AMU_PM_COMPONENTS_LOCAL           := modules

# Uncomment for increased verbosity and/or debugging.
# AMU_PM_VERBOSE                  := defined
# AMU_PM_DEBUG                    := defined

# Include asserts announcements
include $(AMU_PM_COMPONENTS_LOCAL_PATH)/announcements

#------------------------------------------------------------------------------#
# Design Flow Init (DO NO EDIT THIS SECTION)
#------------------------------------------------------------------------------#
ifeq ($(wildcard $(AMU_PM_INIT)),)
  $(info $(call ANNOUNCE_AMU_INIT,AMU_PM_INIT,$(AMU_PM_INIT)))
  $(error unable to continue.)
else
  include $(AMU_PM_INIT)
endif

# Include tools and configurations assertions
include $(AMU_PM_COMPONENTS_LOCAL_PATH)/assertions

#------------------------------------------------------------------------------#
# Overrides to Default Design Flow Configuration
#------------------------------------------------------------------------------#
# target_headings                 := $(false)
# verbose_seam                    := $(false)
# debug_seam_scanner              := $(trueq)
# debug_dif_filter                := $(true)
# debug_dif_scanner               := $(true)

# ignore_modules_exclude          := $(true)
# ignore_scopes_exclude           := $(true)

output_root                       := build
output_path_add_project_version   := $(false)

scopes_output_prefix              := amu/
prefix_scopes_output_path         := $(true)
prefix_scopes_output_prefix       := $(true)
prefix_scopes_input_prefix        := $(true)

doxygen_output_prefix             := docs/
prefix_doxygen_output_path        := $(true)
prefix_doxygen_output_prefix      := $(true)

targets_depends_project           := $(false)
version_checks                    := $(true)
version_checks_skip_warnings      := $(true)
generate_latex                    := $(false)

release_root                      := release
release_project                   := $(false)
release_library                   := $(false)
release_archive_project           := $(false)
release_archive_doxygen           := $(true)
release_archive_scopes            := $(false)

backup_root                       := backups

#------------------------------------------------------------------------------#
# Library Build Configuration
#------------------------------------------------------------------------------#
project_name                      := omdl
project_version                   := $(shell git describe --tags --dirty --always)
project_brief                     := OpenSCAD Mechanical Design Library

docs_group_id                     := omdl
project_logo                      := docs_start_logo_top_55x55
seam_defines                      := INCLUDE_PATH=include/mfs

doxygen_config                    := share/doxygen/Doxyfile
doxygen_html_footer               := share/doxygen/html_footer.html
doxygen_html_css                  := share/doxygen/html_style.css
doxygen_layout                    := share/doxygen/html_layout.xml

project_files_add                 := $(wildcard include/mf/*) \
                                     $(wildcard include/mfs/*.mfs) \
                                     $(wildcard include/amu/*.amu)

library_info                      := README.md \
                                     lgpl-2.1.txt

# Excluded Modules:
# to exclude nothing from the command line, use: $ make modules_exclude="" all
# or set 'ignore_modules_exclude := $(true)' above

modules_exclude                   := parts \
                                     database/component \
                                     database/material

# Excluded Scopes:
# to exclude nothing from the command line, use: $ make scopes_exclude="" all
# or set 'ignore_scopes_exclude := $(true)' above

# exclude shape manifests; required only when doing a library "release."
scopes_exclude                    := manifest

# exclude database tests and statitics
scopes_exclude                    += db_autotest \
                                     db_autostat

# Release Files Additions:
# use recursive assignment '=' for references that use derived paths
release_files_add                  = $(library_info) \
                                     $(modules_release_add)

release_archive_files_add          = $(library_info)

# Backup Files Additions:
backup_files_add                  := $(library_info) \
                                     $(modules_backup_add)

#------------------------------------------------------------------------------#
# Include Root Library Module
#------------------------------------------------------------------------------#
include module.mk

#------------------------------------------------------------------------------#
# Design Flow Rules (DO NO EDIT THIS SECTION)
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
