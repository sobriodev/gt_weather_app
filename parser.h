#ifndef PARSER_H
#define PARSER_H

#include <QObject>
#include <QRegularExpression>

class Parser : public QObject
{
    Q_OBJECT

public:
    const QString SENSOR_DATA_FORMAT = "^\\[(T|H|P) [0-9]+\\.[0-9]+\\]$";
    explicit Parser(QObject *parent = nullptr);

    Q_INVOKABLE void parseData(QString data);

signals:
    void temperatureChanged(double temperature);
    void humidityChanged(double humidity);
    void pressureChanged(double pressure);

private:
    QRegularExpression sensorExp;
    void parseSensorData(QString data);
};

#endif // PARSER_H
