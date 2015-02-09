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
import Ubuntu.Components.ListItems 1.0 as ListItems

ListView {
    id: listView

    boundsBehavior: Flickable.DragOverBounds

    property alias pullUpText: listViewLabel.text
    property alias pullUpImage: listViewImage.source
    signal pulledUp()

    // private
    property bool __wasAtYEnd: false
    property int __initialContentY: 0
    property bool __toBeRefresh: false

    onMovementStarted: {
        __wasAtYEnd = atYEnd
        __initialContentY = contentY
    }

    onContentYChanged: {
        if (__wasAtYEnd && contentY - __initialContentY > units.gu(8))
            __toBeRefresh = true
    }

    onMovementEnded: {
        if (__toBeRefresh) {
            pulledUp()
            __toBeRefresh = false
        }
    }

    Row {
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            margins: units.gu(4)
        }
        visible: listView.__toBeRefresh && contentY - __initialContentY > units.gu(8)
        spacing: units.gu(2)

        Icon {
            id: listViewImage
            name: "view-refresh"
            height: listViewLabel.height
            width: height
        }

        Label {
            id: listViewLabel
            text: qsTr("Release for more results...")
        }
    }

    Component.onCompleted: {
        // FIXME: workaround for qtubuntu not returning values depending on the grid unit definition
        // for Flickable.maximumFlickVelocity and Flickable.flickDeceleration
        var scaleFactor = units.gridUnit / 8;
        maximumFlickVelocity = maximumFlickVelocity * scaleFactor;
        flickDeceleration = flickDeceleration * scaleFactor;
    }
}
