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
RUN apt-get update
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
RUN apt-get -y install unzip

RUN chown -R $(id -u):$(id -g) /opt
RUN cd ~ && wget https://services.gradle.org/distributions/gradle-3.5-bin.zip
RUN mkdir -p /opt/gradle
RUN cd ~ && unzip -d /opt/gradle gradle-3.5-bin.zip
ENV PATH /opt/gradle/gradle-3.5/bin:${PATH}

#install ros2
#RUN mkdir -p ~/ros2_ws/src
#RUN cd ~/ros2_ws && wget https://raw.githubusercontent.com/ros2/ros2/release-latest/ros2.repos
#RUN cd ~/ros2_ws && vcs import src < ros2.repos
#
#RUN cd ~/ros2_ws && rosdep init
#RUN cd ~/ros2_ws && rosdep update
#RUN cd ~/ros2_ws && rosdep install --from-paths src --ignore-src --rosdistro crystal -y --skip-keys "console_bridge fastcdr fastrtps libopensplice67 libopensplice69 python3-lark-parser rti-connext-dds-5.3.1 urdfdom_headers"
#
## remove unneccesary packages
#RUN cd ~/ros2_ws && rm -rf src/ros2/demos
#RUN cd ~/ros2_ws && rm -rf src/ros2/examples
#RUN cd ~/ros2_ws && rm -rf src/ros2/rmw_connext
#RUN cd ~/ros2_ws && rm -rf src/ros2/rmw_opensplice
#RUN cd ~/ros2_ws && rm -rf src/ros2/rosidl_typesupport_connext
#RUN cd ~/ros2_ws && rm -rf src/ros2/rosidl_typesupport_opensplice
#RUN cd ~/ros2_ws && rm -rf src/ros2/rviz
#RUN cd ~/ros2_ws && rm -rf src/ros-visualization
#
## remove package with ament compilation problem
#RUN cd ~/ros2_ws && rm -rf src/ros2/ros2cli/ros2multicast
#
## requires ros1
#RUN cd ~/ros2_ws && rm -rf src/ros2/ros1_bridge
#
#RUN cd ~/ros2_ws && colcon build --symlink-install --merge-install

RUN apt-get -y install mc

RUN mkdir -p ~/ament_ws/src
RUN cd ~/ament_ws && wget https://raw.githubusercontent.com/esteve/ament_java/master/ament_java.repos
RUN cd ~/ament_ws && vcs import src < ament_java.repos

RUN cd ~/ament_ws && src/ament/ament_tools/scripts/ament.py build --symlink-install --isolated --parallel
#RUN cd ~/ament_ws && colcon build --symlink-install

RUN mkdir -p ~/ros2_java_ws/src
RUN cd ~/ros2_java_ws && wget https://raw.githubusercontent.com/ros2/ros2/release-latest/ros2.repos
RUN cd ~/ros2_java_ws && vcs import src < ros2.repos

RUN cd ~/ros2_java_ws && rosdep init
RUN cd ~/ros2_java_ws && rosdep update
RUN cd ~/ros2_java_ws && rosdep install --from-paths src --ignore-src --rosdistro crystal -y --skip-keys "console_bridge fastcdr fastrtps libopensplice67 libopensplice69 python3-lark-parser rti-connext-dds-5.3.1 urdfdom_headers"

# remove unneccesary packages
RUN cd ~/ros2_java_ws && rm -rf src/ament
RUN cd ~/ros2_java_ws && rm -rf src/ros2/demos
RUN cd ~/ros2_java_ws && rm -rf src/ros2/examples
RUN cd ~/ros2_java_ws && rm -rf src/ros2/rmw_connext
RUN cd ~/ros2_java_ws && rm -rf src/ros2/rmw_opensplice
RUN cd ~/ros2_java_ws && rm -rf src/ros2/rosidl_typesupport_connext
RUN cd ~/ros2_java_ws && rm -rf src/ros2/rosidl_typesupport_opensplice
RUN cd ~/ros2_java_ws && rm -rf src/ros2/rviz
RUN cd ~/ros2_java_ws && rm -rf src/ros-visualization

# remove package with ament compilation problem
RUN cd ~/ros2_java_ws && rm -rf src/ros2/ros2cli/ros2multicast

# requires ros1
RUN cd ~/ros2_java_ws && rm -rf src/ros2/ros1_bridge

# package ros2/example_interfaces
RUN cd ~/ros2_java_ws && perl -i -pe 'BEGIN{undef $/;} s/find_package\(action_msgs REQUIRED\)//smg' src/ros2/example_interfaces/CMakeLists.txt
RUN cd ~/ros2_java_ws && perl -i -pe 'BEGIN{undef $/;} s/\"action\/Fibonacci\.action\"//smg' src/ros2/example_interfaces/CMakeLists.txt
RUN cd ~/ros2_java_ws && perl -i -pe 'BEGIN{undef $/;} s/DEPENDENCIES action_msgs//smg' src/ros2/example_interfaces/CMakeLists.txt

# package ros2/rcl_interfaces/test_msgs
RUN cd ~/ros2_java_ws && perl -i -pe 'BEGIN{undef $/;} s/find_package\(action_msgs REQUIRED\)//smg' src/ros2/rcl_interfaces/test_msgs/CMakeLists.txt
RUN cd ~/ros2_java_ws && perl -i -pe 'BEGIN{undef $/;} s/set\(action_files[^\)]*\)//smg' src/ros2/rcl_interfaces/test_msgs/CMakeLists.txt
RUN cd ~/ros2_java_ws && perl -i -pe 'BEGIN{undef $/;} s/builtin_interfaces action_msgs unique_identifier_msgs/builtin_interfaces unique_identifier_msgs/smg' src/ros2/rcl_interfaces/test_msgs/CMakeLists.txt

RUN cd ~/ros2_java_ws && wget https://raw.githubusercontent.com/wmlynar/ros2_java/master/ros2_java.repos
RUN cd ~/ros2_java_ws && vcs import src < ros2_java.repos

RUN . ~/ament_ws/install_isolated/local_setup.sh && cd ~/ros2_java_ws && ament build --symlink-install --isolated --parallel
#RUN . ~/ament_ws/install/local_setup.sh && cd ~/ros2_java_ws && colcon build --symlink-install

