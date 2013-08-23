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

#ifndef UTILS_H
#define UTILS_H

#include <QObject>

class Utils : public QObject
{
    Q_OBJECT

public:
    explicit Utils(QObject *parent = 0);
    ~Utils();

    Q_INVOKABLE bool createDir(const QString& dirName);
    Q_INVOKABLE QString homePath() const;

    Q_INVOKABLE bool write(const QString& dirName, const QString& fileName, const QString& contents);
    Q_INVOKABLE QString read(const QString& dirName, const QString& fileName);

    Q_INVOKABLE bool exportAsPdf(const QString& fileName, const QJsonObject& contents);

Q_SIGNALS:

protected:

};

#endif // UTILS_H
