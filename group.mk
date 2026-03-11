################################################################################
# (root) group
################################################################################
$(eval $(call clear-local-group))
#------------------------------------------------------------------------------#

local_path        :=

local_library     :=  docs_home \
                      docs_topics \
                      \
                      omdl-base

local_release_add :=

local_backup_add  :=  group.mk

local_subgroups   :=  common \
                      datatypes \
                      math \
                      models \
                      parts \
                      shapes \
                      tools \
                      transforms \
                      units \
                      \
                      database

# add only when directory exists
local_subgroups  +=  $(wildcard contrib)

#------------------------------------------------------------------------------#
# initialize omdl groups
#------------------------------------------------------------------------------#

# initialize groups (this group)
groups += $(lastword $(MAKEFILE_LIST))

# add local group defined above
$(eval $(call add-local-group))

# cleanup after last group
$(eval $(call clear-local-group))

################################################################################
# eof
################################################################################
