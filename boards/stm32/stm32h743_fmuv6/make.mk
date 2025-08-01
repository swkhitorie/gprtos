###############################################
# Manufacturer Library files make Configuration
###############################################

# enable/disable low level driver user library
# absolutely enable
BSP_LIBCONFIG_STM32_LLDRV=y

# compile macros for low level driver user library
BSP_LIBCONFIG_STM32_LLDRV_SERIES=DRV_BSP_H7

# sdk sources selection, enable stm32 cubeLibrary H7
BSP_LIBCONFIG_STM32_SERIES=BSP_STM32_H7

# cubeLibrary modules and low level drivers selection
BSP_LIBCONFIG_STM32_HAL_USART=y
BSP_LIBCONFIG_STM32_HAL_IWDG=y
BSP_LIBCONFIG_STM32_HAL_RTC=y
BSP_LIBCONFIG_STM32_HAL_FLASH=n
BSP_LIBCONFIG_STM32_HAL_BASTIM=n
BSP_LIBCONFIG_STM32_HAL_I2C=y
BSP_LIBCONFIG_STM32_HAL_SPI=y
BSP_LIBCONFIG_STM32_HAL_QSPI=y
BSP_LIBCONFIG_STM32_HAL_MMCSD=y

# include all cubelibrary files and low level driver files
include ${SDK_ROOTDIR}/boards/stm32/libs/bsp_libs_stm32.mk
CSOURCES += ${LIB_CSRCS}
PROJ_CINCDIRS += ${LIB_CINCDIRS}

BOARD_BSP_PATH := boards/stm32/stm32h743_fmuv6

#########################################################################
# BSP macros, sources + asm + link files, includes, and entry address
#########################################################################
BOARD_CDEFS += ${BSP_LIBCONFIG_STM32_LLDRV_SERIES}
BOARD_CDEFS += STM32H743xx
BOARD_CDEFS += USE_HAL_DRIVER

BOARD_CSRCS += board_irq.c
BOARD_CSRCS += board_rcc_init.c
BOARD_CSRCS += board_usb.c
BOARD_CSRCS += board_init.c
BOARD_CSRCS += board_bsp.c

BOARD_CPPSRCS += px4_i2c.cpp
BOARD_CPPSRCS += px4_spi.cpp

BOARD_ASMSOURCES += fmuv6_startup.s
BOARD_LNK_FILE   += fmuv6_lnk_script.ld

BOARD_CDEFS += CONFIG_STM32_DMA_SPI1_RX
BOARD_CDEFS += CONFIG_STM32_DMA_SPI1_TX
BOARD_CDEFS += CONFIG_STM32_DMA_SPI2_RX
BOARD_CDEFS += CONFIG_STM32_DMA_SPI2_TX

TMPBOARD_CSRCS = ${addprefix ${BOARD_BSP_PATH}/,${BOARD_CSRCS}}
TMPBOARD_CPPSRCS = ${addprefix ${BOARD_BSP_PATH}/,${BOARD_CPPSRCS}}
TMPBOARD_ASMSOURCES = ${addprefix ${BOARD_BSP_PATH}/,${BOARD_ASMSOURCES}}
TMPBOARD_LNK_FILE = ${addprefix ${BOARD_BSP_PATH}/,${BOARD_LNK_FILE}}

#######################################
# Add all setting to root make variable
#######################################
MOD_ARCH                 = m7
PROJ_ENTRY_POINT        := Reset_Handler
SCF_FILE                := ${TMPBOARD_LNK_FILE}

PROJ_CDEFS              += ${BOARD_CDEFS}

PROJ_CINCDIRS           += ${BOARD_BSP_PATH}
CSOURCES                += ${TMPBOARD_CSRCS}
CPPSOURCES              += ${TMPBOARD_CPPSRCS}
ASMSOURCES              := ${TMPBOARD_ASMSOURCES}
