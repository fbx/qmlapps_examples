import QtQuick 2.5
import fbx.application 1.0
import fbx.async 1.0
import fbx.cdm 1.0
import fbx.data 1.0

Application {
    function postMessageDRM_cwip(type, message) {
        let def = new Deferred.Deferred();
        let xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function() {
            if (xhr.readyState !== XMLHttpRequest.DONE) {
                return;
            }

            if (xhr.status !== 200) {
                def.reject();
                return;
            }

            let jobj = xhr.response;
            console.log("response: " + JSON.stringify(jobj));
            let license = Base64.toArrayBuffer(jobj.rawLicenseBase64);
            def.resolve(license);
        }.bind(this);
        let urlstr = "https://cwip-shaka-proxy.appspot.com/wrapped_request_and_response";
        xhr.open('POST', urlstr);
        xhr.setRequestHeader('Content-Type', 'application/json');
        let jobj = {};
        jobj.rawLicenseRequestBase64 = Base64.fromArrayBuffer(message);
        let msg = JSON.stringify(jobj);
        console.log("request: " + msg);
        xhr.responseType = "json";
        xhr.send(msg);
        return def;
    }

    property var chanInfo: ({
        title: "sintel",
        media_url: "dash+https://storage.googleapis.com/shaka-demo-assets/sintel-widevine/dash.mpd",
        keySystem: "com.widevine.alpha",
        crt_b64: "Cr8CCAMSEChwNFTACPY2GK3nRD22xMgYi+f5kAUijgIwggEKAoIBAQC1IRK40F0CP8xdleLCUcHGSbQXfNjSvu81W7BnQ95mHj0qvDGCt5lG1V/cCN/pVAeBXppidLMiosf14Ge7XwrAeonUWuqUslFvB1tm74EdDSbhuaa4lPK5hXliqhccT2ZjDT5MYCcYiX9eHvm2qvWtTboqfhQXbfE0odMYW1ohisBaTEHwge//gKOgQMULCbvHQO7c2PFNZ1qRmA+Syn3cZGoGra1RAfdKDkmMwB8AUyusIXhQvZBekJI2Vrff7+9CSGdn8z72KD1PQlSrcliTkL7lWAjx1mgIDUXYk8K8ovdNYKDA0KCZPO8BYEcDM0w2OBOUhrydryT9Z6B/mtlDAgMBAAE6EnN0YWdpbmcuZ29vZ2xlLmNvbRKAA5g+MDUmdfQLpxX8JJva5dSsckmiZmUh5DZVc5Upch/4gOCq78Xie8mA2uravz/DhtCEoCyCU3hIzHU/9JewEafal3iKAOKqa4TNfXHAekjr9hYCzKWj8yAwpylcMNqRW5HcGLm8lZO43ou1Dw3twSk4uOngOc3eGPqC6BuwMmMP6VXYWlZs4VQwC/bUwb0SaWY1ayh9ZXsYzmPQ79RfxSael+qxHLVj5VZDsm/0nxCcIQGvyvNbgy8ojw2dRZYOJZ6F+10k29LPgnZMXdm/cn776chh+GkyH2reGJBfTZL5ptplNtuEdYcdFo6HC7IwPPcMbpeEyT0t6EWtgmK+fg1OLkoHWc74LRCdJZLHJCn4wBdCuuKz3srbwzw+X0uvXhbst06tuvy3xnBfep47bzlAOD+cURbSAqIMkinulpwlGXGDA7UNATDDNS4GsBTYOFQPigwifAAR4PWzjk4pjtLLMB60Vkll9VxdeXV6JQpOuchKs+ZTn2tv31aJnqKZFA==",
        postMessageDRM_cb: postMessageDRM_cwip,
    })

    function createSupportedKeySystem() {
        let serviceCertificate;
        let mediaKeys;

        if (chanInfo.crt_b64) {
            serviceCertificate = Base64.toArrayBuffer(chanInfo.crt_b64);
        } else {
            serviceCertificate = null;
        }

        return Cdm.requestMediaKeySystemAccess(chanInfo.keySystem, []).then(function (keySystemAccess) {
            return keySystemAccess.createMediaKeys();
        }).then(function (createdMediaKeys) {
            mediaKeys = createdMediaKeys;

            if (serviceCertificate === null) {
                return false;
            }

            return mediaKeys.setServerCertificate(serviceCertificate);
        }).then(function(boolret) {
            return mediaKeys;
        });
    }

    function postMessageDRM(type, message) {
        return chanInfo.postMessageDRM_cb(type, message);
    }

    function licenseRequestReady(event) {
        let keySession = event.target;
        postMessageDRM(event.messageType, event.message).then(function(response) {
            keySession.update(response);
        });
    }

    function makeNewRequest(mediaKeys, initDataType, initData) {
        let keySession = mediaKeys.createSession();
        keySession.onmessage = licenseRequestReady;
        keySession.generateRequest(initDataType, initData);
    }

    function addSession(video, initDataType, initData) {
        if (video.userdata.mediaKeysObject) {
            makeNewRequest(video.userdata.mediaKeysObject, initDataType, initData);
        } else {
            let data = {
                initDataType: initDataType,
                initData: initData
            };
            video.userdata.pendingSessionData.push(data);
        }
    }

    function handleInitData(event) {
        let video = event.target;

        if (video.userdata.mediaKeysObject === undefined) {
            video.userdata.mediaKeysObject = null;
            video.userdata.pendingSessionData = [];

            createSupportedKeySystem().then(function(createdMediaKeys) {
                video.userdata.mediaKeysObject = createdMediaKeys;

                for (let i = 0; i < video.userdata.pendingSessionData.length; i++) {
                    let data = video.userdata.pendingSessionData[i];
                    makeNewRequest(video.userdata.mediaKeysObject, data.initDataType, data.initData);
                }

                video.userdata.pendingSessionData = [];

                return video.setMediaKeys(createdMediaKeys);
            });
        }

        addSession(video, event.initDataType, event.initData);
    }

    Player {
        id: player
        anchors.fill: parent
        title: chanInfo.title
        focus: true
        property var userdata: ({})
        onEncrypted: handleInitData(encryptedEvent)
        Component.onCompleted: urlOpen(chanInfo.media_url)
    }
}
