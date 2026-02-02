/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
// [Start define_customNativeObject]
// napi_init.cpp
#include <mutex>
#include <unordered_set>
#include "napi/native_api.h"
#include <hilog/log.h>

class CustomNativeObject {
public:
    CustomNativeObject() {}
    ~CustomNativeObject() = default;
    static CustomNativeObject& GetInstance()
    {
        static CustomNativeObject instance;
        return instance;
    }

    static napi_value GetAddress(napi_env env, napi_callback_info info)
    {
        napi_value thisVar = nullptr;
        napi_get_cb_info(env, info, nullptr, nullptr, &thisVar, nullptr);
        if (thisVar == nullptr) {
            return nullptr;
        }
        void* object = nullptr;
        napi_unwrap(env, thisVar, &object);
        if (object == nullptr) {
            return nullptr;
        }
        
        uint64_t addressVal = reinterpret_cast<uint64_t>(object);
        napi_value address = nullptr;
        napi_create_bigint_uint64(env, addressVal, &address);
        return address;
    }

    // 获取数组大小
    static napi_value GetSetSize(napi_env env, napi_callback_info info)
    {
        napi_value thisVar = nullptr;
        napi_get_cb_info(env, info, nullptr, nullptr, &thisVar, nullptr);
        if (thisVar == nullptr) {
            return nullptr;
        }
        void* object = nullptr;
        napi_unwrap(env, thisVar, &object);
        if (object == nullptr) {
            return nullptr;
        }
        CustomNativeObject* obj = static_cast<CustomNativeObject*>(object);
        std::lock_guard<std::mutex> lock(obj->numberSetMutex_);
        uint32_t setSize = reinterpret_cast<CustomNativeObject*>(object)->numberSet_.size();
        napi_value napiSize = nullptr;
        napi_create_uint32(env, setSize, &napiSize);
        return napiSize;
    }

    // 往数组里插入元素
    static napi_value Store(napi_env env, napi_callback_info info)
    {
        size_t argc = 1;
        napi_value args[1] = {nullptr};
        napi_value thisVar = nullptr;
        napi_get_cb_info(env, info, &argc, args, &thisVar, nullptr);
        if (argc != 1) {
            napi_throw_error(env, nullptr, "Store args number must be one.");
            return nullptr;
        }
        napi_valuetype type = napi_undefined;
        napi_typeof(env, args[0], &type);
        if (type != napi_number) {
            napi_throw_error(env, nullptr, "Store args is not number.");
            return nullptr;
        }
        if (thisVar == nullptr) {
            return nullptr;
        }
        
        void* object = nullptr;
        napi_unwrap(env, thisVar, &object);
        if (object == nullptr) {
            return nullptr;
        }
        
        uint32_t value = 0;
        napi_get_value_uint32(env, args[0], &value);
        CustomNativeObject* obj = static_cast<CustomNativeObject*>(object);
        std::lock_guard<std::mutex> lock(obj->numberSetMutex_);
        reinterpret_cast<CustomNativeObject *>(object)->numberSet_.insert(value);
        return nullptr;
    }

    // 删除数组元素
    static napi_value Erase(napi_env env, napi_callback_info info)
    {
        size_t argc = 1;
        napi_value args[1] = {nullptr};
        napi_value thisVar = nullptr;
        napi_get_cb_info(env, info, &argc, args, &thisVar, nullptr);
        if (argc != 1) {
            napi_throw_error(env, nullptr, "Erase args number must be one.");
            return nullptr;
        }
        napi_valuetype type = napi_undefined;
        napi_typeof(env, args[0], &type);
        if (type != napi_number) {
            napi_throw_error(env, nullptr, "Erase args is not number.");
            return nullptr;
        }
        if (thisVar == nullptr) {
            return nullptr;
        }
        
        void* object = nullptr;
        napi_unwrap(env, thisVar, &object);
        if (object == nullptr) {
            return nullptr;
        }
        
        uint32_t value = 0;
        napi_get_value_uint32(env, args[0], &value);
        
        CustomNativeObject* obj = static_cast<CustomNativeObject*>(object);
        std::lock_guard<std::mutex> lock(obj->numberSetMutex_);
        reinterpret_cast<CustomNativeObject *>(object)->numberSet_.erase(value);
        return nullptr;
    }

