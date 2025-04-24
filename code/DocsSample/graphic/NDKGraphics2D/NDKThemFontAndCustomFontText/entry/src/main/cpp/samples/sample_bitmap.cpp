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

#include <bits/alltypes.h>
#include <native_drawing/drawing_font_collection.h>
#include <native_drawing/drawing_text_typography.h>
#include <native_drawing/drawing_register_font.h>
#include <native_buffer/native_buffer.h>
#include <fstream>

#include "common/log_common.h"
#include "sample_bitmap.h"
#include "plugin/plugin_manager.h"

static void OnSurfaceCreatedCB(OH_NativeXComponent *component, void *window)
{
    DRAWING_LOGI("OnSurfaceCreatedCB");
    if ((component == nullptr) || (window == nullptr)) {
        DRAWING_LOGE("OnSurfaceCreatedCB: component or window is null");
        return;
    }
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {'\0'};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    if (OH_NativeXComponent_GetXComponentId(component, idStr, &idSize) != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        DRAWING_LOGE("OnSurfaceCreatedCB: Unable to get XComponent id");
        return;
    }
    std::string id(idStr);
    auto render = SampleBitMap::GetInstance(id);
    OHNativeWindow *nativeWindow = static_cast<OHNativeWindow *>(window);
    render->SetNativeWindow(nativeWindow);

    uint64_t width;
    uint64_t height;
    int32_t xSize = OH_NativeXComponent_GetXComponentSize(component, window, &width, &height);
    if ((xSize == OH_NATIVEXCOMPONENT_RESULT_SUCCESS) && (render != nullptr)) {
        render->SetHeight(height);
        render->SetWidth(width);
        DRAWING_LOGI("xComponent width = %{public}llu, height = %{public}llu", width, height);
    }
}

static void OnSurfaceDestroyedCB(OH_NativeXComponent *component, void *window)
{
    DRAWING_LOGI("OnSurfaceDestroyedCB");
    if ((component == nullptr) || (window == nullptr)) {
        DRAWING_LOGE("OnSurfaceDestroyedCB: component or window is null");
        return;
    }
    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {'\0'};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    if (OH_NativeXComponent_GetXComponentId(component, idStr, &idSize) != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        DRAWING_LOGE("OnSurfaceDestroyedCB: Unable to get XComponent id");
        return;
    }
    std::string id(idStr);
    SampleBitMap::Release(id);
}

static std::unordered_map<std::string, SampleBitMap *> g_instance;

void SampleBitMap::SetWidth(uint64_t width)
{
    width_ = width;
}

void SampleBitMap::SetHeight(uint64_t height)
{
    height_ = height;
}

void SampleBitMap::SetNativeWindow(OHNativeWindow *nativeWindow)
{
    nativeWindow_ = nativeWindow;
}

void SampleBitMap::Prepare()
{
    if (nativeWindow_ == nullptr) {
        DRAWING_LOGE("nativeWindow_ is nullptr");
        return;
    }
    // 这里的nativeWindow是从上一步骤中的回调函数中获得的
    int32_t usage = NATIVEBUFFER_USAGE_CPU_READ | NATIVEBUFFER_USAGE_CPU_WRITE | NATIVEBUFFER_USAGE_MEM_DMA;
    int ret = OH_NativeWindow_NativeWindowHandleOpt(nativeWindow_, SET_USAGE, usage);
    if (ret != 0) {
        DRAWING_LOGE("failed to OH_NativeWindow_NativeWindowHandleOpt");
        return;
    }
    // 通过 OH_NativeWindow_NativeWindowRequestBuffer 获取 OHNativeWindowBuffer 实例
    ret = OH_NativeWindow_NativeWindowRequestBuffer(nativeWindow_, &buffer_, &fenceFd_);
    DRAWING_LOGI("request buffer ret = %{public}d", ret);
    // 通过 OH_NativeWindow_GetBufferHandleFromNative 获取 buffer 的 handle
    bufferHandle_ = OH_NativeWindow_GetBufferHandleFromNative(buffer_);
    // 使用系统mmap接口拿到bufferHandle的内存虚拟地址
    mappedAddr_ = static_cast<uint32_t *>(
        mmap(bufferHandle_->virAddr, bufferHandle_->size, PROT_READ | PROT_WRITE, MAP_SHARED, bufferHandle_->fd, 0));
    if (mappedAddr_ == MAP_FAILED) {
        DRAWING_LOGE("mmap failed");
    }
}

