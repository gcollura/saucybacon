project(saucybacon)
cmake_minimum_required(VERSION 2.8.9)

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

find_package(Qt5Core)
find_package(Qt5Qml)
find_package(Qt5Quick)
find_package(Qt5Script)
#find_package(ubuntu-sdk-libs)

set(CMAKE_AUTOMOC ON)

# Standard install paths
include(GNUInstallDirs)

# components PATH
if(NOT QT_IMPORTS_DIR)
    MESSAGE( STATUS "Query qmake for QT_IMPORTS_DIR" )
    execute_process(
        COMMAND qmake -query QT_INSTALL_QML
        OUTPUT_VARIABLE QT_IMPORTS_DIR
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
endif (NOT QT_IMPORTS_DIR)

option(INSTALL_TESTS "Install the tests on make install" off)
option(CLICK_MODE "Installs to a contained location" on)

if(CLICK_MODE)
    set(CMAKE_INSTALL_PREFIX .)
    set(DATA_DIR ${CMAKE_INSTALL_PREFIX}/clickpkg)
endif(CLICK_MODE)
set(APP_NAME                saucybacon)
set(SAUCYBACON_DIR          ${CMAKE_INSTALL_PREFIX}/app)
set(SAUCYBACONPLUGIN_DIR    backend)
set(MAIN_QML                "saucybacon.qml")
set(ICON                    "resources/icons/SaucyBacon_icon.png")
include(Click)

add_subdirectory(app)
add_subdirectory(backend)
add_subdirectory(resources)

add_custom_target("autopilot" chmod +x ${CMAKE_SOURCE_DIR}/app/tests/autopilot/run
    COMMAND ${CMAKE_SOURCE_DIR}/app/tests/autopilot/run
    DEPENDS  SaucyBaconPlugin-qmldir
    WORKING_DIRECTORY ./app)

add_custom_target("check" /usr/bin/qmltestrunner -input ${CMAKE_SOURCE_DIR}/app/tests/unit -import ${CMAKE_BINARY_DIR}/backend
    DEPENDS SaucyBaconPlugin SaucyBaconPlugin-qmldir
    WORKING_DIRECTORY ./app)

add_custom_target("run" /usr/bin/qmlscene -I ${CMAKE_BINARY_DIR}/backend ${CMAKE_SOURCE_DIR}/app/saucybacon.qml
    DEPENDS SaucyBaconPlugin SaucyBaconPlugin-qmldir
    WORKING_DIRECTORY ./app)

add_custom_target("click" click build ${DATA_DIR}
    DEPENDS SaucyBaconPlugin SaucyBaconPlugin-qmldir)
