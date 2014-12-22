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

#include <QtCore>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QSqlResult>
#include <QSqlError>
#include <QJsonObject>

#include "Database.h"
#include "QueryThread.h"
#include "RecipeParser.h"

#include <QDebug>

Database::Database(QObject *parent) :
    QObject(parent) {

    m_db = new QueryThread();
    connect(m_db, &QueryThread::ready, this, &Database::setReady);
    m_db->start();

    m_rParser = new RecipeParser(this);
    connect(m_rParser, &RecipeParser::recipeAvailable, this, &Database::setCurrentRecipe);
    connect(m_rParser, &RecipeParser::loading, this, &Database::setLoading);
    // force loading to false
    setLoading(false);
}

Database::~Database() {
    m_db->quit();
    m_db->wait();
    delete m_db;
}

void Database::addRecipe(const QVariantMap &recipe) {
    QMetaObject::invokeMethod(m_db->worker(), "addRecipe", Qt::QueuedConnection,
            Q_ARG(QVariantMap, recipe));
}

void Database::deleteRecipe(int id) {
    QMetaObject::invokeMethod(m_db->worker(), "deleteRecipe", Qt::QueuedConnection,
            Q_ARG(int, id));
}

void Database::getRecipe(int id) {
    QMetaObject::invokeMethod(m_db->worker(), "getRecipe", Qt::QueuedConnection,
            Q_ARG(int, id));
}

void Database::getRecipeOnline(const QString &id, const QString &url, const QString &service, const QString &image) {
    m_rParser->get(id, url, service, image);
}

void Database::addCategory(const QString &category) {
    QMetaObject::invokeMethod(m_db->worker(), "addCategory", Qt::QueuedConnection,
            Q_ARG(QString, category));
}

void Database::deleteCategory(int id) {
    QMetaObject::invokeMethod(m_db->worker(), "deleteCategory", Qt::QueuedConnection,
            Q_ARG(int, id));
}

void Database::addSearch(const QString &search) {
    QMetaObject::invokeMethod(m_db->worker(), "addSearch", Qt::QueuedConnection,
            Q_ARG(QString, search));
}

void Database::setError(const QString &error) {
    qWarning() << "Database error:" << error;
    m_error = error;
    errorChanged(error);
}

void Database::setReady(bool ready) {
    qWarning() << "Database ready:" << ready;
    if (ready != m_ready) {
        m_ready = ready;
        readyChanged(ready);
    }

    if (ready) {
        // Connect signals with the worker
        connect(m_db->worker(), &Worker::error, this, &Database::setError);
        connect(m_db->worker(), &Worker::working, this, &Database::setWorking);

        connect(this, &Database::update, m_db->worker(), &Worker::update);

        connect(this, &Database::setDatabaseName, m_db->worker(), &Worker::setDatabaseName);

        connect(m_db->worker(), &Worker::recipesUpdated, this, &Database::setRecipes);
        connect(m_db->worker(), &Worker::recipeAvailable, this, &Database::setCurrentRecipe);
        connect(m_db->worker(), &Worker::categoriesUpdated, this, &Database::setCategories);
        connect(m_db->worker(), &Worker::restrictionsUpdated, this, &Database::setRestrictions);
        connect(m_db->worker(), &Worker::searchesUpdated, this, &Database::setSearches);
        connect(m_db->worker(), &Worker::favoriteCountUpdated, this, &Database::setFavoriteCount);

        emit setDatabaseName("saucybacon.db");
    }
}

void Database::setWorking(bool working) {
    if (working != m_working) {
        qWarning() << "Database working:" << working;
        m_working = working;
        workingChanged(working);
    }
}

void Database::setLoading(bool loading) {
    if (loading != m_loading) {
        m_loading = loading;
        loadingChanged(loading);
    }
}

QString Database::error() const {
    return m_error;
}

bool Database::ready() const {
    return m_ready;
}

bool Database::working() const {
    return m_working;
}

bool Database::loading() const {
    return m_loading;
}

void Database::setCurrentRecipe(const QVariant &recipe) {
    m_recipe = recipe;
    currentRecipeChanged();
}

void Database::setRecipes(const QList<QVariant> &recipes) {
    m_recipes = recipes;
    recipesChanged();
}

void Database::setCategories(const QList<QVariant> &cats) {
    m_categories = cats;
    categoriesChanged();
}

void Database::setRestrictions(const QList<QVariant> &restrictions) {
    m_restrictions = restrictions;
    restrictionsChanged();
}

void Database::setSearches(const QList<QVariant> &searches) {
    m_searches = searches;
    searchesChanged();
}

void Database::setFavoriteCount(int favoriteCount) {
    m_favoriteCount = favoriteCount;
    favoriteCountChanged();
}

void Database::setFilter(const QVariantMap &filter) {
    m_filter = filter;
    filterChanged();
    QMetaObject::invokeMethod(m_db->worker(), "setFilter", Qt::QueuedConnection,
            Q_ARG(QVariantMap, filter));
}

QVariant Database::currentRecipe() const {
    return m_recipe;
}

QList<QVariant> Database::recipes() const {
    return m_recipes;
}

QList<QVariant> Database::categories() const {
    return m_categories;
}

QList<QVariant> Database::restrictions() const {
    return m_restrictions;
}

QList<QVariant> Database::searches() const {
    return m_searches;
}

int Database::favoriteCount() const {
    return m_favoriteCount;
}

QVariantMap Database::filter() const {
    return m_filter;
}
