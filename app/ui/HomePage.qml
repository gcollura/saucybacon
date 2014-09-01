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
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0
import Ubuntu.Layouts 1.0
import U1db 1.0 as U1db

import "../components"

Page {
    id: page

    title: i18n.tr("All Recipes")

    actions: [ newRecipeAction, searchAction ]

    tools: ToolbarItems {
        ToolbarButton {
            action: aboutAction
        }
        ToolbarButton {
            action: newRecipeAction
        }
    }

    property Flickable pageFlickable
    flickable: wideAspect ? null : pageFlickable

    U1db.Query {
        id: recipesQuery
        index: recipes
        query: "*"
    }

    Layouts {
        id: layouts
        anchors.fill: parent

        layouts: [
            ConditionalLayout {
                name: "firstStartLayout"
                when: recipesdb.count == 0

                Label {
                    id: firstStartLabel

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
            },

            ConditionalLayout {
                name: "tabletLayout"
                when: wideAspect && recipesdb.count > 0

                Row {
                    anchors.fill: parent

                    Sidebar {
                        id: sidebar
                        mode: "left"
                        anchors {
                            top: parent.top
                            bottom: parent.bottom
                        }

                        property string selectedItem

                        Column {
                            anchors {
                                left: parent.left
                                right: parent.right
                            }

                            Standard {
                                text: i18n.tr("All")
                                progression: sidebar.selectedItem == text
                                onClicked: { 
                                    filter("name", "*");
                                    sidebar.selectedItem = text;
                                }
                                Component.onCompleted: sidebar.selectedItem = text
                            }

                            Standard {
                                text: i18n.tr("Favorites")
                                progression: sidebar.selectedItem == text
                                onClicked: { 
                                    filter("favorite", true);
                                    sidebar.selectedItem = text;
                                }
                            }

                            Header {
                                text: i18n.tr("Categories")
                            }

                            Repeater {
                                model: categories
                                Standard {
                                    text: modelData
                                    progression: sidebar.selectedItem == text
                                    onClicked: { 
                                        filter("category", modelData); 
                                        sidebar.selectedItem = modelData; 
                                    }
                                }
                            }

                            Header {
                                text: i18n.tr("Restrictions")
                            }

                            Repeater {
                                model: restrictions
                                Standard {
                                    text: modelData
                                    progression: sidebar.selectedItem == text
                                    onClicked: { 
                                        filter("restriction", index); 
                                        sidebar.selectedItem = modelData; 
                                    }
                                }
                            }
                        }
                    }

                    ItemLayout {
                        item: "gridView"
                        anchors {
                            top: parent.top
                            bottom: parent.bottom
                        }
                        width: parent.width - sidebar.width
                    }
                }
            }
        ]

        GridView {
            id: gridView
            Layouts.item: "gridView"
            objectName: "gridView"

            anchors {
                fill: parent
                margins: units.gu(1)
            }

            clip: wideAspect

            cellWidth: width / Math.floor(width / units.gu(16))
            cellHeight: 4 / 3 * cellWidth

            model: recipesQuery

            property string filter
            property bool onlyfav

            delegate: SquareListItem {
                width: gridView.cellWidth
                height: gridView.cellHeight

                title: contents.name
                imageSource: contents.photos[0] ? contents.photos[0] : ""
                favorite: contents.favorite
                restriction: contents.restriction
                difficulty: contents.difficulty
            }

            Component.onCompleted: pageFlickable = gridView
        }
    }

    function filter(prop, expression) {
        var query = { }
        query[prop] = expression;
        recipesQuery.query = query;
    }
}
