################################################################################
# Root Module
################################################################################

local_path        :=

local_library     :=  mainpage \
                      \
                      omdl-base \
                      \
                      console \
                      constants \
                      validation

local_files_add   :=

local_submodules  :=  datatypes \
                      math \
                      shapes \
                      tools \
                      units \
                      \
                      database

# add only when present
local_submodules  +=  $(wildcard database_src)

#------------------------------------------------------------------------------#
# macro: add-module (local-path, local-libs, files-add, submodules)
#------------------------------------------------------------------------------#
define add-module
  # append module
  library           += $(if $(strip $2),$(addprefix $(if $(strip $1),$1/),$2))
  library_files_add += $(if $(strip $3),$(addprefix $(if $(strip $1),$1/),$3))
  library_modules   += $(if $(strip $4),$(addsuffix /module.mk,$(addprefix $(if $(strip $1),$1/),$4)))

  # include submodules
  include $(addsuffix /module.mk,$(addprefix $(if $(strip $1),$1/),$4))
endef

#------------------------------------------------------------------------------#
# target rule: info-modules
#------------------------------------------------------------------------------#
.PHONY: info-modules
info-modules: | silent
	$(call heading1, Project Modules)
	$(call enumerate_variable,library,$(false),$(false))
	$(call enumerate_variable,library_files_add,$(false),$(false))
	$(call enumerate_variable,library_modules,$(false),$(false))

#------------------------------------------------------------------------------#
# initialize library file lists
#------------------------------------------------------------------------------#
undefine library
undefine library_files_add
undefine library_modules

# add (this) rootmodule
library_modules   :=  $(lastword $(MAKEFILE_LIST))

#------------------------------------------------------------------------------#
# add module
#------------------------------------------------------------------------------#

$(eval \
  $(call add-module, \
    $(local_path), \
    $(local_library), \
    $(local_files_add), \
    $(local_submodules) \
  ) \
)

# local cleanup
undefine local_path
undefine local_library
undefine local_files_add
undefine local_submodules

################################################################################
# eof
################################################################################
