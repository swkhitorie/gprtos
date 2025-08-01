
PROJ_NAME  :=  fmuv6_sens
PROJ_TC    :=  gae

CONFIG_LINK_PRINTF_FLOAT:=y
CONFIG_LINK_SCANF_FLOAT:=n
CONFIG_COMPILE_OPTIMIZE:=O1

TARGET_POSTBUILD := ${TARGET_DEST_FILENAME_BIN}

# board configuration
MOD_ARCH = m7
include ${SDK_ROOTDIR}/boards/stm32/stm32h743_fmuv6/make.mk

# os and library configuration
CONFIG_MK_CHIP_ARCH=${MOD_ARCH}
CONFIG_MK_COMPILER=gcc
CONFIG_MK_USE_FREERTOS=n
CONFIG_MK_USE_FRMEM_METHOD=4
CONFIG_MK_USE_FR_POSIX=n
CONFIG_MK_USE_FS_FATFS=n
CONFIG_MK_USE_LIB_CPP=n

CONFIG_MK_USE_CRUSB=y
CONFIG_MK_USE_CRUSB_CDC=y
CONFIG_MK_CRUSB_IP=dwc2_st

CONFIG_MK_USE_PX4_TASKS=n
CONFIG_MK_USE_PX4_HRT=y
CONFIG_MK_USE_PX4_UORB=n
CONFIG_MK_USE_PX4_WORKQUEUE=n
CONFIG_MK_USE_PX4_LOG=n
CONFIG_MK_USE_PX4_MODULE=n
CONFIG_MK_USE_PX4_PERF_CNTER=n

include ${SDK_ROOTDIR}/sched/make.mk
include ${SDK_ROOTDIR}/mm/make.mk
include ${SDK_ROOTDIR}/libs/make.mk
include ${SDK_ROOTDIR}/include/make.mk
include ${SDK_ROOTDIR}/usb/make.mk
include ${SDK_ROOTDIR}/px4/make.mk
CSOURCES      += ${FR_CSOURCES}
CPPSOURCES    += ${FR_CPPSOURCES}
PROJ_CINCDIRS += ${FR_CINCDIRS}

#####################################
# app configuration
# macro list: 
# bsp: 
#     CONFIG_BOARD_COM_STDINOUT
#     CONFIG_BOARD_FREERTOS_ENABLE
#     CONFIG_BOARD_CRUSB_CDC_ACM_ENABLE
#     CONFIG_BOARD_MTD_QSPIFLASH_ENABLE
#     CONFIG_BOARD_MTD_QSPIFLASH_FATFS_SUPPORT
#     CONFIG_BOARD_MTD_QSPIFLASH_RAW_RW_TEST
#     CONFIG_BOARD_MMCSD_ENABLE
#     CONFIG_BOARD_MMCSD_FATFS_SUPPORT
#     CONFIG_BOARD_MMCSD_RAW_RW_TEST
#     CONFIG_BOARD_MMCSD_INFO_CHECK
# rtos:
#     CONFIG_FR_MALLOC_FAILED_HANDLE
#     CONFIG_FR_IDLE_TIMER_TASKCREATE_HANDLE
# usb:
#     CONFIG_CRUSB_CDC_TX_FIFO_ENABLE
#     CONFIG_BOARD_CRUSB_CDC_ACM_STDINOUT
#####################################
#PROJ_CDEFS += CONFIG_BOARD_COM_STDINOUT
PROJ_CDEFS += CONFIG_BOARD_CRUSB_CDC_ACM_ENABLE
PROJ_CDEFS += CONFIG_BOARD_CRUSB_CDC_ACM_STDINOUT
PROJ_CDEFS += CONFIG_CRUSB_CDC_TX_FIFO_ENABLE

APP_PROJ_DIR = apps/demo/fmuv6_sens

PROJ_CINCDIRS += ${APP_PROJ_DIR}
CPPSOURCES += ${APP_PROJ_DIR}/app_main.cpp
CSOURCES += ${APP_PROJ_DIR}/icm42688_test.c
CPPSOURCES += ${APP_PROJ_DIR}/IST8310.cpp

