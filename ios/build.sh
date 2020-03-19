#!/bin/sh

PROJECT_PATH=$(cd `dirname $0`; pwd)

# build path
UNIVERSAL_OUTPUT_FOLDER="${PROJECT_PATH}/Framework"
# build log
LOG_FILE="${UNIVERSAL_OUTPUT_FOLDER}/${TARGET_NAME}Build.log"

CONFIGURATION=Release
TARGET_NAME=GT

if [[ -d "${UNIVERSAL_OUTPUT_FOLDER}" ]]; then
	rm -rf "${UNIVERSAL_OUTPUT_FOLDER}"
fi
mkdir -p "${UNIVERSAL_OUTPUT_FOLDER}"

# iphonesimulator
xcodebuild -project "$PROJECT_PATH/GTKit.xcodeproj"  -scheme ${TARGET_NAME} -sdk iphonesimulator -configuration ${CONFIGURATION} ARCHS='x86_64' VALID_ARCHS='x86_64' BUILD_DIR=${UNIVERSAL_OUTPUT_FOLDER} clean build >>${LOG_FILE}

# iphoneos
xcodebuild -project "$PROJECT_PATH/GTKit.xcodeproj"  -scheme ${TARGET_NAME} -sdk iphoneos -configuration ${CONFIGURATION} ARCHS='armv7 arm64' VALID_ARCHS='armv7 arm64' BUILD_DIR=${UNIVERSAL_OUTPUT_FOLDER} clean build >>${LOG_FILE}

# copy iphoneos to merge path
cp -r "${UNIVERSAL_OUTPUT_FOLDER}/${CONFIGURATION}-iphoneos/${TARGET_NAME}.framework" "${UNIVERSAL_OUTPUT_FOLDER}/${TARGET_NAME}.framework"

# merge frameworks to merge path
lipo -create "${UNIVERSAL_OUTPUT_FOLDER}/${CONFIGURATION}-iphonesimulator/${TARGET_NAME}.framework/${TARGET_NAME}" "${UNIVERSAL_OUTPUT_FOLDER}/${CONFIGURATION}-iphoneos/${TARGET_NAME}.framework/${TARGET_NAME}" -output "${UNIVERSAL_OUTPUT_FOLDER}/${TARGET_NAME}.framework/${TARGET_NAME}"

# cleanup
rm -rf "${UNIVERSAL_OUTPUT_FOLDER}/${CONFIGURATION}-iphonesimulator" "${UNIVERSAL_OUTPUT_FOLDER}/${CONFIGURATION}-iphoneos"

cd ${UNIVERSAL_OUTPUT_FOLDER}/${TARGET_NAME}.framework

zip -r ${UNIVERSAL_OUTPUT_FOLDER}/${TARGET_NAME}.framework.zip *

cd ${UNIVERSAL_OUTPUT_FOLDER}

rm -rf ${UNIVERSAL_OUTPUT_FOLDER}/${TARGET_NAME}.framework
