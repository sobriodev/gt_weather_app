#include "controller.h"
#include <QDebug>

Controller::Controller(QObject *parent) : QObject(parent), controller(nullptr), service(nullptr) {}

Controller::~Controller()
{
    delete controller;
    delete service;
}

void Controller::deviceConnect(Device *device)
{
    this->device = *device;

    delete controller;
    controller = new QLowEnergyController(this->device.getDeviceInfo(), this);

    connect(controller, &QLowEnergyController::serviceDiscovered,
            this, &Controller::bleServiceDiscovered);
    connect(controller, &QLowEnergyController::discoveryFinished,
            this, &Controller::bleServiceScanDone);

    connect(controller, static_cast<void (QLowEnergyController::*)(QLowEnergyController::Error)>(&QLowEnergyController::error),
            this, [this]() {
        emit error();
    });
    connect(controller, &QLowEnergyController::connected, this, [this]() {
        emit connected();
        controller->discoverServices();
    });
    connect(controller, &QLowEnergyController::disconnected, this, [this]() {
        emit disconnected();
    });

    services.clear();
    emit discoveringStarted();
    controller->connectToDevice();
}

void Controller::serviceConnect()
{
    delete service;
    this->service = controller->createServiceObject(QBluetoothUuid(static_cast<uint>(HC08_SERVICE_UUID)));
    if (service) {
        emit serviceObjectCreationSuccess();
        connect(service, &QLowEnergyService::stateChanged, this, &Controller::bleServiceStateChanged);
        connect(service, &QLowEnergyService::characteristicChanged, this, &Controller::bleCharacteristicChanged);
        service->discoverDetails();
    } else {
        emit serviceObjectCreationFailure();
    }
}

void Controller::bleServiceDiscovered(const QBluetoothUuid &gatt)
{
    services.append(gatt);
    emit serviceDiscovered(gatt.toString());
}

void Controller::bleServiceScanDone()
{
    bool res = false;
    for (auto &service : services) {
        if (service == QBluetoothUuid(static_cast<uint>(HC08_SERVICE_UUID))) {
            res = true;
        }
    }
    emit servicesScanDone(res);
}

void Controller::bleServiceStateChanged(QLowEnergyService::ServiceState service)
{
    switch (service) {
    case QLowEnergyService::ServiceDiscovered: {
        const QLowEnergyCharacteristic hrChar = this->service->characteristic(QBluetoothUuid(static_cast<uint>(HC08_CHARACTERICTIC_UUID)));
        if (!hrChar.isValid()) {
            break;
        }
        QLowEnergyDescriptor descriptor = hrChar.descriptor(QBluetoothUuid::ClientCharacteristicConfiguration);
        if (descriptor.isValid())
            this->service->writeDescriptor(descriptor, QByteArray::fromHex("0100"));
        break;
    }
    default:
        break;
    }
}

void Controller::bleCharacteristicChanged(const QLowEnergyCharacteristic &c, const QByteArray &value)
{
    if (c.uuid() == QBluetoothUuid(static_cast<uint>(HC08_CHARACTERICTIC_UUID))) {
        emit characteristicChanged(value);
    }
}

