// Copyright 2016-2018 Esteve Fernandez <esteve@apache.org>
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include <jni.h>

#include <cassert>
#include <cstdlib>
#include <string>

#include "rcl/error_handling.h"
#include "rcl/node.h"
#include "rcl/rcl.h"
#include "rcl/timer.h"
#include "rmw/rmw.h"
#include "rosidl_generator_c/message_type_support_struct.h"

#include "rcljava_common/exceptions.h"
#include "rcljava_common/signatures.h"

#include "org_ros2_rcljava_RCLJava.h"

using rcljava_common::exceptions::rcljava_throw_rclexception;
using rcljava_common::signatures::convert_from_java_signature;
using rcljava_common::signatures::convert_to_java_signature;
using rcljava_common::signatures::destroy_ros_message_signature;

char ** JniStringArray2StringArray(JNIEnv * env, jobjectArray stringArray)
{
  jsize stringCount = env->GetArrayLength(stringArray);
  char ** strings = reinterpret_cast<char **>(malloc(sizeof(char *) * stringCount));

  int i = 0;
  for (i = 0; i < stringCount; ++i) {
    jstring jniString = (jstring) env->GetObjectArrayElement(stringArray, i);
    const char * TempString = env->GetStringUTFChars(jniString, NULL);
    strings[i] = const_cast<char *>(TempString);
    env->ReleaseStringUTFChars(jniString, TempString);
  }

  return strings;
}

JNIEXPORT jlong JNICALL
Java_org_ros2_rcljava_RCLJava_nativeCreateContext(JNIEnv *, jclass)
{
  rcl_context_t * context_ptr = new rcl_context_t;
  *context_ptr = rcl_get_zero_initialized_context();
  return reinterpret_cast<jlong>(context_ptr);
}

JNIEXPORT void JNICALL
Java_org_ros2_rcljava_RCLJava_nativeRCLJavaInit(JNIEnv * env, jclass, jlong contextHandle,
    jobjectArray arg)
{
  rcl_context_t * context_ptr = reinterpret_cast<rcl_context_t *>(contextHandle);
  
  rcl_init_options_t init_options = rcl_get_zero_initialized_init_options();
  rcl_ret_t ret = rcl_init_options_init(&init_options, rcl_get_default_allocator());  
  if (ret != RCL_RET_OK) {
    std::string msg = "Failed to create init options: " + std::string(rcl_get_error_string().str);
    rcl_reset_error();
    rcljava_throw_rclexception(env, ret, msg);
  }
  
  int argc = 0;
  char ** argv = nullptr;
  if (arg != NULL) {
    argc = env->GetArrayLength(arg);
    if( argc>0 ) {
      argv = JniStringArray2StringArray(env, arg);
    }
  }
  
  ret = rcl_init(argc, argv, &init_options, context_ptr);
  if (ret != RCL_RET_OK) {
    std::string msg = "Failed to init: " + std::string(rcl_get_error_string().str);
    rcl_reset_error();
    rcljava_throw_rclexception(env, ret, msg);
  }
}



JNIEXPORT jlong JNICALL
Java_org_ros2_rcljava_RCLJava_nativeCreateNodeHandle(
  JNIEnv * env, jclass, jstring jnode_name, jstring jnamespace, jlong contextHandle)
{
  rcl_context_t * context_ptr = reinterpret_cast<rcl_context_t *>(contextHandle);

  const char * node_name_tmp = env->GetStringUTFChars(jnode_name, 0);
  std::string node_name(node_name_tmp);
  env->ReleaseStringUTFChars(jnode_name, node_name_tmp);

  const char * namespace_tmp = env->GetStringUTFChars(jnamespace, 0);
  std::string namespace_(namespace_tmp);
  env->ReleaseStringUTFChars(jnamespace, namespace_tmp);

  rcl_node_t * node = static_cast<rcl_node_t *>(malloc(sizeof(rcl_node_t)));
  *node = rcl_get_zero_initialized_node();

  rcl_node_options_t default_options = rcl_node_get_default_options();
  rcl_ret_t ret = rcl_node_init(node, node_name.c_str(), namespace_.c_str(), context_ptr, &default_options);
  if (ret != RCL_RET_OK) {
    std::string msg = "Failed to create node: " + std::string(rcl_get_error_string().str);
    rcl_reset_error();
    rcljava_throw_rclexception(env, ret, msg);
    return 0;
  }
  jlong node_handle = reinterpret_cast<jlong>(node);
  return node_handle;
}

JNIEXPORT jstring JNICALL
Java_org_ros2_rcljava_RCLJava_nativeGetRMWIdentifier(JNIEnv * env, jclass)
{
  const char * rmw_implementation_identifier = rmw_get_implementation_identifier();

  return env->NewStringUTF(rmw_implementation_identifier);
}

JNIEXPORT jboolean JNICALL
Java_org_ros2_rcljava_RCLJava_nativeOk(JNIEnv *, jclass, jlong contextHandle)
{
  if (contextHandle==0) {
    return false;
  }
  
  rcl_context_t * context_ptr = reinterpret_cast<rcl_context_t *>(contextHandle);
  
  return rcl_context_is_valid(context_ptr);
}

JNIEXPORT void JNICALL
Java_org_ros2_rcljava_RCLJava_nativeShutdown(JNIEnv * env, jclass, jlong contextHandle)
{
  rcl_context_t * context_ptr = reinterpret_cast<rcl_context_t *>(contextHandle);

  rcl_ret_t ret = rcl_shutdown(context_ptr);
  if (ret != RCL_RET_OK) {
    std::string msg = "Failed to shutdown: " + std::string(rcl_get_error_string().str);
    rcl_reset_error();
    rcljava_throw_rclexception(env, ret, msg);
  }
}

JNIEXPORT void JNICALL
Java_org_ros2_rcljava_RCLJava_nativeDeleteContext(JNIEnv *, jclass, jlong contextHandle)
{
  rcl_context_t * context_ptr = reinterpret_cast<rcl_context_t *>(contextHandle);
  delete context_ptr;
}

JNIEXPORT jlong JNICALL
Java_org_ros2_rcljava_RCLJava_nativeConvertQoSProfileToHandle(
  JNIEnv *, jclass, jint history, jint depth, jint reliability, jint durability,
  jboolean avoidROSNamespaceConventions)
{
  rmw_qos_profile_t * qos_profile =
    static_cast<rmw_qos_profile_t *>(malloc(sizeof(rmw_qos_profile_t)));
  qos_profile->history = static_cast<rmw_qos_history_policy_t>(history);
  qos_profile->depth = depth;
  qos_profile->reliability = static_cast<rmw_qos_reliability_policy_t>(reliability);
  qos_profile->durability = static_cast<rmw_qos_durability_policy_t>(durability);
  qos_profile->avoid_ros_namespace_conventions = avoidROSNamespaceConventions;
  return reinterpret_cast<jlong>(qos_profile);
}

JNIEXPORT void JNICALL
Java_org_ros2_rcljava_RCLJava_nativeDisposeQoSProfile(JNIEnv *, jclass, jlong qos_profile_handle)
{
  rmw_qos_profile_t * qos_profile = reinterpret_cast<rmw_qos_profile_t *>(qos_profile_handle);
  free(qos_profile);
}
