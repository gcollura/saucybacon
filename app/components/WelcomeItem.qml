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

import QtQuick 2.3
import Ubuntu.Components 1.1

Item {
    id: root

    property list<Action> actions
    property alias text: welcomeLabel.text
    property alias backgroundColor: background.color

    Rectangle {
        id: background
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.4)
    }

    Column {
        anchors.centerIn: parent
        spacing: units.gu(4)

        UbuntuShape {
            image: Image {
                source: icon("saucybacon")
                smooth: true
            }

            width: units.gu(20)
            height: width
            radius: "medium"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Label {
            id: welcomeLabel
            width: root.width
            horizontalAlignment: Text.AlignHCenter
            text: i18n.tr("To start, choose one of the following actions")
            fontSize: "large"
            wrapMode: Text.WordWrap
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: units.gu(6)
            Repeater {
                model: root.actions

                ImageWithLabel {
                    iconName: modelData.iconName
                    text: modelData.text
                    MouseArea {
                        anchors.fill: parent
                        onClicked: modelData.trigger()
                    }
                }
            }
        }
    }
}
