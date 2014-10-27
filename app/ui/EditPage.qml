/**
 * This file is part of SaucyBacon.
 *
 * Copyright 2013-2014 (C) Giulio Collura <random.cpp@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
**/

import QtQuick 2.3
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0
import Ubuntu.Components.ListItems 1.0

import "../components"

Page {
    id: page

    flickable: null

    Action {
        id: saveRecipeAction
        description: i18n.tr("Save the current recipe")
        keywords: "save;recipe"
        iconName: 'save'
        text: i18n.tr("Save")

        onTriggered: {
            saveRecipe();
        }
    }

    tools: ToolbarItems {
        ToolbarButton {
            action: saveRecipeAction
        }
    }

    states: [
        State {
            name: "edit"
        },
        State {
            name: "new"
        }
    ]

    Flickable {
        id: flickable

        anchors {
            fill: parent
            topMargin: units.gu(2)
            bottomMargin: units.gu(2)
        }
        contentHeight: layout.height
        interactive: contentHeight + units.gu(5) > height // +5 because of strange OptionSelector height

        Component.onCompleted: page.flickable = flickable

        Grid {
            id: layout
            anchors {
                left: parent.left
                right: parent.right
                margins: units.gu(2)
            }
            spacing: wideAspect ? units.gu(4) : units.gu(2)
            columns: wideAspect ? 2 : 1

            Behavior on columns { UbuntuNumberAnimation { duration: UbuntuAnimation.SlowDuration } }

            Column {
                id: firstColumn
                width: wideAspect ? parent.width / 2 - units.gu(2) : parent.width
                spacing: units.gu(2)

                TextField {
                    id: recipeName
                    width: parent.width

                    placeholderText: i18n.tr("Enter a name for your recipe")
                }

                Row {
                    width: parent.width
                    spacing: units.gu(1)

                    Label {
                        id: totalTime
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width / 2 - units.gu(2)

                        text: i18n.tr("Total time: ") + (prepTime.time + cookTime.time).toTime();
                        fontSize: "large"
                    }

                    TimePicker {
                        id: prepTime
                        width: parent.width / 4
                    }

                    TimePicker {
                        id: cookTime
                        width: parent.width / 4
                    }
                }

                Label {
                    text: i18n.tr("Photos")
                    fontSize: "large"
                }

                PhotoLayout {
                    id: photoLayout
                    width: parent.width
                    clip: wideAspect
                }

                Item {
                    width: parent.width
                    height: childrenRect.height

                    Label {
                        fontSize: "large"
                        text: i18n.tr("Categories")
                    }

                    AbstractButton {
                        id: newCategoryButton
                        width: units.gu(2)
                        height: width
                        anchors.right: parent.right

                        Icon {
                            anchors.fill: parent
                            name: "edit"
                            color: colors.white
                        }
                        onClicked: PopupUtils.open(Qt.resolvedUrl("dialogs/CategoryDialog.qml"))
                    }
                }

                ListModel {
                    id: categoriesModel
                    property var rawModel: database.categories
                    signal updated()
                    onRawModelChanged: {
                        categoriesModel.clear()
                        for (var i = 0; i < rawModel.length; i++) {
                            categoriesModel.append(rawModel[i])
                            categoriesModel.setProperty(i, "isSelected", false)
                        }
                        updated()
                    }
                }

                CategorySelector {
                    id: recipeCategory
                    width: parent.width

                    model: categoriesModel
                    selectedIndexes: []

                    delegate: CategorySelectorDelegate {
                        text: name
                        selected: isSelected

                        onClicked: {
                            if (isSelected) {
                                var idx = recipeCategory.selectedIndexes.indexOf(id.toString())
                                recipeCategory.selectedIndexes.splice(idx, 1);
                            } else {
                                recipeCategory.selectedIndexes.pushBack(id.toString())
                            }
                            listView.model.setProperty(index, "isSelected", !isSelected)
                        }

                        onItemRemoved: {
                            if (isSelected) {
                                var idx = recipeCategory.selectedIndexes.indexOf(id.toString())
                                recipeCategory.selectedIndexes.splice(idx, 1);
                            }
                            database.deleteCategory(id)
                        }
                    }

                    onSelectedIndexesChanged: {
                        updateSelections()
                    }

                    function updateSelections() {
                        // console.log("selectedIndexes", selectedIndexes)
                        recipeCategory.selectedIndex = 0
                        for (var i = 0; i < model.count; i++) {
                            var obj = model.get(i)
                            var index = selectedIndexes.indexOf(obj.id.toString())
                            model.setProperty(i, "isSelected", index > -1)
                        }
                    }

                    Connections {
                        target: categoriesModel
                        onUpdated: recipeCategory.updateSelections()
                    }

                }

                Label {
                    text: i18n.tr("Restriction")
                    fontSize: "large"
                }

                OptionSelector {
                    id: recipeRestriction
                    width: parent.width
                    model: database.restrictions
                    delegate: OptionSelectorDelegate {
                        text: modelData.name
                        iconSource: mainView.icon("64/restriction-%1".arg(modelData.id))
                        constrainImage: true
                    }
                }

                Item {
                    width: parent.width
                    height: childrenRect.height

                    Label {
                        text: i18n.tr("Ingredients")
                        fontSize: "large"
                    }

                    AbstractButton {
                        id: newIngredientButton
                        width: units.gu(2)
                        height: width
                        anchors.right: parent.right

                        Icon {
                            anchors.fill: parent
                            name: "add"
                            color: colors.white
                        }
                        onClicked: ingredientsLayout.addIngredient(true)
                    }
                }

                IngredientLayout {
                    id: ingredientsLayout
                    width: parent.width

                    Component.onCompleted: addIngredient()
                }

                Behavior on width { UbuntuNumberAnimation { } }
            }

            Column {
                id: secondColumn
                width: wideAspect ? parent.width / 2 - units.gu(2) : parent.width
                spacing: units.gu(2)

                Label {
                    text: i18n.tr("Directions")
                    fontSize: "large"
                }

                TextArea {
                    id: recipeDirections
                    width: parent.width

                    textFormat: TextEdit.RichText

                    placeholderText: i18n.tr("Write your directions")
                    maximumLineCount: 0
                    autoSize: true
                }

                Behavior on width { UbuntuNumberAnimation { } }
            }
        }
    }

    function saveRecipe() {

        if (page.state == "edit") {
            var recipe = database.recipe
        } else {
            var recipe = { }
            recipe.favorite = false
        }

        recipe.name = recipeName.text.trim()
        recipe.preptime = prepTime.time
        recipe.cooktime = cookTime.time
        recipe.directions = recipeDirections.getFormattedText(0, recipeDirections.text.length)
        recipe.restriction = recipeRestriction.selectedIndex

        recipe.categories = recipeCategory.selectedIndexes
        console.log(recipe.categories)

        recipe.ingredients = ingredientsLayout.getIngredients()

        recipe.photos = photoLayout.photos

        database.addRecipe(recipe)
        pageStack.pop()

    }

    function editRecipe(recipe) {
        console.log("edit")
        recipeName.text = recipe.name
        recipeCategory.selectedIndexes = recipe.categories
        // recipeDifficulty.selectedIndex = recipe.difficulty
        recipeRestriction.selectedIndex = recipe.restriction

        prepTime.time = recipe.preptime
        cookTime.time = recipe.cooktime

        ingredientsLayout.ingredients = recipe.ingredients

        recipeDirections.text = recipe.directions

        photoLayout.photos = recipe.photos
    }

    function newRecipe() {
        recipeName.text = ""
        recipeCategory.selectedIndexes = []
        // recipeDifficulty.selectedIndex = recipe.difficulty
        recipeRestriction.selectedIndex = 0

        prepTime.time = 0
        cookTime.time = 0

        ingredientsLayout.ingredients = []

        recipeDirections.text = ""

        photoLayout.photos = []
    }
}
