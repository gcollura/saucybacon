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

    Row {
        id: photoRow
        spacing: units.gu(2)

        Button {
            iconSource: icon("import-image")
            height: units.gu(8)
            width: height

            visible: editable

            onClicked: photoRow.selectPhoto();
        }

        Repeater {
            id: repeater
            model: [ ]

            UbuntuShape {
                id: photo
                height: units.gu(8)
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
        }

        function removePhoto(index) {
            photos.splice(index, 1);
        }
    }

    onPhotosChanged: {
        repeater.model = photos
    }

}
