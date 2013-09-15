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
    id: root

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

    Row {
        id: photoRow
        spacing: units.gu(2)

        Button {
            iconSource: icon("32/import-image", true)
            height: iconSize
            width: height

            visible: editable

            onClicked: selectPhoto();
        }

        Repeater {
            id: repeater
            model: photos

            delegate: UbuntuShape {
                id: photo
                width: iconSize
                height: width

                property bool expanded: false
                property int idx: index
                property string source: modelData

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
                            showPhoto(photo)
                        }
                    }
                }
            }
        }
    }

    function showPhoto(caller) {
        PopupUtils.open(previewerComponent, caller);
    }

    function selectPhoto() {
        PopupUtils.open(Qt.resolvedUrl("../components/PhotoChooser.qml"), root);
    }

    function addPhoto(filename) {
        photos.pushBack(filename);
        photosChanged();
    }

    function removePhoto(index) {
        photos.splice(index, 1);
        photosChanged();
    }

    Component {
        id: previewerComponent

        Previewer {
            id: previewer
            Image {
                id: image

                height: Math.min(mainView.height - units.gu(4), sourceSize.height)
                width: Math.min(mainView.width - units.gu(4), sourceSize.width)

                source: caller ? caller.source : ""
                fillMode: Image.PreserveAspectFit
            }
        }
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
                        text: modelData

                        onClicked: {
                            if (index === 0)
                                removePhoto(caller.idx)
                            else if (index === 1)
                                showPhoto(caller)

                            hide();
                        }
                    }
                }
            }
        }
    }
}
