set(LIB SaucyBaconPlugin)

set(SRCS
    SaucyBacon/Backend.cpp
    SaucyBacon/Utils.cpp
)

set(HDRS
    SaucyBacon/Backend.h
    SaucyBacon/Utils.h
)

add_library(${LIB} SHARED ${SRCS})

include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${Qt5Network_INCLUDE_DIRS}
    ${Qt5Quick_INCLUDE_DIRS}
)

target_link_libraries(${LIB}
    ${Qt5Network_LIBRARIES}
    ${Qt5Quick_LIBRARIES}
)

add_custom_command(
    TARGET ${LIB}
    POST_BUILD
    COMMAND "cp" "${CMAKE_CURRENT_BINARY_DIR}/lib${LIB}.so" "${CMAKE_SOURCE_DIR}/modules/SaucyBacon/"
    WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
)
