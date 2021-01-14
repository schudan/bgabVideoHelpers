#!/bin/bash
# vim:set tabstop=4 textwidth=80 shiftwidth=4 expandtab cindent cino=(0,ml,\:0:
# ( settings from: http://datapax.com.au/code_conventions/ )
#
#/**********************************************************************
#    Vimeo-DL
#    Copyright (C) 2010-2012 DaTaPaX (Todd Harbour t/a)
#
#    This program is free software; you can redistribute it and/or
#    modify it under the terms of the GNU General Public License
#    version 2 ONLY, as published by the Free Software Foundation.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program, in the file COPYING or COPYING.txt; if
#    not, write to the Free Software Foundation, Inc.,
#    51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
# **********************************************************************/

cd /media/raid/videos/vimeo

# vimeo-dl
# --------
# This script will attempt to download a Vimeo video.

# [ CONFIG_START

# DEBUG
#   This defines debug mode which will output verbose info to stderr
#   or, if configured, the debug file ( DEBUG_FILE ).
DEBUG=0

# DEBUG_FILE
#   The file to debug to in the event DEBUG != 0.  If this is not set,
#   bet DEBUG != 0, debug will be directed to stderr.
#DEBUG_FILE="/tmp/vimeo-dl.log"

# QUALITY
#   What video quality.  This can be 'sd' or 'hd'.
QUALITY='hd'

# UA
#   What User-Agent to declare ourselves as.
UA="Mozilla/5.0 (Windows; U; Windows NT 6.1; ru; rv:1.9.2.3) Gecko/20100401 Firefox/4.0 (.NET CLR 3.5.30729)"

# ] CONFIG_END



# Standard Vimeo player path (VIDID = Video ID)
PLAYER_PATH="http://vimeo.com/<VIDID>"

# Standard Vimeo video path (VIDID = Video ID, SIG = Signature, TIME = Timestamp)
VIDEO_PATH="http://player.vimeo.com/play_redirect?clip_id=<VIDID>&sig=<SIG>&time=<TIME>&quality=${QUALITY}"



# Quit on error
set -e

# Version
APP_NAME="Vimeo-DL"
APP_VER="0.03"
APP_URL="http://www.datapax.com.au/vimeo-dl/"

# Program name
PROG="$(basename "${0}")"

# exit condition constants
ERR_NONE=0
ERR_MISSINGDEP=1
#ERR_UNKNOWNOPT=2
#ERR_MISSINGOPT=3
#ERR_INVALIDVALUE=4




# Params:
#   NONE
function show_version {
    echo -e "\
${APP_NAME} v${APP_VER}\n\
${APP_URL}\n\
"
}

# Params:
#   NONE
function show_usage {
    show_version
cat <<EOF

${APP_NAME} attempts to retrieve a Vimeo video.

Usage: ${PROG} -h|--help
       ${PROG} -V|--version
       ${PROG} <VID> [<VID> [...]]
       echo -e <VID>["\n" <VID> [...]]|${PROG}

-h|--help           - Displays this help
-V|--version        - Displays the program version
VID                 - URL(s) or Vimeo video IDs etc

Example: ${PROG} 47302607 http://player.vimeo.com/video/47302309 http://vimeo.com/47302308
EOF
}

# Params:
#   $1 = return value
function exitcd {
    if [ ${#} -eq 0 ]; then
        ret=${ERR_NONE}
    else
        ret=${1}
    fi

    if [ "${CWD}" != "$(pwd)" ]; then
        cd "${CWD}"
    fi
    exit ${ret}
}

# Params:
#   NONE
function nop {
    echo -n &>/dev/null
}

# Params:
#   $1 =  (s) command to look for
#   $2 = [(s) suspected package name]
function check_for_cmd {
    # Check for ${1} command
    cmd="UNKNOWN"
    [ $# -gt 0 ] && cmd="${1}" && shift 1
    pkg="${cmd}"
    [ $# -gt 0 ] && pkg="${1}" && shift 1

    type -P "${cmd}" >/dev/null 2>&1 || {
cat <<EOF >&2
ERROR: Cannot find ${cmd}.  This is required.
Ensure you have ${pkg} installed or search for ${cmd}
in your distributions' packages.
EOF

        exitcd ${ERR_MISSINGDEP}
    }

    return ${ERR_NONE}
}

# Debug echo
function decho {
    # Not debugging, get out of here then
    [ ${DEBUG} -le 0 ] && return

    # If debug file NOT set, output to stderr
    if [ -z "${DEBUG_FILE}" ]; then
        echo "DEBUG: ${@}" >&2
        return
    fi

    # Output to debug file
    echo "DEBUG: ${@}" >>"${DEBUG_FILE}"
}



# Check for sed
check_for_cmd "sed" "sed"

# Check for egrep
check_for_cmd "egrep" "grep"

# Check for wget
check_for_cmd "wget" "wget"

# Sample URLS:
#   47302607
#   http://player.vimeo.com/video/47302309
#   http://vimeo.com/47302308
function dlvid() {
    # $1 = vid URL/Name

    id="${1}"

    # Strip "http://"
    [ "${id:0:7}" == "http://" ] && id="${id:7}"

    # Strip all but last path element
    id="${id##*/}"

    decho "Video ID: ${id}"

    data="$(wget -U "${UA}" -O - "${PLAYER_PATH/<VIDID>/${id}}")"
    title="$(echo "${data}"|sed -n 's#^.*<title>\([^<]*\).*$#\1#pg')"
    ts="$(echo "${data}"|sed -n 's#^.*,"timestamp":\([0-9]*\).*$#\1#pg')"
    sig="$(echo "${data}"|sed -n 's#^.*,"signature":"\([^"]*\)".*$#\1#pg')"

    vid_path="$(\
        echo "${VIDEO_PATH}"|\
        sed 's#<VIDID>#'${id}'#;s#<SIG>#'${sig}'#;s#<TIME>#'${ts}'#g'\
    )"

    decho "Video Path: ${vid_path}"

    out_file="${title// /_}.vimeo${id}.flv"

    decho "Saving as: ${out_file}"

    wget -U "${UA}" -O "${out_file}" "${vid_path}" && {
        echo "Video complete: ${out_file} (${1})"
    } || {
        echo "ERROR: Failed to download ${out_file} (${1})"
    }

    return $?
}

# START #

# Current working directory
CWD="$(pwd)"

decho "START"

if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then #{
    # Help
    show_usage
    exitcd ${ERR_NONE}
fi #}

if [ "${1}" == "-V" ] || [ "${1}" == "--version" ]; then #{
    # Version
    show_version
    exitcd ${ERR_NONE}
fi #}

if [ ${#} -gt 0 ]; then #{
    while [ ${#} -gt 0 ]; do #{
        dlvid "${1}"

        shift 1
    done #}

else #} {
    while read line; do #{
        dlvid "${line}"

    done #}

fi #}

decho "END"
