import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Qt.labs.folderlistmodel 1.0

Dialog {
    id: dialogue
    title: i18n.tr("Add a Photo")
    text: i18n.tr("Locate the photo file.")

    property string folderPath: "/home" // TODO: Write c++ plugin to retrieve user informations
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
            nameFilters: [ "*.png", "*.jpg" ]
            showDirsFirst: true
        }

        Component {
            id: fileDelegate
            ListItem.Standard {
                text: fileName
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
                        if (fileName.split(".").pop() === "png"
                                || fileName.split(".").pop() === "jpg") {
                            file = "/" + fileName

                            caller.addPhoto(folderPath + file);
                            PopupUtils.close(dialogue)
                        }
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
            PopupUtils.close(dialogue)

        }
    }
}
