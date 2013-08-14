import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1

Page {
    title: i18n.tr("Search")

    Rectangle {
        // Column feels awkward with a listview
        anchors.fill: parent
        color: "transparent"

        Row {
            id: searchRow
            anchors.horizontalCenter: parent.horizontalCenter

            width: parent.width - units.gu(4)
            height: units.gu(8)
            spacing: units.gu(2)

            TextField {
                id: searchField
                anchors.verticalCenter: parent.verticalCenter

                width: parent.width - units.gu(7)
                placeholderText: "Searching for a new recipe..."

                onAccepted: search(searchField.text)
                onTextChanged: searchLocally(searchField.text)
            }

            Button {
                id: searchButton
                anchors.verticalCenter: parent.verticalCenter

                width: units.gu(5)
                height: searchField.height

                onClicked: search(searchField.text)
            }
        }

        ListView {
            id: resultList
            width: parent.width
            anchors {
                top: searchRow.bottom
                bottom: parent.bottom
            }

            model: db

            /* A delegate will be created for each Document retrieved from the Database */
            delegate: Empty {
            }
        }

    }

    function search(querystr) {
        // Since the number of the api calls is limited,
        // it's better to keep the online search a real request by the user
        // TODO: have money to buy a unlimited API

        console.log("Perfoming remote search...");
    }

    function searchLocally(querystr) {
        // Perform a local search on our personal db
        // this function can be called everytime the user write text in the entry

        console.log("Performing local search...");
    }
}
