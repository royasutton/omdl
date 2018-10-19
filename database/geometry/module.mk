################################################################################
# Module
################################################################################

local_path        :=  database/geometry

local_library     :=

local_files_add   :=

local_submodules  :=  polyhedra

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
