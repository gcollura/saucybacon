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
import Ubuntu.Components.ListItems 0.1 as ListItem

ListItem.Subtitled {
    id: item
    progression: true

    icon: contents.photos[0] ? Qt.resolvedUrl(contents.photos[0]) : mainView.icon("unknown-food", true)

    property bool minimal: false
    property bool silent: false

    Column {
        id: right
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
        }
        Label {
            text: truncate(contents.name, item.width, units.gu(1.5))
        }
        Label {
            visible: contents.preptime + contents.cooktime > 0
            text: i18n.tr("%1".arg(contents.totaltime))
            font.pixelSize: units.gu(1.5)
            color: Theme.palette.normal.backgroundText
        }
    }

    Row {
        id: left
        spacing: units.gu(2)
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
        }
        visible: !minimal
        Label {
            anchors.verticalCenter: parent.verticalCenter
            text: restrictions[contents.restriction]
            font.pixelSize: units.gu(1.5)
            color: Theme.palette.normal.backgroundText
        }
        Column {
            anchors.verticalCenter: parent.verticalCenter
            width: units.gu(2)

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: Array(contents.difficulty + 1).join("\u1620")
            }

            Label {
                visible: contents.favorite
                anchors.horizontalCenter: parent.horizontalCenter
                text: "\u2605" // Star
            }
        }
    }

    onClicked: {
        recipe.docId = docId;
        if (!silent)
            pageStack.push(recipePage);
    }
}
