/*
 * Copyright (C) 2013 Michael Spencer <sonrisesoftware@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authored by: Michael Spencer <sonrisesoftware@gmail.com>
 */

import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1

Rectangle {
    id: root

    color: Qt.rgba(0.2,0.2,0.2,0.4)

    property string mode: "left" // or "right"

    VerticalDivider {
        mode: root.mode

        anchors {
            top: parent.top
            bottom: parent.bottom
            right: mode === "left" ? parent.right : undefined
            left: mode === "right" ? parent.left : undefined
            rightMargin: -1
        }
    }

    width: 0.37 * parent.width//units.gu(35)

    default property alias contents: contents.data

    property bool autoFlick: true

    Flickable {
        id: flickable

        clip: true

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            rightMargin: mode === "left" ? 1 : 0
            leftMargin: mode === "right" ? 1 : 0
        }

        contentWidth: width
        contentHeight: autoFlick ? contents.height : height
        interactive: contentHeight > height

        Item {
            id: contents

            width: flickable.width
            height: autoFlick ? childrenRect.height : flickable.height
        }

        function getFlickableChild(item) {
            if (item && item.hasOwnProperty("children")) {
                for (var i=0; i < item.children.length; i++) {
                    var child = item.children[i];
                    if (internal.isVerticalFlickable(child)) {
                        if (child.anchors.top === page.top || child.anchors.fill === page) {
                            return item.children[i];
                        }
                    }
                }
            }
            return null;
        }
    }

    Scrollbar {
        flickableItem: flickable
    }
}
