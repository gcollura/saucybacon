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
import Ubuntu.Components.ListItems 0.1 as ListItem

import "../components"

Page {
    title: truncate(recipe.name, parent.width)

    tools: RecipePageToolbar {
        objectName: "recipePageToolbar"
    }

    Item {
        visible: !recipe.ready
        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }
        ActivityIndicator {
            id: indicator
            running: !recipe.ready
        }
        Label {
            anchors {
                top: indicator.bottom
                horizontalCenter: parent.horizontalCenter
            }
            text: i18n.tr("I am loading your recipe, please hold still")
            fontSize: "large"
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
        interactive: contentHeight + units.gu(10) > height

        visible: recipe.ready

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
                width: wideAspect ? parent.width / 2 - units.gu(2) : parent.width
                spacing: units.gu(2)

                Item {
                    width: parent.width
                    height: totaltimeLabel.height

                    Label {
                        id: totaltimeLabel
                        anchors.left: parent.left
                        text: i18n.tr("%1".arg(recipe.totaltime))
                    }
                    Label {
                        anchors.right: parent.right
                        text: i18n.tr("Prep: %1 mins, Cook: %2 mins".arg(recipe.preptime).arg(recipe.cooktime))
                    }
                }

                Label {
                    id: difficultyLabel
                    text: i18n.tr("Difficulty: %1".arg(difficulties[recipe.difficulty]))
                }

                Label {
                    id: restrictionLabel
                    text: i18n.tr("Restriction: %1".arg(restrictions[recipe.restriction]));
                }

                ListItem.ThinDivider {
                    anchors.margins: units.gu(-2)
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
                        model: recipe.ingredients

                        delegate: Label {
                            width: parent.width
                            text: txt(modelData.quantity, modelData.type, modelData.name)
                            wrapMode: Text.Wrap

                            function txt(quantity, type, name) {
                                var output = "";
                                output += quantity ? "%1 ".arg(quantity) : "";
                                output += type + name;
                                return output;
                            }
                        }
                    }
                }

                ListItem.ThinDivider {
                    visible: recipe.photos.length > 0
                    anchors.margins: units.gu(-2)
                }

                PhotoLayout {
                    id: photoLayout
                    clip: wideAspect
                    editable: false
                    iconSize: units.gu(12)

                    photos: recipe.photos
                }

                ListItem.ThinDivider {
                    visible: !wideAspect
                    anchors.margins: units.gu(-2)
                }

                Behavior on width { UbuntuNumberAnimation { duration: UbuntuAnimation.SlowDuration } }

            }

            Column {
                id: secondColumn
                width: wideAspect ? parent.width / 2 - units.gu(2) : parent.width
                spacing: units.gu(2)

                Label {
                    id: label
                    text: i18n.tr("Directions")

                    fontSize: "large"
                    font.bold: true
                }

                Label {
                    id: directionsLabel
                    width: parent.width

                    text: recipe.directions

                    wrapMode: Text.Wrap
                }
            }
        }
    }
}
