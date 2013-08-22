project(saucybacon)
cmake_minimum_required(VERSION 2.8.10)

# Instruct CMake to run moc automatically when needed.
set(CMAKE_AUTOMOC ON)
# Find includes in corresponding build directories
set(CMAKE_INCLUDE_CURRENT_DIR ON)

# Find the QtWidgets library
find_package(Qt5Core    REQUIRED)
find_package(Qt5Network REQUIRED)
find_package(Qt5Quick   REQUIRED)

add_definitions(-DWITHQT5=1)

# build flags
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

add_subdirectory(modules)
add_subdirectory(app)
# TODO: add subdirectories

# TODO: add translations
