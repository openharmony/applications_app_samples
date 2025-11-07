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
// [Start create_waterflow_example]
// CreateWaterflowExample.h

#ifndef MYAPPLICATION_CREATEWATERFLOWEXAMPLE_H
#define MYAPPLICATION_CREATEWATERFLOWEXAMPLE_H
#include "waterflow.h"

namespace NativeModule {
const int UI_WIDTH = 400;
const int UI_HEIGHT = 600;
const int SECTION_COUNT = 10;
const int SECTION_2_ID = 2;

inline void SetupSections(std::shared_ptr<WaterflowSection> sections)
{
    SectionOption MARGIN_GAP_SECTION_1 = {10, 2, 10, 10, {20, 30, 40, 50}, nullptr, nullptr};
    SectionOption MARGIN_GAP_SECTION_2 = {10, 4, 10, 10, {20, 30, 40, 50}, nullptr, nullptr};
    for (int i = 0; i < SECTION_COUNT; i++) {
        sections->SetSection(sections->GetSectionOptions(), i,
                             i % SECTION_2_ID ? MARGIN_GAP_SECTION_1 : MARGIN_GAP_SECTION_2);
    }
}

inline std::shared_ptr<ArkUIWaterflowNode> CreateWaterflowExample(napi_env env)
{
    auto waterflow = std::make_shared<ArkUIWaterflowNode>();
    waterflow->SetHeight(UI_HEIGHT);
    waterflow->SetWidth(UI_WIDTH);
    waterflow->SetLazyAdapter(std::make_shared<FlowItemAdapter>());
    auto sections = std::make_shared<WaterflowSection>();
    SetupSections(sections);
    waterflow->SetSection(sections);
    return waterflow;
}
} // namespace NativeModule

#endif // MYAPPLICATION_CREATEWATERFLOWEXAMPLE_H
// [End create_waterflow_example]