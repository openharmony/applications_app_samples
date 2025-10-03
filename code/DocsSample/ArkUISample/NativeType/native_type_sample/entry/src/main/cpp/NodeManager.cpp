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
#include "NodeManager.h"
#include "arkui/native_type.h"
#include <cstdint>
#include <sstream>
#include <arkui/native_interface.h>
#include <arkui/styled_string.h>
#include <hilog/log.h>
#include <multimedia/image_framework/image/pixelmap_native.h>

#define NUM_0 0
#define NUM_1 1
#define NUM_2 2
#define NUM_3 3
#define NUM_4 4
#define NUM_6 6
#define NUM_96 96
#define NUM_255 255
const unsigned int LOG_PRINT_DOMAIN = 0xFF00;

NodeManager &NodeManager::GetInstance()
{
    static NodeManager instance;
    return instance;
}

void NodeManager::SetContentHandle(ArkUI_NodeContentHandle contentHandle)
{
    contentHandle_ = contentHandle;
}

//设置进度条的类型
void NodeManager::SetProgressType(int32_t type)
{
    ArkUI_NativeNodeAPI_1 *nodeApi = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
    if (nodeApi == nullptr) {
        return;
    }
    if (nodes_["progress"] != nullptr) {
        ArkUI_NumberValue value[] = {{.f32 = 10.0f}};
        ArkUI_AttributeItem item = {value, sizeof(value) / sizeof(ArkUI_NumberValue)};
        value[0].i32 = static_cast<ArkUI_ProgressType>(type);
        nodeApi->setAttribute(nodes_["progress"], NODE_PROGRESS_TYPE, &item);
    }
}

//用于存储生成的ProgressLinearStyleOption
static std::unordered_map<int, ArkUI_ProgressLinearStyleOption*> g_styleOptions;
static int g_nextId = 1;

//设置自定义进度条选项
void NodeManager::SetProgressLinearStyleOption(bool scanEffect,
    bool smoothEffect, int32_t strokeWidth, int32_t strokeRadius)
{
    for (auto option : g_styleOptions) {
        OH_ArkUI_ProgressLinearStyleOption_Destroy(option.second);
    }
    g_styleOptions.clear();
    g_nextId = 1;
    ArkUI_NativeNodeAPI_1 *nodeApi = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
    if (nodeApi == nullptr) {
        return;
    }
    if (nodes_["progress"] != nullptr) {
        auto option = OH_ArkUI_ProgressLinearStyleOption_Create();
        //设置进度条的扫描效果
        OH_ArkUI_ProgressLinearStyleOption_SetScanEffectEnabled(option, scanEffect);
        //设置进度变化时的平滑过渡效果
        OH_ArkUI_ProgressLinearStyleOption_SetSmoothEffectEnabled(option, smoothEffect);
        //设置线性进度条的线宽
        OH_ArkUI_ProgressLinearStyleOption_SetStrokeWidth(option, strokeWidth);
        //设置线性进度条两端的圆角半径
        OH_ArkUI_ProgressLinearStyleOption_SetStrokeRadius(option, strokeRadius);
        if (option != nullptr) {
            int id = g_nextId++;
            g_styleOptions[id] = option;
        }
        ArkUI_AttributeItem item = {0};
        item.object = option;
        nodeApi->setAttribute(nodes_["progress"], NODE_PROGRESS_LINEAR_STYLE, &item);
    }
}

std::string NodeManager::GetProgressLinearStyleOptionAndDestroy()
{
    if (!contentHandle_) {
        return "";
    }
    ArkUI_NativeNodeAPI_1 *nodeApi = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
    if (nodeApi == nullptr) {
        return "";
    }
    
    auto option = g_styleOptions[g_nextId - 1];
    if (option == nullptr) {
        return "has no ProgressLinearStyleOption";
    }
    //获取进度条扫描效果
    auto scanEffectEnabled = OH_ArkUI_ProgressLinearStyleOption_GetScanEffectEnabled(option);
    //获取进度变化时的平滑过度效果
    auto smoothEffectEnabled = OH_ArkUI_ProgressLinearStyleOption_GetSmoothEffectEnabled(option);
    //获取线性进度条的线宽
    auto strokeWidth = OH_ArkUI_ProgressLinearStyleOption_GetStrokeWidth(option);
    //获取线性进度条两端的圆角半径
    auto strokeRadius = OH_ArkUI_ProgressLinearStyleOption_GetStrokeRadius(option);
    //销毁自定义选项
    OH_ArkUI_ProgressLinearStyleOption_Destroy(option);
    g_styleOptions.erase(--g_nextId);
    std::string result = "scanEffectEnabled = " + std::to_string(scanEffectEnabled) +
                     " smoothEffectEnabled = " + std::to_string(smoothEffectEnabled) +
                     " strokeWidth = " + std::to_string(strokeWidth) +
                     " strokeRadius = " + std::to_string(strokeRadius);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "NativeTypeTest", "result = %{public}s", result.c_str());
    return result;
}

