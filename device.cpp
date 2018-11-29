#include "device.h"

Device::Device(QObject *parent) : QObject(parent) {}

Device::Device(QBluetoothDeviceInfo deviceInfo, QObject *parent) : QObject(parent), deviceInfo(deviceInfo) {}

Device::Device(const Device &other) : QObject(), deviceInfo(other.deviceInfo) {}

const Device &Device::operator=(const Device &other)
{
    deviceInfo = other.deviceInfo;
    return *this;
}

Device::~Device() {}

QString Device::getDeviceName()
{
    return deviceInfo.name();
}

QString Device::getDeviceAddress()
{
    return deviceInfo.address().toString();
}

QBluetoothDeviceInfo Device::getDeviceInfo() const
{
    return deviceInfo;
}
