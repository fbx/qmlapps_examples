import QtQuick 2.4
import fbx.application 1.0

Application {
    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    Text {
        focus: true
        anchors.centerIn: parent

        color: "white"
        font.pixelSize: 40

        text: "appuyez sur une touche de la télécommande ou d'un calvier"

        Keys.onPressed: {
            if (event.key === Qt.Key_Back)
                Qt.quit();
            switch (event.key) {
            case Qt.Key_0:
            case Qt.Key_1:
            case Qt.Key_2:
            case Qt.Key_3:
            case Qt.Key_4:
            case Qt.Key_5:
            case Qt.Key_6:
            case Qt.Key_7:
            case Qt.Key_8:
            case Qt.Key_9:
                text = "touche " + (parseInt(event.key) - parseInt(Qt.Key_0)) + ", code : " + event.key;
                break;
            case Qt.Key_Up:
                text = "touche haut, code : " + event.key;
                break;
            case Qt.Key_Down:
                text = "touche bas, code : " + event.key;
                break;
            case Qt.Key_Left:
                text = "touche gauche, code : " + event.key;
                break;
            case Qt.Key_Right:
                text = "touche droite, code : " + event.key;
                break;
            case Qt.Key_Search:
                text = "touche recherche (bleu), code : " + event.key;
                break;
            case Qt.Key_Menu:
                text = "touche menu (vert), code : " + event.key;
                break;
            case Qt.Key_Info:
                text = "touche info (jaune), code : " + event.key;
                break;
            case Qt.Key_MediaTogglePlayPause:
                text = "touche média play / pause, code : " + event.key;
                break;
            case Qt.Key_MediaRecord:
                text = "touche enregistrement, code : " + event.key;
                break;
            case Qt.Key_Return:
                text = "touche OK / Entrée, code : " + event.key;
                break;
            default:
                text = "touche, code : " + event.key;
            }
        }
    }
}
