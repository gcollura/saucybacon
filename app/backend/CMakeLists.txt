file(GLOB BACKEND_QML_JS_FILES *.qml *.js)

# make the files visible in the qtcreator tree
add_custom_target(saucybacon_backend_QmlFiles ALL SOURCES ${BACKEND_QML_JS_FILES})

install(FILES ${BACKEND_QML_JS_FILES} DESTINATION ${SAUCYBACON_DIR}/backend)

