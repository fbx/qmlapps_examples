import QtQuick 2.5
import fbx.application 1.0
import fbx.async 1.0
import fbx.ui.control 1.0

Application {
    Column {
        anchors.centerIn: parent

        Button {
            focus: true
            text: "Parental"
            onClicked: {
                label.text = "Checking...";
                return Shell.request("parental_code_validate", { categoryV: true }).then(function(ret) {
                    label.text = "Accepted";
                }, function(err) {
                    label.text = "Error: " + JSON.stringify(err);
                });
            }
        }

        Label {
            id: label
        }
    }
}
