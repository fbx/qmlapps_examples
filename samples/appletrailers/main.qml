import QtQuick 2.3
import QtQuick.XmlListModel 2.0
import QtMultimedia 5.0
import fbx.application 1.0

Application {
    Video {
        id: player
        anchors.fill: parent
        autoPlay: true
    }

    GridView {
        id: grid

        readonly property int columns: Math.floor(parent.width / cellWidth)

        focus: true
        width: columns * cellWidth
        anchors { top: parent.top; bottom: parent.bottom; horizontalCenter: parent.horizontalCenter }

        opacity: player.status === MediaPlayer.NoMedia
        Behavior on opacity { NumberAnimation { duration: 500 } }

        model: XmlListModel {
            source: "http://www.apple.com/trailers/home/xml/current_720p.xml"
            query: "/records/movieinfo"
            XmlRole { name: "poster"; query: "poster/location/string()" }
            XmlRole { name: "link"; query: "preview/large/string()" }
        }

        cellWidth: 134 + 3
        cellHeight: 193 + 3

        delegate: Item {
            height: GridView.view.cellHeight + 2
            width: GridView.view.cellWidth + 2

            Rectangle {
                anchors.fill: parent
                anchors.margins: 3
                color: "#202020"

                Image {
                    id: cover
                    anchors.fill: parent
                    anchors.margins: 2
                    source: model.poster
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    opacity: status == Image.Ready
                    Behavior on opacity { NumberAnimation { duration: 200 } }
                }
            }

            Keys.onReturnPressed: player.source = model.link
        }

        highlight: Rectangle {
            color: "transparent"
            border.width: 3
            border.color: "dodgerblue"
        }

        Keys.onPressed: {
            if (player.status !== MediaPlayer.NoMedia) {
                event.accepted = true;
                player.source = "";
            }
        }
    }
}
