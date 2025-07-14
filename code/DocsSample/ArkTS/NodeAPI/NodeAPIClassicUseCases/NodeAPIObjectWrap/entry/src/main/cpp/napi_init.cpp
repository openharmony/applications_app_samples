/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

// [Start module_registration]
#include "hilog/log.h"
#include "napi/native_api.h"

class MyObject {
public:
    static napi_value Init(napi_env env, napi_value exports);
    static void Destructor(napi_env env, void *nativeObject, void *finalizeHint);

private:
    explicit MyObject(double value = 0);
    ~MyObject();

    static napi_value New(napi_env env, napi_callback_info info);
    static napi_value GetValue(napi_env env, napi_callback_info info);
    static napi_value SetValue(napi_env env, napi_callback_info info);
    static napi_value PlusOne(napi_env env, napi_callback_info info);

    double value_;
    napi_env env_;
    napi_ref wrapper_;
};

static thread_local napi_ref g_ref = nullptr;

MyObject::MyObject(double value) : value_(value), env_(nullptr), wrapper_(nullptr) {}

MyObject::~MyObject() { napi_delete_reference(env_, wrapper_); }

void MyObject::Destructor(napi_env env, void *nativeObject, [[maybe_unused]] void *finalizeHint)
{
    OH_LOG_INFO(LOG_APP, "MyObject::Destructor called");
    delete reinterpret_cast<MyObject *>(nativeObject);
}

// [StartExclude module_registration]
// [Start bind_object]
napi_value MyObject::New(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "MyObject::New called");

    napi_value newTarget;
    napi_get_new_target(env, info, &newTarget);
    if (newTarget != nullptr) {
        // 使用`new MyObject(...)`调用方式
        size_t argc = 1;
        napi_value args[1];
        napi_value jsThis;
        napi_get_cb_info(env, info, &argc, args, &jsThis, nullptr);

        double value = 0.0;
        napi_valuetype valuetype;
        napi_typeof(env, args[0], &valuetype);
        if (valuetype != napi_undefined) {
            napi_get_value_double(env, args[0], &value);
        }

        MyObject *obj = new MyObject(value);

        obj->env_ = env;
        // 通过napi_wrap将ArkTS对象jsThis与C++对象obj绑定
        napi_status status = napi_wrap(env, jsThis, reinterpret_cast<void *>(obj), MyObject::Destructor,
                                       nullptr, // finalizeHint
                                       &obj->wrapper_);
        // napi_wrap失败时，必须手动释放已分配的内存，以防止内存泄漏
        if (status != napi_ok) {
            OH_LOG_INFO(LOG_APP,
                        "Failed to bind native object to js object"
                        ", return code: %{public}d",
                        status);
            delete obj;
            return jsThis;
        }
        // 从napi_wrap接口的result获取napi_ref的行为，将会为jsThis创建强引用，
        // 若开发者不需要主动管理jsThis的生命周期，可直接在napi_wrap最后一个参数中传入nullptr，
        // 或者使用napi_reference_unref方法将napi_ref转为弱引用。
        uint32_t refCount = 0;
        napi_reference_unref(env, obj->wrapper_, &refCount);

        return jsThis;
    } else {
        // 使用`MyObject(...)`调用方式
        size_t argc = 1;
        napi_value args[1];
        napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

        napi_value cons;
        napi_get_reference_value(env, g_ref, &cons);
        napi_value instance;
        napi_new_instance(env, cons, argc, args, &instance);

        return instance;
    }
}
// [End bind_object]

// [Start extract_and_operate_object]
napi_value MyObject::GetValue(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "MyObject::GetValue called");

    napi_value jsThis;
    napi_get_cb_info(env, info, nullptr, nullptr, &jsThis, nullptr);

    MyObject *obj;
    // 通过napi_unwrap将jsThis之前绑定的C++对象取出，并对其进行操作
    napi_unwrap(env, jsThis, reinterpret_cast<void **>(&obj));
    napi_value num;
    napi_create_double(env, obj->value_, &num);

    return num;
}

napi_value MyObject::SetValue(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "MyObject::SetValue called");

    size_t argc = 1;
    napi_value value;
    napi_value jsThis;

    napi_get_cb_info(env, info, &argc, &value, &jsThis, nullptr);

    MyObject *obj;
    // 通过napi_unwrap将jsThis之前绑定的C++对象取出，并对其进行操作
    napi_unwrap(env, jsThis, reinterpret_cast<void **>(&obj));
    napi_get_value_double(env, value, &obj->value_);

    return nullptr;
}

napi_value MyObject::PlusOne(napi_env env, napi_callback_info info)
{
    OH_LOG_INFO(LOG_APP, "MyObject::PlusOne called");

    napi_value jsThis;
    napi_get_cb_info(env, info, nullptr, nullptr, &jsThis, nullptr);

    MyObject *obj;
    // 通过napi_unwrap将jsThis之前绑定的C++对象取出，并对其进行操作
    napi_unwrap(env, jsThis, reinterpret_cast<void **>(&obj));
    obj->value_ += 1;
    napi_value num;
    napi_create_double(env, obj->value_, &num);

    return num;
}
// [End extract_and_operate_object]
// [EndExclude module_registration]

napi_value MyObject::Init(napi_env env, napi_value exports)
{
    napi_property_descriptor properties[] = {
        {"value", 0, 0, GetValue, SetValue, 0, napi_default, 0},
        {"plusOne", nullptr, PlusOne, nullptr, nullptr, nullptr, napi_default, nullptr}};

    napi_value cons;
    const int propertyCount = 2;
    napi_define_class(env, "MyObject", NAPI_AUTO_LENGTH, New, nullptr, propertyCount, properties, &cons);

    napi_create_reference(env, cons, 1, &g_ref);
    napi_set_named_property(env, exports, "MyObject", cons);
    return exports;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    MyObject::Init(env, exports);
    return exports;
}
EXTERN_C_END

static napi_module nativeModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "entry",
    .nm_priv = nullptr,
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterObjectWrapModule() { napi_module_register(&nativeModule); }
// [End module_registration]