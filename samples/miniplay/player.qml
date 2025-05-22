import QtQuick 2.5
import fbx.media 1.0 as Media
import fbx.ui.menu 1.0 as Menu

Media.VideoPlayer {
    id: player

    property string lastError: ""
    property string lastDebugOsdString: ""
    property string title: ""
    signal vscSeek()

    VideoDebugOsd {
        anchors {
            left: parent.left
            leftMargin: 10
            right: parent.right
        }
        opacity: player.lastDebugOsdString != ""
        debugOsdString: player.lastDebugOsdString
        Behavior on opacity {
            NumberAnimation {
            }
        }
    }

    onDebugOsdString: lastDebugOsdString = str

    Media.PlayerTimeline {
        id: playerController
        player: player
        name: title
    }

    Media.VideoSeekController {
        id: vsc
        focus: true
        playerPosition: player.status.curPos - player.status.minPos
        duration: player.status.maxPos - player.status.minPos

        onSeek: {
            var newPos = Math.min(parseFloat(player.status.minPos) + position, parseFloat(player.status.maxPos))
            player.seek(newPos)
            player.vscSeek()
        }

        onPlayPause: player.playPause()
    }

    Menu.Menu {
        id: menu
        title: "Options"
        Menu.Section {
            text: "OSD"
        }
        Menu.Action {
            text: player.debugOsd ? "Disable" : "Enable"
            onClicked: player.debugOsdSet(!player.debugOsd)
        }
        Menu.Section {
            text: "Audio/Vidéo"
        }
        Menu.Submenu {
            target: player.streamMenu
        }
    }

    Menu.View {
        id: menuView
        returnFocusTo: vsc
        root: menu
    }

    Keys.onMenuPressed: {
        menuView.focus = true
    }

    VideoError {
        anchors.centerIn: parent
        opacity: player.mediaState == "error"
        error: player.lastError
        Behavior on opacity {
            NumberAnimation {
            }
        }
    }

    onError: {
	    var o = {};
	    o.error = error;
	    o.fatal = fatal;
	    o.priv = priv;
	    console.log("error: " + JSON.stringify(o));
	    lastError = error;
    }
}
