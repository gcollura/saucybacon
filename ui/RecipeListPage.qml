import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1
import "../components"

Page {
    title: i18n.tr("Recipes")

    tools: RecipeListPageToolbar {
        objectName: "recipesTabToolbar"
    }

    Component {
        id: sectionDelegate
        Rectangle {
            width: parent.width
            height: units.gu(5)

            Text {
                text: section
            }
        }
    }

    ListView {
        objectName: "recipesListView"
        id: listView

        anchors.fill: parent

        model: db
        section.property: "contents.title"
        section.criteria: ViewSection.FullString
        section.delegate: sectionDelegate

        /* A delegate will be created for each Document retrieved from the Database */
        delegate: RecipeListItem {
        }
    }

    Scrollbar {
        flickableItem: listView
        align: Qt.AlignTrailing
    }
}
