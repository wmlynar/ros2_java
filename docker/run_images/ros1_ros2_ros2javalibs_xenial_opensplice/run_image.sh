#!/bin/sh

docker run -u "$UID" -v "$(pwd):/work" -w "/work" -it ros1_ros2_ros2javalibs_opensplice
