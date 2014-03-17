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
import Ubuntu.Components.Popups 0.1

// New category dialog

Dialog {
    id: dialogue
    title: i18n.tr("New category")
    text: i18n.tr("Create a new category for your recipes.")

    TextField {
        id: nameField
        placeholderText: i18n.tr("Name your category...")
    }

    Button {
        text: i18n.tr("Cancel")

        gradient: UbuntuColors.greyGradient
        onClicked: {
            caller.selectedIndex = 0;
            PopupUtils.close(dialogue);
        }
    }

    Button {
        text: i18n.tr("Create")

        onClicked: {
            var index = categories.pushBack(nameField.text)
            categoriesChanged()

            caller.selectedIndex = index
            PopupUtils.close(dialogue)
        }
    }

    Component.onCompleted: nameField.forceActiveFocus()
}
