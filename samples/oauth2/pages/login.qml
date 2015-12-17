import QtQuick 2.2
import QtWebKit 3.0
import fbx.hardware 1.0
import fbx.ui.page 1.0
import fbx.ui.control 1.0
import "../client" 1.0

Page {
    title: "Google Login"

    property Client client

    Text {
        id: ask
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        height: 50

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: "white"
        font.pixelSize: 25
        text: "Veuillez autoriser l'application à se connecter à votre Compte Google"
    }

    WebView {
        id: web

        anchors {
            top: ask.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        focus: true

        onUrlChanged: {
            var regex = new RegExp("^" + Secret.redirect_uris[0]);
            if (url.toString().match(regex)) {
                console.debug("URL is callback", url)
                client.authz.authorizationCallbackHandle(url).then(function (data) {
                    console.log("Client is now authenticated");
                    mouse.required = false;
                });
            }
        }
    }


    onDidAppear: {
        /* ask only for google "profile" capability for this sample */
        client.authz.authorizationUrlQuery("profile").then(function (url) {
            web.url = url;
        });
    }

    Pointer {
        id: mouse
        required: true
    }
}
