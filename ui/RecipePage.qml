import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem

import "../components"

Page {
    title: truncate(recipe.name)

    property alias recipe: recipe
    Recipe {
        id: recipe
    }

    tools: RecipePageToolbar {
        objectName: "recipePageToolbar"
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        anchors.topMargin: units.gu(2)
        anchors.bottomMargin: units.gu(2)
        contentHeight: layout.height
        interactive: contentHeight > height

        Grid {
            id: layout
            columns: wideAspect ? 2 : 1
            width: parent.width
            spacing: units.gu(2)
            anchors {
                margins: units.gu(2)
                left: parent.left
                right: parent.right
            }

            Column {

                width: wideAspect ? parent.width / 2 - units.gu(2): parent.width
                spacing: units.gu(2)

                Item {
                    width: parent.width
                    height: totaltimeLabel.height

                    Label {
                        id: totaltimeLabel
                        anchors.left: parent.left
                        text: i18n.tr("%1".arg(recipe.totaltime))
                    }
                    Label {
                        anchors.right: parent.right
                        text: i18n.tr("Prep: %1 mins, Cook: %2 mins".arg(recipe.preptime).arg(recipe.cooktime))
                    }
                }

                Item {
                    width: parent.width
                    height: difficultyLabel.height

                    Label {
                        id: difficultyLabel
                        anchors.left: parent.left
                        text: i18n.tr("Difficulty: %1".arg(difficulties[recipe.difficulty]))
                    }

                    Label {
                        id: restrictionLabel
                        anchors.right: parent.right
                        text: restrictions[recipe.restriction]
                    }
                }

                ListItem.ThinDivider { }

                Label {
                    text: i18n.tr("Ingredients")
                    fontSize: "large"
                    font.bold: true
                }

                Column {
                    width: parent.width

                    Repeater {
                        id: ingredientsList
                        width: parent.width
                        model: recipe.ingredients

                        delegate: Label {
                            text: "%1 %2 %3".arg(modelData.quantity).arg(modelData.type).arg(modelData.name)
                        }
                    }
                }

                ListItem.ThinDivider { visible: recipe.photos.length > 0 }

                PhotoLayout {
                    id: photoLayout
                    editable: false
                    iconSize: units.gu(12)

                    photos: recipe.photos
                }

                ListItem.ThinDivider { visible: !wideAspect }

            }

            Column {
                width: wideAspect ? parent.width / 2 : parent.width
                spacing: units.gu(2)

                Label {
                    text: i18n.tr("Directions")

                    fontSize: "large"
                    font.bold: true
                }

                Label {
                    id: directionsLabel
                    width: parent.width

                    text: recipe.directions

                    wrapMode: Text.Wrap
                }

            }
        }

    }

    function truncate(name) {
        if (name.length > parent.width / units.gu(2)) {
            name = name.substring(0, parent.width / units.gu(2.1));
            name += "...";
        }
        return name;
    }

}
