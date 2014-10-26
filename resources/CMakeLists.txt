#substitute variables in the desktop file
set(DESKTOP_FILE "${CMAKE_PROJECT_NAME}.desktop")
configure_file(${DESKTOP_FILE}.in ${CMAKE_CURRENT_BINARY_DIR}/${DESKTOP_FILE})

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${DESKTOP_FILE} DESTINATION ${DESKTOP_DIR})
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/dbschema.sql DESTINATION ${DATA_DIR}resources)
