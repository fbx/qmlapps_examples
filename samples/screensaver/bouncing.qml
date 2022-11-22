import QtQuick 2.7
import fbx.data 1.0 as Data
import QtQuick.Window 2.1
import QtGraphicalEffects 1.12

FocusScope {
    id: self
    property QtObject settings

    //random speed on x
    property real __speedX: Math.random() * 10
    //random speed on y
    property real __speedY: Math.random() * 4

    //define screen borders
    readonly property int __maxX: self.width - logo.width
    readonly property int __maxY: self.height - logo.height

    //current logo color
    property string currentColor: {
        if (settings.color == "variable") {
            return randomColor()
        } else {
            return settings.color
        }
    }

    signal quit()

    //as soon as user clicks, page is quit
    Keys.onReleased: {
        if (!event.isAutoRepeat)
            self.quit()
    }

    //update coordinates on each frame
    Connections {
        //signal on each frame
        target: self.Window.window
        onBeforeRendering: self.willRender()
    }

    //choose a random color
    function randomColor() {
        //define colors available when settings.color == variable
        var colors = ["#CC0000", "#00CC00", "#0000CC", "#36769C", "#E88083",
            "#68B9E8", "#E8E551", "#9C6956", "#6F7182", "#38CF3D"]
        var idx = Math.floor(Math.random() * colors.length)
        return colors[idx]
    }

    //update coordinates on each frame
    function willRender() {
        logo.x += __speedX
        logo.y += __speedY
        //check if bounce
        manageBounce()
    }

    //check if bounce
    function manageBounce() {
        var bounced = false
        if ((logo.x <= 0) ||(logo.x >= __maxX)) {
            //bounce on x axis => change __speedX
            __speedX = - __speedX
            bounced = true
        }
        if ((logo.y <= 0) || (logo.y >= __maxY)) {
            //bounce on y axis => change __speedY
            __speedY = - __speedY
            bounced = true
        }
        if (bounced && settings.color == "variable") {
            //change color on bounce
            self.currentColor = randomColor()
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    Item {
        id: logo
        x: Math.floor(Math.random() * 700) + 100    //random position on x
        y: Math.floor(Math.random() * 400) + 100    //random position on y
        height: 94
        width: 200
        Image {
            id: pic
            anchors.fill: parent
            source: "logo.png"
            visible: false
        }
        ColorOverlay {
              anchors.fill: pic
              source: pic
              color: self.currentColor  //change color of original image
        }
    }
}
