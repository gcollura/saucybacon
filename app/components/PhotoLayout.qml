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
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0
import Ubuntu.Components.ListItems 1.0 as ListItem
import Ubuntu.Content 1.0
import SaucyBacon 1.0

Flickable {
    id: root

    height: photoRow.height

    contentWidth: photoRow.width
    interactive: contentWidth > width

    flickableDirection: Flickable.HorizontalFlick
    clip: true

    // Component properties
    property var photos: [ ]
    property bool editable: true
    property int iconSize: units.gu(10)

    Row {
        id: photoRow
        spacing: units.gu(2)

        Button {
            iconSource: icon("32/import-image", true)
            height: iconSize
            width: height

            visible: editable

            onClicked: selectPhoto()
            gradient: colors.redGradient
        }

        Repeater {
            id: repeater
            model: photos

            delegate: UbuntuShape {
                id: photo
                width: iconSize
                height: editable ? width : 1.5 * iconSize

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
        root.forceActiveFocus()
        imageImport.requestNewImage()
    }

    function addPhoto(filename) {
        photos.pushBack(filename);
        photosChanged();
    }

    function removePhoto(index) {
        photos.splice(index, 1);
        photosChanged();
    }

    ImageImport {
        id: imageImport
        onImageReceived: {
            var destDir = utils.path(Utils.SettingsLocation, "imgs/")
            var filename = utils.path(destDir, utils.fileName(imageUrl))

            if (utils.exists(filename)) {
                console.log("File %1 already existed".arg(filename))
            } else if (utils.cp(imageUrl, filename)) {
                console.log("Moved file: %1 to %2".arg(imageUrl).arg(destDir))
            } else {
                console.error("Failed to move %1 to %2".arg(imageUrl).arg(filename))
                return
            }

            console.log(imageUrl, filename)
            addPhoto(filename)
        }
    }

    Component {
        id: previewerComponent

        Previewer {
            id: previewer
            Image {
                id: image

                height: mainView.height - units.gu(4)
                width: mainView.width - units.gu(4)

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
