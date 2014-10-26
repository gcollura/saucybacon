import QtQuick 2.3
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem

ListItem.Empty {
    id: item
    __height: units.gu(5)

    property alias text: nameLabel.text
    readonly property ListView listView: ListView.view

    removable: true
    confirmRemoval: true

    Label {
        id: nameLabel
        anchors {
            left: parent.left
            leftMargin: units.gu(2)
            verticalCenter: parent.verticalCenter
        }
    }

    Component.onCompleted: {
        height = listView.itemHeight = childrenRect.height;
    }
}
