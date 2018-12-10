################################################################################
# Module
################################################################################
$(eval $(call clear-local-module))
#------------------------------------------------------------------------------#

local_path        :=  math

local_library     :=  module \
                      \
                      math-base \
                      \
                      linear_algebra \
                      vector_algebra \
                      \
                      bitwise \
                      polygon_shapes \
                      polytope \
                      triangle \
                      utility

local_release_add :=

local_backup_add  :=

local_submodules  :=

#------------------------------------------------------------------------------#
# add local module
#------------------------------------------------------------------------------#
$(eval $(call add-local-module))

################################################################################
# eof
################################################################################