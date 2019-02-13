// generated from rosidl_generator_java/resource/msg.cpp.em
// generated code does not contain a copyright notice

#include <jni.h>

#include <cassert>
#include <cstdint>
#include <string>

// Ensure that a jlong is big enough to store raw pointers
static_assert(sizeof(jlong) >= sizeof(std::intptr_t), "jlong must be able to store pointers");

#include "@(spec.base_type.pkg_name)/@(subfolder)/@(module_name).h"
#include "rosidl_generator_c/message_type_support_struct.h"

#include "rosidl_generator_c/string.h"
#include "rosidl_generator_c/string_functions.h"

#include "rosidl_generator_c/primitives_sequence.h"
#include "rosidl_generator_c/primitives_sequence_functions.h"

#include "rcljava_common/exceptions.h"
#include "rcljava_common/signatures.h"

@#JNI performance tips taken from http://planet.jboss.org/post/jni_performance_the_saga_continues

using rcljava_common::exceptions::rcljava_throw_exception;

@{

from collections import defaultdict

def get_normalized_type(type_, subfolder='msg'):
    return get_java_type(type_, use_primitives=False, subfolder=subfolder).replace('.', '__')

def get_jni_type(type_, subfolder='msg'):
    return get_java_type(type_, use_primitives=False, subfolder=subfolder).replace('.', '/')

constructor_signatures = defaultdict(lambda: "()V")
constructor_signatures['java/lang/Boolean'] = "(Z)V"
constructor_signatures['java/lang/Byte'] = "(B)V"
constructor_signatures['java/lang/Character'] = "(C)V"
constructor_signatures['java/lang/Double'] = "(D)V"
constructor_signatures['java/lang/Float'] = "(F)V"
constructor_signatures['java/lang/Integer'] = "(I)V"
constructor_signatures['java/lang/Long'] = "(J)V"
constructor_signatures['java/lang/Short'] = "(S)V"
constructor_signatures['java/util/List'] = None

value_methods = {}
value_methods['java/lang/Boolean'] = ("booleanValue", "()Z")
value_methods['java/lang/Byte'] = ("byteValue", "()B")
value_methods['java/lang/Character'] = ("charValue", "()C")
value_methods['java/lang/Double'] = ("doubleValue", "()D")
value_methods['java/lang/Float'] = ("floatValue", "()F")
value_methods['java/lang/Integer'] = ("intValue", "()I")
value_methods['java/lang/Long'] = ("longValue", "()J")
value_methods['java/lang/Short'] = ("shortValue", "()S")

jni_signatures = {}
jni_signatures['java/lang/Boolean'] = "Z"
jni_signatures['java/lang/Byte'] = "B"
jni_signatures['java/lang/Character'] = "C"
jni_signatures['java/lang/Double'] = "D"
jni_signatures['java/lang/Float'] = "F"
jni_signatures['java/lang/Integer'] = "I"
jni_signatures['java/lang/Long'] = "J"
jni_signatures['java/lang/Short'] = "S"

non_primitive_types = set()

def get_constructor_signature(type_, subfolder='msg'):
    return constructor_signatures[get_jni_type(type_, subfolder=subfolder)]

def get_value_method(type_, subfolder='msg'):
    return value_methods.get(get_jni_type(type_, subfolder=subfolder))

def get_jni_signature(type_, subfolder='msg'):
    return jni_signatures.get(get_jni_type(type_, subfolder=subfolder))

msg_normalized_type = get_normalized_type(spec.base_type, subfolder=subfolder)
msg_jni_type = get_jni_type(spec.base_type, subfolder=subfolder)

list_java_type = "java.util.List"
array_list_java_type = "java.util.ArrayList"

list_normalized_type = "java__util__List"
list_jni_type = "java/util/List"

array_list_normalized_type = "java__util__ArrayList"
array_list_jni_type = "java/util/ArrayList"

cache = defaultdict(lambda: False)

cache[msg_normalized_type] = msg_jni_type

# We do not cache strings because java.lang.String behaves differently

unique_fields = set()

for field in spec.fields:
    if field.type.is_array:
        cache[list_normalized_type] = list_jni_type
        cache[array_list_normalized_type] = array_list_jni_type

    if not field.type.type == 'string':
        cache[get_normalized_type(field.type)] = get_jni_type(field.type)

    if not field.type.is_primitive_type():
        non_primitive_types.add(get_jni_type(field.type))
        unique_fields.add((field.type.pkg_name, field.type.type))
}@

