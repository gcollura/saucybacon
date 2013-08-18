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

            model: [ i18n.tr("Easy"), i18n.tr("Medium"), i18n.tr("Hard") ]
            Standard {
                Label {
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        margins: units.gu(2)
                    }
                    text: popoverRepetear.model[index]
                    color: Theme.palette.normal.overlayText
                }

                // FIXME: Hack because of Suru theme!
                onClicked: {
                    caller.text = popoverRepetear.model[index];

                    hide();
                }
            }
        }
    }
}
