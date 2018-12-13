import QtQuick 2.9
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.4
import QtQuick.Layouts 1.3
import app.device 1.0
import app.controller 1.0
import app.parser 1.0

Page {
    property Device device
    property string whiteColor: "#fbfbfb"
    property string serviceDiscoveredText: qsTr("Service %1 found")
    property string connectionSuccessText: qsTr("Connected")
    property string connectionFailureText: qsTr("Connection error")
    property string serviceFoundText: qsTr("Service found")
    property string serviceNotFoundText: qsTr("Weather servide not found")
    property string discoveringText: qsTr("Discovering services...")
    property string disconnectedText: qsTr("Disconnected from device")
    property string objectCreationSuccessText: qsTr("Ready")
    property string objectCreationFailureText: qsTr("Service object created")

    function sliderValuetoDelay(val) {
        switch (val) {
            case 1:
                return "100ms"
            case 2:
                return "1s"
            case 3:
                return "10s"
            default:
                return "100ms"
        }
    }

    function sliderValuetoDelayCommand(val) {
        switch (val) {
        case 1:
            return "[D1]"
        case 2:
            return "[D2]"
        case 3:
            return "[D3]"
        default:
            return "[D1]"
        }
    }

    Controller {
        id: bleController
        onServiceDiscovered: {
            footer.text = serviceDiscoveredText.arg(service)
        }
        onServicesScanDone: {
            spinner.visible = false
            footer.text = serviceFound ? serviceFoundText : serviceNotFoundText
            bleController.serviceConnect()
        }
        onConnected: {
            footer.text = connectionSuccessText
        }
        onDisconnected: {
            footer.text = disconnectedText
        }
        onError: {
            footer.text = connectionFailureText
            spinner.visible = false
        }
        onDiscoveringStarted: {
            footer.text = discoveringText
            spinner.visible = true
        }
        onServiceObjectCreationSuccess: {
            swipeViewRect.visible = true
            hamburger.visible = true
            footer.text = objectCreationSuccessText
        }
        onServiceObjectCreationFailure: {
            footer.text = objectCreationFailureText
        }
        onCharacteristicChanged: {
            parser.parseData(value)
        }
    }

    Parser {
        id: parser
    }

    Drawer {
        id: drawer
        width: mainWindow.width*0.5
        height: mainWindow.height
        edge: Qt.RightEdge

        ColumnLayout {
            anchors.fill: parent
            spacing: 0
            Rectangle {
                Layout.fillWidth: true
                height: 90
                ColumnLayout {
                    anchors.fill: parent
                    spacing: 5
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Label {
                            id: refreshLabel
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            text: "Refresh time: 100ms"
                        }
                    }
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Slider {
                            anchors.fill: parent
                            from: 1
                            to: 3
                            value: 1
                            stepSize: 1
                            snapMode: Slider.SnapAlways
                            onValueChanged: {
                                refreshLabel.text = "Refresh time: "+sliderValuetoDelay(value)
                                bleController.sendCommand(sliderValuetoDelayCommand(value))
                            }
                        }
                    }
                }
            }
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }

    header: Rectangle {
        height: 70
        color: Material.color(Material.Teal)
        Pane {
            anchors.fill: parent
            Material.elevation: 6
            Material.background: Material.Teal

            RowLayout {
                anchors.fill: parent
                spacing: 0
                Rectangle {
                    Layout.fillHeight: true
                    width: 50
                    color: Qt.rgba(0,0,0,0)
                    Image {
                        anchors.centerIn: parent
                        source: "../images/arrow.png"
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            mainView.pop();
                        }
                    }
                }
                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    color: Qt.rgba(0,0,0,0)
                    Label {
                        id: header
                        anchors.centerIn: parent
                        text: device.name
                        color: whiteColor
                    }
                }
                Rectangle {
                    id: hamburger
                    Layout.fillHeight: true
                    width: 50
                    color: Qt.rgba(0,0,0,0)
                    visible: false
                    Image {
                        anchors.centerIn: parent
                        source: "../images/hamburger.png"
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            drawer.open()
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        id: swipeViewRect
        anchors.fill: parent
        visible: false

        SwipeView {
            id: swipeView
            currentIndex: 0
            anchors.fill: parent

            Sensor {}
            Chart {}
        }

        PageIndicator {
            id: indicator
            count: swipeView.count
            currentIndex: swipeView.currentIndex
            anchors.bottom: swipeView.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    Rectangle {
        id: spinner
        visible: false
        anchors.centerIn: parent
        width: 150
        height: 150
        color: Qt.rgba(0,0,0,0)
        AnimatedImage {
            source: "../images/spinner2.gif"
            anchors.fill: parent
        }
    }

    footer: Rectangle {
        height: 50
        color: whiteColor
        Pane {
            anchors.fill: parent
            Material.elevation: 6
            Material.background: whiteColor
            Label {
                id: footer
                anchors.centerIn: parent
                text: "footerText"
            }
        }
    }

    Component.onCompleted: {
        bleController.deviceConnect(device)
    }
}
