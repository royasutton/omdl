################################################################################
# Module
################################################################################

local_path        :=  math

local_library     :=  math-base \
                      \
                      math_linear_algebra \
                      math_vector_algebra \
                      \
                      math_bitwise \
                      math_oshapes \
                      math_polytope \
                      math_triangle \
                      math_utility

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
