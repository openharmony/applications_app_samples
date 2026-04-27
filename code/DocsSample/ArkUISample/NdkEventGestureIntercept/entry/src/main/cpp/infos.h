/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

#ifndef NDKINPUTEVENT_INFOS_H
#define NDKINPUTEVENT_INFOS_H

#include "common.h"
#include "container.h"
#include <arkui/native_node.h>
#include <arkui/native_type.h>
#include <sstream>

namespace NativeXComponentSample {
// 示例说明文本
std::string g_explain = "通过本示例可以测试手势拦截事件C-API的各项功能。\n"
    "1、测试按钮1：通过手指点击该按钮可测试事件透传到Row场景；\n"
    "      该场景日志仅打印'NdkEventGestureIntercept_SampleLog, Row2 tap'；\n"
    "2、测试按钮2：通过手指点击该按钮可测试事件不透传到Row场景；\n"
    "      该场景日志仅打印'NdkEventGestureIntercept_SampleLog, Button2 tap'；\n";

std::stringstream g_ss;

ArkUI_NodeHandle column1;
ArkUI_NodeHandle row1 = nullptr;
ArkUI_NodeHandle row2 = nullptr;
ArkUI_NodeHandle stack1 = nullptr;
ArkUI_NodeHandle button1 = nullptr;
ArkUI_NodeHandle button2 = nullptr;
// 信息文本节点
ArkUI_NodeHandle infoText = nullptr;
int32_t g_buttonId;
} // namespace NativeXComponentSample

#endif //NDKINPUTEVENT_INFOS_H
