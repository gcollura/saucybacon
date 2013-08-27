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

#include "RecipeSearch.h"
#include "ApiKeys.h"

#include <QtNetwork>
#include <QtCore>
#include <QDebug>

RecipeSearch::RecipeSearch(QObject *parent) :
    QAbstractListModel(parent)
{
    m_manager = new QNetworkAccessManager(this);
    connect(m_manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(replyFinished(QNetworkReply*)));

    connect(this, SIGNAL(queryChanged()), this, SLOT(makeRequest()));

}

RecipeSearch::~RecipeSearch() {
}

void RecipeSearch::setQuery(const QString &query) {
    m_query = query;
    m_query = m_query.replace(" ", ",");

    queryChanged();
}

QVariant RecipeSearch::data(const QModelIndex &index, int role) const {

    if (role == 0)
        return m_recipes[index.row()].toObject();

    return QVariant();
}

QHash<int, QByteArray> RecipeSearch::roleNames() const {
    QHash<int, QByteArray> roles;
    roles.insert(0, "contents");
    return roles;
}

int RecipeSearch::rowCount(const QModelIndex &parent) const {
    return m_count;
}

void RecipeSearch::resetModel() {
    beginResetModel();
    endResetModel();
}

void RecipeSearch::makeRequest() {
    setSearching(true);

    QNetworkRequest request;
    QUrl url;
    QUrlQuery query;
    query.addQueryItem("key", ApiKeys::F2FKEY);
    query.addQueryItem("q", m_query);
    query.addQueryItem("sort", "r");
    url.setUrl(ApiKeys::F2FSEARCHURL);
    url.setQuery(query);

    request.setUrl(url);

    m_manager->get(request);
}

void RecipeSearch::replyFinished(QNetworkReply *reply) {
    if (reply->error() == QNetworkReply::NoError) {

        QJsonDocument document = QJsonDocument::fromJson(reply->readAll());

        parseJson(document);

    } else {
        qDebug() << reply->errorString();
    }

    reply->deleteLater();
}

void RecipeSearch::parseJson(const QJsonDocument &contents) {
    beginResetModel();

    m_recipes = contents.object()["recipes"].toArray();
    m_count = contents.object()["count"].toDouble();

    endResetModel();

    setSearching(false);
}