void SampleBitMap::DisPlay()
{
    // 画完后获取像素地址，地址指向的内存包含画布画的像素数据
    void *bitmapAddr = OH_Drawing_BitmapGetPixels(cBitmap_);
    uint32_t *value = static_cast<uint32_t *>(bitmapAddr);

    uint32_t *pixel = static_cast<uint32_t *>(mappedAddr_); // 使用mmap获取到的地址来访问内存
    if (pixel == nullptr) {
        DRAWING_LOGE("pixel is null");
        return;
    }
    if (value == nullptr) {
        DRAWING_LOGE("value is null");
        return;
    }
    uint32_t width = static_cast<uint32_t>(bufferHandle_->stride / 4);
    for (uint32_t x = 0; x < width; x++) {
        for (uint32_t y = 0; y < height_; y++) {
            *pixel++ = *value++;
        }
    }
    // 设置刷新区域，如果Region中的Rect为nullptr,或者rectNumber为0，则认为OHNativeWindowBuffer全部有内容更改。
    Region region {nullptr, 0};
    // 通过OH_NativeWindow_NativeWindowFlushBuffer 提交给消费者使用，例如：显示在屏幕上。
    OH_NativeWindow_NativeWindowFlushBuffer(nativeWindow_, buffer_, fenceFd_, region);
    // 内存使用完记得去掉内存映射
    int result = munmap(mappedAddr_, bufferHandle_->size);
    if (result == -1) {
        DRAWING_LOGE("munmap failed!");
    }
}

void SampleBitMap::Create()
{
    uint32_t width = static_cast<uint32_t>(bufferHandle_->stride / 4);
    // 创建一个bitmap对象
    cBitmap_ = OH_Drawing_BitmapCreate();
    // 定义bitmap的像素格式
    OH_Drawing_BitmapFormat cFormat {COLOR_FORMAT_RGBA_8888, ALPHA_FORMAT_OPAQUE};
    // 构造对应格式的bitmap
    OH_Drawing_BitmapBuild(cBitmap_, width, height_, &cFormat);

    // 创建一个canvas对象
    cCanvas_ = OH_Drawing_CanvasCreate();
    // 将画布与bitmap绑定，画布画的内容会输出到绑定的bitmap内存中
    OH_Drawing_CanvasBind(cCanvas_, cBitmap_);
    // 使用白色清除画布内容
    OH_Drawing_CanvasClear(cCanvas_, OH_Drawing_ColorSetArgb(0xFF, 0xFF, 0xFF, 0xFF));
}

