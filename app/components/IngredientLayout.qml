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

import QtQuick 2.3
import Ubuntu.Components 1.1

Column {
    id: container
    spacing: units.gu(1)

    property var ingredients

    onIngredientsChanged: {
        loadIngredients();
    }

    function getIngredients() {
        var result = new Array();
        for (var i = 0; i < container.children.length; i++) {
            if (container.children[i].name.length < 1) // Don't push non-sense ingredients
                continue;

            var tmpingredient = { "name" : "", "quantity": 1, "unit": "gr" }

            tmpingredient.name = container.children[i].name;
            tmpingredient.quantity = container.children[i].quantity ?
                        parseInt(container.children[i].quantity) : 1;
            tmpingredient.unit = container.children[i].unit;

            result.push(tmpingredient);
        }

        return result;
    }

    function loadIngredients() {
        for (var i = 0; i < ingredients.length; i++) {
            if (!ingredientsLayout.children[i])
                addIngredient();

            container.children[i].name = ingredients[i].name;
            container.children[i].quantity = typeof ingredients[i].quantity !== "undefined" ? ingredients[i].quantity : 0
            container.children[i].unit = ingredients[i].unit;
        }

        // Make room for another ingredient
        addIngredient();
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
