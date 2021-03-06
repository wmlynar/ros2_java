#!/bin/sh

# 1. setup locale

sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
echo "export LANG=en_US.UTF-8" >> ~/.bashrc
export LANG=en_US.UTF-8

# 2. instal dependencies

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
    openjdk-8-jdk
mkdir -p ~/.gradle
echo org.gradle.daemon=true | tee ~/.gradle/gradle.properties
echo org.gradle.jvmargs=-Xmx2048M | tee -a ~/.gradle/gradle.properties
echo "buildscript { repositories { jcenter() }; dependencies { classpath 'com.android.tools.build:gradle:2.2.0+' } }" | tee /tmp/dummy.gradle
gradle -b /tmp/dummy.gradle

echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> ~/.bashrc
echo "export PATH=\$PATH:\${JAVA_HOME}/bin:\${JAVA_HOME}/jre/bin" >> ~/.bashrc
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export PATH=$PATH:${JAVA_HOME}/bin:${JAVA_HOME}/jre/bin

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

sudo apt-get -y install liblog4cxx-dev
sudo apt-get -y install zip unzip
sudo pip3 install lxml

#install openslice dependencies
sudo apt -y install libopensplice69

# 3. compile ament with java support

mkdir -p ament_ws/src
cd ament_ws
wget https://raw.githubusercontent.com/esteve/ament_java/master/ament_java.repos
vcs import src < ament_java.repos
src/ament/ament_tools/scripts/ament.py build --symlink-install --isolated
cd ..

# 4. compile ros with java support

mkdir -p ros2_java_ws/src
cd ros2_java_ws
#take the master branch, instead of the release branch
#wget https://raw.githubusercontent.com/ros2/ros2/release-latest/ros2.repos
#wget https://raw.githubusercontent.com/ros2/ros2/master/ros2.repos
wget https://raw.githubusercontent.com/ros2/ros2/crystal/ros2.repos
vcs import src < ros2.repos

sudo rosdep init
rosdep update
# [Ubuntu 16.04]
rosdep install --from-paths src --ignore-src --rosdistro crystal -y --skip-keys "console_bridge fastcdr fastrtps libopensplice67 libopensplice69 python3-lark-parser rti-connext-dds-5.3.1 urdfdom_headers"

# remove unneccesary packages
rm -rf src/ament
rm -rf src/ros2/demos
rm -rf src/ros2/examples
rm -rf src/ros2/rmw_connext
#rm -rf src/ros2/rmw_opensplice
rm -rf src/ros2/rosidl_typesupport_connext
rm -rf src/ros2/rosidl_typesupport_opensplice
rm -rf src/ros2/rviz
rm -rf src/ros-visualization

# remove package with ament compilation problem
rm -rf src/ros2/ros2cli/ros2multicast

# requires ros1
rm -rf src/ros2/ros1_bridge

# package ros2/example_interfaces
perl -i -pe 'BEGIN{undef $/;} s/find_package\(action_msgs REQUIRED\)//smg' src/ros2/example_interfaces/CMakeLists.txt
perl -i -pe 'BEGIN{undef $/;} s/\"action\/Fibonacci\.action\"//smg' src/ros2/example_interfaces/CMakeLists.txt
perl -i -pe 'BEGIN{undef $/;} s/DEPENDENCIES action_msgs//smg' src/ros2/example_interfaces/CMakeLists.txt

# package ros2/rcl_interfaces/test_msgs
perl -i -pe 'BEGIN{undef $/;} s/find_package\(action_msgs REQUIRED\)//smg' src/ros2/rcl_interfaces/test_msgs/CMakeLists.txt
perl -i -pe 'BEGIN{undef $/;} s/set\(action_files[^\)]*\)//smg' src/ros2/rcl_interfaces/test_msgs/CMakeLists.txt
perl -i -pe 'BEGIN{undef $/;} s/builtin_interfaces action_msgs unique_identifier_msgs/builtin_interfaces unique_identifier_msgs/smg' src/ros2/rcl_interfaces/test_msgs/CMakeLists.txt

wget https://raw.githubusercontent.com/wmlynar/ros2_java/master/ros2_java.repos
vcs import src < ros2_java.repos

. ../ament_ws/install_isolated/local_setup.sh
ament build --symlink-install --isolated --parallel

# 5. install java libraries

# install maven packages and compile
sudo apt -y install maven
cd src/ros2_java
git clone https://github.com/wmlynar/ros2_java_di
git clone https://github.com/wmlynar/ros2_java_di_example
git clone https://github.com/wmlynar/ros2_java_tf
git clone https://github.com/wmlynar/ros2_java_launch
cd ros2_java
install_jars.sh
install_maven.sh
cd ../../..
