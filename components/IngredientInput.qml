import QtQuick 2.0
import Ubuntu.Components 0.1

Row {
    id: ingredient
    width: parent.width
    spacing: units.gu(2)

    property alias name: ingredientName.text
    property alias quantity: ingredientQuantity.text

    TextField {
        id: ingredientName
        width: parent.width - units.gu(16)

        placeholderText: i18n.tr("Insert ingredient name")
    }

    TextField {
        id: ingredientQuantity
        width: units.gu(8)

        inputMethodHints: Qt.ImhDigitsOnly
    }

    Button {
        id: cancelButton
        width: units.gu(4)
        height: width

        iconSource: icon("close")

        onClicked: ingredient.destroy()
    }
}
