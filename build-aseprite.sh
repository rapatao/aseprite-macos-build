#!/usr/bin/env bash

ASEPRITE_VERSION=1.3.1
ASEPRITE_DEP=https://github.com/aseprite/aseprite/releases/download/v${ASEPRITE_VERSION}/Aseprite-v${ASEPRITE_VERSION}-Source.zip

MACOS_SDK=`xcode-select -p`/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk

BASE_PATH=`pwd`
SKIA_DEP=https://github.com/aseprite/skia/releases/download/m102-861e4743af/Skia-macOS-Release-arm64.zip
MACOS_ARCH=arm64

# cleanup
rm -rf Aseprite.app.tmpl/bin
rm -rf build;

# prepare path
mkdir -p deps;
mkdir -p build;

# download aseprite sources
wget -c ${ASEPRITE_DEP} \
  -O deps/aseprite-v${ASEPRITE_VERSION}.zip
unzip -o deps/aseprite-v${ASEPRITE_VERSION}.zip -d deps/aseprite-v${ASEPRITE_VERSION}

# download skia build
wget -c ${SKIA_DEP} -O deps/skia.zip
unzip -o deps/skia.zip -d deps/skia

# replace dev version
gsed -i "s/${ASEPRITE_VERSION}-dev/${ASEPRITE_VERSION}/g" ${BASE_PATH}/deps/aseprite-v${ASEPRITE_VERSION}/src/ver/CMakeLists.txt

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
  ${BASE_PATH}/deps/aseprite-v${ASEPRITE_VERSION}

ninja -C ${BASE_PATH}/build/ aseprite

# copy build artfacts to macos app template
cp -rf ${BASE_PATH}/build/bin ${BASE_PATH}/Aseprite.app.tmpl/bin

# remove old installation
rm -rf ${HOME}/Applications/Aseprite.app

# copy macos app to user applications path
cp -rf ${BASE_PATH}/Aseprite.app.tmpl ${HOME}/Applications/Aseprite.app
