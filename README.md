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
 * Some recipe sites aren't supported yet and they aren't properly managed.
 * Retrieving contents from website is done using stupid regex, because I couldn't get a proper XML/HTML tool to work,
   if you have suggestion to improve this aspect, please open an issue.

## License
GPLv3 - See `LICENSE` for more information.
