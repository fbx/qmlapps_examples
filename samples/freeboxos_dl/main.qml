import QtQuick 2.5
import fbx.application 1.0
import fbx.async 1.0
import fbx.web 1.0

Application {
    property var client

    Text {
        id: info

        anchors {
            centerIn: parent
        }
        color: "white"
        text: "Exemple de téléchargement sur le Freebox Server."
    }

    function client_init() {
        return Shell.request("gw_authz_query", {
            permissions: "downloader",
        }).then(function (ret) {
            console.log(JSON.stringify(ret));
            var authz = new FreeboxOSAuth.Client({
                app_token: ret.id,
                http_transaction_factory: Http.Transaction.debug_factory
            });
            client = new FreeboxOS.Client({
                suffix: "",
                http_transaction_factory: authz.http_transaction_factory
            });
            /* access to adder */
            client.add("downloads");
            client.downloads.add("add", {
                "content-type": "application/x-www-form-urlencoded"
            });
        }).fail(function (err) {
            console.error("client init failed:", err.value, err.message);
        });
    }

    function client_dl(uri) {
        console.debug("dl", uri);
        var args = { download_url: encodeURI(uri) };
        return client.downloads.add.create(args).then(function (result) {
            var task_id = result.id
            /* TODO poll task_id to get download progress */
            /* see http://dev.freebox.fr/sdk/os/download/#get--api-v3-downloads-{id} */
            info.text = "Le téléchargement de sintel-2048-stereo.mp4 est en cours... (tâche " + task_id + ")";
        });
    }

    Component.onCompleted: {
        client_init().then(function () {
            return client_dl("https://ia800200.us.archive.org/7/items/Sintel/sintel-2048-stereo.mp4");
        });
    }
}
