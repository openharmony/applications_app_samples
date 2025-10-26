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
// [Start worterflow_section]
//WaterflowSection.h

#ifndef MYAPPLICATION_WATERFLOWSECTION_H
#define MYAPPLICATION_WATERFLOWSECTION_H

#include <arkui/native_node.h>
#include <hilog/log.h>

namespace NativeModule {

struct SectionOption {
    int32_t itemsCount = 0;
    int32_t crossCount;
    float columnsGap;
    float rowsGap;
    // {上外边距，右外边距，下外边距，左外边距}
    ArkUI_Margin margin{0, 0, 0, 0};
    float (*onGetItemMainSizeByIndex)(int32_t itemIndex);
    void *userData;
};

class WaterflowSection {
public:
    WaterflowSection() : sectionOptions_(OH_ArkUI_WaterFlowSectionOption_Create()){};
    
    ~WaterflowSection()
    {
        OH_ArkUI_WaterFlowSectionOption_Dispose(sectionOptions_);
    }

    void SetSection(ArkUI_WaterFlowSectionOption *sectionOptions, int32_t index, SectionOption section)
    {
        OH_ArkUI_WaterFlowSectionOption_SetItemCount(sectionOptions, index, section.itemsCount);
        OH_ArkUI_WaterFlowSectionOption_SetCrossCount(sectionOptions, index, section.crossCount);
        OH_ArkUI_WaterFlowSectionOption_SetColumnGap(sectionOptions, index, section.columnsGap);
        OH_ArkUI_WaterFlowSectionOption_SetRowGap(sectionOptions, index, section.rowsGap);
        OH_ArkUI_WaterFlowSectionOption_SetMargin(sectionOptions, index, section.margin.top, section.margin.right,
                                                  section.margin.bottom, section.margin.left);
        OH_ArkUI_WaterFlowSectionOption_RegisterGetItemMainSizeCallbackByIndex(sectionOptions, index,
                                                                               section.onGetItemMainSizeByIndex);
    }
    
    ArkUI_WaterFlowSectionOption *GetSectionOptions() const
    {
        return sectionOptions_;
    }
    
    void PrintSectionOptions()
    {
        int32_t sectionCnt = OH_ArkUI_WaterFlowSectionOption_GetSize(sectionOptions_);
        for (int32_t i = 0; i < sectionCnt; i++) {
            ArkUI_Margin margin = OH_ArkUI_WaterFlowSectionOption_GetMargin(sectionOptions_, i);
            OH_LOG_Print(LOG_APP, LOG_INFO, LOG_DOMAIN, "CreateWaterflowExample",
                         "Section[%{public}d].margin:{%{public}f, %{public}f, %{public}f, %{public}f}", i, margin.top,
                         margin.right, margin.bottom, margin.left);
        }
    }

private:
    ArkUI_WaterFlowSectionOption *sectionOptions_ = nullptr;
};
} // namespace NativeModule

#endif // MYAPPLICATION_WATERFLOWSECTION_H
// [End worterflow_section]