#!/usr/bin/make -f
################################################################################
#
#  (openscad-amu): Project Makefile omdl
#
################################################################################

AMU_LIB_PATH        := /usr/local/share/openscad-amu/v1.8
AMU_TOOL_PREFIX     := /usr/local/bin/
AMU_TOOL_VERSION    := v1.8

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

output_path_add_project_version         := $(false)

targets_depends_project                 := $(false)
version_checks                          := $(true)
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
project_version     := $(shell git describe --tags --dirty --always)
project_brief       := OpenSCAD Mechanical Design Library

docs_group_id       := primitives
project_logo        := mainpage_logo_top_55x55
seam_defines        := INCLUDE_PATH=include

doxygen_config      := Doxyfile
project_files_add   := $(wildcard include/*.mfs)

library_info        := README.md \
                       lgpl-2.1.txt

# Polyhedra
library_db01        := database/geometry/polyhedra/anti_prisms \
                       database/geometry/polyhedra/archimedean_duals \
                       database/geometry/polyhedra/archimedean \
                       database/geometry/polyhedra/cupolas \
                       database/geometry/polyhedra/dipyramids \
                       database/geometry/polyhedra/johnson \
                       database/geometry/polyhedra/platonic \
                       database/geometry/polyhedra/prisms \
                       database/geometry/polyhedra/pyramids \
                       database/geometry/polyhedra/trapezohedron \
                       database/geometry/polyhedra/polyhedra_all

library_db01_src    := database_src/geometry/polyhedra/Makefile \
                       database_src/geometry/polyhedra/src/Makefile \
                       database_src/geometry/polyhedra/src/convert \
                       database_src/geometry/polyhedra/src/convert.conf \
                       database_src/geometry/polyhedra/src/convert.text \
                       database_src/geometry/polyhedra/src/dist/fetch.bash \
                       database_src/geometry/polyhedra/src/dist/rename

library             := $(library_db01) \
                       \
                       mainpage \
                       constants \
                       datatypes \
                       datatypes_map \
                       datatypes_table \
                       math \
                       math_bitwise \
                       math_polytope \
                       math_utility \
                       utilities \
                       validation \
                       console \
                       units_angle \
                       units_coordinate \
                       units_length \
                       units_resolution \
                       shapes2d \
                       shapes2de \
                       shapes3d \
                       tools_align \
                       tools_edge \
                       tools_polytope \
                       tools_utility

#------------------------------------------------------------------------------#
# Scope excludes
#------------------------------------------------------------------------------#

# shape manifests: only requred when doing a release
scopes_exclude      := manifest

# database: normally pre-built and released by database makefiles
scopes_exclude      += db_autotest db_autostat

#------------------------------------------------------------------------------#
# Release and backup additions
#------------------------------------------------------------------------------#
# use recursive assignment '=' for references that use derived paths
# such as: $(output_path), $(release_path), etc.

release_files_add    = $(library_info) \
                       \
                       $(output_path)latex/refman.pdf \
                       \
                       $(output_path)stl/mainpage_quickstart.stl \
                       $(output_path)svg/shapes2d_manifest.svg \
                       $(output_path)stl/shapes2de_manifest.stl \
                       $(output_path)stl/shapes3d_manifest_1.stl \
                       $(output_path)stl/shapes3d_manifest_2.stl \
                       $(output_path)stl/tool_edge_manifest.stl

release_archive_files_add := $(library_info)

backup_files_add    := $(library_info) \
                       \
                       $(library_db01_src)

#------------------------------------------------------------------------------#
include $(AMU_PM_PREFIX)amu_pm_rules
################################################################################
# eof
################################################################################
