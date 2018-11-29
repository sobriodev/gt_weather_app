#include "scanner.h"

Scanner::Scanner(QObject *parent) : QObject(parent)
{
    deviceDiscoveryAgent = new QBluetoothDeviceDiscoveryAgent(this);
    deviceDiscoveryAgent->setLowEnergyDiscoveryTimeout(SCAN_TIMEOUT);

    connect(deviceDiscoveryAgent, &QBluetoothDeviceDiscoveryAgent::deviceDiscovered, this, &Scanner::addBleDevice);
    connect(deviceDiscoveryAgent, static_cast<void (QBluetoothDeviceDiscoveryAgent::*)(QBluetoothDeviceDiscoveryAgent::Error)>(&QBluetoothDeviceDiscoveryAgent::error),
            this, &Scanner::bleScanError);

    connect(deviceDiscoveryAgent, &QBluetoothDeviceDiscoveryAgent::finished, this, &Scanner::bleScanFinished);
    connect(deviceDiscoveryAgent, &QBluetoothDeviceDiscoveryAgent::canceled, this, &Scanner::bleScanFinished);
}

Scanner::~Scanner()
{
    delete deviceDiscoveryAgent;
}

void Scanner::startScan()
{
    devices.clear();
    emit scanStarted();
    deviceDiscoveryAgent->start(QBluetoothDeviceDiscoveryAgent::LowEnergyMethod);
}

void Scanner::addBleDevice(const QBluetoothDeviceInfo &device)
{
    if (device.coreConfigurations() & QBluetoothDeviceInfo::LowEnergyCoreConfiguration) {
        devices.append(Device(device));
        emit deviceFound(&devices.last());
    }
}

void Scanner::bleScanError()
{
    emit scanError();
}

void Scanner::bleScanFinished()
{
    QList<QObject *> res;
    for (auto &device : devices) {
        res.append(&device);
    }
    emit scanFinished(res);
}
