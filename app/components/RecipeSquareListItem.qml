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

    property bool minimal: false
    property bool silent: false

    Column {
        anchors {
            margins: units.gu(1)
            fill: parent
        }

        UbuntuShape {
            width: parent.width
            height: parent.height - units.gu(4)
            radius: "medium"
            image: Image {
                source: contents.photos[0] ? Qt.resolvedUrl(contents.photos[0]) : mainView.icon("64/unknown-food", true)
                fillMode: Image.PreserveAspectCrop
            }
        }

        Label {
            width: parent.width
            elide: Text.ElideRight
            maximumLineCount: 2
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            text: contents.name
        }
    }


    MouseArea {
        anchors.fill: parent
        onClicked: {
            recipe.docId = docId;
            console.log("Opening recipe: " + docId)
            if (!silent)
            pageStack.push(Qt.resolvedUrl("../ui/RecipePage.qml"));
        }
    }
}
