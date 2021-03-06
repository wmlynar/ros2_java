ROS2 for Java
=============

Introduction
------------

This is the instruction how to build esteve/ros2_java with the latest packages from ros2. Please go to https://github.com/esteve/ros2_java , https://github.com/esteve/ros2_java_examples and https://github.com/esteve/ros2_java_docker for more information on ros2_java.

This instrction is prepared for Ubuntu Xenial 16.04. In case you want to build for another version of ubuntu please adapt step 3 according to docker files from https://github.com/esteve/ros2_java_docker that are meant for your distribution.

WORK IN PROGRESS

TLDR
----

You can install ros2_java with the following script (the script collects all the steps from below)

```
wget https://raw.githubusercontent.com/wmlynar/ros2_java/master/install_ros2_java.sh
chmod +x install_ros2_java.sh
./install_ros2_java.sh
```

Step 0. Prequisities
--------------------

Make sure that you run the build command in a fresh environment. You may want to make sure that you do not have source /opt/ros/${ROS_DISTRO}/setup.bash in your .bashrc.

Step 1. Setup locale
--------------------------------

This step is based on https://index.ros.org/doc/ros2/Installation/Linux-Development-Setup/

```
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
echo "export LANG=en_US.UTF-8" >> ~/.bashrc
source ~/.bashrc
```

Step 2. Install ROS2 dependencies
--------------------------------

This step is based on https://index.ros.org/doc/ros2/Installation/Linux-Development-Setup/

```
sudo apt update && sudo apt install -y \
  build-essential \
  cmake \
  git \
  python3-colcon-common-extensions \
  python3-pip \
  python-rosdep \
  python3-vcstool \
  wget
# install some pip packages needed for testing
python3 -m pip install -U \
  argcomplete \
  flake8 \
  flake8-blind-except \
  flake8-builtins \
  flake8-class-newline \
  flake8-comprehensions \
  flake8-deprecated \
  flake8-docstrings \
  flake8-import-order \
  flake8-quotes \
  git+https://github.com/lark-parser/lark.git@0.7d \
  pytest-repeat \
  pytest-rerunfailures \
  pytest \
  pytest-cov \
  pytest-runner \
  setuptools
# install Fast-RTPS dependencies
sudo apt install --no-install-recommends -y \
  libasio-dev \
  libtinyxml2-dev
```

Step 3. Install ros2_java dependencies
--------------------------------------

This step is based on https://github.com/esteve/ros2_java_docker/blob/master/xenial/java/Dockerfile

```
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
    locales
sudo apt-get install -y --no-install-recommends \
    apt-transport-https \
    dirmngr \
    gnupg-agent \
    lsb-release \
    software-properties-common \
    tzdata
echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/ros-latest.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 421C365BD9FF1F717815A3895523BAEEB01FA116
echo "deb http://packages.osrfoundation.org/gazebo/ubuntu $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-latest.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys D2486D2DD83DB69272AFE98867170598AF249743
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    cppcheck \
    git \
    python-empy \
    python3-catkin-pkg-modules \
    python3-dev \
    python3-empy \
    python3-nose \
    python3-pip \
    python3-pyparsing \
    python3-setuptools \
    python3-vcstool \
    wget
sudo pip3 install \
    argcomplete
# additional testing dependencies from pip (because not available on ubuntu 16.04)
sudo pip3 install \
    flake8 \
    flake8-blind-except \
    flake8-builtins \
    flake8-class-newline \
    flake8-comprehensions \
    flake8-deprecated \
    flake8-docstrings \
    flake8-import-order \
    flake8-quotes \
    pytest \
    pytest-cov \
    pytest-runner
sudo apt-get install -y --no-install-recommends \
    python3-colcon-common-extensions
sudo add-apt-repository -y ppa:cwchien/gradle
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
    gradle \
    openjdk-8-jdk-headless
mkdir -p ~/.gradle
echo org.gradle.daemon=true | tee ~/.gradle/gradle.properties
echo org.gradle.jvmargs=-Xmx2048M | tee -a ~/.gradle/gradle.properties
echo "buildscript { repositories { jcenter() }; dependencies { classpath 'com.android.tools.build:gradle:2.2.0+' } }" | tee /tmp/dummy.gradle
gradle -b /tmp/dummy.gradle

echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> ~/.bashrc
echo "export PATH=\$PATH:\${JAVA_HOME}/bin:\${JAVA_HOME}/jre/bin" >> ~/.bashrc
source ~/.bashrc

sudo apt-get update
sudo apt-get install -y --no-install-recommends \
    libopencv-dev \
    libpcre3-dev
sudo apt-get install -y --no-install-recommends \
    libasio-dev \
    libtinyxml2-dev \
    openjdk-8-jdk
# dependencies for testing
sudo apt-get install -y --no-install-recommends \
    clang-format \
    pydocstyle \
    pyflakes \
    python3-coverage \
    python3-mock \
    python3-pep8 \
    uncrustify
```

