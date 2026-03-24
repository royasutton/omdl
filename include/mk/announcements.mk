#------------------------------------------------------------------------------#
# Project Announcements
#------------------------------------------------------------------------------#

define ANNOUNCE_AMU_INIT

  [$1] file not found...
  Tried [$2].

  Please review the definitions at the top of $(firstword $(MAKEFILE_LIST)) and update
  as needed for your installation or install the specified version
  acording to the instructions below:
  $(call ANNOUNCE_AMU_VERSION,$(AMU_TOOL_VERSION))
endef

define ANNOUNCE_AMU_VERSION

  This library has been designed and tested to work with openscad-amu $1
  or later.

  To install the version:

  $$ wget https://raw.githubusercontent.com/royasutton/openscad-amu/master/share/scripts/setup-amu.bash
  $$ chmod +x setup-amu.bash
  $$ ./setup-amu.bash --branch $(AMU_TOOL_VERSION) --yes --build --sudo --install

endef

define ANNOUNCE_OPENSCAD_VERSION

  This library has been designed and tested to work with OpenSCAD $1.

  Please make sure this version is available in the search path. This
  or all version checks can be disabled in this project makefile using
  the control variable [version_checks] or individually in the tools
  assertions section.

  see: $(firstword $(MAKEFILE_LIST))
  See: http://www.openscad.org/downloads.html

endef

define ANNOUNCE_IMAGEMAGICK_POLICY

  The current ImageMagick security policy denies access rights ($2)
  to a coder ($1) required to compile this library. Please grant
  these rights in the policy.xml file as follows;

    <policy domain="coder" rights="$3" pattern="$1" />

  command:

    $$ policy_path=$$(identify -list configure |
        sed -n "/CONFIGURE_PATH/s/CONFIGURE_PATH[[:space:]]*//p")

    $$ sudo sed -i.orig $\\
        '/"$1"/s/rights="[^"]*"/rights="$3"/' $\\
        $${policy_path}policy.xml

  See: http://imagemagick.org/script/security-policy.php

endef

define ANNOUNCE_DOXYGEN_VERSION

  This library has been tested to work with Doxygen versions upto $1.
  Please make sure the installed is less than or equal to this version.

  The formatting breaks when upgrading Doxygen from version 1.9.4 to
  1.9.8 are primarily due to changes in default configuration settings
  and stricter Markdown parsing rules. Key changes include how empty
  lines and indentation are interpreted in comment blocks.

  Formatting migration is underway.

  See: https://github.com/raspberrypi/pico-sdk/issues/1563

  Prebuilt binaries available for manual installation:

  See: https://github.com/doxygen/doxygen/releases/tag/Release_1_9_4

endef

################################################################################
# eof
################################################################################
