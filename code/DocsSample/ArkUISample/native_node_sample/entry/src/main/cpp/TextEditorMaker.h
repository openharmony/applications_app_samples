/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

#ifndef NATIVE_NODE_SAMPLE_TEXTEDITORMAKER_H
#define NATIVE_NODE_SAMPLE_TEXTEDITORMAKER_H

#include "manager.h"
#include <native_drawing/drawing_pen.h>
#include <native_drawing/drawing_canvas.h>
#include <native_drawing/drawing_rect.h>
#include <native_drawing/drawing_color_filter.h>
#include <multimedia/image_framework/image/pixelmap_native.h>

class TextEditorMaker {
public:
    TextEditorMaker(){};
    ~TextEditorMaker(){};
    static ArkUI_NodeHandle CreateNativeNode();

private:
    static void CreateStyledStringWithTextStyle();
    static void CreateStyledStringWithParagraphStyle();
    static void CreateStyledStringWithDecorationStyle();
    static void CreateStyledStringWithBaselineOffsetStyle();
    static void CreateStyledStringWithLetterSpacingStyle();
    static void CreateStyledStringWithTextShadowStyle();
    static void CreateStyledStringWithBackgroundColorStyle();
    static void CreateStyledStringWithGestureStyle();
    static void CreateStyledStringWithLineHeightStyle();
    static void CreateStyledStringWithUrlStyle();
    
    static void StyledStringBasicOperations();
    static void StyledStringStyleOperations();
    static void StyledStringAdvancedOperations();
    static void StyledStringComparisonAndSerialization();
    static void StyledStringCustomSpan();
    static void StyledStringImageAttachment();
    static void StyledStringClearStyles();
    static void StyledStringUserDataSpan();
    static void StyledStringReplaceStyle();
    static void StyledStringReplaceStyledString();
    static void StyledStringStyledPlaceholder();
    static void StyledStringWithChangeCallbacks();
    static void ParagraphStyleCallback();
};

#endif //NATIVE_NODE_SAMPLE_TEXTEDITORMAKER_H
