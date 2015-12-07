import QtQuick 2.4

Item {
    property string title
    property string pubDate
    property string content
    property string type
    property string thumbnail

    Image {
        id: img
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 5

        source: thumbnail
        fillMode: Image.PreserveAspectFit
    }

    Text {
        text: title
        color: "white"
        anchors.bottom: parent.bottom
        anchors.left: img.right
        anchors.right: parent.right
        anchors.margins: 5
        horizontalAlignment: Text.AlignRight
    }
}

