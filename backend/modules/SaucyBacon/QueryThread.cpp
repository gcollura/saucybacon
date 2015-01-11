/**
 * This file is part of SaucyBacon.
 *
 * Copyright 2013-2015 (C) Giulio Collura <random.cpp@gmail.com>
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
#include <QStringList>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QVariant>
#include <QVariantMap>
#include <QQmlProperty>

#include "QueryThread.h"

#include <QDebug>

const int DATABASE_VERSION = 0;

class ScopedTransaction {
public:
    ScopedTransaction(QSqlDatabase &db) :
        m_db(db),
        m_transaction(false) {
        m_transaction = m_db.transaction();
    }

    ~ScopedTransaction() {
        if (m_transaction) {
            m_db.commit();
        }
    }

    QSqlDatabase &m_db;

    bool m_transaction;
};

Worker::Worker(QObject* parent)
    : QObject(parent) {

    // thread-specific connection, see db.h
    m_db = QSqlDatabase::addDatabase("QSQLITE", "WorkerDatabase");
}

Worker::~Worker() {
    m_db.close();
}

bool Worker::isInitialized() {
    QStringList tables = m_db.tables();
    if (tables.contains("recipes", Qt::CaseInsensitive))
        return true;
    return false;
}

bool Worker::setDatabaseName(const QString &name) {
    working(true);

    if (m_db.isOpen()) {
        working(false);
        return true;
    }

    if (!m_db.isValid())
        m_db = QSqlDatabase::addDatabase("QSQLITE", "WorkerDatabase");

    if (!m_db.isValid()) {
        error("QSqlDatabase error.");
        working(false);
        return false;
    }

    if (name != ":memory:") {
        QString dataPath(QStandardPaths::writableLocation(QStandardPaths::DataLocation));
        QString absolutePath(QDir(dataPath).absoluteFilePath(name));
        QString parent(QFileInfo(absolutePath).dir().path());
        if (!QDir().mkpath(parent))
            qWarning() << "Failed to make data folder" << parent;
        m_db.setDatabaseName(absolutePath);
    } else
        m_db.setDatabaseName(name);

    if (!m_db.open()) {
        error(QString("Failed to open database: %1").arg(m_db.lastError().text()));
        working(false);
        return false;
    }

    if (!isInitialized()) {
        QFile file("resources/dbschema.sql");
        QSqlQuery q(m_db.exec());

        ScopedTransaction t(m_db);

        if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
            while (!file.atEnd()) {
                QString line = file.readLine();

                while (!line.endsWith(";\n") && !file.atEnd())
                    line += file.readLine();

                if (!q.exec(line)) {
                    error(QString("Failed to apply database schema: %1:\n%2")
                            .arg(q.lastError().text()).arg(line));
                    working(false);
                    return false;
                }
                q.finish();
            }
        } else {
            error(QString("Error while opening schema file: FileError: %1").arg(file.error()));
            working(false);
            return false;
        }

        qDebug() << "Database correctly configured.";
    }

    upgrade();

    update();
    // get a fake recipe
    getRecipe(0);

    working(false);
    return m_db.isValid();
}

void Worker::upgrade() {
    QSqlQuery q(m_db);
    int version;

    ScopedTransaction t(m_db);

    if (q.exec("SELECT value FROM Settings WHERE key = 'dbversion'") && q.next()) {
        version = q.value(0).toInt();
        qDebug() << "Found database version:" << version;
    } else {
        // FIXME
        version = DATABASE_VERSION;
    }

    // code to update the database goes here
    if (DATABASE_VERSION > version) {

    }
}

void Worker::update() {
    working(true);
    updateRecipes();
    updateCategories();
    updateRestrictions();
    updateSearches();
    updateFavoriteCount();
    working(false);
}

void Worker::addRecipe(QVariantMap recipe) {
    QSqlQuery q(m_db);
    int recipeId, categoryId, photoId, ingredientId;

    recipeId = recipe["id"].toInt();

    working(true);

    ScopedTransaction t(m_db);

    if (recipeId > 0) {
        qDebug() << QString("Updating %1").arg(recipeId);
        q.prepare("INSERT OR REPLACE INTO Recipes (id, name, directions, restriction, preptime, cooktime, favorite, source) "
                "VALUES (:id, :name, :directions, :restriction, :preptime, :cooktime, :favorite, :source)");
        q.bindValue(":id", recipeId);
    } else {
        q.prepare("INSERT INTO Recipes (name, directions, restriction, preptime, cooktime, favorite, source) "
                "VALUES (:name, :directions, :restriction, :preptime, :cooktime, :favorite, :source)");
    }
    q.bindValue(":name", recipe["name"].toString());
    q.bindValue(":directions", recipe["directions"].toString());
    q.bindValue(":restriction", recipe["restriction"].toInt());
    q.bindValue(":preptime", recipe["preptime"].toInt());
    q.bindValue(":cooktime", recipe["cooktime"].toInt());
    q.bindValue(":favorite", recipe["favorite"].toBool());
    q.bindValue(":source", recipe["source"].toString());

    if (!q.exec()) {
        error(QString("Error while adding a new recipe into the db: %1").arg(q.lastError().text()));
        qDebug() << q.lastQuery();
    }

    if (recipeId < 1) {
        qDebug() << "Last inserted id:" << q.lastInsertId().toInt();
        recipeId = q.lastInsertId().toInt();
        recipe["id"] = recipeId;
    } else {
        qDebug() << "Clear junctions for recipeId:" << recipeId;
        removeRecipeCategory(recipeId, -1);
        removeRecipePhoto(recipeId, -1);
        removeRecipeIngredient(recipeId, -1);
    }

    auto ingredients = recipe["ingredients"].toList();
    QString name, quantity, unit;
    Q_FOREACH(QVariant ingredient, ingredients) {
        name = ingredient.toMap()["name"].toString();
        quantity = ingredient.toMap()["quantity"].toString();
        unit = ingredient.toMap()["unit"].toString();

        ingredientId = addIngredient(name);
        if (ingredientId > 0) {
            addRecipeIngredient(recipeId, ingredientId, quantity, unit);
        }
    }

    QList<QVariant> categories = recipe["categories"].toList();
    Q_FOREACH(QVariant category, categories) {
        categoryId = category.toInt();

        if (categoryId > 0) {
            addRecipeCategory(recipeId, categoryId);
        }
    }

    QList<QVariant> photos = recipe["photos"].toList();
    Q_FOREACH(QVariant photo, photos) {
        photoId = addPhoto(photo.toString());

        if (photoId > 0) {
            addRecipePhoto(recipeId, photoId);
        }
    }

    recipe["saved"] = true;

    emit recipeUpdated(recipeId);
    emit recipeAvailable(recipe);

    updateRecipes();
    updateCategories();
    updateRestrictions();
    updateFavoriteCount();

    working(false);
}

void Worker::deleteRecipe(int id) {
    working(true);

    QSqlQuery q(m_db);
    ScopedTransaction t(m_db);

    // TODO: Find a better way to manage multiple delete in sqlite
    QStringList qlist;
    qlist.append(QString("DELETE FROM Ingredients WHERE id IN "
            "(SELECT ingredient_id FROM RecipesIngredients WHERE recipe_id = %1)").arg(id));
    qlist.append(QString("DELETE FROM RecipesIngredients WHERE (recipe_id = %1)").arg(id));
    qlist.append(QString("DELETE FROM Recipes WHERE id = %1").arg(id));

    Q_FOREACH (QString qtext, qlist) {
        if (!q.exec(qtext)) {
            error(QString("Error while deleting a recipe: %1").arg(q.lastError().text()));
        }
        q.finish();
    }

    removeRecipeCategory(id, -1);
    removeRecipePhoto(id, -1);
    removeRecipeIngredient(id, -1);

    // Let's load another recipe instantly
    if (q.exec("SELECT * FROM Recipes LIMIT 1")) {
        q.next();
        id = q.record().value("id").toInt();
        getRecipe(id);
    } else {
        error(QString("Error while looking for a recipe: %1").arg(q.lastError().text()));
    }

    updateRecipes();
    updateCategories();
    updateRestrictions();
    updateFavoriteCount();

    working(false);
}

void Worker::getRecipe(int id) {
    working(true);

    QSqlQuery q(m_db);
    QJsonObject recipe;

    q.prepare("SELECT r.*, group_concat(c.id) AS categories, group_concat(p.name) AS photos "
            "FROM Recipes AS r "
            "LEFT JOIN RecipesCategories AS rc ON r.id = rc.recipe_id "
            "LEFT JOIN Categories AS c ON c.id = rc.category_id "
            "LEFT JOIN RecipesPhotos AS rp ON r.id = rp.recipe_id "
            "LEFT JOIN Photos AS p ON p.id = rp.photo_id "
            "WHERE r.id = :id");
    q.bindValue(":id", id);

    if (q.exec() && q.next()) {
        recipe["id"] = q.value("id").toInt();
        recipe["name"] = q.value("name").toString();
        recipe["directions"] = q.value("directions").toString();
        recipe["favorite"] = q.value("favorite").toBool();
        recipe["preptime"] = q.value("preptime").toInt();
        recipe["cooktime"] = q.value("cooktime").toInt();
        recipe["restriction"] = q.value("restriction").toInt();
        recipe["source"] = q.value("source").toString();

        auto data = q.value("photos").toString();
        if (data.length() > 0)
            recipe["photos"] = QJsonArray::fromStringList(data.split(","));
        else
            recipe["photos"] = QJsonArray();

        data = q.value("categories").toString();
        if (data.length() > 0)
            recipe["categories"] = QJsonArray::fromStringList(data.split(","));
        else
            recipe["categories"] = QJsonArray();

        recipe["ingredients"] = QJsonArray::fromVariantList(getRecipeIngredients(id));

        recipe["saved"] = true;
    } else {
        error(QString("Error while retrieving recipe: %1").arg(q.lastError().text()));
    }

    recipeAvailable(recipe);
    working(false);
}

QVariantList Worker::getRecipeIngredients(int id) {
    QVariantList ingredients;
    QVariantMap ingredient;
    QSqlQuery q(m_db);

    ScopedTransaction t(m_db);

    q.prepare("SELECT i.name, ri.unit, ri.quantity FROM RecipesIngredients AS ri "
            "LEFT JOIN Ingredients AS i ON i.id = ri.ingredient_id "
            "WHERE ri.recipe_id = :id");
    q.bindValue(":id", id);

    if (!q.exec()) {
        error(QString("Error while retrieving recipe ingredients: %1").arg(q.lastError().text()));
        return ingredients;
    }

    while (q.next()) {
        ingredient["name"] = q.value("name").toString();
        ingredient["unit"] = q.value("unit").toString();
        ingredient["quantity"] = q.value("quantity").toString();

        ingredients.push_back(ingredient);
    }

    return ingredients;
}

void Worker::addRecipeCategory(int recipeId, int categoryId) {
    QSqlQuery q(m_db);

    q.prepare("INSERT OR IGNORE INTO RecipesCategories (recipe_id, category_id) VALUES (:recipeid, :categoryid)");
    q.bindValue(":recipeid", recipeId);
    q.bindValue(":categoryid", categoryId);

    if (!q.exec()) {
        error(QString("Error while adding a new RecipesCategories relation into the db: %1").arg(q.lastError().text()));
    }
}

void Worker::addRecipeIngredient(int recipeId, int ingredientId, const QString &quantity, const QString &unit) {
    QSqlQuery q(m_db);

    q.prepare("INSERT OR IGNORE INTO RecipesIngredients (recipe_id, ingredient_id, quantity, unit)"
            " VALUES (:recipeid, :ingredientid, :quantity, :unit)");
    q.bindValue(":recipeid", recipeId);
    q.bindValue(":ingredientid", ingredientId);
    q.bindValue(":quantity", quantity);
    q.bindValue(":unit", unit);

    if (!q.exec()) {
        error(QString("Error while adding a new RecipeIngredient relation into the db: %1").arg(q.lastError().text()));
    }
}

void Worker::addRecipePhoto(int recipeId, int photoId) {
    QSqlQuery q(m_db);

    q.prepare("INSERT OR IGNORE INTO RecipesPhotos (recipe_id, photo_id) VALUES (:recipeid, :photoid)");
    q.bindValue(":recipeid", recipeId);
    q.bindValue(":photoid", photoId);

    if (!q.exec()) {
        error(QString("Error while adding a new RecipesCategories relation into the db: %1").arg(q.lastError().text()));
    }
}

void Worker::removeRecipeCategory(int recipeId, int categoryId) {
    QSqlQuery q(m_db);

    if (recipeId > 0) {
        q.prepare("DELETE FROM RecipesCategories WHERE (recipe_id = :recipeid)");
        q.bindValue(":recipeid", recipeId);
    } else if (categoryId > 0) {
        q.prepare("DELETE FROM RecipesCategories WHERE (category_id = :categoryid)");
        q.bindValue(":categoryid", categoryId);
    } else {
        return;
    }

    if (!q.exec()) {
        error(QString("Error while removing a RecipesCategories relation into the db: %1").arg(q.lastError().text()));
    }
}

void Worker::removeRecipePhoto(int recipeId, int photoId) {
    QSqlQuery q(m_db);

    if (recipeId > 0) {
        q.prepare("DELETE FROM RecipesPhotos WHERE (recipe_id = :recipeid)");
        q.bindValue(":recipeid", recipeId);
    } else if (photoId > 0) {
        q.prepare("DELETE FROM RecipesPhotos WHERE (photo_id = :photoid)");
        q.bindValue(":photoid", photoId);
    } else {
        return;
    }

    if (!q.exec()) {
        error(QString("Error while removing a RecipesPhotos relation into the db: %1").arg(q.lastError().text()));
    }
}

void Worker::removeRecipeIngredient(int recipeId, int ingredientId) {
    QSqlQuery q(m_db);

    if (recipeId > 0) {
        q.prepare("DELETE FROM RecipesIngredients WHERE (recipe_id = :recipeid)");
        q.bindValue(":recipeid", recipeId);
    } else if (ingredientId > 0) {
        q.prepare("DELETE FROM Recipesingredients WHERE (ingredient_id = :ingredientid)");
        q.bindValue(":ingredientid", ingredientId);
    } else {
        return;
    }

    if (!q.exec()) {
        error(QString("Error while removing a RecipesIngredients relation into the db: %1").arg(q.lastError().text()));
    }
}

void Worker::addCategory(const QString &category) {
    QSqlQuery q(m_db);

    working(true);

    q.prepare("INSERT OR IGNORE INTO Categories (name) VALUES (:category)");
    q.bindValue(":category", category);

    if (!q.exec()) {
        error(QString("Error while adding a category into the db: %1").arg(q.lastError().text()));
    }

    updateCategories();

    working(false);
}

void Worker::deleteCategory(int id) {
    QSqlQuery q(m_db);
    working(true);

    ScopedTransaction t(m_db);

    q.prepare("DELETE FROM Categories WHERE (id = :id)");
    q.bindValue(":id", id);

    if (!q.exec()) {
        error(QString("Error while deleting a category from the db: %1").arg(q.lastError().text()));
    }

    removeRecipeCategory(-1, id);
    updateCategories();

    working(false);
}

int Worker::addIngredient(const QString &ingredient) {
    QSqlQuery q1(m_db);
    QSqlQuery q2(m_db);
    int id;

    q1.prepare("INSERT OR IGNORE INTO Ingredients (name) VALUES (:ingredient)");
    q1.bindValue(":ingredient", ingredient);

    if (!q1.exec()) {
        error(QString("Error while inserting an ingredient from the db: %1").arg(q1.lastError().text()));
        return -1;
    }

    q2.prepare("SELECT * FROM Ingredients WHERE name = :ingredient");
    q2.bindValue(":ingredient", ingredient);

    if (q2.exec() && q2.next()) {
        id = q2.value("id").toInt();
    } else {
        error(QString("Error while getting an ingredient from the db: %1").arg(q2.lastError().text()));
        return -1;
    }

    return id;
}

int Worker::addPhoto(const QString &photo) {
    QSqlQuery q1(m_db);
    QSqlQuery q2(m_db);
    int id;

    q1.prepare("INSERT OR IGNORE INTO Photos (name) VALUES (:photo)");
    q1.bindValue(":photo", photo);

    if (!q1.exec()) {
        error(QString("Error while adding a photo into the db: %1").arg(q1.lastError().text()));
        return -1;
    }

    q2.prepare("SELECT * FROM Photos WHERE name = :photo");
    q2.bindValue(":photo", photo);

    if (q2.exec() && q2.next()) {
        id = q2.value("id").toInt();
    } else {
        error(QString("Error while adding a photo into the db: %1").arg(q2.lastError().text()));
        return -1;
    }

    return id;
}

void Worker::addSearch(const QString &search) {
    QSqlQuery q(m_db);

    if (!isInitialized())
        return;

    working(true);

    q.prepare("INSERT OR IGNORE INTO Searches (name) VALUES (:search)");
    q.bindValue(":search", search);

    if (!q.exec()) {
        error(QString("Error while adding a search key into the db: %1").arg(q.lastError().text()));
    }

    updateSearches();

    working(false);
}

void Worker::setFilter(const QVariantMap &filter) {
    m_filter = filter;
    updateRecipes();
}

void Worker::updateRecipes() {
    QSqlQuery q(m_db);
    QList<QVariant> recipes;
    QJsonObject recipe;

    ScopedTransaction t(m_db);

    QString qText("SELECT r.*, group_concat(c.name) AS categories, group_concat(p.name) AS photos "
            "FROM Recipes AS r "
            "LEFT JOIN RecipesCategories AS rc ON r.id = rc.recipe_id "
            "LEFT JOIN Categories AS c ON c.id = rc.category_id "
            "LEFT JOIN RecipesPhotos AS rp ON r.id = rp.recipe_id "
            "LEFT JOIN Photos AS p ON p.id = rp.photo_id ");

    if (!m_filter.isEmpty()) {
        if (m_filter["type"].toString() == "category")
            qText += QString(" WHERE rc.category_id = %1 ").arg(m_filter["id"].toInt());
        if (m_filter["type"].toString() == "restriction")
            qText += QString(" WHERE r.restriction = %1 ").arg(m_filter["id"].toInt());
        if (m_filter["type"].toString() == "favorite")
            qText += QString(" WHERE r.favorite = %1 ").arg(m_filter["id"].toInt());
    }

    qText += " GROUP BY r.id ";
    q.prepare(qText);

    if (!q.exec()) {
        error(QString("Error while loading recipes: %1").arg(q.lastError().text()));
        qDebug() << q.lastQuery();
    }

    while (q.next()) {
        recipe["id"] = q.value("id").toString();
        recipe["name"] = q.value("name").toString();
        recipe["preptime"] = q.value("preptime").toInt();
        recipe["cooktime"] = q.value("cooktime").toInt();
        recipe["favorite"] = q.value("favorite").toBool();
        recipe["restriction"] = q.value("restriction").toInt();
        recipe["photos"] = QJsonArray::fromStringList(q.value("photos").toString().split(","));
        recipe["categories"] = QJsonArray::fromStringList(q.value("categories").toString().split(","));

        recipes.append(recipe);
    }

    recipesUpdated(recipes);
}

void Worker::updateCategories() {
    QSqlQuery q(m_db);
    QList<QVariant> cats;
    QJsonObject cat;

    q.prepare("SELECT c.id, c.name, count(rc.category_id) as count FROM Categories as c "
            "LEFT JOIN RecipesCategories AS rc ON c.id = rc.category_id "
            "GROUP BY c.id, c.name");

    if (!q.exec()) {
        error(QString("Error while loading categories: %1").arg(q.lastError().text()));
    }

    while (q.next()) {
        cat["id"] = q.value("id").toInt();
        cat["name"] = q.value("name").toString();
        cat["count"] = q.value("count").toString();
        cats.push_back(cat);
    }

    categoriesUpdated(cats);
}

void Worker::updateRestrictions() {
    QSqlQuery q(m_db);
    QList<QVariant> res;
    QJsonObject object;
    int count;

    q.prepare("SELECT r.restriction, count(*) as count FROM Recipes as r GROUP BY r.restriction");
    if (!q.exec()) {
        error(QString("Error while loading restrictions: %1").arg(q.lastError().text()));
    }

    if (q.next())
        count = q.value("count").toInt();
    else
        count = 0;
    object["id"] = 0;
    object["name"] = tr("No restriction");
    object["count"] = count;
    res.push_back(object);

    if (q.next())
        count = q.value("count").toInt();
    else
        count = 0;
    object["id"] = 1;
    object["name"] = tr("Vegetarian");
    object["count"] = count;
    res.push_back(object);

    if (q.next())
        count = q.value("count").toInt();
    else
        count = 0;
    object["id"] = 2;
    object["name"] = tr("Vegan");
    object["count"] = count;
    res.push_back(object);

    restrictionsUpdated(res);
}

void Worker::updateSearches() {
    QSqlQuery q(m_db);
    QList<QVariant> searches;
    QJsonObject search;

    q.prepare("SELECT * FROM Searches");

    if (!q.exec()) {
        error(QString("Error while loading searches: %1").arg(q.lastError().text()));
    }

    while (q.next()) {
        search["id"] = q.value("id").toInt();
        search["name"] = q.value("name").toString();
        searches.push_back(search);
    }

    searchesUpdated(searches);
}

void Worker::updateFavoriteCount() {
    QSqlQuery q(m_db);
    q.prepare("SELECT count(*) as count FROM Recipes WHERE favorite = 1 GROUP BY favorite");

    if (!q.exec() || !q.next()) {
        error(QString("Error while loading favoriteCount: %1").arg(q.lastError().text()));
        favoriteCountUpdated(0);
        return;
    }

    favoriteCountUpdated(q.value("count").toInt());
}

////

QueryThread::QueryThread(QObject *parent)
    : QThread(parent) {
}

QueryThread::~QueryThread() {
    delete m_worker;
}

Worker *QueryThread::worker() const {
    return m_worker;
}

void QueryThread::run() {
    emit ready(false);

    // Create worker object within the context of the new thread
    m_worker = new Worker();

    emit ready(true);
    exec();
}
