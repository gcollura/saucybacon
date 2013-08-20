import QtQuick 2.0
import Ubuntu.Components 0.1
import U1db 1.0 as U1db

import "ui"
import "components"

/*!
    \brief MainView with Tabs element.
           First Tab has a single Label and
           second Tab has a single ToolbarAction.
*/

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"
    id: mainView

    // Note! applicationName needs to match the .desktop filename
    applicationName: "SaucyBacon"

    automaticOrientation: true
    property bool wideAspect: width > units.gu(80)

    width: units.gu(60)
    height: units.gu(85)

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
        if (width < units.gu(80))
            pageStack.push(recipeListPage)
        else
            console.log("Switch to tablet factor")
        loadCategories();
    }

    /* Database */
    U1db.Database {
        id: db
        path: "saucybacondb"
    }

    /* Base recipe document */
    U1db.Document {
        database: db
        create: false
        defaults: { "name": "", "category": "", "difficulty": 1, "veg": 0,
            "preptime": "0", "cooktime": "0", "totaltime": "0", "ingredients": [ ],
            "directions": "", "servings": 4, "photos" : [ ] }
    }

    /* Recipe addons */
    property var difficulties: [ i18n.tr("Easy"), i18n.tr("Medium"), i18n.tr("Hard") ] // FIXME: Strange name
    property var categories: [ ]

    function loadCategories() {
        // FIXME: use u1db query to retrieve categories
        var docs = db.listDocs();
        var ctgrs = { };
        for (var i = 0; i < docs.length; i++) {
            var category = db.getDoc(docs[i]).category;
            if (ctgrs[category] || category == "")
                continue;
            ctgrs[category] = 1;
        }
        categories = Object.keys(ctgrs);
        console.log(JSON.stringify(categories))
    }

    // Helper functions
    function icon(name) {
        return "/usr/share/icons/ubuntu-mobile/actions/scalable/" + name + ".svg"
    }
    function onlyUnique(value, index, self) {
        // Usage:   var a = ['a', 1, 'a', 2, '1'];
        //          var unique = a.filter( onlyUnique ); -> ['a', 1, 2, '1']
        return self.indexOf(value) === index;
    }
}
