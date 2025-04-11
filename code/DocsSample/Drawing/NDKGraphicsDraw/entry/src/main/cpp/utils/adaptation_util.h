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

#ifndef ADAPTATION_UTIL_H
#define ADAPTATION_UTIL_H

// 多设备适配类，用于适配不同尺寸的设备
class AdaptationUtil {
public:
    static AdaptationUtil* GetInstance();
    float GetWidth(float width);
    float GetHeight(float height);
private:
    AdaptationUtil();
    static AdaptationUtil *instance_;
    
    int screenWidth_ = 720;
    int screenHeight_ = 1280;
    const int standardWidth_ = 1260; // 指南文档默认运行设备为真机
    const int standardHeight_ = 2720;
};

#endif // ADAPTATION_UTIL_H
