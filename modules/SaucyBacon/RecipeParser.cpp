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

QJsonValue evaluate(const QString &expr) {
    QScriptEngine myEngine;
    auto result = myEngine.evaluate(expr);
    return result.isNumber() ? result.toNumber() : 0;
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
    // Default regex -- "a^" doesn't match anything
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
    recipeRegex["directions"] = QRegularExpression("itemprop=\"recipeInstructions\">(.+?)</div>",
                                                   QRegularExpression::DotMatchesEverythingOption);
    recipeRegex["preptime"] = QRegularExpression("class=\"preptime\".*?>(\\d+) ([mM]inutes|[hH]ours)<span");
    recipeRegex["cooktime"] = QRegularExpression("class=\"cooktime\".*?>(\\d+) ([mM]inutes|[hH]ours)<span");
    m_services["http://simplyrecipes.com"] = recipeRegex;

    // PioneerWoman
    recipeRegex["directions"] = QRegularExpression("itemprop=\"instructions\">(.+?)</div>",
                                                   QRegularExpression::DotMatchesEverythingOption);
    recipeRegex["preptime"] = QRegularExpression("itemprop=\'prepTime\'.+?>(\\d+) ([mM]inutes|[hH]ours)</time");
    recipeRegex["cooktime"] = QRegularExpression("itemprop=\'cookTime\'.+?>(\\d+) ([mM]inutes|[hH]ours)</time");
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

    // Epicurious
    recipeRegex["directions"] = QRegularExpression("<div id=\"preparation\".+?>(.+?)</div>",
                                                   QRegularExpression::DotMatchesEverythingOption |
                                                   QRegularExpression::CaseInsensitiveOption);
    recipeRegex["preptime"] = QRegularExpression("class=\"prepTime\">.+?(\\d+) (hour[s]?|min[a-z+]?).+?<span",
                                                 QRegularExpression::DotMatchesEverythingOption);
    recipeRegex["cooktime"] = QRegularExpression("a^");
    m_services["http://www.epicurious.com"] = recipeRegex;

    // BBC good food
    recipeRegex["directions"] = QRegularExpression("section id=\"recipe-method\".+?>(.+?)</section",
                                                   QRegularExpression::DotMatchesEverythingOption);
    recipeRegex["preptime"] = QRegularExpression("class=\"cooking-time-prep\".+?>.+?(\\d+) (hour[s]?|min[a-z+]+).+?</span",
                                                 QRegularExpression::DotMatchesEverythingOption);
    recipeRegex["cooktime"] = QRegularExpression("class=\"cooking-time-cook\".+?>.+?(\\d+) (hour[s]?|min[a-z+]+).+?</span",
                                                 QRegularExpression::DotMatchesEverythingOption);
    m_services["http://www.bbcgoodfood.com"] = recipeRegex;

    // BBC.co.uk Food
    recipeRegex["directions"] = QRegularExpression("div id=\"preparation\".+?>(.+?)</div",
                                                   QRegularExpression::DotMatchesEverythingOption);
    recipeRegex["preptime"] = QRegularExpression("class=\"prepTime\".+?>.+?(\\d+) (hour[s]?|min[a-z+]+).?</span",
                                                 QRegularExpression::DotMatchesEverythingOption);
    recipeRegex["cooktime"] = QRegularExpression("class=\"cookTime\".+?>.+?(\\d+) (hour[s]?|min[a-z+]+).?</span",
                                                 QRegularExpression::DotMatchesEverythingOption);
    m_services["http://www.bbc.co.uk/food"] = recipeRegex;

    // BonAppetit
    recipeRegex["directions"] = QRegularExpression("class=\"prep-steps\".+?>(.+?)<div class=\"recipe-footer",
                                                   QRegularExpression::DotMatchesEverythingOption);
    recipeRegex["preptime"] = QRegularExpression("itemprop=\"prepTime\".+?>.+?(\\d+) (hour[s]?|min[a-z+]+).?</span",
                                                 QRegularExpression::DotMatchesEverythingOption);
    recipeRegex["cooktime"] = QRegularExpression("itemprop=\"totalTime\".+?>.+?(\\d+) (hour[s]?|min[a-z+]+).?</span",
                                                 QRegularExpression::DotMatchesEverythingOption);
    m_services["http://www.bonappetit.com"] = recipeRegex;

    // Cookstr
    recipeRegex["directions"] = QRegularExpression("itemprop=\"recipeInstructions\".+?>(.+?)</div",
                                                   QRegularExpression::DotMatchesEverythingOption);
    recipeRegex["preptime"] = QRegularExpression("a^");
    recipeRegex["cooktime"] = QRegularExpression("a^");
    m_services["http://www.cookstr.com"] = recipeRegex;

    // Chow
    recipeRegex["directions"] = QRegularExpression("itemprop=\"instructions\".+?>(.+?)</div",
                                                   QRegularExpression::DotMatchesEverythingOption);
    recipeRegex["preptime"] = QRegularExpression("a^");
    recipeRegex["cooktime"] = QRegularExpression("a^");
    m_services["http://www.chow.com"] = recipeRegex;

    // And more soon...

    m_manager = new QNetworkAccessManager(this);
    connect(m_manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(replyFinished(QNetworkReply*)));

}

