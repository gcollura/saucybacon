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

#ifndef RECIPESEARCH_H
#define RECIPESEARCH_H

#include <QAbstractListModel>
#include <QNetworkAccessManager>
#include <QtCore>

class Q_DECL_EXPORT RecipeSearch : public QAbstractListModel {

    Q_OBJECT
    Q_PROPERTY(QString query READ query WRITE setQuery NOTIFY queryChanged)
    Q_PROPERTY(bool loading READ loading NOTIFY loadingChanged)

public:
    explicit RecipeSearch(QObject *parent = 0);
    virtual ~RecipeSearch();

    // QAbstractListModel
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;
    QHash<int, QByteArray>roleNames() const;
    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    void resetModel();

signals:
    void queryChanged();
    void loadingChanged();

public slots:

private slots:
    void makeRequest();
    void replyFinished(QNetworkReply *reply);

private:
    QString query() const { return m_query; }
    void setQuery(const QString& query);

    bool loading() const { return m_loading; }
    void setSearching(const bool loading) { m_loading = loading; loadingChanged(); }

    void parseJson(const QJsonDocument &contents);

    int m_count;
    QJsonArray m_recipes;

    QNetworkAccessManager *m_manager;
    QString m_query;
    bool m_loading;

};

#endif // RECIPESEARCH_H
