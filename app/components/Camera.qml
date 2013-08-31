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

import QtQuick 2.0
import QtQuick.Window 2.0
import Ubuntu.Components 0.1
import QtMultimedia 5.0
import SaucyBacon 0.1

Item {
    id: root

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter

    signal imageCaptured(string image)

    Camera {
        id: camera
        flash.mode: Camera.FlashAuto
        captureMode: Camera.CaptureStillImage // Default mode
        focus.focusMode: Camera.FocusAuto
        exposure.exposureMode: Camera.ExposureAuto

        cameraState: Camera.UnloadedState

        imageCapture {
            onImageSaved: imageCaptured(path)
        }
    }

    VideoOutput {
        id: videoPreview
        source: camera

        fillMode: VideoOutput.PreserveAspectCrop
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }

        focus: visible

        /* This rotation needs to be applied since the camera hardware in the
           Galaxy Nexus phone is mounted at an angle inside the device, so the video
           feed is rotated too.
           FIXME: This should come from a system configuration option so that we
           don't have to have a different codebase for each different device we want
           to run on */

        orientation: Screen.primaryOrientation == Qt.LandscapeOrientation ? 0 : -90
    }

    function captureImage() {

        camera.setCaptureMode(Camera.CaptureStillImage);

        camera.start();

        camera.searchAndLock();

        camera.imageCapture.capture();

        camera.unlock();
    }

    function captureVideo() {

        camera.setCaptureMode(Camera.CaptureVideo);

        camera.start();

        camera.videoRecorder.record();
        camera.videoRecorder.stop();

        camera.unlock();
    }

    function setActiveState(status) {

        if (status)
            camera.setCameraState(Camera.ActiveState);
        else
            camera.setCameraState(Camera.UnloadedState);
    }
}
