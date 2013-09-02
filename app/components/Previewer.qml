import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1

PopupBase {
    id: previewer

    default property alias contents: containerItem.data
    property Item caller

    /*!
      \qmlproperty real contentWidth
      \qmlproperty real contentHeight
      The properties can be used to alter the default content width and heights.
      */
    property alias contentWidth: foreground.width
    /*! \internal */
    property alias contentHeight: foreground.height

    property bool autoClose: true

    __foreground: foreground
    __eventGrabber.enabled: true
    __dimBackground: true
    fadingAnimation: UbuntuNumberAnimation { duration: UbuntuAnimation.SnapDuration }

    Rectangle {
        id: foreground

        color: "transparent"

        anchors.centerIn: parent

        width: containerItem.width
        height: containerItem.height

        Item {
            id: containerItem

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                centerIn: parent
            }
            height: childrenRect.height
            width: childrenRect.width
        }
    }

}
