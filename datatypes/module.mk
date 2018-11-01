################################################################################
# Module
################################################################################
$(eval $(call clear-local-module))
#------------------------------------------------------------------------------#

local_path        :=  datatypes

local_library     :=  module \
                      \
                      datatypes-base \
                      \
                      datatypes_identify_scalar \
                      datatypes_identify_iterable \
                      datatypes_identify_list \
                      datatypes_operate_scalar \
                      datatypes_operate_iterable \
                      datatypes_operate_list \
                      \
                      datatypes_map \
                      datatypes_table

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
