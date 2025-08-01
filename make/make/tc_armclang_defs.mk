#
# compiler defs for ARM Compiler v6 clang toolchain
#
include ${MAKEFILES_ROOTDIR}/make/macros.mk

#
# This is the default installation path for Keil/MDK. Change it if different
# 
# TC_PATH_INST_ARMCLANG := D:\__dev_envir\__env\mdk5\CORE\ARM\ARMCLANG

#
# ARM Compiler related section
#
ifneq ($(OS),Linux)
TC_PATH_BIN:=$(call MK_SHORTNAME,"${TC_PATH_INST_ARMCLANG}/bin")
TC_PATH_INC:=$(call MK_SHORTNAME,"${TC_PATH_INST_ARMCLANG}/include")
TC_PATH_LIB:=$(call MK_SHORTNAME,"${TC_PATH_INST_ARMCLANG}/lib")
else
TC_PATH_BIN:=${TC_PATH_INST_ARMCLANG}/bin
TC_PATH_INC:=${TC_PATH_INST_ARMCLANG}/include
TC_PATH_LIB:=${TC_PATH_INST_ARMCLANG}/lib
endif

#
# toolchain executables
#
ifneq ($(OS),Linux)
TC_MAKEDEP:=$(call MK_PATHTOUNX,${TC_PATH_BIN}/armclang.exe -M)
TC_CC:=$(call MK_PATHTOUNX,${TC_PATH_BIN}/armclang.exe)
TC_CPP:=$(call MK_PATHTOUNX,${TC_PATH_BIN}/armclang.exe)
TC_ASM:=$(call MK_PATHTOUNX,${TC_PATH_BIN}/armclang.exe)
TC_LINK:=$(call MK_PATHTOUNX,${TC_PATH_BIN}/armlink.exe)
TC_AR:=$(call MK_PATHTOUNX,${TC_PATH_BIN}/armar.exe)
TC_GENBIN:=$(call MK_PATHTOUNX,${TC_PATH_BIN}/fromelf.exe)
TC_SIZE:=$(call MK_PATHTOUNX,${TC_PATH_BIN}/fromelf.exe -z)
TC_DUMP:=$(call MK_PATHTOUNX,${TC_PATH_BIN}/fromelf.exe)
else
TC_MAKEDEP:=${TC_PATH_BIN}/armclang
TC_CC:=${TC_PATH_BIN}/armclang
TC_CPP:=${TC_PATH_BIN}/armclang
TC_ASM:=${TC_PATH_BIN}/armclang
TC_LINK:=${TC_PATH_BIN}/armlink
TC_AR:=${TC_PATH_BIN}/armar
TC_GENBIN:=${TC_PATH_BIN}/fromelf
TC_SIZE:=${TC_PATH_BIN}/fromelf -z
TC_DUMP:=${TC_PATH_BIN}/fromelf
endif

#
# toolchain switches macros
#
TC_ASM_VIA=@${1}
TC_CC_VIA=@${1}
TC_LINK_VIA=@${1}
TC_LINK_ENTRY=--entry=${1}
TC_LINK_SCF=--scatter=${1}
TC_LINK_LIST=--list=${1}

#
# constants
#

# toolchain identifiers
TC_NAME:=armclang
TC_SUFFIX:=axf

# Assembly opcodes type
TC_ASMTYPE:=arm
TC_ASMEXT:=s

TC_TARGETTHUMB:=-mthumb
TC_TARGETARM:=-marm

# Assembly compiler options
TC_ASMOPTS:=\
  --target=arm-arm-none-eabi        \
  -masm=auto                        \
  -c                                \
  -gdwarf-4
  
# Assembly compiler defines
TC_ASMDEFS:=

# debug: why c opts -xc -std=c11 could not work with -xc++ -std=c++11???
# C compiler options
TC_COPTS:=\
  --target=arm-arm-none-eabi        \
  -xc                               \
  -std=c11                          \
  -gdwarf-4                         \
  -O1                               \
  -c                                \
  -fno-rtti                         \
  -funsigned-char -fshort-enums -fshort-wchar -ffunction-sections \
  -Wno-packed -Wno-missing-variable-declarations -Wno-missing-prototypes \
  -Wno-missing-noreturn -Wno-nonportable-include-path -Wno-sign-conversion \
  -Wno-reserved-id-macro -Wno-unused-macros -Wno-documentation-unknown-command \
  -Wno-documentation -Wno-license-management \
  -Wno-parentheses-equality -Wno-reserved-identifier \
  -Wno-empty-body \
  -Wno-macro-redefined \
  -Wno-invalid-source-encoding \
  -Wno-writable-strings

TC_CPPOPTS:=\
  --target=arm-arm-none-eabi        \
  -xc++                             \
  -std=c++11                        \
  -gdwarf-4                         \
  -O1                               \
  -c                                \
  -fno-rtti                         \
  -funsigned-char -fshort-enums -fshort-wchar -ffunction-sections \
  -Wno-packed -Wno-missing-variable-declarations -Wno-missing-prototypes \
  -Wno-missing-noreturn -Wno-nonportable-include-path -Wno-sign-conversion \
  -Wno-reserved-id-macro -Wno-unused-macros -Wno-documentation-unknown-command \
  -Wno-documentation -Wno-license-management \
  -Wno-parentheses-equality -Wno-reserved-identifier \
  -Wno-empty-body \
  -Wno-macro-redefined \
  -Wno-invalid-source-encoding \
  -Wno-writable-strings

# C compiler defines
TC_CDEFS:=

# Linker options
TC_LIBOPTS:=\
  --libpath=$(call MK_PATHTOUNX,${TC_PATH_LIB}) \
  --strict                                \
  --summary_stderr                        \
  --map                                   \
  --xref                                  \
  --callgraph                             \
  --symbols                               \
  --info=summarysizes                     \
  --info=sizes                            \
  --info=totals                           \
  --info=unused                           \
  --info=veneers                          \
  --info=stack                            \
  --diag_style=gnu                        \
  --diag_suppress=6314,9931               \
  --verbose                               \
  --load_addr_map_info

# Scatter file extension
TC_SCFEXT:=sct

#
# toolchain macros
#

# convert PATH to toolchain friendly path
ifneq ($(OS),Linux)
MK_TC_PATH=$(call MK_PATHTOWIN,${1})
else
MK_TC_PATH=$(call MK_PATHTOUNX,${1})
endif

# command to generate list of linker directory search paths
MK_TC_LIBDIRS=$(if ${1},--userlibpath $(call MK_SPCTOCOM,${1}))

# command to generate list of linker directory search paths
MK_TC_LIBS=$(if ${1},$(addsuffix .${TC_LIBEXT},${1}))

# command to generate scatter file
# 1 - template file
# 2 - output file
# 3 (opt) - armcc options
MK_TC_GENSCF=$(if $(and ${1},${2},${3}),@${TC_GENSCF} -E ${1} -o ${2} ${3})

# command to generate binary file
# 1 - input file
# 2 - output file
MK_TC_GENBIN=$(if $(and ${1},${2}),@${TC_GENBIN} -c --bin -o ${2} ${1})

# command to disassembly output file
# 1 - input file
# 2 - output file
MK_TC_DISASSEMBLY=$(if $(and ${1},${2}), @${TC_DUMP} -c -a ${1} -o ${2})
