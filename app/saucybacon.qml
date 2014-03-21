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
import U1db 1.0 as U1db
import SaucyBacon 0.1

import "backend/prototypes.js" as Proto

import "ui"
import "backend"

MainView {
    objectName: "mainView"
    id: mainView

    // NOTE: applicationName needs to match the .desktop filename
    applicationName: "com.ubuntu.developer.gcollura.saucybacon"

    automaticOrientation: true
    anchorToKeyboard: true
    property bool wideAspect: width > units.gu(80)
    property bool extraWideAspect: width > units.gu(130)

    width: units.gu(135)
    height: units.gu(85)

    headerColor: "#6d0a0a"
    backgroundColor: "#540810"
    footerColor: "#370517"

    // Global actions

    Action {
        id: newRecipeAction
        text: i18n.tr("New")
        description: i18n.tr("Create a new recipe")
        iconSource: icon("add")
        keywords: "new;recipe"
        onTriggered: {
            recipe.newRecipe();
            pageStack.push(Qt.resolvedUrl("ui/EditRecipePage.qml"), { title: i18n.tr("New Recipe") });
        }
    }

    Action {
        id: editRecipeAction
        text: i18n.tr("Edit")
        description: i18n.tr("Edit the current recipe")
        iconSource: icon("edit")
        keywords: "edit;recipe"
        onTriggered: pageStack.push(Qt.resolvedUrl("ui/EditRecipePage.qml"), { title: i18n.tr("Edit Recipe") });
    }

    Action {
        id: searchAction
        text: i18n.tr("Search")
        description: i18n.tr("Search for a new recipe on the internet")
        iconSource: icon("edit")
        keywords: "search;new;recipe"
        onTriggered: { pageStack.push(tabs); tabs.selectedTab = searchTab; }
    }

    Action {
        id: aboutAction
        text: i18n.tr("About")
        description: i18n.tr("About this application...")
        iconSource: icon("help")
        keywords: "about;saucybacon"
        onTriggered: { pageStack.push(Qt.resolvedUrl("ui/AboutPage.qml"))}
    }

    actions: [ newRecipeAction, searchAction ]

    PageStack {
        objectName: "pageStack"
        id: pageStack

        Component.onCompleted: {
            push(tabsComponent);
        }

        function back() {
            pageStack.currentPage.tools.back.trigger();
        }

        Component {
            id: tabsComponent
            Tabs {
                objectName: "tabs"
                id: tabs

                onSelectedTabChanged: {
                    if (tabs.selectedTab == searchTab)
                    searchLoader.source = Qt.resolvedUrl("ui/SearchPage.qml")
                }

                Tab {
                    objectName: "recipeListTab"
                    title: page.title
                    page: RecipeListPage {
                        objectName: "recipeListPage"
                        id: recipeListPage
                    }
                }

                Tab {
                    objectName: "searchTab"
                    id: searchTab
                    title: i18n.tr("Search")
                    page: Loader {
                        id: searchLoader
                        parent: searchTab
                        anchors {
                            left: parent.left
                            right: parent.right
                            bottom: parent.bottom
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        loadSettings();
    }

    Component.onDestruction: {
        saveSettings();
    }

    // SaucyBacon Utils library
    Utils {
        id: utils
        property string version: "0.2.0"
    }

    /* Recipe Database */
    U1db.Database {
        id: recipesdb
        path: utils.path(Utils.SettingsLocation, "sb-recipes.db")

        property bool count: recipesdb.listDocs().length
        function update() {
            count = recipesdb.listDocs().length
        }
    }

    /* Base recipe document - just for reference
    U1db.Document {
        database: db
        create: false
        defaults: { "name": "", "category": "", "difficulty": 1, "restriction": 0,
            "preptime": "0", "cooktime": "0", "totaltime": "0", "ingredients": [ ],
            "directions": "", "servings": 4, "photos" : [ ], "favorite": false }
    } */

    property Recipe r: Recipe { id: recipe }
    property var menus: [ ]

    /* Recipe addons */
    property var difficulties: [ i18n.tr("No difficulty"), i18n.tr("Easy"), i18n.tr("Medium"), i18n.tr("Hard") ] // FIXME: Strange name
    property var categories: [ ]
    property var restrictions: [ i18n.tr("Non-veg"), i18n.tr("Vegetarian"), i18n.tr("Vegan") ]
    property var searches: [ ]

    function loadSettings() {

        if (!utils.get("firstLoad")) {
            console.log("Initializing settings and database for the first time.");
            categories = [ i18n.tr("Uncategorized") ];

            utils.set("firstLoad", 1);
            utils.set("version", utils.version);
        } else {
            console.log("Reloading last saved options.")
            // Restore previous size
            height = utils.get("windowSize").height;
            width = utils.get("windowSize").width;
            categories = utils.get("categories");
            searches = utils.get("searches");

            if (utils.get("version") != utils.version)
                updateDB(utils.get("version"));
        }

        // Component.onDestruction isn't called on the phone
        categoriesChanged.connect(saveSettings);
        searchesChanged.connect(saveSettings);
        saveSettings();
    }

    function saveSettings() {
        utils.set("windowSize", { "height": height, "width": width });
        utils.set("categories", categories);
        utils.set("searches", searches);
        utils.set("version", utils.version);
        utils.save();
    }

    // Helper functions
    function icon(name, local) {
        local = typeof local === "undefined" ? "" : local
        if (local === "app")
            return "/usr/share/icons/ubuntu-mobile/apps/scalable/" + name + ".svg"
        if (local)
            return Qt.resolvedUrl("../resources/images/" + name + ".png")
        return "/usr/share/icons/ubuntu-mobile/actions/scalable/" + name + ".svg"
    }

    function truncate(name, width, unit) {
        unit = typeof unit === "undefined" ? units.gu(2) : unit
        if (name.length > width / unit) {
            name = name.substring(0, width / (unit + units.gu(0.2)));
            name += "...";
        }
        return name;
    }

    function updateDB(oldVersion) {
        oldVersion = typeof oldVersion === "undefined" ? "0.1.0" : oldVersion
        if (oldVersion.startsWith("0.1")) {
            console.log("Migrating from " + oldVersion + " to " + utils.version)
            var docs = recipesdb.listDocs();
            for (var i = 0; i < docs.length; i++) {
                var contents = recipesdb.getDoc(docs[i])
                contents["preptime"] = parseInt(contents["preptime"]);
                contents["cooktime"] = parseInt(contents["cooktime"]);
                recipesdb.putDoc(contents, docs[i]);
            }
        }
    }
}
