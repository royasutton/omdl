#!/usr/bin/env bash
#/##############################################################################
#
#   \file   setup-omdl.bash
#
#   \author Roy Allen Sutton <royasutton@hotmail.com>.
#   \date   2016-2025
#
#   \copyright
#
#     This file is part of [omdl] (https://github.com/royasutton/omdl),
#     an OpenSCAD mechanical design library.
#
#     The \em omdl is free software; you can redistribute it and/or modify
#     it under the terms of the [GNU Lesser General Public License]
#     (http://www.gnu.org/licenses/lgpl.html) as published by the Free
#     Software Foundation; either version 2.1 of the License, or (at
#     your option) any later version.
#
#     The \em omdl is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#     Lesser General Public License for more details.
#
#     You should have received a copy of the GNU Lesser General Public
#     License along with the \em omdl; if not, write to the Free Software
#     Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
#     02110-1301, USA; or see <http://www.gnu.org/licenses/>.
#
###############################################################################/

declare base_path="${0%/*}"
declare base_name="${0##*/}"
declare root_name="${base_name%.*}"
declare work_path="${PWD}"
declare conf_file="${root_name}.conf"

declare kernel=$(uname -s)
declare sysname=${kernel%%-*}

# verify minimum bash version
if [[ $BASH_VERSINFO -lt 4 ]] ; then
  echo "Bash version is $BASH_VERSION. Version 4 or greater required. aborting..."
  exit 1
fi

###############################################################################
# global variables
###############################################################################

declare skip_check="no"
declare skip_prep="no"
declare skip_toolchain="no"

declare apt_cyg_path
declare apt_get_opts="--verbose-versions"
declare git_fetch_opts="--verbose"

declare repo_url_apt_cyg="https://github.com/transcode-open/apt-cyg"

declare repo_url="https://github.com/royasutton/omdl"
declare repo_branch="master"
declare repo_branch_list

declare setup_amu_url="https://git.io/setup-amu.bash"

declare cache_install="no"
declare repo_cache_root="cache"

declare scopes_exclude="db_autotest"
declare make_opts_add="generate_latex="

declare commands

# variables map: ( "variable-key" "description" "example-value" )
declare -i conf_file_vw=3
declare -a conf_file_va=(
  "skip_check"
      "skip system prerequisites check"
      "$skip_check"
  "skip_prep"
      "skip source preparation"
      "$skip_prep"
  "skip_toolchain"
      "skip toolchain preparation"
      "$skip_toolchain"
  "apt_cyg_path"
      "path to apt-cyg"
      "/usr/local/bin/apt-cyg"
  "apt_get_opts"
      "apt get options"
      "$apt_get_opts"
  "git_fetch_opts"
      "git fetch options"
      "$git_fetch_opts"
  "repo_url_apt_cyg"
      "apt-cyg git repo url (can be local path)"
      "$repo_url_apt_cyg"
  "repo_url"
      "git repo url (can be local path)"
      "$repo_url"
  "repo_branch"
      "git repo branch or tag"
      "$repo_branch"
  "repo_branch_list"
      "git repo branch and/or tag list"
      "master develop v0.5 v0.6.1"
  "setup_amu_url"
      "url to setup-amu.bash script"
      "$setup_amu_url"
  "cache_install"
      "install to cache"
      "$cache_install"
  "repo_cache_root"
      "cache root directory path"
      "$repo_cache_root"
  "scopes_exclude"
      "omdl scope exclusions"
      "$scopes_exclude"
  "make_opts_add"
      "make option additions"
      "$make_opts_add"
  "commands"
      "commands to run with each invocation"
      "--branch master --install --template my_project"
)

# derived variables
declare packages
declare packages_installed
declare packages_missing

declare setup_amu_yes

declare repo_cache_apt_cyg
declare repo_cache

declare build_dir

declare cache_prefix

declare -a make_opts

###############################################################################
# message printing
###############################################################################

function print_m() {
  local nl
  local es
  local -i rn=1
  local ws=' '
  local ns="${ws}"

  case $1 in
  -j)                                                     ;;
  -J) print_m -j -n -r ${#root_name} ' ' -j ' ' ; shift 1 ;;
   *) echo -n ${root_name}:                               ;;
  esac

  while [[ $# -gt 0 ]] ; do
    case $1 in
    -n) nl=true           ;;
    -e) es=true           ;;
    -E) es=''             ;;
    -j) ns=''             ;;
    -l) echo ;            ;;
    -r) rn=$2   ; shift 1 ;;
    -s) ws="$2" ; shift 1 ;;
     *)
      while ((rn > 0))
      do
        if [[ -z "$es" ]] ; then
          echo -n -E "${ns}${1}"
        else
          echo -n -e "${ns}${1}"
        fi

        ns=''
        let rn--
      done
      ns="${ws}"
      rn=1
    ;;
    esac

    shift 1
  done

  [[ -z "$nl" ]] && echo

  return
}

