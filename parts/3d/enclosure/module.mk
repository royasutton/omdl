################################################################################
# Module
################################################################################
$(eval $(call clear-local-module))
#------------------------------------------------------------------------------#

local_path        :=  parts/3d/enclosure

local_library     :=  docs_module \
                      \
                      hole_finishes \
                      project_box_rectangle

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
