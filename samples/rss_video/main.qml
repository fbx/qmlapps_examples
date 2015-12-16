import QtQuick 2.4
import QtQuick.XmlListModel 2.0
import QtMultimedia 5.5
import fbx.application 1.0
import fbx.ui.control 1.0
import fbx.ui.dialog 1.0
import fbx.ui.menu 1.0 as M

Application {
    id: main

    XmlListModel {
        id: trailers
        namespaceDeclarations: "declare namespace media='http://search.yahoo.com/mrss/';"
        source: "https://archive.org/services/collection-rss.php?collection=TheVideoCellarCollection"
        query: "/rss/channel/item"

        XmlRole { name: "title"; query: "media:title/string()" }
        XmlRole { name: "content"; query: "enclosure/@url/string()" }
        XmlRole { name: "type"; query: "enclosure/@type/string()" }
        XmlRole { name: "thumbnail"; query: "media:thumbnail/@url/string()" }
    }

    ListView {
        id: list

        property bool details: false

        focus: true
        orientation: ListView.Vertical
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: 5
        width: parent.width / 2

        model: trailers

        delegate: VideoItem {
            width: parent.width
            height: 120

            title: model.title
            content: model.content
            type: model.type
            thumbnail: model.thumbnail
            details: list.details

            Keys.onReturnPressed: {
                if (!content) {
                    return Dialog.create(main, popup, { title: "Erreur", text: "Pas de contenu", buttons: ['ok']});
                }

                if (content != player.source) {
                    loading.visible = true;
                    player.source = content;
                } else {
                    if (player.playbackState == MediaPlayer.PlayingState) {
                        player.pause();
                    } else {
                        player.play();
                    }
                }
            }
        }

        highlight: Rectangle {
            color: "transparent"
            border.color: "dodgerblue"
            border.width: 3
            radius: 2
        }

        Keys.onMenuPressed: menu.focus = true;
    }

    MediaPlayer {
        id: player

        autoLoad: true;
        autoPlay: true;

        onPlaying: {
            loading.visible = false;
        }

        onErrorChanged: {
            if (error !== MediaPlayer.NoError) {
                App.notifyUser(errorString);
            }
        }
    }


    VideoOutput {
        id: video
        source: player
        anchors {
            left: list.right
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }

        Loading {
            id: loading
            visible: false
            anchors.centerIn: parent
        }
    }

    M.View {
        id: menu
        returnFocusTo: list
        root: M.Menu {
            title: "Liste"
            M.Action { text: "Recharger"; onClicked: trailers.reload(); }
            M.Action { text: "Détails"; onClicked: list.details = !list.details; }
        }
    }

    Component {
        id: popup
        Alert { }
    }
}
