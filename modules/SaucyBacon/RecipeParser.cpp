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

#include "RecipeParser.h"
#include "ApiKeys.h"

#include <QtCore>
#include <QtScript/QScriptEngine>

// -------------------------------------------------------------

double evaluate(const QString &expr) {
    double result;
    QScriptEngine myEngine;
    result = myEngine.evaluate(expr).toNumber();
    return result;
}

QJsonArray parseIngredients(const QJsonArray &ingredients) {
    QJsonArray result;
    QRegularExpression regex("(?<quantity>[\\d\\-/?]+)[\\s+]?(?<type>\\w+)?[\\s+](?<name>.*)",
                             QRegularExpression::CaseInsensitiveOption);
    for (int i = 0; i < ingredients.count(); i++) {
        QJsonObject ingredient;
        auto match = regex.match(ingredients[i].toString(), 0, QRegularExpression::PartialPreferCompleteMatch);
        if (match.hasMatch() || match.hasPartialMatch()) {
            ingredient["name"] = match.captured("name");
            ingredient["quantity"] = evaluate(match.captured("quantity").replace("-", "+"));
            ingredient["type"] = match.captured("type");
        } else {
            ingredient["name"] = ingredients[i].toString().trimmed();
            ingredient["quantity"] = 0;
            ingredient["type"] = QString();
        }
        result.push_back(ingredient);
    }
    return result;
}

// -------------------------------------------------------------

RecipeParser::RecipeParser(QObject *parent) :
    QObject(parent) {

    RecipeRegex recipeRegex;
    // Default regex
    recipeRegex["directions"] = QRegularExpression("a^");
    recipeRegex["preptime"] = QRegularExpression("a^");
    recipeRegex["cooktime"] = QRegularExpression("a^");
    m_services["default"] = recipeRegex;

    // Allrecipes
    recipeRegex["directions"] = QRegularExpression("<li><span class=\"plaincharacterwrap break\">(.*)</span></li>");
    recipeRegex["preptime"] = QRegularExpression("<span id=\"prepMinsSpan\"><em>(\\d+)</em>");
    recipeRegex["cooktime"] = QRegularExpression("<span id=\"cookMinsSpan\"><em>(\\d+)</em>");
    m_services["http://allrecipes.com"] = recipeRegex;

    // SimplyRecipes
    recipeRegex["directions"] = QRegularExpression("<div itemprop=\"recipeInstructions\">(.+?)</div>",
                                                            QRegularExpression::DotMatchesEverythingOption);
    recipeRegex["preptime"] = QRegularExpression("class=\"preptime\".*?>(\\d+) ([mM]inutes|[hH]ours)<span");
    recipeRegex["cooktime"] = QRegularExpression("class=\"cooktime\".*?>(\\d+) ([mM]inutes|[hH]ours)<span");
    m_services["http://simplyrecipes.com"] = recipeRegex;

    // PioneerWoman
    recipeRegex["directions"] = QRegularExpression("<div itemprop=\"instructions\">(.*?)</div>",
                                                     QRegularExpression::DotMatchesEverythingOption);
    recipeRegex["preptime"] = QRegularExpression("itemprop=\'prepTime\'.*?>(\\d+) ([mM]inutes|[hH]ours)</time");
    recipeRegex["cooktime"] = QRegularExpression("itemprop=\'cookTime\'.*?>(\\d+) ([mM]inutes|[hH]ours)</time");
    m_services["http://thepioneerwoman.com"] = recipeRegex;

    // Two peas and their pot
    recipeRegex["directions"] = QRegularExpression("<div class=\"instructions\">(.*?)</div>",
                                                        QRegularExpression::DotMatchesEverythingOption);
    recipeRegex["preptime"] = QRegularExpression("class=\"preptime\".*?>(\\d+) ([mM]inutes|[hH]ours)</span");
    recipeRegex["cooktime"] = QRegularExpression("class=\"cooktime\".*?>(\\d+) ([mM]inutes|[hH]ours)</span");
    m_services["http://www.twopeasandtheirpod.com"] = recipeRegex;

    // Tasty Kitchen
    recipeRegex["directions"] = QRegularExpression("<span itemprop=\"instructions\">(.*?)</span>",
                                                           QRegularExpression::DotMatchesEverythingOption);
    recipeRegex["preptime"] = QRegularExpression("itemprop=\'prepTime\'.*?>(\\d+) ([mM]inutes|[hH]ours)</time");
    recipeRegex["cooktime"] = QRegularExpression("itemprop=\'cookTime\'.*?>(\\d+) ([mM]inutes|[hH]ours)</time");
    m_services["http://tastykitchen.com"] = recipeRegex;

    // Jamie Oliver's Recipes
    recipeRegex["directions"] = QRegularExpression("<p class=\"instructions\">(.*?)</p>",
                                                          QRegularExpression::DotMatchesEverythingOption);
    recipeRegex["preptime"] = QRegularExpression("class=\"preptime\".*?>(\\d+) ([mM]inutes|[hH]ours)</span");
    recipeRegex["cooktime"] = QRegularExpression("class=\"cooktime\".*?>(\\d+) ([mM]inutes|[hH]ours)</span");
    m_services["http://www.jamieoliver.com"] = recipeRegex;

    // Closet cooking
    recipeRegex["directions"] = QRegularExpression("<ol class=\"instructions\">(.*?)</ol>",
                                                            QRegularExpression::DotMatchesEverythingOption);
    recipeRegex["preptime"] = QRegularExpression("class=\"prepTime\".*?>(\\d+) ([mM]inutes|[hH]ours)</span");
    recipeRegex["cooktime"] = QRegularExpression("class=\"cookTime\".*?>(\\d+) ([mM]inutes|[hH]ours)</span");
    m_services["http://closetcooking.com"] = recipeRegex;

    // 101 Cookbooks
    recipeRegex["directions"] = QRegularExpression("</blockquote>(.*?)<div class=\"recipetimes\">",
                                                           QRegularExpression::DotMatchesEverythingOption);
    recipeRegex["preptime"] = QRegularExpression("class=\"preptime\".*?>(\\d+) ([mM]in|[hH]ours)");
    recipeRegex["cooktime"] = QRegularExpression("class=\"cooktime\".*?>(\\d+) ([mM]in|[hH]ours)");
    m_services["http://www.101cookbooks.com"] = recipeRegex;

    // And more soon...

    m_manager = new QNetworkAccessManager(this);
    connect(m_manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(replyFinished(QNetworkReply*)));

}

