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

    automaticOrientation: false

    width: units.gu(60)
    height: units.gu(85)

    headerColor: "#700328"
    backgroundColor: "#7A2541"
    footerColor: "#631E35"

    PageStack {
        id: pageStack


        RecipeListPage {
            objectName: "recipesPage"
            id: recipesPage

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
        pageStack.push(recipesPage)
    }

    U1db.Database {
        id: db
        path: "saucybacondb"
    }

    // Helper functions
    function icon(name) {
        return "/usr/share/icons/ubuntu-mobile/actions/scalable/" + name + ".svg"
    }
}
