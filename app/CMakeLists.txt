file(GLOB_RECURSE QML {CMAKE_CURRENT_SOURCE_DIR} *.qml)

# Make the qml files show in the QtCreator tree
add_custom_target(QmlFiles SOURCES ${QML})

install(FILES ${QML} DESTINATION ${CMAKE_INSTALL_PREFIX}/share/saucybacon/app)