static std::unordered_map<int, ArkUI_ImageAnimatorFrameInfo*> g_ImageAnimator;
static int g_imageNextId = 1;
std::string NodeManager::GetImageAnimatorFrameInfo()
{
    ArkUI_NativeNodeAPI_1 *nodeApi = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
    if (nodeApi == nullptr) {
        return "";
    }
    
    auto imageAnimator = g_ImageAnimator[g_imageNextId - 1];
    if (imageAnimator == nullptr) {
        return "has no ImageAnimatorFrameInfo";
    }
    //获取当前帧图片的宽度
    auto width = OH_ArkUI_ImageAnimatorFrameInfo_GetWidth(imageAnimator);
    //获取当前帧图片的高度
    auto height = OH_ArkUI_ImageAnimatorFrameInfo_GetHeight(imageAnimator);
    //获取当前帧在组件中的顶部坐标
    auto top = OH_ArkUI_ImageAnimatorFrameInfo_GetTop(imageAnimator);
    //获取当前帧在组件中的左侧坐标
    auto left = OH_ArkUI_ImageAnimatorFrameInfo_GetLeft(imageAnimator);
    //获取当前帧的播放时长
    auto duration = OH_ArkUI_ImageAnimatorFrameInfo_GetDuration(imageAnimator);
    //释放 imageAnimator 对象占用的内存和资源
    OH_ArkUI_ImageAnimatorFrameInfo_Dispose(imageAnimator);
    g_ImageAnimator.erase(--g_imageNextId);
    std::string result = " height = " + std::to_string(height) +
                     " width = " + std::to_string(width) +
                     " top = " + std::to_string(top) +
                     " left = " + std::to_string(left) +
                     " duration = " + std::to_string(duration);
    OH_LOG_Print(LOG_APP, LOG_INFO, LOG_PRINT_DOMAIN, "NativeTypeTest", "result = %{public}s", result.c_str());
    return result;
}

void NodeManager::CreateDatePicker(int32_t modeType)
{
    if (!contentHandle_) {
        return;
    }
    ArkUI_NativeNodeAPI_1 *nodeApi = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
    if (nodeApi == nullptr) {
        return;
    }
    auto it = nodes_.find("datePicker_column");
    if (it != nodes_.end()) {
        //删除原有的column组件
        OH_ArkUI_NodeContent_RemoveNode(contentHandle_, nodes_["datePicker_column"]);
        nodeApi->disposeNode(nodes_["datePicker_column"]);
        nodes_.erase(it);
    }
    auto date = nodes_.find("datePicker");
    if (date == nodes_.end()) {
        //创建datepicker组件
        ArkUI_NodeHandle datePicker = nodeApi->createNode(ARKUI_NODE_DATE_PICKER);
        nodes_["datePicker"] = datePicker;
    }
    ArkUI_NodeHandle column = nodeApi->createNode(ARKUI_NODE_COLUMN);
    ArkUI_NumberValue colWidth[] = {{.f32 = 300.f}};
    ArkUI_AttributeItem widthItem = {.value = colWidth, .size = 1};
    nodeApi->setAttribute(column, NODE_WIDTH, &widthItem);
    nodes_["datePicker_column"] = column;
    
    ArkUI_NumberValue value[] = {{.f32 = 10.0f}};
    ArkUI_AttributeItem modeItem = {value, sizeof(value) / sizeof(ArkUI_NumberValue)};
    value[0].i32 = static_cast<ArkUI_DatePickerMode>(modeType);
    //设置datepicker组件的NODE_DATE_PICKER_MODE属性
    nodeApi->setAttribute(nodes_["datePicker"], NODE_DATE_PICKER_MODE, &modeItem);
    nodeApi->addChild(nodes_["datePicker_column"], nodes_["datePicker"]);
    OH_ArkUI_NodeContent_AddNode(contentHandle_, nodes_["datePicker_column"]);
}

