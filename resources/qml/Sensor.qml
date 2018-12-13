import QtQuick 2.9
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.4
import QtQuick.Layouts 1.3
import app.device 1.0
import app.controller 1.0
import app.parser 1.0

Rectangle {
    function prependZero(val) {
        return val < 10 ? "0"+val : ""+val
    }

    function parseDate(date) {
        return prependZero(date.getHours()) + ":" + prependZero(date.getMinutes()) + ":" + prependZero(date.getSeconds())
    }

    Rectangle {
        width: parent.width
        height: 230
        ColumnLayout {
            width: parent.width*0.5
            height: parent.height
            anchors.centerIn: parent
            spacing: 0
            Rectangle {
                Layout.fillWidth: true
                height: 80
                Label {
                    anchors.centerIn: parent
                    id: time
                    font.pointSize: 17
                    text: parseDate(new Date)
                }
            }
            Rectangle {
                Layout.fillWidth: true
                height: 50
                RowLayout {
                    anchors.fill: parent
                    spacing: 5
                    Rectangle {
                        width: temperatureImg.width
                        Layout.fillHeight: true
                        Image {
                            id: temperatureImg
                            anchors.centerIn: parent
                            source: "../images/temperature.png"
                        }
                    }
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Label {
                            anchors.verticalCenter: parent.verticalCenter
                            id: temperatureLabel
                            text: "----"
                        }
                    }
                }
            }
            Rectangle {
                Layout.fillWidth: true
                height: 50
                RowLayout {
                    anchors.fill: parent
                    spacing: 5
                    Rectangle {
                        width: pressureImg.width
                        Layout.fillHeight: true
                        Image {
                            id: pressureImg
                            anchors.centerIn: parent
                            source: "../images/pressure.png"
                        }
                    }
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Label {
                            anchors.verticalCenter: parent.verticalCenter
                            id: pressureLabel
                            text: "----"
                        }
                    }
                }
            }
            Rectangle {
                Layout.fillWidth: true
                height: 50
                RowLayout {
                    anchors.fill: parent
                    spacing: 5
                    Rectangle {
                        width: humidityImg.width
                        Layout.fillHeight: true
                        Image {
                            id: humidityImg
                            anchors.centerIn: parent
                            source: "../images/humidity.png"
                        }
                    }
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Label {
                            anchors.verticalCenter: parent.verticalCenter
                            id: humidityLabel
                            text: "----"
                        }
                    }
                }
            }
        }
    }

    Timer {
        interval: 500; running: true; repeat: true
        onTriggered: {
            time.text = parseDate(new Date)
        }
    }

    Connections {
        target: parser
        onTemperatureChanged: {
            temperatureLabel.text = temperature+" °C"
        }
        onHumidityChanged: {
            humidityLabel.text = humidity+" %"
        }
        onPressureChanged: {
           pressureLabel.text = pressure+" hPa"
        }
    }
}
