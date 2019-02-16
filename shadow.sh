#!/usr/bin/env bash

# Copyright (C) 2019 Shadow Of Mordor (energyspear17@xda)
# SPDX-License-Identifier: GPL-3.0-only

# Script used to build Shadow Kernel

# Kernel Config Variables

KERNEL_DIR="${PWD}"
KERNEL="shadow"
BUILD_USER="energyspear17"
BUILD_HOST="gcp"
DEVICE="beryllium"
VERSION="pie"
ARCH="arm64"
CROSS_COMPILE="/home/${USER}/toolchain/gcc-linaro-7.4.1/bin/aarch64-linux-gnu-"
CC="/home/${USER}/toolchain/dtc/out/9.0/bin/clang"
CLANG_TRIPLE="aarch64-linux-gnu-"
CCACHE_DIR="~/.ccache"
OUT="out"

# Color configs

yellow='\033[0;33m'
white='\033[0m'
red='\033[0;31m'
gre='\e[0;32m'
blue='\033[0;34m'
cyan='\033[0;36m'

# Build configs

zimage="${KERNEL_DIR}/out/arch/arm64/boot/Image"
time=$(date +"%d-%m-%y-%T")
date=$(date +"%d-%m-%y")
build_type="gcc"

function build() {

if [ "$1" = "gcc" ]; then
    echo -e "$blue Building Kernel with gcc... \n $white"
    export KBUILD_BUILD_HOST="${BUILD_HOST}"
    export KBUILD_BUILD_USER="${BUILD_USER}"
    export ARCH="${ARCH}"
    export CROSS_COMPILE="${CROSS_COMPILE}"
    export USE_CCACHE=1
    export CCACHE_DIR="${CCACHE_DIR}"
    ccache -M 50G
    make O="${OUT}" "${KERNEL}_defconfig"
    make O="${OUT}" -j$(nproc --all) &>buildlog.txt & pid=$!
else
    echo -e "$yellow Building Kernel with clang... \n $white"
    export KBUILD_BUILD_HOST="${BUILD_HOST}"
    export KBUILD_BUILD_USER="${BUILD_USER}"
    export USE_CCACHE=1
    export CCACHE_DIR="${CCACHE_DIR}"
    ccache -M 50G
    make O="${OUT}" ARCH="${ARCH}" "${KERNEL}_defconfig"
    make -j$(nproc --all) O="${OUT}" \
                      ARCH="${ARCH}" \
                      CC="${CC}" \
                      CLANG_TRIPLE="${CLANG_TRIPLE}" \
                      CROSS_COMPILE="${CROSS_COMPILE}" &>buildlog.txt & pid=$!
fi
  spin[0]="$gre-"
  spin[1]="\\"
  spin[2]="|"
  spin[3]="/$nc"

  echo -ne "$yellow [Please wait...] ${spin[0]}$nc"
  while kill -0 $pid &>/dev/null
  do
    for i in "${spin[@]}"
    do
          echo -ne "\b$i"
          sleep 0.1
    done
  done
if ! [ -a ${zimage} ]; then
    echo -e "$red << Failed to compile zImage, check log and fix the errors first >>$white"
    exit 1
fi
echo -e "$yellow\n Build successful !\n $white"
End=$(date +"%s")
Diff=$(($End - $Start))
echo -e "$gre << Build completed in $(($Diff / 60)) minutes and $(($Diff % 60)) seconds >> \n $white"        
}

function clean() {

echo -e "$blue Cleaning... \n$white"
make O=$OUT clean
make O=$OUT mrproper
make clean && make mrproper
rm ${KERNEL_DIR}/out/arch/arm64/boot/Image

}

function menuconfig() {

echo -e "$blue Displaying Config Menu... \n$white"

export ARCH="${ARCH}"
make "${KERNEL}_defconfig"
make menuconfig

if [ -f "${KERNEL}_defconfig" ]; then
mv ${KERNEL}_defconfig arch/arm64/configs/${KERNEL}_defconfig
echo -e "$gre\n Configuration saved...\n $white"
else
echo -e "$yellow\n No defconfig saved from menuconfig...\n $white"
fi

}

