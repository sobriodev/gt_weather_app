#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "scanner.h"
#include "device.h"
#include "controller.h"
#include "parser.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    qmlRegisterType<Device>("app.device", 1, 0, "Device");
    qmlRegisterType<Scanner>("app.scanner", 1, 0, "Scanner");
    qmlRegisterType<Controller>("app.controller", 1, 0, "Controller");
    qmlRegisterType<Parser>("app.parser", 1, 0, "Parser");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/resources/qml/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
