/**
 * This file is part of SaucyBacon.
 *
 * Copyright 2013 (C) Giulio Collura <random.cpp@gmail.com>
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

import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1
import Ubuntu.Components.ListItems 0.1

import "../components"

Page {
    id: page

    title: recipe.exists() ? i18n.tr("Edit recipe") : i18n.tr("New recipe")

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

        anchors {
            fill: parent
            topMargin: units.gu(2)
            bottomMargin: units.gu(2)
        }
        contentHeight: layout.height
        interactive: contentHeight + units.gu(5) > height // +5 because of strange ValueSelector height

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

                    text: recipe.name
                    placeholderText: i18n.tr("Enter a name for your recipe")
                }

                Column {
                    anchors {
                        left: parent.left
                        right: parent.right
                        margins: units.gu(-2)
                    }

                    ValueSelector {
                        id: recipeCategory
                        width: parent.width
                        text: i18n.tr("Category")

                        selectedIndex: recipe.category ? categories.indexOf(recipe.category) : 0
                        values: categories.concat([i18n.tr("<i>New category...</i>")])

                        onSelectedIndexChanged: {
                            if (selectedIndex == categories.length)
                                PopupUtils.open(Qt.resolvedUrl("NewCategoryDialog.qml"), recipeCategory)
                        }
                    }

                    ValueSelector {
                        id: recipeDifficulty
                        width: parent.width
                        text: i18n.tr("Difficulty")
                        values: difficulties
                        selectedIndex: recipe.difficulty
                    }

                    ValueSelector {
                        id: recipeRestriction
                        width: parent.width
                        text: i18n.tr("Restriction")
                        values: restrictions
                        selectedIndex: recipe.restriction
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

                ThinDivider {
                    anchors.margins: units.gu(-2)
                }

                Row {
                    width: parent.width
                    Label {
                        text: i18n.tr("Ingredients")
                    }
                    // FIXME: Add servings feature
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

                ThinDivider {
                    anchors.margins: units.gu(-2)
                    visible: !wideAspect
                }

                Behavior on width { UbuntuNumberAnimation { duration: UbuntuAnimation.SlowDuration } }
            }

            Column {
                id: secondColumn
                width: wideAspect ? parent.width / 2 - units.gu(2) : parent.width
                spacing: units.gu(2)

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
                    width: parent.width
                    clip: wideAspect

                    photos: recipe.photos
                }

                Behavior on width { UbuntuNumberAnimation { duration: UbuntuAnimation.SlowDuration } }
            }
        }
    }

    function saveRecipe() {

        recipe.name = recipeName.text ? recipeName.text : i18n.tr("Misterious Recipe");
        recipe.category = categories[recipeCategory.selectedIndex];
        recipe.difficulty = recipeDifficulty.selectedIndex;
        recipe.restriction = recipeRestriction.selectedIndex;

        recipe.preptime = prepTime.text;
        recipe.cooktime = cookTime.text;
        recipe.totaltime = totalTime.text;

        recipe.ingredients = ingredientsLayout.getIngredients();

        recipe.directions = recipeDirections.text;

        recipe.photos = photoLayout.photos;
        recipe.restriction = recipeRestriction.selectedIndex;

        pageStack.back();
        recipe.save();

    }

    onVisibleChanged: {
        if (!visible)
            return;

        // WORKAROUND: Refresh some widgets that may forget they configuration
        // for example when they cleared using the clear button
        recipeName.text = recipe.name
        recipeCategory.selectedIndex = recipe.category ? categories.indexOf(recipe.category) : 0;
        recipeDifficulty.selectedIndex = recipe.difficulty;
        recipeRestriction.selectedIndex = recipe.restriction;

        prepTime.text = recipe.preptime > 0 ? recipe.preptime : "";
        cookTime.text = recipe.cooktime > 0 ? recipe.cooktime : "";

        recipeDirections.text = recipe.directions;
    }
}
