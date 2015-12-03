import QtQuick 2.4
import fbx.application 1.0

Application {
    property int size: 100
    property int ease: 10

    property bool play: true
    property bool win

    property int dx: Math.floor((Math.random() * 10) + 1)
    property int dy: Math.floor((Math.random() * 10) + 1)

    Rectangle {
        id: hole

        property int centerX: parent.width / 2
        property int centerY: parent.height / 2

        anchors.centerIn: parent
        color: "green"
        width: size + ease
        height: size + ease
    }

    Rectangle {
        id: ball

        property int centerX: ball.x + (size / 2)
        property int centerY: ball.y + (size / 2)
        property bool help: false

        focus: true
        radius: size / 2
        color: "white"

        width: size
        height: size

        x: dx
        y: dy

        Keys.onLeftPressed: dx--;
        Keys.onRightPressed: dx++;
        Keys.onUpPressed: dy--;
        Keys.onDownPressed: dy++;

        Text {
            visible: ball.help
            anchors.centerIn: parent
            text: "(" + dx + "," + dy + ")"
        }

        Keys.onReturnPressed: {
            if (!play) {
                dx = Math.floor((Math.random() * 10) + 1)
                dy = Math.floor((Math.random() * 10) + 1)
                play = true;
            }
        }

        Keys.onMenuPressed: help = !help;
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: size + ease
        text: win ? "win! :-)" : "loose! :-("
        visible: !play
        color: "green"
    }

    onFrameSwapped: {
        if (play == true && dx == 0 && dy == 0) {
            play = false;
            ball.help = false;
            console.log(ball.centerX, ball.centerY, hole.centerX, hole.centerY);

            if (((ball.centerX <= hole.centerX && ball.centerX > hole.centerX - ease) ||
                    (ball.centerX >= hole.centerX && ball.centerX < hole.centerX + ease)) &&
                    ((ball.centerY <= hole.centerY && ball.centerY > hole.centerY - ease) ||
                    (ball.centerY >= hole.centerY && ball.centerY < hole.centerY + ease))) {
                win = true;
            } else {
                win = false;
            }
        }

        if (play) {
            var x = ball.centerX;
            var y = ball.centerY;

            if ((dx > 0 && x >= width) || (dx < 0 && x <= 0)) {
                dx = -dx;
            }

            if ((dy > 0 && y >= height) || (dy < 0 && y <= 0)) {
                dy = -dy;
            }

            ball.x += dx;
            ball.y += dy;
        }
    }
}
