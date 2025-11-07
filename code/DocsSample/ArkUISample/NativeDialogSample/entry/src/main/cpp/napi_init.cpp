/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

#include "common/common.h"
#include "customdialog/customdialogexample.h"
#include "customdialog/nativedialogdemo.h"
#include <vector>
#include "napi/native_api.h"

namespace ArkUICapiTest {
EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "Init", "Init begins");
    if ((env == nullptr) || (exports == nullptr)) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Init", "env or exports is null");
        return nullptr;
    }

    napi_property_descriptor desc[] = {
        {"setNapiCallback", nullptr, CustomDialogTest::NAPI_Global_setNapiCallback, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"setCustomDialog", nullptr, CustomDialogTest::SetCustomDialog, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"Close", nullptr, CustomDialogTest::CloseDialog, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"CloseCustomDialog", nullptr, CustomDialogTest::CloseCustomDialog, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"openCustomDialog", nullptr, CustomDialogTest::OpenCustomDialog, nullptr, nullptr, nullptr, napi_default,
         nullptr},
        {"setNativeDialog", nullptr, CustomDialogTest::SetDialogController, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"openNativeDialog", nullptr, CustomDialogTest::OpenNativeDialog, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"resetDialogController", nullptr, CustomDialogTest::ResetDialogController, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"mainPageController", nullptr, Dialog_Demo::Dialog_Controller_Demo::BuildDemoPage, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"disposeController", nullptr, Dialog_Demo::Dialog_Controller_Demo::Dispose, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"mainPageOption", nullptr, Dialog_Demo::Dialog_Option_Demo::BuildDemoPage, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"disposeOption", nullptr, Dialog_Demo::Dialog_Option_Demo::Dispose, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"mainPageOptionText", nullptr, Dialog_Demo::Dialog_OptionText_Demo::BuildDemoPage, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"disposeOptionText", nullptr, Dialog_Demo::Dialog_OptionText_Demo::Dispose, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"mainPageLifecycle", nullptr, Dialog_Demo::Dialog_LifeCycle_Demo::BuildDemoPage, nullptr, nullptr, nullptr,
         napi_default, nullptr},
        {"disposeLifecycle", nullptr, Dialog_Demo::Dialog_LifeCycle_Demo::Dispose, nullptr, nullptr, nullptr,
         napi_default, nullptr},
    };
    if (napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc) != napi_ok) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_PRINT_DOMAIN, "Init", "napi_define_properties failed");
        return nullptr;
    }
    return exports;
}
EXTERN_C_END

static napi_module nativerenderModule = {.nm_version = 1,
                                         .nm_flags = 0,
                                         .nm_filename = nullptr,
                                         .nm_register_func = Init,
                                         .nm_modname = "nativerender",
                                         .nm_priv = ((void *)0),
                                         .reserved = {0}};

extern "C" __attribute__((constructor)) void RegisterModule(void) { napi_module_register(&nativerenderModule); }
} // namespace ArkUICapiTest
