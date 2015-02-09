/**
 * This file is part of SaucyBacon.
 *
 * Copyright 2013-2015 (C) Giulio Collura <random.cpp@gmail.com>
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

    property Flickable flickable: null

    onIngredientsChanged: {
        loadIngredients()
    }

    ListModel {
        id: ingredientsModel
    }

    Repeater {
        id: repeater
        model: ingredientsModel
        delegate: Component {
            Loader {
                property var listModel: model
                asynchronous: true
                width: parent ? parent.width : 0
                opacity: ((container.y+y+height) >= flickable.contentY) && (container.y+y <= (flickable.contentY + flickable.height)) ? 1 : 0
                sourceComponent: ingredientComponent
            }
        }
    }

    function getIngredients() {
        var result = [];
        var ingredient;
        for (var i = 0; i < ingredientsModel.count; i++) {
            ingredient = ingredientsModel.get(i);
            if (ingredient.name.length > 0) {
                // Trash that useless ObjectModel
                result.push(JSON.parse(JSON.stringify(ingredient)))
            }
        }

        return result;
    }

    function loadIngredients() {
        ingredientsModel.clear();
        // We reuse the already created ingredient entries
        for (var i = 0; i < ingredients.length; i++) {
            ingredientsModel.append(ingredients[i]);
        }
    }

    function clearIngredients() {
        ingredientsModel.clear();
    }

    function addIngredient(focus) {
        ingredientsModel.append({ name: '', quantity: '', unit: '', focus: focus });
    }

    Component {
        id: ingredientComponent
        IngredientInput {
            id: input
            property var model: listModel
            quantity: model ? model.quantity : ""
            unit: model ? model.unit : ""
            name: model ? model.name : ""
            onRemove: ingredientsModel.remove(model.index);
            onChanged: modelTimer.restart()
            focus: model ? model.focus : ""

            onFocusChanged: {
                console.log("focus changed", focus);
                flickable.contentY = container.y + y + height
            }

            Timer {
                // we avoid that changed signal updates the listmodel entry before other
                // fields get their correct values
                id: modelTimer
                interval: 1000

                onTriggered: ingredientsModel.set(model.index, input.get())
            }

            Component.onCompleted: {
                // console.log(listModel.focus)
                if (model.focus) {
                    focus();
                }
            }
        }
    }
}