@[for field_pkg_name, field_type in unique_fields]@
#include "@(field_pkg_name)/msg/@(convert_camel_case_to_lower_case_underscore(field_type)).h"
#include "@(field_pkg_name)/msg/@(convert_camel_case_to_lower_case_underscore(field_type))__functions.h"
@[end for]@
#ifdef __cplusplus
extern "C" {
#endif

// Initialize cached types in the anonymous namespace to avoid linking conflicts
namespace
{
JavaVM * g_vm = nullptr;

@[for normalized_type, jni_type in cache.items()]@
jclass _j@(normalized_type)_class_global = nullptr;
@[if constructor_signatures[jni_type]]@
jmethodID _j@(normalized_type)_constructor_global = nullptr;
@[end if]@

@[    if value_methods.get(jni_type)]@
jmethodID _j@(normalized_type)_value_global = nullptr;
@[    end if]@

@[    if jni_type in non_primitive_types]@
jmethodID _j@(normalized_type)_from_java_converter_global = nullptr;
using _j@(normalized_type)_from_java_signature = @(normalized_type) * (*)(jobject, @(normalized_type) *);
jlong _j@(normalized_type)_from_java_converter_ptr_global = 0;
_j@(normalized_type)_from_java_signature _j@(normalized_type)_from_java_function = nullptr;

jmethodID _j@(normalized_type)_to_java_converter_global = nullptr;
using _j@(normalized_type)_to_java_signature = jobject (*)(@(normalized_type) *, jobject);
jlong _j@(normalized_type)_to_java_converter_ptr_global = 0;
_j@(normalized_type)_to_java_signature _j@(normalized_type)_to_java_function = nullptr;
@[    end if]@
@[end for]@
}  // namespace

/*
 * Class:     @(jni_package_name)_@(subfolder)_@(type_name)
 * Method:    getFromJavaConverter
 * Signature: ()J
 */
JNIEXPORT jlong JNICALL Java_@(jni_package_name)_@(subfolder)_@(jni_type_name)_getFromJavaConverter
  (JNIEnv *, jclass);

/*
 * Class:     @(jni_package_name)_@(subfolder)_@(type_name)
 * Method:    getToJavaConverter
 * Signature: ()J
 */
JNIEXPORT jlong JNICALL Java_@(jni_package_name)_@(subfolder)_@(jni_type_name)_getToJavaConverter
  (JNIEnv *, jclass);

/*
 * Class:     @(jni_package_name)_@(subfolder)_@(type_name)
 * Method:    getTypeSupport
 * Signature: ()J
 */
JNIEXPORT jlong JNICALL Java_@(jni_package_name)_@(subfolder)_@(jni_type_name)_getTypeSupport
  (JNIEnv *, jclass);

/*
 * Class:     @(jni_package_name)_@(subfolder)_@(type_name)
 * Method:    getDestructor
 * Signature: ()J
 */
JNIEXPORT jlong JNICALL Java_@(jni_package_name)_@(subfolder)_@(jni_type_name)_getDestructor
  (JNIEnv *, jclass);

#ifdef __cplusplus
}
#endif

