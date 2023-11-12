################################################################################
# Module
################################################################################
$(eval $(call clear-local-module))
#------------------------------------------------------------------------------#

local_path        :=  database

local_library     :=  docs_module

local_release_add :=

local_backup_add  :=

local_submodules  :=  component \
                      geometry \
                      material

#------------------------------------------------------------------------------#
# add local module
#------------------------------------------------------------------------------#
$(eval $(call add-local-module))

################################################################################
# eof
################################################################################