RecipeParser::~RecipeParser() {

}

void RecipeParser::get(const QString &recipeId, const QString &urlRecipe, const QString &urlService) {
    setLoading(true);
    m_parseHtml = false;
    m_parseJson = false;

    QUrl ingredientsUrl(ApiKeys::F2FGETURL);
    QUrl directionsUrl(urlRecipe);
    m_service = urlService;

    QUrlQuery query;
    query.addQueryItem("key", ApiKeys::F2FKEY);
    query.addQueryItem("rId", recipeId);
    ingredientsUrl.setQuery(query);
    QNetworkRequest ingredientsReq(ingredientsUrl);
    m_manager->get(ingredientsReq);

    QNetworkRequest directionReq(directionsUrl);
    m_manager->get(directionReq);
}

void RecipeParser::replyFinished(QNetworkReply *reply) {
    if (reply->error() == QNetworkReply::NoError) {

        bool apiResponse = QUrl(ApiKeys::F2FURL).isParentOf(reply->url());
        if (apiResponse) {
            parseJson(reply->readAll());
        } else {
            m_contents["source"] = reply->url().toString();
            parseHtml(reply->readAll());
        }

    } else {
        qDebug() << reply->errorString();
    }
    reply->deleteLater();
}

void RecipeParser::parseHtml(const QByteArray &html) {

    RecipeRegex defaultRegex;
    if (m_services.contains(m_service))
        defaultRegex = m_services[m_service];
    else {
        defaultRegex = m_services["default"];
        qDebug() << "Site not supported yet.";
    }

    QRegularExpressionMatchIterator matchDirections = defaultRegex["directions"].globalMatch(html);
    QString directions;

    while (matchDirections.hasNext()) {
        QRegularExpressionMatch match = matchDirections.next();
        directions.append(match.captured(1).replace(QRegularExpression("<.+?>"), "").trimmed());
        directions.append("\n");
    }
    directions.append(tr("\nRecipe from %1").arg(m_service));

    QRegularExpressionMatch matchPreptime = defaultRegex["preptime"].match(html);
    QString preptime;
    if (matchPreptime.hasMatch())
        preptime = matchPreptime.captured(1);


    QRegularExpressionMatch matchCooktime = defaultRegex["cooktime"].match(html);
    QString cooktime;
    if (matchCooktime.hasMatch())
        cooktime = matchCooktime.captured(1);


    m_contents["directions"] = directions;
    m_contents["preptime"] = preptime;
    m_contents["cooktime"] = cooktime;

    m_parseHtml = true;
    hasFinishedParsing();
}

void RecipeParser::parseJson(const QByteArray &json) {
    QJsonObject recipe = QJsonDocument::fromJson(json).object()["recipe"].toObject();
    m_contents["name"] = recipe["title"].toString();
    m_contents["ingredients"] = parseIngredients(recipe["ingredients"].toArray());
    m_contents["photos"] = QJsonArray::fromStringList(QStringList(recipe["image_url"].toString()));

    m_parseJson = true;
    hasFinishedParsing();
}

void RecipeParser::hasFinishedParsing() {
    // If all processes are completed, trigger all signals
    if (m_parseJson && m_parseHtml) {
        setLoading(false);
        contentsChanged();
    }
}
