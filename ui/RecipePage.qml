import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem

Page {
    title: i18n.tr("")

    property var recipeId
    property string name
    property alias directions: directionsLabel.text
    property alias ingredients: ingredientsList.model
    property string preptime
    property string cooktime
    property string totaltime
    property string difficulty

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
            id: totaltimeLabel
            text: i18n.tr("<b>%1</b> \t (Prep: %2 mins, Cook: %3 mins)".arg(totaltime).arg(preptime).arg(cooktime))
        }

        Label {
            id: difficultyLabel
            text: i18n.tr("Difficulty: %1".arg(difficulty))
        }

        ListItem.ThinDivider {

        }

        Label {
            text: i18n.tr("Ingredients")
            fontSize: "large"
            font.bold: true
        }

        Column {
            width: parent.width

            Repeater {
                id: ingredientsList
                width: parent.width
                model: 0

                delegate: Label {
                    text: "%1 %2 %3".arg(ingredientsList.model[index].quantity)
                    .arg(ingredientsList.model[index].type).arg(ingredientsList.model[index].name)
                }
            }
        }

        ListItem.ThinDivider {}

        Label {
            text: i18n.tr("Directions")

            fontSize: "large"
            font.bold: true
        }

        Label {
            id: directionsLabel
            width: parent.width

            wrapMode: Text.Wrap
        }
    }

    function setRecipe(id) {
        var recipe = db.getDoc(id);

        if (recipe) {
            name = recipe.title;
            directions = recipe.directions;
            ingredients = recipe.ingredients;
            preptime = recipe.preptime;
            cooktime = recipe.cooktime;
            totaltime = recipe.totaltime;
            difficulty = recipe.difficulty;

            recipeId = id;
            title = truncate(name);
        } else {
            console.log("Error while opening recipe with id: %1".arg(id));
        }
    }

    function deleteRecipe(id) {
        var recipe = db.putDoc("", id);

        console.log("FIXME: Delete this entry please!");
    }

    function truncate(name) {
        if (name.length > parent.width / units.gu(2)) {
            name = name.substring(0, parent.width / units.gu(2.1));
            name += "...";
        }
        return name;
    }

    onWidthChanged: {
        title = truncate(name);
    }
}
