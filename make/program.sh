#!/bin/bash

script_dir="$(cd "$(dirname "$0")" && pwd)"
source ${script_dir}/toolchain.sh
app_subpath=$1
make_thread=$2
make_rebuild=$3
prog_interface=$4
prog_target=$5

echo "path[gcc-arm ]:" ${armgcc_path}
echo "path[openocd ]:" ${openocd_path}
echo "path[armcc   ]:" ${armcc_path}
echo "path[armclang]:" ${armclang_path}

target_addr=0x08000000
target_type1=$(echo stm32 | grep "${prog_target}")

if [ ${target_type1} ]
then
target_addr=0x08000000
fi

cd ${script_dir}/../

current_dir=$(pwd)
find_sub_path=$current_dir/apps/$app_subpath
if [ ! -d ${find_sub_path} ];then
    echo "APP directory:"${find_sub_path}"/ is not exist"
    exit 1
fi

if [ ${make_rebuild} ]
then
    if [ ${make_rebuild} == "-r" ]
    then
        ./make/clean.sh $1
        echo "rebuilding..."
    else
        echo "building..."
    fi
else
    echo "building..."
fi

make all ${make_thread} \
    APP_SUBPATH=${app_subpath} \
    OS=${makefile_os} \
    MAKE_TARGET_CLEANS=n \
    TC_PATH_INST_GCC=${armgcc_path} \
    TC_PATH_INST_ARMCC=${armcc_path} \
    TC_PATH_INST_ARMCLANG=${armclang_path}\
    TC_OPENOCD_PATH=${openocd_path}

make program ${make_thread} \
    APP_SUBPATH=${app_subpath} \
    OS=${makefile_os} \
    MAKE_TARGET_CLEANS=n \
    TC_PATH_INST_GCC=${armgcc_path} \
    TC_PATH_INST_ARMCC=${armcc_path} \
    TC_PATH_INST_ARMCLANG=${armclang_path} \
    TC_OPENOCD_PATH=${openocd_path} \
    PROJ_OPENOCD_DEBUG=${prog_interface} \
    PROJ_OPENOCD_CHIP=${prog_target} \
    PROJ_OPENOCD_LOAD_ADDR=${target_addr}

# make/program.sh test/app_bsp_test -j2 -r stlink stm32f4x 
# make/program.sh test/app_bsp_test -j2 -r stlink stm32h7x 

exit 0
