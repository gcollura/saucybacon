cmake_minimum_required(VERSION 2.8)

include(FindGettext)
find_program(GETTEXT_XGETTEXT_EXECUTABLE xgettext)
file(GLOB_RECURSE I18N_SRC_FILES
    RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_SOURCE_DIR}/*.qml
    ${CMAKE_SOURCE_DIR}/*.js
    ${CMAKE_SOURCE_DIR}/*.cpp
    ${CMAKE_SOURCE_DIR}/*.h
)

set(DOMAIN ${PROJECT_NAME})
set(POT_FILE ${APP_PACKAGE}.pot)
file(GLOB PO_FILES ${CMAKE_SOURCE_DIR}/po/*.po)

add_custom_target(${POT_FILE} ALL
    COMMENT "Generating translation template"
    COMMAND ${GETTEXT_XGETTEXT_EXECUTABLE} -o ${POT_FILE}
    -D ${CMAKE_CURRENT_SOURCE_DIR}
    -D ${CMAKE_CURRENT_BINARY_DIR}
    --from-code=UTF-8
    --c++ --qt --add-comments=TRANSLATORS
    --keyword=tr --keyword=tr:1,2
    --package-name='${APP_PACKAGE}'
    --package-version=${APP_VERSION}
    --copyright-holder='Giulio Collura.'
    ${I18N_SRC_FILES}
    COMMENT "Copying new pot template back to source tree"
    COMMAND ${CMAKE_COMMAND} COPY
    ${CMAKE_BINARY_DIR}/po/${POT_FILE}
    ${CMAKE_SOURCE_DIR}/po/
)

foreach(PO_FILE ${PO_FILES})
    get_filename_component(LANG ${PO_FILE} NAME_WE)
    gettext_process_po_files(${LANG} ALL PO_FILES ${PO_FILE})
    set(INSTALL_DIR ${CMAKE_INSTALL_LOCALEDIR}/${LANG}/LC_MESSAGES)
    install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${LANG}.gmo
            DESTINATION ${INSTALL_DIR}
            RENAME ${APP_PACKAGE}.mo)
endforeach(PO_FILE)
