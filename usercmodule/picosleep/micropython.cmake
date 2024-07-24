# Create an INTERFACE library for our C module.
add_library(usermod_picosleep INTERFACE)

include_directories(${CMAKE_CURRENT_LIST_DIR}/../../../lib/pico-extras/src/rp2_common/pico_sleep/include)
include_directories(${CMAKE_CURRENT_LIST_DIR}/../../../lib/pico-extras/src/rp2_common/hardware_rosc/include)

# Add our source files to the lib
target_sources(usermod_picosleep INTERFACE
    ${CMAKE_CURRENT_LIST_DIR}/../../../lib/pico-extras/src/rp2_common/pico_sleep/sleep.c
    ${CMAKE_CURRENT_LIST_DIR}/../../../lib/pico-extras/src/rp2_common/hardware_rosc/rosc.c
    ${CMAKE_CURRENT_LIST_DIR}/picosleep.c
)

# Add the current directory as an include directory.
target_include_directories(usermod_picosleep INTERFACE
    ${CMAKE_CURRENT_LIST_DIR}
)

# Link our INTERFACE library to the usermod target.
target_link_libraries(usermod INTERFACE usermod_picosleep)
