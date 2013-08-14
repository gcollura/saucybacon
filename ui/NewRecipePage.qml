import QtQuick 2.0
import Ubuntu.Components 0.1
import U1db 1.0 as U1db

import "../components"

Page {
    title: i18n.tr("New Recipe")

    tools: ToolbarItems {
        ToolbarButton {
            iconSource: icon('save')
            text: i18n.tr("Save")

            onTriggered: {
                saveRecipe();
            }
        }
    }

    Flickable {
        id: flickable

        width: parent.width
        height: parent.height

        contentHeight: newRecipeColumn.implicitHeight

        anchors.fill: parent
        clip: true

        Column {
            id: newRecipeColumn

            width: parent.width
            spacing: units.gu(2)
            anchors {
                fill: parent
                margins: units.gu(2)
            }

            TextField {
                id: recipeName
                width: parent.width
                placeholderText: i18n.tr("Enter a name for your recipe")
                hasClearButton: true
            }

            Row {
                width: parent.width

                TextField {
                    id: recipeTags
                    width: parent.width
                    placeholderText: i18n.tr("Enter tags separated by a comma")
                }
            }

            Row {
                width: parent.width
                spacing: units.gu(2)

                TextField {
                    id: prepTime
                    width: parent.width / 2 - units.gu(1)
                    placeholderText: i18n.tr("Prep time (in min)")
                    inputMethodHints: Qt.ImhPreferNumbers
                }

                TextField {
                    id: cookTime
                    width: parent.width / 2 - units.gu(1)
                    placeholderText: i18n.tr("Cook time (in min)")
                    inputMethodHints: Qt.ImhPreferNumbers
                }
            }

            Label {
                id: totalTime
                width: units.gu(8)
                text: i18n.tr("Total time: %1 minutes").arg(computeTotalTime(prepTime.text, cookTime.text))
            }


            Label {
                text: i18n.tr("Ingredients:")
            }

            Column {
                id: ingredientsContainer
                width: parent.width
                spacing: units.gu(2)

                IngredientInput {

                }
            }

            Button {
                width: parent.width
                height: units.gu(4)
                text: i18n.tr("Add new ingredient")

                onClicked: {
                    var component = Qt.createComponent("../components/IngredientInput.qml")
                    var object = component.createObject(ingredientsContainer)
                    if (object == null)
                        console.log("Error while creating the object")
                }
            }

            TextArea {
                id: recipeDirections
                width: parent.width

                placeholderText: i18n.tr("Write down your directions")
                maximumLineCount: 15
                autoSize: true

                onLineCountChanged: updateFlickable()
            }

            UbuntuShape {

                width: parent.width - units.gu(20)
                height: width
                anchors.horizontalCenter: parent.horizontalCenter

                Image {
                    source: icon("import-image")
                    anchors {
                        verticalCenter: parent.verticalCenter
                        horizontalCenter: parent.horizontalCenter
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("Open a file browser to choose an image!")
                    }
                }
            }
        }

    }

    function computeTotalTime(time1, time2) {
        var t1 = parseInt(time1);
        var t2 = parseInt(time2);

        var total = t1 + t2;
        if (!total)
            total = 0;

        return total.toString();
    }

    function saveRecipe() {
        console.log("Saving recipe: %1".arg(newRecipe.docId))

        var tmpContents = newRecipe.defaults;
        tmpContents["title"] = recipeName.text;
        tmpContents["directions"] = recipeDirections.text;
        tmpContents["preptime"] = prepTime.text;
        tmpContents["cooktime"] = cookTime.text;
        tmpContents["totaltime"] = totalTime.text;
        for (var i = 0; i < ingredientsContainer.children.length; ++i)
            tmpContents["ingredients"][ingredientsContainer.children[i].name] = ingredientsContainer.children[i].quantity

        console.log(JSON.stringify(tmpContents))

        newRecipe.contents = tmpContents;

        newRecipe.create = true
        resetRecipe();
    }

    function resetRecipe() {
        newRecipe.create = false
        newRecipe.docId = getRandomId()
    }

    function getRandomId() {
        var n = Math.random();
        return n.toString();
    }

    U1db.Document {
        id: newRecipe
        database: db
        defaults: {"title": "world", "preptime": "0", "cooktime": "0", "totaltime": "0", "ingredients": { },
            "directions": "text" }
    }

    Component.onCompleted: resetRecipe()
}