function print_hb () {
  local tput=$(which tput 2>/dev/null)
  local cols=80

  [[ -n "$tput" ]] && cols=$(${tput} cols)

  print_m -j -r ${cols} ${1:-#}
}

function print_h1 () {
  print_hb "#"
  print_m -j "#" -l -j "#" $* -l -j "#"
  print_hb "#"
}

function print_h2 () {
  print_hb "="
  print_m -j $*
  print_hb "="
}

###############################################################################
# os dependent functions
###############################################################################

#------------------------------------------------------------------------------
# configuration:
#   (1) prerequisite package list
#------------------------------------------------------------------------------
function update_prerequisite_list() {
  print_m "${FUNCNAME} begin"

  local packages_Common
  local packages_Linux
  local packages_CYGWIN_NT

  packages_Common="
    bash
    wget
    git
    make
    unzip
    openscad
  "

  packages_Linux="
  "

  packages_CYGWIN_NT="
  "

  case "${sysname}" in
    Linux)
      packages="${packages_Common} ${packages_Linux}"
    ;;
    CYGWIN_NT)
      packages="${packages_Common} ${packages_CYGWIN_NT}"
    ;;
    *)
      print_m "ERROR: Configuration for [$sysname] required. aborting..."
      exit 1
    ;;
  esac

  print_m "${FUNCNAME} end"
}

#==============================================================================
# Linux
#==============================================================================

function prerequisite_check.Linux() {
  dpkg-query --no-pager --show --showformat='${Status}\n' $1 2>/dev/null |
    grep -q "install ok installed" &&
      return 0

  return 1
}

function prerequisites_status.Linux() {
  dpkg-query --no-pager --show $*
}

function prerequisites_install.Linux() {
  print_m "apt-get install options: [${apt_get_opts}]"
  if ! sudo apt-get install ${apt_get_opts} $* ; then
    print_m "ERROR: install failed. aborting..."
    exit 1
  fi

  return 0
}

function prerequisite_install_openscad.Linux() {
  local pkg="$1"

  function setup_repository(){
    case "$(lsb_release -si)" in
      Ubuntu)
        local repo="deb https://download.opensuse.org/repositories/home:/t-paul/x$(lsb_release -si)_$(lsb_release -sr)/ ./"
      ;;
      Debian)
        local repo="deb https://download.opensuse.org/repositories/home:/t-paul/$(lsb_release -si)_$(lsb_release -sr)/ ./"
      ;;
      *)
        print_m "ERROR: Configuration for [$(lsb_release -si)] required. aborting..."
        exit 1
      ;;
    esac

    local name="openscad-development-snapshots"
    local desc="OpenSCAD development snapshots"
    local rkey="https://files.openscad.org/OBS-Repository-Key.pub"
    local keyf="5F4A 8A2C 8BB1 1716 F294  82BB 75F3 214F 30EB 8E08"

    local list="/etc/apt/sources.list.d/${name}.list"
    local update

    # setup repository key
    print_m "repository: [${desc}]"
    print_m "checking for repository source key..."
    if [[ -n $(apt-key finger | grep "$keyf") ]] ; then
      print_m "key found."
    else
      print_m "key not found, retreaving..."
      wget --quiet --output-document - "$rkey" | sudo apt-key add -

      update="true"
    fi

    # setup repository source file
    print_m "checking for source file: [$list]..."
    if [[ -f $list ]] ; then
      print_m "source file exists."
    else
      print_m "source file not found, adding..."
      echo "$repo" | sudo tee $list

      update="true"
    fi

    # resynchronize package index files
    if [[ "$update" == "true" ]] ; then
      print_m "resynchronizing package index files..."
      sudo apt-get --quiet update
    else
      print_m "package index resynchronization not required."
    fi
  }

  print_m "exception install: [${pkg}]..."

  # development snapshots repository only required for openscad-nightly
  if [[ "${pkg}" == "openscad-nightly" ]] ; then
    print_m "setting up repository for ${pkg}"
    setup_repository
  fi

  # install package
  prerequisites_install.${sysname} ${pkg}

  return 0
}

#==============================================================================
# Cygwin
#==============================================================================

function prerequisite_check.CYGWIN_NT() {
  cygcheck --check-setup --dump-only $1 |
    tail -1 |
    grep -q $1 &&
      return 0

  return 1
}

function prerequisites_status.CYGWIN_NT() {
  cygcheck --check-setup $*
}

function prerequisites_install.CYGWIN_NT() {
  set_apt_cyg_path
  if ! ${apt_cyg_path} install $* ; then
    print_m "ERROR: install failed. aborting..."
    exit 1
  fi

  return 0
}

