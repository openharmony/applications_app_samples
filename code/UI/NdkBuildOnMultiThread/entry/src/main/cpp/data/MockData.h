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

#ifndef MYAPPLICATION_MOCKDATA_H
#define MYAPPLICATION_MOCKDATA_H
#include "card/CardCreator.h"

namespace NativeModule {

#define CARD_RED 0xffc94b51
#define CARD_BLUE 0xff5b97c7
#define CARD_GREEN 0xff70c06f
#define CARD_YELLOW 0xffcbbb4d
#define CARD_PURPLE 0xffab70b1

std::vector<AppItemInfo> g_appItems = {
    {"测试文本", "resource://media/startIcon.png", CARD_YELLOW},
    {"测试文本", "resource://media/startIcon.png", CARD_RED},
    {"测试文本", "resource://media/startIcon.png", CARD_PURPLE},
    {"测试文本", "resource://media/startIcon.png", CARD_BLUE},
    {"测试文本", "resource://media/startIcon.png", CARD_GREEN},
    {"测试文本", "resource://media/startIcon.png", CARD_RED},
    {"测试文本", "resource://media/startIcon.png", CARD_BLUE},
    {"测试文本", "resource://media/startIcon.png", CARD_PURPLE},
    {"测试文本", "resource://media/startIcon.png", CARD_BLUE},
    {"测试文本", "resource://media/startIcon.png", CARD_RED},
    {"测试文本", "resource://media/startIcon.png", CARD_BLUE},
    {"测试文本", "resource://media/startIcon.png", CARD_GREEN},
    {"测试文本", "resource://media/startIcon.png", CARD_YELLOW},
    {"测试文本", "resource://media/startIcon.png", CARD_RED},
    {"测试文本", "resource://media/startIcon.png", CARD_BLUE},
    {"测试文本", "resource://media/startIcon.png", CARD_YELLOW},
    {"测试文本", "resource://media/startIcon.png", CARD_PURPLE},
    {"测试文本", "resource://media/startIcon.png", CARD_GREEN},
    {"测试文本", "resource://media/startIcon.png", CARD_RED},
};

std::vector<ServiceItemInfo> g_serviceItems = {
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_YELLOW},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_RED},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_PURPLE},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_BLUE},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_GREEN},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_BLUE},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_YELLOW},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_BLUE},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_RED},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_YELLOW},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_GREEN},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_BLUE},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本 ", "resource://media/startIcon.png", CARD_YELLOW},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_BLUE},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_RED},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_PURPLE},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_YELLOW},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_GREEN},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_YELLOW},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_RED},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_PURPLE},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_BLUE},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_GREEN},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_BLUE},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_YELLOW},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_BLUE},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_RED},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_YELLOW},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_GREEN},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_BLUE},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_YELLOW},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_BLUE},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_RED},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_PURPLE},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_YELLOW},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_GREEN},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_YELLOW},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_RED},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_PURPLE},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_BLUE},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_GREEN},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_BLUE},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_YELLOW},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_BLUE},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_RED},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_YELLOW},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_GREEN},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_BLUE},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_YELLOW},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_BLUE},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_RED},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_PURPLE},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_YELLOW},
    {"测试文本", "resource://media/startIcon.png", "测试文本 测试文本", "resource://media/startIcon.png", CARD_GREEN},
};

std::vector<CardInfo> g_cardTypeInfos = {
    {"App", {}, { "测试文本1", g_appItems }},
    {"Service", { "测试文本2", g_serviceItems }, {}},
    {"App", {}, { "测试文本3", g_appItems }},
    {"App", {}, { "测试文本4", g_appItems }},
    {"Service", { "测试文本5", g_serviceItems }, {}},
    {"App", {}, { "测试文本6", g_appItems }},
};
}
#endif //MYAPPLICATION_MOCKDATA_H