void NodeManager::CreateCalendarPicker(int32_t modeType)
{
    if (!contentHandle_) {
        return;
    }
    ArkUI_NativeNodeAPI_1 *nodeApi = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
    if (nodeApi == nullptr) {
        return;
    }
    auto it = nodes_.find("calendarPicker_column");
    if (it != nodes_.end()) {
        //删除原有的column组件
        OH_ArkUI_NodeContent_RemoveNode(contentHandle_, nodes_["calendarPicker_column"]);
        nodeApi->disposeNode(nodes_["calendarPicker_column"]);
        nodes_.erase(it);
    }
    auto calendar = nodes_.find("calendarPicker");
    if (calendar == nodes_.end()) {
        //创建calendarPicker组件
        ArkUI_NodeHandle calendarPicker = nodeApi->createNode(ARKUI_NODE_CALENDAR_PICKER);
        nodes_["calendarPicker"] = calendarPicker;
    }
    ArkUI_NodeHandle column = nodeApi->createNode(ARKUI_NODE_COLUMN);
    ArkUI_NumberValue colWidth[] = {{.f32 = 500.f}};
    ArkUI_AttributeItem widthItem = {.value = colWidth, .size = 1};
    nodeApi->setAttribute(column, NODE_WIDTH, &widthItem);
    nodes_["calendarPicker_column"] = column;
    
    ArkUI_NumberValue value[] = {{.f32 = 10.0f}};
    ArkUI_AttributeItem modeItem = {value, sizeof(value) / sizeof(ArkUI_NumberValue)};
    value[0].i32 = static_cast<ArkUI_CalendarAlignment>(modeType);
    //设置calendarPicker组件的NODE_CALENDAR_PICKER_EDGE_ALIGNMENT属性
    nodeApi->setAttribute(nodes_["calendarPicker"], NODE_CALENDAR_PICKER_EDGE_ALIGNMENT, &modeItem);
    
    ArkUI_NumberValue Width[] = {{.f32 = 300.f}};
    ArkUI_AttributeItem widthItem1 = {.value = Width, .size = 1};
    nodeApi->setAttribute(nodes_["calendarPicker"], NODE_WIDTH, &widthItem1);
    nodeApi->addChild(nodes_["calendarPicker_column"], nodes_["calendarPicker"]);
    OH_ArkUI_NodeContent_AddNode(contentHandle_, nodes_["calendarPicker_column"]);
}

void NodeManager::CreateImageSize(int32_t objectFit, int32_t imageSize)
{
    if (!contentHandle_) {
        return;
    }
    ArkUI_NativeNodeAPI_1 *nodeApi = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
    if (nodeApi == nullptr) {
        return;
    }
    auto it = nodes_.find("image_column");
    if (it != nodes_.end()) {
        OH_ArkUI_NodeContent_RemoveNode(contentHandle_, nodes_["image_column"]);
        nodeApi->disposeNode(nodes_["image_column"]);
        nodes_.erase(it);
    }
    
    ArkUI_NodeHandle column = nodeApi->createNode(ARKUI_NODE_COLUMN);
    ArkUI_NumberValue colWidth[] = {{.f32 = 500.f}};
    ArkUI_AttributeItem widthItem = {.value = colWidth, .size = 1};
    nodeApi->setAttribute(column, NODE_WIDTH, &widthItem);
    ArkUI_NumberValue textHeight[] = {{.f32 = 400.f}};
    ArkUI_AttributeItem HeightItem = {.value = textHeight, .size = 1};
    nodeApi->setAttribute(column, NODE_HEIGHT, &HeightItem);
    ArkUI_NumberValue borderWidth[] = {{.f32 = 1}};
    ArkUI_AttributeItem borderWidthItem = {.value = borderWidth, .size = 1};
    nodeApi->setAttribute(column, NODE_BORDER_WIDTH, &borderWidthItem);
    nodes_["image_column"] = column;
    
    auto image = nodes_.find("image");
    if (image == nodes_.end()) {
        //创建Image组件
        ArkUI_NodeHandle image  = nodeApi->createNode(ARKUI_NODE_IMAGE);
        char src[] = "resources/base/media/startIcon.png";
        ArkUI_AttributeItem imageItem = {.string = src};
        //设置Image的NODE_IMAGE_SRC属性，为图片路径
        nodeApi->setAttribute(image, NODE_IMAGE_SRC, &imageItem);
        nodes_["image"] = image;
    }
    
    ArkUI_NumberValue FitValue[] = {{.f32 = 10.0f}};
    ArkUI_AttributeItem objectFitItem = {FitValue, sizeof(FitValue) / sizeof(ArkUI_NumberValue)};
    FitValue[0].i32 = static_cast<ArkUI_ObjectFit>(objectFit);
    //设置Image的NODE_IMAGE_OBJECT_FIT属性
    nodeApi->setAttribute(nodes_["image"], NODE_IMAGE_OBJECT_FIT, &objectFitItem);
    
    ArkUI_NumberValue value[] = {{.f32 = 10.0f}};
    ArkUI_AttributeItem sizeItem = {value, sizeof(value) / sizeof(ArkUI_NumberValue)};
    value[0].i32 = static_cast<ArkUI_ImageSize>(imageSize);
    //设置背景的NODE_BACKGROUND_IMAGE_SIZE_WITH_STYLE属性
    nodeApi->setAttribute(nodes_["image_column"], NODE_BACKGROUND_IMAGE_SIZE_WITH_STYLE, &sizeItem);
    char backGroundSrc[] = "resources/base/media/640.jpg";
    ArkUI_AttributeItem backgroundItem = {.string = backGroundSrc};
    //设置背景的图片路径
    nodeApi->setAttribute(nodes_["image_column"], NODE_BACKGROUND_IMAGE, &backgroundItem);
    nodeApi->addChild(nodes_["image_column"], nodes_["image"]);
    OH_ArkUI_NodeContent_AddNode(contentHandle_, nodes_["image_column"]);
}

