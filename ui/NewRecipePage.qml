import QtQuick 2.0
import Ubuntu.Components 0.1
import U1db 1.0 as U1db

import "../components"

Page {
    title: i18n.tr("New Recipe")

    property string recipeId: ""

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

        // FIXME: the flickable doesn't fit the whole view sometimes
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
            }

            Row {
                width: parent.width

                // TODO: Change this to a combobox-like widget
                TextField {
                    id: recipeTags
                    width: parent.width
                    placeholderText: i18n.tr("TODO: Categories")
                }
            }

            Row {
                width: parent.width
                spacing: units.gu(1)

                Label {
                    id: totalTime
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width / 3 - units.gu(2)
                    text: i18n.tr("Total: %1 minutes").arg(computeTotalTime(prepTime.text, cookTime.text))
                }

                TextField {
                    id: prepTime
                    width: parent.width / 3
                    placeholderText: i18n.tr("Prep time (in min)")
                    inputMethodHints: Qt.ImhPreferNumbers
                }

                TextField {
                    id: cookTime
                    width: parent.width / 3
                    placeholderText: i18n.tr("Cook time (in min)")
                    inputMethodHints: Qt.ImhPreferNumbers
                }

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

                onClicked: addNewIngredient()
            }

            TextArea {
                id: recipeDirections
                width: parent.width

                placeholderText: i18n.tr("Write your directions")
                maximumLineCount: 15
            }

            Grid {
                width: parent.width
                spacing: units.gu(2)

                Repeater {
                    width: parent.width
                    model: 20
                    UbuntuShape {

                        width: units.gu(8)
                        height: width

                        Image {
                            source: icon("import-image")
                            width: parent.width - units.gu(1)
                            height: width
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

        var tmpContents = newRecipe.defaults;

        tmpContents.title = recipeName.text ? recipeName.text : i18n.tr("Misterious Recipe");
        tmpContents.directions = recipeDirections.text;
        tmpContents.preptime = prepTime.text;
        tmpContents.cooktime = cookTime.text;
        tmpContents.totaltime = totalTime.text;

        for (var i = 0; i < ingredientsContainer.children.length; i++) {
            var tmpingredient = { "name" : "", "quantity": 1, "type": "gr" }

            tmpingredient.name = ingredientsContainer.children[i].name;
            tmpingredient.quantity = ingredientsContainer.children[i].quantity ?
                        parseInt(ingredientsContainer.children[i].quantity) : 1;
            tmpingredient.type = ingredientsContainer.children[i].type;

            // Add the ingredient to the contents
            if (tmpingredient.name.length > 0) // Don't push non-sense ingredients
                tmpContents.ingredients.push(tmpingredient);
        }

        console.log(JSON.stringify(tmpContents));

        if (recipeId.length > 0)
            db.putDoc(tmpContents, recipeId);
        else
            db.putDoc(tmpContents);

        resetRecipe();
        pageStack.push(recipeListPage);
    }

    function loadRecipe(id) {
        recipeId = id;
        var contents = db.getDoc(recipeId);

        recipeName.text = contents.title;
        recipeDirections.text = contents.directions;
        prepTime.text = contents.preptime;
        cookTime.text = contents.cooktime;

        for (var i = 0; i < contents.ingredients.length; i++) {
            ingredientsContainer.children[i + 1].name = contents.ingredients[i].name;
            ingredientsContainer.children[i + 1].quantity = contents.ingredients[i].quantity;
            ingredientsContainer.children[i + 1].type = contents.ingredients[i].type;

            addNewIngredient();
        }

    }

    function resetRecipe() {

        recipeId = "";

        recipeName.text = "";
        recipeDirections.text = "";
        prepTime.text = "";
        cookTime.text = "";

        for (var i = 0; i < ingredientsContainer.children.length; ++i) {
            // Wipe out everything
            ingredientsContainer.children[i].destroy();
        }

        addNewIngredient();

    }

    function addNewIngredient() {
        var component = Qt.createComponent("../components/IngredientInput.qml")
        var object = component.createObject(ingredientsContainer)

        if (object == null)
            console.log("Error while creating the object")
    }

    onVisibleChanged: {
        // on edit, an id is passed after making visible the page
        // on new, no id is passed, then a new recipe will be saved
        if (visible)
            resetRecipe();
    }
}

