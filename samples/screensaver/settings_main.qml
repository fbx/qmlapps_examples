import QtQuick 2.3
import fbx.ui.control 1.0 as Controls
import fbx.ui.page 1.0 as Page
import fbx.ui.settings 1.0 as SettingsUi

SettingsUi.Page {
    id: self
    anchors.leftMargin: 100
    anchors.rightMargin: 100
    focus: true
    infoWanted: false
    property QtObject settings

    Text {
        font.pixelSize: 30
        font.bold: true
        color: "white"
        anchors.horizontalCenter: parent.horizontalCenter
        height: 100
        verticalAlignment: Text.AlignVCenter
        text: "Réglages"
    }

    Item {
        width: 40
        height: 50
    }

    SettingsUi.Entry {
        text: "Couleur du logo"
        Controls.Combo {
            id: primaryOutputCombo
            __rightMargin: 20
            height: 50
            width: 300
            anchors.right: parent.right
            anchors.rightMargin: 10
            alignment: "AlignRight"

            items: ListModel {
                ListElement { label: "Variable"; value: "variable" }
                ListElement { label: "Rouge"; value: "#CC0000" }
                ListElement { label: "Bleu"; value: "#0000CC" }
                ListElement { label: "Vert"; value: "#00CC00" }
            }
            Component.onCompleted: {
                value = settings.color
            }
            onSelected: {
                settings.color = value
            }
        }
    }

    Item {
        width: 40
        height: 50
    }

    SettingsUi.LinkButton {
        text: "Tester l'écran de veille"
        visible: settings.text != ""
        onClicked: self.stack.launch()
    }
}
