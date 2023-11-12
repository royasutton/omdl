################################################################################
# Root Module
################################################################################
$(eval $(call clear-local-module))
#------------------------------------------------------------------------------#

local_path        :=

local_library     :=  docs_start \
                      docs_topics \
                      \
                      omdl-base \
                      \
                      console \
                      constants \
                      validation

local_release_add :=  stl/mainpage_quickstart.stl

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

#------------------------------------------------------------------------------#
# initialize omdl modules
#------------------------------------------------------------------------------#

# add (this) root module
modules +=  $(lastword $(MAKEFILE_LIST))

# add local module
$(eval $(call add-local-module))

# cleanup after last module
$(eval $(call clear-local-module))

################################################################################
# eof
################################################################################
