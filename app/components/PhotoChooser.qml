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
import SaucyBacon 0.1
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Qt.labs.folderlistmodel 1.0

Dialog {
    id: dialogue
    title: i18n.tr("Add a Photo")
    text: i18n.tr("Locate the photo file.")

    property string folderPath: utils.path(Utils.PicturesLocation);
    property string file: ""

    onFileChanged: {
        var path = folderPath + file
    }

    Label {
        id: folder
        text: folderPath + file
    }

    ListView {
        clip: true
        height: units.gu(30)
        FolderListModel {
            id: folderModel
            folder: folderPath
            showDotAndDotDot: true
            nameFilters: [ "*.png", "*.jpg", "*.jpeg" ]
            showDirsFirst: true
        }

        Component {
            id: fileDelegate
            ListItem.Standard {
                Label {
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        margins: units.gu(2)
                    }
                    text: fileName
                    fontSize: "medium"
                    color: "white" // FIXME: hardcoded colors
                }

                onClicked: {
                    var split = folder.text.split("/")
                    if (fileName == "..") {
                        if (split.length > 2) {
                            for (var i = 1, newFolder = ""; i < split.length - 1; i++) {
                                newFolder = newFolder + "/" + split[i]
                            }
                        } else {
                            newFolder = "/"
                        }
                    } else if (fileName == ".") {
                        newFolder = "/"
                    } else {
                        if (folder.text != "/") newFolder = folder.text + "/" + fileName
                        else newFolder = "/" + fileName
                    }
                    if (folderModel.isFolder(index)) {
                        folderPath = newFolder
                        file = "";
                    } else {
                        file = "/" + fileName

                        caller.addPhoto(folderPath + file);
                        PopupUtils.close(dialogue)
                    }
                }
            }
        }

        model: folderModel
        delegate: fileDelegate
    }
    Button {
        text: i18n.tr("Cancel")
        gradient: UbuntuColors.greyGradient
        onClicked: PopupUtils.close(dialogue)
    }
    Button {
        text: i18n.tr("Acquire from Camera")
        onClicked: {
            PopupUtils.close(dialogue);
            pageStack.push(cameraPage);
        }
    }
}
