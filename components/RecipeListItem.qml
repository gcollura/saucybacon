import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem

ListItem.Subtitled {
    id: item
    progression: true

    text: contents.name
    subText: i18n.tr("%1".arg(contents.totaltime))
    icon: contents.photos[0] ? Qt.resolvedUrl(contents.photos[0]) : Qt.resolvedUrl("../graphics/toolbarIcon@8.png")

    Row {
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
        }
        spacing: units.gu(1)

        Label {
            anchors.verticalCenter: parent.verticalCenter
            text: restrictions[contents.restriction]
            font.pixelSize: units.gu(1.5)
            color: Theme.palette.normal.backgroundText
        }

        Label {
            anchors.verticalCenter: parent.verticalCenter
            text: Array(contents.difficulty + 1).join("\u1620")
            font.pixelSize: units.gu(2)
        }

    }

    onClicked: {
        recipePage.recipe.docId = docId;
        pageStack.push(recipePage);
    }
}
