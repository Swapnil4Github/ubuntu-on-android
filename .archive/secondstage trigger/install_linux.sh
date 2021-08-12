#!/usr/bin/env bash

# * Deafault color is Blue
RST="\e[0m"
RED="\e[1;31m" # *This is bold 
GREEN="\e[1;32m"
BLUE="\e[34m"
DC=${BLUE}


# * Usefull functions
# die()     exit with code 1 with printing given string
# warn()    like die() without exit status (used when exit is not necessary)
# shout()   pring messege in a good way with some lines
# lshout()  print messege in a standard way

die    () { echo -e "${RED}Error ${*}${RST}";exit 1 ;:;}
warn   () { echo -e "${RED}Error ${*}${RST}";:;}
shout  () { echo -e "${DC}-----";echo -e "${*}";echo -e "-----${RST}";:; }
lshout () { echo -e "${DC}";echo -e "${*}";echo -e "${RST}";:; }

# PATHS
SECOND_STAGE_DIR="/debootstrap"

# couple of exit code
# if [ ! -d "${SECOND_STAGE_DIR}" ]; then
#     die "Directory: \"$GREEN${SECOND_STAGE_DIR}$RED\" Not found Can continue giving up"
# fi
# if [ ! -f "${SECOND_STAGE_DIR}/debootstrap" ]; then
#     die "File: \"$GREEN${SECOND_STAGE_DIR}/debootstrap$RED\" Not found Can continue giving up"
# fi

# if [ "$(uname -m)" != "arm64" ]; then
#     die "Only supports arm64 not $(uname -m)"
# fi


pd help

shout "Starting Second stage.... $GREEN${SECOND_STAGE_DIR}/debootstrap --second-stage"
$SECOND_STAGE_DIR/debootstrap --second-stage || warn "Installation completed with errors"
