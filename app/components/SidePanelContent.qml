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
import Ubuntu.Components.ListItems 1.0

Column {
    id: root
    property string selectedItem

    signal filter(string type, int id)

    Standard {
        text: i18n.tr("All recipes")
        progression: root.selectedItem == text
        onClicked: {
            filter("", "");
            root.selectedItem = text;
        }
        Component.onCompleted: root.selectedItem = text
    }

    Standard {
        text: i18n.tr("Favorites")
        progression: root.selectedItem == text
        onClicked: {
            filter("favorite", 1);
            root.selectedItem = text;
        }
    }

    Header {
        text: i18n.tr("Categories")
    }

    Repeater {
        model: database.categories
        StandardWithCount {
            text: modelData.name
            count: modelData.count
            progression: root.selectedItem == text
            visible: count > 0
            onClicked: {
                filter("category", modelData.id);
                root.selectedItem = modelData.name;
            }
        }
    }

    Header {
        text: i18n.tr("Restrictions")
    }

    Repeater {
        model: database.restrictions
        StandardWithCount {
            text: modelData.name
            count: modelData.count
            progression: root.selectedItem == text
            visible: count > 0
            onClicked: {
                filter("restriction", index);
                root.selectedItem = modelData.name;
            }
        }
    }
}

