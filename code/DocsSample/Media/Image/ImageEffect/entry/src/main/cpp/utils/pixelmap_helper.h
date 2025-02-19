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

#ifndef IMAGEEFFECT_PIXELMAP_HELPER_H
#define IMAGEEFFECT_PIXELMAP_HELPER_H

#include <multimedia/image_framework/image/pixelmap_native.h>
#include <memory>

class PixelMapHelper {
public:
    static std::shared_ptr<OH_PixelmapNative> Decode(std::string &pathName);
    static bool Encode(OH_PixelmapNative *pixelmap, std::string &pathName);
};

#endif // IMAGEEFFECT_PIXELMAP_HELPER_H
