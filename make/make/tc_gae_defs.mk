#
# compiler defs for gcc arm toolchain
#
include ${MAKEFILES_ROOTDIR}/make/macros.mk

#
# This is the default installation path for gcc arm. Change it if different
# 
# TC_PATH_INST_GCC:=D:\__dev_envir\__env\arm_gcc\gcc-arm-none-eabi
TC_GCC_PREFIX = arm-none-eabi-

#
# GCC ARM Compiler related section
#
ifneq ($(OS),Linux)
TC_PATH_BIN:=$(call MK_SHORTNAME,"${TC_PATH_INST_GCC}/bin")
TC_PATH_INC:=$(call MK_SHORTNAME,"${TC_PATH_INST_GCC}/arm-none-eabi/include")
TC_PATH_LIB:=$(call MK_SHORTNAME,"${TC_PATH_INST_GCC}/arm-none-eabi/lib")
else
TC_PATH_BIN:=${TC_PATH_INST_GCC}/bin
TC_PATH_INC:=${TC_PATH_INST_GCC}/arm-none-eabi/include
TC_PATH_LIB:=${TC_PATH_INST_GCC}/arm-none-eabi/lib
endif

#
# toolchain executables
#
ifneq ($(OS),Linux)
TC_MAKEDEP:=$(call MK_PATHTOUNX,${TC_PATH_BIN}/$(TC_GCC_PREFIX)gcc.exe -MM)
TC_CC:=$(call MK_PATHTOUNX,${TC_PATH_BIN}/$(TC_GCC_PREFIX)gcc.exe)
TC_CPP:=$(call MK_PATHTOUNX,${TC_PATH_BIN}/$(TC_GCC_PREFIX)g++.exe)
TC_ASM:=$(call MK_PATHTOUNX,${TC_PATH_BIN}/$(TC_GCC_PREFIX)as.exe)
TC_LINK:=$(call MK_PATHTOUNX,${TC_PATH_BIN}/$(TC_GCC_PREFIX)gcc.exe)
TC_AR:=$(call MK_PATHTOUNX,${TC_PATH_BIN}/$(TC_GCC_PREFIX)ar.exe)
TC_GENBIN:=$(call MK_PATHTOUNX,${TC_PATH_BIN}/$(TC_GCC_PREFIX)objcopy.exe)
TC_SIZE:=$(call MK_PATHTOUNX,${TC_PATH_BIN}/$(TC_GCC_PREFIX)size.exe)
TC_DUMP:=$(call MK_PATHTOUNX,${TC_PATH_BIN}/$(TC_GCC_PREFIX)objdump.exe)
else
TC_MAKEDEP:=${TC_PATH_BIN}/$(TC_GCC_PREFIX)gcc -MM
TC_CC:=${TC_PATH_BIN}/$(TC_GCC_PREFIX)gcc
TC_CPP:=${TC_PATH_BIN}/$(TC_GCC_PREFIX)g++
TC_ASM:=${TC_PATH_BIN}/$(TC_GCC_PREFIX)as
TC_LINK:=${TC_PATH_BIN}/$(TC_GCC_PREFIX)gcc
TC_AR:=${TC_PATH_BIN}/$(TC_GCC_PREFIX)ar
TC_GENBIN:=${TC_PATH_BIN}/$(TC_GCC_PREFIX)objcopy
TC_SIZE:=${TC_PATH_BIN}/$(TC_GCC_PREFIX)size
TC_DUMP:=${TC_PATH_BIN}/$(TC_GCC_PREFIX)objdump
endif

#
# toolchain switches macros
#
TC_ASM_VIA=@${1}
TC_CC_VIA=@${1}
TC_LINK_VIA=@${1}
TC_LINK_LIBUSE=
TC_LINK_ENTRY=-e ${1}
TC_LINK_SCF=-T ${1}
TC_LINK_LIST=-Wl,-Map=${1}

#
# constants
#

# toolchain identifiers
TC_NAME:=gae
TC_SUFFIX:=elf

