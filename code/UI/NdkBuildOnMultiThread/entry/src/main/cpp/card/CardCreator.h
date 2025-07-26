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

#ifndef MYAPPLICATION_SERVICECARD_H
#define MYAPPLICATION_SERVICECARD_H

#include "common/ArkUINode.h"
#include <string>

namespace NativeModule {
struct ServiceItemInfo {
    std::string name;
    std::string backgroundImageSrc;
    std::string describeInfo;
    std::string iconSrc;
    int64_t iconColor;
};

struct AppItemInfo {
    std::string name;
    std::string iconSrc;
    int64_t iconColor;
};

struct AppCardInfo {
    std::string name;
    std::vector<AppItemInfo> items;
};

struct ServiceCardInfo {
    std::string name;
    std::vector<ServiceItemInfo> items;
};

struct CardInfo {
    std::string type;
    ServiceCardInfo serviceCardInfo;
    AppCardInfo appCardInfo;
};

std::shared_ptr<ArkUINode> CreateServiceCard(ServiceCardInfo& info);
std::shared_ptr<ArkUINode> CreateAppCard(AppCardInfo& info);
} // namespace NativeModule

#endif //MYAPPLICATION_SERVICECARD_H
