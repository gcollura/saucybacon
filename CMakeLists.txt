project(saucybacon)
cmake_minimum_required(VERSION 2.8.10)

# Instruct CMake to run moc automatically when needed.
set(CMAKE_AUTOMOC ON)
# Find includes in corresponding build directories
set(CMAKE_INCLUDE_CURRENT_DIR ON)

# Find the QtWidgets library
find_package(Qt5Core            REQUIRED)
find_package(Qt5PrintSupport    REQUIRED)
find_package(Qt5Network         REQUIRED)
find_package(Qt5Quick           REQUIRED)

add_definitions(-DWITHQT5=1)

# build flags
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

get_target_property(QMAKE_EXECUTABLE Qt5::qmake LOCATION)
exec_program(${QMAKE_EXECUTABLE} ARGS "-query QT_INSTALL_QML" OUTPUT_VARIABLE QT_IMPORTS_DIR)
file(TO_CMAKE_PATH "${QT_IMPORTS_DIR}" QT_IMPORTS_DIR)

add_subdirectory(modules)
add_subdirectory(app)
add_subdirectory(graphics)
# TODO: add subdirectories

# TODO: add translations


install(FILES saucybacon.desktop DESTINATION ${CMAKE_INSTALL_PREFIX}/share/applications)
