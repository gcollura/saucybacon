import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1

Page {
    title: i18n.tr("")

    property var recipeId

    tools: RecipePageToolbar {
        objectName: "recipePageToolbar"
    }

    // Delete dialog
    Component {
        id: deletionDialog
        Dialog {
            id: deletionDialogue
            title: i18n.tr("Confirm deletion")
            text: i18n.tr("Are you sure you want to delete this recipe?")
            Button {
                text: i18n.tr("Delete")
                onClicked: {
                    deleteRecipe(recipeId);
                    PopupUtils.close(deletionDialogue);
                    pageStack.push(recipeListPage);
                }
            }
            Button {
                text: i18n.tr("Cancel")
                gradient: UbuntuColors.greyGradient
                onClicked: PopupUtils.close(deletionDialogue)
            }
        }
    }

    function setRecipe(id) {
        var recipe = db.getDoc(id);

        if (recipe) {
            title = recipe.title;
            recipeId = id;
        }
    }

    function deleteRecipe(id) {
        var recipe = db.getDoc(id);

        newRecipe.docId = id;

        console.log("FIXME: Delete this entry please!");
    }
}