void SampleBitMap::DrawCustomFontText()
{
    OH_Drawing_FontCollection *fontCollection = OH_Drawing_CreateSharedFontCollection();
    // 后续使用自定义字体时，需使用到该字体家族名
    const char* fontFamily = "myFamilyName"; 
    // 该路径是待注册的自定义字体文件在应用设备下的路径，确保该自定义字体文件已正确放置在该路径下
    const char* fontPath = "/system/fonts/NotoSerifTamil[wdth,wght].ttf"; 
    std::ifstream fileStream(fontPath);
    fileStream.seekg(0, std::ios::end);
    uint32_t bufferSize = fileStream.tellg();
    fileStream.seekg(0, std::ios::beg);
    std::unique_ptr<uint8_t[]> buffer = std::make_unique<uint8_t[]>(bufferSize);
    fileStream.read(reinterpret_cast<char*>(buffer.get()), bufferSize);
    fileStream.close();
    // 返回0为成功，1为文件不存在，2为打开文件失败，3为读取文件失败，4为寻找文件失败，5为获取大小失败，9文件损坏
    int errorCode = OH_Drawing_RegisterFont(fontCollection, fontFamily, fontPath);
    // 用于在字体管理器中注册字体缓冲区
    uint32_t result = OH_Drawing_RegisterFontBuffer(fontCollection, fontFamily, buffer.get(), bufferSize);
    DRAWING_LOGI("errorCode = %{public}d  result = %{public}d", errorCode, result);
    OH_Drawing_TextStyle* textStyle = OH_Drawing_CreateTextStyle();
    // 如果已经注册成功自定义字体，填入自定义字体的字体家族名
    const char* myFontFamilies[] = {"myFamilyName"}; 
    // 加入可使用的自定义字体
    OH_Drawing_SetTextStyleFontFamilies(textStyle, 1, myFontFamilies);
    // 设置其他文本样式
    OH_Drawing_SetTextStyleColor(textStyle , OH_Drawing_ColorSetArgb(0xFF, 0x00, 0x00, 0x00));
    OH_Drawing_SetTextStyleFontSize(textStyle , 50.0);
    // 创建一个段落样式对象，以设置排版风格
    OH_Drawing_TypographyStyle *typographyStyle = OH_Drawing_CreateTypographyStyle();
    OH_Drawing_SetTypographyTextAlign(typographyStyle, TEXT_ALIGN_LEFT); // 设置段落样式为左对齐
    // 创建一个段落生成器
    OH_Drawing_TypographyCreate* handler = OH_Drawing_CreateTypographyHandler(typographyStyle, fontCollection);
    // 在段落生成器中设置文本样式
    OH_Drawing_TypographyHandlerPushTextStyle(handler, textStyle);
    // 在段落生成器中设置文本内容
    const char* text = "Hello World. 你好世界。\n以上文字使用了自定义字体";
    OH_Drawing_TypographyHandlerAddText(handler, text);
    // 通过段落生成器生成段落
    OH_Drawing_Typography* typography = OH_Drawing_CreateTypography(handler);
    // 设置页面最大宽度
    double maxWidth = width_;
    OH_Drawing_TypographyLayout(typography, maxWidth);
    // 设置文本在画布上绘制的起始位置
    double position[2] = {width_ / 5.0, height_ / 2.0};
    // 将文本绘制到画布上
    OH_Drawing_TypographyPaint(typography, cCanvas_, 0, 100);
}

