import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1

Page {
    title: i18n.tr("")

    property var recipeId
    property alias directions: directionsLabel.text
    property alias ingredients: ingredientsList.model

    tools: RecipePageToolbar {
        objectName: "recipePageToolbar"
    }

    Column {
        width: parent.width
        anchors{
            margins: units.gu(2)
            fill: parent
        }
        spacing: units.gu(2)

        Label {
            text: i18n.tr("Ingredients")
            fontSize: "large"
            font.bold: true
        }

        ListView {
            id: ingredientsList

            delegate: Label {
                text: ingredientsList.model[index].name
                height: units.gu(3)
            }
        }

        Label {
            text: i18n.tr("Directions")
            fontSize: "large"
            font.bold: true
        }

        Label {
            id: directionsLabel
            text: ""
        }
    }

    function setRecipe(id) {
        var recipe = db.getDoc(id);

        if (recipe) {
            title = recipe.title.length > 0 ? recipe.title : "Unnamed";
            directions = recipe.directions;
            ingredients = recipe.ingredients;
            console.log(JSON.stringify(recipe.ingredients))
            recipeId = id;
        }
    }

    function deleteRecipe(id) {
        var recipe = db.putDoc("", id);

        console.log("FIXME: Delete this entry please!");
    }
}
