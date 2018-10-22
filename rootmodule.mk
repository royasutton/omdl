################################################################################
# Library Root Module
################################################################################

local_path        :=

local_library     :=  mainpage \
                      rootmodule \
                      \
                      omdl-base \
                      \
                      console \
                      constants \
                      validation

local_backup_add  :=

local_submodules  :=  datatypes \
                      math \
                      parts \
                      shapes \
                      tools \
                      units \
                      \
                      database

# add only when present
local_submodules  +=  $(wildcard database_src)

# add (this) root module
library_modules   +=  $(lastword $(MAKEFILE_LIST))

#------------------------------------------------------------------------------#
# add root module
#------------------------------------------------------------------------------#
$(eval $(call add-local-module))
$(eval $(call clear-local-module))

################################################################################
# eof
################################################################################
