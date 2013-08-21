import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1

// Delete dialog

Dialog {
    id: dialogue
    title: i18n.tr("New category")
    text: i18n.tr("Create a new category for your recipes.")

    TextField {
        id: nameField
        placeholderText: i18n.tr("Name your category...")
        focus: true
    }

    Button {
        text: i18n.tr("Cancel")

        gradient: UbuntuColors.greyGradient
        onClicked: PopupUtils.close(dialogue)
    }

    Button {
        text: i18n.tr("Create")

        onClicked: {
            categories.push(nameField.text)
            caller.text = nameField.text
            PopupUtils.close(dialogue)
        }
    }
}
