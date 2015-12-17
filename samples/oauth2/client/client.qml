import QtQuick 2.0
import fbx.async 1.0
import fbx.web 1.0
import "secret.js" as Secret

QtObject {
    id: self

    property var plus
    property var authz

    property string token
    property bool ready: false

    Component.onCompleted: {
        /* creating the google authentication client */
       self.authz = new Oauth.Client({
            version: "2.0",
            authorization_url: Secret.auth_uri,
            access_token_url: Secret.token_uri,
            callback_url: Secret.redirect_uris[0],
            client_id: Secret.client_id,
            client_secret: Secret.client_secret,
            body_client_authentication: true,
            use_authorization_header: true,
            approval_prompt: "force"
        });

        self.authz.changed = function() {
            self.token = self.authz.save();
            console.log("Google access token", self.token);
            /* TODO: save it in settings for future use */
        };

        /* reset authz with: */
        /* authz.restore(self.token); */

        /* creating the REST client for G+ */
        self.plus = new Rest.Client("https://www.googleapis.com/plus/v1", {
            http_transaction_factory: self.authz.http_transaction_factory,
            suffix: ""
        });

        /* preparing REST urls to access */
        self.plus.add("people");
        self.plus.people.add("me");

        /* etc. see: https://developers.google.com/+/web/api/rest/ */
        self.ready = true;
    }
}
