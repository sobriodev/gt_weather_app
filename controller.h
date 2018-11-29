#ifndef CONTROLLER_H
#define CONTROLLER_H

#include <QObject>
#include <QtBluetooth>
#include "device.h"

class Controller : public QObject
{
    Q_OBJECT

public:
    const int HC08_SERVICE_UUID = 0xFFE0;
    const int HC08_CHARACTERICTIC_UUID = 0xFFE1;

    explicit Controller(QObject *parent = nullptr);
    virtual ~Controller();

    Q_INVOKABLE void deviceConnect(Device *device);

public slots:
    void bleServiceDiscovered(const QBluetoothUuid &gatt);
    void bleServiceScanDone();

signals:
    void error();
    void connected();
    void disconnected();
    void servicesScanDone(bool serviceFound);
    void serviceDiscovered(QString service);
    void discoveringStarted();

private:
    Device device;
    QLowEnergyController *controller;
    QVector<QBluetoothUuid> services;

};

#endif // CONTROLLER_H
