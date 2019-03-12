#!/bin/sh

# checkout repositories
rm -rf *
git clone https://github.com/wmlynar/ros2_java_maven
git clone https://github.com/wmlynar/ros2_java_maven_example
git clone https://github.com/wmlynar/ros2_java_di
git clone https://github.com/wmlynar/ros2_java_di_example
git clone https://github.com/wmlynar/ros2_java_tf
git clone https://github.com/wmlynar/ros2_java_launch

#rm ros2_java_maven_repo/org/ros2/java/*

# build ros2_java
docker run -u "$UID" -v "$(pwd):/root/ros2_java_ws/src/ros2_java" -w "/root/ros2_java_ws" -t xenial_ros2_java sh -c ". ~/ament_ws/install_isolated/local_setup.sh && ament build --symlink-install --isolated --only-packages rcljava rcljava_examples && cd src/ros2_java/ros2_java_maven && mvn install && ./install.sh && cp -r ~/.m2/repository/org/ros2/java/* ../ros2_java_maven_repo/org/ros2/java/"

