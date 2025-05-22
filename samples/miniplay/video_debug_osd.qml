import QtQuick 2.5

Item {
    id: self

    property string debugOsdString: ""

    implicitWidth: 1920
    implicitHeight: 1080

    onDebugOsdStringChanged: debugOsdText.text = debugOsdString

    Rectangle {
        color: "#000000"
        width: debugOsdText.contentWidth
        height: debugOsdText.contentHeight
        opacity: 0.3
    }

    Text {
        id: debugOsdText
        anchors {
            left: parent.left
            right: parent.right
        }
        color: "#ffffff"
        wrapMode: Text.Wrap
        font.family: "Helvetica"
        font.pixelSize: 14
        style: Text.Raised
        styleColor: "#000000"
    }
}
