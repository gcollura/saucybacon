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

#include "Database.h"

#include <QtSql>
#include <QFile>
#include <QDir>

#include <QDebug>

Database::Database(QObject *parent) :
    QAbstractListModel(parent) {

    // Find QSLite driver
    db = new QSqlDatabase();
    db->addDatabase("QSQLITE");

    db->setDatabaseName("saucybacondb");

    // Open database
    db->open();

    bool ret = false;
    if (db->isOpen()) {
        QSqlQuery query(*db);
        ret = query.exec("create table person "
                         "(id integer primary key, "
                         "firstname varchar(20), "
                         "lastname varchar(30), "
                         "age integer)");

    } else {
        qDebug() << "Cannot open db.";
    }
    qDebug() << db->databaseName();
}

Database::~Database() {
    db->close();
    delete db;
}

QVariant Database::data(const QModelIndex &index, int role) const {

    return QVariant();
}

QHash<int, QByteArray> Database::roleNames() const {
    QHash<int, QByteArray> roles;
    roles.insert(0, "contents");
    return roles;
}

int Database::rowCount(const QModelIndex &parent) const {
    return 0;
}

void Database::resetModel() {
    beginResetModel();
    endResetModel();
}
