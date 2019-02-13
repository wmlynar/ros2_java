// generated from rosidl_generator_java/resource/srv.cpp.em
// generated code does not contain a copyright notice

#include <jni.h>

#include "rosidl_generator_c/service_type_support_struct.h"
#include "@(spec.pkg_name)/@(subfolder)/@(module_name).h"

#ifdef __cplusplus
extern "C" {
#endif

/*
 * Class:     @(jni_package_name)_@(subfolder)_@(type_name)
 * Method:    getServiceTypeSupport
 * Signature: ()J
 */
JNIEXPORT jlong JNICALL Java_@(jni_package_name)_@(subfolder)_@(jni_type_name)_getServiceTypeSupport(JNIEnv *, jclass);

#ifdef __cplusplus
}
#endif

JNIEXPORT jlong JNICALL Java_@(jni_package_name)_@(subfolder)_@(jni_type_name)_getServiceTypeSupport(JNIEnv *, jclass)
{
  const rosidl_service_type_support_t * ts = ROSIDL_GET_SRV_TYPE_SUPPORT(
    @(spec.pkg_name), @(subfolder), @(spec.srv_name));
  return reinterpret_cast<jlong>(ts);
}
