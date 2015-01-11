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

Object.defineProperty(String.prototype, "startsWith", {
    enumerable: false,
    value: function (str) {
        return this.indexOf(str) == 0;
    }
});

Object.defineProperty(String.prototype, "toIntTime", {
    enumerable: false,
    value: function() {
        var time = this.split(":");
        return parseInt(time[0])*60 + parseInt(time[1]);
    }
});

Object.defineProperty(String.prototype, "capitalize", {
    enumerable: false,
    value: function() {
        return this.charAt(0).toUpperCase() + this.slice(1);
    }
});

Object.defineProperty(Number.prototype, "toTime", {
    enumerable: false,
    value: function () {
        var hh = Math.floor(this / 60);
        var mm = this % 60;
        return hh.toString() + ":" + ("0" + mm).slice(-2);
    }
});


Object.defineProperty(Object.prototype, "keys", {
    enumerable: false,
    value: function () {
        var keys = [];
        for (var k in this) keys.push(k);
        return keys;
    }
});

Object.defineProperty(Array.prototype, "pushBack", {
    enumerable: false,
    value: function (item) {
        // This for seems to be slightly faster than .indexOf(item)
        for (var i = 0; i < this.length; i++)
            if (this[i] == item)
                return i;
        this.push(item);
        return i;
    }
});
