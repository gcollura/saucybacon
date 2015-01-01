# SaucyBacon

Write recipes or find them online with the [Food2Fork](http://food2fork.com/) API.

## Features
 * Recipe management
 * Online recipe search with automatic download
 * Adaptive layout
 * Unity/HUD integration

## Requirements
 * Ubuntu SDK
 * Ubuntu Mobile Icons - ubuntu-mobile-icons
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
$ make run
```

To generate a new click package in project directory:
```
$ click-buddy --arch armhf --framework ubuntu-sdk-14.10
```

**Known problems**
 * Some websites aren't properly supported and thus their recipes can't be loaded.
 * Retrieving contents from website is done using per-website regex, because I couldn't get a proper XML/HTML tool to work,
   if you have suggestion to improve this aspect, please open an issue.

## License
GPLv3 - See `LICENSE` for more information.
