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

#include <cstdint>

#include "plugin_render.h"

namespace NativeXComponent {

PluginRender::PluginRender(const int64_t id)
{
    this->id_ = id;
    this->eglCore_ = new EGLCore();
}

void PluginRender::DrawTransparentBuffer()
{
    if (eglCore_ != nullptr) {
        eglCore_->Draw();
    }
}

void PluginRender::InitNativeWimdow(OHNativeWindow *window)
{
    if (eglCore_ != nullptr) {
        eglCore_->EglContextInit(window);
    }
}

void PluginRender::UpdateNativeWindowSize(int width, int height)
{
    if (eglCore_ != nullptr) {
        eglCore_->UpdateSize(width, height);
    }
}

} // namespace NativeXComponent
