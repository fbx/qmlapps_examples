import QtQuick 2.4
import fbx.application 1.0
import fbx.ui.page 1.0

Application {
    id: self

    property int pushCount: 0

    Stack {
        id: stack
        anchors.fill: parent
        focus: true
        baseUrl: Qt.resolvedUrl(".")
        canPopRoot: true

        Keys.onReturnPressed: {
            stack.push("page.qml", { pushCount: ++self.pushCount }, "Title Here");
        }
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        color: "green"
        font.pixelSize: 40
        text: "press ok to push a new page on stack\nand back to pop it"
        horizontalAlignment: Text.Center
    }
}