void SampleBitMap::PrintSysFontMetrics()
{
    OH_Drawing_FontConfigInfoErrorCode fontConfigInfoErrorCode;  // 用于接收错误代码
    OH_Drawing_FontConfigInfo* fontConfigInfo = OH_Drawing_GetSystemFontConfigInfo(&fontConfigInfoErrorCode);
    if(fontConfigInfoErrorCode != SUCCESS_FONT_CONFIG_INFO) {
        OH_LOG_Print(LOG_APP, LOG_ERROR, LOG_DOMAIN, "PrintSysFontMetrics", "获取系统信息失败，错误代码为： %{public}d", fontConfigInfoErrorCode);
    }

    // 获取系统字体配置信息示例
    if (fontConfigInfo != nullptr) {
        // 获取字体文件路径数量，打印日志
        size_t fontDirCount = fontConfigInfo->fontDirSize;
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, "PrintSysFontMetrics", "字体文件路径数量为: %{public}zu\n", fontDirCount);
        // 遍历字体文件路径列表，打印日志
        for (size_t i = 0; i < fontDirCount; ++i) {
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, "PrintSysFontMetrics", "字体文件路径为: %{public}s\n",
                         fontConfigInfo->fontDirSet[i]);
        }
        // 获取通用字体集数量，打印日志
        size_t genericCount = fontConfigInfo->fontGenericInfoSize;
        OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, "PrintSysFontMetrics", "通用字体集数量为: %{public}zu\n", genericCount);
        // 遍历获取每个通用字体集中的字体家族名（例如 HarmonyOS Sans），打印日志
        for (size_t i = 0; i < genericCount; ++i) {
            OH_Drawing_FontGenericInfo &genericInfo = fontConfigInfo->fontGenericInfoSet[i];
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, "PrintSysFontMetrics",
                         "获取第%{public}zu个通用字体集中的字体家族名为: %{public}s", i, genericInfo.familyName);
        }
    }
    // 如若后续不再需要系统字体的系统配置信息时，则释放其占用的内存。
    OH_Drawing_DestroySystemFontConfigInfo(fontConfigInfo);
    
    OH_Drawing_FontCollection *fontCollection = OH_Drawing_CreateSharedFontCollection();
    OH_Drawing_TextStyle *textStyle = OH_Drawing_CreateTextStyle();
    // 情况一：设置系统字体为"HarmonyOS Sans Condensed"
    const char *myFontFamilies[] = {"HarmonyOS Sans Condensed"};
    OH_Drawing_SetTextStyleFontFamilies(textStyle, 1, myFontFamilies);

    // 情况二：不手动设置，此时使用的是系统默认字体"HarmonyOS Sans"
    // const char* myFontFamilies[] = {"HarmonyOS Sans Condensed"};
    // OH_Drawing_SetTextStyleFontFamilies(textStyle, 1, myFontFamilies);

    // 设置其他文本样式
    OH_Drawing_SetTextStyleColor(textStyle, OH_Drawing_ColorSetArgb(0xFF, 0x00, 0x00, 0x00));
    OH_Drawing_SetTextStyleFontSize(textStyle, 70.0);
    // 创建一个段落样式对象，以设置排版风格
    OH_Drawing_TypographyStyle *typographyStyle = OH_Drawing_CreateTypographyStyle();
    OH_Drawing_SetTypographyTextAlign(typographyStyle, TEXT_ALIGN_LEFT); // 设置段落样式为左对齐
    // 创建一个段落生成器
    OH_Drawing_TypographyCreate *handler = OH_Drawing_CreateTypographyHandler(typographyStyle, fontCollection);
    // 在段落生成器中设置文本样式
    OH_Drawing_TypographyHandlerPushTextStyle(handler, textStyle);
    // 在段落生成器中设置文本内容
    const char *text = "Hello World. 你好世界。\n以上文字使用了系统字体";
    OH_Drawing_TypographyHandlerAddText(handler, text);
    // 通过段落生成器生成段落
    OH_Drawing_Typography *typography = OH_Drawing_CreateTypography(handler);
    // 设置页面最大宽度
    double maxWidth = width_;
    OH_Drawing_TypographyLayout(typography, maxWidth);
    // 设置文本在画布上绘制的起始位置
    double position[2] = {width_ / 5.0, height_ / 2.0};
    // 将文本绘制到画布上
    OH_Drawing_TypographyPaint(typography, cCanvas_, 0, 100);
}

