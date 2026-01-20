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
 * WITHOUT WARRANTIES OR CONDITIONS OF InputStyle KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// [Start input_case_input_CPreview016]
#include "napi/native_api.h"
#include <codecvt>
#include <locale>
#include <thread>

#include "hilog/log.h"
#include "inputmethod/inputmethod_controller_capi.h"

 constexpr int32_t TEXTSIZE = 1024;

static std::string g_strText;
char g_strTextChar[TEXTSIZE];
int32_t g_strTextCharLen = 0;
bool g_flagShow = false;
std::mutex g_textMutex;
InputMethod_TextEditorProxy *textEditorProxy = nullptr;
InputMethod_AttachOptions *attachOptions = nullptr;
InputMethod_InputMethodProxy *inputMethodProxy = nullptr;

void InputMethodDestroy();

void InitText()
{
    std::lock_guard<std::mutex> lock(g_textMutex);
    if (g_flagShow) {
        memset(g_strTextChar, 0x00, sizeof(g_strTextChar));
        g_strTextCharLen = 0;
        g_flagShow = false;
    }
}

void SetText(const char* input)
{
    std::lock_guard<std::mutex> lock(g_textMutex);
    g_strTextCharLen = strlen(input);
    if (g_strTextCharLen > TEXTSIZE) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "testTag", "Length greater than 1024 , ret=%{public}d", g_strTextCharLen);
    }
    strncpy(g_strTextChar, input, g_strTextCharLen);
}

void GetTextConfigFunc(InputMethod_TextEditorProxy *proxy, InputMethod_TextConfig *config)
{ // 处理获取输入框配置请求
    auto ret = OH_TextConfig_SetEnterKeyType(config, InputMethod_EnterKeyType::IME_ENTER_KEY_SEND);
    if (ret != IME_ERR_OK) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "testTag", "SetEnterKeyType failed, ret=%{public}d", ret);
        return;
    }

    ret = OH_TextConfig_SetInputType(config, InputMethod_TextInputType::IME_TEXT_INPUT_TYPE_PHONE);
    if (ret != IME_ERR_OK) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "testTag", "SetInputType failed, ret=%{public}d", ret);
        return;
    }
}

void InsertTextFunc(InputMethod_TextEditorProxy *proxy, const char16_t *text, size_t length)
{
    InitText();

    // 处理插入文本请求
    // 将char16_t类型的字符串转换为u16string
    std::u16string u16Str(text, length + 1);

    // 转换为UTF-8编码的string
    std::wstring_convert<std::codecvt_utf8_utf16<char16_t>, char16_t> converter;
    std::string utf8Str = converter.to_bytes(u16Str);
    for (size_t i = 0; i < utf8Str.size(); ++i) {
        unsigned char c = static_cast<unsigned char>(utf8Str[i]);
        if (c != 0x00) {
            std::lock_guard<std::mutex> lock(g_textMutex);
            g_strTextChar[g_strTextCharLen] = c;
            g_strTextCharLen += 1;
        }
    }
}

void DeleteForwardFunc(InputMethod_TextEditorProxy *proxy, int32_t length)
{
    std::lock_guard<std::mutex> lock(g_textMutex);
    if (g_strTextCharLen > 0) {
        strncpy(g_strTextChar, g_strTextChar + 1, g_strTextCharLen - 1);
        g_strTextCharLen = (g_strTextCharLen > 0) ? g_strTextCharLen - 1 : g_strTextCharLen;
    }
}

void DeleteBackwardFunc(InputMethod_TextEditorProxy *proxy, int32_t length)
{
    std::lock_guard<std::mutex> lock(g_textMutex);
    g_strTextCharLen = (g_strTextCharLen > 0) ? g_strTextCharLen - 1 : g_strTextCharLen;
    g_strTextChar[g_strTextCharLen] = '\0';
}

void SendKeyboardStatusFunc(InputMethod_TextEditorProxy *proxy, InputMethod_KeyboardStatus status)
{
    if (status == InputMethod_KeyboardStatus::IME_KEYBOARD_STATUS_HIDE) {
        g_flagShow = false;
        SetText("键盘已经被隐藏");
    } else if (status == InputMethod_KeyboardStatus::IME_KEYBOARD_STATUS_SHOW && g_flagShow != true) {
        g_flagShow = true;
        SetText("键盘已经被拉起");
    }
}

