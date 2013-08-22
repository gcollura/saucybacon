# SaucyBacon

Write recipes and save them online with the UbuntuOne sync feature.

## Requirements
 * Ubuntu SDK
 * U1db - qtdeclarative5-u1db1.0
 * Qt5 development packages

## Testing
The c++ plugin needs to be compiled before launching `saucybacon`. In the root directory of the project,
run the following shell commands:
```
$ mkdir build && cd build
$ cmake ..
$ make
```
If you get some strange/error/warning output here, contact me on IRC or open an issue.

Then to run SaucyBacon:
```
$ cd -
$ qmlscene -I modules app/saucybacon.qml
```

***Known problems***
 * If your default compiler is clang, you have to switch back to gcc. Clang seems to be not supported at the moment.

## License
GPLv3 - See `LICENSE` for more information.
