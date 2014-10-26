-- Database schema
CREATE TABLE Recipes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(100) NOT NULL,
    difficulty INTEGER,
    directions VARCHAR(10000),
    restriction INTEGER,
    favorite BOOLEAN,
    preptime INTEGER,
    cooktime INTEGER,
    source VARCHAR(100),
    f2fsource VARCHAR(100)
);

CREATE TABLE Ingredients (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(50) NOT NULL,
    UNIQUE(name)
);

CREATE TABLE Categories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(50) NOT NULL,
    UNIQUE(name)
);

CREATE TABLE Photos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(100) NOT NULL,
    UNIQUE(name)
);

CREATE TABLE Searches (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(50) NOT NULL,
    UNIQUE(name)
);

CREATE TABLE RecipesIngredients (
    recipe_id INTEGER NOT NULL REFERENCES Recipes(id),
    ingredient_id INTEGER NOT NULL REFERENCES Ingredients(id),
    quantity VARCHAR(30),
    unit VARCHAR(20),
    PRIMARY KEY (recipe_id, ingredient_id)
);

CREATE TABLE RecipesCategories (
    recipe_id INTEGER NOT NULL REFERENCES Recipes(id),
    category_id INTEGER NOT NULL REFERENCES Categories(id),
    PRIMARY KEY (recipe_id, category_id)
);

CREATE TABLE RecipesPhotos (
    recipe_id INTEGER NOT NULL REFERENCES Recipes(id),
    photo_id INTEGER NOT NULL REFERENCES Photos(id),
    PRIMARY KEY (recipe_id, photo_id)
);

CREATE TABLE Settings (
    key VARCHAR(50) PRIMARY KEY,
    value VARCHAR(50)
);

INSERT INTO Settings (key, value) VALUES ("dbversion", "1");