And some additional dependencies

```
sudo apt-get -y install liblog4cxx-dev
```

Step 4. Downgrade gradle to version 3.5
---------------------------------------

WARNING: This will change ownership of /opt to current user!

```
sudo chown -R $(id -u):$(id -g) /opt
wget https://services.gradle.org/distributions/gradle-3.5-bin.zip
mkdir -p /opt/gradle
unzip -d /opt/gradle gradle-3.5-bin.zip
echo "export PATH=/opt/gradle/gradle-3.5/bin:\${PATH}" >> ~/.bashrc
source ~/.bashrc
```

Step 5. Build ament with plugin for ros2_java
---------------------------------------------

This step is based on https://github.com/esteve/ros2_java

```
mkdir -p ament_ws/src
cd ament_ws
wget https://raw.githubusercontent.com/esteve/ament_java/master/ament_java.repos
vcs import src < ament_java.repos
src/ament/ament_tools/scripts/ament.py build --symlink-install --isolated
cd ..
```

Step 6. Download ROS2 code
------------------------------------------------------------

This step is based on https://index.ros.org/doc/ros2/Installation/Linux-Development-Setup/

```
mkdir -p ros2_java_ws/src
cd ros2_java_ws
wget https://raw.githubusercontent.com/ros2/ros2/release-latest/ros2.repos
vcs import src < ros2.repos
```

Step 7. Install dependencies using rosdep
-----------------------------------------

This step is based on https://index.ros.org/doc/ros2/Installation/Linux-Development-Setup/

```
sudo rosdep init
rosdep update
# [Ubuntu 16.04]
rosdep install --from-paths src --ignore-src --rosdistro crystal -y --skip-keys "console_bridge fastcdr fastrtps libopensplice67 libopensplice69 python3-lark-parser rti-connext-dds-5.3.1 urdfdom_headers"
```

Step 8. Remove unnecessary packages
-----------------------------------------

```
# remove unneccesary packages
rm -rf src/ros2/ament
rm -rf src/ros2/demos
rm -rf src/ros2/examples
rm -rf src/ros2/rmw_connext
rm -rf src/ros2/rmw_opensplice
rm -rf src/ros2/rosidl_typesupport_connext
rm -rf src/ros2/rosidl_typesupport_opensplice
rm -rf src/ros2/rviz
rm -rf src/ros-visualization

# remove package with ament compilation problem
rm -rf src/ros2/ros2cli/ros2multicast
```

Step 9. Remove the Fibonacci.action compilation error (apparently ros2_java does not support actions)
------------------------------------------------------

```
# package ros2/example_interfaces
perl -i -pe 'BEGIN{undef $/;} s/find_package\(action_msgs REQUIRED\)//smg' src/ros2/example_interfaces/CMakeLists.txt
perl -i -pe 'BEGIN{undef $/;} s/\"action\/Fibonacci\.action\"//smg' src/ros2/example_interfaces/CMakeLists.txt
perl -i -pe 'BEGIN{undef $/;} s/DEPENDENCIES action_msgs//smg' src/ros2/example_interfaces/CMakeLists.txt

# package ros2/rcl_interfaces/test_msgs
perl -i -pe 'BEGIN{undef $/;} s/find_package\(action_msgs REQUIRED\)//smg' src/ros2/rcl_interfaces/test_msgs/CMakeLists.txt
perl -i -pe 'BEGIN{undef $/;} s/set\(action_files[^\)]*\)//smg' src/ros2/rcl_interfaces/test_msgs/CMakeLists.txt
perl -i -pe 'BEGIN{undef $/;} s/builtin_interfaces action_msgs unique_identifier_msgs/builtin_interfaces unique_identifier_msgs/smg' src/ros2/rcl_interfaces/test_msgs/CMakeLists.txt
```

Step 10. Download ros2_java code
-------------------------------

This step is based on https://github.com/esteve/ros2_java

```
wget https://raw.githubusercontent.com/wmlynar/ros2_java/master/ros2_java.repos
vcs import src < ros2_java.repos
```

Step 11. Build ros2_java
-----------------------

You can add `--parallel` option for faster builds but that requires more ram

```
. ../ament_ws/install_isolated/local_setup.sh
ament build --symlink-install --isolated
```

Congratulations your build is ready!

Run some examples
-----------------

Now you can run examples to verify that your build is correct. This step is based on https://github.com/esteve/ros2_java_examples

Subscriber:

```
. ~/ament_ws/install_isolated/local_setup.sh
. ~/ros2_java_ws/install_isolated/local_setup.sh
ros2 run rcljava_examples subscriber_lambda
```

Publisher:

```
. ~/ament_ws/install_isolated/local_setup.sh
. ~/ros2_java_ws/install_isolated/local_setup.sh
ros2 run rcljava_examples publisher_lambda
```

Display messages with ros2 command:

```
ros2 topic echo /topic
```



