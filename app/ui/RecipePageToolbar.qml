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
import Ubuntu.Components.Popups 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem

ToolbarItems {
    id: toolbar

    ToolbarButton {
        text: i18n.tr("Favorite")
        iconSource: recipe.favorite ? icon("favorite-selected") : icon("favorite-unselected")

        visible: recipe.exists()
        onTriggered: {
            toolbar.opened = false;
            recipe.favorite = !recipe.favorite;
            recipe.save();
        }
    }

    ToolbarButton {
        text: i18n.tr("Source")
        iconSource: icon("32/browser", true)

        visible: recipe.source.length > 0
        onTriggered: {
            if (utils.open(recipe.source))
                console.log("Open " + recipe.source);
        }
    }

    ToolbarButton {
        text: i18n.tr("Save")
        iconSource: icon("save")

        visible: recipe.ready && !recipe.exists()
        onTriggered: {
            toolbar.opened = false;
            recipe.save()
        }
    }

    ToolbarButton {
        visible: recipe.ready
        action: editRecipeAction
    }

    ToolbarButton {
        text: i18n.tr("Delete")
        iconSource: icon("delete")

        visible: false //recipe.exists()
        onTriggered: PopupUtils.open(Qt.resolvedUrl("dialogs/DeleteDialog.qml"))
    }
}
