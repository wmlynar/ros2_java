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

#include "org_ros2_rcljava_WaitSetImpl.h"

JNIEXPORT void JNICALL
Java_org_ros2_rcljava_executors_BaseExecutor_nativeWaitSetInit(
  JNIEnv * env, jclass, jlong wait_set_handle, jint number_of_subscriptions,
  jint number_of_guard_conditions, jint number_of_timers, jint number_of_clients,
  jint number_of_services)
{
  rcl_wait_set_t * wait_set = reinterpret_cast<rcl_wait_set_t *>(wait_set_handle);

  rcl_ret_t ret = rcl_wait_set_init(
    wait_set, number_of_subscriptions, number_of_guard_conditions, number_of_timers,
    number_of_clients, number_of_services, rcl_get_default_allocator());
  if (ret != RCL_RET_OK) {
    std::string msg = "Failed to initialize wait set: " + std::string(rcl_get_error_string_safe());
    rcl_reset_error();
    rcljava_throw_rclexception(env, ret, msg);
  }
}

JNIEXPORT void JNICALL
Java_org_ros2_rcljava_executors_BaseExecutor_nativeWaitSetClearSubscriptions(
  JNIEnv * env, jclass, jlong wait_set_handle)
{
  rcl_wait_set_t * wait_set = reinterpret_cast<rcl_wait_set_t *>(wait_set_handle);
  rcl_ret_t ret = rcl_wait_set_clear_subscriptions(wait_set);
  if (ret != RCL_RET_OK) {
    std::string msg =
      "Failed to clear subscriptions from wait set: " + std::string(rcl_get_error_string_safe());
    rcl_reset_error();
    rcljava_throw_rclexception(env, ret, msg);
  }
}

JNIEXPORT void JNICALL
Java_org_ros2_rcljava_executors_BaseExecutor_nativeWaitSetAddSubscription(
  JNIEnv * env, jclass, jlong wait_set_handle, jlong subscription_handle)
{
  rcl_wait_set_t * wait_set = reinterpret_cast<rcl_wait_set_t *>(wait_set_handle);
  rcl_subscription_t * subscription = reinterpret_cast<rcl_subscription_t *>(subscription_handle);
  rcl_ret_t ret = rcl_wait_set_add_subscription(wait_set, subscription);
  if (ret != RCL_RET_OK) {
    std::string msg =
      "Failed to add subscription to wait set: " + std::string(rcl_get_error_string_safe());
    rcl_reset_error();
    rcljava_throw_rclexception(env, ret, msg);
  }
}

JNIEXPORT void JNICALL
Java_org_ros2_rcljava_executors_BaseExecutor_nativeWaitSetAddService(
  JNIEnv * env, jclass, jlong wait_set_handle, jlong service_handle)
{
  rcl_wait_set_t * wait_set = reinterpret_cast<rcl_wait_set_t *>(wait_set_handle);
  rcl_service_t * service = reinterpret_cast<rcl_service_t *>(service_handle);
  rcl_ret_t ret = rcl_wait_set_add_service(wait_set, service);
  if (ret != RCL_RET_OK) {
    std::string msg =
      "Failed to add service to wait set: " + std::string(rcl_get_error_string_safe());
    rcl_reset_error();
    rcljava_throw_rclexception(env, ret, msg);
  }
}

JNIEXPORT void JNICALL
Java_org_ros2_rcljava_executors_BaseExecutor_nativeWaitSetClearClients(
  JNIEnv * env, jclass, jlong wait_set_handle)
{
  rcl_wait_set_t * wait_set = reinterpret_cast<rcl_wait_set_t *>(wait_set_handle);
  rcl_ret_t ret = rcl_wait_set_clear_clients(wait_set);
  if (ret != RCL_RET_OK) {
    std::string msg =
      "Failed to clear clients from wait set: " + std::string(rcl_get_error_string_safe());
    rcl_reset_error();
    rcljava_throw_rclexception(env, ret, msg);
  }
}

JNIEXPORT void JNICALL
Java_org_ros2_rcljava_executors_BaseExecutor_nativeWaitSetAddClient(
  JNIEnv * env, jclass, jlong wait_set_handle, jlong client_handle)
{
  rcl_wait_set_t * wait_set = reinterpret_cast<rcl_wait_set_t *>(wait_set_handle);
  rcl_client_t * client = reinterpret_cast<rcl_client_t *>(client_handle);
  rcl_ret_t ret = rcl_wait_set_add_client(wait_set, client);
  if (ret != RCL_RET_OK) {
    std::string msg =
      "Failed to add client to wait set: " + std::string(rcl_get_error_string_safe());
    rcl_reset_error();
    rcljava_throw_rclexception(env, ret, msg);
  }
}

JNIEXPORT void JNICALL
Java_org_ros2_rcljava_executors_BaseExecutor_nativeWaitSetAddTimer(
  JNIEnv * env, jclass, jlong wait_set_handle, jlong timer_handle)
{
  rcl_wait_set_t * wait_set = reinterpret_cast<rcl_wait_set_t *>(wait_set_handle);
  rcl_timer_t * timer = reinterpret_cast<rcl_timer_t *>(timer_handle);
  rcl_ret_t ret = rcl_wait_set_add_timer(wait_set, timer);
  if (ret != RCL_RET_OK) {
    std::string msg =
      "Failed to add timer to wait set: " + std::string(rcl_get_error_string_safe());
    rcl_reset_error();
    rcljava_throw_rclexception(env, ret, msg);
  }
}

JNIEXPORT jboolean JNICALL
Java_org_ros2_rcljava_executors_BaseExecutor_nativeWaitSetSubscriptionIsReady(
  JNIEnv *, jclass, jlong wait_set_handle, jlong index)
{
  rcl_wait_set_t * wait_set = reinterpret_cast<rcl_wait_set_t *>(wait_set_handle);
  return wait_set->subscriptions[index] != nullptr;
}

JNIEXPORT jboolean JNICALL
Java_org_ros2_rcljava_executors_BaseExecutor_nativeWaitSetTimerIsReady(
  JNIEnv *, jclass, jlong wait_set_handle, jlong index)
{
  rcl_wait_set_t * wait_set = reinterpret_cast<rcl_wait_set_t *>(wait_set_handle);
  return wait_set->timers[index] != nullptr;
}

JNIEXPORT jboolean JNICALL
Java_org_ros2_rcljava_executors_BaseExecutor_nativeWaitSetServiceIsReady(
  JNIEnv *, jclass, jlong wait_set_handle, jlong index)
{
  rcl_wait_set_t * wait_set = reinterpret_cast<rcl_wait_set_t *>(wait_set_handle);
  return wait_set->services[index] != nullptr;
}

JNIEXPORT jboolean JNICALL
Java_org_ros2_rcljava_executors_BaseExecutor_nativeWaitSetClientIsReady(
  JNIEnv *, jclass, jlong wait_set_handle, jlong index)
{
  rcl_wait_set_t * wait_set = reinterpret_cast<rcl_wait_set_t *>(wait_set_handle);
  return wait_set->clients[index] != nullptr;
}
