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
import Ubuntu.Components.Popups 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem

Flickable {
    id: flickable

    anchors {
        left: parent.left
        right: parent.right
    }

    height: photoRow.height

    contentWidth: photoRow.width
    interactive: contentWidth > width

    flickableDirection: Flickable.HorizontalFlick
    clip: true

    // Component properties
    property var photos: [ ]
    property bool editable: true
    property int iconSize: units.gu(8)

    property int currentIndex: 0

    Row {
        id: photoRow
        spacing: units.gu(2)

        Button {
            iconSource: icon("import-image", true)
            height: iconSize
            width: height

            visible: editable

            onClicked: photoRow.selectPhoto();
        }

        Repeater {
            id: repeater
            model: [ ]

            delegate: UbuntuShape {
                id: photo
                width: iconSize
                height: width

                property bool expanded: false

                image: Image {
                    source: modelData
                    asynchronous: true
                    fillMode: Image.PreserveAspectCrop
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (editable)
                            PopupUtils.open(popoverComponent, photo);
                        else {
                            //photoRow.showPhoto(idx);
                            if (!photo.expanded) {
                                width = flickable.parent.width;
                                photo.expanded = !photo.expanded;
                                console.log(flickable.parent.width)
                            } else {
                                width = iconSize;
                                photo.expanded = !photo.expanded;
                            }
                        }
                    }
                }

                // UbuntuNumberAnimation on opacity { from: 0; to: 100 }

            }
        }

        function showPhoto(index) {
            console.log("Not implemented feature.");
        }

        function selectPhoto() {
            PopupUtils.open(Qt.resolvedUrl("../components/PhotoChooser.qml"), photoRow);
        }

        function addPhoto(filename) {
            photos.push(filename);
            // Update the model manually, since push() doesn't trigger
            // the *Changed event
            repeater.model = photos
        }

        function removePhoto(index) {
            photos.splice(index, 1);
            repeater.model = photos
        }
    }

    onPhotosChanged: {
        repeater.model = photos
    }

    Component {
        id: popoverComponent

        Popover {
            Column {
                anchors {
                    left: parent.left
                    top: parent.top
                    right: parent.right
                }
                Repeater {
                    model: [ i18n.tr("Remove"), i18n.tr("View") ]
                    ListItem.Standard {
                        Label {
                            // FIXME: Hack because of Suru theme!
                            anchors {
                                verticalCenter: parent.verticalCenter
                                left: parent.left
                                margins: units.gu(2)
                            }
                            text: modelData

                            color: Theme.palette.normal.overlayText
                        }

                        onClicked: {
                            if (index === 0)
                                photoRow.removePhoto(caller.idx)
                            else if (index === 1)
                                photoRow.showPhoto(caller.idx)

                            hide();
                        }
                    }
                }
            }
        }
    }
}
