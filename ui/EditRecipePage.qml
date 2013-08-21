import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1
import Ubuntu.Components.ListItems 0.1

import "../components"

Page {
    id: page

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
        interactive: contentHeight + units.gu(10) > height // hack due to ValueSelection at the end of the page

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
            }

            Row {
                width: parent.width
                spacing: units.gu(1)

                Selector {
                    id: recipeCategory
                    width: parent.width / 2 - units.gu(.5)
                    height: units.gu(4)

                    model: categories
                    action: Standard {
                        Label {
                            // FIXME: Hack because of Suru theme!
                            anchors {
                                verticalCenter: parent.verticalCenter
                                left: parent.left
                                margins: units.gu(2)
                            }
                            text: i18n.tr("New category...")
                            font.italic: true

                            color: Theme.palette.normal.overlayText
                        }
                        onClicked: { parent.hide(); PopupUtils.open(Qt.resolvedUrl("NewCategoryDialog.qml"), recipeCategory) }
                    }
                }

                Selector {
                    id: recipeDifficulty
                    width: parent.width / 2 - units.gu(.5)
                    height: units.gu(4)

                    index: recipe.difficulty

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

            ValueSelector {
                id: recipeRestriction
                width: parent.width
                text: i18n.tr("Restriction")
                values: restrictions
                selectedIndex: recipe.restriction
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
        recipe.category = recipeCategory.text;
        recipe.difficulty = difficulties.indexOf(recipeDifficulty.text);
        recipe.restriction = recipeRestriction.selectedIndex;

        recipe.preptime = prepTime.text;
        recipe.cooktime = cookTime.text;
        recipe.totaltime = totalTime.text;

        recipe.ingredients = ingredientsLayout.getIngredients();

        recipe.directions = recipeDirections.text;

        recipe.photos = photoLayout.photos;
        recipe.restriction = recipeRestriction.selectedIndex;

        recipe.save();
        pageStack.push(recipeListPage);

    }

    onVisibleChanged: {
        if (!visible)
            return;

        // WORKAROUND: Refresh some widgets that may forget they configuration
        // for example when they cleared using the clear button
        recipeName.text = recipe.name
        recipeCategory.text = recipe.category.length > 0 ? recipe.category : i18n.tr("Select category")
        recipeDifficulty.text = difficulties[recipe.difficulty];
        recipeRestriction.selectedIndex = recipe.restriction;

        prepTime.text = recipe.preptime;
        cookTime.text = recipe.cooktime;

        recipeDirections.text = recipe.directions;
    }

}

