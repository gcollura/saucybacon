import QtQuick 2.0
import Ubuntu.Components 0.1

Row {
    id: ingredient
    width: parent.width
    spacing: units.gu(1)

    property alias name: ingredientName.text
    property alias quantity: ingredientQuantity.text
    property alias type: ingredientQuantityType.text

    TextField {
        id: ingredientName
        width: parent.width - units.gu(23)

        placeholderText: i18n.tr("Insert ingredient name")
    }

    TextField {
        id: ingredientQuantity
        width: units.gu(8)

        inputMethodHints: Qt.ImhFormattedNumbersOnly
        placeholderText: i18n.tr("Qty")
    }

    TextField {
        id: ingredientQuantityType
        width: units.gu(8)

        placeholderText: i18n.tr("Type")
    }

    Button {
        id: cancelButton
        width: units.gu(4)
        height: width

        iconSource: icon("close")

        onClicked: ingredient.destroy()
    }
}
