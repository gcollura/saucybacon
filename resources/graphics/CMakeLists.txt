file(GLOB_RECURSE GRAPHICS {CMAKE_CURRENT_SOURCE_DIR} *.png *.jpg)

# Make the graphics files show in the QtCreator tree
add_custom_target(GraphicsFiles SOURCES ${GRAPHICS})

install(FILES ${GRAPHICS} DESTINATION ${CMAKE_INSTALL_PREFIX}/share/saucybacon/graphics)