void SetImageColumn(ArkUI_NativeNodeAPI_1 *nodeApi, ArkUI_NodeHandle column)
{
    ArkUI_NumberValue colWidth[] = {{.f32 = 500.f}};
    ArkUI_AttributeItem widthItem = {.value = colWidth, .size = 1};
    nodeApi->setAttribute(column, NODE_WIDTH, &widthItem);
    ArkUI_NumberValue Height[] = {{.f32 = 400.f}};
    ArkUI_AttributeItem HeightItem = {.value = Height, .size = 1};
    nodeApi->setAttribute(column, NODE_HEIGHT, &HeightItem);
    ArkUI_NumberValue borderWidth[] = {{.f32 = 1}};
    ArkUI_AttributeItem borderWidthItem = {.value = borderWidth, .size = 1};
    nodeApi->setAttribute(column, NODE_BORDER_WIDTH, &borderWidthItem);
    char backGroundSrc[] = "resources/base/media/startIcon.png";
    ArkUI_AttributeItem backgroundItem = {.string = backGroundSrc};
    nodeApi->setAttribute(column, NODE_BACKGROUND_IMAGE, &backgroundItem);
}

void NodeManager::SetImageProperties(int32_t imageRepeat, int32_t imageInterpolation, int32_t imageRenderMode)
{
    if (!contentHandle_) {
        return;
    }
    ArkUI_NativeNodeAPI_1 *nodeApi = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
    if (nodeApi == nullptr) {
        return;
    }
    
    auto it = nodes_.find("image_column");
    if (it != nodes_.end()) {
        OH_ArkUI_NodeContent_RemoveNode(contentHandle_, nodes_["image_column"]);
        nodeApi->disposeNode(nodes_["image_column"]);
        nodes_.erase(it);
    }
    //创建column
    ArkUI_NodeHandle column = nodeApi->createNode(ARKUI_NODE_COLUMN);
    SetImageColumn(nodeApi, column);
    nodes_["image_column"] = column;
    
    auto image = nodes_.find("image");
    if (image == nodes_.end()) {
        //创建Image组件
        ArkUI_NodeHandle image  = nodeApi->createNode(ARKUI_NODE_IMAGE);
        char src[] = "resources/base/media/startIcon.png";
        ArkUI_AttributeItem imageItem = {.string = src};
        nodeApi->setAttribute(image, NODE_IMAGE_SRC, &imageItem);
        nodes_["image"] = image;
    }
    
    ArkUI_NumberValue InterpolationValue[] = {{.f32 = 10.0f}};
    ArkUI_AttributeItem InterpolationValueItem = {InterpolationValue,
        sizeof(InterpolationValue) / sizeof(ArkUI_NumberValue)};
    InterpolationValue[0].i32 = static_cast<ArkUI_ImageInterpolation>(imageInterpolation);
    //设置Image的NODE_IMAGE_INTERPOLATION属性
    nodeApi->setAttribute(nodes_["image"], NODE_IMAGE_INTERPOLATION, &InterpolationValueItem);
    
    ArkUI_NumberValue RenderModeValue[] = {{.f32 = 10.0f}};
    ArkUI_AttributeItem RenderModeValueItem = {RenderModeValue,
        sizeof(RenderModeValue) / sizeof(ArkUI_NumberValue)};
    RenderModeValue[0].i32 = static_cast<ArkUI_ImageRenderMode>(imageRenderMode);
    //设置Image的NODE_IMAGE_RENDER_MODE属性
    nodeApi->setAttribute(nodes_["image"], NODE_IMAGE_RENDER_MODE, &RenderModeValueItem);
    
    ArkUI_NumberValue imageRepeatValue[] = {{.f32 = 10.0f}};
    ArkUI_AttributeItem imageRepeatItem = {imageRepeatValue,
        sizeof(imageRepeatValue) / sizeof(ArkUI_NumberValue)};
    imageRepeatValue[0].i32 = static_cast<ArkUI_ImageRepeat>(imageRepeat);
    char backGroundSrc[] = "resources/base/media/startIcon.png";
    imageRepeatItem.string = backGroundSrc;
    nodeApi->setAttribute(nodes_["image_column"], NODE_BACKGROUND_IMAGE, &imageRepeatItem);
    
    nodeApi->addChild(nodes_["image_column"], nodes_["image"]);
    OH_ArkUI_NodeContent_AddNode(contentHandle_, nodes_["image_column"]);
}

