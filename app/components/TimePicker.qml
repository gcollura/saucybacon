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
import Ubuntu.Components.Pickers 1.0
import Ubuntu.Components.Popups 1.0

Button {
    id: root

    text: time.toTime()
    property int time: 0

    onClicked: {
        PopupUtils.open(dialog, root);
    }

    gradient: colors.redGradient

    Component {
        id: dialog

        Dialog {
            id: dialogue
            title: i18n.tr("Pick a time")

            DatePicker {
                id: picker
                mode: "Hours|Minutes"
                date: new Date(2014, 3, 14, Math.floor(root.time / 60), root.time % 60, 0)
            }

            Button {
                text: i18n.tr("Accept")
                gradient: UbuntuColors.orangeGradient
                onClicked: {
                    root.time = picker.date.getMinutes() + picker.date.getHours() * 60;
                    print("Picked time=" + Qt.formatTime(picker.date, "hh:mm"));
                    PopupUtils.close(dialogue);
                }
            }

            Button {
                text: i18n.tr("Cancel")
                onClicked: {
                    PopupUtils.close(dialogue);
                }
            }
        }
    }
}
