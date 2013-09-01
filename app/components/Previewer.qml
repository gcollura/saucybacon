import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1

PopupBase {
    id: previewer

    default property alias contents: contentsItem.data
    property Item caller

    __foreground: foreground
    __eventGrabber.enabled: true
    __dimBackground: true
    fadingAnimation: UbuntuNumberAnimation { duration: UbuntuAnimation.SnapDuration }

    Rectangle {
        id: foreground

        property int margins: units.gu(2)
        anchors.centerIn: parent

        Item {
            id: contentsItem
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: foreground.margins
            }
        }
    }

}
