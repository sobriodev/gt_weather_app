import QtQuick 2.9
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.4
import QtQuick.Layouts 1.3
import app.device 1.0
import app.controller 1.0

Page {
    property Device device
    property string whiteColor: "#fbfbfb"
    property string serviceDiscoveredText: qsTr("Service %1 found")
    property string connectionSuccessText: qsTr("Connected")
    property string connectionFailureText: qsTr("Connection error")
    property string serviceFoundText: qsTr("Ready")
    property string serviceNotFoundText: qsTr("Weather servide not found")
    property string discoveringText: qsTr("Discovering services...")
    property string disconnectedText: qsTr("Disconnected from device")


    Controller {
        id: bleController
        onServiceDiscovered: {
            footer.text = serviceDiscoveredText.arg(service)
        }
        onServicesScanDone: {
            spinner.visible = false
            footer.text = serviceFound ? serviceFoundText : serviceNotFoundText
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
    }

    Drawer {
        id: drawer
        width: mainWindow.width*0.5
        height: mainWindow.height
        edge: Qt.RightEdge
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
                    Label {
                        anchors.centerIn: parent
                        text: "\u25c0"
                        font.pointSize: 14
                        color: whiteColor
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
                    Layout.fillHeight: true
                    width: 50
                    color: Qt.rgba(0,0,0,0)
                    Label {
                        anchors.centerIn: parent
                        text: "\u2630"
                        font.pointSize: 14
                        color: whiteColor
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
        anchors.fill: parent
    }

    Rectangle {
        id: spinner
        visible: false
        anchors.centerIn: parent
        width: 50
        height: 50
        color: Qt.rgba(0,0,0,0)
        Image {
            source: "../images/spinner.png"
            anchors.fill: parent
            NumberAnimation on rotation { duration: 1500; from:0; to: 360; loops: Animation.Infinite}
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
