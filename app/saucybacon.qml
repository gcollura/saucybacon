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
import Ubuntu.Layouts 0.1
import U1db 1.0 as U1db
import SaucyBacon 0.1

import "ui"
import "components"

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"
    id: mainView

    // Note! applicationName needs to match the .desktop filename
    applicationName: "SaucyBacon"

    automaticOrientation: true
    property bool wideAspect: width > units.gu(80)

    width: units.gu(70)
    height: units.gu(75)

    headerColor: "#640707"
    backgroundColor: "#790f0f"
    footerColor: "#641616"

    PageStack {
        id: pageStack

        RecipeListPage {
            objectName: "recipeListPage"
            id: recipeListPage

            visible: false
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

        SearchPage {
            objectName: "searchPage"
            id: searchPage

            visible: false
        }
    }

    Component.onCompleted: {
        loadSettings();

        if (wideAspect) {
            pageStack.push(recipeListPage)
            console.log("Switch to tablet factor")
        } else {
            pageStack.push(recipeListPage)
        }
    }

    Component.onDestruction: {
        saveSettings();
    }

    /* Recipe Database */
    U1db.Database {
        id: recipesdb
        path: "sb-recipesdb"
    }

    /* Base recipe document - just for reference
    U1db.Document {
        database: db
        create: false
        defaults: { "name": "", "category": "", "difficulty": 1, "restriction": 0,
            "preptime": "0", "cooktime": "0", "totaltime": "0", "ingredients": [ ],
            "directions": "", "servings": 4, "photos" : [ ], "favorite": false }
    } */

    // SaucyBacon Utils library
    Utils {
        id: utils
    }

    property Recipe recipe: Recipe { }

    /* Recipe addons */
    property var difficulties: [ i18n.tr("No difficulty"), i18n.tr("Easy"), i18n.tr("Medium"), i18n.tr("Hard") ] // FIXME: Strange name
    property var categories: [ ]
    property var restrictions: [ i18n.tr("Non-veg"), i18n.tr("Vegetarian"), i18n.tr("Vegan") ]
    property var searches: [ ]

    function loadSettings() {
        if (!utils.get("firstLoad")) {
            categories = [ i18n.tr("Uncategorized") ];

            utils.set("firstLoad", 1);
        } else {
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
        if (local)
            return Qt.resolvedUrl("../graphics/icons/" + name + ".png")
        return "/usr/share/icons/ubuntu-mobile/actions/scalable/" + name + ".svg"
    }

    function onlyUnique(value, index, self) {
        // Usage:   var a = ['a', 1, 'a', 2, '1'];
        //          var unique = a.filter( onlyUnique ); -> ['a', 1, 2, '1']
        return self.indexOf(value) === index;
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
        var t1 = parseInt(time1);
        var t2 = parseInt(time2);

        var total = t1 + t2;
        if (!total)
            total = 0;

        return total.toString();
    }
}
