#!/bin/sh

VERSION=0.0.1-SNAPSHOT

# install rcljava and rcljava_common libraries

for file in `find ~/ros2_java_ws/build_isolated/ -name *rcl*.jar`
do
  echo "Installing $file as $(basename ${file%.*})"
  mvn install:install-file -Dfile="$file" -DgroupId=org.ros2.java -DartifactId="$(basename ${file%.*})" -Dversion=$VERSION -Dpackaging=jar
done

# install all messages

for file in `find ~/ros2_java_ws/build_isolated/ -name *messages.jar`
do
  echo "Installing $file as $(basename ${file%.*})"
  mvn install:install-file -Dfile="$file" -DgroupId=org.ros2.java -DartifactId="$(basename ${file%.*})" -Dversion=$VERSION -Dpackaging=jar
done


