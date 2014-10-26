/**
 * This file is part of SaucyBacon.
 *
 * Copyright 2013-2014 (C) Giulio Collura <random.cpp@gmail.com>
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

#ifndef RECIPEPARSER_H
#define RECIPEPARSER_H

#include <QObject>
#include <QtNetwork>

class QRegularExpression;
typedef QMap<QString, QRegularExpression> RecipeRegex;

class RecipeParser : public QObject {

    Q_OBJECT

public:
    explicit RecipeParser(QObject *parent = 0);
    virtual ~RecipeParser();

    void get(const QString &recipeId, const QString &recipeUrl, const QString &serviceUrl, const QString &imageUrl);

signals:
    void recipeAvailable(const QVariantMap &recipe);
    void loading(bool loading);
    void destPathChanged();

private slots:
    void replyFinished(QNetworkReply *reply);

private:
    void parseHtml(const QByteArray &html);
    void parseJson(const QByteArray &json);
    void parseImage(const QByteArray &imgData);
    void hasFinishedParsing();

    QNetworkAccessManager *m_manager;
    QVariantMap m_contents;
    QString m_service;
    QString m_destPath;
    QString m_photoName;

    QMap<QString, RecipeRegex> m_services;

    bool m_parseJson;
    bool m_parseHtml;
    bool m_parseImage;
};

#endif // RECIPEPARSER_H
