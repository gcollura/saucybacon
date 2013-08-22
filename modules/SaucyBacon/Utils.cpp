#include "Utils.h"

#include <QDir>

Utils::Utils(QObject *parent) :
    QObject(parent),
    m_message("")
{

}

Utils::~Utils() {

}

bool Utils::createDir(const QString &dirName) {
    QDir dir(dirName);
    if (!dir.exists())
        dir.mkpath(".");

    return dir.exists();
}
