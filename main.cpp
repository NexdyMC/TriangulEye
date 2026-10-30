#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include "controller.h"
#include "clipboardhelper.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setApplicationName("TriangulEye");
    app.setOrganizationName("SpeedrunTools");
    app.setWindowIcon(QIcon(":/qt/qml/TriangulEye/app_icon.ico"));

    QQmlApplicationEngine engine;

    auto *controller = new Controller(&app);
    engine.rootContext()->setContextProperty("controller", controller);

    auto *clipboardHelper = new ClipboardHelper(&app);
    engine.rootContext()->setContextProperty("Clipboard", clipboardHelper);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("TriangulEye", "Main");

    return QGuiApplication::exec();
}
