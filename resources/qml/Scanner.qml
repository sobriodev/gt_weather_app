import QtQuick 2.9
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.4
import QtQuick.Layouts 1.3
import app.scanner 1.0

Page {
    property string whiteColor: "#fbfbfb"
    property string headerText: qsTr("Scan for devices")
    property string refreshButtonText: qsTr("Scan")
    property string refreshButtonText2: qsTr("Refresh")
    property string footerText: qsTr("Click scan to refresh BLE devices list")
    property string scanStartedText: qsTr("Scanning...")
    property string deviceFoundText: qsTr("Device <b>%1</b> found")
    property string finishedText: qsTr("Scan finished. Devices found: <b>%1</b>")
    property string errorText: qsTr("Scan error. Maybe bluetooth is turned off?")

    Scanner {
        id: bleScanner
        onScanStarted: {
            devicesList.model = null
            footer.text = scanStartedText
            spinner.visible = true
        }
        onDeviceFound: {
            footer.text = deviceFoundText.arg(device.name)
        }
        onScanError: {
            footer.text = errorText
            spinner.visible = false
        }
        onScanFinished: {
            devicesList.model = devices
            footer.text = finishedText.arg(devices.length)
            spinner.visible = false
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
                    Layout.fillWidth: true
                    color: Qt.rgba(0,0,0,0)
                    Label {
                        id: header
                        anchors.centerIn: parent
                        text: headerText
                        color: whiteColor
                    }
                }
                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    color: Qt.rgba(0,0,0,0)
                    Button {
                        id: refreshButton
                        text: refreshButtonText
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        highlighted: refreshButton.pressed ? false : true
                        background: Rectangle {
                            anchors.fill: parent
                            color: refreshButton.pressed ? whiteColor : Qt.rgba(0,0,0,0)
                            border.width: 1
                            border.color: refreshButton.pressed ? Material.color(Material.Teal) : Material.color(Material.Grey)
                            radius: 5
                        }
                        onClicked: {
                            text = refreshButtonText2
                            bleScanner.startScan()
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0,0,0,0)
        ListView {
            id: devicesList
            anchors.fill: parent
            delegate: Pane {
                width: parent.width
                height: 70
                Material.background: Qt.rgba(0,0,0,0)

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 0
                    Rectangle {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        color: Qt.rgba(0,0,0,0)
                        Label {
                            anchors.centerIn: parent
                            text: modelData.name
                        }
                    }
                    Rectangle {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        color: Qt.rgba(0,0,0,0)
                        Label {
                            anchors.centerIn: parent
                            text: modelData.address
                        }
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        mainView.push("Device.qml", {"device": modelData})
                    }
                }
            }
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
                text: footerText
            }
        }
    }
}
