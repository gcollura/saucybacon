if(CLICK_MODE)
    set(EXEC "qmlscene $@ -I ${SAUCYBACONPLUGIN_DIR} ${SAUCYBACON_DIR}/${MAIN_QML}")
    set(DESKTOP_DIR ${DATA_DIR})
    set(ICON "${ICON}")
    install(FILES manifest.json DESTINATION ${DATA_DIR})
    install(DIRECTORY "resources/images" DESTINATION ${DATA_DIR}/resources)
    install(FILES ${ICON} DESTINATION ${DATA_DIR}/resources/icons)
    install(FILES "${CMAKE_PROJECT_NAME}.json" DESTINATION ${DATA_DIR})
else(CLICK_MODE)
    set(DATA_DIR ${CMAKE_INSTALL_DATADIR}/${APP_NAME})
    set(EXEC "qmlscene $@ ${CMAKE_INSTALL_PREFIX}/${DATA_DIR}/app/${MAIN_QML}")
    set(ICON "${CMAKE_INSTALL_PREFIX}/${DATA_DIR}/${ICON}")
    set(DESKTOP_DIR ${CMAKE_INSTALL_DATADIR}/applications)
endif(CLICK_MODE)