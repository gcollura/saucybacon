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

        Column {
            id: layout

            width: parent.width
            anchors {
                margins: units.gu(2)
                left: parent.left
                right: parent.right
            }
            spacing: units.gu(2)

            Label {
                id: totaltimeLabel
                text: i18n.tr("<b>%1</b> \t (Prep: %2 mins, Cook: %3 mins)".arg(recipe.totaltime).arg(recipe.preptime).arg(recipe.cooktime))
            }

            Label {
                id: difficultyLabel
                text: i18n.tr("Difficulty: %1".arg(difficulties[recipe.difficulty]))
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

            ListItem.ThinDivider { }

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

            ListItem.ThinDivider { }

            PhotoLayout {
                id: photoLayout
                editable: false
                iconSize: units.gu(12)

                photos: recipe.photos
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
