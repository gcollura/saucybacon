# Make the qml file show in the QtCreator tree

file(GLOB_RECURSE Qml *.qml)

add_custom_target(QmlFiles ALL SOURCES ${Qml})
