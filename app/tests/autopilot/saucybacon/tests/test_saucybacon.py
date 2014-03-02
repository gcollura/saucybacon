# -*- Mode: Python; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-

"""Tests for the Hello World"""

from __future__ import absolute_import
import os

from textwrap import dedent
from autopilot.matchers import Eventually
from testtools.matchers import Equals, Contains, NotEquals, Not, Is
from testtools import skip

from ubuntuuitoolkit import emulators as toolkit_emulators
from saucybacon.tests import SaucyBaconTestCase


class MainTests(SaucyBaconTestCase):
    """Generic tests for the Hello World"""
    
    def setUp(self):
        super(MainTests, self).setUp()
        self.assertThat(
            self.main_view.visible, Eventually(Equals(True)))

    def test_0_can_select_mainView(self):
        """Must be able to select the main window."""

        rootItem = self.main_view
        self.assertThat(rootItem, Not(Is(None)))
        self.assertThat(rootItem.visible, Eventually(Equals(True)))

    def test_searchTab(self):
        # switch to search tab
        self.page = self.main_view.open_search_page()

        # make sure we are in the right place
        tabName = lambda: self.main_view.select_single("Tab",
                objectName="searchTab")
        self.assertThat(tabName, Eventually(NotEquals(None)))

        # start a search
        toolbar = self.main_view.open_toolbar()
        toolbar.click_button("searchTopRatedAction")

        # check spinning circle
        spinning = lambda: self.main_view.select_single("ActivityIndicator",
                objectName="activityIndicator").running
        self.assertThat(spinning, Eventually(NotEquals(False)))

        self.assertThat(self.page.get_num_of_results(), Eventually(NotEquals(0)))

