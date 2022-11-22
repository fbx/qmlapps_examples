import QtQuick 2.7
import QtQuick.Window 2.2
import fbx.ui.page 1.0
import "." as Me

Page {
    id: self
    property QtObject settings

    Me.Bouncing {
        anchors.fill: parent
        focus: true
        onQuit: self.stack.pop()
        settings: self.settings
    }
}
