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
        loadIngredients();
    }

    ListModel {
        id: listModel
    }

    Repeater {
        id: repeater
        model: listModel
        delegate: ingredientComponent
    }

    function getIngredients() {
        var result = [];
        var ingredient;
        for (var i = 0; i < listModel.count; i++) {
            ingredient = listModel.get(i);
            if (ingredient.name.length > 0) {
                // Trash that useless ObjectModel
                result.push(JSON.parse(JSON.stringify(ingredient)))
            }
        }

        return result;
    }

    function loadIngredients() {
        listModel.clear();
        // We reuse the already created ingredient entries
        for (var i = 0; i < ingredients.length; i++) {
            listModel.append(ingredients[i]);
        }
    }

    function clearIngredients() {
        listModel.clear();
    }

    function addIngredient(setfocus) {
        listModel.append({ name: '', quantity: '', unit: '', focus: true });
    }

    Component {
        id: ingredientComponent
        IngredientInput {
            id: input
            width: parent ? parent.width : 0
            quantity: model.quantity
            unit: model.unit
            name: model.name
            onRemove: listModel.remove(model.index);
            onChanged: modelTimer.restart()
            focus: model.focus
            opacity: ((container.y+y+height) >= flickable.contentY) && (container.y+y <= (flickable.contentY + flickable.height)) ? 1 : 0

            Timer {
                // we avoid that changed signal updates the listmodel entry before other
                // fields get their correct values
                id: modelTimer
                interval: 1000

                onTriggered: listModel.set(model.index, input.get())
            }

            Component.onCompleted: {
                if (model.focus) {
                    focus();
                }
            }
        }
    }
}
