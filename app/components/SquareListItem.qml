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
    // Inspired by nik90's DetailCarousel delegate
    id: item

    property string imageSource: ""
    property alias title: label.text
    property int favorite: 0
    property int difficulty: 0
    property int restriction: 0

    property bool minimal: false
    property bool silent: false

    Column {
        anchors {
            fill: parent
            margins: units.gu(1.5)
            bottomMargin: units.gu(0.5)
        }
        spacing: units.gu(0.5)

        UbuntuShape {
            width: parent.width
            height: parent.height - units.gu(6)
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
                height: units.gu(5)
                visible: difficulty || restriction || favorite
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }

                UbuntuShape {
                    // Thanks to nik90 for this trick
                    radius: "medium"
                    height: item.height
                    anchors {
                        bottom: parent.bottom
                        left: parent.left
                        right: parent.right
                    }
                    color: Qt.rgba(0,0,0,0.8)
                }

                Row {
                    id: symbols
                    height: parent.height
                    width: childrenRect.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: units.gu(1)

                    Image {
                        anchors.verticalCenter: parent.verticalCenter
                        source: difficulty ? icon("32/difficulty-%1".arg(difficulty), true) : ""
                        sourceSize.height: units.gu(2)
                    }

                    Image {
                        anchors.verticalCenter: parent.verticalCenter
                        source: restriction ? icon("32/restriction-%1".arg(restriction), true) : ""
                        sourceSize.height: units.gu(2)
                    }

                    Image {
                        visible: favorite
                        anchors.verticalCenter: parent.verticalCenter
                        source: mainView.icon("32/star", true)
                        sourceSize.height: units.gu(2)
                    }
                }
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


    MouseArea {
        anchors.fill: parent
        onClicked: {
            recipe.docId = docId;
            console.log("Opening recipe: " + docId)
            if (!silent)
            pageStack.push(Qt.resolvedUrl("../ui/NewRecipePage.qml"));
        }
    }
}
