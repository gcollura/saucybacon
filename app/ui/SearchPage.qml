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
import Ubuntu.Components.ListItems 0.1 as ListItem
import U1db 1.0 as U1db
import SaucyBacon 0.1

Page {
    title: i18n.tr("Search")

    U1db.Index {
        database: recipesdb
        id: searchIndex
        expression: [ "name", "category", "difficulty", "veg",
                      "preptime", "cooktime", "totaltime", "ingredients",
                      "directions", "servings", "photos" ]
    }

    U1db.Query {
        id: searchQuery
        index: searchIndex
        query: [{"name":"*"},{ "category":"*"}, {"difficulty":"*", "veg":"*",
                "preptime":"*", "cooktime":"*", "totaltime":"*", "ingredients":"*",
                "directions":"*", "servings":"*", "photos":"*"}]
    }

    Column {
        anchors {
            fill: parent
            margins: units.gu(2)
        }

        spacing: units.gu(2)

        Row {
            id: searchRow

            width: parent.width
            spacing: units.gu(2)

            TextField {
                id: searchField

                width: parent.width - searchButton.width - parent.spacing
                placeholderText: "Searching for a recipe..."

                onAccepted: searchOnline(searchField.text)
                onTextChanged: searchLocally(searchField.text)

                Behavior on width { UbuntuNumberAnimation { } }
            }

            Button {
                id: searchButton
                anchors.verticalCenter: parent.verticalCenter
                visible: !search.searching

                height: searchField.height
                width: units.gu(5)

                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: icon("search", true)
                    sourceSize {
                        height: parent.height - units.gu(1.5)
                        width: parent.width - units.gu(1.5)
                    }
                }

                onClicked: searchOnline(searchField.text)
                Behavior on visible { UbuntuNumberAnimation { } }
            }

            ActivityIndicator {
                id: activity
                anchors.verticalCenter: parent.verticalCenter
                width: searchButton.width
                running: search.searching
                visible: running
            }
        }

//        Label {
//            id: instructions
//            text: "Hello"
//            font.pixelSize: units.gu(20)
//        }

        ListView {
            id: resultList
            anchors {
                left: parent.left
                right: parent.right
                margins: units.gu(-2)
            }

            height: parent.height - searchRow.height
            clip: true

            model: search

            /* A delegate will be created for each Document retrieved from the Database */
            delegate: ListItem.Subtitled {
                icon: contents.image_url
                text: contents.title
                subText: contents.publisher_url
                onClicked: {
                    //console.log(recipe);
                    webPage.title = contents.title
                    webPage.url = contents.source_url
                    pageStack.push(webPage);
                }
            }
        }


    }

    RecipeSearch {
        id: search
    }

    function searchOnline(querystr) {
        // Since the number of the api calls is limited,
        // it's better to keep the online search a real request by the user
        // TODO: have money to buy an unlimited API

        console.log("Perfoming remote search...");
        search.query = querystr;
    }

    function searchLocally(querystr) {
        // Perform a local search on our personal db
        // this function can be called everytime the user write text in the entry

        //searchQuery.query = [ {"title": querystr + "*" , "name": querystr + "*" }]

    }
}
