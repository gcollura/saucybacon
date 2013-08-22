import QtQuick 2.0
import QtQuick.Window 2.0
import Ubuntu.Components 0.1
import QtMultimedia 5.0

UbuntuShape {
    width: parent.width
    height: width

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter

    Camera {
        id: camera
        flash.mode: Camera.FlashAuto
        captureMode: Camera.CaptureStillImage // Default mode
        focus.focusMode: Camera.FocusAuto
        exposure.exposureMode: Camera.ExposureAuto

        cameraState: Camera.UnloadedState

        imageCapture {
            onImageSaved: {
                console.log("image saved as " + path);
            }
        }
    }

    VideoOutput {
        id: videoPreview
        source: camera

        fillMode: VideoOutput.PreserveAspectCrop

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

        return camera.imageCapture.capturedImagePath;
    }

    function captureVideo() {

        camera.setCaptureMode(Camera.CaptureVideo);

        camera.start();
        camera.videoRecorder.setOutputLocation("/home/Videos/test.wmv");

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
