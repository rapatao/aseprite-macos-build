# Aseprite macOS build

Provides an automated script to create a release app of [Aseprite](https://github.com/aseprite/aseprite) for macOS. The script automatically downloads the Aseprite source code, an official pre-built `SKIA` dependency, and creates a macOS app in the users `Applications` folder.

Currently, set to build the version `1.2.40` for `arm64` macOS.

## Requirements

* XCode
* CMake
    ```shell
    brew install cmake
    ```

* Ninja
    ```shell
    brew install ninja
    ```

# Running

Clone the repository

```shell
```

Run the script:

```shell
./build-aseprite.sh
```
