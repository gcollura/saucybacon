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
import U1db 1.0 as U1db

import "../components"

Page {
    id: page

    title: i18n.tr("Recipes")
    anchors.fill: parent

    tools: ToolbarItems {
        ToolbarButton {
            action: newRecipeAction
        }
    }

    states: [
        State {
            name: "wide"
            when: wideAspect

            PropertyChanges {
                target: recipeListView

                anchors.top: contents.top
                anchors.topMargin: units.gu(9.5)
                topMargin: 0
            }

            PropertyChanges {
                target: contents

                anchors.top: page.top
                anchors.topMargin: 0
            }
        },

        State {
            name: ""

            PropertyChanges {
                target: recipeListView

                topMargin: units.gu(9.5)
            }
        }
    ]

    flickable: !wideAspect ? recipeListView : null

    Sidebar {
        id: sidebar
        expanded: wideAspect
        anchors.topMargin: units.gu(9.5)

        Column {
            anchors {
                left: parent.left
                right: parent.right
            }

            Standard {
                text: i18n.tr("All")
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
        id: contents

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: sidebar.right
            right: parent.right
        }

        ListView {
            objectName: "recipesListView"
            id: recipeListView

            anchors.fill: parent
            clip: true

            model: recipesdb

            delegate: RecipeListItem { }
        }
    }

    function filter(name) {

    }

    U1db.Index {

    }

    U1db.Query {

    }

}
