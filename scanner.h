#ifndef SCANNER_H
#define SCANNER_H

#include <QObject>
#include <QtBluetooth>
#include "device.h"

class Scanner : public QObject
{
    Q_OBJECT

public:
    explicit Scanner(QObject *parent = nullptr);
    virtual ~Scanner();

    Q_INVOKABLE void startScan();

signals:
    void scanStarted();
    void deviceFound(Device *device);
    void scanError();
    void scanFinished(QList<QObject *> devices);

public slots:
    void addBleDevice(const QBluetoothDeviceInfo &device);
    void bleScanError();
    void bleScanFinished();

private:
    const int SCAN_TIMEOUT = 1500;
    QBluetoothDeviceDiscoveryAgent *deviceDiscoveryAgent;
    QVector<Device> devices;
};

#endif // SCANNER_H
