#!/usr/bin/make -f
################################################################################
#
# Buildinfo
#
################################################################################

################################################################################
# Rules
################################################################################

# Instantiate rules for each group in 'buildinfo_groups' list.
$(foreach g, \
  $(buildinfo_groups), \
  $(eval $(call buildinfo_target,$(g))) \
)

#------------------------------------------------------------------------------#
# Build Targets
#------------------------------------------------------------------------------#

.PHONY: all-buildinfo
all-buildinfo:
	$(call target_end)

# buildinfo stamp
$(buildinfo_stamp): | $(buildinfo_output_path)
	$(call target_begin)
	$(touch) $(buildinfo_stamp)

# make buildinfo_stamp depend on 'all-building' as configured
ifeq ($(generate_buildinfo),$(true))
all-buildinfo: $(buildinfo_stamp)
endif

# make doxygen depend on buildinfo_stamp as configured
ifeq ($(doxygen_depends_buildinfo),$(true))
$(doxygen_stamp): $(buildinfo_stamp)
endif

# create target directories (iff not empty)
ifneq ($(buildinfo_output_path),$(empty))
$(buildinfo_output_path): ; $(mkdir_p) $@
endif

#------------------------------------------------------------------------------#
# Clean Targets
#------------------------------------------------------------------------------#

.PHONY: clean-buildinfo
clean-buildinfo:
	$(call target_begin)
	-$(if $(generate_buildinfo),$(rm_f) $(buildinfo_clean_files))
	-$(if $(generate_buildinfo),$(rmdir_p) $(buildinfo_output_path))
	$(call target_end)

#------------------------------------------------------------------------------#
# Install / Uninstall Targets
#------------------------------------------------------------------------------#

.PHONY: install-buildinfo
install-buildinfo: | silent
	$(call target_end)

.PHONY: uninstall-buildinfo
uninstall-buildinfo: | silent
	$(call target_end)

#------------------------------------------------------------------------------#
# Information Targets
#------------------------------------------------------------------------------#

.PHONY: info-buildinfo
info-buildinfo: | silent
	$(call heading1, Buildinfo)
	$(call list_variables,$(buildinfo_control_variables),$(true), control)
	$(call list_variables,$(buildinfo_config_variables),$(false), variables)
	$(call list_variables,$(buildinfo_config_derived),$(false), derived)

################################################################################
# eof
################################################################################
