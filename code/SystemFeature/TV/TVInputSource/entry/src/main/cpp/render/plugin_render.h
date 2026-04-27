/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef NATIVE_XCOMPONENT_PLUGIN_RENDER_H
#define NATIVE_XCOMPONENT_PLUGIN_RENDER_H

#include <native_window/external_window.h>
#include "egl_core.h"

namespace NativeXComponent {
class PluginRender {
public:
    explicit PluginRender(const int64_t id);
    ~PluginRender()
    {
        if (eglCore_ != nullptr) {
            eglCore_->Release();
            delete eglCore_;
            eglCore_ = nullptr;
        }
    }
    void DrawTransparentBuffer();
    void InitNativeWimdow(OHNativeWindow *window);
    void UpdateNativeWindowSize(int width, int height);

private:
    EGLCore *eglCore_;
    int64_t id_;
};
} // namespace NativeXComponent
#endif // NATIVE_XCOMPONENT_PLUGIN_RENDER_H
