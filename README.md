ROS2 for Java
=============

Introduction
------------

In this fork I am maintaining esteve/ros2_java to work with the latest packages from ros2. Please go to https://github.com/esteve/ros2_java , https://github.com/esteve/ros2_java_examples and https://github.com/esteve/ros2_java_docker for more information on ros2_java.

Choosing the right Ubuntu distribution
--------------------------------------

Ros2_java uses JNI to access ros2 so it needs libraries that are build for appropriate operating system. You also need to choose if you want to include 3rd party DDS implementations, like OpenSplice. At this moment the free implementation FastRTPS contains few unfixed bugs on Ubuntu melodic () so I recommend to use OpenSplice until those problems are resolved. Please use one of the following exports

```
export DISTRO=xenial
export DISTRO=xenial_opensplice
export DISTRO=bionic
export DISTRO=bionic_opensplice
```

1. Install ros2_java binaries build by me
-----------------------------------------

The simplest way to work with ros2_java is to install binaries that were prebuild by me. The easiest way to install it is to use following scritpt. The script will install ros2, ros2_java libraries into /opt/ros2_java/lib, ros2_launch tool into /opt/ros2_java/bin and it will export environment variables like LD_LIBRATY_PATH and ROS2_LAUNCH_PATH.

````
wget https://raw.githubusercontent.com/wmlynar/ros2_java/master/scripts/install/install_ros1_ros2_ros2javalibs_${DISTRO}.sh
chmod +x install_ros1_ros2_ros2javalibs_${DISTRO}.sh
./install_ros1_ros2_ros2javalibs_${DISTRO}.sh
````

Please update the ROS2_LAUNCH_PATH environment variable in your .bashrc to the folder with your ros2_java projects.

2. Build ros2_java from sources by yourself
-------------------------------------------

You can use following script to build ros2_java on your computer. The script will build and install ros2_java libraries into /opt/ros2_java/lib

````
wget https://raw.githubusercontent.com/wmlynar/ros2_java/master/scripts/build_local/build_ros2_java_${DISTRO}.sh
chmod +x build_ros2_java_${DISTRO}.sh
./build_ros2_java_${DISTRO}.sh
````

3. Build ros2_java binaries for all the platforms using docker
--------------------------------------------------------------


1. Build docker images


```
git clone https://github.com/wmlynar/ros2_java
cd ros2_java/docker/build_images
./build_image_all.sh
```

2. Build ros2_java libraries



3. Build ros2_java jars


WORK_IN_PROGRESS
