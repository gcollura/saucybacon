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
import Ubuntu.Components.Popups 1.0
import Ubuntu.Components.ListItems 1.0 as ListItem

ToolbarItems {
    id: toolbar

    ToolbarButton {
        action: Action {
            visible: recipe.saved
            text: i18n.tr("Favorite")
            iconName: database.recipe.favorite ? "favorite-selected" : "favorite-unselected"

            onTriggered: {
                recipe.favorite = !recipe.favorite
                database.addRecipe(recipe)
            }
        }
    }

    ToolbarButton {
        action: Action {
            visible: !recipe.saved
            text: i18n.tr("Save")
            iconName: "save"

            onTriggered: {
                database.addRecipe(recipe)
            }
        }
    }

    ToolbarButton {
        action: editRecipeAction
    }

    ToolbarButton {
        action: Action {
            visible: recipe.saved
            text: i18n.tr("Delete")
            iconName: "delete"

            onTriggered: PopupUtils.open(Qt.resolvedUrl("dialogs/DeleteDialog.qml"))
        }
    }

    ToolbarButton {
        action: Action {
            visible: recipe.source.length > 0
            text: i18n.tr("Source")
            iconName: "stock_website"

            onTriggered: {
                if (utils.open(recipe.source))
                console.log("Open " + recipe.source);
            }
        }
    }
}
