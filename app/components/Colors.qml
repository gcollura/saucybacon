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

import QtQuick 2.2

QtObject {

    readonly property color white: "#ffffff"
    readonly property color darkRed: "#540810"
    readonly property color darkerRed: "#370517"
    readonly property color headerColor: "#6d0a0a"
    readonly property color footerColor: darkerRed

    property Gradient redGradient: Gradient {
        GradientStop { position: 0.0; color: darkRed }
        GradientStop { position: 1.0; color: darkRed }
    }
}
