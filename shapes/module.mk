################################################################################
# Module
################################################################################
$(eval $(call clear-local-module))
#------------------------------------------------------------------------------#

local_path        :=  shapes

local_library     :=  module \
                      \
                      derivative_2d \
                      derivative_2de \
                      derivative_3d

local_release_add :=  svg/derivative_2d_manifest.svg \
                      \
                      stl/derivative_2de_manifest.stl \
                      stl/derivative_3d_manifest_1.stl \
                      stl/derivative_3d_manifest_2.stl \


local_backup_add  :=

local_submodules  :=

#------------------------------------------------------------------------------#
# add local module
#------------------------------------------------------------------------------#
$(eval $(call add-local-module))

################################################################################
# eof
################################################################################
