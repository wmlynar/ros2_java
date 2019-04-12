#!/bin/sh
docker run --rm -v"$(pwd):/root/ros2_java_ws/src/ros2_java/ros2_java" -w "/root/ros2_java_ws" -it ros2_bionic_opensplice bash -c "\
        . ~/ament_ws/install_isolated/local_setup.sh &&\
        ament build --symlink-install --isolated --only-packages rcljava rcljava_common rcljava_examples &&\
        cd ~/ros2_java_ws/src/ros2_java/ros2_java \
	"
