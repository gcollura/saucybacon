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
import SaucyBacon 0.1

Item {
    id: recipe

    RecipeParser {
        id: parser

        onContentsChanged: {
            if (contents)
                setContents(parser.contents);
        }
    }

    property bool ready: !parser.loading
    function load(recipeId, recipeUrl, serviceUrl) {
        if (docId)
            newRecipe();
        else
            reset(); // hard reset, if the docId was already null
        parser.get(recipeId, recipeUrl, serviceUrl);
    }

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
    signal deleted

    onDocIdChanged: {
        if (exists()) {
            setContents(recipesdb.getDoc(docId));
        } else {
            reset();
        }

        changed();
    }

    function newRecipe() {
        docId = "";
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

        category = contents.category ? contents.category : categories[0];
        difficulty = contents.difficulty ? contents.difficulty : 0;
        restriction = contents.restriction ? contents.restriction : 0;

        preptime = contents.preptime ? contents.preptime : "0";
        cooktime = contents.cooktime ? contents.cooktime : "0";
        totaltime = contents.totaltime ? contents.totaltime : i18n.tr("Total time: %1 minutes").arg(computeTotalTime(preptime, cooktime));

        ingredients = contents.ingredients ? contents.ingredients : [ ];
        servings = contents.servings ? contents.servings : 4;

        directions = contents.directions ? contents.directions : "";

        photos = contents.photos ? contents.photos : [ ];
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
        if (docId) {
            recipesdb.putDoc("", docId);
            deleted();
        }
    }

    function exportAsPdf() {
        var fileName = utils.homePath() + "/" + name + ".pdf";

        if (utils.exportAsPdf(fileName, getContents()))
            console.log("Saved PDF: " + fileName);
    }
}
