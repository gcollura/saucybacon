/**
 * This file is part of SaucyBacon.
 *
 * Copyright 2013 (C) Giulio Collura <random.cpp@gmail.com>
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

import QtQuick 2.0

QtObject {
    id: recipe

    property string docId: ""

    property string name
    property bool favorite
    property string category
    property int difficulty: 0
    property int restriction: 0

    property string preptime
    property string cooktime
    property string totaltime

    property var ingredients: new Array()
    property int servings

    property string directions

    property var photos: new Array()

    // Signals
    signal changed
    signal saved

    onDocIdChanged: {
        if (exists()) {
            setContents(recipesdb.getDoc(docId));
        } else {
            reset();
        }

        changed();
    }

    function reset() {
        name = "";
        favorite = false;

        category = "";
        difficulty = 0;
        restriction = 0;

        preptime = 0;
        cooktime = 0;

        ingredients = new Array();
        servings = 4;

        directions = "";

        photos = new Array();
    }

    function setContents(contents) {
        name = contents.name;
        favorite = contents.favorite ? contents.favorite : false;

        category = contents.category;
        difficulty = contents.difficulty;
        restriction = contents.restriction;

        preptime = contents.preptime;
        cooktime = contents.cooktime;
        totaltime = contents.totaltime;

        ingredients = contents.ingredients;
        servings = contents.servings;

        directions = contents.directions;

        photos = contents.photos;
    }

    function getContents() {
        return {
            "name": name,
            "favorite": favorite,
            "category": category,
            "difficulty": difficulty,
            "restriction": restriction,
            "preptime": preptime,
            "cooktime": cooktime,
            "totaltime": totaltime,
            "ingredients": ingredients,
            "servings": servings,
            "directions": directions,
            "photos": photos
        }
    }

    function exists() {
        return docId.length > 0;
    }

    function save() {
        // Save consists in writing the changes to the db
        var result;
        if (exists)
            result = recipesdb.putDoc(getContents(), docId);
        else
            result = recipesdb.putDoc(getContents());

        if (result)
            saved(); // emit signal

        return result;
    }

    function remove() {
        console.log("Cannot delete this recipe at the moment.");
        console.log("U1db does not support Document deletetion.")
    }

    function exportAsPdf() {
        var fileName = utils.homePath() + "/" + name + ".pdf";

        if (utils.exportAsPdf(fileName, getContents()))
            console.log("Saved PDF: " + fileName);
    }
}
