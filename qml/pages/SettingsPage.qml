import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: settingspage

    SilicaFlickable {
        anchors.fill: parent
        Column {
            anchors.fill: parent
            DialogHeader {
                acceptText: qsTr("Save")
            }
            TextField {
                id: baseUrlField
                width: parent.width
                label: qsTr("Tracks base URL")
                placeholderText: qsTr("Tracks base URL")
                text: settings.base_url
                focus: true
                inputMethodHints: Qt.ImhUrlCharactersOnly

                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: usernameField.focus = true
            }
            TextField {
                id: usernameField
                width: parent.width
                label: qsTr("Username")
                placeholderText: qsTr("Username")
                text: settings.username
                inputMethodHints: Qt.ImhNoPredictiveText

                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: tokenField.focus = true
            }
            PasswordField {
                id: tokenField
                width: parent.width
                label: qsTr("Password")
                placeholderText: qsTr("Password")
                text: settings.token

                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: focus = false
            }
        }
        VerticalScrollDecorator {}
    }
    onDone: {
        if (result == DialogResult.Accepted) {
            settings.base_url = baseUrlField.text
            settings.username = usernameField.text
            settings.token = tokenField.text
        }
    }
}
