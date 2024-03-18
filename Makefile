MACOS_ARCH ?= `uname -m`
MACOS_SDK ?= `xcode-select -p`/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk

ASEPRITE_VERSION ?= 1.3.5
ASEPRITE_DEP ?= https://github.com/aseprite/aseprite/releases/download/v${ASEPRITE_VERSION}/Aseprite-v${ASEPRITE_VERSION}-Source.zip
ASEPRITE_DEP_PATH = aseprite-v${ASEPRITE_VERSION}

SKIA_ARCH := arm64
ifeq (${MACOS_ARCH}, x86_64)
SKIA_ARCH = x64
endif

SKIA_DEP ?= https://github.com/aseprite/skia/releases/download/m102-861e4743af/Skia-macOS-Release-$(SKIA_ARCH).zip
SKIA_DEP_PATH = Skia-macOS-Release-$(SKIA_ARCH)

BASE_PATH = `pwd`

all: download configure assemble install start

download:
	@mkdir -p deps

	@wget -c ${SKIA_DEP} -O deps/$(SKIA_DEP_PATH).zip
	@wget -c ${ASEPRITE_DEP} -O deps/$(ASEPRITE_DEP_PATH).zip

configure:
	@unzip -o deps/$(SKIA_DEP_PATH).zip -d deps/$(SKIA_DEP_PATH)
	@unzip -o deps/$(ASEPRITE_DEP_PATH).zip -d deps/$(ASEPRITE_DEP_PATH)

	@gsed -i "s/${ASEPRITE_VERSION}-dev/${ASEPRITE_VERSION}/g" ${BASE_PATH}/deps/$(ASEPRITE_DEP_PATH)/src/ver/CMakeLists.txt

assemble:
	@rm -rf ${BASE_PATH}/build
	@mkdir -p build

	@cmake \
		-DCMAKE_BUILD_TYPE=RelWithDebInfo \
		-DCMAKE_OSX_ARCHITECTURES=$(MACOS_ARCH) \
		-DCMAKE_OSX_DEPLOYMENT_TARGET=11.0 \
		-DCMAKE_OSX_SYSROOT=${MACOS_SDK} \
		-DLAF_BACKEND=skia \
		-DSKIA_DIR=${BASE_PATH}/deps/$(SKIA_DEP_PATH) \
		-DSKIA_LIBRARY_DIR=${BASE_PATH}/deps/$(SKIA_DEP_PATH)/out/Release-$(SKIA_ARCH) \
		-DSKIA_LIBRARY=${BASE_PATH}/deps/$(SKIA_DEP_PATH)/out/Release-$(SKIA_ARCH)/libskia.a \
		-DPNG_ARM_NEON:STRING=on \
		-G Ninja \
		-B ${BASE_PATH}/build/ \
		${BASE_PATH}/deps/$(ASEPRITE_DEP_PATH)

	@ninja -C ${BASE_PATH}/build/ aseprite

install:
	@rm -rf ${BASE_PATH}/Aseprite.app.tmpl/bin
	@cp -rf ${BASE_PATH}/build/bin ${BASE_PATH}/Aseprite.app.tmpl/bin
	@rm -rf ${HOME}/Applications/Aseprite.app
	@cp -rf ${BASE_PATH}/Aseprite.app.tmpl ${HOME}/Applications/Aseprite.app

uninstall:
	@rm -rf ${HOME}/Applications/Aseprite.app

start:
	open ${HOME}/Applications/Aseprite.app

clear:
	@rm -rf deps
	@rm -rf build
	@rm -rf ${BASE_PATH}/Aseprite.app.tmpl/bin

info:
	@echo \
		\\n \
		HOME=${HOME} \\n \
		BASE_PATH=${BASE_PATH} \\n \
		\\n \
		MACOS_ARCH=${MACOS_ARCH} \\n \
		MACOS_SDK=${MACOS_SDK} \\n \
		\\n \
		SKIA_DEP=${SKIA_DEP} \\n \
		\\n \
		ASEPRITE_VERSION=${ASEPRITE_VERSION} \\n \
		ASEPRITE_DEP=${ASEPRITE_DEP} \\n \
