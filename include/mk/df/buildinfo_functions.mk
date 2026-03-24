#!/usr/bin/make -f
################################################################################
#
# Buildinfo
#
################################################################################

################################################################################
# Functions
################################################################################

#------------------------------------------------------------------------------#
#  General
#------------------------------------------------------------------------------#

# buildinfo_output_path (empty)
# returns output directory for current configuration.
define buildinfo_output_path
$(amu_pm_d0)$(call join_with,$(empty),
  $(if $(call bool_decode,$(prefix_buildinfo_output_path)),$(output_path))
  $(if $(call bool_decode,$(prefix_buildinfo_output_prefix)),$(buildinfo_output_prefix))
)
endef

# buildinfo_target_name (arg1)
# arg1: target group name.
# returns target output filename for named group.
buildinfo_target_name = $(buildinfo_output_path)$1$(buildinfo_output_ext)

#------------------------------------------------------------------------------#
# Build Information Rules Generation
#------------------------------------------------------------------------------#

# buildinfo_target (arg1)
# arg1: target group name.
# returns rules for generating output for named group.
define buildinfo_target
$(call buildinfo_target_name,$1): | $(buildinfo_output_path)
$(amu_pm_d1)

	$$(call target_begin)
	$$(file > $$@,$$(call build_info_$1))
	$$(call target_end)

# add dependency on source files unconditional
$(call buildinfo_target_name,$1): $(src_files)

# add dependency on project files as configured
ifeq ($(targets_depends_project),$(true))
$(call buildinfo_target_name,$1): $(MAKEFILE_LIST) $(project_files_add)
endif

# add dependency on scopes stamp as configured
ifeq ($(buildinfo_depends_scopes),$(true))
$(call buildinfo_target_name,$1): $(scopes_stamp)
endif

# add buildinfo_stamp dependency on this target
$(buildinfo_stamp): $(call buildinfo_target_name,$1)

# add to clean file list
buildinfo_clean_files += $(call buildinfo_target_name,$1)
endef

#------------------------------------------------------------------------------#
# Build Information Group Output Functions
#------------------------------------------------------------------------------#
# add a space (' ') after '^' so that columns are rendered for empty values

# build_info_general (empty)
define build_info_general
  omdl version^ $(project_version)^
  openscad-amu version^ $(AMU_TOOL_VERSION)^
  openscad-amu prefix^ $(AMU_TOOL_PREFIX)^
  selected groups^ $(words $(groups))^
  library files^ $(words $(src_files))^
  project makefiles^ $(words $(MAKEFILE_LIST))^
  source-embedded openscad-amu auxiliary scripts^ $(words $(scopes_scripts_source))^
  selected auxiliary scripts^ $(words $(scopes_scripts_selected))^
  selected auxiliary makefile scripts^ $(words $(scopes_mfs))^
  selected auxiliary makefiles^ $(words $(scopes_mf))^
  build os^ $(os)^
  architecture^ $(arch)^
  build date^ $(datetime)^
endef

# build_info_toolchain (empty)
define build_info_toolchain
  openscad_dif^ $(amudifvn)^ $(path_openscad_dif)^
  openscad_seam^ $(amuseamvn)^ $(path_openscad_seam)^
  OpenSCAD^ $(openscadvn)^ $(path_openscad)^
  Doxygen^ $(doxygenvn)^ $(path_doxygen)^
  Bash^ $(bashvn)^ $(path_bash)^
  GNU Make^ $(gnumakevn)^ $(path_gnumake)^
endef

# build_info_components (empty)
define build_info_components
  OMDL_PM_PATH^ ---^$(OMDL_PM_PATH)^
  AMU_TOOL_PREFIX^ ---^$(AMU_TOOL_PREFIX)^
  AMU_LIB_PATH^ ---^$(AMU_LIB_PATH)^
  AMU_PM_PREFIX^ ---^$(AMU_PM_PREFIX)^
  AMU_PM_SUFFIX^ ---^$(AMU_PM_SUFFIX)^
  AMU_PM_DESIGN_FLOW^ ---^$(AMU_PM_DESIGN_FLOW)^
  AMU_PM_COMPONENTS^ $(words $(AMU_PM_COMPONENTS))^ $(if $(AMU_PM_COMPONENTS),$(AMU_PM_COMPONENTS),---)^
  AMU_PM_PREFIX_LOCAL^ ---^$(AMU_PM_PREFIX_LOCAL)^
  AMU_PM_SUFFIX_LOCAL^ ---^$(AMU_PM_SUFFIX_LOCAL)^
  AMU_PM_COMPONENTS_LOCAL^ $(words $(AMU_PM_COMPONENTS_LOCAL))^ $(if $(AMU_PM_COMPONENTS_LOCAL),$(AMU_PM_COMPONENTS_LOCAL),---)^
endef

# build_info_scopes (empty)
define build_info_scopes
  ignore_scopes_include^ ---^ \$(call bool_string,$(ignore_scopes_include))^
  ignore_scopes_exclude^ ---^ \$(call bool_string,$(ignore_scopes_exclude))^
  scopes_include^ $(words $(scopes_include))^ $(if $(scopes_include),(scopes_include),---)^
  scopes_exclude^ $(words $(scopes_exclude))^ $(if $(scopes_exclude),$(scopes_exclude),---)^
  scopes_scripts_source^ $(words $(scopes_scripts_source))^ $(if $(scopes_scripts_source),...,---)^
  scopes_scripts_selected^ $(words $(scopes_scripts_selected))^ $(if $(scopes_scripts_selected),...,---)^
  scopes_mfs^ $(words $(scopes_mfs))^ $(if $(scopes_mfs),...,---)^
  scopes_mf^ $(words $(scopes_mf))^ $(if $(scopes_mf),...,---)^
endef

# build_info_groups (empty)
define build_info_groups
  ignore_groups_exclude^ ---^ \$(call bool_string,$(ignore_groups_exclude))^
  groups_exclude^ $(words $(groups_exclude))^ $(if $(groups_exclude),$(groups_exclude),---)^
  groups^ $(words $(groups))^ $(if $(groups),...,---)^
endef

# build_info_sources (empty)
define build_info_sources
  design^ $(words $(design))^ $(if $(design),...,----)^
  library^ $(words $(library))^ $(if $(library),...,---)^
endef

################################################################################
# eof
################################################################################
