import QtQuick 2.0
import Ubuntu.Components 0.1

Item {
    id: root

    property alias source: image.source
    property alias text: label.text

    height: units.gu(12)
    width: label.width > image.width ? label.width : image.width

    Image {
        id: image
        anchors.horizontalCenter: parent.horizontalCenter
        sourceSize.height: units.gu(6)
    }

    Label {
        id: label
        anchors {
            top: image.bottom
            margins: units.gu(2)
            horizontalCenter: parent.horizontalCenter
        }
    }
}
