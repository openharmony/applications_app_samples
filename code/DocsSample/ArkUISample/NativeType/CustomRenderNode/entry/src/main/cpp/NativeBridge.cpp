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

// [Start native_bridge]
// native_bridge.cpp
#include "napi/native_api.h"
#include <native_drawing/drawing_canvas.h>
#include <native_drawing/drawing_color.h>
#include <native_drawing/drawing_path.h>
#include <native_drawing/drawing_pen.h>

namespace {
    const int32_t ARG_NUM0 = 0;
    const int32_t ARG_NUM1 = 1;
    const int32_t ARG_NUM2 = 2;
    const int32_t ARG_NUM3 = 3;
    const int32_t ARG_NUM4 = 4;
}

static napi_value OnDraw(napi_env env, napi_callback_info info)
{
    size_t argc = ARG_NUM4;
    napi_value args[ARG_NUM4] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    int32_t id;
    napi_get_value_int32(env, args[ARG_NUM0], &id);

    // 获取 Canvas 指针
    void *temp = nullptr;
    napi_unwrap(env, args[ARG_NUM1], &temp);
    OH_Drawing_Canvas *canvas = reinterpret_cast<OH_Drawing_Canvas *>(temp);

    // 获取 Canvas 宽度
    int32_t width;
    napi_get_value_int32(env, args[ARG_NUM2], &width);

    // 获取 Canvas 高度
    int32_t height;
    napi_get_value_int32(env, args[ARG_NUM3], &height);

    const float kQuarter = 0.25f;
    const float kThreeQuarters  = 0.75f;
    // 传入canvas、height、width等信息至绘制函数中进行自定义绘制
    auto path = OH_Drawing_PathCreate();
    OH_Drawing_PathMoveTo(path, width * kQuarter, height * kQuarter);
    OH_Drawing_PathLineTo(path, width * kThreeQuarters, height * kQuarter);
    OH_Drawing_PathLineTo(path, width * kThreeQuarters, height * kThreeQuarters);
    OH_Drawing_PathLineTo(path, width * kQuarter, height * kThreeQuarters);
    OH_Drawing_PathLineTo(path, width * kQuarter, height * kQuarter);
    OH_Drawing_PathClose(path);

    auto pen = OH_Drawing_PenCreate();
    const int lineWidth = 10;
    OH_Drawing_PenSetWidth(pen, lineWidth);
    OH_Drawing_PenSetColor(pen, OH_Drawing_ColorSetArgb(0xFF, 0xFF, 0x00, 0x00));
    OH_Drawing_CanvasAttachPen(canvas, pen);

    OH_Drawing_CanvasDrawPath(canvas, path);

    return nullptr;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {
        {"nativeOnDraw", nullptr, OnDraw, nullptr, nullptr, nullptr, napi_default, nullptr}};
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

extern "C" __attribute__((constructor)) void RegisterEntryModule(void)
{
    napi_module_register(&demoModule);
}
// [End native_bridge]