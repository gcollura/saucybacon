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

Item {
    id: item

    anchors {
        left: parent.left
        right: parent.right
    }

    height: row.childrenRect.height

    property alias name: _name.text
    property alias quantity: _quantity.text
    property alias type: _quantityType.text

    Item {
        id: row

        anchors.fill: parent

        TextField {
            id: _quantity
            width: focus ? units.gu(16) : units.gu(6)
            anchors {
                left: parent.left
            }

            inputMethodHints: Qt.ImhFormattedNumbersOnly
            placeholderText: i18n.tr("Qty")

            Behavior on width { UbuntuNumberAnimation { } }
        }

        TextField {
            id: _quantityType
            width: focus ? units.gu(16) : units.gu(6)
            anchors {
                left: _quantity.right
                leftMargin: units.gu(1)
            }

            placeholderText: i18n.tr("Type")

            Behavior on width { UbuntuNumberAnimation { } }
        }

        TextField {
            id: _name
            anchors {
                left: _quantityType.right
                right: cancelButton.left
                leftMargin: units.gu(1)
                rightMargin: units.gu(1)
            }

            placeholderText: i18n.tr("Insert ingredient name")
        }

        AbstractButton {
            id: cancelButton
            width: units.gu(4)
            height: width
            anchors {
                right: parent.right
            }

            Icon {
                anchors {
                    fill: parent
                    margins: units.gu(0.2)
                }
                name: "edit-clear"
            }

            onClicked: item.destroy()
        }
    }

    function focus() {
        _name.forceActiveFocus();
    }
}
