################################################################################
# Module
################################################################################
$(eval $(call clear-local-module))
#------------------------------------------------------------------------------#

local_path        :=  tools

local_library     :=  docs_module \
                      \
                      align \
                      extrude \
                      operation_cs \
                      polytope \
                      repeat

local_release_add :=

local_backup_add  :=

local_submodules  := drafting

#------------------------------------------------------------------------------#
# add local module
#------------------------------------------------------------------------------#
$(eval $(call add-local-module))

################################################################################
# eof
################################################################################
