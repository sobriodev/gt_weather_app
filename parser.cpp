#include "parser.h"
#include <QDebug>

Parser::Parser(QObject *parent) : QObject(parent), sensorExp(SENSOR_DATA_FORMAT) {}

void Parser::parseData(QString data)
{
    QRegularExpressionMatch dataMatch = sensorExp.match(data);
    QRegularExpressionMatch commandMatch;

    if (dataMatch.hasMatch()) {
        parseSensorData(data);
    } else if (commandMatch.hasMatch()) {
        // do some command...
    }
}

void Parser::parseSensorData(QString data)
{
    QString sensorType = data.at(1);
    QString temp = data.right(data.length() - 3);
    double sensorData = temp.left(temp.length() - 1).toDouble();

    if (sensorType == 'T') {
        emit temperatureChanged(sensorData);
    } else if (sensorType == 'H') {
        emit humidityChanged(sensorData);
    } else if (sensorType == 'P') {
        emit pressureChanged(sensorData);
    }
}


