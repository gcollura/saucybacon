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
import Ubuntu.Components.ListItems 0.1
import "../components"

Page {
    title: i18n.tr("Recipes")

    tools: ToolbarItems {
        ToolbarButton {
            action: newAction
        }
    }

    Sidebar {
        id: sidebar
        expanded: wideAspect

        Column {
            anchors {
                left: parent.left
                right: parent.right
            }

            Standard {
                text: i18n.tr("Favorites")
            }

            Header {
                text: i18n.tr("Categories")
            }

            Repeater {
                model: categories
                Standard {
                    text: modelData
                }
            }
        }
    }

    Item {
        anchors {
            left: sidebar.right
            top: parent.top
            right: parent.right
            bottom: parent.bottom
        }

        ListView {
            objectName: "recipesListView"
            id: listView

            anchors.fill: parent
            clip: true

            model: recipesdb

            /* A delegate will be created for each Document retrieved from the Database */
            delegate: RecipeListItem {
            }

            Scrollbar {
                flickableItem: listView
            }
        }

    }

}
