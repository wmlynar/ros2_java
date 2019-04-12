#!/bin/sh

cd ros1_ros2_ros2javalibs_xenial
./build_image.sh $@
cd ..

cd ros1_ros2_ros2javalibs_xenial_opensplice
./build_image.sh $@
cd ..
