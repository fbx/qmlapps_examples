import QtQuick 2.7
import fbx.application 1.0
import "." as Me

Application {
    id: app

    function handleUrl(action, url, mimeType)
    {
    }

    Me.SettingsClient {
        //user settings
        id: _settings
    }

    Me.Bouncing {
        //boucing page
        anchors.fill: parent
        focus: true
        onQuit: Qt.quit()
        settings: _settings
    }
}
