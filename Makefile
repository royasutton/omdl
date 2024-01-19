#!/usr/bin/make -f
################################################################################
#
# OpenSCAD Mechanical Design Library (omdl)
# Project Makefile
#
################################################################################

AMU_TOOL_VERSION                  := v3.2

AMU_TOOL_PREFIX                   := /usr/local/bin/
AMU_LIB_PATH                      := /usr/local/share/openscad-amu/$(AMU_TOOL_VERSION)

AMU_PM_PREFIX                     := $(AMU_LIB_PATH)/include/pmf/
AMU_PM_INIT                       := $(AMU_PM_PREFIX)amu_pm_init
AMU_PM_RULES                      := $(AMU_PM_PREFIX)amu_pm_rules
AMU_PM_DESIGN_FLOW                := df1/

# openscad-amu component extensions to for omdl
AMU_PM_COMPONENTS_LOCAL_PATH      := include/pmf
AMU_PM_COMPONENTS_LOCAL           := modules \
                                     buildinfo

# Uncomment for increased verbosity and/or debugging.
# AMU_PM_VERBOSE                  := defined
# AMU_PM_DEBUG                    := defined

#------------------------------------------------------------------------------#
# Path overrides (for development snapshots, change. ie:)
# path_openscad                   := openscad-nightly
# version_checks                  := $(false)
#------------------------------------------------------------------------------#
path_openscad                     :=
path_doxygen                      :=

#------------------------------------------------------------------------------#
# Design Flow Init (DO NO EDIT THIS SECTION)
#------------------------------------------------------------------------------#
# Include asserts announcements
include $(AMU_PM_COMPONENTS_LOCAL_PATH)/announcements

ifeq ($(wildcard $(AMU_PM_INIT)),)
  $(info $(call ANNOUNCE_AMU_INIT,AMU_PM_INIT,$(AMU_PM_INIT)))
  $(error unable to continue.)
else
  include $(AMU_PM_INIT)
endif

# Design Flow toolchain version checks or warnings
version_checks                    := $(true)
version_checks_skip_warnings      := $(false)

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

output_path_add_project_version   := $(false)

prefix_scopes_output_path         := $(true)
prefix_scopes_output_prefix       := $(true)
prefix_scopes_input_prefix        := $(true)

prefix_doxygen_output_path        := $(true)
prefix_doxygen_output_prefix      := $(true)

prefix_buildinfo_output_path      := $(true)
prefix_buildinfo_output_prefix    := $(true)
buildinfo_depends_scopes          := $(true)
doxygen_depends_buildinfo         := $(true)

targets_depends_project           := $(false)
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

output_root                       := build

scopes_output_prefix              := amu/
seam_defines                      := INCLUDE_PATH=include/mfs

doxygen_output_prefix             := docs/
doxygen_config                    := share/doxygen/Doxyfile
doxygen_html_footer               := share/doxygen/html_footer.html
doxygen_html_css                  := share/doxygen/html_style.css
doxygen_layout                    := share/doxygen/html_layout.xml

docs_group_id                     := omdl
project_logo                      := docs_start_logo_top_55x55

buildinfo_output_prefix           := docs/buildinfo/

project_files_add                 := $(wildcard include/pmf/*) \
                                     $(wildcard include/mfs/*.mfs) \
                                     $(wildcard include/amu/*.amu)

library_info                      := README.md \
                                     gnu-lgpl-v2.1.txt

# Excluded Modules:
# to exclude nothing from the command line, use: $ make modules_exclude="" all
# or set 'ignore_modules_exclude := $(true)' above

modules_exclude                   := database/material

# Excluded Scopes:
# to exclude nothing from the command line, use: $ make scopes_exclude="" all
# or set 'ignore_scopes_exclude := $(true)' above

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
