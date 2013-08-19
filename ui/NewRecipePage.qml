import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1
import Ubuntu.Components.ListItems 0.1
import U1db 1.0 as U1db

import "../components"

Page {
    title: i18n.tr("New recipe")

    property string recipeId

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

        anchors.fill: parent
        anchors.topMargin: units.gu(2)
        anchors.bottomMargin: units.gu(2)

        contentHeight: newRecipeColumn.height
        interactive: contentHeight > height

        Column {
            id: newRecipeColumn

            width: parent.width
            spacing: units.gu(2)
            anchors {
                left: parent.left
                right: parent.right
                margins: units.gu(2)
            }

            TextField {
                id: recipeName
                width: parent.width
                placeholderText: i18n.tr("Enter a name for your recipe")

                onFocusChanged: {
                    // FIXME
                    focus ? __styleInstance.color = Theme.palette.normal.overlayText : __styleInstance.color = "white"
                }
            }

            Row {
                width: parent.width
                spacing: units.gu(2)

                // TODO: Change this to a combobox-like widget
                Button {
                    id: recipeCategory
                    width: parent.width / 2 - units.gu(1)
                    height: units.gu(4)
                    text: i18n.tr("Select category")

                    property var model: categories
                    onClicked: PopupUtils.open(Qt.resolvedUrl("../components/DifficultySelector.qml"), recipeCategory)
                }
//                ValueSelector {
//                    width: parent.width / 2 - units.gu(1)
//                    text: "Category"
//                    values: ["Value 1", "Value 2", "Value 3", "Value 4", "Value 5", "Value 6", "Value 7"]
//                }

                Button {
                    id: recipeDifficulty
                    width: parent.width / 2 - units.gu(1)
                    height: units.gu(4)

                    text: i18n.tr("Select difficulty")

                    property var model: difficultyModel
                    onClicked: PopupUtils.open(Qt.resolvedUrl("../components/DifficultySelector.qml"), recipeDifficulty)
                }
//                ValueSelector {
//                    width: parent.width / 2 - units.gu(1)
//                    text: "Difficulty"
//                    values: ["Value 1", "Value 2", "Value 3", "Value 4"]
//                }
            }

            Row {
                width: parent.width
                spacing: units.gu(1)

                Label {
                    id: totalTime
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width / 2 - units.gu(2)
                    text: i18n.tr("Total time: %1 minutes").arg(computeTotalTime(prepTime.text, cookTime.text))
                }

                TextField {
                    id: prepTime
                    width: parent.width / 4
                    placeholderText: i18n.tr("Prep time")
                    inputMethodHints: Qt.ImhPreferNumbers
                }

                TextField {
                    id: cookTime
                    width: parent.width / 4
                    placeholderText: i18n.tr("Cook time")
                    inputMethodHints: Qt.ImhPreferNumbers
                }

            }

            Row {
                width: parent.width
                Label {
                    width: text.length * units.gu(2)
                    text: i18n.tr("Ingredients")
                }
//                Slider {
//                    height: units.gu(4)
//                    value: 4
//                    minimumValue: 1
//                    maximumValue: 10
//                    live: true
//                }
            }

            Column {
                id: ingredientsContainer
                width: parent.width
                spacing: units.gu(1)

                IngredientInput {

                }

            }

            Button {
                width: parent.width
                height: units.gu(4)
                text: i18n.tr("Add new ingredient")

                onClicked: addNewIngredient(true)
            }

            TextArea {
                id: recipeDirections
                width: parent.width

                placeholderText: i18n.tr("Write your directions")
                maximumLineCount: 0
                autoSize: true
            }

            PhotoLayout {
                id: photoLayout
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
        tmpContents.category = recipeCategory.text;
        tmpContents.difficulty = recipeDifficulty.text;

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

        tmpContents.photos = photoLayout.photos;

        // console.log(JSON.stringify(tmpContents));

        if (recipeId.length > 0) {
            db.putDoc(tmpContents, recipeId);
            pageStack.push(recipePage);
            recipePage.setRecipe(recipeId);
        } else {
            db.putDoc(tmpContents);
            pageStack.push(recipeListPage);
        }

    }

    onRecipeIdChanged: {

        if (recipeId.length > 0) {
            // If a recipeId is set, retrieve its information from the db
            // load them in to the edit page and set a proper page title
            var contents = db.getDoc(recipeId);

            if (!contents) {
                console.log("Error while loading " + recipeId);
                return;
            }

            recipeName.text = contents.title;
            recipeDirections.text = contents.directions;
            prepTime.text = contents.preptime;
            cookTime.text = contents.cooktime;
            recipeCategory.text = contents.category;
            recipeDifficulty.text = contents.difficulty;

            resetIngredients(contents.ingredients.length);

            for (var i = 0; i < contents.ingredients.length; i++) {
                if (!ingredientsContainer.children[i])
                    addNewIngredient();

                ingredientsContainer.children[i].name = contents.ingredients[i].name;
                ingredientsContainer.children[i].quantity = contents.ingredients[i].quantity;
                ingredientsContainer.children[i].type = contents.ingredients[i].type;

            }

            addNewIngredient();

            photoLayout.photos = contents.photos;

            title = i18n.tr("Edit recipe");
        } else if (recipeId == "") {
            // Else, if no recipeId is set, clean everything and be ready to
            // retrieve a new saucy recipe

            recipeName.text = "";
            recipeDirections.text = "";
            prepTime.text = "";
            cookTime.text = "";
            recipeCategory.text = i18n.tr("Select category")
            recipeDifficulty.text = i18n.tr("Select difficulty");

            resetIngredients();
            addNewIngredient();

            photoLayout.photos = [ ]

            // Set a proper title
            title = i18n.tr("New recipe");
        }

    }

    function addNewIngredient(setfocus) {
        var component = Qt.createComponent("../components/IngredientInput.qml");
        var object = component.createObject(ingredientsContainer);

        if (typeof object === 'undefined')
            console.log("Error while creating the object")
        if (setfocus)
            object.focus()
    }

    function resetIngredients(length) {
        // Length parameter avoid useless object.destroy() calls
        length = typeof length !== 'undefined' ? length : 0

        for (var i = ingredientsContainer.children.length - 1; i >= length; i--) {
            ingredientsContainer.children[i].destroy();
        }
    }

}

