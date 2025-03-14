################################################################################
# Module
################################################################################
$(eval $(call clear-local-module))
#------------------------------------------------------------------------------#

local_path        :=  database/component/motion

local_library     :=  docs_module \
                      \
                      bearing_linear_lmxuu \
                      bearing_radial_ball \
                      motor_nema_stepper

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