void SendEnterKeyFunc(InputMethod_TextEditorProxy *proxy, InputMethod_EnterKeyType type)
{
    SetText("处理回车键请求事件");
    g_flagShow = true;
}

void MoveCursorFunc(InputMethod_TextEditorProxy *proxy, InputMethod_Direction direction)
{
    if (direction == InputMethod_Direction::IME_DIRECTION_UP) {
        SetText("光标正在向 上 移动");
    } else if (direction == InputMethod_Direction::IME_DIRECTION_DOWN) {
        SetText("光标正在向 下 移动");
    } else if (direction == InputMethod_Direction::IME_DIRECTION_LEFT) {
        SetText("光标正在向 左 移动");
    } else if (direction == InputMethod_Direction::IME_DIRECTION_RIGHT) {
        SetText("光标正在向 右  移动");
    } else {
        SetText("光标移动 出现错误");
    }
}

void HandleSetSelectionFunc(InputMethod_TextEditorProxy *proxy, int32_t start, int32_t end)
{
    SetText("处理选中文本请求");
}

void HandleExtendActionFunc(InputMethod_TextEditorProxy *proxy, InputMethod_ExtendAction action)
{
    SetText("处理扩展编辑请求");
}

void GetLeftTextOfCursorFunc(InputMethod_TextEditorProxy *proxy, int32_t number, char16_t text[], size_t *length)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag", "处理获取光标左侧文本请求  ...");
}

void GetRightTextOfCursorFunc(InputMethod_TextEditorProxy *proxy, int32_t number, char16_t text[], size_t *length)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag", "处理获取光标右侧文本请求  ...");
}

int32_t GetTextIndexAtCursorFunc(InputMethod_TextEditorProxy *proxy)
{
    OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag", "处理获取光标所在输入框文本索引请求  ...");
    return 0;
}
int32_t ReceivePrivateCommandFunc(InputMethod_TextEditorProxy *proxy, InputMethod_PrivateCommand *privateCommand[],
    size_t size)
{
    SetText("处理扩展编辑请求");
    return 0;
}

int32_t SetPreviewTextFunc(InputMethod_TextEditorProxy *proxy, const char16_t *text, size_t length, int32_t start,
    int32_t end)
{
    SetText("处理设置预上屏文本请求");
    return 0;
}

void FinishTextPreviewFunc(InputMethod_TextEditorProxy *proxy)
{
    SetText("处理结束预上屏请求");
}

void ConstructTextEditorProxy(InputMethod_TextEditorProxy *textEditorProxy)
{
    // [Start input_case_input_ConstructTextEditorProxy]
    OH_TextEditorProxy_SetGetTextConfigFunc(textEditorProxy, GetTextConfigFunc);
    OH_TextEditorProxy_SetInsertTextFunc(textEditorProxy, InsertTextFunc);
    OH_TextEditorProxy_SetDeleteForwardFunc(textEditorProxy, DeleteForwardFunc);
    OH_TextEditorProxy_SetDeleteBackwardFunc(textEditorProxy, DeleteBackwardFunc);
    OH_TextEditorProxy_SetSendKeyboardStatusFunc(textEditorProxy, SendKeyboardStatusFunc);
    OH_TextEditorProxy_SetSendEnterKeyFunc(textEditorProxy, SendEnterKeyFunc);
    OH_TextEditorProxy_SetMoveCursorFunc(textEditorProxy, MoveCursorFunc);
    OH_TextEditorProxy_SetHandleSetSelectionFunc(textEditorProxy, HandleSetSelectionFunc);
    OH_TextEditorProxy_SetHandleExtendActionFunc(textEditorProxy, HandleExtendActionFunc);
    OH_TextEditorProxy_SetGetLeftTextOfCursorFunc(textEditorProxy, GetLeftTextOfCursorFunc);
    OH_TextEditorProxy_SetGetRightTextOfCursorFunc(textEditorProxy, GetRightTextOfCursorFunc);
    OH_TextEditorProxy_SetGetTextIndexAtCursorFunc(textEditorProxy, GetTextIndexAtCursorFunc);
    OH_TextEditorProxy_SetReceivePrivateCommandFunc(textEditorProxy, ReceivePrivateCommandFunc);
    OH_TextEditorProxy_SetSetPreviewTextFunc(textEditorProxy, SetPreviewTextFunc);
    OH_TextEditorProxy_SetFinishTextPreviewFunc(textEditorProxy, FinishTextPreviewFunc);
    // [End input_case_input_ConstructTextEditorProxy]
}
// [End input_case_input_CPreview016]

