################################################################################
# Library Module
################################################################################

local_path        :=  math

local_library     :=  module \
                      \
                      math-base \
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
# add local module
#------------------------------------------------------------------------------#
$(eval $(call add-local-module))
$(eval $(call clear-local-module))

################################################################################
# eof
################################################################################
