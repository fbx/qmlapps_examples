import QtQuick 2.4
import fbx.application 1.0
import fbx.web 1.0

Application {
    id: app

    function getFirstChild(item, tag) {
        var childs = item.childNodes;
        for (var i = 0; i < childs.length; i++) {
            if (childs[i].tagName === tag) {
                return childs[i];
            }
        }
    }

    function getChildren(item, tag) {
        var childs = item.childNodes;
        var tags = [];
        for (var i = 0; i < childs.length; i++) {
            if (childs[i].tagName === tag) {
                tags.push(childs[i]);
            }
        }
        return tags;
    }

    function fetchTitles() {
        var trn = Http.Transaction.factory({
            method: "get",
            url: "https://dev.freebox.fr/blog/?feed=rss2&cat=1",
            headers: {
                "accept": "text/xml",
            }
        });

        trn.send().then(function (response) {
            var xml = response.xmlParse();
            var doc = xml.document;
            var channel = getFirstChild(doc, "channel");
            var items = getChildren(channel, "item");
            for (var it = 0; it < items.length; it++) {
                var title = getFirstChild(items[it], "title")
                titlesmodel.append({ title: title.firstChild.nodeValue });
            }
        });
    }

    ListModel {
        id: titlesmodel
        //ListElement {title: "foo"}
    }

    ListView {
        id: list
        anchors.fill: parent
        anchors.margins: 40
        model: titlesmodel
        delegate: Text {
            color: "white"
            text: title
        }
    }

    Component.onCompleted: {
        fetchTitles();
    }
}
