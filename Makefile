# Path to root dir
SDK_DIR_MK = $(dir $(realpath $(lastword ${MAKEFILE_LIST})))
SDK_DIR_CUR = $(CURRENT_DIR)
SDK_ROOTDIR := ${SDK_DIR_MK}

# Absolute path to makefiles
MAKEFILES_ROOTDIR := ${SDK_ROOTDIR}/make

CONFIG_FILE := ${SDK_ROOTDIR}/apps/app_config.mk
include ${CONFIG_FILE}

# including common build makefile
include $(MAKEFILES_ROOTDIR)/make/build.mk
all: prebuild build postbuild
