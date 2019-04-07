#!/bin/sh

mkdir -p tmp
find ~/ros2_java_ws/build_isolated/ -name 'lib*.so*' -exec cp {} tmp/  \;
cd tmp
zip ../ros2_java_libs.zip *
cd ..
rm -rf tmp
