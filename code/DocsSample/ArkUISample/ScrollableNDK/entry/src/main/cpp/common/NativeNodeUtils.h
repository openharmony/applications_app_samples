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

#ifndef SCROLLABLENDK_NATIVE_NODE_UTILS_H
#define SCROLLABLENDK_NATIVE_NODE_UTILS_H

#include <memory>
#include <vector>

#include "napi/native_api.h"
#include <arkui/native_node.h>
#include <arkui/native_node_napi.h>

namespace ScrollableNDK {

/** 保活容器：防止 JS 不持有引用导致 C++ 对象被回收 */
template <typename T>
inline std::vector<std::shared_ptr<T>>& KeepAliveVec()
{
    static std::vector<std::shared_ptr<T>> s_keepAlive;
    return s_keepAlive;
}

/** 从 NAPI 参数解析 NodeContentHandle（args[0]） */
inline ArkUI_NodeContentHandle GetContentFromArg(napi_env env, napi_callback_info info)
{
    size_t argc = 1;
    napi_value args[1] = { nullptr };
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
    if (argc < 1) {
        return nullptr;
    }
    ArkUI_NodeContentHandle content = nullptr;
    OH_ArkUI_GetNodeContentFromNapiValue(env, args[0], &content);
    return content;
}

/** 将 node 挂到 NodeContent */
inline void AddNodeToContent(ArkUI_NodeContentHandle content, ArkUI_NodeHandle node)
{
    if (content && node) {
        OH_ArkUI_NodeContent_AddNode(content, node);
    }
}

/** 通用属性设置：float */
inline void SetAttrF32(ArkUI_NativeNodeAPI_1* api, ArkUI_NodeHandle node,
                       ArkUI_NodeAttributeType attr, float v)
{
    ArkUI_NumberValue nv{};
    nv.f32 = v;
    ArkUI_AttributeItem item{ &nv, 1 };
    api->setAttribute(node, attr, &item);
}

/** 通用属性设置：uint32_t */
inline void SetAttrU32(ArkUI_NativeNodeAPI_1* api, ArkUI_NodeHandle node,
                       ArkUI_NodeAttributeType attr, uint32_t v)
{
    ArkUI_NumberValue nv{};
    nv.u32 = v;
    ArkUI_AttributeItem item{ &nv, 1 };
    api->setAttribute(node, attr, &item);
}

/** 文本：设置内容 */
inline void SetTextContent(ArkUI_NativeNodeAPI_1* api, ArkUI_NodeHandle text, const char* cstr)
{
    if (!text) {
        return;
    }
    ArkUI_AttributeItem item{ nullptr, 0, cstr };
    api->setAttribute(text, NODE_TEXT_CONTENT, &item);
}

/** 文本：设置字号 */
inline void SetFontSize(ArkUI_NativeNodeAPI_1* api, ArkUI_NodeHandle text, float size)
{
    if (!text) {
        return;
    }
    ArkUI_NumberValue nv{};
    nv.f32 = size;
    ArkUI_AttributeItem attr{ &nv, 1 };
    api->setAttribute(text, NODE_FONT_SIZE, &attr);
}

} // namespace ScrollableNDK

#endif // SCROLLABLENDK_NATIVE_NODE_UTILS_H
