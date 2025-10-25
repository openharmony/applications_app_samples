// entry/src/main/cpp/napi_init.cpp
#include "napi/native_api.h"
#include "NativeEntry.h"



EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    // 绑定Native侧的创建组件和销毁组件。
    napi_property_descriptor desc[] = {
        {"createNodeTreeOnMultiThread", nullptr, NativeModule::CreateNodeTreeOnMultiThread, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"createCustomPropertyDemo", nullptr, NativeModule::CreateCustomPropertyDemo, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"createNodeAdapterDemo", nullptr, NativeModule::CreateNodeAdapterDemo, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"disposeNodeTree", nullptr, NativeModule::DisposeNodeTree, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"destroyNativeRoot", nullptr, NativeModule::DestroyNativeRoot, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"getContext", nullptr, NativeModule::GetContext, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getNodeHandle", nullptr, NativeModule::GetNodeHandle, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getNodeHandleById", nullptr, NativeModule::GetNodeHandleById, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"getNodeHandleByUniqueId", nullptr, NativeModule::GetNodeHandleByUniqueId, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"CreateDrawNode", nullptr, NativeModule::CreateDrawNode, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"CreateNativeRoot", nullptr, NativeModule::CreateNativeRoot, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"DestroyNativeRoot", nullptr, NativeModule::DestroyNativeRoot, nullptr, nullptr, nullptr,
         napi_default, nullptr},
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "entry",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) { napi_module_register(&demoModule); }