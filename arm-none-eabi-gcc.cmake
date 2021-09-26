set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR ARM)

if(MINGW OR CYGWIN OR WIN32)
    set(UTIL_SEARCH_CMD where)
elseif(UNIX OR APPLE)
    set(UTIL_SEARCH_CMD which)
endif()

set(TOOLCHAIN_PREFIX arm-none-eabi-)

execute_process(
  COMMAND ${UTIL_SEARCH_CMD} ${TOOLCHAIN_PREFIX}gcc
  OUTPUT_VARIABLE BINUTILS_PATH
  OUTPUT_STRIP_TRAILING_WHITESPACE
)

get_filename_component(ARM_TOOLCHAIN_DIR ${BINUTILS_PATH} DIRECTORY)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(FLOAT_ABI "hard" CACHE STRING "Specifies which floating-point ABI to use")
set_property(CACHE FLOAT_ABI PROPERTY STRINGS soft softfp hard)

set(FLOAT_FLAGS "-mfloat-abi=${FLOAT_ABI}")
if(FLOAT_ABI STREQUAL "hard")
	set(FLOAT_FLAGS ${FLOAT_FLAGS} -mfpu=fpv4-sp-d16)
else()
	set(FLOAT_FLAGS -msoft-float)
endif()

set(CMAKE_C_COMPILER ${TOOLCHAIN_PREFIX}gcc)
set(CMAKE_ASM_COMPILER ${CMAKE_C_COMPILER})
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_PREFIX}g++)

set(arm_compile_link_options
    -mcpu=cortex-m4
    -mthumb
    -mthumb-interwork
    -mlittle-endian
    -fsingle-precision-constant
    -Wdouble-promotion
    ${FLOAT_FLAGS}
    -specs=nosys.specs
    -fno-exceptions
)

add_compile_options(${arm_compile_link_options})

string(REPLACE ";" " " CMAKE_C_LINK_FLAGS "${arm_compile_link_options}")
string(REPLACE ";" " " CMAKE_CXX_LINK_FLAGS "${arm_compile_link_options}")

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_LIST_DIR})

set(CMAKE_OBJCOPY ${ARM_TOOLCHAIN_DIR}/${TOOLCHAIN_PREFIX}objcopy CACHE INTERNAL "objcopy tool")
set(CMAKE_SIZE_UTIL ${ARM_TOOLCHAIN_DIR}/${TOOLCHAIN_PREFIX}size CACHE INTERNAL "size tool")

set(CMAKE_FIND_ROOT_PATH ${BINUTILS_PATH})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
