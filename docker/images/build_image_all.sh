#!/bin/sh

cd bionic
./build_image.sh $@
cd ..

cd bionic_opensplice
./build_image.sh $@
cd ..

cd xenial
./build_image.sh $@
cd ..

cd xenial_opensplice
./build_image.sh $@
cd ..
