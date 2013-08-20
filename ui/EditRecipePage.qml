import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1
import Ubuntu.Components.ListItems 0.1
import U1db 1.0 as U1db

import "../components"

Page {
    title: recipe.exists() ? i18n.tr("Edit recipe") : i18n.tr("New recipe")

    property var recipe: Recipe { }

    tools: ToolbarItems {
        ToolbarButton {
            iconSource: icon('save')
            text: i18n.tr("Save")

            onTriggered: {
                saveRecipe();
            }
        }
    }

    Flickable {
        id: flickable

        anchors.fill: parent
        anchors.topMargin: units.gu(2)
        anchors.bottomMargin: units.gu(2)

        contentHeight: newRecipeColumn.height
        interactive: contentHeight > height

        Column {
            id: newRecipeColumn

            width: parent.width
            spacing: units.gu(2)
            anchors {
                left: parent.left
                right: parent.right
                margins: units.gu(2)
            }

            TextField {
                id: recipeName
                width: parent.width

                text: recipe.name
                placeholderText: i18n.tr("Enter a name for your recipe")

                onFocusChanged: {
                    // FIXME
                    focus ? __styleInstance.color = Theme.palette.normal.overlayText : __styleInstance.color = "white"
                }
            }

            Row {
                width: parent.width
                spacing: units.gu(1)

                Selector {
                    id: recipeCategory
                    width: parent.width / 2 - units.gu(.5)
                    height: units.gu(4)

                    text: recipe.category.length > 0 ? recipe.category : i18n.tr("Select category")

                    model: categories
                }

                Selector {
                    id: recipeDifficulty
                    width: parent.width / 2 - units.gu(.5)
                    height: units.gu(4)

                    text: recipe.difficulty >= 0 ? difficulties[recipe.difficulty] : i18n.tr("Select difficulty")

                    model: difficulties
                }
            }

            Row {
                width: parent.width
                spacing: units.gu(1)

                Label {
                    id: totalTime
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width / 2 - units.gu(2)
                    text: i18n.tr("Total time: %1 minutes").arg(computeTotalTime(prepTime.text, cookTime.text))
                }

                TextField {
                    id: prepTime
                    width: parent.width / 4
                    placeholderText: i18n.tr("Prep time")
                    inputMethodHints: Qt.ImhPreferNumbers

                    text: recipe.preptime
                }

                TextField {
                    id: cookTime
                    width: parent.width / 4
                    placeholderText: i18n.tr("Cook time")
                    inputMethodHints: Qt.ImhPreferNumbers

                    text: recipe.cooktime
                }

            }

            Row {
                width: parent.width
                Label {
                    width: text.length * units.gu(2)
                    text: i18n.tr("Ingredients")
                }
//                Slider {
//                    height: units.gu(4)
//                    value: 4
//                    minimumValue: 1
//                    maximumValue: 10
//                    live: true
//                }
            }

            IngredientLayout {
                id: ingredientsLayout
                width: parent.width

                ingredients: recipe.ingredients
            }

            Button {
                width: parent.width
                height: units.gu(4)
                text: i18n.tr("Add new ingredient")

                onClicked: ingredientsLayout.addIngredient(true)
            }

            TextArea {
                id: recipeDirections
                width: parent.width
                text: recipe.directions

                placeholderText: i18n.tr("Write your directions")
                maximumLineCount: 0
                autoSize: true
            }

            PhotoLayout {
                id: photoLayout
                photos: recipe.photos
            }

        }

    }

    function computeTotalTime(time1, time2) {
        var t1 = parseInt(time1);
        var t2 = parseInt(time2);

        var total = t1 + t2;
        if (!total)
            total = 0;

        return total.toString();
    }

    function saveRecipe() {

        recipe.name = recipeName.text ? recipeName.text : i18n.tr("Misterious Recipe");
        recipe.directions = recipeDirections.text;
        recipe.preptime = prepTime.text;
        recipe.cooktime = cookTime.text;
        recipe.totaltime = totalTime.text;
        recipe.category = recipeCategory.text;
        recipe.difficulty = difficulties.indexOf(recipeDifficulty.text);

        recipe.ingredients = ingredientsLayout.getIngredients();
        recipe.photos = photoLayout.photos;

        recipe.save();
        pageStack.push(recipeListPage);

    }


}

