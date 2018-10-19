################################################################################
# Library Module
################################################################################

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
