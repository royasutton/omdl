################################################################################
# Library Module
################################################################################

local_path        :=  database/component/electrical

local_library     :=  module

local_backup_add  :=

local_submodules  :=

#------------------------------------------------------------------------------#
# add module
#------------------------------------------------------------------------------#

$(eval \
  $(call add-module, \
    $(local_path), \
    $(local_library), \
    $(local_backup_add), \
    $(local_submodules) \
  ) \
)

# local cleanup
undefine local_path
undefine local_library
undefine local_backup_add
undefine local_submodules

################################################################################
# eof
################################################################################
