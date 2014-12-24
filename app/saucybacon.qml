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

import QtQuick 2.3
import Ubuntu.Components 1.1
import SaucyBacon 1.0

import "ui"
import "components"

import "prototypes.js" as Prototypes

MainView {
    objectName: "mainView"
    id: mainView

    applicationName: "com.ubuntu.developer.gcollura.saucybacon"

    automaticOrientation: true
    anchorToKeyboard: true
    useDeprecatedToolbar: false

    property bool wideAspect: width > units.gu(80)
    property bool appActive: Qt.application.active

    width: units.gu(120)
    height: units.gu(85)

    // Thanks Lucas Di Benedetto
    headerColor: colors.headerColor
    backgroundColor: colors.darkRed
    footerColor: colors.footerColor

    property alias recipe: database.recipe

    // Global actions
    Action {
        id: newRecipeAction
        text: i18n.tr("New")
        description: i18n.tr("Create a new recipe")
        iconName: "add"
        onTriggered: {
            pageStack.push(editPage, { title: i18n.tr("New recipe"), state: "new" })
            editPage.newRecipe()
        }
    }

    Action {
        id: editRecipeAction
        text: i18n.tr("Edit")
        iconName: "edit"
        onTriggered: {
            pageStack.push(editPage, { title: i18n.tr("Edit recipe"), state: "edit" })
            editPage.editRecipe(recipe)
        }
    }

    Action {
        id: searchAction
        text: i18n.tr("Search")
        description: i18n.tr("Search online for a new recipe")
        iconName: "search"
        onTriggered: pageStack.push(Qt.resolvedUrl("ui/SearchPage.qml"))
    }

    Action {
        id: aboutAction
        text: i18n.tr("About")
        iconName: "help"
        onTriggered: pageStack.push(Qt.resolvedUrl("ui/AboutPage.qml"))
    }

    Action {
        id: refreshAction
        text: i18n.tr("Refresh")
        iconName: "reload"
        onTriggered: database.update()
    }

    Action {
        id: deleteAction
        text: i18n.tr("Delete")
        iconName: "delete"
        onTriggered: {
            database.deleteRecipe(database.recipe.id)
            deleteRecipeTimer.start()
        }
    }

    // WORKAROUND: if pageStack.pop() is called as soon as the dialog closes,
    // the app freezes, with this trick, everything goes fine
    Timer {
        id: deleteRecipeTimer
        interval: 100
        repeat: false

        onTriggered: {
            pageStack.pop()
        }
    }

    PageStack {
        objectName: "pageStack"
        id: pageStack

        Component.onCompleted: {
            push(homePage);
        }

        HomePage {
            objectName: "homePage"
            id: homePage
        }

        EditPage {
            id: editPage
            visible: false
        }

    }

    ActivityIndicator {
        anchors {
            bottom: parent.bottom
            right: parent.right
            margins: units.gu(1)
        }
        z: 100
        running: database.working
    }

    Colors {
        id: colors
    }

    Database {
        id: database
    }

    Utils {
        id: utils
    }

    // Helper functions
    function icon(name) {
        return Qt.resolvedUrl("graphics/" + name + ".png")
    }

}
