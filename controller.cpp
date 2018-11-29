#include "controller.h"

Controller::Controller(QObject *parent) : QObject(parent), controller(nullptr) {}

Controller::~Controller()
{
    delete controller;
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


