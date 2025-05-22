import QtQuick 2.5

Item {
    id: self

    property string error: ""
    property alias title: headerText.text
    property alias detail: errText.text

    implicitWidth: 700
    implicitHeight: 320

    function getDescription(error) {
        switch (error) {
        case "UnknownStream":
            return [ "Erreur vidéo", "Le chargement de la vidéo a échoué." ];
        case "ProtectedStream":
            return [ "Erreur vidéo", "Le flux est protégé, votre matériel n'en permet pas la lecture." ];
        case "ConnectFailed":
            return [ "Erreur vidéo", "La connexion au serveur a échoué." ];
        case "Timeout":
            return [ "Erreur vidéo", "Le serveur distant ne répond pas." ];
        case "NotEnoughBandwidth":
            return [ "Erreur de débit", "Débit insuffisant." ];
        case "MaxSession":
            return [ "Erreur de session", "Nombre maximal de sessions atteint." ];
        case "RemoteDisconnect":
            return [ "Erreur de session", "La session n'existe plus." ];
        case "Internal":
            return [ "Erreur vidéo", "Erreur du serveur distant." ];
        case "ConnectFailed":
            return [ "Erreur vidéo", "La connexion au réseau a été interrompue." ];
        case "AuthorizationRequired":
        case "PaymentRequired":
            return [ "Erreur vidéo", "Accès refusé." ];
        case "BadRequest":
            return [ "Erreur vidéo", "Programme demandé non disponible." ];
        case "RemoteDisconnect":
            return [ "Erreur vidéo", "Diffusion interrompue par le serveur distant." ];
        case "Morality":
            return [ "Contrôle parental", "Cette vidéo est interdite aux mineurs." ];
        case "DashMpdFetch":
            return [ "DASH Error : " + error, "mpd fetch failed" ];
        case "DashMpdParse":
            return [ "DASH Error : " + error, "mpd parse failed" ];

        default:
            return [ "Erreur vidéo", "Erreur vidéo inconnue" ];
        }
    }

    onErrorChanged: {
        var e = getDescription(error);
        title = e[0];
        detail = e[1];
    }

    Column {
        anchors {
            left: parent.left
            leftMargin: 10
            right: parent.right
            verticalCenter: parent.verticalCenter
        }

        spacing: 5

        Text {
            id: headerText
            anchors {
                left: parent.left
                right: parent.right
            }
            color: "white"
            font {
                pixelSize: 24
                bold: true
                capitalization: Font.AllUppercase
            }
        }

        Text {
            id: errText
            anchors {
                left: parent.left
                right: parent.right
            }
            color: "#a0a0a0"
            wrapMode: Text.Wrap
            font.pixelSize: 20
        }
    }
}
