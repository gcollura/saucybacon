import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1
import Ubuntu.Components.ListItems 0.1

Popover {

    Column {
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        Repeater {
            id: popoverRepetear
            clip: true

            model: caller.model
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

                    hide();
                }
            }
        }
    }
}
