import QtQuick 2.4
import QtQuick.XmlListModel 2.0
import QtMultimedia 5.5
import fbx.application 1.0
import fbx.ui.control 1.0
import fbx.ui.dialog 1.0

Application {
    id: main

    XmlListModel {
        id: flocks
        namespaceDeclarations: "declare namespace media='http://search.yahoo.com/mrss/';"
        source: "https://archive.org/services/collection-rss.php?collection=TheVideoCellarCollection"
        query: "/rss/channel/item"

        XmlRole { name: "title"; query: "media:title/string()" }
        XmlRole { name: "pubDate"; query: "pubDate/string()" }
        XmlRole { name: "content"; query: "media:content/@url/string()" }
        XmlRole { name: "type"; query: "media:content/@type/string()" }
        XmlRole { name: "thumbnail"; query: "media:thumbnail/@url/string()" }
    }

    ListView {
        id: list
        focus: true
        orientation: ListView.Vertical
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: 5
        width: parent.width / 2

        model: flocks

        delegate: VideoItem {
            width: parent.width
            height: 120

            title: model.title
            pubDate: model.pubDate
            content: model.content
            type: model.type
            thumbnail: model.thumbnail

            Keys.onReturnPressed: {
                if (content) {
                    loading.visible = true;
                    player.source = content;
                } else {
                    return Dialog.create(main, popup, { title: "Erreur", text: "Pas de contenu", buttons: ['ok']});
                }
            }
        }

        highlight: Rectangle {
            color: "transparent"
            border.color: "#0088BB"
            border.width: 3
            radius: 2
        }
    }

    MediaPlayer {
        id: player

        autoLoad: true;
        autoPlay: true;

        onPlaying: {
            loading.visible = false;
        }
    }

    VideoOutput {
        id: video
        source: player

        anchors.left: list.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: 5
    }

    Loading {
        id: loading
        visible: false
        anchors.centerIn: parent
    }

    Component {
        id: popup
        Alert { }
    }
}
