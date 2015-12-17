import QtQuick 2.4
import fbx.application 1.0
import fbx.ui.page 1.0
import fbx.ui.layout 1.0
import "client" 1.0

Application {
    Background {
        background: "player"
    }

    Breadcrumb {
        id: breadcrumb

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        stack: pageStack

        KeyNavigation.down: pageStack
    }

    Stack {
        id: pageStack

        anchors {
            top: breadcrumb.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        focus: true

        baseUrl: Qt.resolvedUrl("pages/")

        KeyNavigation.up: breadcrumb
    }

    property Client client: Client { }

    property bool ready: client.ready
    property bool ok: client.ready && client.token

    onReadyChanged: {
        if (ready) {
            pageStack.push("login.qml", { client: client });
        }
    }

    onOkChanged: {
        if (ok) {
            pageStack.replace("browse.qml", { client: client });
        }
    }
}
