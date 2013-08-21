import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1
import Ubuntu.Components.ListItems 0.1

Item {
    id: item

    property alias text: button.text
    property int index
    property var model

    property Item action

    Button {
        id: button

        anchors.fill: parent
        width: parent.width
        height: parent.height

        onClicked: PopupUtils.open(popover, item)
    }

    onIndexChanged: text = model[index]

    Component {
        id: popover
        Popover {
            id: root
            property Item action

            onCallerChanged: {
                action = caller.action ? caller.action : null
                if (action)
                    action.parent = column
            }

            Column {
                id: column
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }

                Repeater {
                    id: popoverRepetear
                    model: caller ? caller.model : 0

                    Standard {
                        Label {
                            id: label
                            // FIXME: Hack because of Suru theme!
                            anchors {
                                verticalCenter: parent.verticalCenter
                                left: parent.left
                                margins: units.gu(2)
                            }
                            text: modelData !== "" ? modelData : i18n.tr("Uncategorized")

                            color: Theme.palette.normal.overlayText
                        }

                        onClicked: {
                            caller.text = label.text;
                            root.hide();
                        }
                    }
                }
                ThinDivider { visible: action && action.visible }

                function hide() {
                    // Provide a hide() method accessible from the children
                    root.hide();
                }
            }
        }
    }
}

