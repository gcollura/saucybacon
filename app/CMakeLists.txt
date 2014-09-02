file(GLOB QML_JS_FILES *.qml *.js)

# make the files visible on qtcreator
add_custom_target(saucybacon_QmlFiles ALL SOURCES ${QML_JS_FILES})

install(FILES ${QML_JS_FILES} DESTINATION ${SAUCYBACON_DIR})
install(DIRECTORY "graphics/" DESTINATION ${SAUCYBACON_DIR}/graphics)

add_subdirectory(components)
add_subdirectory(ui)
add_subdirectory(backend)
