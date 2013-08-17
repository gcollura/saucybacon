import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem

ListItem.Subtitled {
    id: item
    progression: true

    text: contents.title
    subText: "%1\nIngredients: %2".arg(contents.totaltime).arg(listElement(contents.ingredients))


    onClicked: openRecipe(docId)

    function openRecipe(id) {
        pageStack.push(recipePage);
        recipePage.setRecipe(id);
    }

    function listElement(array) {
//        var retlist = [];
//        for (var i = 0; i < array.length; i++)
//            retlist[i] = array[i].name;
//        return retlist;

        var result = "";

        if (!array) // recipe without ingredients
            return result;

        for (var i = 0; i < array.length; i++) {
            result += array[i].name;
            if (i != array.length - 1) // On last element, don't push back a comma
                result += ", ";
        }

        return result;
    }
}
