#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm   \
    freepats-general-midi \
    libdecor              \
    sdl2                  \
    SDL2_mixer            \
    SDL2_ttf              \
    SDL2_image            \
    SDL2_gfx              \
    timidity++

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

# If the application needs to be manually built that has to be done down here
echo "Making nightly build of OpenClaw..."
echo "---------------------------------------------------------------"
REPO="https://github.com/pjasicek/OpenClaw"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone --recursive --depth 1 "$REPO" ./OpenClaw
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cd ./OpenClaw
mkdir -p build && cd build
cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5
make -j$(nproc)
cd ../Build_Release
mv -v openclaw ../AppDir/bin
mv -v SAVES.XML ../AppDir/bin
mv -v clacon.ttf ../AppDir/bin
mv -v config.xml ../AppDir/bin
mv -v console02.tga ../AppDir/bin
