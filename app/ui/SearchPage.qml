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

Page {
    title: i18n.tr("Search is not implemented, due to some u1db bugs")

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
            left: parent.left
            right: parent.right
            fill: parent
        }

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

                iconSource: icon("search")

                onClicked: search(searchField.text)
            }
        }

        ListView {
            id: resultList
            width: parent.width
            height: parent.height - searchRow.height
            anchors {
                left: parent.left
                right: parent.right
            }

            model: searchQuery

            /* A delegate will be created for each Document retrieved from the Database */
            delegate: ListItem.Standard {
                text: "%1".arg(contents.difficulty)
                onClicked: console.log(JSON.stringify(contents))
            }
        }

    }

    function search(querystr) {
        // Since the number of the api calls is limited,
        // it's better to keep the online search a real request by the user
        // TODO: have money to buy an unlimited API

        console.log("Perfoming remote search...");
    }

    function searchLocally(querystr) {
        // Perform a local search on our personal db
        // this function can be called everytime the user write text in the entry

        //searchQuery.query = [ {"title": querystr + "*" , "name": querystr + "*" }]
        resultList.model = searchQuery.query
        console.log(JSON.stringify(searchQuery))
    }
}
