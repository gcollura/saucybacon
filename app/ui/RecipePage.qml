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

import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import Ubuntu.Layouts 1.0

import "../components"

Page {
    id: page

    title: truncate(recipe.name, parent.width)
    anchors.fill: parent

    tools: RecipePageToolbar {
        objectName: "recipePageToolbar"
    }

    property Flickable pageFlickable

    flickable: wideAspect ? null : pageFlickable

    Layouts {
        id: layouts
        anchors.fill: parent

        layouts: [
            ConditionalLayout {
                name: "waitLayout"
                when: !recipe.ready

                Item {
                    anchors.fill: parent
                    // We put the Column in a item because sometimes qmlscene
                    // blames on parent which may be null and doesn't have the
                    // properties verticalCenter and horizontalCenter
                    // 
                    // TypeError: Cannot read property of null
                    Column {
                        anchors {
                            verticalCenter: parent.verticalCenter
                            horizontalCenter: parent.horizontalCenter
                        }
                        spacing: units.gu(4)
                        ActivityIndicator {
                            id: indicator
                            anchors.horizontalCenter: parent.horizontalCenter
                            running: true
                        }
                        Label {
                            anchors {
                                horizontalCenter: parent.horizontalCenter
                            }
                            text: i18n.tr("Please wait. Serving up recipe.")
                            horizontalAlignment: Text.AlignHCenter
                            fontSize: "large"
                        }
                    }
                }
            },
            ConditionalLayout {
                name: "tabletLayout"
                when: wideAspect && recipe.ready

                Row {
                    anchors {
                        topMargin: header.height
                        fill: parent
                    }

                    Sidebar {
                        id: sidebar
                        mode: "left"
                        anchors {
                            top: parent.top
                            bottom: parent.bottom
                        }

                        ListView {
                            width: sidebar.width
                            height: sidebar.height
                            model: recipesdb
                            header: ListItem.Header {
                                text: i18n.tr("Recipes")
                            }
                            delegate: ListItem.Subtitled {
                                text: truncate(contents.name, parent.width, units.gu(1.5))
                                subText: i18n.tr("Total time: " + (contents.preptime + contents.cooktime).toTime())
                                iconSource: contents.photos[0] ? contents.photos[0] : ""
                                progression: docId === recipe.docId
                                onClicked: {
                                    console.log("Opening recipe: " + docId)
                                    recipe.docId = docId;
                                }
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
                        width: page.width / 2 - sidebar.width / 2
                        contentHeight: leftColumn.height
                        interactive: contentHeight > height

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
                                height: symbolDisplay.height
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
                        width: page.width / 2 - sidebar.width / 2
                        contentHeight: rightColumn.height
                        interactive: contentHeight > height

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

            Component.onCompleted: pageFlickable = flickable

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
                            id: difficulty
                            visible: recipe.difficulty
                            source: recipe.difficulty ? icon("64/difficulty-%1".arg(recipe.difficulty), true) : ""
                            text: difficulties[recipe.difficulty]
                        }

                        ImageWithLabel {
                            id: restriction
                            visible: recipe.restriction
                            source: recipe.restriction ? icon("64/restriction-%1".arg(recipe.restriction), true) : ""
                            text: restrictions[recipe.restriction]
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
                    iconSize: units.gu(12)

                    photos: recipe.photos
                }

                ListItem.ThinDivider {
                    visible: recipe.photos.length > 0
                    anchors.margins: units.gu(-2)
                }

                Label {
                    id: ingredientsLabel
                    Layouts.item: "ingredientsLabel"
                    text: i18n.tr("Ingredients")
                    fontSize: "large"
                    font.bold: true
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
                            model: recipe.ingredients

                            delegate: Label {
                                id: label
                                width: ingredientsList.width
                                text: formatIngredient(modelData.quantity, modelData.type, modelData.name)
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
        output += quantity ? "%1 ".arg(quantity) : "";
        output += type ? "%1 ".arg(type) : "";
        output += name;
        return output.capitalize();
    }
}
