#ifndef RECIPESEARCH_H
#define RECIPESEARCH_H

#include <QAbstractListModel>
#include <QNetworkAccessManager>
#include <QtCore>

class Q_DECL_EXPORT RecipeSearch : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QString query READ query WRITE setQuery NOTIFY queryChanged)
    Q_PROPERTY(bool searching READ searching NOTIFY searchingChanged)

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
    void searchingChanged();

public slots:

private slots:
    void makeRequest();
    void replyFinished(QNetworkReply *reply);

private:
    QString query() const { return m_query; }
    void setQuery(const QString& query);

    bool searching() const { return m_searching; }
    void setSearching(const bool searching) { m_searching = searching; searchingChanged(); }

    void parseJson(const QJsonDocument &contents);

    int m_count;
    QJsonArray m_recipes;

    QNetworkAccessManager *m_manager;
    QString m_query;
    QString m_apiKey;
    bool m_searching;

};

#endif // RECIPESEARCH_H
