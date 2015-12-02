import QtQuick 2.3
import fbx.application 1.0
import fbx.ui.control 1.0
import fbx.async 1.0

Application {

    Column {
        anchors.centerIn: parent

        TextInput {
            id: url
            focus: true

            placeholderText: "URL ?"
            text: "home://"
            onEditingChanged: if (!editing) mediaType.focus = true;
            KeyNavigation.down: mediaType
        }

        TextInput {
            id: mediaType

            placeholderText: "type MIME ?"
            text: ""
            onEditingChanged: if (!editing) confirm.focus = true;
            KeyNavigation.up: url
            KeyNavigation.down: confirm
        }

        Button {
            id: confirm
            KeyNavigation.up: mediaType
            text: "Ouvrir"
            onClicked: App.urlOpen(url.text, mediaType.text)
        }
    }
}
