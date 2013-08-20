import QtQuick 2.0

QtObject {
    id: recipe

    property string docId: ""

    property string name
    property string category
    property int difficulty: -1
    property int veg: 0

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
            setContents(db.getDoc(docId));
        } else {
            reset();
        }

        changed();
    }

    function reset() {
        name = "";

        category = "";
        difficulty = -1;
        veg = 0;

        preptime = 0;
        cooktime = 0;

        ingredients = new Array();
        servings = 4;

        directions = "";

        photos = new Array();
    }

    function setContents(contents) {
        name = contents.name;

        category = contents.category;
        difficulty = contents.difficulty;
        veg = contents.veg;

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
            "category": category,
            "difficulty": difficulty,
            "veg": veg,
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
            result = db.putDoc(getContents(), docId)
        else
            result = db.putDoc(getContents())

        if (result)
            saved();
        return result;
    }
}
