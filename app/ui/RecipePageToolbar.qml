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
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.OnlineAccounts 0.1
import Friends 0.1

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
        id: shareButton
        text: i18n.tr("Share")
        iconSource: icon("share")

        visible: recipe.exists()
        onTriggered: PopupUtils.open(popoverComponent, shareButton)
    }

    ToolbarButton {
        text: i18n.tr("Source")
        //iconSource: icon("open")

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
        action: editRecipeAction
    }

    ToolbarButton {
        text: i18n.tr("Delete")
        iconSource: icon("delete")

        visible: recipe.exists()
        onTriggered: PopupUtils.open(Qt.resolvedUrl("dialogs/DeleteDialog.qml"))
    }

    FriendsDispatcher {
        id: friends
        onSendComplete: {
            if (success) {
                console.log("Send completed successfully");
            } else {
                console.log("Send failed: " + errorMessage.split("str: str:")[1]);
                // TODO: show some error dialog/widget
            }
        }
        onUploadComplete: {
            if (success) {
                console.log("Upload completed successfully");
            } else {
                console.log("Upload failed: " + errorMessage);
                // TODO: show some error dialog/widget
            }
        }
    }

    AccountServiceModel {
        id: accounts
        serviceType: "microblogging"
    }

    Component {
        id: popoverComponent
        Popover {
            id: popover
            Column {
                id: containerLayout
                anchors {
                    left: parent.left
                    top: parent.top
                    right: parent.right
                }
                ListItem.Header { text: i18n.tr("Export") }
                ListItem.Standard {
                    text: i18n.tr("As pdf")
                    icon: mainView.icon("export-document", true)

                    onTriggered: {
                        hide();
                        toolbar.opened = false;
                        recipe.exportAsPdf();
                    }
                }
                ListItem.Header { text: i18n.tr("Share"); visible: recipe.source }
                Repeater {
                    model: accounts
                    ListItem.Subtitled {
                        text: serviceName
                        subText: displayName
                        icon: mainView.icon(serviceName.toLowerCase().replace(".",""), "app")
                        visible: recipe.source
                        onClicked: {
                            hide();
                            toolbar.opened = false;
                            var message = recipe.name;
                            message += recipe.f2f ? "\n" + recipe.f2f : "\n"+ recipe.source
                            friends.sendForAccountAsync(accountId, message);
                        }
                    }
                }
            }
        }
    }
}
