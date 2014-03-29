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
import Ubuntu.Components 0.1

Item {
    id: item

    property string imageSource: ""
    property alias title: label.text
    property int favorite: 0
    property int difficulty: 0
    property int restriction: 0

    UbuntuShape {
        anchors {
            fill: parent
            margins: units.gu(1)
        }
        radius: "medium"

        image: ImageWithFallback {
            id: image
            source: imageSource
            fallbackSource: icon("512/unknown-food", true)
            fillMode: Image.PreserveAspectCrop
        }

        Item {
            id: bottomContainer
            clip: true
            height: infos.height + units.gu(2)
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            UbuntuShape {
                radius: "medium"
                height: item.height
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }
                color: Qt.rgba(0, 0, 0, 0.8)
            }

            Column {
                id: infos
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: units.gu(1)
                    verticalCenter: parent.verticalCenter
                }
                height: childrenRect.height
                spacing: units.gu(0.4)

                Row {
                    id: symbols
                    height: childrenRect.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: units.gu(1)

                    Image {
                        source: difficulty ? icon("32/difficulty-%1".arg(difficulty), true) : ""
                        sourceSize.height: units.gu(2)
                    }

                    Image {
                        source: restriction ? icon("32/restriction-%1".arg(restriction), true) : ""
                        sourceSize.height: units.gu(2)
                    }

                    Image {
                        visible: favorite
                        source: mainView.icon("32/star", true)
                        sourceSize.height: units.gu(2)
                    }
                }

                Label {
                    id: label
                    width: parent.width
                    elide: Text.ElideRight
                    maximumLineCount: 2
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            recipe.docId = docId;
            console.log("Opening recipe: " + docId)
            pageStack.push(Qt.resolvedUrl("../ui/NewRecipePage.qml"));
        }
    }
}
