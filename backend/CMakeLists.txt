SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/modules/SaucyBacon
    ${CMAKE_CURRENT_BINARY_DIR}
)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/modules/SaucyBacon/configure.cmake.in
        ${CMAKE_CURRENT_BINARY_DIR}/configure.cmake.h)

set(SaucyBaconPlugin_SRCS
    #modules/SaucyBacon/Database.cpp
    modules/SaucyBacon/Plugin.cpp
    modules/SaucyBacon/ApiKeys.cpp
    modules/SaucyBacon/RecipeParser.cpp
    modules/SaucyBacon/RecipeSearch.cpp
    modules/SaucyBacon/Utils.cpp
)

add_library(SaucyBaconPlugin MODULE
    ${SaucyBaconPlugin_SRCS}
)

set_target_properties(SaucyBaconPlugin PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY SaucyBacon)

qt5_use_modules(SaucyBaconPlugin Gui Qml Quick Script)

# Copy qmldir file to build dir for running in QtCreator
add_custom_target(SaucyBaconPlugin-qmldir ALL
    COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/modules/SaucyBacon/qmldir ${CMAKE_CURRENT_BINARY_DIR}/SaucyBacon
    DEPENDS ${QMLFILES}
)

if(CLICK_MODE)
    install(TARGETS SaucyBaconPlugin DESTINATION
        ${DATA_DIR}/${SAUCYBACONPLUGIN_DIR}/SaucyBacon)
    install(FILES   modules/SaucyBacon/qmldir DESTINATION 
        ${DATA_DIR}/${SAUCYBACONPLUGIN_DIR}/SaucyBacon)
else(CLICK_MODE)
    # Install plugin file
    install(TARGETS SaucyBaconPlugin DESTINATION ${QT_IMPORTS_DIR}/SaucyBacon/)
    install(FILES   modules/SaucyBacon/qmldir DESTINATION ${QT_IMPORTS_DIR}/SaucyBacon/)
endif(CLICK_MODE)
