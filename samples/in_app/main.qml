import QtQuick 2.5
import QtQuick.Layouts 1.0
import fbx.application 1.0
import fbx.inapp 1.0
import fbx.data 1.0
import fbx.ui.control 1.0
import fbx.ui.base 1.0

Application {
    id: app

    property bool inhibitBuy: false

    ListModel {
        id: items

        function reload() {
            items.clear();
            return InApp.items().then(function(ret) {
                for (var i = 0; i < ret.length; i++)
                    items.append(ret[i]);
            }, function (err) {
                console.error("items listing failed:", err.message);
            });
        }

        Component.onCompleted: reload()
    }

    ListModel {
        id: transactions

        function reload() {
            transactions.clear();
            return InApp.transactions().then(function(ret) {
                for (var i = 0; i < ret.length; i++)
                    transactions.append(ret[i]);
            }, function (err) {
                console.error("transactions listing failed:", err.message);
            });
        }

        Component.onCompleted: reload()
    }

    GridLayout {
        anchors.fill: parent
        anchors.margins: 20
        columns: 4

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: itemView.activeFocus ? "#222222" : "#090909"
            radius: 5
            clip: true

            ListView {
                id: itemView
                anchors.fill: parent
                anchors.margins: 5
                focus: true
                model: items
                delegate: itemDelegate
                header: Text {
                    font.pixelSize: 24
                    font.bold: true
                    color: "white"
                    text: "Available Items"
                }
                KeyNavigation.right: transactionView
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: transactionView.activeFocus ? "#222222" : "#090909"
            radius: 5
            clip: true

            ListView {
                id: transactionView
                anchors.fill: parent
                anchors.margins: 5
                model: transactions
                delegate: transactionDelegate
                header: Text {
                    font.pixelSize: 24
                    font.bold: true
                    color: "white"
                    text: "Transactions"
                }
                KeyNavigation.left: itemView
            }
        }
    }

    Component {
        id: itemDelegate
        Button {
            width: parent.width
            height: content.height + 10
            enabled: !inhibitBuy

            Column {
                id: content
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: 20
                    verticalCenter: parent.verticalCenter
                }
                Label { color: "lightgray"; text: model.akey }
                Label { color: "lightgray"; text: model.description + ", " + model.type + ", " + Formatter.number(model.priceCents / 100, 2, ",", " ") + " €" }
            }

            onClicked: {
                inhibitBuy = true;
                InApp.buyItem(model).then(function(ret) {
                    console.log("Ok, transaction id is:", ret.transactionId);
                }),(function (err) {
                    console.error("Cannot buy item:", JSON.stringify(err));
                }).both(function () {
                    inhibitBuy = false;
                });
            }
        }
    }

    Component {
        id: transactionDelegate
        Item {
            width: parent.width
            height: content.height + 10
            Column {
                id: content
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: 20
                    verticalCenter: parent.verticalCenter
                }
                Label { text: model.akey }
                Label { text: model.when }
            }
        }
    }
}