void NodeManager::SetUpColumnAndText(ArkUI_NativeNodeAPI_1 *nodeApi, ArkUI_NodeHandle &column, ArkUI_NodeHandle &text)
{
    ArkUI_NumberValue colWidth[] = {{.f32 = 500.f}};
    ArkUI_AttributeItem widthItem = {.value = colWidth, .size = 1};
    nodeApi->setAttribute(column, NODE_WIDTH, &widthItem);
    ArkUI_NumberValue backgroundColor[] = {{.f32 = 0xFFFF0000}};
    ArkUI_AttributeItem backgroundColorItem = {.value = backgroundColor, .size = 1};
    nodeApi->setAttribute(column, NODE_BACKGROUND_COLOR, &backgroundColorItem);
    
    //设置text控件的参数
    ArkUI_NumberValue textWidth[] = {{.f32 = 250}};
    ArkUI_AttributeItem textWidthItem = {.value = textWidth, .size = 1};
    nodeApi->setAttribute(text, NODE_WIDTH, &textWidthItem);
    ArkUI_NumberValue textHeight[] = {{.f32 = 50}};
    ArkUI_AttributeItem textHeightItem = {.value = textHeight, .size = 1};
    nodeApi->setAttribute(text, NODE_HEIGHT, &textHeightItem);
    ArkUI_NumberValue borderWidth[] = {{.f32 = 1}};
    ArkUI_AttributeItem borderWidthItem = {.value = borderWidth, .size = 1};
    nodeApi->setAttribute(text, NODE_BORDER_WIDTH, &borderWidthItem);
    ArkUI_AttributeItem textOutput = {.string = "CrossLanguageOption"};
    nodeApi->setAttribute(text, NODE_TEXT_CONTENT, &textOutput);
    nodeApi->addChild(column, text);
}

//设置text控件的CrossLanguageOption
void NodeManager::SetUpTextCrossLanguage(bool isCross)
{
    ArkUI_NativeNodeAPI_1 *nodeApi = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
    if (nodeApi == nullptr) {
        return;
    }
    //创建一个CrossLanguageOption
    ArkUI_CrossLanguageOption* option = OH_ArkUI_CrossLanguageOption_Create();
    //设置option的状态
    OH_ArkUI_CrossLanguageOption_SetAttributeSettingStatus(option, isCross);
    OH_ArkUI_NodeUtils_SetCrossLanguageOption(nodes_["text"], option);
    //获取option的状态
    auto ret = OH_ArkUI_CrossLanguageOption_GetAttributeSettingStatus(option);
    //销毁创建的CrossLanguageOption
    OH_ArkUI_CrossLanguageOption_Destroy(option);
    ArkUI_AttributeItem textOutput;
    if (ret) {
        textOutput = {.string = "CrossLanguageOption = ture"};
    } else {
        textOutput = {.string = "CrossLanguageOption = false"};
    }
    nodeApi->setAttribute(nodes_["text"], NODE_TEXT_CONTENT, &textOutput);
}

