#include <QtQml>
#include <QtQml/QQmlContext>
#include "Backend.h"
#include "Utils.h"


void SaucyBaconPlugin::registerTypes(const char *uri)
{
    Q_ASSERT(uri == QLatin1String("SaucyBacon"));

    qmlRegisterType<Utils>(uri, 0, 1, "Utils");
}

void SaucyBaconPlugin::initializeEngine(QQmlEngine *engine, const char *uri)
{
    QQmlExtensionPlugin::initializeEngine(engine, uri);
}
