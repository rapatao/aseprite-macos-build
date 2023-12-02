# Aseprite macOS build

Provides an automated script to create a release app of [Aseprite](https://github.com/aseprite/aseprite) for macOS. The script automatically downloads the Aseprite source code, an official pre-built `SKIA` dependency, and creates a macOS app in the users `Applications` folder.

> It is possible to cutomize the building process, to change the Aseprite build version and other settings. See [more](#Build customization)

It is possible to define which Aseprite version should be installed, as well as a different SKIA release.

## Requirements

* XCode

* Make
    ````shell
    brew install make
    ``

* CMake
    ```shell
    brew install cmake
    ```

* Ninja
    ```shell
    brew install ninja
    ```

* GNU Sed
    ```shell
    brew install gnu-sed
    ```

* GNU Wget
    ```shell
    brew install wget
    ```

# Building

Clone the repository

```shell
git clone https://github.com/rapatao/aseprite-macos-build.git

cd aseprite-macos-build

make
```

# Build customization

* `ASEPRITE_VERSION`: defines the Aseprite version;
* `ASEPRITE_DEP`: Defines the URL that must be used to download the Aseprite release.
* `SKIA_DEP`: Defines the URL that must be used to download the SKIA release.
* `MACOS_ARCH`: Defines the macOS architecture. Uses by default the result of the command `uname -m`. Tested values: `arm64` and `x86_64`
* `MACOS_SDK`: Defines the custom path for the macOS SDK.

Ex.:
```shell
make ASEPRITE_VERSION=1.3.2 MACOS_ARCH=arm64
```