void NodeManager::AddTextPicker(int32_t type, ArkUI_NativeNodeAPI_1 *nodeApi, ArkUI_NodeHandle &column)
{
    //创建textPicker组件
    ArkUI_NodeHandle textPicker = nodeApi->createNode(ARKUI_NODE_TEXT_PICKER);
    //单列选择框和多列选择框的处理
    if (static_cast<ArkUI_TextPickerRangeType>(type) == ARKUI_TEXTPICKER_RANGETYPE_SINGLE ||
        static_cast<ArkUI_TextPickerRangeType>(type) == ARKUI_TEXTPICKER_RANGETYPE_MULTI) {
        char example[] = "111,112;221,222;331,332";
        ArkUI_NumberValue value[] = {{.f32 = 10.0f}};
        ArkUI_AttributeItem rangeAttr = {value, sizeof(value) / sizeof(ArkUI_NumberValue)};
        value[0].i32 = static_cast<ArkUI_TextPickerRangeType>(type);
        rangeAttr.string = example;
        nodeApi->setAttribute(textPicker, NODE_TEXT_PICKER_OPTION_RANGE, &rangeAttr);
        nodeApi->addChild(column, textPicker);
    }
    //可带图标的textPicker处理逻辑
    if (static_cast<ArkUI_TextPickerRangeType>(type) == ARKUI_TEXTPICKER_RANGETYPE_RANGE_CONTENT) {
        char path[] = "resources/base/media/startIcon.png";
        //创建两个TextPickerRangeContent
        auto array = OH_ArkUI_TextPickerRangeContentArray_Create(2);
        //为下标为0的元素设置文字描述
        OH_ArkUI_TextPickerRangeContentArray_SetTextAtIndex(array, "first", 0);
        //为下标为1的元素设置文字描述
        OH_ArkUI_TextPickerRangeContentArray_SetTextAtIndex(array, "second", 1);
        //为下标为0的元素设置图标
        OH_ArkUI_TextPickerRangeContentArray_SetIconAtIndex(array, path, 0);
        //为下标为1的元素设置图标
        OH_ArkUI_TextPickerRangeContentArray_SetIconAtIndex(array, path, 1);
        ArkUI_NumberValue value[] = {{.f32 = 10.0f}};
        ArkUI_AttributeItem rangeAttr = {value, sizeof(value) / sizeof(ArkUI_NumberValue)};
        value[0].i32 = static_cast<ArkUI_TextPickerRangeType>(type);
        rangeAttr.object = array;
        nodeApi->setAttribute(textPicker, NODE_TEXT_PICKER_OPTION_RANGE, &rangeAttr);
        OH_ArkUI_TextPickerRangeContentArray_Destroy(array);
        nodeApi->addChild(column, textPicker);
    }
    //级联形式的textPicker处理逻辑
    if (static_cast<ArkUI_TextPickerRangeType>(type) == ARKUI_TEXTPICKER_RANGETYPE_CASCADE_RANGE_CONTENT) {
        //创建两个父节点并初始化
        auto twoParent = OH_ArkUI_TextCascadePickerRangeContentArray_Create(2);
        OH_ArkUI_TextCascadePickerRangeContentArray_SetTextAtIndex(twoParent, "firstParent", 0);
        OH_ArkUI_TextCascadePickerRangeContentArray_SetTextAtIndex(twoParent, "secondParent", 1);
        //分别为两个父节点创建两个子节点并初始化
        auto firstTwoChild = OH_ArkUI_TextCascadePickerRangeContentArray_Create(2);
        auto secondTwoChild = OH_ArkUI_TextCascadePickerRangeContentArray_Create(2);
        OH_ArkUI_TextCascadePickerRangeContentArray_SetTextAtIndex(firstTwoChild, "first_Child1", 0);
        OH_ArkUI_TextCascadePickerRangeContentArray_SetTextAtIndex(firstTwoChild, "first_Child2", 1);
        OH_ArkUI_TextCascadePickerRangeContentArray_SetTextAtIndex(secondTwoChild, "second_Child1", 0);
        OH_ArkUI_TextCascadePickerRangeContentArray_SetTextAtIndex(secondTwoChild, "second_Child2", 1);
        //将子节点连接到父节点上
        OH_ArkUI_TextCascadePickerRangeContentArray_SetChildAtIndex(twoParent, firstTwoChild, 0);
        OH_ArkUI_TextCascadePickerRangeContentArray_SetChildAtIndex(twoParent, secondTwoChild, 1);
        ArkUI_NumberValue value[] = {{.f32 = 10.0f}};
        ArkUI_AttributeItem rangeAttr = {value, sizeof(value) / sizeof(ArkUI_NumberValue)};
        value[0].i32 = static_cast<ArkUI_TextPickerRangeType>(type);
        rangeAttr.object = twoParent;
        nodeApi->setAttribute(textPicker, NODE_TEXT_PICKER_OPTION_RANGE, &rangeAttr);
        OH_ArkUI_TextCascadePickerRangeContentArray_Destroy(twoParent);
        nodeApi->addChild(column, textPicker);
    }
}

void NodeManager::CreateTextPickerWithCustomContent(int32_t type)
{
    if (!contentHandle_) {
        return;
    }
    ArkUI_NativeNodeAPI_1 *nodeApi = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
    if (nodeApi == nullptr) {
        return;
    }
    auto it = nodes_.find("textPicker_column");
    if (it != nodes_.end()) {
        OH_ArkUI_NodeContent_RemoveNode(contentHandle_, nodes_["textPicker_column"]);
        nodeApi->disposeNode(nodes_["textPicker_column"]);
        nodes_.erase(it);
    }
    ArkUI_NodeHandle column = nodeApi->createNode(ARKUI_NODE_COLUMN);
    ArkUI_NodeHandle text = nodeApi->createNode(ARKUI_NODE_TEXT);
    nodes_["text"] = text;
    SetUpColumnAndText(nodeApi, column, text);
    AddTextPicker(type, nodeApi, column);
    nodes_["textPicker_column"] = column;
    OH_ArkUI_NodeContent_AddNode(contentHandle_, column);
}

void NodeManager::ClearNodes()
{
    ArkUI_NativeNodeAPI_1 *nodeApi = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
    if (nodeApi == nullptr) {
        return;
    }
    //销毁nodes_中的组件
    for (auto node : nodes_) {
        nodeApi->disposeNode(node.second);
    }
    //销毁g_styleOptions中的option元素
    for (auto option : g_styleOptions) {
        OH_ArkUI_ProgressLinearStyleOption_Destroy(option.second);
    }
    //重新初始化g_nextId
    g_nextId = 1;
    //销毁g_ImageAnimator中的FrameInfo元素
    for (auto image : g_ImageAnimator) {
        OH_ArkUI_ImageAnimatorFrameInfo_Dispose(image.second);
    }
    //重新初始化g_imageNextId
    g_imageNextId = 1;
    //清空nodes_;
    nodes_.clear();
    //清空g_styleOptions;
    g_styleOptions.clear();
    //清空g_ImageAnimator;
    g_ImageAnimator.clear();
}

