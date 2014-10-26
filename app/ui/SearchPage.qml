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
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import Ubuntu.Layouts 1.0
import U1db 1.0 as U1db
import SaucyBacon 1.0

import "../components"

Page {
    id: page
    title: i18n.tr("Search")

    actions: [
        Action {
            id: searchTopRatedAction
            text: i18n.tr("Top Rated")
            description: i18n.tr("Search top rated recipes")
            iconName: "favorite-selected"
            keywords: "search;top;rated;recipe"
            onTriggered: { searchOnline(""); }
        }
    ]

    tools: ToolbarItems {
        ToolbarButton {
            objectName: "searchTopRatedAction"
            action: searchTopRatedAction
        }
    }

    LoadingIndicator {
        id: loadingIndicator
        text: i18n.tr("Searching...")
        isShown: search.loading
    }

    Layouts {
        id: layouts
        anchors.fill: parent

        layouts: [
            ConditionalLayout {
                name: "tabletLayout"
                when: wideAspect

                Row {
                    anchors.fill: parent

                    Sidebar {
                        id: sidebar
                        mode: "left"
                        anchors {
                            top: parent.top
                            bottom: parent.bottom
                        }
                        height: page.height

                        Column {
                            anchors {
                                left: parent.left
                                right: parent.right
                            }

                            ListItem.Header {
                                text: i18n.tr("Search history")
                            }

                            Repeater {
                                model: database.searches

                                ListItem.Standard {
                                    text: modelData.name
                                    onClicked: {
                                        searchField.text = modelData.name;
                                        searchOnline(modelData.name);
                                    }
                                }
                            }
                        }
                    }

                    ItemLayout {
                        item: "searchColumn"
                        anchors {
                            top: parent.top
                            bottom: parent.bottom
                            margins: units.gu(2)
                        }
                        width: parent.width - sidebar.width
                    }
                }
            }
        ]

        Column {
            id: searchColumn
            Layouts.item: "searchColumn"
            objectName: "searchColumn"

            anchors {
                fill: parent
                topMargin: units.gu(2)
                bottomMargin: units.gu(2)
            }
            spacing: units.gu(2)

            Row {
                id: searchRow

                anchors {
                    left: parent.left
                    right: parent.right
                    margins: units.gu(2)
                }
                spacing: units.gu(2)

                TextField {
                    id: searchField
                    objectName: "searchField"

                    width: parent.width
                    placeholderText: "Search for a recipe..."

                    onAccepted: searchOnline(searchField.text)
                    onTextChanged: searchLocally(searchField.text)

                    Behavior on width { UbuntuNumberAnimation { } }
                }
            }

            Label {
                id: creditLabel
                anchors {
                    right: parent.right
                    rightMargin: units.gu(4)
                }
                text: i18n.tr("Powered by Food2Fork.com")
                fontSize: "small"
            }

            RefreshableListView {
                id: resultList
                objectName: "resultList"
                anchors {
                    left: parent.left
                    right: parent.right
                }

                height: parent.height - searchRow.height - creditLabel.height - units.gu(2)
                clip: true

                model: search

                /* A delegate will be created for each Document retrieved from the Database */
                delegate: ListItem.Subtitled {
                    progression: true
                    iconSource: contents.image_url
                    text: contents.title
                    subText: contents.publisher_url
                    onClicked: {
                        database.getRecipeOnline(contents.recipe_id, contents.source_url, contents.publisher_url, contents.image_url);
                        pageStack.push(Qt.resolvedUrl("RecipePage.qml"));
                    }
                }

                onPulledUp: {
                    console.log("Load more results")
                    oldContentY = contentY;
                    search.loadMore();
                }

                property double oldContentY;

                Scrollbar {
                    flickableItem: resultList
                }
            }
        }
    }

    RecipeSearch {
        id: search
        onLoadingError: {
            loadingIndicator.text = i18n.tr("Loading error, please try again");
        }
        onLoadingCompleted: {
            if (search.page > 1) {
                resultList.contentY = resultList.oldContentY + units.gu(3);
            }
        }

    }

    function searchOnline(querystr) {
        // Since the number of the api calls is limited,
        // it's better to keep the online search a real request by the user
        // TODO: have money to buy an unlimited API

        console.log("Perfoming remote search...");
        loadingIndicator.text = i18n.tr("Searching...");
        search.query = querystr;

        if (querystr.length > 0) {
            database.addSearch(querystr);
        }
    }

    function searchLocally(querystr) {
        // Perform a local search on our personal db
        // this function can be called everytime the user write text in the entry

        //searchQuery.query = [ {"title": querystr + "*" , "name": querystr + "*" }]
    }
}
