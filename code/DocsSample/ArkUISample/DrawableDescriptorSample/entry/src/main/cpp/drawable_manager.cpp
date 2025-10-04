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
#include "drawable_manager.h"

DrawableManager& DrawableManager::GetInstance()
{
    static DrawableManager instance;
    return instance;
}

DrawableManager::~DrawableManager()
{
    std::lock_guard<std::mutex> lock(mutex_);
    for (auto& pair : drawableMap_) {
        if (pair.second != nullptr) {
            OH_ArkUI_DrawableDescriptor_Dispose(pair.second);
        }
    }
    drawableMap_.clear();
}

int32_t DrawableManager::AddDrawable(ArkUI_DrawableDescriptor* descriptor)
{
    if (descriptor == nullptr) {
        return -1;
    }

    std::lock_guard<std::mutex> lock(mutex_);
    int32_t id = nextId_++;
    drawableMap_[id] = descriptor;
    return id;
}

ArkUI_DrawableDescriptor* DrawableManager::GetDrawable(int32_t id)
{
    std::lock_guard<std::mutex> lock(mutex_);
    auto it = drawableMap_.find(id);
    if (it != drawableMap_.end()) {
        return it->second;
    }
    return nullptr;
}

void DrawableManager::RemoveDrawable(int32_t id)
{
    std::lock_guard<std::mutex> lock(mutex_);
    auto it = drawableMap_.find(id);
    if (it != drawableMap_.end()) {
        if (it->second != nullptr) {
            OH_ArkUI_DrawableDescriptor_Dispose(it->second);
        }
        drawableMap_.erase(it);
    }
}
    