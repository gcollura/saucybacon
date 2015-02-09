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

import QtQuick 2.3
import Ubuntu.Components 1.1
import Ubuntu.Components.Themes.Ambiance 0.1

Item {
    id: item

    height: _quantity.height

    property alias quantity: _quantity.text
    property alias unit: _unit.text
    property alias name: _name.text
    focus: _name.focus || _unit.focus || _quantity.focus

    function get() {
        return { "quantity": quantity, "unit": unit, "name": name };
    }

    function focus() {
        _name.forceActiveFocus();
    }

    signal remove()
    signal changed()

    Component {
        id: textFieldStyle
        TextFieldStyle {
            color: "white"
            background: Item { anchors.fill: parent }
        }
    }

    Item {
        id: row

        anchors.fill: parent

        TextField {
            id: _quantity
            width: focus ? units.gu(16) : units.gu(6)
            anchors {
                left: parent.left
            }

            // inputMethodHints: Qt.ImhFormattedNumbersOnly
            placeholderText: i18n.tr("Qty")
            onTextChanged: item.changed()

            style: textFieldStyle

            Behavior on width { UbuntuNumberAnimation { } }
        }

        TextField {
            id: _unit
            width: focus ? units.gu(16) : units.gu(7)
            anchors {
                left: _quantity.right
                leftMargin: units.gu(1)
            }

            placeholderText: i18n.tr("Type")
            onTextChanged: item.changed()

            style: textFieldStyle
            Behavior on width { UbuntuNumberAnimation { } }
        }

        TextField {
            id: _name
            anchors {
                left: _unit.right
                right: cancelButton.left
                leftMargin: units.gu(1)
                rightMargin: units.gu(1)
            }

            placeholderText: i18n.tr("Insert ingredient name")
            onTextChanged: item.changed()

            style: textFieldStyle
        }

        AbstractButton {
            id: cancelButton
            width: units.gu(3)
            height: width
            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
            }

            Icon {
                anchors.fill: parent
                name: "edit-clear"
                color: colors.white
            }

            onClicked: remove()
        }
    }
}
