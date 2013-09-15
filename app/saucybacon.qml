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
import U1db 1.0 as U1db
import SaucyBacon 0.1

import "ui"
import "backend"

MainView {
    objectName: "mainView"
    id: mainView

    // NOTE: applicationName needs to match the .desktop filename
    applicationName: "saucybacon"

    automaticOrientation: true
    property bool wideAspect: width > units.gu(80)
    property bool extraWideAspect: width > units.gu(130)

    width: units.gu(135)
    height: units.gu(85)

    headerColor: "#640707"
    backgroundColor: "#790f0f"
    footerColor: "#641616"

    // Global actions

    Action {
        id: newRecipeAction
        text: i18n.tr("New")
        description: i18n.tr("Create a new recipe")
        iconSource: icon("add")
        keywords: "new;recipe"
        onTriggered: {
            recipe.newRecipe();
            pageStack.push(editRecipePage);
        }
    }

    Action {
        id: editRecipeAction
        text: i18n.tr("Edit")
        description: i18n.tr("Edit the current recipe")
        iconSource: icon("edit")
        keywords: "edit;recipe"
        onTriggered: pageStack.push(editRecipePage)
    }

    Action {
        id: searchAction
        text: i18n.tr("Search")
        description: i18n.tr("Search for a new recipe on the internet")
        iconSource: icon("edit")
        keywords: "search;new;recipe"
        onTriggered: { pageStack.push(tabs); tabs.selectedTabIndex = 1; }
    }

    actions: [ newRecipeAction, searchAction ]

    PageStack {
        id: pageStack

        Tabs {
            objectName: "tabs"
            id: tabs
            visible: false

            Tab {
                title: page.title
                page: RecipeListPage {
                    objectName: "recipeListPage"
                    id: recipeListPage
                }
            }

            Tab {
                title: page.title
                page: SearchPage {
                    objectName: "searchPage"
                    id: searchPage
                }
            }

            Tab {
                title: page.title
                page: AboutPage {
                    objectName: "aboutPage"
                    id: aboutPage
                }
            }
        }

        RecipePage {
            objectName: "recipePage"
            id: recipePage

            visible: false
        }

        EditRecipePage {
            objectName: "newRecipePage"
            id: editRecipePage

            visible: false
        }

        CameraPage {
            objectName: "cameraPage"
            id: cameraPage

            visible: false
        }

        function back() {
            pageStack.currentPage.tools.back.trigger();
        }
    }

    Component.onCompleted: {
        loadSettings();

        pageStack.push(tabs)
    }

    Component.onDestruction: {
        saveSettings();
    }

    // SaucyBacon Utils library
    Utils {
        id: utils
    }

    Database {
        id: db
    }

    /* Recipe Database */
    U1db.Database {
        id: recipesdb
        path: utils.path(Utils.SettingsLocation, "sb-recipes.db")

        property bool count: recipesdb.listDocs().length > 0
        function update() {
            count = recipesdb.listDocs().length > 0
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

    property Recipe recipe: Recipe { }
    property var menus: [ ]

    /* Recipe addons */
    property var difficulties: [ i18n.tr("No difficulty"), i18n.tr("Easy"), i18n.tr("Medium"), i18n.tr("Hard") ] // FIXME: Strange name
    property var categories: [ ]
    property var restrictions: [ i18n.tr("Non-veg"), i18n.tr("Vegetarian"), i18n.tr("Vegan") ]
    property var searches: [ ]

    function loadSettings() {

        Array.prototype.pushBack = function(item) {
            // Reimplement Array.push(..) to have always unique arrays
            if (this.indexOf(item) < 0)
                this.push(item);
        }

        Array.prototype.unique = function() {
            var o = {}, i, l = this.length, r = [];
            for (i = 0; i < l; i += 1)
                o[this[i]] = this[i];
            for (i in o)
                r.push(o[i]);
            return r;
        }

        String.prototype.capitalize = function() {
            return this.charAt(0).toUpperCase() + this.slice(1);
        }

        if (!utils.get("firstLoad")) {
            categories = [ i18n.tr("Uncategorized") ];

            utils.set("firstLoad", 1);
        } else {
            // Restore previous size
            height = utils.get("windowSize").height;
            width = utils.get("windowSize").width;
            categories = utils.get("categories");
            searches = utils.get("searches");
        }
    }

    function saveSettings() {
        utils.set("windowSize", { "height": height, "width": width });
        utils.set("categories", categories);
        utils.set("searches", searches);
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

    function computeTotalTime(time1, time2) {
        var t1 = time1 ? parseInt(time1) : 0;
        var t2 = time2 ? parseInt(time2) : 0;

        var total = t1 + t2;
        if (!total)
            total = 0;

        return total.toString();
    }
}
