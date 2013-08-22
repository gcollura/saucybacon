import QtQuick 2.0
import Ubuntu.Components 0.1

Column {
    id: container
    spacing: units.gu(1)

    property var ingredients

    onIngredientsChanged: {
        loadIngredients();
    }

    function getIngredients() {
        var result = new Array()
        for (var i = 0; i < container.children.length; i++) {
            if (container.children[i].name.length < 1) // Don't push non-sense ingredients
                continue;

            var tmpingredient = { "name" : "", "quantity": 1, "type": "gr" }

            tmpingredient.name = container.children[i].name;
            tmpingredient.quantity = container.children[i].quantity ?
                        parseInt(container.children[i].quantity) : 1;
            tmpingredient.type = container.children[i].type;

            result.push(tmpingredient);
        }

        return result;
    }

    function loadIngredients() {
        resetIngredients(ingredients.length);

        for (var i = 0; i < ingredients.length; i++) {
            if (!ingredientsLayout.children[i])
                addIngredient();

            container.children[i].name = ingredients[i].name;
            container.children[i].quantity = ingredients[i].quantity;
            container.children[i].type = ingredients[i].type;
        }

        // Make room for another ingredient
        addIngredient();
    }

    function resetIngredients(length) {
        // Length parameter avoid useless object.destroy() calls
        // Destroy only the objects we don't need at the moment
        length = typeof length !== 'undefined' ? length : 0

        for (var i = container.children.length - 1; i >= length; i--) {
            container.children[i].destroy();
        }
    }

    function addIngredient(setfocus) {
        var object = ingredientComponent.createObject(container);

        if (typeof object === 'undefined' || object === null)
            console.log("Error while creating the object")
        if (setfocus)
            object.focus()
    }

    Component {
        id: ingredientComponent
        IngredientInput {

        }
    }
}