void NodeManager::CreateProgress()
{
    if (!contentHandle_) {
        return;
    }
    ArkUI_NativeNodeAPI_1 *nodeApi = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
    if (nodeApi == nullptr) {
        return;
    }
    ArkUI_NodeHandle column = nodeApi->createNode(ARKUI_NODE_COLUMN);
    ArkUI_NumberValue colWidth[] = {{.f32 = 300}};
    ArkUI_AttributeItem widthItem = {.value = colWidth, .size = 1};
    nodeApi->setAttribute(column, NODE_WIDTH, &widthItem);
    
    if (nodes_.find("progress") == nodes_.end()) {
        //创建progress组件
        ArkUI_NodeHandle progress = nodeApi->createNode(ARKUI_NODE_PROGRESS);
        nodes_["progress"] = progress;
    }
    ArkUI_NumberValue value[] = {{.f32 = 10.0f}};
    ArkUI_AttributeItem item = {value, sizeof(value) / sizeof(ArkUI_NumberValue)};
    value[0].i32 = ARKUI_PROGRESS_TYPE_CAPSULE;
    nodeApi->setAttribute(nodes_["progress"], NODE_PROGRESS_TYPE, &item);
    nodeApi->addChild(column, nodes_["progress"]);
    OH_ArkUI_NodeContent_AddNode(contentHandle_, column);
}

void SetImageAnimatorAndColumn(ArkUI_NativeNodeAPI_1 *nodeApi,
    ArkUI_NodeHandle column, ArkUI_NodeHandle imageAnimator)
{
    ArkUI_NumberValue colWidth[] = {{.f32 = 500}};
    ArkUI_AttributeItem widthItem = {.value = colWidth, .size = 1};
    nodeApi->setAttribute(column, NODE_WIDTH, &widthItem);
    ArkUI_NumberValue textHeight[] = {{.f32 = 500}};
    ArkUI_AttributeItem heightItem = {.value = textHeight, .size = 1};
    nodeApi->setAttribute(column, NODE_HEIGHT, &heightItem);
    ArkUI_NumberValue borderWidth[] = {{.f32 = 1}};
    ArkUI_AttributeItem borderWidthItem = {.value = borderWidth, .size = 1};
    nodeApi->setAttribute(column, NODE_BORDER_WIDTH, &borderWidthItem);
    nodeApi->setAttribute(imageAnimator, NODE_BORDER_WIDTH, &borderWidthItem);
    nodeApi->setAttribute(imageAnimator, NODE_WIDTH, &widthItem);
    nodeApi->setAttribute(imageAnimator, NODE_HEIGHT, &heightItem);
}

void NodeManager::CreateImageAnimatorFromString(int32_t width,
    int32_t height, int32_t top, int32_t left, int32_t duration)
{
    for (auto image : g_ImageAnimator) {
        OH_ArkUI_ImageAnimatorFrameInfo_Dispose(image.second);
    }
    g_imageNextId = 1;
    g_ImageAnimator.clear();
    if (!contentHandle_) {
        return;
    }
    ArkUI_NativeNodeAPI_1 *nodeApi = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
    if (nodeApi == nullptr) {
        return;
    }
    auto it = nodes_.find("imageAnimator_column");
    if (it != nodes_.end()) {
        OH_ArkUI_NodeContent_RemoveNode(contentHandle_, nodes_["imageAnimator_column"]);
        nodeApi->disposeNode(nodes_["imageAnimator_column"]);
        nodes_.erase(it);
    }
    ArkUI_NodeHandle column = nodeApi->createNode(ARKUI_NODE_COLUMN);
    nodes_["imageAnimator_column"] = column;
    ArkUI_NodeHandle imageAnimator = nodeApi->createNode(ARKUI_NODE_IMAGE_ANIMATOR);
    auto node = OH_ArkUI_ImageAnimatorFrameInfo_CreateFromString("resources/base/media/test.gif");
    if (node != nullptr) {
        int id = g_imageNextId++;
        g_ImageAnimator[id] = node;
    }
    ArkUI_AttributeItem frameInfo = {0};
    OH_ArkUI_ImageAnimatorFrameInfo_SetWidth(node, width);
    OH_ArkUI_ImageAnimatorFrameInfo_SetHeight(node, height);
    OH_ArkUI_ImageAnimatorFrameInfo_SetTop(node, top);
    OH_ArkUI_ImageAnimatorFrameInfo_SetLeft(node, left);
    OH_ArkUI_ImageAnimatorFrameInfo_SetDuration(node, duration);
    ArkUI_ImageAnimatorFrameInfo* array[] = { node };
    frameInfo.size = 1;
    frameInfo.object = array;
    
    ArkUI_NumberValue attr[] = {{.f32 = 10.0f}};
    ArkUI_AttributeItem item = {attr, sizeof(attr) / sizeof(ArkUI_NumberValue)};
    attr[0].i32 = 0;
    SetImageAnimatorAndColumn(nodeApi, column, imageAnimator);
    nodeApi->setAttribute(imageAnimator, NODE_IMAGE_ANIMATOR_FIXED_SIZE, &item);
    nodeApi->setAttribute(imageAnimator, NODE_IMAGE_ANIMATOR_IMAGES, &frameInfo);
    
    nodeApi->addChild(column, imageAnimator);
    OH_ArkUI_NodeContent_AddNode(contentHandle_, column);
}

