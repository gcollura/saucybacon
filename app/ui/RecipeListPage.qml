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
import Ubuntu.Components.ListItems 0.1
import U1db 1.0 as U1db

import "../components"

Page {
    id: page

    title: i18n.tr("All Recipes")
    anchors.fill: parent

    actions: [ newRecipeAction, searchAction ]

    tools: ToolbarItems {
        ToolbarButton {
            action: aboutAction
        }
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
                clip: true
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
                clip: false
                topMargin: units.gu(9.5)
            }
        }
    ]

    flickable: !wideAspect ? recipeListView : null

    Label {
        visible: recipesdb.count == 0

        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            right: parent.right
            margins: units.gu(2)
        }
        text: i18n.tr("No Recipes!\n\nGo to Search tab\nTap on New to create a new recipe")
        elide: Text.ElideRight
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
        fontSize: "large"
    } 

    Sidebar {
        id: sidebar
        expanded: wideAspect && recipesdb.count > 0
        anchors.topMargin: units.gu(9.5)

        Column {
            anchors {
                left: parent.left
                right: parent.right
            }

            Standard {
                text: i18n.tr("All")
                onClicked: { filter(""); favorites(false) }
            }

            Standard {
                text: i18n.tr("Favorites")
                onClicked: { favorites(true) }
            }

            Header {
                text: i18n.tr("Categories")
            }

            Repeater {
                model: categories
                Standard {
                    text: modelData
                    onClicked: filter(modelData)
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

        GridView {
            objectName: "recipesListView"
            id: recipeListView

            anchors {
                fill: parent
                margins: units.gu(1)
            }

            visible: recipesdb.count > 0
            clip: false
  
            cellWidth: width / Math.floor(width / units.gu(16.5))
            cellHeight: 4 / 3 * cellWidth + units.gu(4)
            model: recipesdb

            property string filter
            property bool onlyfav

            delegate: RecipeSquareListItem {
                width: recipeListView.cellWidth
                height: recipeListView.cellHeight

                visible: (recipeListView.filter.length > 0 ? contents.category == recipeListView.filter : true)
                         && (recipeListView.onlyfav ? contents.favorite : true) && typeof contents.name !== 'undefined'
            }
        }
    }


    function filter(name) {
        recipeListView.filter = name;
    }
    function favorites(show) {
        recipeListView.onlyfav = show;
    }
}
