#!/bin/sh

docker run -u "$UID" -v "$(pwd):/work" -w "/work" -it ros2_bionic_opensplice
