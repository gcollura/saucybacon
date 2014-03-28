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
import Ubuntu.Components.Popups 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Content 0.1
import SaucyBacon 0.1

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
    property int iconSize: units.gu(8)

    property var activeTransfer: null

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
        activeTransfer = picSourceMulti.request();
    }

    function addPhoto(filename) {
        photos.pushBack(filename);
        photosChanged();
    }

    function removePhoto(index) {
        photos.splice(index, 1);
        photosChanged();
    }

    ContentPeer {
        id: picSourceMulti
        contentType: ContentType.Pictures
        handler: ContentHandler.Source
        selectionType: ContentTransfer.Multiple
    }

    // ContentHub features
    ContentTransferHint {
        id: importHint
        anchors.fill: parent
        activeTransfer: root.activeTransfer
    }

    Connections {
        target: root.activeTransfer
        onStateChanged: {
            if (root.activeTransfer.state === ContentTransfer.Charged) {
                var importItems = root.activeTransfer.items;
                for (var i = 0; i < importItems.length; i++) {
                    // TODO: Use QUrl::fromLocalFile to decode the path
                    // Workaround: QFile doesn't play well with "file://" prefix
                    var importedItem = importItems[i].url.toString().replace("file://", "");
                    var filename = utils.fileName(importedItem);
                    filename = utils.path(Utils.SettingsLocation, "imgs/" + filename);

                    if (!utils.cp(importedItem, filename)) {
                        console.log(" *** ERROR: utils.cp() failed (%1 -> %2)".arg(importedItem).arg(filename));
                        continue;
                    }

                    photos.pushBack(filename);
                }
                photosChanged();
            }
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
