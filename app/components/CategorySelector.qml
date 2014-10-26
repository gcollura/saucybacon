import QtQuick 2.3
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem

OptionSelector {
    id: categorySelector

    property var selectedIndexes: []
    multiSelection: true
    containerHeight: itemHeight * 4

    property ListView listView: categorySelector.listView
}
