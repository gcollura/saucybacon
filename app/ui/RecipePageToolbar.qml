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
import Ubuntu.Components.Popups 0.1

ToolbarItems {

    ToolbarButton {
        text: i18n.tr("Export")
        //iconSource: icon("export")

        visible: recipe.exists()
        onTriggered: {
            recipe.exportAsPdf();
        }
    }

    ToolbarButton {
        text: i18n.tr("Favorite")
        iconSource: recipe.favorite ? icon("favorite-selected") : icon("favorite-unselected")

        visible: recipe.exists()
        onTriggered: {
            recipe.favorite = !recipe.favorite;
            recipe.save();
        }
    }

    ToolbarButton {
        text: i18n.tr("Share")
        iconSource: icon("share")

        visible: recipe.exists()
        onTriggered: {

        }
    }

    ToolbarButton {
        text: i18n.tr("Edit")
        iconSource: icon("edit")

        visible: recipe.ready
        onTriggered: {
            pageStack.push(editRecipePage)
        }
    }

    ToolbarButton {
        text: i18n.tr("Delete")
        iconSource: icon("delete")

        visible: recipe.exists()
        onTriggered: PopupUtils.open(Qt.resolvedUrl("DeleteDialog.qml"))
    }

}
