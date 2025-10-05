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

#ifndef ARKUI_CAPI_CUSTOMDIALOG_EXAMPLE_H
#define ARKUI_CAPI_CUSTOMDIALOG_EXAMPLE_H

#include "../common/common.h"
#include "utils.h"
#include <js_native_api.h>
#include <js_native_api_types.h>
#include <string>

struct CallBackData {
    std::string willDismiss;
    std::string willAppear;
    std::string didAppear;
    std::string willDisappear;
    std::string didDisappear;
};

namespace ArkUICapiTest {
class CustomDialogTest {
public:
    ~CustomDialogTest() = default;

    static napi_value SetCustomDialog(napi_env env, napi_callback_info info);
    static int32_t SetCustomDialogDialogAttribute(int32_t nodeType = 0, uint32_t nodeValue = 0);

    static napi_value CloseDialog(napi_env env, napi_callback_info info);
    static napi_value CloseCustomDialog(napi_env env, napi_callback_info info);
    static napi_value OpenCustomDialog(napi_env env, napi_callback_info info);
    static CallBackData callBackData;

    static napi_value SetDialogController(napi_env env, napi_callback_info info);
    static napi_value OpenNativeDialog(napi_env env, napi_callback_info info);
    static napi_value ResetDialogController(napi_env env, napi_callback_info info);
    static int32_t SetDialogControllerAttribute(int32_t nodeType = 0, uint32_t nodeValue = 0);
    static int32_t OnEventReceiveTestAPI(int32_t nodeType = 0, uint32_t nodeValue = 0);

    static napi_value NAPI_Global_setNapiCallback(napi_env env, napi_callback_info info);
    static std::vector<napi_ref> g_callback_refs;
    static napi_env g_env;
};
}  // namespace ArkUICapiTest
#endif  //  ARKUI_CAPI_CUSTOMDIALOG_EXAMPLE_H