ArkUI_DrawableDescriptor* NodeManager::CreateDescriptor()
{
    OH_PixelmapNativeHandle pixelMap = nullptr;
    ArkUI_DrawableDescriptor* descriptor = nullptr;

    uint8_t data[NUM_96];
    for (auto i = 0; i < NUM_96; i = i + NUM_4) {
        data[i] = uint8_t(NUM_0);
        data[i + NUM_1] = uint8_t(NUM_0);
        data[i + NUM_2] = uint8_t(NUM_0);
        data[i + NUM_3] = uint8_t(NUM_255);
    }

    uint8_t data1[NUM_96];
    for (auto j = 0; j < NUM_96; j++) {
        data1[j] = uint8_t(j);
    }
    OH_Pixelmap_InitializationOptions* options = nullptr;
    OH_PixelmapInitializationOptions_Create(&options);
    OH_PixelmapInitializationOptions_SetWidth(options, NUM_4);
    OH_PixelmapInitializationOptions_SetHeight(options, NUM_6);
    OH_PixelmapInitializationOptions_SetPixelFormat(options, NUM_4);
    OH_PixelmapInitializationOptions_SetAlphaType(options, NUM_0);
    OH_PixelmapNative_CreatePixelmap(data, NUM_96, options, &pixelMap);
    descriptor = OH_ArkUI_DrawableDescriptor_CreateFromPixelMap(pixelMap);
    return descriptor;
}

void NodeManager::CreateImageAnimatorFromDrawableDescriptor(int32_t width,
    int32_t height, int32_t top, int32_t left, int32_t duration)
{
    for (auto image : g_ImageAnimator) {
        OH_ArkUI_ImageAnimatorFrameInfo_Dispose(image.second);
    }
    g_imageNextId = 1;
    g_ImageAnimator.clear();
    if (!contentHandle_) {
        return;
    }
    ArkUI_NativeNodeAPI_1 *nodeApi = reinterpret_cast<ArkUI_NativeNodeAPI_1 *>(
        OH_ArkUI_QueryModuleInterfaceByName(ARKUI_NATIVE_NODE, "ArkUI_NativeNodeAPI_1"));
    if (nodeApi == nullptr) {
        return;
    }
    auto it = nodes_.find("imageAnimator_column");
    if (it != nodes_.end()) {
        OH_ArkUI_NodeContent_RemoveNode(contentHandle_, nodes_["imageAnimator_column"]);
        nodeApi->disposeNode(nodes_["imageAnimator_column"]);
        nodes_.erase(it);
    }
    ArkUI_NodeHandle column = nodeApi->createNode(ARKUI_NODE_COLUMN);
    nodes_["imageAnimator_column"] = column;
    auto descriptor = CreateDescriptor();
    auto node = OH_ArkUI_ImageAnimatorFrameInfo_CreateFromDrawableDescriptor(descriptor);
    if (node != nullptr) {
        int id = g_imageNextId++;
        g_ImageAnimator[id] = node;
    }
    ArkUI_AttributeItem frameInfo = {0};
    OH_ArkUI_ImageAnimatorFrameInfo_SetWidth(node, width);
    OH_ArkUI_ImageAnimatorFrameInfo_SetHeight(node, height);
    OH_ArkUI_ImageAnimatorFrameInfo_SetTop(node, top);
    OH_ArkUI_ImageAnimatorFrameInfo_SetLeft(node, left);
    OH_ArkUI_ImageAnimatorFrameInfo_SetDuration(node, duration);
    ArkUI_ImageAnimatorFrameInfo* array[] = { node };
    frameInfo.size = 1;
    frameInfo.object = array;
    ArkUI_NodeHandle imageAnimator = nodeApi->createNode(ARKUI_NODE_IMAGE_ANIMATOR);
    ArkUI_NumberValue attr[] = {{.f32 = 10.0f}};
    ArkUI_AttributeItem item = {attr, sizeof(attr) / sizeof(ArkUI_NumberValue)};
    attr[0].i32 = 0;
    SetImageAnimatorAndColumn(nodeApi, column, imageAnimator);
    nodeApi->setAttribute(imageAnimator, NODE_IMAGE_ANIMATOR_FIXED_SIZE, &item);
    nodeApi->setAttribute(imageAnimator, NODE_IMAGE_ANIMATOR_IMAGES, &frameInfo);
    nodeApi->addChild(column, imageAnimator);
    OH_ArkUI_NodeContent_AddNode(contentHandle_, column);
}
// namespace NativeNode::Manager
