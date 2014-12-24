import QtQuick 2.0
import Ubuntu.Components 1.1

Item {
    id: root

    property alias source: image.source
    property alias iconName: image.name
    property alias color: image.color
    property alias text: label.text

    width: childrenRect.width
    height: childrenRect.height

    Column {
        spacing: units.gu(2)

        Icon {
            id: image
            anchors.horizontalCenter: parent.horizontalCenter
            height: units.gu(6)
            width: units.gu(6)
            color: Qt.rgba(1, 1, 1, 1)
        }

        Label {
            id: label
            width: root.width
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            wrapMode: Text.WordWrap
        }
    }
}
