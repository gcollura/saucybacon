import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1
import "../components"

Page {
    title: i18n.tr("Recipes")

    tools: RecipeListPageToolbar {
        objectName: "recipesTabToolbar"
    }

    ListView {
        objectName: "recipesListView"
        id: listView

        anchors.fill: parent

        model: db

        /* A delegate will be created for each Document retrieved from the Database */
        delegate: RecipeItem {
        }
    }

    Scrollbar {
        flickableItem: listView
        align: Qt.AlignTrailing
    }
}
