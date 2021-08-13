#!/usr/bin/env bash

build_root="~/rootfs-build"

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
codename="$()" # debootstrap only work in latest ubunbtu -> impish

function mount_fs()
{
    m_points="dev proc sys"
    if [ ! -d "$1" ]; then
        die "Error: Directory $1 is no such directory found.."
    else
        mkdir -p "$build_root"
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

    "$add_args" mount -t proc /proc "${1}"/proc/ || die "Mount Error"
    "$add_args" mount -t sysfs /sys "${1}"/sys/ || die "Mount Error"
    "$add_args" mount --rbind /dev "${1}"/dev/ || die "Mount Error"
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
    # make folder
    if [ -d ~/rootfs-build ]; then
        die "Folder ~/rootfs-build already exists..."
    fi
    
    mkdir -pv ~/rootfs-build
    
    # Do Download first
    for b_arch in {arm64,armhf,amd64}; do
        shout "Getting things for ${b_arch}"
        mkdir -pv ~/rootfs-build/impish-"$b_arch"
        sudo debootstrap \
            --foreign    \
            --arch="${b_arch}" \
            --include=udisk2,fprintd \
            ~/rootfs-build/impish-"$b_arch" \
            impish
        shout "Done!"
    done
    unset b_arch
    for b_arch in {arm64,armhf,amd64}; do
        shout "Getting things for ${b_arch}"
            "$add_args" mount_fs "${build-root}/impish-${b_arch}"
            "$add_args" cp "/bin/qemu-$(arch_translate "${b_arch}")-static" "${build-root}/impish-${b_arch}"
            "$add_args" chroot "${build-root}/impish-${b_arch}" /bin/bash /debootstrap/debootstrap --second-stage
        shout "Done!"
    done
    unset b_arch
    #TODO: algo to make tarballs
}

function arch_traslate()
{
    case $VAR in
        "arm64") echo "aarch64"
        ;;
        "armhf") echo "armhf"
        ;;
        "amd64") echo "x86_64"
        ;;
        *) echo default
        ;;
    esac
    
}

# function do_second_stage()
# {
#     fs_dir=
#     for b_arch in {arm64,armhf,amd64}; do
#         cp "/bin/qemu-$(arch_translate ${b_arch})-static" 
#     done
# }
de_debootstarp
#TODO: Test and make fixes