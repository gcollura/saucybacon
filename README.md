# SaucyBacon

Write recipes and save them online with the UbuntuOne sync feature.

## Requirements
 * Ubuntu SDK
 * U1db - qtdeclarative5-u1db1.0

## Testing
The c++ plugin needs to be compiled before launching `saucybacon`. In the root directory of the project,
run the following shell commands:
```
$ mkdir build && cd build
$ cmake ..
$ make
$ cp modules/libSaucyBaconPlugin.so ../modules/SaucyBacon
```
Then to run SaucyBacon:
```
$ cd -
$ qmlscene -I modules app/saucybacon.qml
```

# License
GPLv3 - See `LICENSE` for more information.
