file(GLOB UI_DIALOGS_QML_JS_FILES *.qml *.js)

# make the files visible in the qtcreator tree
add_custom_target(saucybacon_ui_dialogs_QmlFiles ALL SOURCES ${UI_DIALOGS_QML_JS_FILES})

install(FILES ${UI_DIALOGS_QML_JS_FILES} DESTINATION ${SAUCYBACON_DIR}/ui/dialogs)

