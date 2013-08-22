set(LIB SaucyBaconPlugin)

get_target_property(QMAKE_EXECUTABLE Qt5::qmake LOCATION)
# See http://doc-snapshot.qt-project.org/5.0/qtcore/qlibraryinfo.html#LibraryLocation-enum
# exec_program(${QMAKE_EXECUTABLE} ARGS "-query QT_INSTALL_QML" OUTPUT_VARIABLE QT_IMPORTS_DIR)
exec_program(${QMAKE_EXECUTABLE} ARGS "-query QT_INSTALL_QML" OUTPUT_VARIABLE QT_IMPORTS_DIR)
file(TO_CMAKE_PATH "${QT_IMPORTS_DIR}" QT_IMPORTS_DIR)

set(SRCS
    SaucyBacon/backend.cpp
    SaucyBacon/mytype.cpp
)

set(HDRS
    SaucyBacon/backend.h
    SaucyBacon/mytype.h
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

#add_custom_command(
#    TARGET ${LIB}
#    POST_BUILD
#    COMMAND "qmlplugindump" "SaucyBacon" "1.0" "${CMAKE_BINARY_DIR}/modules" ">" "plugins.qmltypes"
#    WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
#)
