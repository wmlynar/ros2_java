// Copyright 2018 Esteve Fernandez <esteve@apache.org>
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
/* Header for class org_ros2_rcljava_WaitSetImpl */

#ifndef ORG_ROS2_RCLJAVA_WAITSETIMPL_H_
#define ORG_ROS2_RCLJAVA_WAITSETIMPL_H_
#ifdef __cplusplus
extern "C" {
#endif

/*
 * Class:     org_ros2_rcljava_WaitSetImpl
 * Method:    nativeWaitSetInit
 * Signature: (JIIIII)V
 */
JNIEXPORT void JNICALL Java_org_ros2_rcljava_WaitSetImpl_nativeWaitSetInit(
  JNIEnv *, jclass, jlong, jint, jint, jint, jint, jint);

/*
 * Class:     org_ros2_rcljava_WaitSetImpl
 * Method:    nativeWaitSetClearSubscriptions
 * Signature: (J)V
 */
JNIEXPORT void JNICALL
  Java_org_ros2_rcljava_WaitSetImpl_nativeWaitSetClearSubscriptions(JNIEnv *, jclass, jlong);

/*
 * Class:     org_ros2_rcljava_WaitSetImpl
 * Method:    nativeWaitSetClearTimers
 * Signature: (J)V
 */
JNIEXPORT void JNICALL
  Java_org_ros2_rcljava_WaitSetImpl_nativeWaitSetClearTimers(JNIEnv *, jclass, jlong);

/*
 * Class:     org_ros2_rcljava_WaitSetImpl
 * Method:    nativeWaitSetClearServices
 * Signature: (J)V
 */
JNIEXPORT void JNICALL
  Java_org_ros2_rcljava_WaitSetImpl_nativeWaitSetClearServices(JNIEnv *, jclass, jlong);

/*
 * Class:     org_ros2_rcljava_WaitSetImpl
 * Method:    nativeWaitSetAddSubscription
 * Signature: (JJ)V
 */
JNIEXPORT void JNICALL
  Java_org_ros2_rcljava_WaitSetImpl_nativeWaitSetAddSubscription(JNIEnv *, jclass, jlong, jlong);

/*
 * Class:     org_ros2_rcljava_WaitSetImpl
 * Method:    nativeWaitSetAddService
 * Signature: (JJ)V
 */
JNIEXPORT void JNICALL
  Java_org_ros2_rcljava_WaitSetImpl_nativeWaitSetAddService(JNIEnv *, jclass, jlong, jlong);

/*
 * Class:     org_ros2_rcljava_WaitSetImpl
 * Method:    nativeWaitSetClearClients
 * Signature: (J)V
 */
JNIEXPORT void JNICALL
  Java_org_ros2_rcljava_WaitSetImpl_nativeWaitSetClearClients(JNIEnv *, jclass, jlong);

/*
 * Class:     org_ros2_rcljava_WaitSetImpl
 * Method:    nativeWaitSetAddClient
 * Signature: (JJ)V
 */
JNIEXPORT void JNICALL
  Java_org_ros2_rcljava_WaitSetImpl_nativeWaitSetAddClient(JNIEnv *, jclass, jlong, jlong);

/*
 * Class:     org_ros2_rcljava_WaitSetImpl
 * Method:    nativeWaitSetAddTimer
 * Signature: (JJ)V
 */
JNIEXPORT void JNICALL
  Java_org_ros2_rcljava_WaitSetImpl_nativeWaitSetAddTimer(JNIEnv *, jclass, jlong, jlong);

/*
 * Class:     org_ros2_rcljava_WaitSetImpl
 * Method:    nativeWaitSetSubscriptionIsReady
 * Signature: (JJ)Z
 */
JNIEXPORT jboolean JNICALL Java_org_ros2_rcljava_WaitSetImpl_nativeWaitSetSubscriptionIsReady(
  JNIEnv *, jclass, jlong, jlong);

/*
 * Class:     org_ros2_rcljava_WaitSetImpl
 * Method:    nativeWaitSetTimerIsReady
 * Signature: (JJ)Z
 */
JNIEXPORT jboolean JNICALL
  Java_org_ros2_rcljava_WaitSetImpl_nativeWaitSetTimerIsReady(JNIEnv *, jclass, jlong, jlong);

/*
 * Class:     org_ros2_rcljava_WaitSetImpl
 * Method:    nativeWaitSetServiceIsReady
 * Signature: (JJ)Z
 */
JNIEXPORT jboolean JNICALL
  Java_org_ros2_rcljava_WaitSetImpl_nativeWaitSetServiceIsReady(JNIEnv *, jclass, jlong, jlong);

/*
 * Class:     org_ros2_rcljava_WaitSetImpl
 * Method:    nativeWaitSetClientIsReady
 * Signature: (JJ)Z
 */
JNIEXPORT jboolean JNICALL
  Java_org_ros2_rcljava_WaitSetImpl_nativeWaitSetClientIsReady(JNIEnv *, jclass, jlong, jlong);

#ifdef __cplusplus
}
#endif
#endif  // ORG_ROS2_RCLJAVA_WAITSETIMPL_H_
