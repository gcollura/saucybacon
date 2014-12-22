#!/bin/sh

set -x
find . -name CMakeCache.txt -exec rm "{}" \;
find . -name cmake_install.cmake -exec rm "{}" \;
find . -name "moc*" -exec rm "{}" \;
find . -name "*automoc*" -exec rm "{}" \;
find . -name Makefile -exec rm "{}" \;
find . -type d -name CMakeFiles -exec rm -r "{}" \;
rm resources/saucybacon.desktop
rm install_manifest.txt
rm -r backend/SaucyBacon
set +x