void SampleBitMap::DrawDisableSysFontText()
{
    // 创建字体管理器，建议优先使用OH_Drawing_CreateSharedFontCollection创建可共享的字体集对象。
    OH_Drawing_FontCollection *fontCollection = OH_Drawing_CreateSharedFontCollection();
    // 禁用系统字体。
    OH_Drawing_DisableFontCollectionSystemFont(fontCollection);
    // 注意 若不设置字体，文本会默认使用系统字体，而系统字体禁用后若不设置使用自定义字体，文本将无法正常显示。
    OH_Drawing_TextStyle *textStyle = OH_Drawing_CreateTextStyle();
    // 禁用系统字体后的几种情况如下：
    // 情况一：如果此时设置使用了自定义字体，文本会正常显示
    // 该路径是待注册的自定义字体文件在应用设备下的路径，确保该自定义字体文件已正确放置在该路径下
    // 后续使用自定义字体时，需使用到该字体家族名
    const char* fontFamily = "HarmonyOS_Sans"; 
    const char* fontPath = "/system/fonts/HarmonyOS_Sans.ttf"; 
    // 返回0为成功，1为文件不存在，2为打开文件失败，3为读取文件失败，4为寻找文件失败，5为获取大小失败，9文件损坏
    int errorCode = OH_Drawing_RegisterFont(fontCollection, fontFamily, fontPath);
    DRAWING_LOGI("errorCode = %{public}d", errorCode);
    const char *myFontFamilies[] = {"HarmonyOS_Sans"}; // 确保已成功注册自定义字体，填入自定义字体的字体家族名
    OH_Drawing_SetTextStyleFontFamilies(textStyle, 1, myFontFamilies);

    // 情况二：如果此时使用了系统字体，文本将无法显示
    // const char *myFontFamilies[] = {"HarmonyOS_Sans"};
    // OH_Drawing_SetTextStyleFontFamilies(textStyle, 1, myFontFamilies);

    // 情况三：如果此时不设置使用字体，文本会默认使用系统默认字体，而此时系统字体已被禁用，因此文本将无法显示
    // const char *myFontFamilies[] = {"HarmonyOS_Sans"};
    // OH_Drawing_SetTextStyleFontFamilies(textStyle, 1, myFontFamilies);

    // 设置其他文本样式
    OH_Drawing_SetTextStyleColor(textStyle, OH_Drawing_ColorSetArgb(0xFF, 0x00, 0x00, 0x00));
    OH_Drawing_SetTextStyleFontSize(textStyle, 30.0);
    // 创建一个段落样式对象，以设置排版风格
    OH_Drawing_TypographyStyle *typographyStyle = OH_Drawing_CreateTypographyStyle();
    OH_Drawing_SetTypographyTextAlign(typographyStyle, TEXT_ALIGN_LEFT); // 设置段落样式为左对齐
    // 创建一个段落生成器
    OH_Drawing_TypographyCreate *handler = OH_Drawing_CreateTypographyHandler(typographyStyle, fontCollection);
    // 在段落生成器中设置文本样式
    OH_Drawing_TypographyHandlerPushTextStyle(handler, textStyle);
    // 在段落生成器中设置文本内容
    const char *text = "Hello World.\n以上文字使用了自定义字体";
    OH_Drawing_TypographyHandlerAddText(handler, text);
    // 通过段落生成器生成段落
    OH_Drawing_Typography *typography = OH_Drawing_CreateTypography(handler);
    
    // 设置页面最大宽度
    double maxWidth = width_;
    OH_Drawing_TypographyLayout(typography, maxWidth);
    // 设置文本在画布上绘制的起始位置
    double position[2] = {width_ / 5.0, height_ / 2.0};
    // 将文本绘制到画布上
    OH_Drawing_TypographyPaint(typography, cCanvas_, position[0], position[1]);
}

void SampleBitMap::DrawText()
{

    OH_Drawing_FontCollection *fontCollection = OH_Drawing_GetFontCollectionGlobalInstance();
    OH_Drawing_TextStyle *myTextStyle = OH_Drawing_CreateTextStyle();
    // const char* myFontFamilies[] = {"otherFontFamilyName"};
    // 注意不要使用此接口来指定字体
    // OH_Drawing_SetTextStyleFontFamilies(textStyle, 1, myFontFamilies);
    
    // 设置其他文本样式
    OH_Drawing_SetTextStyleColor(myTextStyle, OH_Drawing_ColorSetArgb(0xFF, 0x00, 0x00, 0x00));
    OH_Drawing_SetTextStyleFontSize(myTextStyle, 50.0);
    // 创建一个段落样式对象，以设置排版风格
    OH_Drawing_TypographyStyle *typographyStyle = OH_Drawing_CreateTypographyStyle();
    OH_Drawing_SetTypographyTextAlign(typographyStyle, TEXT_ALIGN_LEFT); // 设置段落样式为左对齐
    // 创建一个段落生成器
    OH_Drawing_TypographyCreate *handler = OH_Drawing_CreateTypographyHandler(typographyStyle, fontCollection);
    // 在段落生成器中设置文本样式
    OH_Drawing_TypographyHandlerPushTextStyle(handler, myTextStyle);
    // 在段落生成器中设置文本内容
    const char *text = "Hello World. \nThis is the theme font.";
    OH_Drawing_TypographyHandlerAddText(handler, text);
    // 通过段落生成器生成段落
    OH_Drawing_Typography *typography = OH_Drawing_CreateTypography(handler);
    
    // 设置页面最大宽度
    double maxWidth = width_;
    OH_Drawing_TypographyLayout(typography, maxWidth);
    // 设置文本在画布上绘制的起始位置
    double position[2] = {width_ / 5.0, height_ / 2.0};
    // 将文本绘制到画布上
    OH_Drawing_TypographyPaint(typography, cCanvas_, position[0], position[1]);
}

