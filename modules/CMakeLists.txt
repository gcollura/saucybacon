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

# copy qmldir file into build directory for shadow builds
file(COPY "${CMAKE_CURRENT_SOURCE_DIR}/SaucyBacon/qmldir"
    DESTINATION ${CMAKE_CURRENT_BINARY_DIR}
)

## Generate the plugins.qmltypes file, so it's easier to comunicate with QtCreator
add_custom_command(
    TARGET ${LIB}
    POST_BUILD
    COMMAND "rm" "-f" "plugins.qmltypes" ";" "qmlplugindump" "SaucyBacon" "0.1" "${CMAKE_SOURCE_DIR}/modules" ">" "plugins.qmltypes"
    WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
)

## Copy the .so to the modules/ path, so it's easier to test the app locally, without installation
add_custom_command(
    TARGET ${LIB}
    POST_BUILD
    COMMAND "cp" "${CMAKE_CURRENT_BINARY_DIR}/lib${LIB}.so" "${CMAKE_SOURCE_DIR}/modules/SaucyBacon/"
    "&&" "cp" "${CMAKE_CURRENT_BINARY_DIR}/plugins.qmltypes" "${CMAKE_SOURCE_DIR}/modules/SaucyBacon/"
    WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
)
