""" A main.qml test suite """

# -*- Mode: Python; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-

"""Ubuntu Touch App autopilot tests."""

from os import remove
import os.path
from tempfile import mktemp
import subprocess

from autopilot.input import Mouse, Touch, Pointer
from autopilot.matchers import Eventually
from autopilot.platform import model
from testtools.matchers import Is, Not, Equals
from autopilot.testcase import AutopilotTestCase

from saucybacon import emulators

from ubuntuuitoolkit import emulators as toolkit_emulators

def get_module_include_path():
    return os.path.abspath(
        os.path.join(
            os.path.dirname(__file__),
            '..',
            '..',
            '..',
            '..',
            '..',
            'build',
            'backend'
            )
        )
        
def get_qml_location():
    return os.path.abspath(
        os.path.join(
            os.path.dirname(__file__),
            '..',
            '..',
            '..',
            '..',
            '..',
            'app'
            )
        )


class SaucyBaconTestCase(AutopilotTestCase):
    """A common test case class that provides several useful methods for the tests."""

    if model() == 'Desktop':
        scenarios = [
        ('with mouse', dict(input_device_class=Mouse))
        ]
    else:
        scenarios = [
        ('with touch', dict(input_device_class=Touch))
        ]
    
    local_location = get_qml_location() + "/saucybacon.qml"

    @property
    def main_window(self):
        return MainWindow(self.app)

    def setUp(self):
        self.pointing_device = Pointer(self.input_device_class.create())
        super(SaucyBaconTestCase, self).setUp()
        
        print self.local_location
        print get_module_include_path()
        if os.path.exists(self.local_location):
            self.launch_test_local()
        elif os.path.exists('/usr/share/saucybacon/app/saucybacon.qml'):
            self.launch_test_installed()
        else:
            self.launch_test_click()

    def launch_test_local(self):
        self.app = self.launch_test_application(
            "qmlscene",
            self.local_location,
            "-I",
            get_module_include_path(),
            app_type='qt',
            emulator_base=toolkit_emulators.UbuntuUIToolkitEmulatorBase)

    def launch_test_installed(self):
        self.app = self.launch_test_application(
            "qmlscene",
            "/usr/share/postino/postino.qml",
            "--desktop_file_hint=/usr/share/applications/saucybacon.desktop",
            app_type='qt',
            emulator_base=toolkit_emulators.UbuntuUIToolkitEmulatorBase)

    def launch_test_click(self):
        self.app = self.launch_click_package(
            'com.ubuntu.developers.gcollura.saucybacon',
            emulator_base=toolkit_emulators.UbuntuUIToolkitEmulatorBase)


    def get_qml_view(self):
        """Get the main QML view"""

        return self.app.select_single("QQuickView")

    def get_mainview(self):
        """Get the QML MainView"""

        mainView = self.app.select_single("MainView")
        self.assertThat(mainView, Not(Is(None)))
        return mainView


    def get_object(self,objectName):
        """Get a object based on the objectName"""

        obj = self.app.select_single(objectName=objectName)
        self.assertThat(obj, Not(Is(None)))
        return obj


    def mouse_click(self,objectName):
        """Move mouse on top of the object and click on it"""

        obj = self.get_object(objectName)
        self.pointing_device.move_to_object(obj)
        self.pointing_device.click()


    def mouse_press(self,objectName):
        """Move mouse on top of the object and press mouse button (without releasing it)"""

        obj = self.get_object(objectName)
        self.pointing_device.move_to_object(obj)
        self.pointing_device.press()


    def mouse_release(self):
        """Release mouse button"""

        self.pointing_device.release()     


    def type_string(self, string):
        """Type a string with keyboard"""

        self.keyboard.type(string)


    def type_key(self, key):
        """Type a single key with keyboard"""

        self.keyboard.key(key)
        
    @property
    def main_view(self):
        return self.app.select_single(emulators.MainView)
