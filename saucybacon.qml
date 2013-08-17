import QtQuick 2.0
import Ubuntu.Components 0.1
import U1db 1.0 as U1db

import "ui"

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

    width: units.gu(60)
    height: units.gu(85)

    headerColor: "#640707"
    backgroundColor: "#9b1515"
    footerColor: "#b32525"

    PageStack {
        id: pageStack


        RecipeListPage {
            objectName: "recipesPage"
            id: recipeListPage

            visible: false
        }

        RecipePage {
            objectName: "recipePage"
            id: recipePage

            visible: false
        }

        NewRecipePage {
            objectName: "newRecipePage"
            id: newRecipePage

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
    }

    onWidthChanged: {

    }

    /* Database */
    U1db.Database {
        id: db
        path: "saucybacondb"
    }

    /* Base recipe document */
    U1db.Document {
        id: newRecipe
        database: db
        create: false
        defaults: { "title": "world", "category": [], "difficulty": "normal",
            "preptime": "0", "cooktime": "0", "totaltime": "0", "ingredients": [ ],
            "directions": "text" }
    }

    // Helper functions
    function icon(name) {
        return "/usr/share/icons/ubuntu-mobile/actions/scalable/" + name + ".svg"
    }
}
