import QtQuick 2.0
import Ubuntu.Components 0.1

Item {
    id: root

    property alias source: image.source
    property alias text: label.text

    width: childrenRect.width
    height: childrenRect.height

    Column {
        spacing: units.gu(2)

        Image {
            id: image
            anchors.horizontalCenter: parent.horizontalCenter
            smooth: true
            sourceSize.height: units.gu(6)
        }

        Label {
            id: label
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
