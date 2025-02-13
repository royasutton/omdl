################################################################################
# Root Module
################################################################################
$(eval $(call clear-local-module))
#------------------------------------------------------------------------------#

local_path        :=

local_library     :=  docs_start \
                      docs_topics \
                      \
                      omdl-base

local_release_add :=

local_backup_add  :=

local_submodules  :=  common \
                      datatypes \
                      math \
                      models \
                      parts \
                      shapes \
                      tools \
                      units \
                      \
                      database

# add only when directory exists
local_submodules  +=  $(wildcard contrib)

#------------------------------------------------------------------------------#
# initialize omdl modules
#------------------------------------------------------------------------------#

# initialize modules with this root module
modules +=  $(lastword $(MAKEFILE_LIST))

# add local module defined above
$(eval $(call add-local-module))

# cleanup after last module
$(eval $(call clear-local-module))

################################################################################
# eof
################################################################################
