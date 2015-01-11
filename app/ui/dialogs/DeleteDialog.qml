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
import Ubuntu.Components.Popups 1.0

// Delete dialog

Dialog {
    id: dialogue
    title: i18n.tr("Confirm deletion")
    text: i18n.tr("Are you sure you want to delete this recipe?")

    Button {
        text: i18n.tr("Delete")
        color: UbuntuColors.red
        onClicked: {
            PopupUtils.close(dialogue);
            deleteAction.trigger();
        }
    }

    Button {
        text: i18n.tr("Cancel")

        onClicked: PopupUtils.close(dialogue)
    }
}
