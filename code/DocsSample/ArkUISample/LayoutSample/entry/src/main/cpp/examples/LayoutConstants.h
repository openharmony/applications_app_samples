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

#ifndef LAYOUT_CONSTANTS_H
#define LAYOUT_CONSTANTS_H

#include <string>
#include <vector>
#include <cstdint>

namespace LayoutConstants {

// ==================== 颜色常量 ====================
namespace Colors {
constexpr uint32_t LIGHT_GREEN = 0xFFA3CF62;
constexpr uint32_t TEAL = 0xFF00AE9D;
constexpr uint32_t BLUE = 0xFF0A59F7;

constexpr uint32_t YELLOW = 0xFFFFFF00;
constexpr uint32_t RED = 0xFFFF0000;
constexpr uint32_t GREEN = 0xFF00FF00;
constexpr uint32_t LIGHT_GRAY = 0xFFDDDDDD;
constexpr uint32_t BEIGE = 0xFFF5DEB3;
constexpr uint32_t TAN = 0xFFD2B48C;
constexpr uint32_t LIGHT_BLUE = 0xFFAFEEEE;
constexpr uint32_t LIGHT_CYAN = 0xFFF0FAFF;

constexpr uint32_t PURPLE = 0xFF800080;
constexpr uint32_t CYAN = 0xFF00FFFF;
constexpr uint32_t LIGHT_BROWN = 0xFFD2CAB3;
constexpr uint32_t SAGE_GREEN = 0xFFC1CBAC;
constexpr uint32_t BUTTON_BACKGROUND_COLOR = BLUE;

// 颜色数组
const std::vector<uint32_t> STANDARD_COLORS = { LIGHT_GREEN, TEAL, BLUE };
const std::vector<uint32_t> ITEM_COLORS = { BEIGE, TAN, BEIGE, TAN };
} // namespace Colors

// ==================== 尺寸常量 ====================
namespace Sizes {
// 基础尺寸
constexpr float SMALL = 30.0f;
constexpr float MEDIUM = 50.0f;
constexpr float LARGE = 80.0f;
constexpr float EXTRA_LARGE = 100.0f;
constexpr float ULTRA_LARGE = 200.0f;
constexpr float GIANT = 300.0f;

// 特定用途尺寸
constexpr float BORDER_WIDTH = 2.0f;
constexpr float BORDER_WIDTH_THIN = 1.0f;
constexpr float MARGIN_SMALL = 5.0f;
constexpr float MARGIN_MEDIUM = 10.0f;
constexpr float PADDING_MEDIUM = 10.0f;

// 高度变化
constexpr float HEIGHT_SMALL = 20.0f;
constexpr float HEIGHT_LARGE = 70.0f;

// 按钮样式
constexpr float BUTTON_HEIGHT = 40.0f;
constexpr float BUTTON_WIDTH = 150.0f;

// 特定偏移值
constexpr float OFFSET_MEDIUM = 60.0f;

// 字体大小
constexpr float FONT_SIZE_SMALL = 16.0f;
constexpr float FONT_SIZE_MEDIUM = 20.0f;

// 布局策略相关尺寸
constexpr float CONSTRAINT_SIZE_SMALL = 150.0f;
constexpr float CONSTRAINT_SIZE_MEDIUM = 250.0f;

// LayoutPosition相关尺寸
constexpr int32_t LAYOUT_RECT_WIDTH = 900;
constexpr int32_t LAYOUT_RECT_HEIGHT = 200;

constexpr int32_t POSITION_X = 30;
constexpr int32_t POSITION_Y = 30;

constexpr int32_t ROW_COUNT = 9;

constexpr int32_t ZERO = 0;

} // namespace Sizes

// ==================== 百分比常量 ====================
namespace Percentages {
constexpr float FULL_WIDTH = 1.0f;
constexpr float NINETY_PERCENT = 0.9f;
constexpr float SEVENTY_PERCENT = 0.7f;
constexpr float SIXTY_PERCENT = 0.6f;
constexpr float TWENTY_PERCENT = 0.2f;

// 边框百分比
constexpr float BORDER_THIN = 0.005f;

// 圆角百分比
constexpr float RADIUS_SMALL = 0.1f;
constexpr float RADIUS_MEDIUM = 0.2f;
constexpr float RADIUS_LARGE = 0.3f;
constexpr float RADIUS_EXTRA_LARGE = 0.4f;

// Flex收缩
constexpr float FLEX_SHRINK_SMALL = 0.05f;
} // namespace Percentages

// ==================== 数量常量 ====================
namespace Counts {
constexpr int TEXT_NODES_SMALL = 2;
constexpr int TEXT_NODES_MEDIUM = 3;
constexpr int TEXT_NODES_LARGE = 4;
constexpr int TEXT_NODES_EXTRA_LARGE = 6;
constexpr int TEXT_NODES_MAX = 10;
} // namespace Counts

// ==================== 文本常量 ====================
namespace Texts {
// 标题文本
const std::string TITLE_SET_POSITION = "SetPosition";
const std::string TITLE_SET_OFFSET = "SetOffset";
const std::string TITLE_SET_SIZE = "SetSize";
const std::string TITLE_JUSTIFY_CONTENT = "justifyContent + alignItems";
const std::string TITLE_BOTTOM_ALIGNMENT = "bottom alignment";
const std::string TITLE_DIRECTION = "direction";
const std::string TITLE_ALIGNMENT = "alignment";
const std::string TITLE_ASPECT_RATIO = "aspect ratio";
const std::string TITLE_BORDER_ALIGNSELF = "setborder and alignself test";
const std::string TITLE_FLEX_GROW = "SetFlexGrow test";
const std::string TITLE_FLEX_BASIS = "flexBasis test";
const std::string TITLE_DISPLAY_PRIORITY = "display priority";
const std::string TITLE_LAYOUT_POSITION = "setLayoutPosition";

// 内容文本
const std::string CONTENT_POSITION = "position1 (30, 30)";
const std::string CONTENT_OFFSET = "offset (60,60)";
const std::string CONTENT_SIZE = "size (100*100)";
const std::string CONTENT_RATIO = "ratio w/h=1.5";
const std::string CONTENT_FLEX_GROW_2 = "flexGrow(2)";
const std::string CONTENT_FLEX_GROW_1 = "flexGrow(1)";
const std::string CONTENT_FLEX_BASIS_100 = "flexBasis(100)";
const std::string CONTENT_FLEX_BASIS_AUTO = "flexBasis(auto)";
const std::string CONTENT_STACK_FIRST = "first child, show in bottom";
const std::string CONTENT_STACK_SECOND = "second child, show in top";
} // namespace Texts

// ==================== ID常量 ====================
namespace IDs {
const std::string FATHER = "father";
const std::string ROW_PREFIX = "row";
const std::string TEXT_PREFIX = "text";
const std::string DIRECTION_PREFIX = "direction";
const std::string ALIGNMENT_PREFIX = "alignment";
const std::string CHILD_PREFIX = "child";
const std::string BARRIER_PREFIX = "barrier";
} // namespace IDs

// ==================== 索引常量 ====================
namespace Indices {
constexpr int ZERO = 0;
constexpr int ONE = 1;
constexpr int TWO = 2;
constexpr int THREE = 3;
constexpr int FOUR = 4;
constexpr int FIVE = 5;
constexpr int SIX = 6;
constexpr int SEVEN = 7;
constexpr int EIGHT = 8;

// 测试索引常量
constexpr int BARRIER_TEST_INDEX = ZERO;
constexpr int REFERENCE_TEST_INDEX = ZERO;
} // namespace Indices

// ==================== Flex相关常量 ====================
namespace Flex {
constexpr int GROW_FACTOR_HIGH = 2;
constexpr int GROW_FACTOR_LOW = 1;
constexpr float BASIS_FIXED = 100.0f;
constexpr float ASPECT_RATIO_WIDE = 1.5f;
} // namespace Flex

// ==================== 显示优先级常量 ====================
namespace DisplayPriority {
constexpr int HIGH = 2;
constexpr int LOW = 1;
} // namespace DisplayPriority

// ==================== 便利函数 ====================
namespace Utils {

inline std::string GenerateId(const std::string& prefix, int index)
{
    return prefix + std::to_string(index);
}

inline std::string GenerateText(const std::string& prefix, int index)
{
    return prefix + std::to_string(index);
}

inline float CalculateIncrementalSize(float base, int index, float increment = 10.0f)
{
    return base + index * increment;
}

inline uint32_t GetCyclicColor(const std::vector<uint32_t>& colors, int index)
{
    return colors[index % colors.size()];
}
} // namespace Utils

} // namespace LayoutConstants

#endif // LAYOUT_CONSTANTS_H