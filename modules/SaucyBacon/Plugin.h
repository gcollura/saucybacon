#ifndef SAUCYBACON_PLUGIN_H
#define SAUCYBACON_PLUGIN_H

#include <QtQml/QQmlEngine>
#include <QtQml/QQmlExtensionPlugin>

/*
 ----8<-----

 import SaucyBacon 0.1

 Rectangle {
   width: 200
   height: 200

   Utils {
      id: utils
   }

   Text {
     anchors.centerIn: parent
     text: utils.homePath()
   }
 }

 -----8<------
*/
class SaucyBaconPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    void registerTypes(const char *uri);
    void initializeEngine(QQmlEngine *engine, const char *uri);
};
#endif // SAUCYBACON_PLUGIN_H

