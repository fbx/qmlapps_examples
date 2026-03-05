import QtQuick 2.0
import fbx.application 1.0

Application {
    ListModel {
        id: deeplinksModel

        ListElement {
            name: "What is my viewport"
            url: "https://whatismyviewport.com/"
            mimeType: "application/vnd.freebox.app-dev"
        }

        ListElement {
            name: "Test UFO"
            url: "https://testufo.com/"
            mimeType: "application/vnd.freebox.app-dev"
        }

        ListElement {
            name: "MotionMark 1.3.1"
            url: "https://browserbench.org/MotionMark1.3.1/"
            mimeType: "application/vnd.freebox.app-dev"
        }

        ListElement {
            name: "WebGL: check support"
            url: "https://get.webgl.org/"
            mimeType: "application/vnd.freebox.app-dev"
        }

        ListElement {
            name: "WebGL: report"
            url: "https://webglreport.com"
            mimeType: "application/vnd.freebox.app-dev"
        }

        ListElement {
            name: "WebGL2: check"
            url: "https://get.webgl.org/webgl2"
            mimeType: "application/vnd.freebox.app-dev"
        }

        ListElement {
            name: "WebGL2: report"
            url: "https://webglreport.com?v=2"
            mimeType: "application/vnd.freebox.app-dev"
        }

        ListElement {
            name: "WebGL: Matrix"
            url: "https://rezmason.github.io/matrix/"
            mimeType: "application/vnd.freebox.app-dev"
        }

        ListElement {
            name: "WebGL: Jellyfish"
            url: "https://archibold.io/demo/jellyfish/"
            mimeType: "application/vnd.freebox.app-dev"
        }

        ListElement {
            name: "Canvas: Night Drive"
            url: "https://incoherency.co.uk/nightdrive/"
            mimeType: "application/vnd.freebox.app-dev"
        }
    }

    ListView {
        anchors.fill: parent
        model: deeplinksModel
        focus: true
        delegate: Text {
            color: "white"
            font.pixelSize: 26
            text: model.name
            Keys.onReturnPressed: {
                App.urlOpen(model.url, model.mimeType)
            }
        }
        highlight: Rectangle {
            color: "steelblue"
        }
    }
}