function prerequisite_install_openscad.CYGWIN_NT() {
  local    pkg="$1"

  function install_openscad(){
    local    pkg="$1"

    local    ldir="openscad"
    local    lcmd="${pkg}"

    local    arch="x86-32"
    local    fext=".zip"
    local    fpat
    local    surl

    local    path="${repo_cache_root}"
    local    dist="${repo_cache_root}/distrib"

    local    list
    local -i lcnt=1
    local    pick
    local    inst

    case "${pkg}" in
      openscad)
        surl="https://files.openscad.org"
        fpat="OpenSCAD-....\...-${arch}${fext}"
      ;;
      openscad-nightly)
        surl="https://files.openscad.org/snapshots"
        fpat="OpenSCAD-....\...\...-${arch}${fext}"
      ;;
      *)
        print_m "ERROR: invalid package name [${pkg}]. aborting..."
        exit 1
      ;;
    esac

    # download, unpack, create symbolic links, and add to $PATH
    if [[ -x ${path}/${ldir}/${lcmd}.exe ]] ; then
      print_m "using ${lcmd} installed in cache."
    else
      # determine machine hardware
      [[ $(arch) == "x86_64" ]] && arch="x86-64"

      # get list of development snapshots
      list=$( \
        wget --quiet --output-document - ${surl} |
        grep --only-matching "${fpat}" |
        sort --uniq |
        tail --lines=${lcnt} \
      )

      # downloads distribution(s)
      print_m "downloading latest [$lcnt] distribution(s):"
      for f in ${list} ; do
        print_m "--> $f"
        if [[ -e "${dist}/${f}" ]] ; then
          print_m "[${dist}/${f}] exists."
        else
          wget --quiet --show-progress --directory-prefix=${dist} "${surl}/${f}"
        fi

        pick="$f"
      done

      # unpack distribution
      print_m "unpacking: [$pick]..."
      unzip -q -u -d ${path} ${dist}/${pick}

      # set install path for 'picked' snapshot
      # assumes  unpacked directory named: OpenSCAD-* or openscad-*
      # using head -1 should choose the newest version from the list
      inst=$(cd ${path} && ls -1d {OpenSCAD-*,openscad-*} 2>/dev/null | head -1)

      if [[ -z "${inst}" ]] ; then
        print_m "ERROR: unable to locate unpacked OpenSCAD distribution. aborting..."
        exit 1
      fi

      # create path symbolic links
      print_m "creating symbolic links..."
      (
        cd ${path} &&
        ln --force --symbolic --verbose --no-target-directory \
          ${inst} ${ldir}
      )

      # iff: openscad-nightly, create command symbolic links
      if [[ "${lcmd}" == "openscad-nightly" ]] ; then
        (
          cd ${path}/${inst} &&
          ln --force --symbolic --verbose --no-target-directory \
            openscad.exe ${lcmd}.exe
        )
        (
          cd ${path}/${inst} &&
          ln --force --symbolic --verbose --no-target-directory \
            openscad.com ${lcmd}.com
        )
      fi
    fi

    # add to path (temporary)
    print_m "adding (temporary) shell path [${work_path}/${path}/${ldir}]."
    export PATH="${work_path}/${path}/${ldir}:${PATH}"

    if [[ -z $(which 2>/dev/null ${lcmd}) ]] ; then
      print_m "ERROR: unable to locate or setup requirement: [${lcmd}]. aborting..."
      exit 1
    else
      print_m "confirmed ${lcmd} added to shell path"
    fi

    # output and record install note
    local note="${path}/${lcmd}.readme"

    if [[ -e ${note} ]] ; then
      print_m "install note exists: [${note}]."
    else
      print_m -j
      cat << EOF | tee ${note}
      #####################################################################
      #####################################################################
      ##                                                                 ##
      ## note:                                                           ##
      ##                                                                 ##
      ## omdl requires a recent build of OpenSCAD. One has been          ##
      ## downloaded and installed to a cache at:                         ##
      ##                                                                 ##
      ##   PATH=${work_path}/${path}/${ldir}:\${PATH}
      ##                                                                 ##
      ## You should add the location to permanent install to your shell  ##
      ## path if you plan to work with omdl from the command line.       ##
      ##                                                                 ##
      #####################################################################
      #####################################################################
EOF
      print_m -j
      sleep 10
    fi
  }

  # check to see if ${lcmd} already exists in ${PATH}
  if [[ -z $(which 2>/dev/null ${lcmd}) ]] ; then
    print_m "exception install: [${pkg}]..."
    install_openscad "${pkg}"
  else
    print_m "${lcmd} exists in shell path"
  fi

  return 0
}

