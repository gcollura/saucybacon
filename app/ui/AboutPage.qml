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

Page {
    title: i18n.tr("About")

    Column {
        anchors {
            centerIn: parent
            margins: units.gu(3)
            topMargin: units.gu(8)
        }

        spacing: units.gu(3)

        UbuntuShape {
            image: Image {
                source: Qt.resolvedUrl("../../resources/icons/SaucyBacon_icon.png")
            }

            width: 128
            height: width
            radius: "medium"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Grid {
            anchors.horizontalCenter: parent.horizontalCenter
            columns: 2
            spacing: units.gu(1)

            Label {
                text: i18n.tr("Author: ")
            }

            Label {
                font.bold: true
                text: "Giulio Collura"
            }

            Label {
                text: i18n.tr("Icon:")
            }

            Label {
                font.bold: true
                text: "Lucas Romero Di Benedetto"
            }

            Label {
                text: i18n.tr("Contact:")
            }

            Label {
                text: i18n.tr("<a href=\"mailto:random.cpp@gmail.com?subject=SaucyBacon%20support\">random.cpp@gmail.com</a>")
                onLinkActivated: Qt.openUrlExternally(link)
            }
        }

        Label {
            text: i18n.tr("<a href=\"https://github.com/random-cpp/saucybacon/issues/\">Report a Bug</a>")
            anchors.horizontalCenter: parent.horizontalCenter
            onLinkActivated: Qt.openUrlExternally(link)
        }

        Label {
            text: i18n.tr("<a href=\"https://github.com/random-cpp/saucybacon\">Website</a>")
            anchors.horizontalCenter: parent.horizontalCenter
            onLinkActivated: Qt.openUrlExternally(link)
        }

        Label {
            text: i18n.tr("Version <b>%1</b>").arg("1.0")
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Label {
            text: i18n.tr("Copyright (C) 2013 Giulio Collura")
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
