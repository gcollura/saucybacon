#include "RecipeSearch.h"

#include <QtNetwork>
#include <QtCore>
#include <QDebug>

RecipeSearch::RecipeSearch(QObject *parent) :
    QAbstractListModel(parent)
{
    m_manager = new QNetworkAccessManager(this);
    connect(m_manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(replyFinished(QNetworkReply*)));

    connect(this, SIGNAL(queryChanged()), this, SLOT(makeRequest()));

    m_apiKey = "bed9a0385fc98548af8018eccda97e24"; // f2f
    //m_apiKey = "TGPw8AuPLYcfdScGWSPtK2in9AR7fc9l"; // Kitchen Monkey

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
    query.addQueryItem("key", m_apiKey);
    query.addQueryItem("q", m_query);
    query.addQueryItem("sort", "r");
    url.setUrl("http://food2fork.com/api/search");
    url.setQuery(query);

    request.setUrl(url);

    m_manager->get(request);
}

void RecipeSearch::replyFinished(QNetworkReply *reply) {
    if (reply->error() == QNetworkReply::NoError) {
        for (auto r : reply->rawHeaderPairs())
            qDebug() << QString(r.second);
        QByteArray data = reply->readAll();
        QJsonDocument document = QJsonDocument::fromJson(data);

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