function set_apt_cyg_path() {
  local cmd_name="apt-cyg"
  local cmd_cache=${repo_cache_apt_cyg}/${cmd_name}

  if [[ -z "${apt_cyg_path}" ]] ; then
    apt_cyg_path=$(which 2>/dev/null ${cmd_name} ${cmd_cache} | head -1)

    if [[ -x "${apt_cyg_path}" ]] ; then
      print_m "found: ${cmd_name}=${apt_cyg_path}"
    else
      print_m "fetching apt-cyg git repository to ${repo_cache_apt_cyg}"
      repository_update "${repo_url_apt_cyg}" "${repo_cache_apt_cyg}"

      if [[ -e "${cmd_cache}" ]] ; then
        [[ ! -x "${cmd_cache}" ]] && chmod --verbose +x ${cmd_cache}
        apt_cyg_path=$(which 2>/dev/null ${cmd_name} ${cmd_cache} | head -1)
        print_m "using cached: ${cmd_name}=${apt_cyg_path}"
        print_m "adding [${apt_cyg_path%/*}] to shell path"
        PATH=${apt_cyg_path%/*}:${PATH}
      else
        print_m "ERROR: unable to locate or cache ${cmd_name}. aborting..."
        exit 1
      fi
    fi
  fi

  return 0
}

###############################################################################
# os independent functions
###############################################################################

#==============================================================================
# general / core
#==============================================================================

#------------------------------------------------------------------------------
# write configuration file
#------------------------------------------------------------------------------
function write_configuration_file() {
  print_m "${FUNCNAME} begin"

  local file="$1"         ; shift 1
  local -i cv_w="$1"      ; shift 1
  local -a cv_a=( "$@" )

  local -i cv_s=$(( ${#cv_a[@]} / ${cv_w} ))

  local cv_c="#"

  if [[ -e ${file} ]]
  then
    print_m "configuration file ${file} exists... not writting."
  else
    print_m "writing ${cv_s} keys to ${file}"

    print_m >  ${file} -j -r 80 ${cv_c} -l \
                       -j "${cv_c} file: ${file}" -l \
                       -j -r 80 ${cv_c}

    cat >> ${file} << EOF
# note:
#  - Do not quote variable names or values.
#  - Tokenize multi-value lists with ' ' (space-character).
#  - 'commands' and 'make' options are specified as they are on the command
#    line, with multi-value lists Tokenized by ',' (comma-character).
#  - Values can be split across lines using '\\':
#      commands=\\
#        --branch-list master,develop,v0.5,v0.6.1 \\
#        --cache --install
EOF

    print_m >> ${file} -j -r 80 ${cv_c} -l -l \
                       -j ${cv_c} -j -r 79 "=" -l \
                       -j "${cv_c} Supported Variables" -l \
                       -j ${cv_c} -j -r 79 "=" -l

    for ((i = 0; i < $cv_s; i++))
    do
      local kv=${cv_a[$(( $i*$cv_w + 0 ))]}
      local kd=${cv_a[$(( $i*$cv_w + 1 ))]}
      local ke=${cv_a[$(( $i*$cv_w + 2 ))]}

      print_m >> ${file} -j "${cv_c} [::: ${kd^} :::]" -l \
                         -j "${cv_c} ${kv}=${ke}" -l
    done

    print_m >> ${file} -j -r 80 ${cv_c} -l \
                       -j "${cv_c} eof" -l \
                       -j -r 80 ${cv_c}
  fi

  print_m "${FUNCNAME} end"

  return 0
}

#------------------------------------------------------------------------------
# parse configuration file
#------------------------------------------------------------------------------
function parse_configuration_file() {
  print_m "${FUNCNAME} begin"

  local file="$1"         ; shift 1
  local -i cv_w="$1"      ; shift 1
  local -a cv_a=( "$@" )

  local -i cv_s=$(( ${#cv_a[@]} / ${cv_w} ))
  local -i cv_r=0

  function read_key()
  {
    local file="$1"
    local key="$2"

    # support line gobbling
    while IFS= read line || [[ -n "$line" ]]; do
      echo "$line"
    done < "${file}" |
    sed -e '/^[[:space:]]*$/d' \
        -e '/^[[:space:]]*#/d' \
        -e 's/^[[:space:]\t]*//' |
    grep "${key}=" |
    tail -1 |
    sed -e "s/${key}=//"
  }

  print_m "checking for ${cv_s} configuration keys"
  for ((i = 0; i < $cv_s; i++))
  do
    local key=${cv_a[$(( $i*$cv_w + 0 ))]}
    local cfv

    printf -v cfv '%s' "$(read_key ${file} $key)"
    if [[ -n "$cfv" ]] ; then
      printf -v $key '%s' "$cfv"
      print_m "setting $key=$cfv"

      (( ++cv_r ))
    fi
  done
  print_m "read ${cv_r} key values"

  print_m "${FUNCNAME} end"

  return 0
}

#------------------------------------------------------------------------------
# update build variables
#------------------------------------------------------------------------------
function update_build_variables() {
  print_m "${FUNCNAME} begin"

  repo_cache_apt_cyg=${repo_cache_root}/apt-cyg
  repo_cache=${repo_cache_root}/omdl

  build_dir="build/${repo_branch}/"

  # make options: output directory
  make_opts=( output_path=${build_dir} )

  # make options: cache directory
  if [[ "${cache_install}" == "yes" ]] ; then
    cache_prefix="${work_path}/${repo_cache_root}/local/share/OpenSCAD"

    make_opts+=(
      install_prefix_scad=${cache_prefix}/libraries/
      install_prefix_html=${cache_prefix}/docs/html/
      install_prefix_pdf=${cache_prefix}/docs/pdf/
      install_prefix_man=${cache_prefix}/docs/man/
    )
  fi

  # make options: scope exclusions
  if [[ -n "${scopes_exclude}" ]] ; then
    make_opts+=( scopes_exclude="${scopes_exclude}" )
  else
    make_opts+=( scopes_exclude="" )
  fi

  # make options: other additions
  if [[ -n "${make_opts_add}" ]] ; then
    local -a make_opts_add_a

    # tokenize to array on ','
    IFS=',' read -a make_opts_add_a <<< "$make_opts_add"

    make_opts+=( "${make_opts_add_a[@]}" )
  fi

  print_m "${FUNCNAME} end"
}

#------------------------------------------------------------------------------
# list prerequisite packages
#------------------------------------------------------------------------------
function prerequisites_list() {
  print_m "${FUNCNAME} begin"

  update_prerequisite_list

  print_h2 "[ prerequisites ]"

  for r in ${packages} ; do
    print_m -j $r
  done
  print_hb "="

  print_m "${FUNCNAME} end"
}

#------------------------------------------------------------------------------
# update prerequisite package status lists
#------------------------------------------------------------------------------
function prerequisites_check() {
  print_m "${FUNCNAME} begin"

  packages_installed=""
  packages_missing=""

  update_prerequisite_list

  for r in ${packages} ; do
    if prerequisite_check.${sysname} $r
    then
      packages_installed+=" $r"
    else
      packages_missing+=" $r"
    fi
  done

  print_m "${FUNCNAME} end"
}

