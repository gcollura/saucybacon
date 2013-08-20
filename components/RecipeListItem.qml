import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem

ListItem.Subtitled {
    id: item
    progression: true

    text: contents.name
    subText: i18n.tr("%1\nIngredients: %2"
                     .arg(contents.totaltime).arg(listElement(contents.ingredients)))
    icon: Qt.resolvedUrl(contents.photos[0])

    Row {
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
        }
        Repeater {
            model: contents.difficulty + 1
            Text {
                color: "white"
                text: "\u2605"
                font.pixelSize: units.gu(2)
            }
        }
    }

    onClicked: openRecipe(docId)

    function openRecipe(id) {
        recipePage.recipe.docId = id;
        pageStack.push(recipePage);
    }

    function listElement(array) {
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
