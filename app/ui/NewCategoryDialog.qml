import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1

// New category dialog

Dialog {
    id: dialogue
    title: i18n.tr("New category")
    text: i18n.tr("Create a new category for your recipes.")

    TextField {
        id: nameField
        placeholderText: i18n.tr("Name your category...")
    }

    Button {
        text: i18n.tr("Cancel")

        gradient: UbuntuColors.greyGradient
        onClicked: {
            caller.selectedIndex = 0;
            PopupUtils.close(dialogue);
        }
    }

    Button {
        text: i18n.tr("Create")

        onClicked: {
            if (categories.indexOf(nameField.text) < 0)
                categories.push(nameField.text)
            caller.values = caller.update()
            caller.selectedIndex = categories.indexOf(nameField.text)
            PopupUtils.close(dialogue)
        }
    }

    Component.onCompleted: nameField.forceActiveFocus()
}
