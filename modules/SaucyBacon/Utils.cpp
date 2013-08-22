#include "Utils.h"

#include <QtCore>

Utils::Utils(QObject *parent) :
    QObject(parent) {

}

Utils::~Utils() {

}

bool Utils::createDir(const QString &dirName) {
    QDir dir(dirName);
    if (!dir.exists())
        dir.mkpath(".");

    return dir.exists();
}

QString Utils::homePath() const {
    return QDir::homePath();
}

bool Utils::write(const QString& dirName, const QString& fileName, const QString& contents) {
    if (!createDir(dirName))
        return false;
    QString path = QDir(dirName).absoluteFilePath(fileName);
    path = QDir::cleanPath(path);

    QFile file(path);

    if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        QTextStream stream(&file);
        stream << contents << endl;
        file.close();
        return true;
    } else {
        return false;
    }
}

QString Utils::read(const QString& dirName, const QString& fileName) {
    QString path = QDir(dirName).absoluteFilePath(fileName);
    path = QDir::cleanPath(path);
    QFile file(path);

    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QString contents = QString(file.readAll());
        return contents;
    } else {
        // Return an empty string if the file doesn't exists or it's impossible to read
        return QString();
    }
}
