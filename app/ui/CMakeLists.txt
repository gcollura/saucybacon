file(GLOB UI_QML_JS_FILES *.qml *.js)

# make the files visible in the qtcreator tree
add_custom_target(saucybacon_ui_QmlFiles ALL SOURCES ${UI_QML_JS_FILES})

install(FILES ${UI_QML_JS_FILES} DESTINATION ${SAUCYBACON_DIR}/ui)

add_subdirectory(dialogs)
