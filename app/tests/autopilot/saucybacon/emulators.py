# -*- Mode: Python; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-
# Copyright 2015 Giulio Collura
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 3, as published
# by the Free Software Foundation.

"""SaucyBacon autopilot emulators."""

import logging
from time import sleep

from autopilot import logging as autopilot_logging
from ubuntuuitoolkit import emulators as toolkit_emulators

logger = logging.getLogger(__name__)

class MainView(toolkit_emulators.MainView):

    """An emulator class that makes it easy to interact with the
    music-app.
    """
    retry_delay = 0.2
    @autopilot_logging.log_action(logger.info)
    def open_search_page(self):
        """Open the Search tab.

        :return: the Search page.

        """
        self.switch_to_tab('searchTab')
        return self.wait_select_single(SearchPage)


class Page(toolkit_emulators.UbuntuUIToolkitEmulatorBase):
    """Autopilot helper for Pages."""

    def __init__(self, *args):
        super(Page, self).__init__(*args)
        self.main_view = self.get_root_instance().select_single(MainView)

class SearchPage(Page):
    """Autopilot helper for Search Page."""

    def get_search_field(self):
        """Return the search entry"""
        return self.wait_select_single('TextField', objectName='searchField')

    def get_search_button(self):
        """Return the search button"""
        return self.select_single('Button', objectName='searchButton')

    def get_num_of_results(self):
        return int(self._get_search_list().count)

    def _get_search_list(self):
        return self.wait_select_single(
            toolkit_emulators.QQuickListView,  objectName='resultList')