@# Avoid warnings about unused arguments if the message definition does not contain any fields
@[if spec.fields]@
@(msg_normalized_type) * @(spec.base_type.pkg_name)_@(type_name)__convert_from_java(jobject _jmessage_obj, @(msg_normalized_type) * ros_message)
@[else]@
@(msg_normalized_type) * @(spec.base_type.pkg_name)_@(type_name)__convert_from_java(jobject, @(msg_normalized_type) * ros_message)
@[end if]@
{
  JNIEnv * env = nullptr;
  // TODO(esteve): check return status
  assert(g_vm != nullptr);
  g_vm->GetEnv(reinterpret_cast<void **>(&env), JNI_VERSION_1_6);
  assert(env != nullptr);

  if (ros_message == nullptr) {
    ros_message = @(msg_normalized_type)__create();
  }
@[for field in spec.fields]@
@{
normalized_type = get_normalized_type(field.type)
}@
@[    if field.type.is_array]
  auto _jfield_@(field.name)_fid = env->GetFieldID(_j@(msg_normalized_type)_class_global, "@(field.name)", "L@(list_jni_type);");
  jobject _jlist_@(field.name)_object = env->GetObjectField(_jmessage_obj, _jfield_@(field.name)_fid);

  if (_jlist_@(field.name)_object != nullptr) {
    jmethodID _jlist_@(field.name)_get_mid = env->GetMethodID(_j@(list_normalized_type)_class_global, "get", "(I)Ljava/lang/Object;");
@[        if field.type.array_size is None or field.type.is_upper_bound]@
    jmethodID _jlist_@(field.name)_size_mid = env->GetMethodID(_j@(list_normalized_type)_class_global, "size", "()I");
    jint _jlist_@(field.name)_size = env->CallIntMethod(_jlist_@(field.name)_object, _jlist_@(field.name)_size_mid);
@[            if field.type.type == 'string']@
    if (!rosidl_generator_c__String__Sequence__init(&(ros_message->@(field.name)), _jlist_@(field.name)_size)) {
      rcljava_throw_exception(env, "java/lang/IllegalStateException", "unable to create String__Sequence ros_message");
    }
@[            else]@
@[                if field.type.is_primitive_type()]@
    if (!rosidl_generator_c__@(field.type.type)__Sequence__init(&(ros_message->@(field.name)), _jlist_@(field.name)_size)) {
      rcljava_throw_exception(env, "java/lang/IllegalStateException", "unable to create @(field.type.type)__Sequence ros_message");
    }
@[                else]@
    if (!@(field.type.pkg_name)__msg__@(field.type.type)__Sequence__init(&(ros_message->@(field.name)), _jlist_@(field.name)_size)) {
      rcljava_throw_exception(env, "java/lang/IllegalStateException", "unable to create @(field.type.type)__Sequence ros_message");
    }

@[                end if]@
@[            end if]@
    auto _dest_@(field.name) = ros_message->@(field.name).data;
@[        else]@
    jint _jlist_@(field.name)_size = @(field.type.array_size);

    auto _dest_@(field.name) = ros_message->@(field.name);
@[        end if]@

    for (jint i = 0; i < _jlist_@(field.name)_size; ++i) {
      auto element = env->CallObjectMethod(_jlist_@(field.name)_object, _jlist_@(field.name)_get_mid, i);
@[        if field.type.is_primitive_type()]@
@[            if field.type.type == 'string']@
      jstring _jfield_@(field.name)_value = static_cast<jstring>(element);
      if (_jfield_@(field.name)_value != nullptr) {
        const char * _str@(field.name) = env->GetStringUTFChars(_jfield_@(field.name)_value, 0);
        rosidl_generator_c__String__assign(
          &_dest_@(field.name)[i], _str@(field.name));
        env->ReleaseStringUTFChars(_jfield_@(field.name)_value, _str@(field.name));
      }
@[            else]@
@{
call_method_name = 'Call%sMethod' % get_java_type(field.type, use_primitives=True).capitalize()
}@
      _dest_@(field.name)[i] = env->@(call_method_name)(element, _j@(normalized_type)_value_global);
@[            end if]@
@[        else]@
      _dest_@(field.name)[i] = *_j@(normalized_type)_from_java_function(element, nullptr);
@[        end if]@
      env->DeleteLocalRef(element);
    }
  }
@[    else]@
@[        if field.type.is_primitive_type()]@
@[            if field.type.type == 'string']@
  auto _jfield_@(field.name)_fid = env->GetFieldID(_j@(msg_normalized_type)_class_global, "@(field.name)", "Ljava/lang/String;");
  jstring _jvalue@(field.name) = static_cast<jstring>(env->GetObjectField(_jmessage_obj, _jfield_@(field.name)_fid));

  if (_jvalue@(field.name) != nullptr) {
    const char * _str@(field.name) = env->GetStringUTFChars(_jvalue@(field.name), 0);
    rosidl_generator_c__String__assign(
      &ros_message->@(field.name), _str@(field.name));
    env->ReleaseStringUTFChars(_jvalue@(field.name), _str@(field.name));
  }
@[            else]@
@{
jni_signature = get_jni_signature(field.type)
get_method_name = 'Get%sField' % get_java_type(field.type, use_primitives=True).capitalize()
}@
  auto _jfield_@(field.name)_fid = env->GetFieldID(_j@(msg_normalized_type)_class_global, "@(field.name)", "@(jni_signature)");
  ros_message->@(field.name) = env->@(get_method_name)(_jmessage_obj, _jfield_@(field.name)_fid);

@[            end if]@
@[        else]@
  auto _jfield_@(field.name)_fid = env->GetFieldID(
    _j@(msg_normalized_type)_class_global, "@(field.name)", "L@(field.type.pkg_name)/msg/@(field.type.type);");
  assert(_jfield_@(field.name)_fid != nullptr);

  jobject _jfield_@(field.name)_obj = env->GetObjectField(_jmessage_obj, _jfield_@(field.name)_fid);

  if (_jfield_@(field.name)_obj != nullptr) {
    ros_message->@(field.name) = *_j@(normalized_type)_from_java_function(_jfield_@(field.name)_obj, nullptr);
  }
  env->DeleteLocalRef(_jfield_@(field.name)_obj);
@[        end if]@
@[    end if]@
@[end for]@
  assert(ros_message != nullptr);
  return ros_message;
}

