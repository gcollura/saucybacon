set(LIB SaucyBaconPlugin)

set(HDRS
    SaucyBacon/Plugin.h
    SaucyBacon/Utils.h
    SaucyBacon/ApiKeys.h
    SaucyBacon/RecipeSearch.h
    SaucyBacon/RecipeParser.h
)

set(SRCS
    SaucyBacon/Plugin.cpp
    SaucyBacon/Utils.cpp
    SaucyBacon/ApiKeys.cpp
    SaucyBacon/RecipeSearch.cpp
    SaucyBacon/RecipeParser.cpp
)

add_library(${LIB} SHARED ${SRCS})

include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${Qt5Network_INCLUDE_DIRS}
    ${Qt5Quick_INCLUDE_DIRS}
    ${Qt5PrintSupport_INCLUDE_DIRS}
    ${Qt5Script_INCLUDE_DIRS}
)

target_link_libraries(${LIB}
    ${Qt5Core_LIBRARIES}
    ${Qt5Network_LIBRARIES}
    ${Qt5Quick_LIBRARIES}
    ${Qt5PrintSupport_LIBRARIES}
    ${Qt5Script_LIBRARIES}
)

# copy qmldir file into build directory for shadow builds
file(COPY "${CMAKE_CURRENT_SOURCE_DIR}/SaucyBacon/qmldir"
    DESTINATION ${CMAKE_CURRENT_BINARY_DIR}
)

## Copy the .so to the modules/ path, so it's easier to test the app locally, without installation
add_custom_command(
    TARGET ${LIB}
    POST_BUILD
    COMMAND "cp" "${CMAKE_CURRENT_BINARY_DIR}/lib${LIB}.so" "${CMAKE_SOURCE_DIR}/modules/SaucyBacon/"
    WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
)

## Generate the plugins.qmltypes file, so it's easier to comunicate with QtCreator
add_custom_command(
    TARGET ${LIB}
    POST_BUILD
    COMMAND "rm" "-f" "plugins.qmltypes" ";" "qmlplugindump" "SaucyBacon" "0.1" "${CMAKE_SOURCE_DIR}/modules" ">" "plugins.qmltypes"
    "&&" "cp" "${CMAKE_CURRENT_BINARY_DIR}/plugins.qmltypes" "${CMAKE_SOURCE_DIR}/modules/SaucyBacon/"
    WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
)

install(TARGETS ${LIB} DESTINATION ${QT_IMPORTS_DIR}/SaucyBacon)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/qmldir ${CMAKE_CURRENT_BINARY_DIR}/plugins.qmltypes
        DESTINATION ${QT_IMPORTS_DIR}/SaucyBacon
)
