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
import Ubuntu.Components.ListItems 1.0

Flickable {
    id: root
    anchors {
        fill: parent
    }
    contentHeight: column.height
    interactive: contentHeight > parent.height
    clip: true

    property Item __selectedItem
    readonly property string selectedItem: __selectedItem.text
    readonly property bool isDefaultSelected: __selectedItem == defaultSelection
    signal filter(string type, int id)

    function resetSelection() {
        defaultSelection.clicked()
    }

    function filterModel(model) {
        var result = [];
        for (var i = 0; i < model.length; i++) {
            if (model[i].count > 0) {
                result.push(model[i]);
            }
        }
        return result;
    }

    Connections {
        target: database
        onRecipesChanged: {
            if (database.recipes.length === 0 && __selectedItem != defaultSelection) {
                resetSelection();
            }
        }
    }

    Column {
        id: column
        anchors {
            left: parent.left
            right: parent.right
        }

        Standard {
            id: defaultSelection
            text: i18n.tr("All recipes")
            progression: root.__selectedItem == defaultSelection
            onClicked: {
                filter("", "");
                root.__selectedItem = defaultSelection;
            }
            Component.onCompleted: root.__selectedItem = defaultSelection
        }

        StandardWithCount {
            id: favoriteSelection
            text: i18n.tr("Favorites")
            progression: root.__selectedItem == favoriteSelection
            count: database.favoriteCount
            visible: database.favoriteCount > 0
            onClicked: {
                filter("favorite", 1);
                root.__selectedItem = favoriteSelection;
            }
        }

        Header {
            text: i18n.tr("Categories")
            visible: categoriesRepeater.model.length > 0
        }

        Repeater {
            id: categoriesRepeater
            model: filterModel(database.categories)
            StandardWithCount {
                id: categorySelection
                text: modelData.name
                count: modelData.count
                progression: root.__selectedItem == categorySelection
                onClicked: {
                    filter("category", modelData.id);
                    root.__selectedItem = categorySelection;
                }
            }
        }

        Header {
            text: i18n.tr("Restrictions")
        }

        Repeater {
            model: filterModel(database.restrictions)
            StandardWithCount {
                id: restrictionSelection
                text: modelData.name
                count: modelData.count
                progression: root.__selectedItem == restrictionSelection
                onClicked: {
                    filter("restriction", index);
                    root.__selectedItem = restrictionSelection;
                }
            }
        }
    }
}