    // 清空数组
    static napi_value Clear(napi_env env, napi_callback_info info)
    {
        napi_value thisVar = nullptr;
        napi_get_cb_info(env, info, nullptr, nullptr, &thisVar, nullptr);
        if (thisVar == nullptr) {
            return nullptr;
        }
        void* object = nullptr;
        napi_unwrap(env, thisVar, &object);
        if (object == nullptr) {
            return nullptr;
        }
        CustomNativeObject* obj = static_cast<CustomNativeObject*>(object);
        std::lock_guard<std::mutex> lock(obj->numberSetMutex_);
        reinterpret_cast<CustomNativeObject *>(object)->numberSet_.clear();
        return nullptr;
    }
    
    // 设置传输模式
    static napi_value SetTransferDetached(napi_env env, napi_callback_info info)
    {
        size_t argc = 1;
        napi_value args[1];
        napi_value thisVar;
        napi_get_cb_info(env, info, &argc, args, &thisVar, nullptr);
        if (argc != 1) {
            napi_throw_error(env, nullptr, "SetTransferDetached args number must be one.");
            return nullptr;
        }
        
        if (thisVar == nullptr) {
            return nullptr;
        }
        
        napi_valuetype type = napi_undefined;
        napi_typeof(env, args[0], &type);
        if (type != napi_boolean) {
            napi_throw_error(env, nullptr, "SetTransferDetached args is not boolean.");
            return nullptr;
        }
        
        bool isDetached;
        napi_get_value_bool(env, args[0], &isDetached);
        
        void* object = nullptr;
        napi_unwrap(env, thisVar, &object);
        if (object == nullptr) {
            return nullptr;
        }
        CustomNativeObject* obj = static_cast<CustomNativeObject*>(object);
        std::lock_guard<std::mutex> lock(obj->numberSetMutex_);
        obj->isDetached_ = isDetached;
        return nullptr;
    }
    
    bool isDetached_ = false;

private:
    CustomNativeObject(const CustomNativeObject &) = delete;
    CustomNativeObject &operator=(const CustomNativeObject &) = delete;

    std::unordered_set<uint32_t> numberSet_{};
    std::mutex numberSetMutex_{};
};

void FinalizeCallback(napi_env env, void *data, void *hint)
{
    return;
}

// 解绑回调，在序列化时调用，可在对象解绑时执行一些清理操作
void* DetachCallback(napi_env env, void *value, void *hint)
{
    if (hint == nullptr) {
        return value;
    }
    napi_value jsObject = nullptr;
    napi_get_reference_value(env, reinterpret_cast<napi_ref>(hint), &jsObject);
    void* object = nullptr;
    if (static_cast<CustomNativeObject*>(value)->isDetached_) {
        napi_remove_wrap(env, jsObject, &object);
    }
    return value;
}

// 绑定回调，在反序列化时调用
napi_value AttachCallback(napi_env env, void* value, void* hint)
{
    napi_value object = nullptr;
    napi_create_object(env, &object);
    napi_property_descriptor desc[] = {
        {"getAddress", nullptr, CustomNativeObject::GetAddress, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getSetSize", nullptr, CustomNativeObject::GetSetSize, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"store", nullptr, CustomNativeObject::Store, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"erase", nullptr, CustomNativeObject::Erase, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"clear", nullptr, CustomNativeObject::Clear, nullptr, nullptr, nullptr, napi_default, nullptr}};
    napi_define_properties(env, object, sizeof(desc) / sizeof(desc[0]), desc);
    // 将JS对象object和native对象value生命周期进行绑定
    napi_wrap(env, object, value, FinalizeCallback, nullptr, nullptr);
    // JS对象携带native信息
    napi_coerce_to_native_binding_object(env, object, DetachCallback, AttachCallback, value, nullptr);
    return object;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"getAddress", nullptr, CustomNativeObject::GetAddress, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getSetSize", nullptr, CustomNativeObject::GetSetSize, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"store", nullptr, CustomNativeObject::Store, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"erase", nullptr, CustomNativeObject::Erase, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"clear", nullptr, CustomNativeObject::Clear, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"setTransferDetached", nullptr, CustomNativeObject::SetTransferDetached,
            nullptr, nullptr, nullptr, napi_default, nullptr}};
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    auto &object = CustomNativeObject::GetInstance();
    napi_wrap(env, exports, reinterpret_cast<void*>(&object), FinalizeCallback, nullptr, nullptr);
    napi_ref exportsRef;
    napi_create_reference(env, exports, 1, &exportsRef);
    napi_coerce_to_native_binding_object(env, exports, DetachCallback,
        AttachCallback, reinterpret_cast<void*>(&object), exportsRef);
    return exports;
}
EXTERN_C_END

static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "entry",
    .nm_priv = ((void*)0),
    .reserved = { 0 },
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&demoModule);
}
// [End define_customNativeObject]