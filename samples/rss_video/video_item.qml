import QtQuick 2.4

Item {
    property string title
    property string content
    property string type
    property string thumbnail
    property bool details

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
        font.pointSize: 20
        color: "white"
        elide: Text.ElideRight
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: img.right
        anchors.right: parent.right
        anchors.margins: 5
        horizontalAlignment: Text.AlignRight
    }

    Text {
        text: "média de type " + type + ""
        color: "gray"
        font.pointSize: 15
        anchors.bottom: parent.bottom
        anchors.top: title.bottom
        anchors.left: img.right
        anchors.right: parent.right
        anchors.margins: 5
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignBottom
        visible: details
    }
}
