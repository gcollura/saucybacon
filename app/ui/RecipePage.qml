import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem

import "../components"

Page {
    title: truncate(recipe.name, parent.width)

    property Recipe recipe: Recipe { }

    tools: RecipePageToolbar {
        objectName: "recipePageToolbar"
    }

    Flickable {
        id: flickable

        anchors {
            fill: parent
            topMargin: units.gu(2)
            bottomMargin: units.gu(2)
        }

        contentHeight: layout.height
        interactive: contentHeight + units.gu(10) > height

        Grid {
            id: layout

            anchors {
                left: parent.left
                right: parent.right
                margins: units.gu(2)
            }
            spacing: wideAspect ? units.gu(4) : units.gu(2)
            columns: wideAspect ? 2 : 1

            Behavior on columns { UbuntuNumberAnimation { duration: UbuntuAnimation.SlowDuration } }

            Column {
                width: wideAspect ? parent.width / 2 - units.gu(2) : parent.width
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

                Label {
                    id: difficultyLabel
                    text: i18n.tr("Difficulty: %1".arg(difficulties[recipe.difficulty]))
                }

                Label {
                    id: restrictionLabel
                    text: i18n.tr("Restriction: %1".arg(restrictions[recipe.restriction]));
                }

                ListItem.ThinDivider {
                    anchors.margins: units.gu(-2)
                }

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

                ListItem.ThinDivider {
                    visible: recipe.photos.length > 0
                    anchors.margins: units.gu(-2)
                }

                PhotoLayout {
                    id: photoLayout
                    editable: false
                    iconSize: units.gu(12)

                    photos: recipe.photos
                }

                ListItem.ThinDivider {
                    visible: !wideAspect
                    anchors.margins: units.gu(-2)
                }

                Behavior on width { UbuntuNumberAnimation { duration: UbuntuAnimation.SlowDuration } }

            }

            Column {
                id: secondColumn
                width: wideAspect ? parent.width / 2 - units.gu(2) : parent.width
                spacing: units.gu(2)

                Label {
                    id: label
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

}
