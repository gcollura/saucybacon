# Configure .desktop launcher
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/saucybacon.desktop.cmake ${CMAKE_CURRENT_SOURCE_DIR}/saucybacon.desktop)

install(FILES saucybacon.desktop DESTINATION ${CMAKE_INSTALL_PREFIX}/share/applications)

file(GLOB_RECURSE GRAPHICS {CMAKE_CURRENT_SOURCE_DIR} *.png *.jpg *.svg)

# Make the graphics files show in the QtCreator tree
add_custom_target(GraphicsFiles SOURCES ${GRAPHICS})

install(DIRECTORY icons DESTINATION ${CMAKE_INSTALL_PREFIX}/share/saucybacon/resources)
install(DIRECTORY images DESTINATION ${CMAKE_INSTALL_PREFIX}/share/saucybacon/resources)