@# Avoid warnings about unused arguments if the message definition does not contain any fields
@[if spec.fields]@
jobject @(spec.base_type.pkg_name)_@(type_name)__convert_to_java(@(msg_normalized_type) * _ros_message, jobject _jmessage_obj)
@[else]@
jobject @(spec.base_type.pkg_name)_@(type_name)__convert_to_java(@(msg_normalized_type) *, jobject _jmessage_obj)
@[end if]@
{
  JNIEnv * env = nullptr;
  // TODO(esteve): check return status
  assert(g_vm != nullptr);
  g_vm->GetEnv(reinterpret_cast<void **>(&env), JNI_VERSION_1_6);
  assert(env != nullptr);

  if (_jmessage_obj == nullptr) {
    _jmessage_obj = env->NewObject(_j@(msg_normalized_type)_class_global, _j@(msg_normalized_type)_constructor_global);
  }
@[for field in spec.fields]@
@{
normalized_type = get_normalized_type(field.type)
}@
@[    if field.type.is_array]@
@[        if field.type.is_primitive_type()]@
  auto _jfield_@(field.name)_fid = env->GetFieldID(_j@(msg_normalized_type)_class_global, "@(field.name)", "L@(list_jni_type);");
  jobject _jarray_list_@(field.name)_obj = env->NewObject(_j@(array_list_normalized_type)_class_global, _j@(array_list_normalized_type)_constructor_global);
@[            if field.type.array_size and not field.type.is_upper_bound]@
  for (size_t i = 0; i < @(field.type.array_size); ++i) {
    auto _ros_@(field.name)_element = _ros_message->@(field.name)[i];
@[            else]@
  for (size_t i = 0; i < _ros_message->@(field.name).size; ++i) {
    auto _ros_@(field.name)_element = _ros_message->@(field.name).data[i];
@[            end if]@
@[                if field.type.type == 'string']@
    jobject _jlist_@(field.name)_element = nullptr;
    if (_ros_@(field.name)_element.data != nullptr) {
      _jlist_@(field.name)_element = env->NewStringUTF(_ros_@(field.name)_element.data);
    }
@[                else]@
    jobject _jlist_@(field.name)_element = env->NewObject(
      _j@(normalized_type)_class_global, _j@(normalized_type)_constructor_global, _ros_@(field.name)_element);
@[                end if]@
    // TODO(esteve): replace ArrayList with a jobjectArray to initialize the array beforehand
    jmethodID _jlist_@(field.name)_add_mid = env->GetMethodID(
      _j@(array_list_normalized_type)_class_global, "add", "(Ljava/lang/Object;)Z");
    if (_jlist_@(field.name)_element != nullptr) {
      jboolean _jlist_@(field.name)_add_result = env->CallBooleanMethod(_jarray_list_@(field.name)_obj, _jlist_@(field.name)_add_mid, _jlist_@(field.name)_element);
      assert(_jlist_@(field.name)_add_result);
    }
  }
@[        else]@

  auto _jfield_@(field.name)_fid = env->GetFieldID(_j@(msg_normalized_type)_class_global, "@(field.name)", "L@(list_jni_type);");
  jobject _jarray_list_@(field.name)_obj = env->NewObject(_j@(array_list_normalized_type)_class_global, _j@(array_list_normalized_type)_constructor_global);

@[          if field.type.array_size and not field.type.is_upper_bound]@
  for (size_t i = 0; i < @(field.type.array_size); ++i) {
    jobject _jlist_@(field.name)_element = _j@(normalized_type)_to_java_function(&(_ros_message->@(field.name)[i]), nullptr);
@[          else]@
  for (size_t i = 0; i < _ros_message->@(field.name).size; ++i) {
    jobject _jlist_@(field.name)_element = _j@(normalized_type)_to_java_function(&(_ros_message->@(field.name).data[i]), nullptr);
@[          end if]@
    // TODO(esteve): replace ArrayList with a jobjectArray to initialize the array beforehand
    jmethodID _jlist_@(field.name)_add_mid = env->GetMethodID(_j@(array_list_normalized_type)_class_global, "add", "(Ljava/lang/Object;)Z");
    if (_jlist_@(field.name)_element != nullptr) {
      jboolean _jlist_@(field.name)_add_result = env->CallBooleanMethod(_jarray_list_@(field.name)_obj, _jlist_@(field.name)_add_mid, _jlist_@(field.name)_element);
      assert(_jlist_@(field.name)_add_result);
    }
  }
@[        end if]@
  env->SetObjectField(_jmessage_obj, _jfield_@(field.name)_fid, _jarray_list_@(field.name)_obj);
  env->DeleteLocalRef(_jarray_list_@(field.name)_obj);
@[    else]@
@[        if field.type.is_primitive_type()]@
@[            if field.type.type == 'string']@
  auto _jfield_@(field.name)_fid = env->GetFieldID(_j@(msg_normalized_type)_class_global, "@(field.name)", "Ljava/lang/String;");
  if (_ros_message->@(field.name).data != nullptr) {
    env->SetObjectField(_jmessage_obj, _jfield_@(field.name)_fid, env->NewStringUTF(_ros_message->@(field.name).data));
  }
@[            else]@
@{
jni_signature = get_jni_signature(field.type)
set_method_name = 'Set%sField' % get_java_type(field.type, use_primitives=True).capitalize()
}@
  auto _jfield_@(field.name)_fid = env->GetFieldID(_j@(msg_normalized_type)_class_global, "@(field.name)", "@(jni_signature)");
  env->@(set_method_name)(_jmessage_obj, _jfield_@(field.name)_fid, _ros_message->@(field.name));
@[            end if]@
@[        else]@
  auto _jfield_@(field.name)_fid = env->GetFieldID(
    _j@(msg_normalized_type)_class_global, "@(field.name)", "L@(field.type.pkg_name)/msg/@(field.type.type);");
  assert(_jfield_@(field.name)_fid != nullptr);

  jobject _jfield_@(field.name)_obj = _j@(normalized_type)_to_java_function(&(_ros_message->@(field.name)), nullptr);

  env->SetObjectField(_jmessage_obj, _jfield_@(field.name)_fid, _jfield_@(field.name)_obj);
@[        end if]@
@[    end if]@
@[end for]@
  assert(_jmessage_obj != nullptr);
  return _jmessage_obj;
}

JNIEXPORT jint JNICALL JNI_OnLoad(JavaVM * vm, void *)
{
  // Can only call this once
  if (g_vm == nullptr) {
    g_vm = vm;
  }

  JNIEnv * env;
  if (g_vm->GetEnv(reinterpret_cast<void **>(&env), JNI_VERSION_1_6) != JNI_OK) {
    return JNI_ERR;
  } else {
@[for normalized_type, jni_type in cache.items()]@
    auto _j@(normalized_type)_class_local = env->FindClass("@(jni_type)");
    assert(_j@(normalized_type)_class_local != nullptr);
    _j@(normalized_type)_class_global = static_cast<jclass>(env->NewGlobalRef(_j@(normalized_type)_class_local));
    env->DeleteLocalRef(_j@(normalized_type)_class_local);
    assert(_j@(normalized_type)_class_global != nullptr);
@[if constructor_signatures[jni_type]]@
    _j@(normalized_type)_constructor_global = env->GetMethodID(_j@(normalized_type)_class_global, "<init>", "@(constructor_signatures[jni_type])");
    assert(_j@(normalized_type)_constructor_global != nullptr);
@[end if]@
@{
value_method = value_methods.get(jni_type)
if value_method:
    value_method_name, value_method_signature = value_method
}@
@[    if value_method]@
    _j@(normalized_type)_value_global = env->GetMethodID(_j@(normalized_type)_class_global, "@(value_method_name)", "@(value_method_signature)");
    assert(_j@(normalized_type)_value_global != nullptr);
@[    end if]@
@[    if jni_type in non_primitive_types]@
    _j@(normalized_type)_from_java_converter_global = env->GetStaticMethodID(
      _j@(normalized_type)_class_global, "getFromJavaConverter", "()J");
    assert(_j@(normalized_type)_from_java_converter_global != nullptr);

    _j@(normalized_type)_from_java_converter_ptr_global = env->CallStaticLongMethod(
      _j@(normalized_type)_class_global, _j@(normalized_type)_from_java_converter_global);
    assert(_j@(normalized_type)_from_java_converter_ptr_global != 0);

    _j@(normalized_type)_from_java_function =
      reinterpret_cast<_j@(normalized_type)_from_java_signature>(_j@(normalized_type)_from_java_converter_ptr_global);
    assert(_j@(normalized_type)_from_java_function != nullptr);

    _j@(normalized_type)_to_java_converter_global = env->GetStaticMethodID(
      _j@(normalized_type)_class_global, "getToJavaConverter", "()J");
    assert(_j@(normalized_type)_to_java_converter_global != nullptr);

    _j@(normalized_type)_to_java_converter_ptr_global = env->CallStaticLongMethod(
      _j@(normalized_type)_class_global, _j@(normalized_type)_to_java_converter_global);
    assert(_j@(normalized_type)_to_java_converter_ptr_global != 0);

    _j@(normalized_type)_to_java_function =
      reinterpret_cast<_j@(normalized_type)_to_java_signature>(_j@(normalized_type)_to_java_converter_ptr_global);
    assert(_j@(normalized_type)_to_java_function != nullptr);
@[    end if]@
@[end for]@
  }
  return JNI_VERSION_1_6;
}

JNIEXPORT void JNICALL JNI_OnUnload(JavaVM * vm, void *)
{
  assert(g_vm != nullptr);
  assert(g_vm == vm);

  JNIEnv * env;
  if (g_vm->GetEnv(reinterpret_cast<void **>(&env), JNI_VERSION_1_6) == JNI_OK) {
@[for normalized_type, jni_type in cache.items()]@
    if (_j@(normalized_type)_class_global != nullptr) {
      env->DeleteGlobalRef(_j@(normalized_type)_class_global);
      _j@(normalized_type)_class_global = nullptr;
@[    if constructor_signatures[jni_type]]@
      _j@(normalized_type)_constructor_global = nullptr;
@[    end if]@
@[    if value_methods.get(jni_type)]@
      _j@(normalized_type)_value_global = nullptr;
@[    end if]@
@[    if jni_type in non_primitive_types]@
      _j@(normalized_type)_from_java_converter_global = nullptr;
      _j@(normalized_type)_from_java_converter_ptr_global = 0;
      _j@(normalized_type)_from_java_function = nullptr;

      _j@(normalized_type)_to_java_converter_global = nullptr;
      _j@(normalized_type)_to_java_converter_ptr_global = 0;
      _j@(normalized_type)_to_java_function = nullptr;
@[    end if]@
    }
@[end for]@
  }
}

JNIEXPORT jlong JNICALL Java_@(jni_package_name)_@(subfolder)_@(jni_type_name)_getFromJavaConverter(JNIEnv *, jclass)
{
  jlong ptr = reinterpret_cast<jlong>(&@(spec.base_type.pkg_name)_@(type_name)__convert_from_java);
  return ptr;
}

JNIEXPORT jlong JNICALL Java_@(jni_package_name)_@(subfolder)_@(jni_type_name)_getToJavaConverter(JNIEnv *, jclass)
{
  jlong ptr = reinterpret_cast<jlong>(@(spec.base_type.pkg_name)_@(type_name)__convert_to_java);
  return ptr;
}

JNIEXPORT jlong JNICALL Java_@(jni_package_name)_@(subfolder)_@(jni_type_name)_getTypeSupport(JNIEnv *, jclass)
{
  jlong ptr = reinterpret_cast<jlong>(ROSIDL_GET_MSG_TYPE_SUPPORT(@(spec.base_type.pkg_name), @(subfolder), @(spec.msg_name)));
  return ptr;
}

JNIEXPORT jlong JNICALL Java_@(jni_package_name)_@(subfolder)_@(jni_type_name)_getDestructor(JNIEnv *, jclass)
{
  jlong ptr = reinterpret_cast<jlong>(@(msg_normalized_type)__destroy);
  return ptr;
}
