################################################################################
# Module
################################################################################
$(eval $(call clear-local-module))
#------------------------------------------------------------------------------#

local_path        :=  database/component/fastener

local_library     :=  docs_module \
                      \
                      ansi_b18_3_5m \
                      \
                      din_125a \
                      din_985 \
                      \
                      iso_4014a \
                      iso_4014b \
                      iso_4032 \
                      iso_4033 \
                      iso_4035 \
                      iso_4161 \
                      iso_4762 \
                      iso_7046_1p \
                      iso_7046_1s \
                      iso_7089 \
                      iso_7091 \
                      iso_7092 \
                      iso_7093 \
                      iso_7380 \
                      iso_8677 \
                      iso_8678

local_release_add :=

local_backup_add  :=  diagrams/washer_flat.svg \
                      diagrams/nut_hex.svg \
                      diagrams/nut_hex_flange.svg \
                      diagrams/nut_hex_jam.svg \
                      diagrams/nut_hex_nylon_insert_stop.svg

local_submodules  :=

#------------------------------------------------------------------------------#
# add local module
#------------------------------------------------------------------------------#
$(eval $(call add-local-module))

################################################################################
# eof
################################################################################
