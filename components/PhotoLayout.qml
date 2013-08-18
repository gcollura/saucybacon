import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1

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

    // Component properties
    property var photos: [ ]
    property bool editable: true
    property int iconSize: units.gu(8)

    Row {
        id: photoRow
        spacing: units.gu(2)

        Button {
            iconSource: icon("import-image")
            height: iconSize
            width: height

            visible: editable

            onClicked: photoRow.selectPhoto();
        }

        Repeater {
            id: repeater
            model: [ ]

            UbuntuShape {
                id: photo
                height: iconSize
                width: height

                image: Image {
                    source: modelData
                    fillMode: Image.PreserveAspectCrop
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: editable ? photoRow.removePhoto(index) : photoRow.showPhoto(index);
                }
            }

        }

        function showPhoto(index) {

        }

        function selectPhoto() {
            console.log("Open a file browser to choose an image!");
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

}