#------------------------------------------------------------------------------
# show prerequisite package status
#------------------------------------------------------------------------------
function prerequisites_status() {
  print_m "${FUNCNAME} begin"

  prerequisites_check

  print_h2 "[ Installed ]"
  if [[ -n "${packages_installed}" ]] ; then
    prerequisites_status.${sysname} $packages_installed
  else
    print_m -j "installed prerequisite list is empty."
  fi

  print_h2 "[ Missing ]"
  if [[ -n "${packages_missing}" ]] ; then
    for r in ${packages_missing} ; do
      print_m -j $r
    done
  else
    print_m -j "missing prerequisite list is empty."

    print_h2 "[ Asserts ]"
    prerequisites_assert
  fi
  print_hb "="

  print_m "${FUNCNAME} end"
}

#------------------------------------------------------------------------------
# install missing prerequisite packages
#------------------------------------------------------------------------------
function prerequisites_install() {
  print_m "${FUNCNAME} begin"

  prerequisites_check

  if [[ -n "${packages_missing}" ]] ; then
    print_h2 "[ Missing ]"
    for r in ${packages_missing} ; do
      print_m -j $r
    done

    print_h2 "[ Installing ]"
    for r in ${packages_missing} ; do
      print_h2 "installing: [ $r ]"
      print_m -j $r

      # exception handler
      case "$r" in
        openscad|openscad-nightly)
          prerequisite_install_openscad.${sysname} $r ;;
        *)
          prerequisites_install.${sysname} $r ;;
      esac
    done
    print_hb "="
  else
    print_m "no missing prerequisites."
  fi

  print_m "${FUNCNAME} end"

  return 0
}

#------------------------------------------------------------------------------
# assertions on prerequisite packages
#------------------------------------------------------------------------------
function prerequisites_assert() {
  print_m "${FUNCNAME} begin"

  print_m "${FUNCNAME} end"
}

#------------------------------------------------------------------------------
# clone or update a Git repository
#------------------------------------------------------------------------------
function repository_update() {
  print_m "${FUNCNAME} begin"

  local gitrepo="$1"
  local out_dir="$2"

  print_m "source: [${gitrepo}]"
  print_m " cache: [${out_dir}]"

  # assume 'git' is available, it not report and abort.
  local git=$(which 2>/dev/null git)
  if [[ ! -x "${git}" ]] ; then
    print_m "ERROR: please install git:"

    case "${sysname}" in
      Linux)        print_m "info: $ sudo apt-get install git" ;;
      CYGWIN_NT)    print_m "info: run Cygwin setup.exe and select Devel/git" ;;
      *)            print_m "info: configuration does not exists for [$sysname]." ;;
    esac

    print_m "aborting..."
    exit 1
  fi

  if [[ -d ${out_dir} ]] ; then
    if ( cd ${out_dir} 2>/dev/null && git rev-parse 2>/dev/null ) ; then
      print_m "updating: Git repository cache"
      ( cd ${out_dir} && ${git} pull ${git_fetch_opts} )
    else
      print_m "ERROR: directory [${out_dir}] exists and is not a repository. aborting..."
      exit 1
    fi
  else
    print_m "cloning: Git repository to cache"
    ${git} clone ${gitrepo} ${out_dir} ${git_fetch_opts}
  fi

  if ( cd ${out_dir} 2>/dev/null && git rev-parse 2>/dev/null ) ; then
    print_m -n "repository description: "
    ( cd ${out_dir} && git describe --tags --long --dirty )
  else
    print_m "ERROR: repository update failed. aborting..."
    exit 1
  fi

  print_m "${FUNCNAME} end"

  return 0
}

#------------------------------------------------------------------------------
# remove directory
#------------------------------------------------------------------------------
function remove_directory() {
  print_m "${FUNCNAME} begin"

  local dir_path="$1"
  local dir_desc="$2"

  [[ -n ${dir_desc} ]] && dir_desc+=" "

  if [[ -x ${dir_path} ]] ; then
    print_m "removing ${dir_desc}directory [${dir_path}]."
    rm -rfv ${dir_path}
  else
    print_m "${dir_desc}directory [${dir_path}] does not exists."
  fi

  print_m "${FUNCNAME} end"
}

#------------------------------------------------------------------------------
# prepare source for compilation
#------------------------------------------------------------------------------
function source_prepare() {
  print_m "${FUNCNAME} begin"

  # check for existing source repository
  if ! ( cd ${repo_cache} 2>/dev/null && git rev-parse 2>/dev/null ) ; then
    print_m "fetching repository cache."
    repository_update "${repo_url}" "${repo_cache}"
  fi

  # checkout branch
  if ! ( cd ${repo_cache} && git checkout ${repo_branch} ) ; then
    print_m "ERROR: failed to checkout branch [${repo_branch}]. aborting..."
    exit 1
  else
    print_m -n "repository branch description: "
    ( cd ${repo_cache} && git describe --tags --long --dirty )
  fi

  print_m "${FUNCNAME} end"
}

