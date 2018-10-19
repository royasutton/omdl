################################################################################
# Module
################################################################################

local_path        :=  shapes

local_library     :=  shapes2d \
                      shapes2de \
                      shapes3d

local_files_add   :=

local_submodules  :=

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
