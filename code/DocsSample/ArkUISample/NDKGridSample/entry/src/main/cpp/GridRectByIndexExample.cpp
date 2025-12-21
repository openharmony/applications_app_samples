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

#include "GridRectByIndexExample.h"

#include "ArkUIGridLayoutOptions.h"
#include "ArkUIGridNode.h"
#include "ArkUIGridItemNode.h"
#include "ArkUITextNode.h"
#include "ArkUIColumnNode.h"

namespace NativeModule {
namespace {
const std::vector<std::string> NUMBERS_1 = {"0", "1", "2", "3", "4", "5", "6", "7", "8"};
const float ITEM_HEIGHT = 80.0f;
const float ROWS_GAP = 10.0f;
const int TWO_ROWS = 2;
const int SIX_ROWS = 6;
const int ITEM_INDEX_2 = 2;
const int ITEM_INDEX_3 = 3;
const int ITEM_INDEX_4 = 4;
const int ITEM_INDEX_5 = 5;
const int ITEM_INDEX_6 = 6;
const int ITEM_INDEX_7 = 7;
} // namespace

template <typename T> inline std::vector<std::shared_ptr<T>> &GetKeepAliveContainer()
{
    static std::vector<std::shared_ptr<T>> keepAliveContainer;
    return keepAliveContainer;
}

void CreateGridItem(std::shared_ptr<ArkUIGridNode> gird, const std::string &content, float height)
{
    ArkUI_NativeNodeAPI_1 *nodeAPI = nullptr;
    OH_ArkUI_GetModuleInterface(ARKUI_NATIVE_NODE, ArkUI_NativeNodeAPI_1, nodeAPI);
    auto item = std::make_shared<ArkUIGridItemNode>();
    auto text = std::make_shared<ArkUITextNode>();
    text->SetTextAlign(ARKUI_TEXT_ALIGNMENT_CENTER);
    text->SetBackgroundColor(0xFFF9CF93U);
    text->SetPercentHeight(1.0f);
    text->SetPercentWidth(1.0f);
    text->SetFontSize(16.0f);
    text->SetTextContent(content);
    item->SetHeight(height);
    nodeAPI->addChild(item->GetHandle(), text->GetHandle());
    nodeAPI->addChild(gird->GetHandle(), item->GetHandle());
}

static std::shared_ptr<ArkUIGridNode> BuildGridRectByIndex()
{
    // [Start grid_columns_and_rows]
    auto grid = std::make_shared<ArkUIGridNode>();
    grid->SetPercentWidth(0.9f);
    grid->SetHeight(SIX_ROWS * ITEM_HEIGHT + (SIX_ROWS - 1) * ROWS_GAP);
    grid->SetColumnsTemplate("1fr 1fr 1fr 1fr");
    grid->SetRowsTemplate("1fr 1fr 1fr 1fr 1fr 1fr");
    grid->SetColumnsGap(10.0f);
    grid->SetRowsGap(ROWS_GAP);
    // [End grid_columns_and_rows]

    for (auto i = 0; i < NUMBERS_1.size(); i++) {
        CreateGridItem(grid, std::to_string(i), (i == 0 || i == 1) ? ITEM_HEIGHT * TWO_ROWS + ROWS_GAP : ITEM_HEIGHT);
    }

    // [Start grid_get_rect_by_index]
    auto option = std::make_shared<ArkuiGridLayoutOptions>();
    auto layoutOptions = option->GetLayoutOptions();
    OH_ArkUI_GridLayoutOptions_RegisterGetRectByIndexCallback(
        option->GetLayoutOptions(), nullptr, [](int32_t itemIndex, void *userData) -> ArkUI_GridItemRect {
            switch (itemIndex) {
                case 0:
                    return ArkUI_GridItemRect{0, 0, 2, 4};
                case 1:
                    return ArkUI_GridItemRect{3, 0, 2, 2};
                case ITEM_INDEX_2:
                    return ArkUI_GridItemRect{3, 2, 1, 2};
                case ITEM_INDEX_3:
                    return ArkUI_GridItemRect{4, 2, 1, 1};
                case ITEM_INDEX_4:
                    return ArkUI_GridItemRect{4, 3, 1, 1};
                case ITEM_INDEX_5:
                    return ArkUI_GridItemRect{5, 0, 1, 1};
                case ITEM_INDEX_6:
                    return ArkUI_GridItemRect{5, 1, 1, 1};
                case ITEM_INDEX_7:
                    return ArkUI_GridItemRect{5, 2, 1, 1};
                default:
                    return ArkUI_GridItemRect{5, 3, 1, 1};
            }
        });
    grid->SetLayoutOptions(layoutOptions);
    // [End grid_get_rect_by_index]
    GetKeepAliveContainer<ArkUIGridNode>().emplace_back(grid);
    return grid;
}

std::shared_ptr<ArkUIBaseNode> GridRectByIndexExample::CreateNativeNode()
{
    auto page = std::make_shared<ArkUIColumnNode>();
    page->SetPercentWidth(1.0f);
    page->SetPercentHeight(1.0f);
    if (page == nullptr || page->GetHandle() == nullptr) {
        return nullptr;
    }

    std::shared_ptr<ArkUIGridNode> grid2 = BuildGridRectByIndex();
    if (grid2 && grid2->GetHandle() != nullptr) {
        page->AddChild(grid2);
    }
    GetKeepAliveContainer<ArkUIColumnNode>().emplace_back(page);
    return page;
}
}