RecipeParser::~RecipeParser() {

}

void RecipeParser::get(const QString &recipeId, const QString &recipeUrl, const QString &serviceUrl, const QString &imageUrl) {
    setLoading(true);
    m_parseHtml = false;
    m_parseJson = false;
    m_parseImage = false;

    QUrl ingredientsUrl(ApiKeys::F2FGETURL);
    QUrl directionsUrl(recipeUrl);
    m_service = serviceUrl;
    QUrl photoUrl(imageUrl);

    QUrlQuery query;
    query.addQueryItem("key", ApiKeys::F2FKEY);
    query.addQueryItem("rId", recipeId);
    ingredientsUrl.setQuery(query);
    QNetworkRequest ingredientsReq(ingredientsUrl);
    m_manager->get(ingredientsReq);

    QNetworkRequest directionReq(directionsUrl);
    m_manager->get(directionReq);

    QNetworkRequest photoReq(photoUrl);
    m_photoName = imageUrl.split("/").back();
    m_manager->get(photoReq);
}

void RecipeParser::replyFinished(QNetworkReply *reply) {
    if (reply->error() == QNetworkReply::NoError) {

        bool apiResponse = QUrl(ApiKeys::F2FURL).isParentOf(reply->url());
        if (apiResponse) {
            parseJson(reply->readAll());
        } else if (reply->url().toString().contains(m_photoName)) {
            parseImage(reply->readAll());
        } else {
            int statusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
            if (statusCode == 301) {
                QUrl redirectUrl = reply->attribute(QNetworkRequest::RedirectionTargetAttribute).toUrl();
                m_manager->get(QNetworkRequest(redirectUrl));
            }
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
        qDebug() << "Site not supported yet: " + m_service;
    }

    QRegularExpressionMatchIterator matchDirections = defaultRegex["directions"].globalMatch(html);
    QString directions;

    while (matchDirections.hasNext()) {
        QRegularExpressionMatch match = matchDirections.next();
        directions.append(match.captured(1).replace(QRegularExpression("<.+?>"), "").simplified());
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
    m_contents["source"] = recipe["source_url"].toString();
    m_contents["f2f"] = recipe["f2f_url"].toString();

    m_parseJson = true;
    hasFinishedParsing();
}

void RecipeParser::parseImage(const QByteArray &imgData) {
    QFile photo;
    photo.setFileName(m_destPath + "/" + m_photoName);
    photo.open(QIODevice::WriteOnly);
    photo.write(imgData);
    photo.close();

    m_contents["photos"] = QJsonArray::fromStringList(QStringList(photo.fileName()));

    m_parseImage = true;
    hasFinishedParsing();
}

void RecipeParser::hasFinishedParsing() {
    // If all processes are completed, trigger all signals
    if (m_parseJson && m_parseHtml && m_parseImage) {
        setLoading(false);
        emit contentsChanged();
    }
}
