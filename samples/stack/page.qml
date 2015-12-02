import QtQuick 2.4
import fbx.ui.page 1.0

Page {
    id: self

    property int pushCount: 0

    Text {
        anchors.centerIn: parent
        color: "white"
        font.pixelSize: 40
        text: "page " + pushCount
    }
}
