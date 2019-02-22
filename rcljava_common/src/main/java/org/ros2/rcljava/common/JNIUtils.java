/* Copyright 2016-2018 Esteve Fernandez <esteve@apache.org>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.ros2.rcljava.common;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.util.function.Consumer;

public final class JNIUtils {
  private static final Logger logger = LoggerFactory.getLogger(JNIUtils.class);

  private static final String TYPESUPPORT = "rosidl_typesupport_c";
  
  private static Consumer<String> libraryLoader; 

  /**
   * Private constructor so this cannot be instantiated.
   */
  private JNIUtils() {}

  private static String normalizeClassName(Class cls) {
    String className = cls.getCanonicalName();

    // Convert from camel case to underscores using the same regex as:
    // https://raw.githubusercontent.com/ros2/rosidl/master/rosidl_cmake/cmake/string_camel_case_to_lower_case_underscore.cmake
    String libraryName = className.replaceAll("\\.", "_")
                              .replaceAll("(.)([A-Z][a-z]+)", "$1_$2")
                              .replaceAll("([a-z0-9])([A-Z])", "$1_$2")
                              .toLowerCase();
    return libraryName;
  }

  public static void loadImplementation(Class cls) {
    String libraryName = normalizeClassName(cls);
    libraryName = libraryName + "__jni";
    logger.info("Loading implementation: " + libraryName);
    if (libraryLoader == null) {
      System.loadLibrary(libraryName);
    } else {
      libraryLoader.accept(libraryName);
    }
  }

  public static void loadTypesupport(Class cls) {
    String libraryName = normalizeClassName(cls);
    libraryName = libraryName + "__jni__" + JNIUtils.TYPESUPPORT;
    logger.info("Loading typesupport: " + libraryName);
    if (libraryLoader == null) {
      System.loadLibrary(libraryName);
    } else {
      libraryLoader.accept(libraryName);
    }
  }
  
  public static void setLibraryLoader(Consumer<String> libraryLoader) {
    JNIUtils.libraryLoader = libraryLoader;
  }
}
