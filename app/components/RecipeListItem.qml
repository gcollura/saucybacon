import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem

ListItem.Subtitled {
    id: item
    progression: true

    icon: contents.photos[0] ? Qt.resolvedUrl(contents.photos[0]) : Qt.resolvedUrl("../graphics/toolbarIcon@8.png")

    Column {
        id: right
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
        }
        Label {
            text: truncate(contents.name, item.width, units.gu(1.5))
        }
        Label {
            text: i18n.tr("%1".arg(contents.totaltime))
            font.pixelSize: units.gu(1.5)
            color: Theme.palette.normal.backgroundText
        }
    }

    Row {
        id: left
        spacing: units.gu(2)
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
        }
        Label {
            anchors.verticalCenter: parent.verticalCenter
            text: restrictions[contents.restriction]
            font.pixelSize: units.gu(1.5)
            color: Theme.palette.normal.backgroundText
        }
        Column {
            anchors.verticalCenter: parent.verticalCenter
            width: units.gu(2)

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: Array(contents.difficulty + 1).join("\u1620")
            }

            Label {
                visible: contents.favorite
                anchors.horizontalCenter: parent.horizontalCenter
                text: "\u2605"
            }
        }
    }

    onClicked: {
        recipePage.recipe.docId = docId;
        pageStack.push(recipePage);
    }
}
