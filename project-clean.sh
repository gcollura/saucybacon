#!/bin/sh

set -x
find . -name CMakeCache.txt -exec rm -r "{}" \;
find . -name cmake_install.cmake -exec rm -r "{}" \;
find . -name "moc*" -exec rm -r "{}" \;
find . -name Makefile -exec rm -r "{}" \;
find . -type d -name CMakeFiles -exec rm -r "{}" \;
rm app/saucybacon.desktop
rm install_manifest.txt
set +x
