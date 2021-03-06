#!/usr/bin/env bash

WD=$(dirname pwd)
BASEDIR=$(dirname "$0")
cd ${BASEDIR}

#export NDK=/usr/lib/android-ndk/
export NDK=$HOME/Library/Android/sdk/ndk-bundle/

if [ ! -z ${NDK+x} ]; then
    echo "Environment variable NDK is unset; please specify, e.g., 'export NDK=\$HOME/Library/Android/sdk/ndk-bundle/'";
fi

rm -fr out arm arm64 x86 x86_64 android-toolchain-**

echo "Building in $BASEDIR"

if [ ! -d "$BASEDIR/build/gyp" ]; then
  # Control will enter here if $D
  echo "  * directory ./build/gyp does not exist, cloning."
  git clone https://chromium.googlesource.com/external/gyp $BASEDIR/build/gyp
fi

chmod +x ./gyp_uv.py
chmod -R +x ./build/gyp

echo "  * set execute permissions"

echo "Using NDK=$NDK"
source android-configure-arm ${NDK} gyp 23
BUILDTYPE=Release make -C out
mv -f out arm


source android-configure-arm64 ${NDK} gyp 23
BUILDTYPE=Release make -C out
mv -f out arm64

source android-configure-x86 ${NDK} gyp 23
BUILDTYPE=Release make -C out
mv -f out x86

source android-configure-x86_64 ${NDK} gyp 23
BUILDTYPE=Release make -C out
mv -f out x86_64

cd ${WD}

