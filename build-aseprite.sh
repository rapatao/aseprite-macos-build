#!/usr/bin/env bash

ASEPRITE_VERSION=1.2.40
ASEPRITE_BRANCH="v${ASEPRITE_VERSION}"

MACOS_SDK=`xcode-select -p`/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk

BASE_PATH=`pwd`
SKIA_DEP=https://github.com/aseprite/skia/releases/download/m102-861e4743af/Skia-macOS-Release-arm64.zip
MACOS_ARCH=arm64

# cleanup
rm -rf Aseprite.app/bin
rm -rf build;
rm -rf deps;

# prepare path
mkdir -p deps;
mkdir -p build;

# clone aseprite
git clone --branch ${ASEPRITE_BRANCH} --depth 1 --recursive git@github.com:aseprite/aseprite.git deps/aseprite

# download skia
wget -c ${SKIA_DEP} -O deps/skia.zip
unzip -o deps/skia.zip -d deps/skia

gsed -i "s/1.x-dev/${ASEPRITE_VERSION}/g" ${BASE_PATH}/deps/aseprite/src/ver/CMakeLists.txt

# building
cmake \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DCMAKE_OSX_ARCHITECTURES=${MACOS_ARCH} \
  -DCMAKE_OSX_DEPLOYMENT_TARGET=11.0 \
  -DCMAKE_OSX_SYSROOT=${MACOS_SDK} \
  -DLAF_BACKEND=skia \
  -DSKIA_DIR=${BASE_PATH}/deps/skia \
  -DSKIA_LIBRARY_DIR=${BASE_PATH}/deps/skia/out/Release-arm64 \
  -DSKIA_LIBRARY=${BASE_PATH}/deps/skia/out/Release-arm64/libskia.a \
  -DPNG_ARM_NEON:STRING=on \
  -G Ninja \
  -B ${BASE_PATH}/build/ \
  ${BASE_PATH}/deps/aseprite

ninja -C ${BASE_PATH}/build/ aseprite

cp -rf ${BASE_PATH}/build/bin ${BASE_PATH}/Aseprite.app/bin

cp -rf ${BASE_PATH}/Aseprite.app ${HOME}/Applications/Aseprite.app
