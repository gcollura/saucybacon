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

QtObject {
    id: recipe

    property bool ready: !parser.loading

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

    property string source
    property string f2f

    // Signals
    signal changed
    signal saved
    signal removed
    signal exported(string fileName)

    default property RecipeParser parser
    RecipeParser {
        destPath: utils.path(utils.path(Utils.SettingsLocation) + "/imgs", "")
        onContentsChanged: {
            if (contents)
                setContents(parser.contents);
        }
    }

    onDocIdChanged: {
        if (exists()) {
            setContents(recipesdb.getDoc(docId));
        } else {
            reset();
        }

        changed();
    }

    function load(recipeId, recipeUrl, serviceUrl, imageUrl) {
        newRecipe();
        parser.get(recipeId, recipeUrl, serviceUrl, imageUrl);
    }

    function newRecipe() {
        if (docId)
            docId = "";
        else
            reset();
    }

    function reset() {
        setContents(defaultContents());
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

        source = contents.source ? contents.source : "";
        f2f = contents.f2f ? contents.f2f : "";
    }

    function getContents() {
        var contents = defaultContents();
        contents.name = name;
        contents.favorite = favorite ? favorite : false;
        contents.category = category ? category : categories[0];
        contents.difficulty = difficulty ? difficulty : 0;
        contents.restriction = restriction ? restriction : 0;
        contents.preptime = preptime ? preptime : "0";
        contents.cooktime = cooktime ? cooktime : "0";
        contents.totaltime = totaltime ? totaltime : i18n.tr("Total time: %1 minutes").arg(computeTotalTime(preptime, cooktime));
        contents.ingredients = ingredients ? ingredients : [ ];
        contents.servings = servings ? servings : 4;
        contents.directions = directions ? directions : "";
        contents.photos = photos ? photos : [ ];
        contents.source = source ? source : "";
        contents.f2f = f2f ? f2f : "";
        return contents;
    }

    function defaultContents() {
        return {
            "name": "",
            "favorite": false,
            "category": categories[0],
            "difficulty": 0,
            "restriction": 0,
            "preptime": "0",
            "cooktime": "0",
            "totaltime": i18n.tr("Total time: %1 minutes").arg(computeTotalTime(preptime, cooktime)),
            "ingredients": [ ],
            "servings": 4,
            "directions": "",
            "photos": [ ],
            "source": "",
            "f2f": ""
        }
    }

    function exists() {
        return docId.length > 0;
    }

    function save() {
        // Save consists in writing the changes to the db
        var result;
        var contents = getContents();

        if (exists())
            result = recipesdb.putDoc(contents, docId);
        else
            result = recipesdb.putDoc(contents);

        if (result)
            saved(); // emit signal

        return result;
    }

    function remove() {
        if (docId) {
            recipesdb.putDoc(null, docId);
            removed();
        }
    }

    function exportAsPdf() {
        var fileName = utils.path(Utils.DocumentsLocation, name + ".pdf");

        if (utils.exportAsPdf(fileName, getContents())) {
            exported(fileName);
            console.log("Saved PDF: " + fileName);
        }
    }
}
