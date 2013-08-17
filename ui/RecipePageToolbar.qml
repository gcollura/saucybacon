import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1

ToolbarItems {

    ToolbarButton {
        text: i18n.tr("Share")
        iconSource: icon("share")

        onTriggered: {

        }
    }

    ToolbarButton {
        text: i18n.tr("Edit")
        iconSource: icon("edit")

        onTriggered: {
            pageStack.push(newRecipePage)
            newRecipePage.loadRecipe(recipeId);
        }
    }

    ToolbarButton {
        text: i18n.tr("Delete")
        iconSource: icon("delete")

        onTriggered: PopupUtils.open(deletionDialog)
    }

    DeleteDialog {
        id: deletionDialog
    }

}
