#!/usr/bin/env bash

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

sys_arch="$(uname -m)"
codename="$()"

function mount_fs()
{
    m_points="/dev /proc /sys"
    if [ ! -d "$1" ]; then
        die "Error: Directory $1 is no such directory found.."
    fi

    for points in $m_points; do
        if [ ! -d "$points" ]; then
            warn "Error: Directory $points: no such directory found.. (Required to mount)"
            die "giving up.."
        fi    
    done
    make_sure_of_root
    shout "Mounting $m_points to $1"
    # echo "${spasswd}" | sudo -S whoami

    if ! $isroot; then
        add_args="echo \"$spasswd\" | sudo -S"
    fi

    "$add_args" mount -t proc /proc proc/ || die "Mount Error"
    "$add_args" mount -t sysfs /sys sys/ || die "Mount Error"
    "$add_args" mount --rbind /dev dev/ || die "Mount Error"
}

function make_sure_of_root()
{
    local isroot
    local spasswd
    if [ "$(id -u)" != 0 ]; then
        if ! command -v sudo >> /dev/null; then
            die "Error: Cannot aquire root privileges"
        fi
        lshout "Trying to aquire root privileges"
        read -r -s -p "please enter sudo passwd : " spasswd
    else
        isroot=true
    fi
    
}

function de_debootstarp()
{
    :
    # TODO: Implement multiarch and complete this function
}

#TODO: add entry point and conditions