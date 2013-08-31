/**
 * This file is part of SaucyBacon.
 *
 * Copyright 2013 (C) Giulio Collura <random.cpp@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
**/

#include "Utils.h"

#include <QTextDocument>
#include <QtPrintSupport/QPrinter>

Utils::Utils(QObject *parent) :
    QObject(parent) {

    mkdir(path(Utils::SettingsLocation));
    auto json = QJsonDocument::fromJson(read(path(Utils::SettingsLocation), "sb-settings.json").toUtf8()).object();
    m_settings = json.toVariantMap();
}

Utils::~Utils() {
    auto json = QJsonObject::fromVariantMap(m_settings);
    QJsonDocument document(json);
    write(path(Utils::SettingsLocation), "sb-settings.json", document.toJson());
}

bool Utils::mkdir(const QString &dirName) {
    QDir dir(dirName);
    if (!dir.exists())
        dir.mkpath(".");

    return dir.exists();
}

QString Utils::path(StandardLocation location) const {
    if (location == Utils::SettingsLocation)
        return QStandardPaths::standardLocations(QStandardPaths::ConfigLocation)[0] + "/SaucyBacon";
    return QStandardPaths::standardLocations((QStandardPaths::StandardLocation) location)[0];
}

QString Utils::path(const QString &location, const QString &fileName) {
    mkdir(location);
    QString path = QDir(location).absoluteFilePath(fileName);
    return QDir::cleanPath(path);
}

QString Utils::path(StandardLocation location, const QString &fileName) {
    mkdir(path(location));
    QString path = QDir(this->path(location)).absoluteFilePath(fileName);
    return QDir::cleanPath(path);
}

bool Utils::write(const QString& dirName, const QString& fileName, const QByteArray& contents) {
    if (!mkdir(dirName))
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

bool Utils::exportAsPdf(const QString &fileName, const QJsonObject &contents) {
    QTextDocument doc;
    QString html;
    QTextStream stream(&html);

    stream << QString("<html><head><style type=\"text/css\">"
                      "h1 {color:red;} "
                      " "
                      "</style></head><body>");

    stream << QString("<h1>%1</h1>").arg(contents["name"].toString());

    stream << QString("<p>%1 <br>").arg(contents["totaltime"].toString());
    stream << QString(tr("Difficulty: %1<br>")).arg(contents["difficulty"].toDouble()); // FIXME: how can I access the array?
    stream << QString(tr("Restriction: %1</p>")).arg(contents["restriction"].toDouble());

    stream << QString(tr("<h2>Ingredients</h2>"));

    stream << "<ul>";
    QJsonArray ingredients = contents["ingredients"].toArray();
    for (int i = 0; i < ingredients.count(); i++) {
        QJsonObject ingredient = ingredients[i].toObject();
        stream << QString("<li>%1 %2 %3</li>").arg(ingredient["quantity"].toDouble())
                .arg(ingredient["type"].toString(), ingredient["name"].toString());
    }
    stream << "</ul>";

    stream << QString(tr("<h2>Directions</h2>"));
    stream << QString("<p>%1</p>").arg(contents["directions"].toString());

    stream << QString(tr("<h2>Photos</h2><br />"));
    QJsonArray photos = contents["photos"].toArray();
    for (int i = 0; i < photos.count(); i++)
        stream << QString("<img src='%1' width=200 />").arg(photos[i].toString());

    stream << QString("</body></html>");

    doc.setHtml(html);

    QPrinter printer;
    printer.setOutputFileName(fileName);
    printer.setOutputFormat(QPrinter::PdfFormat);
    doc.print(&printer);
    printer.newPage();

    return true;
}

QVariant Utils::get(const QString &key) {
    if (m_settings.contains(key))
        return m_settings[key];
    else
        return QVariant();
}

bool Utils::set(const QString &key, const QVariant &value) {
    if (m_settings.contains(key))
        m_settings[key] = value;
    else
        m_settings.insert(key, value);
    return true;
}
