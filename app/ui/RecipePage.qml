/**
 * This file is part of SaucyBacon.
 *
 * Copyright 2013-2015 (C) Giulio Collura <random.cpp@gmail.com>
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
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import Ubuntu.Components.Popups 1.0
import Ubuntu.Layouts 1.0

import "../components"

Page {
    id: page

    anchors.fill: parent

    Action {
        id: favoriteRecipeAction
        visible: recipe.saved
        text: i18n.tr("Favorite")
        iconName: database.recipe.favorite ? "favorite-selected" : "favorite-unselected"

        onTriggered: {
            recipe.favorite = !recipe.favorite
            database.addRecipe(recipe)
        }
    }

    Action {
        id: saveRecipeAction
        visible: !recipe.saved
        text: i18n.tr("Save")
        iconName: "save"

        onTriggered: {
            database.addRecipe(recipe)
        }
    }

    Action {
        id: deleteRecipeAction
        visible: recipe.saved
        text: i18n.tr("Delete")
        iconName: "delete"

        onTriggered: PopupUtils.open(Qt.resolvedUrl("dialogs/DeleteDialog.qml"))
    }

    Action {
        id: sourceRecipeAction
        visible: recipe.source.length > 0
        text: i18n.tr("Source")
        iconName: "stock_website"

        onTriggered: {
            if (utils.open(recipe.source)) {
                console.log("Open " + recipe.source);
            }
        }
    }

    property var actions: [
        saveRecipeAction,
        favoriteRecipeAction,
        editRecipeAction,
        deleteRecipeAction,
        sourceRecipeAction
    ]

    state: database.loading ? "loading" : "default"
    states: [
        State {
            name: "default"
            PropertyChanges {
                target: head
                actions: page.actions
            }
            PropertyChanges {
                target: page
                title: recipe.name ? recipe.name : i18n.tr("Recipe")
            }
        },
        State {
            name: "loading"
            PropertyChanges {
                target: page
                title: ""
            }
        }
    ]

    property Flickable pageFlickable

    flickable: wideAspect ? null : pageFlickable

    property var recipe: database.recipe

    LoadingIndicator {
        id: loadingIndicator
        text: i18n.tr("Downloading recipe...")
        isShown: database.loading
    }

    onVisibleChanged: {
        console.log("recipePage visible", page.visible)
    }

    opacity: visible ? 1 : 0
    Behavior on opacity {
        UbuntuNumberAnimation {
            duration: UbuntuAnimation.SlowDuration
        }
    }

    Layouts {
        id: layouts
        anchors.fill: parent

        opacity: database.loading ? 0 : 1
        Behavior on opacity {
            UbuntuNumberAnimation {
                duration: UbuntuAnimation.SlowDuration
            }
        }

        layouts: [
            ConditionalLayout {
                name: "tabletLayout"
                when: wideAspect

                Row {
                    anchors {
                        topMargin: header.height
                        fill: parent
                    }

                    Flickable {
                        clip: true
                        anchors {
                            top: parent.top
                            bottom: parent.bottom
                            margins: units.gu(2)
                        }
                        width: page.width / 2
                        contentHeight: leftColumn.height + units.gu(5)
                        interactive: contentHeight > height

                        Component.onCompleted: {
                            // FIXME: workaround for qtubuntu not returning values depending on the grid unit definition
                            // for Flickable.maximumFlickVelocity and Flickable.flickDeceleration
                            var scaleFactor = units.gridUnit / 8;
                            maximumFlickVelocity = maximumFlickVelocity * scaleFactor;
                            flickDeceleration = flickDeceleration * scaleFactor;
                        }

                        Column {
                            id: leftColumn
                            anchors {
                                left: parent.left
                                right: parent.right
                                margins: units.gu(2)
                            }
                            spacing: units.gu(2)
                            height: childrenRect.height

                            ItemLayout {
                                id: symbolDisplayItem
                                item: "symbolDisplay"
                                width: parent.width
                                height: symbolDisplay.childrenRect.height
                                visible: recipe.difficulty || recipe.preptime + recipe.cooktime > 0 || recipe.favorite || recipe.restriction
                            }

                            ItemLayout {
                                item: "totaltimeLabel"
                                anchors {
                                    horizontalCenter: parent.horizontalCenter
                                }
                                width: totaltimeLabel.width
                                height: totaltimeLabel.height
                                visible: recipe.preptime + recipe.cooktime > 0
                            }

                            ItemLayout {
                                item: "categoriesHeaderLabel"
                                width: parent.width
                                height: categoriesHeaderLabel.height
                                visible: recipe.categories.length > 0
                            }

                            ItemLayout {
                                item: "categoriesLabel"
                                width: parent.width
                                height: categoriesLabel.height
                                visible: recipe.categories.length > 0
                            }

                            ListItem.ThinDivider {
                                visible: symbolDisplayItem.visible
                                anchors.margins: units.gu(-2)
                            }

                            ItemLayout {
                                item: "photoLayout"
                                width: parent.width
                                height: photoLayout.height
                                visible: recipe.photos.length > 0
                            }

                            ListItem.ThinDivider {
                                visible: recipe.photos.length > 0
                                anchors.margins: units.gu(-2)
                            }

                            ItemLayout {
                                item: "ingredientsLabel"
                                width: parent.width
                                height: ingredientsLabel.height
                            }

                            ItemLayout {
                                item: "ingredientsColumn"
                                width: parent.width
                                height: ingredientsColumn.height
                            }
                        }
                    }

                    Flickable {
                        clip: true
                        anchors {
                            top: parent.top
                            bottom: parent.bottom
                            margins: units.gu(2)
                        }
                        width: page.width / 2
                        contentHeight: rightColumn.height
                        interactive: contentHeight > height

                        Component.onCompleted: {
                            // FIXME: workaround for qtubuntu not returning values depending on the grid unit definition
                            // for Flickable.maximumFlickVelocity and Flickable.flickDeceleration
                            var scaleFactor = units.gridUnit / 8;
                            maximumFlickVelocity = maximumFlickVelocity * scaleFactor;
                            flickDeceleration = flickDeceleration * scaleFactor;
                        }

                        Column {
                            id: rightColumn
                            anchors {
                                left: parent.left
                                right: parent.right
                                margins: units.gu(2)
                            }
                            spacing: units.gu(2)
                            height: childrenRect.height

                            ItemLayout {
                                item: "directionsLabel"
                                width: parent.width
                                height: directionsLabel.height
                            }

                            ItemLayout {
                                item: "directionsText"
                                anchors {
                                    left: parent.left
                                    right: parent.right
                                }
                                height: directionsText.contentHeight
                            }
                        }
                    }
                }
            }
        ]

        Flickable {
            id: flickable
            anchors {
                fill: parent
                margins: units.gu(2)
            }
            contentHeight: column.height
            interactive: contentHeight > parent.height

            Component.onCompleted: {
                // FIXME: workaround for qtubuntu not returning values depending on the grid unit definition
                // for Flickable.maximumFlickVelocity and Flickable.flickDeceleration
                var scaleFactor = units.gridUnit / 8;
                maximumFlickVelocity = maximumFlickVelocity * scaleFactor;
                flickDeceleration = flickDeceleration * scaleFactor;
                pageFlickable = flickable;
            }

            Column {
                id: column
                anchors {
                    left: parent.left
                    right: parent.right
                }
                spacing: units.gu(2)

                Item {
                    id: symbolDisplay
                    Layouts.item: "symbolDisplay"
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                    height: childrenRect.height

                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: units.gu(4)

                        ImageWithLabel {
                            id: totaltime
                            visible: recipe.preptime + recipe.cooktime > 0
                            source: icon("64/clock", true)
                            text: (recipe.preptime + recipe.cooktime).toTime()
                        }

                        ImageWithLabel {
                            id: restriction
                            visible: recipe.restriction
                            source: recipe.restriction ? icon("64/restriction-%1".arg(recipe.restriction), true) : ""
                            text: database.restrictions[recipe.restriction].name
                        }

                        ImageWithLabel {
                            id: favorite
                            visible: recipe.favorite
                            source: icon("64/star", true)
                            text: i18n.tr("Favorite")
                        }
                    }
                }

                Label {
                    id: totaltimeLabel
                    Layouts.item: "totaltimeLabel"
                    visible: recipe.preptime + recipe.cooktime > 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: formatTime(recipe.preptime, recipe.cooktime)
                }

                Label {
                    id: categoriesHeaderLabel
                    Layouts.item: "categoriesHeaderLabel"
                    visible: categoriesLabel.visible
                    width: parent.width
                    text: "Categories"
                    font.bold: true
                    fontSize: "large"
                }

                Label {
                    id: categoriesLabel
                    Layouts.item: "categoriesLabel"
                    visible: recipe.categories.length > 0
                    width: parent.width
                    text: {
                        var txt = "";
                        for (var i = 0; i < database.categories.length; i++) {
                            if (recipe.categories.indexOf(database.categories[i].id.toString()) > -1) {
                                txt += database.categories[i].name + " ";
                            }
                        }
                        return txt;
                    }
                }

                ListItem.ThinDivider {
                    visible: symbolDisplay.height > 0
                    anchors.margins: units.gu(-2)
                }

                PhotoLayout {
                    id: photoLayout
                    Layouts.item: "photoLayout"
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                    clip: wideAspect
                    editable: false
                    iconSize: units.gu(16)

                    photos: recipe.photos
                }

                ListItem.ThinDivider {
                    visible: recipe.photos.length > 0 && ingredientsLabel.visible
                    anchors.margins: units.gu(-2)
                }

                Label {
                    id: ingredientsLabel
                    Layouts.item: "ingredientsLabel"
                    text: i18n.tr("Ingredients")
                    fontSize: "large"
                    font.bold: true
                    visible: recipe.ingredients ? recipe.ingredients.length > 0 : 0
                }

                Item {
                    id: ingredientsColumn
                    Layouts.item: "ingredientsColumn"
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                    height: childrenRect.height

                    Column {
                        width: parent.width
                        spacing: units.gu(0.7)
                        height: childrenRect.height

                        Repeater {
                            id: ingredientsList
                            width: parent.width
                            model: recipe.ingredients ? recipe.ingredients : 0

                            delegate: Label {
                                id: label
                                width: ingredientsList.width
                                text: formatIngredient(modelData.quantity, modelData.unit, modelData.name)
                                wrapMode: Text.Wrap
                            }
                        }
                    }
                }

                ListItem.ThinDivider {
                    anchors.margins: units.gu(-2)
                }

                Label {
                    id: directionsLabel
                    Layouts.item: "directionsLabel"
                    text: i18n.tr("Directions")

                    fontSize: "large"
                    font.bold: true
                    visible: recipe.directions.length > 0
                }

                Label {
                    id: directionsText
                    Layouts.item: "directionsText"
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                    text: recipe.directions

                    wrapMode: Text.WordWrap
                    textFormat: Text.RichText
                }
            }
        }
    }

    function formatTime(preptime, cooktime) {
        var string = "";
        if (preptime > 0)
        string += i18n.tr("Prep Time: " + preptime.toTime());
        if (preptime > 0 && cooktime > 0)
        string += " | ";
        if (cooktime > 0)
        string += i18n.tr("Cook Time: " + cooktime.toTime());
        return string;
    }

    function formatIngredient(quantity, type, name) {
        var output = "";
        output += quantity > 0 ? "%1 ".arg(quantity) : "";
        output += type ? "%1 ".arg(type) : "";
        output += name;
        return output.capitalize();
    }
}
