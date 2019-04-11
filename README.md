ROS2 for Java
=============

Introduction
------------

This fork maintains esteve/ros2_java to work with the latest packages from ros2. Please go to https://github.com/esteve/ros2_java , https://github.com/esteve/ros2_java_examples and https://github.com/esteve/ros2_java_docker for more information on ros2_java.

Choosing the right Ubuntu distribution
--------------------------------------

Ros2_java uses JNI to access ros2. So it needs libraries that are built for specific operating system. You also need to choose if you want to include 3rd party DDS implementations, like OpenSplice. At this moment the free implementation FastRTPS contains few unfixed bugs in Ubuntu melodic () so you can use OpenSplice until those problems are resolved. Please set one of the following exports

```
export DISTRO=xenial
export DISTRO=xenial_opensplice
export DISTRO=bionic
export DISTRO=bionic_opensplice
```

1. Install ros2_java binaries
-----------------------------

Following script will install ros2, ros2_java libraries into /opt/ros2_java/lib, ros2_launch tool into /opt/ros2_java/bin and it will export environment variables like LD_LIBRATY_PATH and ROS2_LAUNCH_PATH.

````
wget https://raw.githubusercontent.com/wmlynar/ros2_java/master/scripts/install/install_ros1_ros2_ros2javalibs_${DISTRO}.sh
chmod +x install_ros1_ros2_ros2javalibs_${DISTRO}.sh
./install_ros1_ros2_ros2javalibs_${DISTRO}.sh
````

After executing the script update the ROS2_LAUNCH_PATH environment variable in your .bashrc to the folder with your ros2_java projects.

2. Build ros2_java from sources
-------------------------------

Following script will build and install ros2_java libraries into /opt/ros2_java/lib

````
wget https://raw.githubusercontent.com/wmlynar/ros2_java/master/scripts/build_local/build_ros2_java_${DISTRO}.sh
chmod +x build_ros2_java_${DISTRO}.sh
./build_ros2_java_${DISTRO}.sh
````
After executing the script update the ROS2_LAUNCH_PATH environment variable in your .bashrc to the folder with your ros2_java projects.

3. Update ros2_java maven repository
------------------------------------

Build ros2_java binaries for all the platforms using docker

```
git clone https://github.com/wmlynar/ros2_java
cd ros2_java/docker/build_images
./build_image_all.sh --no-cache
cd ../../..
```
Update maven repository with jars and zip files with libraries for all the platforms

```
git clone https://github.com/wmlynar/ros2_java_maven_repo
cd ros2_java_maven_repo
./build_all.sh
```

Push the repository to github

```
git add *
git commit --amend
git push -f origin master
```

4. Using rqt_console with ros1_ros2_bridge
------------------------------------------

Until the issue https://github.com/ros2/ros1_bridge/issues/159 is resolved you cannot use logging when using ros1_ros2_bridge. Until then ros2_java will publish
on topic /rosout2 and you need to edit rqt_console to listen to /rosout2 topic.

Please edit file
```
~/ros2_install/ros2-linux/lib/python3.6/site-packages/rqt_console/console.py
```
and replace the line /rosout_agg with /rosout2
```
        self._topic = '/rosout2'
```
