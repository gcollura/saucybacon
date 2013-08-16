import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem

ListItem.MultiValue {
    id: item
    progression: true

    text: contents.title
    values: [contents.totaltime, /*Object.values(contents.ingredients.name)*/]

    onClicked: openRecipe(docId)

    function openRecipe(id) {
        pageStack.push(recipePage);
        recipePage.setRecipe(id);
    }
}
