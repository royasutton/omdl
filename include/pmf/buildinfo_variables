#!/usr/bin/make -f
################################################################################
#
# Buildinfo
#
################################################################################

################################################################################
# Variables
################################################################################

# output file names in output directory
buildinfo_stamp := $(addprefix $(buildinfo_output_path),$(buildinfo_stamp_name))

# clean Files
buildinfo_clean_files := $(buildinfo_stamp)

#------------------------------------------------------------------------------#
# Configuration Variable List
#------------------------------------------------------------------------------#

buildinfo_config_variables := \
  buildinfo_output_prefix \
  buildinfo_output_ext \
  buildinfo_groups

buildinfo_config_derived := \
  buildinfo_stamp

#------------------------------------------------------------------------------#
# Help Text
#------------------------------------------------------------------------------#

define help_text_buildinfo
 all-buildinfo:
     create build information files

 clean-buildinfo:
     clean build information files

 install-buildinfo, uninstall-buildinfo:
     do nothing.

 info-buildinfo:
     buildinfo components information.
endef

################################################################################
# eof
################################################################################
