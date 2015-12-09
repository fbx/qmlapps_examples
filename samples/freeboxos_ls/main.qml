import QtQuick 2.5
import fbx.application 1.0
import fbx.async 1.0
import fbx.web 1.0

Application {
    property var client

    ListModel { id: listing }

    ListView {
        anchors.fill: parent
        focus: true
        model: listing
        delegate: Text {
            color: "white"
            text: model.name
            Keys.onReturnPressed: {
                if (model.type === "dir") {
                    client_list(model.path);
                } else {
                    var exp = Math.floor((new Date().getTime() + 300000) / 1000); /* now + 5 min */
                    return client.share_link.create({ path: model.path, expire: exp }).then(function (resp) {
                        /* open share-link fullurl externally */
                        App.urlOpen(resp.fullurl, model.mimetype);
                    }, function (err) {
                        console.log(JSON.stringify(err));
                    });
                }
            }
        }

        highlight: Rectangle { radius: 2; color: "dodgerblue" }
    }

    function client_init() {
        return Shell.request("gw_authz_query", {
            permissions: "explorer",
        }).then(function (ret) {
            var authz = new FreeboxOSAuth.Client({
                app_token: ret.id,
                //http_transaction_factory: Http.Transaction.debug_factory
            });
            client = new FreeboxOS.Client({
                suffix: "",
                http_transaction_factory: authz.http_transaction_factory
            });
            /* access to files */
            client.add("fs");
            client.fs.add("ls");

            /* access to share-link creation */
            client.add("share_link", { suffix: "/" });
        }).fail(function (err) {
            console.error("client init failed:", err.value, err.message);
        });
    }

    function client_list(path) {
        console.debug("list", path);
        return client.fs.ls(path).read().then(function (files) {
            listing.clear();
            for (var i = 0; i < files.length; i++)
                listing.append(files[i]);
        });
    }

    Component.onCompleted: {
        client_init().then(function () {
            return client_list("/");
        });
    }
}
