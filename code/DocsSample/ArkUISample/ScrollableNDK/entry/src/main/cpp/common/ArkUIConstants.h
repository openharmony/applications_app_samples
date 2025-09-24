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

#ifndef SCROLLABLENDK_COMMON_ARKUICONSTANTS_H
#define SCROLLABLENDK_COMMON_ARKUICONSTANTS_H

#include <cstdint>

namespace ScrollableNDK::Constants {

// ==============================
// 通用尺寸和布局常量
// ==============================
constexpr float K_PERCENT_FULL = 1.0f;
constexpr float K_PERCENT_HALF = 0.5f;
constexpr float K_DEFAULT_PADDING = 8.0f;
constexpr float K_DEFAULT_MARGIN = 16.0f;
constexpr float K_DEFAULT_BORDER_RADIUS = 8.0f;
constexpr float K_DEFAULT_FONT_SIZE = 16.0f;
constexpr float K_SMALL_FONT_SIZE = 14.0f;
constexpr float K_LARGE_FONT_SIZE = 18.0f;

// ==============================
// 颜色常量
// ==============================
constexpr uint32_t K_COLOR_TRANSPARENT = 0x00000000U;
constexpr uint32_t K_COLOR_WHITE = 0xFFFFFFFFU;
constexpr uint32_t K_COLOR_BLACK = 0xFF000000U;
constexpr uint32_t K_COLOR_GRAY = 0xFF808080U;
constexpr uint32_t K_COLOR_LIGHT_GRAY = 0xFFF0F0F0U;
constexpr uint32_t K_COLOR_DARK_GRAY = 0xFF404040U;
constexpr uint32_t K_COLOR_PRIMARY = 0xFF007AFFU;
constexpr uint32_t K_COLOR_SECONDARY = 0xFF6C757DU;
constexpr uint32_t K_COLOR_SUCCESS = 0xFF28A745U;
constexpr uint32_t K_COLOR_WARNING = 0xFFFFC107U;
constexpr uint32_t K_COLOR_ERROR = 0xFFDC3545U;

// ==============================
// 滚动相关常量
// ==============================
constexpr float K_DEFAULT_SCROLL_BAR_WIDTH = 4.0f;
constexpr uint32_t K_DEFAULT_SCROLL_BAR_COLOR = 0x66000000U;
constexpr float K_DEFAULT_SCROLL_FRICTION = 0.015f;
constexpr int32_t K_DEFAULT_FADING_EDGE = 12;
constexpr int32_t K_DEFAULT_CACHED_COUNT = 1;

// ==============================
// 动画和交互常量
// ==============================
constexpr int32_t K_DEFAULT_ANIMATION_DURATION = 300;
constexpr int32_t K_SHORT_ANIMATION_DURATION = 150;
constexpr int32_t K_LONG_ANIMATION_DURATION = 500;
constexpr float K_DEFAULT_DAMPING = 0.85f;
constexpr float K_DEFAULT_STIFFNESS = 100.0f;

// ==============================
// 布局相关常量
// ==============================
constexpr int32_t K_MAX_LINES = 10;
constexpr int32_t K_DEFAULT_LANES = 1;
constexpr float K_DEFAULT_ITEM_SPACING = 8.0f;
constexpr float K_DEFAULT_SECTION_SPACING = 16.0f;

// ==============================
// 性能相关常量
// ==============================
constexpr int32_t K_DEFAULT_VIEWPORT_ITEM_COUNT = 20;
constexpr int32_t K_LARGE_DATASET_THRESHOLD = 1000;
constexpr int32_t K_INFINITE_SCROLL_THRESHOLD = 5;

// ==============================
// 字符串和文本常量
// ==============================
constexpr char K_EMPTY_STRING[] = "";
constexpr char K_DEFAULT_LOADING_TEXT[] = "加载中…";
constexpr char K_DEFAULT_DELETE_TEXT[] = "Delete";
constexpr char K_DEFAULT_FOOTER_TEXT[] = "到底啦…";

// ==============================
// 数值验证常量
// ==============================
constexpr int32_t K_MIN_VALID_INDEX = 0;
constexpr int32_t K_INVALID_INDEX = -1;
constexpr float K_MIN_VALID_FLOAT = 0.0f;
constexpr float K_MAX_VALID_FLOAT = 1000000.0f;

// ==============================
// UI 尺寸常量
// ==============================
constexpr float K_MIN_TOUCH_SIZE = 44.0f;
constexpr float K_DEFAULT_TEXT_HEIGHT = 40.0f;
constexpr float K_DEFAULT_BUTTON_HEIGHT = 48.0f;
constexpr float K_DEFAULT_ITEM_HEIGHT = 64.0f;
constexpr float K_DEFAULT_LIST_ITEM_HEIGHT = 80.0f;

// ==============================
// 日志域
// ==============================
constexpr unsigned int K_LOG_DOMAIN = 0xFF00;

} // namespace ScrollableNDK::Constants

#endif // SCROLLABLENDK_COMMON_ARKUICONSTANTS_H