napi_value SampleBitMap::NapiDrawCustomFontText(napi_env env, napi_callback_info info)
{
    DRAWING_LOGI("NapiDrawCustomFontText");
    if ((env == nullptr) || (info == nullptr)) {
        DRAWING_LOGE("NapiDrawCustomFontText: env or info is null");
        return nullptr;
    }

    napi_value thisArg;
    if (napi_get_cb_info(env, info, nullptr, nullptr, &thisArg, nullptr) != napi_ok) {
        DRAWING_LOGE("NapiDrawCustomFontText: napi_get_cb_info fail");
        return nullptr;
    }

    napi_value exportInstance;
    if (napi_get_named_property(env, thisArg, OH_NATIVE_XCOMPONENT_OBJ, &exportInstance) != napi_ok) {
        DRAWING_LOGE("NapiDrawCustomFontText: napi_get_named_property fail");
        return nullptr;
    }

    OH_NativeXComponent *nativeXComponent = nullptr;
    if (napi_unwrap(env, exportInstance, reinterpret_cast<void **>(&nativeXComponent)) != napi_ok) {
        DRAWING_LOGE("NapiDrawCustomFontText: napi_unwrap fail");
        return nullptr;
    }

    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {'\0'};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    if (OH_NativeXComponent_GetXComponentId(nativeXComponent, idStr, &idSize) != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        DRAWING_LOGE("NapiDrawCustomFontText: Unable to get XComponent id");
        return nullptr;
    }
    DRAWING_LOGI("ID = %{public}s", idStr);
    std::string id(idStr);
    SampleBitMap *render = SampleBitMap().GetInstance(id);
    if (render != nullptr) {
        render->Prepare();
        render->Create();
        render->DrawCustomFontText();
        render->DisPlay();
        render->Destroy();
        DRAWING_LOGI("DrawCustomFontText executed");
    } else {
        DRAWING_LOGE("render is nullptr");
    }
    return nullptr;
}

napi_value SampleBitMap::NapiPrintSysFontMetrics(napi_env env, napi_callback_info info)
{
    DRAWING_LOGI("NapiPrintSysFontMetrics");
    if ((env == nullptr) || (info == nullptr)) {
        DRAWING_LOGE("NapiPrintSysFontMetrics: env or info is null");
        return nullptr;
    }

    napi_value thisArg;
    if (napi_get_cb_info(env, info, nullptr, nullptr, &thisArg, nullptr) != napi_ok) {
        DRAWING_LOGE("NapiPrintSysFontMetrics: napi_get_cb_info fail");
        return nullptr;
    }

    napi_value exportInstance;
    if (napi_get_named_property(env, thisArg, OH_NATIVE_XCOMPONENT_OBJ, &exportInstance) != napi_ok) {
        DRAWING_LOGE("NapiPrintSysFontMetrics: napi_get_named_property fail");
        return nullptr;
    }

    OH_NativeXComponent *nativeXComponent = nullptr;
    if (napi_unwrap(env, exportInstance, reinterpret_cast<void **>(&nativeXComponent)) != napi_ok) {
        DRAWING_LOGE("NapiPrintSysFontMetrics: napi_unwrap fail");
        return nullptr;
    }

    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {'\0'};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    if (OH_NativeXComponent_GetXComponentId(nativeXComponent, idStr, &idSize) != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        DRAWING_LOGE("NapiPrintSysFontMetrics: Unable to get XComponent id");
        return nullptr;
    }
    DRAWING_LOGI("ID = %{public}s", idStr);
    std::string id(idStr);
    SampleBitMap *render = SampleBitMap().GetInstance(id);
    if (render != nullptr) {
        render->Prepare();
        render->Create();
        render->PrintSysFontMetrics();
        render->DisPlay();
        render->Destroy();
        DRAWING_LOGI("PrintSysFontMetrics executed");
    } else {
        DRAWING_LOGE("render is nullptr");
    }
    return nullptr;
}

