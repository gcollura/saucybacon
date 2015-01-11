/**
 * This file is part of SaucyBacon.
 *
 * Copyright 2013-2015 (C) Giulio Collura <random.cpp@gmail.com>
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

#ifndef UTILS_H
#define UTILS_H

#include <QtCore>

class Q_DECL_EXPORT Utils : public QObject
{
    Q_OBJECT
    Q_ENUMS(StandardLocation)

public:
    explicit Utils(QObject *parent = 0);
    virtual ~Utils();

    enum StandardLocation {
        DesktopLocation = QStandardPaths::DesktopLocation,
        DocumentsLocation = QStandardPaths::DocumentsLocation,
        PicturesLocation = QStandardPaths::PicturesLocation,
        HomeLocation = QStandardPaths::HomeLocation,
        ConfigLocation = QStandardPaths::ConfigLocation,
        SettingsLocation
    };

    Q_INVOKABLE bool mkdir(const QString& dirName);
    Q_INVOKABLE QString path(StandardLocation location) const;
    Q_INVOKABLE QString path(const QString &location, const QString &fileName);
    Q_INVOKABLE QString path(StandardLocation location, const QString &fileName);

    Q_INVOKABLE bool open(const QString &url);
    Q_INVOKABLE bool mailto(const QString &address, const QString &subject, const QString &body);

    Q_INVOKABLE bool write(const QString& dirName, const QString& fileName, const QByteArray &contents);
    Q_INVOKABLE QString read(const QString& dirName, const QString& fileName);
    Q_INVOKABLE bool mv(const QString& oldName, const QString& newName);
    Q_INVOKABLE bool cp(const QString& oldName, const QString& newName);
    Q_INVOKABLE bool exists(const QString& fileName);
    Q_INVOKABLE QString fileName(const QString& sourceFile);

    Q_INVOKABLE bool exportAsPdf(const QString& fileName, const QJsonObject& contents);

    Q_INVOKABLE QVariant get(const QString &key);
    Q_INVOKABLE bool set(const QString &key, const QVariant &value);
    Q_INVOKABLE bool save();

Q_SIGNALS:

protected:
    QVariantMap m_settings;

};

#endif // UTILS_H