function makezip() {
echo -e "$blue\n Generating flashable zip now... \n $white"
cd ${KERNEL_DIR}/build/
rm *.zip > /dev/null 2>&1
rm -rf kernel
mkdir kernel
rm -rf dtbs
mkdir dtbs
mv ${KERNEL_DIR}/out/arch/arm64/boot/dts/qcom/*.dtb ${KERNEL_DIR}/build/dtbs/
cp ${KERNEL_DIR}/out/arch/arm64/boot/Image.gz ${KERNEL_DIR}/build/kernel/
cd ${KERNEL_DIR}/build/
v=$(grep "CONFIG_LOCALVERSION=" "${KERNEL_DIR}/arch/arm64/configs/${KERNEL}_defconfig" | cut -d- -f3- | cut -c -3)
zip -r $KERNEL-$DEVICE-$VERSION-v$v-$date.zip * > /dev/null
if [ "$1" = "y" ]; then
    if [ -f "/usr/local/bin/gdrive" ]; then
        gdrive upload $KERNEL-$DEVICE-$VERSION-v$v-$date.zip
    else
        echo -e "$yellow\n GDrive not found installing...\n $white"
        wget "https://drive.google.com/uc?id=10NAVLG-cNSPcPC-g3E-RfMgFksxJnyZu&export=download"
        mv "uc?id=10NAVLG-cNSPcPC-g3E-RfMgFksxJnyZu&export=download" gdrive
        chmod +x gdrive
        sudo install gdrive /usr/local/bin/gdrive
        rm gdrive
        if [ -f "/usr/local/bin/gdrive" ]; then
            echo -e "$blue\n GDrive Installed Successfully.. Configure gdrive and upload manually\n $white"
        else
            echo -e "$red << GDrive installation failed Try Installing Manually... >>$white"
        fi
    fi

fi
cd ${KERNEL_DIR}
}

function main() {

echo -e ""

if [ "$1" = "" ]; then
    echo -e "$cyan \n\n███████╗██╗  ██╗ █████╗ ██████╗  ██████╗ ██╗    ██╗\n██╔════╝██║  ██║██╔══██╗██╔══██╗██╔═══██╗██║    ██║\n███████╗███████║███████║██║  ██║██║   ██║██║ █╗ ██║\n╚════██║██╔══██║██╔══██║██║  ██║██║   ██║██║███╗██║\n███████║██║  ██║██║  ██║██████╔╝╚██████╔╝╚███╔███╔╝\n╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝  ╚═════╝  ╚══╝╚══╝ \n\n  "
    echo -e "$blue\n 1.Build $KERNEL\n$gre\n 2.Make Menu Config\n$yellow\n 3.Clean Source\n$red\n 4.Exit\n$white"
    echo -n " Enter your choice:"
    read ch

    case $ch in
        1)
            read -r -p "Do you want to compile with clang ? y/n :" CL_ANS
            if [ "$CL_ANS" = "y" ]; then
                build_type="clang"
            fi
            echo -e "$yellow Running make clean before compiling \n$white"
            clean
            Start=$(date +"%s")
            build $build_type
            read -r -p "Do you want to make flashable zip ? y/n :" ZIP
            if [ "$ZIP" = "y" ]; then
                read -r -p "Do you want to Upload to Gdrive ? y/n :" GD
                makezip $GD
            fi
            ;;
        2)
            menuconfig
            ;;
        3)
            clean
            ;;
        *)
           exit 1
    esac
    
else
    case $1 in
        b)
            if [ "$2" = "" ]; then
                echo -e "$red << Please Specify clang or gcc... >>$white"
                exit 2
            fi
            echo -e "$yellow Running make clean before compiling \n$white"
            clean
            Start=$(date +"%s")
            build $2
            if [ "$3" = "y" ]; then
                makezip $4
            fi
            ;;
        mc)
            menuconfig
            ;;
        c)
            clean
            ;;
        *)
           echo -e "$red << Unknown argument passed... >>$white"
           exit 1
    esac

fi
}

main $1 $2 $3 $4
