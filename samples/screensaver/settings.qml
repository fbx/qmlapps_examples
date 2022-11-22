import QtQuick 2.3
import fbx.system 1.0
import fbx.application 1.0
import fbx.ui.page 1.0
import "." as Me

Application {
    id: self

    function handleUrl(action, url, mimeType)
    {
    }

    Me.SettingsClient {
        id: _settings
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    Stack {
        id: stack
        anchors.fill: parent
        focus: true
        baseUrl: Qt.resolvedUrl("./")
        Component.onCompleted: {
            stack.push("settings_main.qml", {settings: _settings})
        }

        function launch() {
            stack.push("settings_test.qml", {settings: _settings})
        }
    }
}
