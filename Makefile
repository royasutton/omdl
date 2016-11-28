#!/usr/bin/make -f
################################################################################
#
#  (openscad-amu): Project Makefile omdl
#
################################################################################

AMU_LIB_PATH        := /usr/local/share/openscad-amu/v1.7
AMU_TOOL_PREFIX     := /usr/local/bin/
AMU_TOOL_VERSION    := v1.7

AMU_PM_PREFIX       := $(AMU_LIB_PATH)/include/pmf/

#AMU_PM_VERBOSE     := defined
#AMU_PM_DEBUG       := defined

include $(AMU_PM_PREFIX)amu_pm_init

#------------------------------------------------------------------------------#
# Default Overrides
#------------------------------------------------------------------------------#
#parallel_jobs                          := $(true)
#target_headings                        := $(false)
#verbose_seam                           := $(false)
#debug_dif_filter                       := $(true)

version_checks                          := $(true)
targets_depends_project                 := $(true)
generate_latex                          := $(true)

release_project                         := $(false)
release_library                         := $(true)
release_archive_doxygen                 := $(true)
release_archive_scopes                  := $(false)

#------------------------------------------------------------------------------#
# Version Checks
#------------------------------------------------------------------------------#
ifeq ($(version_checks),$(true))
$(call check_version,amuseam,ge,1.7,$(true),requires openscad-amu v1.7 or later.)
endif

#------------------------------------------------------------------------------#
# Project
#------------------------------------------------------------------------------#
project_name        := omdl
project_version     := 0.1
project_brief       := OpenSCAD Mechanical Design Library

docs_group_id       := framework
project_logo        :=
seam_defines        := INCLUDE_PATH=include

doxygen_config      := Doxyfile
project_files_add   := $(wildcard include/*.mfs)

library             := mainpage \
                       constants \
                       math \
                       utilities \
                       console \
                       units_angle \
                       units_length \
                       resolution \
                       table \
                       transform \
                       shapes2d \
                       shapes2de \
                       shapes3d

backup_files_add    := README.md \
                       lgpl-2.1.txt

release_files_add         := $(backup_files_add)
release_archive_files_add := $(backup_files_add)

# temp
edit: ; geany Makefile $(src_files)

#------------------------------------------------------------------------------#
include $(AMU_PM_PREFIX)amu_pm_rules
################################################################################
# eof
################################################################################
