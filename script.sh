#!/bin/bash
set -e

# ⚙️ 설정값
WORKSPACE="Yaml.xcworkspace"          # 워크스페이스 파일명
SCHEME="Yaml OSX"                           # 빌드할 Scheme 이름
FRAMEWORK_NAME="Yaml"                   # 프레임워크 이름
OUTPUT_DIR="./build"                         # 임시 빌드 아카이브 폴더
XCFRAMEWORK_OUTPUT="./${FRAMEWORK_NAME}.xcframework"

# 🔄 이전 결과 삭제
rm -rf "$OUTPUT_DIR"
rm -rf "$XCFRAMEWORK_OUTPUT"

# 📦 iOS (Device)
xcodebuild archive \
  -workspace "$WORKSPACE" \
  -scheme "$SCHEME" \
  -sdk iphoneos \
  -archivePath "$OUTPUT_DIR/ios_devices" \
  SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# 📦 iOS (Simulator)
xcodebuild archive \
  -workspace "$WORKSPACE" \
  -scheme "$SCHEME" \
  -sdk iphonesimulator \
  -archivePath "$OUTPUT_DIR/ios_sim" \
  SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# 📦 macOS (필요하다면)
xcodebuild archive \
  -workspace "$WORKSPACE" \
  -scheme "$SCHEME" \
  -sdk macosx \
  -archivePath "$OUTPUT_DIR/macos" \
  SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# 🏗️ XCFramework 생성
xcodebuild -create-xcframework \
  -framework "$OUTPUT_DIR/ios_devices.xcarchive/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework" \
  -framework "$OUTPUT_DIR/ios_sim.xcarchive/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework" \
  -framework "$OUTPUT_DIR/macos.xcarchive/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework" \
  -output "$XCFRAMEWORK_OUTPUT"

echo "✅ XCFramework 생성 완료: $XCFRAMEWORK_OUTPUT"
