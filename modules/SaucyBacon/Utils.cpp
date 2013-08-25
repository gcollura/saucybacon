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

#include <QtCore>
#include <QTextDocument>
#include <QtPrintSupport/QPrinter>

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

bool Utils::exportAsPdf(const QString &fileName, const QJsonObject &contents) {
    QTextDocument doc;
    QString html;
    QTextStream stream(&html);

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
        stream << QString("<img src='%1' />").arg(photos[i].toString());

    doc.setHtml(html);

    QPrinter printer;
    printer.setOutputFileName(fileName);
    printer.setOutputFormat(QPrinter::PdfFormat);
    doc.print(&printer);
    printer.newPage();

    return true;
}
