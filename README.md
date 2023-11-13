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

* GNU Sed
    ```shell
    brew install gnu-sed
    ```

* GNU Wget
    ```shell
    brew install wget
    ```

# Running

Clone the repository

```shell
git clone https://github.com/rapatao/aseprite-macos-build.git
```

Run the script:

```shell
cd aseprite-macos-build
./build-aseprite.sh
```
