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
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0
import Ubuntu.Layouts 1.0

import "../components"

Page {
    id: page

    title: sidePanelContent.selectedItem

    property var actions: [
        // refreshAction,
        newRecipeAction,
        searchAction
    ]
    property bool backVisible: false
    flickable: null

    // Connections {
    //     target: database
    //     onIsEmptyChanged: {
    //         console.log("isEmpty", isEmpty);
    //         if (database.isEmpty) {
    //             state = "firstLaunch";
    //         } else {
    //             state = "default";
    //         }
    //         console.log("layouts.visible", layouts.visible);
    //     }
    // }

    Action {
        id: defaultBackAction
        iconName: "back"
        visible: backVisible && !wideAspect
        onTriggered: sidePanelContent.resetSelection()
    }

    state: "default"
    states: [
        State {
            name: "default"
            when: !database.isEmpty
            PropertyChanges {
                target: page.head
                actions: page.actions
                backAction: defaultBackAction
            }
            // Restore visibility manually, if not we may encounter bugs.
            PropertyChanges {
                target: layouts
                visible: true
            }
            PropertyChanges {
                target: welcomeItem
                visible: false
            }
        },
        PageHeadState {
            name: "filter"
            extend: "default"
            head: page.head
            backAction: Action {
                iconName: "back"
                onTriggered: {
                    sidePanel.close()
                    page.state = "default"
                }
            }
        },
        State {
            name: "firstLaunch"
            when: database.isEmpty
            PropertyChanges {
                target: page
                title: i18n.tr("Welcome to SaucyBacon")
            }
            PropertyChanges {
                target: layouts
                visible: false
            }
            PropertyChanges {
                target: welcomeItem
                opacity: 1
            }
        }
    ]

    WelcomeItem {
        id: welcomeItem
        anchors.fill: parent
        opacity: 0
        actions: page.actions

        Behavior on opacity {
            UbuntuNumberAnimation { duration: 1000 }
        }
    }

    Layouts {
        id: layouts
        anchors.fill: parent
        visible: true
        layouts: [
            ConditionalLayout {
                name: "wideAspect"
                when: wideAspect

                RowLayout {
                    anchors.fill: parent
                    spacing: 0
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

        UbuntuShape {
            id: tip
            objectName: "bottomEdgeTip"

            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
                bottomMargin: -units.gu(1)
                Behavior on bottomMargin {
                    SequentialAnimation {
                        // wait some msecs in case of the focus change again, to avoid flickering
                        PauseAnimation {
                            duration: 300
                        }
                        UbuntuNumberAnimation {
                            duration: UbuntuAnimation.SnapDuration
                        }
                    }
                }
            }

            z: 1
            width: tipLabel.paintedWidth + units.gu(6)
            height: units.gu(4)
            color: Theme.palette.normal.background
            Label {
                id: tipLabel

                text: i18n.tr("Filter")
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                    topMargin: units.dp(4)
                }
                horizontalAlignment: Text.AlignHCenter
                opacity: tip.hidden ? 0.0 : 1.0
                Behavior on opacity {
                    UbuntuNumberAnimation {
                        duration: UbuntuAnimation.SnapDuration
                    }
                }
            }
        }

        Panel {
            id: sidePanel
            align: Qt.AlignBottom
            anchors.fill: parent

            z: 100

            Rectangle {
                id: sidePanelBackground
                anchors.fill: parent
                color: colors.darkerRed
            }

            SidePanelContent {
                id: sidePanelContent
                Layouts.item: "panelContent"

                anchors.fill: parent

                onFilter: page.filter(type, id)
                onSelectedItemChanged: sidePanel.close()
            }

            onOpenedChanged: {
                if (opened) {
                    page.state = "filter"
                } else {
                    page.state = "default"
                }
            }
        }

        GridView {
            id: gridView
            objectName: "gridView"
            Layouts.item: "gridView"

            anchors {
                fill: parent
                leftMargin: units.gu(1)
                rightMargin: units.gu(1)
            }

            header: Item {
                height: wideAspect ? 0 : units.gu(1)
            }

            footer: Item {
                height: wideAspect ? 0 : units.gu(1)
            }

            clip: true

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
        }
    }

    function filter(type, id) {
        if (type === "") {
            backVisible = false;
        } else {
            backVisible = true;
        }
        var query = { "type": type, "id": id };
        database.filter = query;
    }

}
