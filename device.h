#ifndef DEVICE_H
#define DEVICE_H

#include <QObject>
#include <QtBluetooth>

class Device : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ getDeviceName CONSTANT)
    Q_PROPERTY(QString address READ getDeviceAddress CONSTANT)

public:
    explicit Device(QObject *parent = nullptr);
    Device(QBluetoothDeviceInfo deviceInfo, QObject *parent = nullptr);
    Device(const Device &other);
    const Device &operator=(const Device &other);
    virtual ~Device();

    QBluetoothDeviceInfo getDeviceInfo() const;

    QString getDeviceName();
    QString getDeviceAddress();

private:
    QBluetoothDeviceInfo deviceInfo;
};

#endif // DEVICE_H
