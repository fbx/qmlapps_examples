import QtQuick 2.3
import fbx.application 1.0

QtObject {
    id: self
    property alias color: settings.color

    property Settings settings: Settings {
        id: settings
        property string color: "variable"   //color by default
        onReady: self.ready()               //settings are ready
    }

    signal ready()      //settings are ready

}
