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

#ifndef QUERYTHREAD_H
#define QUERYTHREAD_H

#include <QList>
#include <QThread>
#include <QMutex>
#include <QWaitCondition>
#include <QSqlDatabase>
#include <QSqlRecord>
#include <QString>
#include <QVariantMap>

// The class that does all the work with the database. This class will
// be instantiated in the thread object's run() method.
class Worker : public QObject {
    Q_OBJECT

public:
    Worker(QObject* parent = 0);
    ~Worker();

public slots:
    bool isInitialized();
    bool setDatabaseName(const QString &name);

    void addRecipe(QVariantMap recipe);
    void deleteRecipe(int id);
    void getRecipe(int id);
    QVariantList getRecipeIngredients(int id);
    void addCategory(const QString &category);
    void deleteCategory(int id);
    int addPhoto(const QString &photo);
    int addIngredient(const QString &ingredient);
    void addSearch(const QString &search);
    void setFilter(const QVariantMap &filter);

    void addRecipeCategory(int recipeId, int categoryId);
    void addRecipePhoto(int recipeId, int photoId);
    void addRecipeIngredient(int recipeId, int ingredientId, const QString &q, const QString &u);

    void removeRecipeCategory(int recipeId, int categoryId);
    void removeRecipePhoto(int recipeId, int photoId);
    void removeRecipeIngredient(int recipeId, int ingredientId);

    void update();
    void updateRecipes();
    void updateCategories();
    void updateRestrictions();
    void updateSearches();
    void updateFavoriteCount();

    void upgrade();

signals:
    void progress(const QString &msg);
    void error(const QString &msg);
    void working(bool wrk);

    void recipeAvailable(const QVariant &recipe);
    void recipeUpdated(int id);
    void recipesUpdated(const QList<QVariant> &recipes);
    void categoriesUpdated(const QList<QVariant> &cats);
    void restrictionsUpdated(const QList<QVariant> &restrictions);
    void searchesUpdated(const QList<QVariant> &searches);
    void favoriteCountUpdated(int favoriteCount);

private:
    QSqlDatabase m_db;
    QVariantMap m_filter;
};

////

class QueryThread : public QThread {

    Q_OBJECT

public:
    QueryThread(QObject *parent = 0);
    ~QueryThread();

    void execute(const QString &query);
    Worker *worker() const;

signals:
    void progress(const QString &msg);
    void ready(bool);

protected:
    void run();

private:
    Worker* m_worker;
};

#endif // RENDERTHREAD_H
