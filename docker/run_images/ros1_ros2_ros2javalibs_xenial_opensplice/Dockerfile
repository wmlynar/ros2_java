FROM ubuntu:xenial
MAINTAINER esteve@apache.org
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    locales
RUN locale-gen en_US en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
RUN apt-get install -y --no-install-recommends \
    apt-transport-https \
    dirmngr \
    gnupg-agent \
    lsb-release \
    software-properties-common \
    tzdata
RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros-latest.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 421C365BD9FF1F717815A3895523BAEEB01FA116
RUN echo "deb http://packages.osrfoundation.org/gazebo/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/gazebo-latest.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys D2486D2DD83DB69272AFE98867170598AF249743
RUN apt-get update --fix-missing
RUN apt-get install -y --no-install-recommends \
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
RUN pip3 install \
    argcomplete
# additional testing dependencies from pip (because not available on ubuntu 16.04)
RUN pip3 install \
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
RUN apt-get install -y --no-install-recommends \
    python3-colcon-common-extensions
RUN add-apt-repository ppa:cwchien/gradle
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    gradle \
    openjdk-8-jdk-headless
RUN mkdir -p /root/.gradle
RUN echo org.gradle.daemon=true | tee /root/.gradle/gradle.properties
RUN echo org.gradle.jvmargs=-Xmx2048M | tee -a /root/.gradle/gradle.properties
RUN echo "buildscript { repositories { jcenter() }; dependencies { classpath 'com.android.tools.build:gradle:2.2.0+' } }" | tee /tmp/dummy.gradle
RUN gradle -b /tmp/dummy.gradle
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=$PATH:${JAVA_HOME}/bin:${JAVA_HOME}/jre/bin
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    libopencv-dev \
    libpcre3-dev
RUN apt-get install -y --no-install-recommends \
    libasio-dev \
    libtinyxml2-dev \
    openjdk-8-jdk
# dependencies for testing
RUN apt-get install -y --no-install-recommends \
    clang-format \
    pydocstyle \
    pyflakes \
    python3-coverage \
    python3-mock \
    python3-pep8 \
    uncrustify

RUN apt install -y \
  build-essential \
  cmake \
  git \
  python3-colcon-common-extensions \
  python3-pip \
  python-rosdep \
  python3-vcstool \
  wget
# install some pip packages needed for testing
RUN python3 -m pip install -U \
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
RUN apt install --no-install-recommends -y \
  libasio-dev \
  libtinyxml2-dev

RUN apt-get -y install liblog4cxx-dev
RUN apt-get -y install zip unzip
RUN pip3 install lxml

# install ros2

RUN export ROS_FILE=crystal-20190408

RUN mkdir -p ~/ros2_install
RUN cd ~/ros2_install && wget https://github.com/ros2/ros2/releases/download/release-${ROS_FILE}/ros2-${ROS_FILE}-linux-xenial-amd64.tar.bz2
RUN cd ~/ros2_install && tar xf ros2-${ROS_FILE}-linux-xenial-amd64.tar.bz2
RUN cd ~/ros2_install && rm ros2-${ROS_FILE}-linux-xenial-amd64.tar.bz2

RUN cd ~/ros2_install && rosdep init
RUN cd ~/ros2_install && rosdep update
# [Ubuntu 16.04]
RUN cd ~/ros2_install/ros2-linux && rosdep install --from-paths src --ignore-src --rosdistro crystal -y --skip-keys "console_bridge fastcdr fastrtps libopensplice67 libopensplice69 python3-lark-parser rti-connext-dds-5.3.1 urdfdom_headers"
RUN cd ~/ros2_install/ros2-linux && python3 -m pip install -U lark-parser

# install ros1

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
RUN apt-get update
#RUN apt-get install -y ros-kinetic-desktop-full
RUN apt-get -y install ros-kinetic-ros-base

#RUN rosdep init
RUN rosdep update

# install ros2_java_libraries

RUN chown -R $(id -u):$(id -g) /opt
RUN mkdir -p /opt/ros2_java/lib
RUN cd /opt/ros2_java/lib && wget https://github.com/wmlynar/ros2_java_maven_repo/raw/master/ros2-java-libs-xenial-opensplice-0.0.1-SNAPSHOT.zip
RUN cd /opt/ros2_java/lib && unzip ros2-java-libs-xenial-opensplice-0.0.1-SNAPSHOT.zip
RUN cd /opt/ros2_java/lib && rm ros2-java-libs-xenial-opensplice-0.0.1-SNAPSHOT.zip

# add environment variables
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/ros2_java/lib

#install opensplice
RUN apt -y install libopensplice69

#for the purpose of being able to: perl -i -pe 'BEGIN{undef $/;} s/<Id>[^<]*<\/Id>/<Id>$ROS_DOMAIN_ID<\/Id>/smg' /usr/etc/opensplice/config/ospl.xml 
RUN apt -y install perl
