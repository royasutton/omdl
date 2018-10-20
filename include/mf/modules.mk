################################################################################
#
# Library Local-Modules
#
# Nonrecursive multi-directory scheme for modular library construction.
################################################################################

# append local module files to library file lists
#------------------------------------------------------------------------------#
# macro: add-module (arg1,arg2,arg3,arg4)
#------------------------------------------------------------------------------#
# arg1: local directory path
# arg2: list of local library files
# arg3: list of local files add to library backups
# arg4: list of submodules
#------------------------------------------------------------------------------#
define add-module
  # append module
  library             += $(if $(strip $2),$(addprefix $(if $(strip $1),$1/),$2))
  library_backup_add  += $(if $(strip $3),$(addprefix $(if $(strip $1),$1/),$3))
  library_modules     += $(if $(strip $4),$(addsuffix /module.mk,$(addprefix $(if $(strip $1),$1/),$4)))

  # include submodules
  include $(addsuffix /module.mk,$(addprefix $(if $(strip $1),$1/),$4))
endef

# simplified local module addition using assumed local variable names
#------------------------------------------------------------------------------#
# macro: add-local-module ()
#------------------------------------------------------------------------------#
define add-local-module
  $(call add-module, \
    $(local_path), \
    $(local_library), \
    $(local_backup_add), \
    $(local_submodules) \
  )
endef

# simplified local module cleanup using assumed local variable names
#------------------------------------------------------------------------------#
# macro: clear-local-module ()
#------------------------------------------------------------------------------#
define clear-local-module
  undefine local_path
  undefine local_library
  undefine local_backup_add
  undefine local_submodules
endef

#------------------------------------------------------------------------------#
# initialize library file lists
#------------------------------------------------------------------------------#
library             :=
library_backup_add  :=
library_modules     :=

################################################################################
# target rules
################################################################################

#------------------------------------------------------------------------------#
# target: info-modules
#------------------------------------------------------------------------------#
.PHONY: info-modules
info-modules: | silent
	$(call heading1, Project Modules)
	$(call enumerate_variable,library,$(false),$(false))
	$(call enumerate_variable,library_backup_add,$(false),$(false))
	$(call enumerate_variable,library_modules,$(false),$(false))

################################################################################
# eof
################################################################################