// [Start input_case_input_CPreview208]
void InputMethodNdkDemo()
{
    // [Start input_case_input_TextEditorProxy]
    // 创建InputMethod_TextEditorProxy实例
    textEditorProxy = OH_TextEditorProxy_Create();
    // [End input_case_input_TextEditorProxy]
    if (textEditorProxy == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "testTag", "Create TextEditorProxy failed.");
        return;
    }

    // 将实现好的响应处理函数设置到InputMethod_TextEditorProxy中
    ConstructTextEditorProxy(textEditorProxy);

    // [Start input_case_input_attachOptions]
    // 创建InputMethod_AttachOptions实例，选项showKeyboard用于指定此次绑定成功后是否显示键盘，此处以目标显示键盘为例
    bool showKeyboard = true;
    attachOptions = OH_AttachOptions_Create(showKeyboard);
    // [End input_case_input_attachOptions]
    if (attachOptions == nullptr) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "testTag", "Create AttachOptions failed.");
        OH_TextEditorProxy_Destroy(textEditorProxy);
        return;
    }

    // [Start input_case_input_OH_InputMethodController_Attach]
    // 发起绑定请求
    auto ret = OH_InputMethodController_Attach(textEditorProxy, attachOptions, &inputMethodProxy);
    if (ret != IME_ERR_OK) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "testTag", "Attach failed, ret=%{public}d.", ret);
        OH_TextEditorProxy_Destroy(textEditorProxy);
        OH_AttachOptions_Destroy(attachOptions);
        return;
    }
    // [End input_case_input_OH_InputMethodController_Attach]
}

static napi_value InputMethodDestroy(napi_env env, napi_callback_info info)
{
   // 隐藏键盘
    int ret = OH_InputMethodProxy_HideKeyboard(inputMethodProxy);
    if (ret != IME_ERR_OK) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, 0, "testTag", "HideKeyboard failed, ret=%{public}d.", ret);
        OH_TextEditorProxy_Destroy(textEditorProxy);
        OH_AttachOptions_Destroy(attachOptions);
        return nullptr;
    }

    // [Start input_case_input_OH_InputMethodController_Detach]
    // 发起解绑请求
    OH_InputMethodController_Detach(inputMethodProxy);
    OH_TextEditorProxy_Destroy(textEditorProxy);
    OH_AttachOptions_Destroy(attachOptions);
    // [End input_case_input_OH_InputMethodController_Detach]
    OH_LOG_Print(LOG_APP, LOG_INFO, 0, "testTag", "Finished.");
    return nullptr;
}


static napi_value AttachInputMethod(napi_env env, napi_callback_info info)
{
    InputMethodNdkDemo();

    napi_value result;
    napi_create_string_utf8(env,  g_strText.c_str(),  g_strText.length(),  &result);
    return result;
}

static napi_value GetText(napi_env env, napi_callback_info info)
{
    napi_value result;
    napi_create_string_utf8(env, g_strTextChar, g_strTextCharLen,  &result);
    return result;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        { "attachInputMethod", nullptr, AttachInputMethod, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "getText", nullptr, GetText, nullptr, nullptr, nullptr, napi_default, nullptr },
        { "inputMethodDestroy", nullptr, InputMethodDestroy, nullptr, nullptr, nullptr, napi_default, nullptr },
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
    .nm_priv = ((void*)0),
    .reserved = { 0 },
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&demoModule);
}
// [End input_case_input_CPreview208]