napi_value SampleBitMap::NapiDrawDisableSysFontText(napi_env env, napi_callback_info info)
{
    DRAWING_LOGI("NapiDrawDisableSysFontText");
    if ((env == nullptr) || (info == nullptr)) {
        DRAWING_LOGE("NapiDrawDisableSysFontText: env or info is null");
        return nullptr;
    }

    napi_value thisArg;
    if (napi_get_cb_info(env, info, nullptr, nullptr, &thisArg, nullptr) != napi_ok) {
        DRAWING_LOGE("NapiDrawDisableSysFontText: napi_get_cb_info fail");
        return nullptr;
    }

    napi_value exportInstance;
    if (napi_get_named_property(env, thisArg, OH_NATIVE_XCOMPONENT_OBJ, &exportInstance) != napi_ok) {
        DRAWING_LOGE("NapiDrawDisableSysFontText: napi_get_named_property fail");
        return nullptr;
    }

    OH_NativeXComponent *nativeXComponent = nullptr;
    if (napi_unwrap(env, exportInstance, reinterpret_cast<void **>(&nativeXComponent)) != napi_ok) {
        DRAWING_LOGE("NapiDrawDisableSysFontText: napi_unwrap fail");
        return nullptr;
    }

    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {'\0'};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    if (OH_NativeXComponent_GetXComponentId(nativeXComponent, idStr, &idSize) != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        DRAWING_LOGE("NapiDrawDisableSysFontText: Unable to get XComponent id");
        return nullptr;
    }
    DRAWING_LOGI("ID = %{public}s", idStr);
    std::string id(idStr);
    SampleBitMap *render = SampleBitMap().GetInstance(id);
    if (render != nullptr) {
        render->Prepare();
        render->Create();
        render->DrawDisableSysFontText();
        render->DisPlay();
        render->Destroy();
        DRAWING_LOGI("DrawDisableSysFontText executed");
    } else {
        DRAWING_LOGE("render is nullptr");
    }
    return nullptr;
}

napi_value SampleBitMap::NapiDrawText(napi_env env, napi_callback_info info)
{
    DRAWING_LOGI("NapiDrawText");
    if ((env == nullptr) || (info == nullptr)) {
        DRAWING_LOGE("NapiDrawPattern: env or info is null");
        return nullptr;
    }

    napi_value thisArg;
    if (napi_get_cb_info(env, info, nullptr, nullptr, &thisArg, nullptr) != napi_ok) {
        DRAWING_LOGE("NapiDrawPattern: napi_get_cb_info fail");
        return nullptr;
    }

    napi_value exportInstance;
    if (napi_get_named_property(env, thisArg, OH_NATIVE_XCOMPONENT_OBJ, &exportInstance) != napi_ok) {
        DRAWING_LOGE("NapiDrawPattern: napi_get_named_property fail");
        return nullptr;
    }

    OH_NativeXComponent *nativeXComponent = nullptr;
    if (napi_unwrap(env, exportInstance, reinterpret_cast<void **>(&nativeXComponent)) != napi_ok) {
        DRAWING_LOGE("NapiDrawPattern: napi_unwrap fail");
        return nullptr;
    }

    char idStr[OH_XCOMPONENT_ID_LEN_MAX + 1] = {'\0'};
    uint64_t idSize = OH_XCOMPONENT_ID_LEN_MAX + 1;
    if (OH_NativeXComponent_GetXComponentId(nativeXComponent, idStr, &idSize) != OH_NATIVEXCOMPONENT_RESULT_SUCCESS) {
        DRAWING_LOGE("NapiDrawPattern: Unable to get XComponent id");
        return nullptr;
    }
    DRAWING_LOGI("ID = %{public}s", idStr);
    std::string id(idStr);
    SampleBitMap *render = SampleBitMap().GetInstance(id);
    if (render != nullptr) {
        render->Prepare();
        render->Create();
        render->DrawText();
        render->DisPlay();
        render->Destroy();
        DRAWING_LOGI("DrawText executed");
    } else {
        DRAWING_LOGE("render is nullptr");
    }
    return nullptr;
}

