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

Row {
    id: object

    anchors.left: parent.left
    anchors.right: parent.right
    spacing: units.gu(1)

    property alias name: ingredientName.text
    property alias quantity: ingredientQuantity.text
    property alias type: ingredientQuantityType.text

    TextField {
        id: ingredientQuantity
        width: units.gu(8)

        inputMethodHints: Qt.ImhFormattedNumbersOnly
        placeholderText: i18n.tr("Qty")
    }

    TextField {
        id: ingredientQuantityType
        width: units.gu(8)

        placeholderText: i18n.tr("Type")
    }

    TextField {
        id: ingredientName
        width: parent.width - units.gu(23)

        placeholderText: i18n.tr("Insert ingredient name")
    }

    Button {
        id: cancelButton
        width: units.gu(4)
        height: width

        iconSource: icon("32/delete", true)

        onClicked: object.destroy()
    }

    // UbuntuNumberAnimation on opacity { from: 0; to: 100 }

    function focus() {
        ingredientName.forceActiveFocus();
    }

}
