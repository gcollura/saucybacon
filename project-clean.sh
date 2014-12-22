#!/bin/sh

set -x
find . -name CMakeCache.txt -exec rm "{}" \;
find . -name cmake_install.cmake -exec rm "{}" \;
find . -name "moc*" -exec rm "{}" \;
find . -name "*automoc*" -exec rm "{}" \;
find . -name Makefile -exec rm "{}" \;
find . -type d -name CMakeFiles -exec rm -r "{}" \;
find . -name install_manifest.txt -exec rm "{}" \;
rm resources/saucybacon.desktop
rm -r backend/SaucyBacon
rm manifest.json
set +x
