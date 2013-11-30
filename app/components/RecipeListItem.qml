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

    iconSource: contents.photos[0] ? Qt.resolvedUrl(contents.photos[0]) : mainView.icon("64/unknown-food", true)
    fallbackIconSource: mainView.icon("64/unknown-food", true)

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
            text: i18n.tr("Total time: %1".arg(contents.totaltime))
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

        Image {
            anchors.verticalCenter: parent.verticalCenter
            source: contents.restriction ? mainView.icon("32/restriction-%1".arg(contents.restriction), true) : ""
            sourceSize.height: units.gu(2)
        }

        Image {
            anchors.verticalCenter: parent.verticalCenter
            source: contents.difficulty ? mainView.icon("32/difficulty-%1".arg(contents.difficulty), true) : ""
            sourceSize.height: units.gu(2)
        }

        Image {
            visible: contents.favorite
            anchors.verticalCenter: parent.verticalCenter
            source: mainView.icon("32/star", true)
            sourceSize.height: units.gu(2)
        }
    }

    onClicked: {
        recipe.docId = docId;
        if (!silent)
            pageStack.push(recipePage);
    }
}
