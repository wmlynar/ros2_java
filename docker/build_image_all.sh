#!/bin/sh

cd build_images
./build_image.sh $@
cd ..

cd run_images
./build_image.sh $@
cd ..
