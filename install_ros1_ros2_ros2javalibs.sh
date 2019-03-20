#!/bin/sh

sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
echo "export LANG=en_US.UTF-8" >> ~/.bashrc
export LANG=en_US.UTF-8

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
sudo apt-get update --fix-missing
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

#echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> ~/.bashrc
#echo "export PATH=\$PATH:\${JAVA_HOME}/bin:\${JAVA_HOME}/jre/bin" >> ~/.bashrc
#export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
#export PATH=$PATH:${JAVA_HOME}/bin:${JAVA_HOME}/jre/bin

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

sudo apt-get install liblog4cxx-dev
apt-get -y install unzip

sudo chown -R $(id -u):$(id -g) /opt

# install ros2

mkdir -p ~/ros2_install
cd ~/ros2_install
wget https://github.com/ros2/ros2/releases/download/release-crystal-20190314/ros2-crystal-20190314-linux-xenial-amd64.tar.bz2
tar xf ros2-crystal-20190314-linux-xenial-amd64.tar.bz2
cd ~/ros2_install/ros2-linux 

sudo rosdep init
rosdep update
# [Ubuntu 16.04]
rosdep install --from-paths src --ignore-src --rosdistro crystal -y --skip-keys "console_bridge fastcdr fastrtps libopensplice67 libopensplice69 python3-lark-parser rti-connext-dds-5.3.1 urdfdom_headers"

cd ../..

# install ros1

sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
sudo apt-get update
sudo apt-get install ros-kinetic-desktop-full

sudo rosdep init
rosdep update

# install ros2_java_libraries

sudo chown -R $(id -u):$(id -g) /opt
mkdir -p /opt/ros2_java/lib
cd /opt/ros2_java/lib
wget https://github.com/wmlynar/ros2_java_maven_repo/raw/master/ros2-java-libs-xenial-0.0.1-SNAPSHOT.zip
unzip ros2-java-libs-xenial-0.0.1-SNAPSHOT.zip
rm ros2-java-libs-xenial-0.0.1-SNAPSHOT.zip

# install ros2_java_launch

cd ~
mkdir -p ros2_java_ws/src/ros2_java
cd ros2_java_ws/src/ros2_java
gti clone https://github.com/wmlynar/ros2_java_launch.git
cd ros2_java_launch
./install_ros2_java_launch.sh

# add environment variables
echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/opt/ros2_java/lib" >> ~/.bashrc
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/ros2_java/lib

echo "export PATH=/opt/ros2_java/bin:\${PATH}" >> ~/.bashrc
export PATH=/opt/ros2_java/bin:${PATH}

echo " ROS2_JAVA_LAUNCH_PATH=/home/inovatica/repo_ws/src/autonomiczne-wozki-widlowe/java2" >> ~/.bashrc
export ROS2_JAVA_LAUNCH_PATH=/home/inovatica/repo_ws/src/autonomiczne-wozki-widlowe/java2

