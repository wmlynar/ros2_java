#!/bin/sh

mvn install

cd ../ros2_java_di
mvn install

cd ../ros2_java_di_example
mvn install

cd ../ros2_java_tf
mvn install

cd ../ros2_java_launch
mvn install

