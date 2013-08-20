import QtQuick 2.0
import Ubuntu.Components 0.1

ToolbarItems {
    ToolbarButton {
        iconSource: icon('search')
        text: i18n.tr("Search")

        onTriggered: {
            pageStack.push(searchPage);
        }
    }
    ToolbarButton {
        iconSource: icon('add')
        text: i18n.tr("New")

        onTriggered: {
            pageStack.push(editRecipePage);
            editRecipePage.recipe.docId = "";
        }
    }
}
