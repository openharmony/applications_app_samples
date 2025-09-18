/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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

#ifndef CAPI_0922_LAYOUTPOLICYEXAMPLE_REFACTORED_H
#define CAPI_0922_LAYOUTPOLICYEXAMPLE_REFACTORED_H

#include "LayoutConstants.h"
#include "nodes/ArkUIBaseNode.h"
#include "nodes/ArkUIColumnNode.h"
#include "nodes/ArkUIRowNode.h"
#include "nodes/ArkUIStackNode.h"
#include "nodes/ArkUITextNode.h"
#include <vector>


namespace NativeModule {

using namespace LayoutConstants;

std::shared_ptr<ArkUITextNode> CreatePolicyTitle(const std::string& titleText)
{
    auto title = std::make_shared<ArkUITextNode>();
    title->SetTextContent(titleText);
    return title;
}

std::shared_ptr<ArkUIColumnNode> CreateMainContainer()
{
    auto column = std::make_shared<ArkUIColumnNode>();
    column->SetWidth(Sizes::ULTRA_LARGE);  // 特定容器宽度
    column->SetHeight(Sizes::ULTRA_LARGE); // 特定容器高度
    column->SetPadding(Sizes::MARGIN_MEDIUM);
    column->SetBorderWidth(Sizes::BORDER_WIDTH);
    return column;
}

std::shared_ptr<ArkUIFlexNode> CreateMatchParentExample()
{
    // matchParent生效时，当前组件会与其父组件内容区大小（180vp * 180vp）相等，
    // 同时依旧受自身constraintSize（150vp * 150vp）约束，因此当前组件大小为150vp
    // * 150vp
    auto matchParentFlex = std::make_shared<ArkUIFlexNode>();
    matchParentFlex->SetBackgroundColor(Colors::RED);
    matchParentFlex->SetWidthLayoutPolicy(ARKUI_LAYOUTPOLICY_MATCHPARENT);
    matchParentFlex->SetHeightLayoutPolicy(ARKUI_LAYOUTPOLICY_MATCHPARENT);
    matchParentFlex->SetConstraintSize(Sizes::CONSTRAINT_SIZE_SMALL, Sizes::CONSTRAINT_SIZE_SMALL,
                                       Sizes::CONSTRAINT_SIZE_SMALL, Sizes::CONSTRAINT_SIZE_SMALL); // 特定约束尺寸
    return matchParentFlex;
}

std::shared_ptr<ArkUIRowNode> CreateWrapContentExample()
{
    // wrapContent生效时，当前组件会与其子组件大小（300vp * 300vp）相等，
    // 但不能超过父组件内容大小（180vp * 180vp）且会受自身constraintSize（250vp *
    // 250vp）约束， 因此当前组件大小为180vp * 180vp
    auto wrapContentRow = std::make_shared<ArkUIRowNode>();
    auto wrapContentFlex = std::make_shared<ArkUIFlexNode>();

    wrapContentFlex->SetWidth(Sizes::ULTRA_LARGE);
    wrapContentFlex->SetHeight(Sizes::ULTRA_LARGE);
    wrapContentRow->AddChild(wrapContentFlex);

    wrapContentRow->SetBackgroundColor(Colors::BLUE);
    wrapContentRow->SetWidthLayoutPolicy(ARKUI_LAYOUTPOLICY_WRAPCONTENT);
    wrapContentRow->SetHeightLayoutPolicy(ARKUI_LAYOUTPOLICY_WRAPCONTENT);
    wrapContentRow->SetConstraintSize(0, Sizes::CONSTRAINT_SIZE_MEDIUM, 0, Sizes::CONSTRAINT_SIZE_MEDIUM); // 特定约束尺寸

    return wrapContentRow;
}

std::shared_ptr<ArkUIRowNode> CreateFixAtIdealSizeExample()
{
    // fixAtIdealSize生效时，当前组件会与其子组件大小（300vp * 300vp）相等，
    // 可以超过父组件内容大小（180vp * 180vp）但会受自身constraintSize（250vp *
    // 250vp）约束， 因此当前组件大小为250vp * 250vp
    auto fixAtIdealSizeRow = std::make_shared<ArkUIRowNode>();
    auto fixAtIdealSizeFlex = std::make_shared<ArkUIFlexNode>();

    fixAtIdealSizeFlex->SetWidth(Sizes::GIANT);
    fixAtIdealSizeFlex->SetHeight(Sizes::GIANT);
    fixAtIdealSizeRow->AddChild(fixAtIdealSizeFlex);

    fixAtIdealSizeRow->SetBackgroundColor(Colors::LIGHT_CYAN);
    fixAtIdealSizeRow->SetWidthLayoutPolicy(ARKUI_LAYOUTPOLICY_FIXATIDEALSIZE);
    fixAtIdealSizeRow->SetHeightLayoutPolicy(ARKUI_LAYOUTPOLICY_FIXATIDEALSIZE);
    fixAtIdealSizeRow->SetConstraintSize(0, Sizes::CONSTRAINT_SIZE_MEDIUM, 0, Sizes::CONSTRAINT_SIZE_MEDIUM); // 特定约束尺寸

    return fixAtIdealSizeRow;
}

std::shared_ptr<ArkUIBaseNode> CreateLayoutPolicyExample()
{
    auto column = CreateMainContainer();

    // MatchParent策略示例
    column->AddChild(CreatePolicyTitle("matchParent"));
    column->AddChild(CreateMatchParentExample());

    // WrapContent策略示例
    column->AddChild(CreatePolicyTitle("wrapContentText"));
    column->AddChild(CreateWrapContentExample());

    // FixAtIdealSize策略示例
    column->AddChild(CreatePolicyTitle("fixAtIdealSize"));
    column->AddChild(CreateFixAtIdealSizeExample());

    return column;
}

} // namespace NativeModule
#endif // CAPI_0922_LAYOUTPOLICYEXAMPLE_REFACTORED_H
