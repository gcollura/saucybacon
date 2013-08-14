.pragma library

// main object
var db = new Database();

// Database class definition
function Database() { }

Database.prototype.init = function () {

    var u1db = new U1db.Database()
    u1db.setPath("/home/random");
}
