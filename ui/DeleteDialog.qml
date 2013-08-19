import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1

// Delete dialog

Dialog {

    id: dialogue
    title: i18n.tr("Confirm deletion")
    text: i18n.tr("Are you sure you want to delete this recipe?")

    Button {
        text: i18n.tr("Cancel")

        gradient: UbuntuColors.greyGradient
        onClicked: PopupUtils.close(dialogue)
    }
    Button {
        text: i18n.tr("Delete")

        onClicked: {
            deleteRecipe(recipeId);
            PopupUtils.close(dialogue);
            pageStack.push(recipeListPage);
        }
    }
}