#------------------------------------------------------------------------------
# prepare openscad-amu toolchain if required
#------------------------------------------------------------------------------
function toolchain_prepare() {
  print_m "${FUNCNAME} begin"

  # identify toolchain version specified in omdl Makefile
  local amu_version=$( \
    grep --invert-match '#' ${repo_cache}/Makefile |
    grep 'AMU_TOOL_VERSION[[:space:]]*:=' |
    head -1 |
    awk -F '=' '{print $2}' |
    sed -s 's/[[:space:]]*//g' \
  )
  print_m "omdl ${repo_branch} uses openscad-amu ${amu_version}."

  local test_cmd_name="openscad-seam"
  local test_cmd_path

  local cache_cmd_path=${work_path}/${repo_cache_root}/local/bin/${sysname}/${test_cmd_name}-${amu_version}
  local shell_cmd_path

  local setup_amu_bash="${repo_cache_root}/setup-amu.bash"

  local amu_lib_path
  local amu_tool_prefix

  #
  # assume toolchain is available if test command can be found
  #

  # check shell path
  print_m "searching for specified toolchain version in shell path..."
  shell_cmd_path=$(which 2>/dev/null ${test_cmd_name}-${amu_version} | head -1)

  if [[ -n ${shell_cmd_path} ]] ; then
    # test command found in shell path
    test_cmd_path=${shell_cmd_path}
    print_m "--> found [${test_cmd_path}]"
  else
    # test command not found in shell path
    print_m "--> not found in shell path."

    # check cache path
    print_m "searching for specified toolchain in cache..."

    if [[ -x ${cache_cmd_path} ]] ; then
      # test command found in cache
      test_cmd_path=${cache_cmd_path}
      print_m "--> found [${test_cmd_path}]"
    else
      # test command not found in cache
      print_m "--> not found in cache, setting up toolchain..."

      #
      # setup toolchain
      #

      print_m "searching for toolchain setup script..."
      if [[ -x ${setup_amu_bash} ]] ; then
        print_m "${setup_amu_bash} script exists locally."
      else
        print_m "retrieving toolchain setup script..."
        wget --no-verbose --output-document=${setup_amu_bash} ${setup_amu_url}
        chmod +x ${setup_amu_bash}
      fi

      # build toolchain for install to temporary cache
      print_h1 "building toolchain from source for install to temporary cache..."
      print_h2 ${setup_amu_bash} \-\-fetch \-\-reconfigure \-\-cache \-\-branch ${amu_version} ${setup_amu_yes} \-\-install
      ${setup_amu_bash} --fetch --reconfigure --cache --branch ${amu_version} ${setup_amu_yes} --install

      # test return code
      if [[ $? -eq 0 ]] ; then
        print_h2 "${setup_amu_bash} exited normally."
        test_cmd_path=${cache_cmd_path}
      else
        print_h2 "${setup_amu_bash} exited with errors. aborting..."
        exit 1
      fi

    fi
  fi

  #
  # configure toolchain paths
  #

  # identify openscad-amu paths
  if [[ -n ${test_cmd_path} && -x ${test_cmd_path} ]] ; then
    # get library path
    amu_lib_path=$( \
      ${test_cmd_path} --version --verbose  |
      grep 'lib path' |
      awk '{print $4}' \
    )

    # get tool path prefix (add trailing directory slash)
    amu_tool_prefix=${test_cmd_path%/*}/
  else
    print_m "ERROR: unable to find or setup ${test_cmd_name}-${amu_version}. aborting..."
    exit 1
  fi

  # append configured toolchain version and paths to make options
  if [[ -n ${amu_version} && -x ${amu_lib_path} && -x ${amu_tool_prefix} ]] ; then
    print_m "adding make options for openscad-amu ${amu_version} toolchain..."
    make_opts+=(
      AMU_TOOL_VERSION=${amu_version}
      AMU_LIB_PATH=${amu_lib_path}
      AMU_TOOL_PREFIX=${amu_tool_prefix}
    )
  else
    print_m "ERROR: unable to find or setup openscad-amu ${amu_version} toolchain... aborting..."
    exit 1
  fi

  print_m "${FUNCNAME} end"

  return 0
}

#------------------------------------------------------------------------------
# run make with targets
#------------------------------------------------------------------------------
function source_make() {
  print_m "${FUNCNAME} begin"

  update_build_variables

  if [[ "${skip_check}" == "yes" ]] ; then
    print_m "skipping system prerequisite checks."
  else
    print_m "checking system for prerequisites."
    prerequisites_install
  fi

  if [[ "${skip_check}" == "yes" ]] ; then
    print_m "skipping system prerequisite asserts."
  else
    print_m "checking system for prerequisite asserts."
    prerequisites_assert
  fi

  if [[ "${skip_prep}" == "yes" ]] ; then
    print_m "skipping source preparation."
  else
    print_m "preparing source."
    source_prepare
  fi

  if [[ "${skip_toolchain}" == "yes" ]] ; then
    print_m "skipping toolchain preparation."
  else
    print_m "preparing toolchain."
    toolchain_prepare
  fi

  print_hb '+'
  print_m "building [$*]."
  print_m "directory:"
  print_m "  [$repo_cache]"
  print_m "options:"
  for i in "${make_opts[@]}" $* ; do
    print_m "  [$i]"
  done
  print_hb '+'

  print_m \( cd ${repo_cache} \&\& make "${make_opts[@]}" $* \)
  ( cd ${repo_cache} && make "${make_opts[@]}" $* )

  print_m "${FUNCNAME} end"

  return 0
}

#------------------------------------------------------------------------------
# parse command line arguments (per-branch)
#------------------------------------------------------------------------------
function parse_commands_branch() {
  print_m "${FUNCNAME} begin"

  while [[ $# -gt 0 ]]; do
      case $1 in
      --skip-check)
        print_h2 "setting: skip prerequisite check"
        skip_check="yes"
      ;;
      --skip-prep)
        print_h2 "setting: skip source preparation"
        skip_prep="yes"
      ;;
      --skip-toolchain)
        print_h2 "setting: skip toolchain preparation"
        skip_toolchain="yes"
      ;;

      --list)
        print_h1 "Listing prerequisites"
        prerequisites_list
      ;;
      --check)
        print_h1 "Checking for installed prerequisites"
        prerequisites_status
      ;;
      --required)
        print_h1 "Installing missing prerequisites"
        prerequisites_install
      ;;
      --yes)
        local opt="--assume-yes"
        print_h2 "adding: apt-get install option [${opt}]"
        [[ -n "${apt_get_opts}" ]] && apt_get_opts+=" ${opt}"
        [[ -z "${apt_get_opts}" ]] && apt_get_opts="${opt}"

        setup_amu_yes="$1"
      ;;

      --no-excludes)
        print_h2 "Building all scopes; overridding any exclusions"
        unset scopes_exclude
      ;;

      -c|--cache)
        print_h2 "setting: configure source to install to cache"
        cache_install="yes"
      ;;
      --cache-root)
        if [[ -z "$2" ]] ; then
          print_m "syntax: ${base_name} $1 <path>"
          print_m "missing cache root path. aborting..."
          exit 1
        fi
        repo_cache_root="$2" ; shift 1
        print_h2 "setting: cache root path [${repo_cache_root}]"
      ;;

      -v|--branch)
        if [[ -z "$2" ]] ; then
          print_m "syntax: ${base_name} $1 <name>"
          print_m "missing repository branch name. aborting..."
          exit 1
        fi
        repo_branch="$2" ; shift 1
        print_h2 "setting: source branch [${repo_branch}]"
      ;;

      -b|--build)
        local targets="all"
        print_h1 "Building omdl: make target=[${targets}]"
        source_make ${targets}
      ;;
      -i|--install)
        local targets="install"
        print_h1 "Building omdl: make target=[${targets}]"
        source_make ${targets}
      ;;
      -u|--uninstall)
        local targets="uninstall"
        print_h1 "Building omdl: make target=[${targets}]"
        source_make ${targets}
      ;;

      -m|--make)
        if [[ -z "$2" ]] ; then
          print_m "syntax: ${base_name} $1 <name1,name2,...>"
          print_m "missing make target list. aborting..."
          exit 1
        fi
        # get list and tokenize with [,]
        local targets="${2//,/ }" ; shift 1
        print_h1 "Building omdl: make target=[${targets}]"
        source_make ${targets}
      ;;

      --remove)
        print_h1 "Remove source build directory"
        update_build_variables
        remove_directory "${repo_cache}/${build_dir}" "source build"
      ;;

      *)
        print_m "invalid command [$1]. aborting..."
        exit 1
      ;;
      esac
      shift 1
  done

  print_m "${FUNCNAME} end"
}

#------------------------------------------------------------------------------
# parse command line arguments (per-repository)
#------------------------------------------------------------------------------
function parse_commands_repo() {
  print_m "${FUNCNAME} begin"

  local args

  while [[ $# -gt 0 ]]; do
      case $1 in
      --fetch)
        print_h1 "Updating omdl source cache"
        update_build_variables
        repository_update "${repo_url}" "${repo_cache}"
      ;;

      -l|--branch-list)
        if [[ -z "$2" ]] ; then
          print_m "syntax: ${base_name} $1 <name1,name2,...>"
          print_m "missing repository branch list. aborting..."
          exit 1
        fi

        # get list and tokenize with [,]
        repo_branch_list="${2//,/ }" ; shift 1
        print_h1 "setting: branch list [${repo_branch_list}]"
      ;;

      -h|--help)
        print_help
        exit 0
      ;;
      --examples)
        print_examples
        exit 0
      ;;
      --info)
        print_info
        exit 0
      ;;
      --write-conf)
        write_configuration_file "${conf_file}" "${conf_file_vw}" "${conf_file_va[@]}"
        exit 0
      ;;

      # argument is not "per-repository", add to argument list to be
      # passed to the "per-branch" argument parser
      *)
        [[ -n $args ]] && args+=" $1"
        [[ -z $args ]] && args=$1
      ;;
      esac
      shift 1
  done

  #
  # process argument list for each specified repository branch
  #

  if [[ -z ${repo_branch_list} ]] ; then
    # empty list, single branch for command arguments

    parse_commands_branch $args
  else
    # list specified, process command arguments for each branch

    # check for 'tags' keyword
    if [[ ${repo_branch_list:0:4} == "tags" ]] ; then
      # obtain list of tagged releases from git repository

      # force immediate clone/update of source repository (if needed)
      update_build_variables

      # check for source
      if ! ( cd ${repo_cache} 2>/dev/null && git rev-parse 2>/dev/null ) ; then
        print_m "fetching repository cache."
        repository_update "${repo_url}" "${repo_cache}"
      fi

      # check for 'tagsN', where 'N' indicates use last 'N' tags.
      local repo_branch_list_cnt=${repo_branch_list:4}

      if [[ -z ${repo_branch_list_cnt} ]] ; then
        repo_branch_list=$( cd ${repo_cache} && git tag )
        print_m tag limits = [all]
      else
        repo_branch_list=$( cd ${repo_cache} && git tag | tail -${repo_branch_list_cnt} )
        print_m tag limits = last [${repo_branch_list_cnt}]
      fi

      print_m using tag list = [${repo_branch_list}]
    fi

    # handle command set for each branch
    print_m "${FUNCNAME}.branch-list begin"
    for tag in ${repo_branch_list} ; do
      repo_branch="$tag"
      print_h2 "setting: source branch [${repo_branch}]"

      print_m $args
      parse_commands_branch $args
    done
    print_m "${FUNCNAME}.branch-list end"
  fi

  print_m "${FUNCNAME} end"
}

#==============================================================================
# help, examples, and info
#==============================================================================

#------------------------------------------------------------------------------
# help
#------------------------------------------------------------------------------
function print_help() {
print_m -j "${base_name}: (Help)" -l

cat << EOF
This script attempts to setup the omdl OpenSCAD library. It downloads
the source, builds, and installs the library include files and
documentation. Detected missing prerequisites are installed prior when
possible, including the openscad-amu toolchain.

 [ branch options ]

      --skip-check          : Skip system prerequisites check.
      --skip-prep           : Skip source preparation (use with care).
      --skip-toolchain      : Skip toolchain preparation.

      --list                : List prerequisites.
      --check               : Check system for prerequisites.
      --required            : Install missing prerequisites.
      --yes                 : Automatic 'yes' to install prompts.

      --no-excludes         : Build all omdl scopes.

 -c | --cache               : Configure source to install to cache.
      --cache-root          : Set the cache root directory.

 -v | --branch <name>       : Use branch 'name' default=(master).

 -b | --build               : Build library documentation.
 -i | --install             : Install library documentation.
 -u | --uninstall           : Uninstall library documentation.

 -m | --make <list>         : Run make with target 'list'.

      --remove              : Remove source build directory.

 [ repository options ]

      --fetch               : Download/update source repository cache.

 -l | --branch-list <list>  : Iterate over list of repository branches:
                              use: tags      for ALL tagged releases.
                                   tagsN     for last 'N' tagged releases.

 [ other options ]

 -h | --help                : Show this help message.
      --examples            : Show some examples uses.
      --info                : Show script information.
      --write-conf          : Write example configuration file.

 NOTES:
  * See --examples for basic usage examples.
  * Setup options can be stored in configuration file. Use --write-conf
    to generate a template with configuration parameters.
  * The --no-excludes option builds optional library scopes such as some
    tests, documentation statistics, etc.

EOF
}

#------------------------------------------------------------------------------
# examples
#------------------------------------------------------------------------------
function print_examples() {
print_m -j "${base_name}: (Examples)" -l

cat << EOF
(1) Build and install branch v0.9.7 to the OpenSCAD user library path.

    $ ./setup-omdl.bash --branch v0.9.7 --yes --install

(2) Build and install the latest source branch to a local cache.

    $ ./setup-omdl.bash --cache --branch-list tags1 --yes --install

(3) Build and install the latest source branch to the OpenSCAD user
    library path.

    $ ./setup-omdl.bash --branch-list tags1 --yes --install

(4) Build all scopes and install select tagged release versions, to the
    OpenSCAD user library path.

    $ ./setup-omdl.bash --branch-list v0.9.1,v0.9.6,v0.9.7 --no-excludes --install

(5) Build all scopes and install all release versions, to the OpenSCAD
    user library path.

    $ ./setup-omdl.bash --branch-list tags --no-excludes --install

(6) See omdl library documentation.

    [cache]
    $ google-chrome cache/local/share/OpenSCAD/docs/html/index.html

    [OpenSCAD user library]
    $ (cd cache/omdl; make print-install_prefix_html)
    $ google-chrome <install_prefix_html>/index.html


EOF
}

#------------------------------------------------------------------------------
# info
#------------------------------------------------------------------------------
function print_info() {
print_m -j "${base_name}: (Info)" -l

cat << EOF
     package: omdl
  bug report: royasutton@hotmail.com
    site url: https://royasutton.github.io/omdl

EOF
}

###############################################################################
###############################################################################
##
## (main) process command line arguments.
##
###############################################################################
###############################################################################

# parse configuration file
if [[ -e ${conf_file} ]] ; then
  print_m "reading configuration file: ${conf_file}"
  parse_configuration_file "${conf_file}" "${conf_file_vw}" "${conf_file_va[@]}"
else
  print_m "configuration file ${conf_file} does not exists."
fi

# parse configuration file commands
if [[ -n "${commands}" ]] ; then
  print_m "processing configuration file commands."
  parse_commands_repo ${commands}
fi

# parse command line arguments
if [[ $# -ne 0 ]] ; then
  print_m "processing command line arguments."
  parse_commands_repo $*
fi

# show help if no command line arguments or configuration file commands
if [[ $# == 0 && -z "${commands}" ]] ; then
  print_help
  exit 0
fi

print_m "done."
exit 0

###############################################################################
# eof
###############################################################################
