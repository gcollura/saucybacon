import QtQuick 2.3
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0

Standard {
    property alias count: countLabel.text

    Rectangle {
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
            margins: units.gu(4)
        }

        height: countLabel.height + units.gu(1)
        width: height
        color: colors.darkRed
        radius: units.gu(0.5)

        Label {
            id: countLabel
            anchors.centerIn: parent
            text: modelData.count
        }
    }
}
