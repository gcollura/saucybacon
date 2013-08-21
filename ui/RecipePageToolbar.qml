import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1

ToolbarItems {

    ToolbarButton {
        text: i18n.tr("Favorite")
        iconSource: recipe.favorite ? icon("favorite-selected") : icon("favorite-unselected")

        onTriggered: {
            recipe.favorite = !recipe.favorite;
            recipe.save();
        }
    }

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
            editRecipePage.recipe = recipe;
            pageStack.push(editRecipePage)
        }
    }

    ToolbarButton {
        text: i18n.tr("Delete")
        iconSource: icon("delete")

        onTriggered: PopupUtils.open(Qt.resolvedUrl("DeleteDialog.qml"))
    }

}
