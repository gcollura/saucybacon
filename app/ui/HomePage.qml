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
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0
import Ubuntu.Layouts 1.0

import "../components"

Page {
    id: page

    title: sidePanelContent.selectedItem

    tools: ToolbarItems {
        ToolbarButton {
            action: refreshAction
        }
        ToolbarButton {
            action: newRecipeAction
        }
        ToolbarButton {
            action: searchAction
        }
    }
    actions: [ refreshAction, newRecipeAction, searchAction ]

    property Flickable pageFlickable
    flickable: wideAspect ? null : pageFlickable

    Layouts {
        id: layouts
        anchors.fill: parent
        layouts: [
            ConditionalLayout {
                name: "wideAspect"
                when: wideAspect

                RowLayout {
                    anchors.fill: parent
                    Rectangle {
                        id: sidebar
                        anchors {
                            top: parent.top
                            bottom: parent.bottom
                        }
                        width: units.gu(35)
                        color: Qt.rgba(0.2, 0.2, 0.2, 0.4)
                        ItemLayout {
                            item: "panelContent"
                            anchors.fill: parent
                        }
                    }
                    Item {
                        anchors {
                            top: parent.top
                            bottom: parent.bottom
                        }
                        Layout.fillWidth: true
                        ItemLayout {
                            item: "gridView"
                            anchors.fill: parent
                        }
                    }
                }
            }
        ]

        Panel {
            id: sidePanel
            align: Qt.AlignBottom
            anchors {
                fill: parent
                topMargin: header.height
            }

            z: 100

            Rectangle {
                id: sidePanelBackground
                anchors.fill: parent
                color: colors.darkerRed
            }

            Rectangle {
                id: sidePanelHandler
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
                height: units.gu(3)
                color: Qt.rgba(0, 0, 0, 0.4)
            }

            SidePanelContent {
                id: sidePanelContent
                Layouts.item: "panelContent"

                anchors {
                    fill: parent
                    topMargin: units.gu(3)
                }

                onFilter: page.filter(type, id)
                onSelectedItemChanged: sidePanel.close()
            }
        }

        GridView {
            id: gridView
            objectName: "gridView"
            Layouts.item: "gridView"

            anchors {
                fill: parent
                margins: units.gu(1)
            }

            clip: wideAspect

            cellWidth: width / Math.floor(width / units.gu(16))
            cellHeight: 4 / 3 * cellWidth

            model: database.recipes

            delegate: SquareListItem {
                width: gridView.cellWidth
                height: gridView.cellHeight

                title: modelData.name
                imageSource: modelData.photos[0] ? modelData.photos[0] : ""
                favorite: modelData.favorite
                restriction: modelData.restriction
            }

            Component.onCompleted: pageFlickable = gridView
        }
    }

    function filter(type, id) {
        var query = { "type": type, "id": id }
        database.filter = query;
    }

}
