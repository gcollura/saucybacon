project(saucybacon C CXX)
cmake_minimum_required(VERSION 2.8.9)

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
set(UBUNTU_PROJECT_TYPE "ClickApp" CACHE INTERNAL "Tells QtCreator this is a Click app project")

find_package(Qt5Core)
find_package(Qt5Qml)
find_package(Qt5Quick)
find_package(Qt5Sql)
#find_package(ubuntu-sdk-libs)

set(CMAKE_AUTOMOC ON)

# Standard install paths
include(GNUInstallDirs)

# components PATH
execute_process(
    COMMAND dpkg-architecture -qDEB_HOST_MULTIARCH
    OUTPUT_VARIABLE ARCH_TRIPLET
    OUTPUT_STRIP_TRAILING_WHITESPACE
)
set(QT_IMPORTS_DIR "lib/${ARCH_TRIPLET}")

option(INSTALL_TESTS "Install the tests on make install" off)

set(APP_NAME                saucybacon)
set(FULL_APP_NAME           "SaucyBacon")
set(SAUCYBACON_DIR          "share/qml/${APP_NAME}")
set(MAIN_QML                "saucybacon.qml")
set(ICON                    "icons/SaucyBacon_icon.png")

# set install paths
set(CMAKE_INSTALL_PREFIX /)
set(DATA_DIR /)
set(DESKTOP_DIR ${DATA_DIR})
set(DESKTOP_FILE "${CMAKE_PROJECT_NAME}.desktop")

set(EXEC "qmlscene ${SAUCYBACON_DIR}/${MAIN_QML}")

install(FILES manifest.json DESTINATION ${CMAKE_INSTALL_PREFIX})
install(DIRECTORY "resources/icons" DESTINATION ${DATA_DIR})
install(FILES "saucybacon.apparmor" DESTINATION ${DATA_DIR})

add_subdirectory(app)
add_subdirectory(backend)
add_subdirectory(resources)
#add_subdirectory(po)

add_custom_target("autopilot" chmod +x ${CMAKE_SOURCE_DIR}/app/tests/autopilot/run
    COMMAND ${CMAKE_SOURCE_DIR}/app/tests/autopilot/run
    DEPENDS  SaucyBaconPlugin-qmldir
    WORKING_DIRECTORY ./app)

add_custom_target("check" /usr/bin/qmltestrunner -input ${CMAKE_SOURCE_DIR}/app/tests/unit -import ${CMAKE_BINARY_DIR}/backend
    DEPENDS SaucyBaconPlugin SaucyBaconPlugin-qmldir
    WORKING_DIRECTORY ./app)

add_custom_target("run" APP_ID=com.developer.gcollura.saucybacon_saucybacon_2.0.0 /usr/bin/qmlscene -I ${CMAKE_BINARY_DIR}/backend ${CMAKE_SOURCE_DIR}/app/saucybacon.qml
    DEPENDS SaucyBaconPlugin SaucyBaconPlugin-qmldir
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})

add_custom_target("debug" gdb --args qmlscene -I ${CMAKE_BINARY_DIR}/backend ${CMAKE_SOURCE_DIR}/app/saucybacon.qml
    DEPENDS SaucyBaconPlugin SaucyBaconPlugin-qmldir
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})

add_custom_target("profile" qmlprofiler qmlscene -I ${CMAKE_BINARY_DIR}/backend ${CMAKE_SOURCE_DIR}/app/saucybacon.qml
    DEPENDS SaucyBaconPlugin SaucyBaconPlugin-qmldir
    WORKING_DIRECTORY ./app)
