import QtQuick 2.2
import fbx.ui.page 1.0
import fbx.ui.control 1.0
import "../client" 1.0

Page {
    title: "Google+ Profile"

    property Client client

    Row {
        anchors.centerIn: parent
        spacing: 25

        Text {
            id: welcome
            color: "white"
            font.pixelSize: 50

        }

        Image {
            id: pic
            fillMode: Image.PreserveAspectFit
        }
    }

    Text {
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }

        font.pointSize: 18
        color: "white"
        text: "this name and picture are taken from the Google+ authentified REST api"
    }

    onDidAppear: {
        return client.plus.people.me.read()
        .then(function (json) {
            welcome.text = "Welcome " + json.name.givenName + " " + json.name.familyName;
            pic.source = json.image.url;
        }, function (err) {
            console.log(err.value);
        });
    }
}
