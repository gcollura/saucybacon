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

#ifndef DATABASE_H
#define DATABASE_H

#include <QAbstractListModel>
#include <QtSql/QSqlDatabase>

class QueryThread;
class RecipeParser;

class Database : public QObject {

    Q_OBJECT
    Q_PROPERTY(QString error READ error NOTIFY errorChanged)
    Q_PROPERTY(bool ready READ ready NOTIFY readyChanged)
    Q_PROPERTY(bool working READ working NOTIFY workingChanged)
    Q_PROPERTY(bool loading READ loading NOTIFY loadingChanged)

    Q_PROPERTY(QVariant recipe READ currentRecipe NOTIFY currentRecipeChanged)
    Q_PROPERTY(QList<QVariant> recipes READ recipes NOTIFY recipesChanged)
    Q_PROPERTY(QList<QVariant> categories READ categories NOTIFY categoriesChanged)
    Q_PROPERTY(QList<QVariant> restrictions READ restrictions NOTIFY restrictionsChanged)
    Q_PROPERTY(QList<QVariant> searches READ searches NOTIFY searchesChanged)

    Q_PROPERTY(QVariantMap filter READ filter WRITE setFilter NOTIFY filterChanged)

public:
    explicit Database(QObject *parent = 0);
    virtual ~Database();

    Q_INVOKABLE void addRecipe(const QVariantMap &recipe);
    // Q_INVOKABLE void updateRecipe(int id, const QVariantMap &recipe);
    Q_INVOKABLE void deleteRecipe(int id);
    Q_INVOKABLE void getRecipe(int id);
    Q_INVOKABLE void getRecipeOnline(const QString &id, const QString &url, const QString &service, const QString &image);
    Q_INVOKABLE void addCategory(const QString &category);
    Q_INVOKABLE void deleteCategory(int id);
    Q_INVOKABLE void addSearch(const QString &search);

signals:
    void errorChanged(const QString &error);
    void readyChanged(bool ready);
    void workingChanged(bool working);
    void loadingChanged(bool loading);
    void setDatabaseName(const QString &name);

    void currentRecipeChanged();
    void recipesChanged();
    void categoriesChanged();
    void restrictionsChanged();
    void searchesChanged();
    void filterChanged();

protected slots:
    void setError(const QString &error);
    void setReady(bool ready);
    void setWorking(bool work);
    void setLoading(bool loading);

    void setCurrentRecipe(const QVariant &recipe);
    void setRecipes(const QList<QVariant> &recipes);
    void setCategories(const QList<QVariant> &cats);
    void setRestrictions(const QList<QVariant> &restrictions);
    void setSearches(const QList<QVariant> &searches);

    void setFilter(const QVariantMap &filter);

signals:
    void update();

private:
    bool initDb(const QString &path = ":memory:");
    bool isInitialized();

    QString error() const;
    bool ready() const;
    bool working() const;
    bool loading() const;

    QVariant currentRecipe() const;
    QList<QVariant> recipes() const;
    QList<QVariant> categories() const;
    QList<QVariant> restrictions() const;
    QList<QVariant> searches() const;
    QVariantMap filter() const;

    QueryThread *m_db;
    RecipeParser *m_rParser;
    QString m_error;
    bool m_ready;
    bool m_working;
    bool m_loading;

    QVariant m_recipe;
    QList<QVariant> m_recipes;
    QList<QVariant> m_categories;
    QList<QVariant> m_restrictions;
    QList<QVariant> m_searches;
    QVariantMap m_filter;
};

#endif // DATABASE_H