SampleBitMap::~SampleBitMap()
{
    // 销毁创建的对象
    OH_Drawing_BrushDestroy(cBrush_);
    cBrush_ = nullptr;
    OH_Drawing_PenDestroy(cPen_);
    cPen_ = nullptr;
    OH_Drawing_PathDestroy(cPath_);
    cPath_ = nullptr;
    // 销毁canvas对象
    OH_Drawing_CanvasDestroy(cCanvas_);
    cCanvas_ = nullptr;
    // 销毁bitmap对象
    OH_Drawing_BitmapDestroy(cBitmap_);
    cBitmap_ = nullptr;

    buffer_ = nullptr;
    bufferHandle_ = nullptr;
    nativeWindow_ = nullptr;
    mappedAddr_ = nullptr;
}

void SampleBitMap::Destroy()
{
    // 销毁创建的对象
    OH_Drawing_BrushDestroy(cBrush_);
    cBrush_ = nullptr;
    OH_Drawing_PenDestroy(cPen_);
    cPen_ = nullptr;
    OH_Drawing_PathDestroy(cPath_);
    cPath_ = nullptr;
    // 销毁canvas对象
    OH_Drawing_CanvasDestroy(cCanvas_);
    cCanvas_ = nullptr;
    // 销毁bitmap对象
    OH_Drawing_BitmapDestroy(cBitmap_);
}

void SampleBitMap::Release(std::string &id)
{
    PluginManager::GetInstance()->ReleaseRender(id);
    SampleBitMap *render = SampleBitMap::GetInstance(id);
    if (render != nullptr) {
        delete render;
        render = nullptr;
        g_instance.erase(g_instance.find(id));
    }
}

void SampleBitMap::Export(napi_env env, napi_value exports)
{
    if ((env == nullptr) || (exports == nullptr)) {
        DRAWING_LOGE("Export: env or exports is null");
        return;
    }
    napi_property_descriptor desc[] = {
        {"drawCustomFontText", nullptr, SampleBitMap::NapiDrawCustomFontText, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"printSysFontMetrics", nullptr, SampleBitMap::NapiPrintSysFontMetrics, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"drawDisableSysFontText", nullptr, SampleBitMap::NapiDrawDisableSysFontText, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"drawText", nullptr, SampleBitMap::NapiDrawText, nullptr, nullptr, nullptr, napi_default, nullptr}};
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    if (napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc) != napi_ok) {
        DRAWING_LOGE("Export: napi_define_properties failed");
    }
}

void SampleBitMap::RegisterCallback(OH_NativeXComponent *nativeXComponent)
{
    DRAWING_LOGI("register callback");
    renderCallback_.OnSurfaceCreated = OnSurfaceCreatedCB;
    renderCallback_.OnSurfaceDestroyed = OnSurfaceDestroyedCB;
    // Callback must be initialized
    renderCallback_.DispatchTouchEvent = nullptr;
    renderCallback_.OnSurfaceChanged = nullptr;
    OH_NativeXComponent_RegisterCallback(nativeXComponent, &renderCallback_);
}

SampleBitMap *SampleBitMap::GetInstance(std::string &id)
{
    if (g_instance.find(id) == g_instance.end()) {
        SampleBitMap *render = new SampleBitMap(id);
        g_instance[id] = render;
        return render;
    } else {
        return g_instance[id];
    }
}
