################################################################################
# Library Module
################################################################################

local_path        :=  database/geometry/polyhedra

local_library     :=  polyhedra_all \
                      \
                      anti_prisms \
                      archimedean_duals \
                      archimedean \
                      cupolas \
                      dipyramids \
                      johnson \
                      platonic \
                      prisms \
                      pyramids \
                      trapezohedron

local_backup_add  :=

local_submodules  :=

#------------------------------------------------------------------------------#
# add local module
#------------------------------------------------------------------------------#
$(eval $(call add-local-module))
$(eval $(call clear-local-module))

################################################################################
# eof
################################################################################
