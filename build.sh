#!/bin/bash
set -e

BOARD="nice_nano_v2"
LEFT_SHIELD="corne_left"
RIGHT_SHIELD="corne_right"

build_half() {
  local shield=$1
  echo "Building $shield..."

  docker run --rm \
    -v zmk-cache:/zmk \
    -v $(pwd):/zmk-config \
    zmkfirmware/zmk-build-arm:stable \
    bash -c "cd /zmk && west build -s app -b $BOARD -- \
      -DSHIELD=$shield \
      -DZMK_CONFIG=/zmk-config/config"

  docker run --rm \
    -v zmk-cache:/zmk \
    -v $(pwd):/zmk-config \
    zmkfirmware/zmk-build-arm:stable \
    cp /zmk/build/zephyr/zmk.uf2 /zmk-config/$shield.uf2

  echo "Saved to $shield.uf2"
}

build_half $LEFT_SHIELD
build_half $RIGHT_SHIELD

echo "All done! Flash corne_left.uf2 to the left half, corne_right.uf2 to the right."