# Assembly opcodes type
TC_ASMTYPE:=gnu
TC_ASMEXT:=asm

TC_TARGETARM:=-marm
TC_TARGETTHUMB:=-mthumb

# Assembly compiler options
TC_ASMOPTS:=\
  --gdwarf-2                  
  
TC_DBG_ASMOPTS:=
  # -g                    \
  # -gdwarf-2

# Assembly compiler defines
TC_ASMDEFS:=

ifeq (${CONFIG_COMPILE_OPTIMIZE},)
COMPILE_OPTIMIZE := O1
else
COMPILE_OPTIMIZE := ${CONFIG_COMPILE_OPTIMIZE}
endif

# C compiler options
TC_COPTS:=\
  -c                    \
  -ffunction-sections   \
  -fdata-sections       \
  -fstack-usage         \
  -${COMPILE_OPTIMIZE}  \
  -gdwarf-2             \
  -w -Wno-empty-body       \
  -w -Wno-macro-redefined  \
  -w -Wno-invalid-source-encoding \
  -w -Wno-writable-strings \
  --specs=nano.specs   \
  -g3

ifneq (${CONFIG_C_STANDARD},)
TC_COPTS += -std=${CONFIG_C_STANDARD}
endif

TC_CPPOPTS:=\
  -c                    \
  -ffunction-sections   \
  -fdata-sections       \
  -fstack-usage         \
  -${COMPILE_OPTIMIZE}  \
  -gdwarf-2             \
  -w -Wno-empty-body       \
  -w -Wno-macro-redefined  \
  -w -Wno-invalid-source-encoding \
  -w -Wno-writable-strings \
  --specs=nano.specs     \
  -g3

ifneq (${CONFIG_CXX_STANDARD},)
TC_CPPOPTS += -std=${CONFIG_CXX_STANDARD}
endif

TC_DBG_COPTS:=
  # -g          \
  # -gdwarf-2

# C compiler defines
TC_CDEFS:=

# Linker options
TC_LIBOPTS:=\
  -W                        \
  -Wl,--gc-sections --static \
  --data-sections           \
  -lc                       \
  -lm                       \
  --specs=nosys.specs


ifneq (${CONFIG_LIB_NOT_USE_NANOLIB},y)
TC_LIBOPTS += --specs=nano.specs
else
TC_LIBOPTS += --specs=nosys.specs
endif

ifeq (${CONFIG_LINK_PRINTF_FLOAT},y)
TC_LIBOPTS += -u _printf_float 
endif

ifeq (${CONFIG_LINK_SCANF_FLOAT},y)
TC_LIBOPTS += -u _scanf_float 
endif

# Scatter file extension
TC_SCFEXT:=ld

# Linker libraries
TC_LIBNAMES:=\
  c                     \
  m                     \
  stdc++

TC_LIBPREFIX:=lib
TC_LIBSUFFIX:=gcc4x
TC_LIBEXT:=a

# Archiver options
TC_AROPTS:=\
  -r

#
# toolchain macros
#

# convert PATH to toolchain friendly path
MK_TC_PATH=$(call MK_PATHTOUNX,${1})

# command to generate list of linker directory search paths
MK_TC_LIBDIRS=$(if ${1},$(addprefix -L,${1}))

# command to generate list of linker directory search paths
MK_TC_LIBS=$(if ${1},$(addprefix -l,${1}))

# command to generate scatter file
# 1 - template file
# 2 - output file
# 3 (opt) - armcc options
MK_TC_GENSCF=$(if $(and ${1},${2},${3}),@${TC_GENSCF} -P -E ${1} -o ${2} ${3})

# command to generate binary file
# 1 - input file
# 2 - output file
MK_TC_GENBIN=$(if $(and ${1},${2}),@${TC_GENBIN} -O binary ${1} ${2})

# command to disassembly output file
# 1 - input file
# 2 - output file
MK_TC_DISASSEMBLY=$(if $(and ${1},${2}), @${TC_DUMP} -h -S ${1} > "${2}")
