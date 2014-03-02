file(GLOB_RECURSE QML_JS_FILES *.qml *.js)

# make the files visible on qtcreator
add_custom_target(saucybacon_QmlFiles ALL SOURCES ${QML_JS_FILES})

if(CLICK_MODE)
    install(FILES saucybacon.qml DESTINATION ${DATA_DIR}/app)
    install(DIRECTORY components DESTINATION ${DATA_DIR}/app)
    install(DIRECTORY ui DESTINATION ${DATA_DIR}/app)
    install(DIRECTORY backend DESTINATION ${DATA_DIR}/app)    
else(CLICK_MODE)
    install(FILES saucybacon.qml DESTINATION ${SAUCYBACON_DIR}/app)
    install(DIRECTORY components DESTINATION ${SAUCYBACON_DIR}/app)
    install(DIRECTORY ui DESTINATION ${SAUCYBACON_DIR}/app)
    install(DIRECTORY backend DESTINATION ${SAUCYBACON_DIR}/app)    
endif(CLICK_MODE)
