################################################################################
# Module
################################################################################

local_path        :=  tools

local_library     :=  module \
                      \
                      tools_align \
                      tools_edge \
                      tools_polytope \
                      tools_utility

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
