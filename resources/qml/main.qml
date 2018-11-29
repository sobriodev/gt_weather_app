import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.4
import app.scanner 1.0
import app.device 1.0


ApplicationWindow {
    id: mainWindow
    visible: true
    width: 640
    height: 480
    title: qsTr("Weather app")

    StackView {
        id: mainView
        width: parent.width
        height: parent.height
        initialItem: "Scanner.qml"
    }

    onClosing: {
        if(mainView.depth > 1) {
            close.accepted = false
            mainView.pop()
        } else{
            return;
        }
    }
}
