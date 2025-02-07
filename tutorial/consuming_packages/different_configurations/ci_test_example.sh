#!/bin/bash

set -e
set -x

BASEDIR=$(dirname "$0")
pushd "$BASEDIR"

rm -rf build

debug_enabled=0

if [ $debug_enabled -eq 1 ]; then
    echo "Debug mode enabled."
    conan install . --output-folder=build --build=missing --settings=build_type=Debug

else
    echo "Debug mode disabled."
    conan install . --output-folder=build --build=missing  -o *:shared=True

fi

cd build

if [ $debug_enabled -eq 1 ]; then
    cmake .. -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Debug

else
    cmake .. -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Release

fi

cmake --build .

./compressor
